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
	import com.spiral9.data.commerce.CouponInfo;
	import com.spiral9.data.commerce.DigitalGoodInfo;
	//import com.spiral9.data.portscape.PortInfo;
	import com.spiral9.utils.Conversion;
	import com.spiral9.utils.StringService;

	public class DialogInfo implements IAnalyticsInfo
	{
		public var CN : String = "DialogInfo";

		public static const DEFAULT_ID : String = "defaultID";
		public static const DEFAULT_STRING : String = "";
		public var btnCloseActions : Array;
		public var btnInfos : Vector.<ButtonInfo>;
		public var dialogID : String;
		public var dismissable : Boolean;
		public var imageInfo : SWFassetInfo;
		public var msg0 : String;
		public var msg1 : String;
		public var digitalGoodInfo : DigitalGoodInfo;
		//public var portInfo : PortInfo;
		public var couponInfo : CouponInfo;
		public var title : String;

		public function DialogInfo( initObject : Object = null )
		{
			//trace( CN + " instantiated." );

			/*
			"action":"displayDialog",
			"DialogInfo":{
				"dialogID":"purchaseInventory",
				"msg0":"This item is now in your inventory.",
				"btns":null
			}
			*/

			btnInfos = new Vector.<ButtonInfo>();

			if( initObject != null )
			{
				var i : int;

				dialogID = Conversion.assignProp( initObject, "dialogID", DEFAULT_ID );
				msg0 = StringService.processServerString( Conversion.assignProp( initObject, "msg0", DEFAULT_STRING ) );
				msg1 = StringService.processServerString( Conversion.assignProp( initObject, "msg1", DEFAULT_STRING ) );
				title = StringService.processServerString( Conversion.assignProp( initObject, "title", DEFAULT_STRING ) );

				if( initObject.hasOwnProperty( "dismissable" ) )
				{
					dismissable = !( String( initObject.dismissable ).toLowerCase() == "false" );
				}
				else
				{
					dismissable = true;
				}

				if( initObject.img != null )
				{
					imageInfo = new SWFassetInfo( initObject.img );
				}

				if( initObject.btns != null )
				{
					for( i = 0; i < initObject.btns.length; i++ )
					{
						btnInfos.push( new ButtonInfo( initObject.btns[ i ] ) );
					}
				}

				switch( true )
				{
					case ( initObject.PortInfo != null ) :
						//portInfo = new PortInfo( initObject.PortInfo );
						break;
					case ( initObject.CouponInfo != null ) :
						couponInfo = new CouponInfo( initObject.CouponInfo );
						break;
					case ( initObject.DigitalGoodInfo != null ) :
						digitalGoodInfo = new DigitalGoodInfo( initObject.DigitalGoodInfo );
						break;
				}
			}
			//trace( this );
		}

		public function toString( traceLevel : int = 0 ) : String
		{
			var indent : String = StringService.getIndent( traceLevel );

			var str : String = "\n" + indent + "DialogInfo :\n";
			str += indent + "\t• dialogID :\t\t" + String( dialogID ) + "\n";
			str += indent + "\t• title :\t\t" + String( title ) + "\n";
			str += indent + "\t• msg0 :\t\t" + String( msg0 ) + "\n";
			str += indent + "\t• msg1 :\t\t" + String( msg1 ) + "\n";
			str += indent + "\t• imageInfo :\t\t" + String( imageInfo ) + "\n";
			str += indent + "\t• dismissable :\t\t" + String( dismissable ) + "\n";
			str += indent + "\t• btnCloseActions :\t" + StringService.stringify( btnCloseActions, traceLevel + 1 ) + "\n";
			//str += indent + "\t• portInfo :\t\t" + StringService.stringify( portInfo, traceLevel + 1 ) + "\n";
			str += indent + "\t• digitalGoodInfo :\t" + StringService.stringify( digitalGoodInfo, traceLevel + 1 ) + "\n";
			str += indent + "\t• btnInfos :\t\t  " + StringService.stringify( btnInfos, traceLevel + 1 );
			return( str );
		}

		public function get analyticEventText() : String
		{
			return String( dialogID );
		}
	}
}
