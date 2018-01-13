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
	import com.spiral9.data.actionengine.Reports;
	//import com.spiral9.data.portscape.PortInfo;
	import com.spiral9.utils.Conversion;
	import com.spiral9.utils.StringService;

	import flash.net.URLVariables;


	public class DigitalGoodInfo extends ReportInfo implements IAnalyticsInfo
	{
		public static const TYPE_PORT		: String = 		"port";
		public static const TYPE_COUPON		: String = 		"coupon";
		public static const MSG_REQUIRED	: String = 		"Unlock at Level ";

		public var digitalGoodID			: String;
		public var type						: String;
		public var label					: String;
		public var requirementMsg			: String;
		public var statusChangeInfos		: Vector.<StatusChangeInfo>;
		public var levelRequired			: Number;

		public var couponInfo				: CouponInfo;
		//public var portInfo					: PortInfo;

		public function DigitalGoodInfo( initObject : Object = null )
		{
			var i : int;

			super();

			CN = "DigitalGoodInfo";
			//trace( CN + " instantiated." );

			reportType = Reports.REPORT_PURCHASE_REQUESTED;
			infoClass = DigitalGoodInfo;

			if( initObject != null )
			{
				digitalGoodID = Conversion.assignProp( initObject, "digitalGoodID", null );
				type = Conversion.assignProp( initObject, "type", null );
				label = Conversion.assignProp( initObject, "label", null );
				levelRequired = Number( Conversion.assignProp( initObject, "levelRequired", -1 ) );
				statusChangeInfos = new Vector.<StatusChangeInfo>();

				if( initObject.hasOwnProperty( "statusChangeInfos" ) )
				{
					for( i=0; i<initObject.statusChangeInfos.length; i++ )
					{
						statusChangeInfos.push( new StatusChangeInfo( initObject.statusChangeInfos[ i ] ) );
					}
				}

				switch( type )
				{
					case TYPE_COUPON :
						couponInfo = new CouponInfo( initObject.CouponInfo );
						break;
					case TYPE_PORT :
						//portInfo = new PortInfo( initObject.PortInfo );
						break;
				}
			}
		}

		public function toString( traceLevel : int = 0 ) : String
		{
			var indent : String = StringService.getIndent( traceLevel );

			var str : String = "\n" + indent + "DigitalGoodInfo :\n";
			str += indent + "\t• label :\t\t" + String( label ) + "\n";
			str += indent + "\t• digitalGoodID :\t\t" + String( digitalGoodID ) + "\n";
			str += indent + "\t• type :\t\t" + String( type ) + "\n";
			str += indent + "\t• requirementMsg :\t\t" + String( requirementMsg ) + "\n";
			str += indent + "\t• statusChangeInfos :\t\t" + StringService.stringify( statusChangeInfos, traceLevel + 1 ) + "\n";
			str += indent + "\t• couponInfo :\t\t" + StringService.stringify( couponInfo, traceLevel + 1 ) + "\n";
			//str += indent + "\t• portInfo :\t\t" + StringService.stringify( portInfo, traceLevel + 1 );
			return( str );
		}

		override public function toURLvars() : URLVariables
		{
			//trace( CN + ".toObject" );

			super.toURLvars();
			urlVars.digitalGoodID = digitalGoodID;
			return urlVars;
		}

		public function get analyticEventText() : String
		{
			return String( label ) + ' (' + String( digitalGoodID ) + ')';
		}
	}
}
