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

	import com.spiral9.data.FileInfo;
	import com.spiral9.data.media.ImageInfo;
	import com.spiral9.utils.BitmapUtil;
	import flash.display.Bitmap;
	import flash.events.Event;


	public class Image extends BaseUI
	{
		private var _fileInfo : FileInfo;
		private var _imageInfo : ImageInfo;

		public function Image( imageInfo : ImageInfo = null )
		{
			super();
			CN = "Image";

			if( imageInfo != null )
			{
				loadFromInfo( imageInfo );
			}
		}

		public function loadFromInfo( imageInfo : ImageInfo ) : void
		{
			trace( CN + ".loadFromInfo" );

			if( imageInfo != null )
			{
				_imageInfo = imageInfo;
				_fileInfo = new FileInfo();
				_fileInfo.id = _imageInfo.type;
				_fileInfo.type = FileInfo.TYPE_IMAGE;
				_fileInfo.url = _imageInfo.url;
				_fileInfo.signalNetworkingFinished.addOnce( bitmapLoaded );
			}
			else
			{
				trace( "\tERROR : the imageInfo is null." );
			}
		}

		override public function get width() : Number
		{
			return _imageInfo.width;
		}

		override public function get height() : Number
		{
			return _imageInfo.height;
		}

		private function bitmapLoaded( fileInfo : FileInfo ) : void
		{
			trace( CN + ".bitmapLoaded" );

			if( fileInfo.status == FileInfo.STATUS_FAILED )
			{
				trace( "\tERROR : the bitmap did not load successfully." );
				trace( "\tfileInfo.url:" + fileInfo.url + ":" );
				trace( "\tfileInfo.error:\n" + fileInfo.error );
			}

			if( fileInfo.bitmap is Bitmap )
			{
				BitmapUtil.drawBitmap( this, fileInfo.bitmap );
			}
			signalInitialized.dispatch( this );
		}

		override protected function init( e : Event = null ) : void
		{
			// do nothing
		}
	}
}
