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
package com.spiral9.data
{

	import com.spiral9.data.media.VisualMediaInfo;
	import com.spiral9.utils.DataUtils;

	public class SWFassetInfo extends VisualMediaInfo
	{
		public static const NO_CLASSNAME : String = "noClassname";
		//public var imageID : String;
		public var classname : String = "";

		public function SWFassetInfo( initObject : Object = null )
		{
			super();
			CN = "SWFassetInfo";
			//trace( CN + " instantiated." );
			if( initObject != null )
			{
				transferProps( initObject, this );
			}
		}

		override protected function transferProps( initObject : Object, targetObject : Object ) : void
		{
			super.transferProps( initObject, targetObject );
			DataUtils.transferProp( initObject, targetObject, "classname" );
			if( classname == "" ){ classname = NO_CLASSNAME; }
		}

		public function get analyticEventText() : String
		{
			return String( classname );
		}
	}
}
