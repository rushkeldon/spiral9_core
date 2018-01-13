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
package com.spiral9.data.commerce
{
	import com.spiral9.utils.StringService;
	public class DigitalGoodInventoryInfo
	{
		public static const CN : String = "DigitalGoodInventoryInfo";

		public var couponDigitalGoodInfos : Vector.<DigitalGoodInfo>;
		public var portDigitalGoodInfos : Vector.<DigitalGoodInfo>;

		public function DigitalGoodInventoryInfo( digitalGoodInfos : Array )
		{
			//trace( CN + " instantiated." );
			//trace( "\tdigitalGoodInfos.length:" + digitalGoodInfos.length + ":" );

			var o : Object;

			couponDigitalGoodInfos = new Vector.<DigitalGoodInfo>();
			portDigitalGoodInfos = new Vector.<DigitalGoodInfo>();

			for each( o in digitalGoodInfos )
			{
				switch( o.DigitalGoodInfo.type )
				{
					case DigitalGoodInfo.TYPE_COUPON :
						//trace( "coupon" );
						couponDigitalGoodInfos.push( new DigitalGoodInfo( o.DigitalGoodInfo ) );
						break;
					case DigitalGoodInfo.TYPE_PORT :
						//trace( "port" );
						portDigitalGoodInfos.push( new DigitalGoodInfo( o.DigitalGoodInfo ) );
						break;
				}
			}
		}

		public function toString() : String
		{
			var str : String = "\nDigitalGoodInventoryInfo :\n";

			str += "\t• couponDigitalGoodInfos :\t\t" + StringService.stringify( couponDigitalGoodInfos ) + ":\n";
			str += "\t• portDigitalGoodInfos :\t\t" + StringService.stringify( portDigitalGoodInfos ) + ":\n";

			return str;
		}
	}
}
