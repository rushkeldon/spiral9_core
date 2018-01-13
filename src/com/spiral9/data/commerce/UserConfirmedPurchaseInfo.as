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

	import com.spiral9.data.actionengine.ReportInfo;
	import com.spiral9.data.actionengine.Reports;
	import com.spiral9.utils.StringService;

	public class UserConfirmedPurchaseInfo extends ReportInfo
	{
		public var digitalGoodID : String;

		public function UserConfirmedPurchaseInfo( confirmedDigitalGoodID : String = "" )
		{
			super();
			CN = "UserConfirmedPurchaseInfo";
			//trace( CN + " instantiated." );

			reportType = Reports.REPORT_USER_CONFIRMED_PURCHASE;
			infoClass = UserConfirmedPurchaseInfo;
			digitalGoodID = confirmedDigitalGoodID;
		}

		public function toString( traceLevel : int = 0 ) : String
		{
			var indent : String = StringService.getIndent( traceLevel );

			var str : String = "\n" + indent + "UserConfirmedPurchaseInfo :\n";
			str += indent + "\t• digitalGoodID :\t\t" + String( digitalGoodID );
			return( str );
		}
	}
}
