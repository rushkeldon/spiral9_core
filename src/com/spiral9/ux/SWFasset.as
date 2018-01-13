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
package com.spiral9.ux {
	import com.spiral9.data.FileInfo;
	import com.spiral9.data.SWFassetInfo;
	import com.spiral9.net.FileService;
	import com.spiral9.utils.MovieClipUtil;
	import com.greensock.TweenLite;

	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeSignal;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;

	public class SWFasset extends MovieClip
	{
		public static const CN : String = "SWFasset";

		public var imageAsset : DisplayObject;
		public var signalInitialized : Signal;

		private var _swfAssetInfo : SWFassetInfo;
		private var _isAssetLoaded : Boolean;
		private var _signalRemovedFromStage : NativeSignal;
		private var _signalExitFrame : NativeSignal;


		public function SWFasset( swfAssetInfo : SWFassetInfo = null )
		{
			trace( CN + " instantiated." );

			signalInitialized = new Signal( SWFasset );
			_swfAssetInfo = swfAssetInfo;
			_signalRemovedFromStage = new NativeSignal( this, Event.REMOVED_FROM_STAGE, Event );
			_signalRemovedFromStage.addOnce( dispose );
			alpha = 0;

			_signalExitFrame = new NativeSignal( this, Event.EXIT_FRAME, Event );
			_signalExitFrame.addOnce( loadAssets );
		}

		public function get info() : SWFassetInfo
		{
			return _swfAssetInfo;
		}

		public function loadAssets( e : Event = null ) : void
		{
			trace( CN + ".loadAssets" );

			var assetClass : Class = getClass();

			if( assetClass is Class )
			{
				createAsset( assetClass );
			}
			else
			{
				loadFile();
			}
		}

		private function getClass() : Class
		{
			trace( CN + ".getClass" );

			var imageClassFromName : Class;

			try
			{
				imageClassFromName = FileService.getClass( info.classname );
			}
			catch( e : Error )
			{
				trace( "\tERROR :" + e );
			}

			return imageClassFromName;
		}

		private function loadFile() : void
		{
			trace( CN + ".loadFile" );

			var fileInfo : FileInfo;

			fileInfo = new FileInfo( { url : info.url, type : FileInfo.TYPE_SWF_INTERNAL, callBack : onAssetsLoaded } );
			FileService.load( fileInfo );
		}

		private function onAssetsLoaded( fileInfo : FileInfo ) : void
		{
			trace( CN + ".onAssetsLoaded" );
			trace( "\tfileInfo.status:" + fileInfo.status + ":" );

			var assetClass : Class = getClass();
			_isAssetLoaded = true;

			switch( true )
			{
				case ( info == null || info.classname == SWFassetInfo.NO_CLASSNAME ) :
					trace( "\tERROR : missing info.classname - aborting." );
					if( info != null ){ trace( "\tinfo.classname:" + info.classname + ":" ); }
					return;
					break;
				case ( assetClass is Class ) :
					createAsset( assetClass );
					break;
				default :
					trace( "\tERROR : an unhandled case was encountered by " + CN + ".onAssetsLoaded" );
			}
		}

		private function createAsset( assetClass : Class ) : void
		{
			trace( CN + ".createAsset" );

			try
			{
				imageAsset = new assetClass() as DisplayObject;
			}
			catch( e : Error )
			{
				trace( "\tERROR :" + e );
				trace( "\tcreating empty MovieClip instead of the non-existant classname." );
				imageAsset = new MovieClip() as DisplayObject;
			}
			addChild( imageAsset );
			initImageAsset();
		}

		private function initImageAsset( e : Event = null ) : void
		{
			trace( CN + ".initImageAsset" );

			signalInitialized.dispatch( this );
			intro();
		}

		private function intro() : void
		{
			trace( CN + ".intro" );

			TweenLite.to( this, .5, { autoAlpha : 1, onComplete : null } );
		}

		private function dispose( e : Event = null ) : void
		{
			// listeners
			_signalRemovedFromStage.removeAll();
			signalInitialized.removeAll();

			// children
			MovieClipUtil.prune( this, imageAsset );

			// references
			imageAsset = null;
			signalInitialized = null;
			_swfAssetInfo = null;
			_signalRemovedFromStage = null;
			_signalExitFrame = null;
		}
	}
}
