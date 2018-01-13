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
	import com.spiral9.data.IAnalyticsInfo;
	import com.spiral9.data.StatusChangeInfo;
	import com.spiral9.data.actionengine.ReportInfo;
	import com.spiral9.utils.Conversion;
	import com.spiral9.utils.StringService;
	import flash.net.URLVariables;

	public class CouponInfo extends ReportInfo implements IAnalyticsInfo
	{
		public static const CN : String = 							"CouponInfo";

		public static const CLASSNAME_ICON_COINS : String =			"IconCoins";
		public static const CLASSNAME_ICON_CASH : String =			"IconCash";
		public static const CLASSNAME_ICON_TICKETS : String =		"IconTickets";
		public static const CLASSNAME_ICON_XP : String =				"IconXP";
		public static const CLASSNAME_ICON_ENERGY : String =			"IconEnergy";
		public static const CLASSNAME_USER_LEVEL_ICON : String =		"IconUserLevel";

		public var couponID : String;
		public var url : String;
		public var className : String;
		public var statusChangeInfos : Vector.<StatusChangeInfo>;
		public var label : String;

		// runtime
		public var panelType : String;

		public function CouponInfo( initObject : Object = null )
		{
			//trace( CN + ".CouponInfo" );

			if( initObject != null )
			{
				couponID = initObject.couponID;
				url = initObject.url;
				className = initObject.className;
				statusChangeInfos = new Vector.<StatusChangeInfo>();
				label = Conversion.assignProp( initObject, "label", "" );
				var i : int;
				for( i=0; i<initObject.statusChangeInfos.length; i++ )
				{
					statusChangeInfos.push( new StatusChangeInfo( initObject.statusChangeInfos[ i ] ) );
				}
			}
		}

		public function toString( traceLevel : int = 0 ) : String
		{
			var indent : String = StringService.getIndent( traceLevel );

			var str : String = "\n" + indent + "CouponInfo :\n";
			str += indent + "\t• className :\t\t" + String( className ) + "\n";
			str += indent + "\t• couponID :\t\t" + String( couponID ) + "\n";
			str += indent + "\t• label :\t\t" + String( label ) + "\n";
			str += indent + "\t• statusChangeInfos :\t\t" + StringService.stringify( statusChangeInfos, traceLevel + 1 ) + ":\n";
			str += indent + "\t• url :\t\t" + String( url );
			return( str );
		}

		override public function toURLvars() : URLVariables
		{
			//trace( CN + ".toObject" );

			super.toURLvars();
			urlVars.couponID = couponID;
			return urlVars;
		}

		public function get analyticEventText() : String
		{
			return String( label ) + ' (' + String( couponID ) + ')';
		}
	}
}
