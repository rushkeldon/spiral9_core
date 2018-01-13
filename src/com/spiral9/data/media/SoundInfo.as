package com.spiral9.data.media
{
	import com.spiral9.utils.StringUtils;
	import com.spiral9.data.FileInfo;
	import com.spiral9.net.FileService;
	import com.spiral9.net.URLservice;
	import com.spiral9.utils.DataUtils;

	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeSignal;

	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;


	public class SoundInfo
	{
		public var CN : String = "SoundInfo";

		public var loops : int = 0;
		public var soundClass : Class;
		public var soundTransform : SoundTransform;
		public var startTime : Number = 0;
		public var soundChannel : SoundChannel;
		public var isRecyclable : Boolean = true;
		public var signalInitialized : Signal;
		public var signalSoundStarted : NativeSignal;
		public var signalSoundComplete : NativeSignal;
		public var isPlaying : Boolean = false;
		public var isAutoPlay : Boolean = false;

		private var _fileInfo : FileInfo;
		private var _sound : Sound;

		public function SoundInfo( initObject : * = null )
		{
			switch( true )
			{
				case ( initObject is Class ) :
					soundClass = initObject as Class;
					break;
				case ( initObject != null ) :
					transferProps( initObject, this );
					break;
				default :
					// do nothing
			}
		}

		private function transferProps( initObject : Object, targetObject : Object ) : void
		{
			DataUtils.transferProp( initObject, targetObject, "soundClass" );
			DataUtils.transferProp( initObject, targetObject, "sound" );
			DataUtils.transferProp( initObject, targetObject, "loops" );
			DataUtils.transferProp( initObject, targetObject, "soundTransform" );
			DataUtils.transferProp( initObject, targetObject, "url" );
			DataUtils.transferProp( initObject, targetObject, "isAutoPlay" );
		}
		
		public function get sound() : Sound
		{
			var snd : Sound;
			
			switch( true )
			{
				case ( _sound is Sound ) :
					snd = _sound;
					break;
				case ( _fileInfo != null ) :
					snd = _fileInfo.sound;
					break;
			}
			
			return snd;
		}
		
		public function set sound( newSound : Sound ) : void
		{
			_sound = newSound;
		}

		public function set url( newURL : String ) : void
		{
			if( _fileInfo == null )
			{
				_fileInfo = new FileInfo(
				{
					url : newURL,
					type : FileInfo.TYPE_SOUND
				} );
			}

			if( _fileInfo.url != URLservice.BAD_URL )
			{
				FileService.load( _fileInfo );
				signalLoadingComplete.add( soundLoaded );
			}
		}
		
		public function get url() : String
		{
			if( _fileInfo == null ){ return URLservice.BAD_URL; }
			return _fileInfo.url;
		}

		public function get signalAsyncErrorEncountered() : Signal
		{
			if( _fileInfo == null ){ return null; }
			return _fileInfo.signalAsyncErrorEncountered;
		}

		public function get signalNetworkingFinished() : Signal
		{
			if( _fileInfo == null ){ return null; }
			return _fileInfo.signalNetworkingFinished;
		}

		public function get signalLoadingComplete() : Signal
		{
			if( _fileInfo == null ){ return null; }
			return _fileInfo.signalLoadingComplete;
		}

		public function get signalHTTPstatusReceived() : Signal
		{
			if( _fileInfo == null ){ return null; }
			return _fileInfo.signalHTTPstatusReceived;
		}

		public function get signalUncaughtErrorEncountered() : Signal
		{
			if( _fileInfo == null ){ return null; }
			return _fileInfo.signalUncaughtErrorEncountered;
		}

		public function get signalIOErrorEncountered() : Signal
		{
			if( _fileInfo == null ){ return null; }
			return _fileInfo.signalIOErrorEncountered;
		}

		public function get signalStreamOpened() : Signal
		{
			if( _fileInfo == null ){ return null; }
			return _fileInfo.signalStreamOpened;
		}

		public function get signalProgress() : Signal
		{
			if( _fileInfo == null ){ return null; }
			return _fileInfo.signalProgress;
		}

		public function get signalSecurityErrorEncountered() : Signal
		{
			if( _fileInfo == null ){ return null; }
			return _fileInfo.signalSecurityErrorEncountered;
		}

		public function get signalLoaderUncaughtErrorEncountered() : Signal
		{
			if( _fileInfo == null ){ return null; }
			return _fileInfo.signalLoaderUncaughtErrorEncountered;
		}

		public function get signalUnloaded() : Signal
		{
			if( _fileInfo == null ){ return null; }
			return _fileInfo.signalUnloaded;
		}

		private function soundLoaded( fileInfo : FileInfo ) : void
		{
			trace( CN + ".soundLoaded" );

			if( fileInfo.status == FileInfo.STATUS_FAILED )
			{
				trace( "\tERROR : the sound file did not load successfully." );
				trace( "\tfileInfo.url:" + fileInfo.url + ":" );
				trace( "\tfileInfo.error:\n" + fileInfo.error );
			}

			if( isAutoPlay && sound != null )
			{
				sound.play( startTime, loops, soundTransform );
			}
		}

		public function toString() : String
		{
			var o : Object = {};
			transferProps( this, o );
			return StringUtils.objectToPrettyJSON( o );
		}
	}
}
