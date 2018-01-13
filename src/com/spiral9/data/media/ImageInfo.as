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

package com.spiral9.data.media
{
	import com.greensock.layout.ScaleMode;
	import com.spiral9.utils.DataUtils;

	/* INHERITED
		public var url : String;
		public var width : Number;
		public var height : Number;
		public var movieInfo : com.spiral9.data.media.MovieInfo;
		public var type : String;
	*/

	public class ImageInfo extends VisualMediaInfo
	{
		public var imageID : String;
		public var hasDropshadow : Boolean;

		public function ImageInfo( initObject : Object = null )
		{
			super();
			CN = "ImageInfo";
			//trace( CN + " instantiated." );
			_scaleMode = ScaleMode.PROPORTIONAL_INSIDE;
			if( initObject != null )
			{
				transferProps( initObject, this );
			}
		}

		override protected function transferProps( initObject : Object, targetObject : Object ) : void
		{
			super.transferProps( initObject, targetObject );
			DataUtils.transferProp( initObject, targetObject, "imageID" );
			DataUtils.transferProp( initObject, targetObject, "hasDropshadow" );
		}

		public function get analyticEventText() : String
		{
			return String( imageID );
		}
	}
}
