package com.spiral9.media
{

	import com.spiral9.data.media.VideoInfo;
	import com.spiral9.utils.MovieClipUtil;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeSignal;



	public class VideoPanelSimple extends MovieClip
	{
		public var CN : String = 		"VideoPanelSimple";

		public var signalOnStreamConnected : Signal;
		public var signalVideoStarted : Signal;
		public var signalVideoPaused : Signal;
		public var signalVideoEnded : Signal;
		public var signalFileNotFound : Signal;

		private var _nc : NetConnection;
		private var _ns : NetStream;
		private var _video : Video;
		private var _videoInfo : VideoInfo;
		private var _signalConnectNetStatus : NativeSignal;
		private var _signalStreamNetStatus : NativeSignal;
		private var _signalRemovedFromStage : NativeSignal;
		private var _isAutoStart : Boolean;

		public function VideoPanelSimple( videoInfo : VideoInfo = null, isAutoStart : Boolean = true )
		{
			trace ( CN + " instantiated." );

			_isAutoStart = isAutoStart;

			if( videoInfo != null )
			{
				trace( "\tvideoInfo.url:" + videoInfo.url + ":" );
				_videoInfo = videoInfo;
				initVideo();
			}

			signalOnStreamConnected = new Signal();
			signalVideoStarted = new Signal();
			signalVideoPaused = new Signal();
			signalVideoEnded = new Signal();
			signalFileNotFound = new Signal();

			_signalRemovedFromStage = new NativeSignal( this, Event.REMOVED_FROM_STAGE, Event );
			_signalRemovedFromStage.addOnce( dispose );
		}

		public function playVideo( videoInfo : VideoInfo = null ) : void
		{
			trace ( CN + ".playVideo." );

			switch( true )
			{
				case ( _videoInfo == null ) :
				case ( _videoInfo != videoInfo ) :
					_isAutoStart = true;
					_videoInfo = videoInfo;
					initVideo();
					break;
				case ( _videoInfo == videoInfo ) :
					resumeVideo();
				default :
					trace( "\tERROR : " + CN + ".playVideo has encountered an unexpected case." );
			}
		}

		/**
		* Sets up new NetConnection and connects.  Wait for status that connection is good or has failed
		* before setting up NetStream
		* @return	void
		*/
		private function initVideo() : void
		{
			trace ( CN + ".initVideo" );

			if( _nc != null ){ killVideo(); }

			_nc = new NetConnection();

			_signalConnectNetStatus = new NativeSignal( _nc, NetStatusEvent.NET_STATUS, NetStatusEvent );
			_signalConnectNetStatus.add( onNetConnectStatus );
			_nc.connect( null );
		}

		/**
		* Event listener for NetConnection NetStatusEvent.NET_STATUS
		* Connect the NetStream if there is a valid NetConnection connection
		* @param NetStatusEvent
		* @return	void
		*/
		private function onNetConnectStatus( ns : NetStatusEvent = null ) : void
		{
			trace( CN + ".onNetConnectStatus with code : " + ns.info.code );

			switch( ns.info.code )
			{
				case "NetConnection.Connect.Success" :
					connectStream();
					break;
			}
		}

		/**
		* Event listener for NetStream NetStatusEvent.NET_STATUS
		* @param NetStatusEvent
		* @return	void
		*/
		private function onNetStreamStatus( ns : NetStatusEvent = null ) : void
		{
			//trace( CN + ".onNetStreamStatus with code : " + ns.info.code );

			switch( ns.info.code )
			{
				case "NetStream.Play.StreamNotFound" :
					signalFileNotFound.dispatch();
					break;
				case "NetStream.Play.Start" :
					signalVideoStarted.dispatch();
					break;
				case "NetStream.Play.Stop" :
					_ns.pause();
					signalVideoEnded.dispatch();
					break;
				case "NetStream.Play.StreamNotFound" :
					signalFileNotFound.dispatch();
					break;
			}
		}

		/** When a valid NetConnection is made, create a new NetStream and start video playback.
		* This happens everytime we start play on a video as we remove and destroy the video when it is stopped
		* every time.
		* @return	void */
		private function connectStream() : void
		{
			trace( CN + ".connectStream" );

			var sniffer : Object = new Object();
			_ns = new NetStream( _nc );
			_signalStreamNetStatus = new NativeSignal( _ns, NetStatusEvent.NET_STATUS, NetStatusEvent );
			_signalStreamNetStatus.add( onNetStreamStatus );
			_ns.client = sniffer; //stream is the NetStream instance
			sniffer.onMetaData = getMeta;
			_video = new Video( _videoInfo.width, _videoInfo.height );
			_video.attachNetStream( _ns );
			_ns.soundTransform = new SoundTransform( 1, 0 );
			_ns.play( _videoInfo.url );
			addChild( _video );

			if( !_isAutoStart )
			{
				pauseVideo();
			}
		}

		public function resumeVideo() : void
		{
			trace( CN + ".resumeVideo" );
			_ns.resume();
		}

		public function pauseVideo() : void
		{
			trace( CN + ".pauseVideo" );

			_ns.pause();
			_isAutoStart = true;
		}

		private function getMeta( mdata : Object ) : void {}

		private function onCuePoint( cdata : Object ) : void {}

		private function killVideo() : void
		{
			trace( CN + ".killVideo" );

			if( _nc != null )
			{
				_signalConnectNetStatus.remove( onNetConnectStatus );
				_nc.close();
			}

			if( _ns != null )
			{
				_signalStreamNetStatus.remove( onNetStreamStatus );
				_ns.close();
			}

			if( _video != null )
			{
				_video.attachNetStream( null );
				MovieClipUtil.prune( this, _video );
			}

			_nc = null;
			_ns = null;
			_video = null;
		}

		public function dispose( e : Event = null ) : void
		{
			trace( CN + ".dispose" );

			killVideo();
			removeAllListeners();
			removeAllReferences();
		}

		private function removeAllListeners() : void
		{
			trace( CN + ".removeAllListeners" );

			_signalConnectNetStatus.removeAll();
			_signalStreamNetStatus.removeAll();
			signalOnStreamConnected.removeAll();
			signalVideoStarted.removeAll();
			signalVideoPaused.removeAll();
			signalVideoEnded.removeAll();
			signalFileNotFound.removeAll();
		}

		private function removeAllReferences() : void
		{
			trace( CN + ".removeAllReferences" );

			_nc = null;
			_ns = null;
			_video = null;
			_videoInfo = null;
			_signalConnectNetStatus = null;
			_signalStreamNetStatus = null;
			signalOnStreamConnected = null;
			signalVideoStarted = null;
			signalVideoPaused = null;
			signalVideoEnded = null;
			signalFileNotFound = null;
		}
	}
}
