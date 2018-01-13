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
	import com.spiral9.data.actionengine.ReportInfo;
	import com.spiral9.data.actionengine.Reports;
	import com.spiral9.utils.StringService;

	import flash.net.URLVariables;

	public class SessionInfo extends ReportInfo
	{
		public static const AUTHORITY_ID_FACEBOOK : String = 				"fb";
		public static const AUTHORITY_ID_GOOGLE_PLUS : String = 				"gp";

		public static var SN : String;								// the ID of the social network
		public static var SNID : String;								// the ID of the user ala the Social Network
		public static var HWPID : String;
		public static var isFirstRun : Boolean;

		public function SessionInfo( initObject : Object = null )
		{
			super();
			CN = "SessionInfo";
			reportType = Reports.REPORT_SESSION_STARTED;
			infoClass = SessionInfo;
			SN = AUTHORITY_ID_FACEBOOK;

			if( initObject != null )
			{
				isFirstRun = initObject.isFirstRun;
				HWPID = initObject.HWPID;
			}
		}


		override public function toURLvars() : URLVariables
		{
			//trace( CN + ".toURLvars" );

			super.toURLvars();
			urlVars.reportType = reportType;
			urlVars.SN = SN;
			urlVars.SNID = SNID;
			return urlVars;
		}

		public function toString( traceLevel : int = 0 ) : String
		{
			var indent : String = StringService.getIndent( traceLevel );

			var str : String = "\n" + indent + "SessionInfo :\n";

			str += indent + "\t• reportType :\t\t" + reportType + "\n";
			str += indent + "\t• infoClass :\t\t" + infoClass + "\n";
			str += indent + "\t• SN :\t\t" + SN + "\n";
			str += indent + "\t• SNID :\t\t" + SNID + "\n";
			str += indent + "\t• HWPID :\t\t" + HWPID + "\n";
			str += indent + "\t• isFirstRun :\t\t" + isFirstRun + "\n";

			return str;
		}
	}
}
