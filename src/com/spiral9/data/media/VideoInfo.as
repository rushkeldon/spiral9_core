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

	import com.spiral9.data.IAnalyticsInfo;
	import com.spiral9.utils.DataUtils;

	public class VideoInfo extends VisualMediaInfo implements IAnalyticsInfo
	{
		public static const WIDTH_DEFAULT : int =  640;
		public static const HEIGHT_DEFAULT : int = 480;

		public var videoID : String;
		public var timePoints : Array;

		// runtime
		public var statusChangeActions : Array;
		public var isForTickle : Boolean;

		public function VideoInfo( initObject : Object = null )
		{
			CN = "VideoInfo";
			//trace( CN + " instantiated." );
			if( initObject != null )
			{
				transferProps( initObject, this );
			}
		}

		override protected function transferProps( initObject : Object, targetObject : Object ) : void
		{
			super.transferProps( initObject, targetObject );
			DataUtils.transferProp( initObject, targetObject, "videoID" );
			DataUtils.transferProp( initObject, targetObject, "timePoints" );
			DataUtils.transferProp( initObject, targetObject, "statusChangeActions" );
			DataUtils.transferProp( initObject, targetObject, "isForTickle" );
		}

		public function get analyticEventText() : String
		{
			return String( videoID );
		}
	}
}
