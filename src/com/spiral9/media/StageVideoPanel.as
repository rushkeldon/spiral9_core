/*******************************************************************************
 * (C) 2008 - 2012 SPIRAL9, INC. ( SPIRAL9 )
 * All Rights Reserved.
 *
 * NOTICE:  SPIRAL9 permits you to use, modify, and distribute this file in
 * accordance with the terms of the SPIRAL9 license agreement accompanying it.
 * If you have received this file without a license agreement or from a source
 * other than SPIRAL9 then your use, modification, or distribution of it requires
 * the prior written permission of SPIRAL9, INC.
 *******************************************************************************/
package com.spiral9.media
{
	import com.spiral9.data.media.VideoInfo;
	import com.spiral9.utils.MovieClipUtil;
	import com.spiral9.utils.StageReference;
	import com.spiral9.utils.StringUtils;
	import com.spiral9.ux.BaseUI;

	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeSignal;

	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.StageVideoAvailabilityEvent;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.media.StageVideo;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	public class StageVideoPanel extends BaseUI
	{
		private static const NS_CODE_BUFFER_EMPTY : String = "NetStream.Buffer.Empty";
		private static const NS_CODE_BUFFER_FLUSHED : String = "NetStream.Buffer.Flush";
		private static const NS_CODE_BUFFER_FULL : String = "NetStream.Buffer.Full";
		private static const NS_CODE_INSUFFICIENT_BANDWIDTH : String = "NetStream.Play.InsufficientBW";
		private static const NS_CODE_PAUSED : String = "NetStream.Pause.Notify";
		private static const NS_CODE_RESUMED : String = "NetStream.Unpause.Notify";
		private static const NS_CODE_STARTED : String = "NetStream.Play.Start";
		private static const NS_CODE_STOPPED : String = "NetStream.Play.Stop";
		private static const NS_CODE_STREAM_NOT_FOUND : String = "NetStream.Play.StreamNotFound";

		public var signalBufferEmpty : Signal;
		public var signalBufferFlushed : Signal;
		public var signalBufferFull : Signal;
		public var signalFileNotFound : Signal;
		public var signalInsufficientBandwidthForVideo : Signal;
		public var signalLogMsg : Signal;
		public var signalMetaDataReceived : Signal;
		public var signalStreamConnected : Signal;
		public var signalVideoEnded : Signal;
		public var signalVideoPaused : Signal;
		public var signalVideoResumed : Signal;
		public var signalVideoStarted : Signal;

		protected var _nc : NetConnection;
		protected var _ns : NetStream;
		protected var _video : Video;
		protected var _stageVideo : StageVideo;
		protected var _videoInfo : VideoInfo;
		protected var _signalStageVideoStatusChange : NativeSignal;
		protected var _signalConnectNetStatus : NativeSignal;
		protected var _signalStreamNetStatus : NativeSignal;
		protected var _isAutoStart : Boolean;
		protected var _isVideoPlaying : Boolean;

		protected var _videoRect : Rectangle = new Rectangle( 0, 0, 0, 0 );
		protected var _debugMsg : String = "";
		protected var _isDebug : Boolean;
		protected var _authoredWidth : Number = 0;
		protected var _authoredHeight : Number = 0;

		public function StageVideoPanel( videoInfo : VideoInfo, isAutoStart : Boolean = true, isDebug : Boolean = false )
		{
			super();
			if( videoInfo == null ){ trace( "ERROR : videoInfo == null" ); return; }
			CN = "StageVideoPanel";

			isRecyclable = false;
			_isDebug = isDebug;
			_videoInfo = videoInfo;
			_isAutoStart = isAutoStart;
			_isVideoPlaying = false;

			signalBufferEmpty = new Signal();
			signalBufferFlushed = new Signal();
			signalBufferFull = new Signal();
			signalFileNotFound = new Signal( NetStatusEvent );
			signalInsufficientBandwidthForVideo = new Signal();
			signalLogMsg = new Signal( String, Boolean );
			signalStreamConnected = new Signal();
			signalVideoEnded = new Signal();
			signalVideoPaused = new Signal();
			signalVideoResumed = new Signal();
			signalVideoStarted = new Signal();
			signalMetaDataReceived = new Signal( Object );
		}

		override protected function init( e : Event = null ) : void
		{
			super.init();

			if( _nc != null ){ killVideo(); }

			_nc = new NetConnection() ;
			_signalConnectNetStatus = new NativeSignal( _nc, NetStatusEvent.NET_STATUS, NetStatusEvent );
			_signalConnectNetStatus.add( onNetConnectStatus );
			_nc.connect( null );
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

		public function toggleVideoDisplayMode() : void
		{
			switch( true )
			{
				case ( _stageVideo.viewPort.width > StageReference.stage.stageWidth ) :

					break;

			}
		}

		private function onCuePoint( cdata : Object ) : void
		{
			trace( CN + ".onCuePoint" );
		}

		private function onMetaData( mdata : Object ) : void
		{
			trace( CN + ".onMetaData" );
			trace( StringUtils.objectToPrettyJSON( mdata ) );
			/*
			{
				"duration": 88.09629821777344,
				"height": 768,
				"width": 1024
			}
			*/
			signalMetaDataReceived.dispatch( mdata );
			_authoredWidth = mdata.width;
			_authoredHeight = mdata.height;
		}

		private function onImageData( imgData : Object ) : void
		{
			trace( CN + ".onImageData" );
			trace( StringUtils.objectToPrettyJSON( imgData ) );

		}

		private function onPlayStatus( playStatus : * ) : void
		{
			trace( CN + ".onPlayStatus" );
			trace( StringUtils.objectToPrettyJSON( playStatus ) );
		}

		private function onTextData( txtData : * ) : void
		{
			trace( CN + ".onTextData" );
			trace( StringUtils.objectToPrettyJSON( txtData ) );
		}

		private function onXMPData( xmpData : * ) : void
		{
			trace( CN + ".onXMPData" );
			trace( StringUtils.objectToPrettyJSON( xmpData ) );

		}

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

			if( _stageVideo != null )
			{
				_stageVideo.attachNetStream( null );
			}

			_nc = null;
			_ns = null;
			_video = null;
			_stageVideo = null;
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

		/** When a valid NetConnection is made, create a new NetStream and start video playback.
		* This happens everytime we start play on a video as we remove and destroy the video when it is stopped
		* every time.
		* @return	void */
		private function connectStream() : void
		{
			trace( CN + ".connectStream" );

			_ns = new NetStream( _nc );
			_signalStreamNetStatus = new NativeSignal( _ns, NetStatusEvent.NET_STATUS, NetStatusEvent );
			_signalStreamNetStatus.add( onNetStreamStatus );
			_ns.client = {
				onMetaData : onMetaData,
				onCuePoint : onCuePoint,
				onImageData : onImageData,
				onPlayStatus : onPlayStatus,
				onTextData : onTextData,
				onXMPData : onXMPData
			};
			_ns.soundTransform = new SoundTransform( 1, 0 );
			_ns.play( _videoInfo.url );
			if( !_isAutoStart )
			{
				pauseVideo();
			}
			startStageVideoCheck();
		}

		private function startStageVideoCheck() : void
		{
			trace( CN + ".startStageVideoCheck" );

			// StageVideoAvailabilityEvent fires immediately and as StageVideo availability changes
			var theStage : Stage = stage;
			if( theStage == null ){ theStage = StageReference.stage; }
			_signalStageVideoStatusChange = new NativeSignal( theStage, StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, StageVideoAvailabilityEvent );
			_signalStageVideoStatusChange.add( stageVideoStatusChange );
		}

		private function displayStageVideo() : void
		{
			trace( CN + ".displayStageVideo" );

			switch( true )
			{
				case ( stage == null ) :
					trace( "\tERROR : stage == null" );
					return;
				case ( stage.stageVideos == null ) :
					trace( "\tERROR : stage.stageVideos == null" );
					return;
					break;
				case ( _videoInfo == null ) :
					trace( "\tERROR : _videoInfo == null" );
					return;
			}
			trace( "\tstage.stageVideos.length:" + stage.stageVideos.length + ":" );

			if( stage == null || stage.stageVideos == null )
			{
				trace( "\tERROR : stage or stage.stageVideos is null." );
				return;
			}

			if( _stageVideo == null )
			{
				if( stage.stageVideos.length >= 1 )
				{
					// set _stageVideo to reference the first available StageVideo object ( there can be up to 8 on desktops )
					_stageVideo = stage.stageVideos[ 0 ];
					_stageVideo.viewPort = new Rectangle( 0, 0, _videoInfo.width, _videoInfo.height );
				}
			}

			if( _stageVideo != null )
			{
				trace( "\t_stageVideo.viewPort:" + _stageVideo.viewPort + ":" );
				if( _video != null && _video.parent != null ){ MovieClipUtil.prune( this, _video ); }
				_stageVideo.attachNetStream( _ns ) ;
			}
			else
			{
				trace( "\tERROR : there is no StageVideo available. stage.stageVideos.length:" + stage.stageVideos.length + ":" );
			}
		}

		private function displayVideo() : void
		{
			trace( CN + ".displayVideo" );

			if( _video == null )
			{
				_video = new Video( _videoInfo.width, _videoInfo.height );
			}
			_video.attachNetStream( _ns ) ;
			MovieClipUtil.graft( this, _video );
		}

		public function log( msg : String, shouldReplace : Boolean = false ) : void
		{
			trace( msg );

			if( shouldReplace )
			{
				_debugMsg = msg + "\n";
			}
			else
			{
				_debugMsg += msg + "\n";
			}

			if( _isDebug )
			{
				signalLogMsg.dispatch( _debugMsg, false );
			}
		}

		private function stageVideoStatusChange( e : StageVideoAvailabilityEvent ) : void
		{
			log( CN + ".stageVideoAvailabilityChanged : e.availability:" + e.availability + ":", false );

			if( e.availability == "available" )
			{
				displayStageVideo();
			}
			else
			{
				displayVideo();
			}
		}

		private function onNetStreamStatus( ns : NetStatusEvent = null ) : void
		{
			trace( CN + ".onNetStreamStatus with code : " + ns.info.code );

			switch( ns.info.code )
			{
				case NS_CODE_STREAM_NOT_FOUND :
					signalFileNotFound.dispatch( ns );
					break;
				case NS_CODE_STARTED :
					_isVideoPlaying = true;
					signalVideoStarted.dispatch();
					break;
				case NS_CODE_STOPPED :
					_isVideoPlaying = false;
					_ns.pause();
					signalVideoEnded.dispatch();
					break;
				case NS_CODE_PAUSED :
					_isVideoPlaying = false;
					signalVideoPaused.dispatch();
					break;
				case NS_CODE_RESUMED :
					_isVideoPlaying = true;
					signalVideoResumed.dispatch();
					break;
				case NS_CODE_INSUFFICIENT_BANDWIDTH :
					trace( "\tNOTICE : The client does not have sufficient bandwidth to play the video at its intended frame rate." );
					signalInsufficientBandwidthForVideo.dispatch();
					break;
				case NS_CODE_BUFFER_FLUSHED :
					trace( "\tNOTICE : Playback has ended and the buffer is now empty." );
					signalBufferFlushed.dispatch();
					break;
				case NS_CODE_BUFFER_EMPTY :
					signalBufferEmpty.dispatch();
					break;
				case NS_CODE_BUFFER_FULL :
					signalBufferFull.dispatch();
					break;
			}
		}

		private function getVideoRect( width : uint, height : uint ) : Rectangle
		{
			trace( CN + ".getVideoRect" );

			var videoWidth : uint = width;
			var videoHeight : uint = height;
			var scaling : Number = Math.min ( stage.stageWidth / videoWidth, stage.stageHeight / videoHeight );

			videoWidth *= scaling, videoHeight *= scaling;

			var posX : uint = stage.stageWidth - videoWidth >> 1;
			var posY : uint = stage.stageHeight - videoHeight >> 1;

			_videoRect.x = posX;
			_videoRect.y = posY;
			_videoRect.width = videoWidth;
			_videoRect.height = videoHeight;

			return _videoRect;
		}

		override public function dispose( e : Event = null ) : void
		{
			super.dispose();
			trace( CN + ".dispose" );

			killVideo();
			removeAllListeners();
			removeAllReferences();
		}

		private function removeAllListeners() : void
		{
			trace( CN + ".removeAllListeners" );

			if( _signalConnectNetStatus != null ){ _signalConnectNetStatus.removeAll(); }
			if( _signalStreamNetStatus != null ){ _signalStreamNetStatus.removeAll(); }
			if( signalStreamConnected != null ){ signalStreamConnected.removeAll(); }
			if( signalVideoStarted != null ){ signalVideoStarted.removeAll(); }
			if( signalVideoPaused != null ){ signalVideoPaused.removeAll(); }
			if( signalVideoEnded != null ){ signalVideoEnded.removeAll(); }
			if( signalFileNotFound != null ){ signalFileNotFound.removeAll(); }
		}

		private function removeAllReferences() : void
		{
			trace( CN + ".removeAllReferences" );

			_nc = null;
			_ns = null;
			_signalConnectNetStatus = null;
			_signalStreamNetStatus = null;
			_stageVideo = null;
			_video = null;
			_videoInfo = null;
			_videoRect = null;
			signalFileNotFound = null;
			signalStreamConnected = null;
			signalVideoEnded = null;
			signalVideoPaused = null;
			signalVideoStarted = null;
		}

		public function get isVideoPlaying() : Boolean
		{
			return _isVideoPlaying;
		}
	}
}
