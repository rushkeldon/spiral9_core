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
package com.spiral9.ux
{

	import com.spiral9.data.SmartLinkInfo;
	import com.spiral9.data.media.ImageInfo;
	import com.spiral9.data.media.SoundInfo;
	import com.spiral9.utils.DataUtils;
	import flash.display.DisplayObject;
	import org.osflash.signals.Signal;



	public class AssetPack
	{
		public var CN : String = "AssetPack";

		public var images : Vector.<Image>;
		public var smartLinks : Vector.<SmartLink>;
		public var soundInfos : Vector.<SoundInfo>;

		public var signalImagesLoaded : Signal;
		public var signalSmartLinksLoaded : Signal;
		public var signalSoundsLoaded : Signal;
		public var signalAllAssetsLoaded : Signal;

		public var areImagesLoaded : Boolean;
		public var areSmartLinksLoaded : Boolean;
		public var areSoundsLoaded : Boolean;

		protected var _initObject : Object;
		protected var _imageLoadCount : int = 0;
		protected var _smartLinkLoadCount : int = 0;
		protected var _soundLoadCount : int = 0;

		public function AssetPack( initObject : Object = null )
		{
			_initObject = initObject;

			signalAllAssetsLoaded = new Signal( AssetPack );

			if( _initObject != null )
			{
				if( DataUtils.hasProp( initObject, "imageInfos" ) )
				{
					signalImagesLoaded = new Signal( Vector.<Image> );
					loadImages( initObject.imageInfos as Array );
				}

				if( DataUtils.hasProp( initObject, "smartLinkInfos" ) )
				{
					signalSmartLinksLoaded = new Signal( Vector.<SmartLink> );
					loadSmartLinks( initObject.smartLinkInfos as Array );
				}

				if( DataUtils.hasProp( initObject, "soundInfos" ) )
				{
					signalSoundsLoaded = new Signal( Vector.<SoundInfo> );
					loadSounds( initObject.soundInfos as Array );
				}
			}
		}

		public function get isAllLoaded() : Boolean
		{
			return( areImagesLoaded && areSmartLinksLoaded && areSoundsLoaded );
		}

		public function loadImages( initArray : Array ) : void
		{
			var image : Image;
			var imageInfo : ImageInfo;
			images = new Vector.<Image>();
			var initObject : Object;

			for each( initObject in initArray )
			{
				_imageLoadCount++;
				imageInfo = new ImageInfo( initObject );
				image = new Image( imageInfo );
				image.signalInitialized.addOnce( imageInitialized );
				images.push( image );
			}
		}

		public function loadSmartLinks( initArray : Array ) : void
		{
			var smartLink : SmartLink;
			var smartLinkInfo : SmartLinkInfo;
			smartLinks = new Vector.<SmartLink>();
			var initObject : Object;

			for each( initObject in initArray )
			{
				_smartLinkLoadCount++;
				smartLinkInfo = new SmartLinkInfo( initObject );
				smartLink = new SmartLink( smartLinkInfo );
				smartLink.signalInitialized.addOnce( smartLinkInitialized );
				smartLinks.push( smartLink );
			}
		}

		public function loadSounds( initArray : Array ) : void
		{
			var soundInfo : SoundInfo;
			soundInfos = new Vector.<SoundInfo>();
			var initObject : Object;

			for each( initObject in initArray )
			{
				_soundLoadCount++;
				soundInfo = new SoundInfo( initObject );
				soundInfo.signalInitialized.addOnce( soundInitialized );
				soundInfos.push( soundInfo );
				// FIXME : got rid of load - fix me
				//soundInfo.load();
			}
		}

		private function soundInitialized( soundInfo : SoundInfo ) : void
		{
			trace( CN + ".soundInitialized" );

			_soundLoadCount--;
			if( _soundLoadCount <= 0 )
			{
				areSoundsLoaded = true;
				signalSoundsLoaded.dispatch( soundInfos );
			}
			checkAllLoaded();
		}

		private function smartLinkInitialized( smartLink : DisplayObject = null ) : void
		{
			trace( CN + ".smartLinkInitialized" );

			_smartLinkLoadCount--;
			if( _smartLinkLoadCount <= 0 )
			{
				areSmartLinksLoaded = true;
				signalSmartLinksLoaded.dispatch( smartLinks );
			}
			checkAllLoaded();
		}

		private function imageInitialized( image : DisplayObject = null ) : void
		{
			trace( CN + ".imageInitialized" );

			_imageLoadCount--;
			if( _imageLoadCount <= 0 )
			{
				areImagesLoaded = true;
				signalImagesLoaded.dispatch( images );
			}
			checkAllLoaded();
		}

		private function checkAllLoaded() : void
		{
			if( isAllLoaded )
			{
				signalAllAssetsLoaded.dispatch( this );
			}
		}
	}
}
