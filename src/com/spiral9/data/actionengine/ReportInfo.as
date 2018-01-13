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
package com.spiral9.data.actionengine
{
	import com.spiral9.net.FileService;

	import flash.net.URLVariables;
	import flash.utils.getTimer;

	public dynamic class ReportInfo
	{
		public var CN : String =                      "ReportInfo";

		public static const NO_TOKEN : String =       "noToken";
		public static var clientID : String =         "unknown_client";
		public var reportType : String =              "defaultReportType";
		public var timestamp : int;
		public var isDataNeeded : Boolean;
		public var HWPID : String;

		// runtime
		public var eventData : Object;
		public var urlVars : URLVariables;
		public var infoClass : Class;

		public function ReportInfo( initObject : Object = null )
		{
			HWPID = HWPIDstore.HWPID;
			infoClass = ReportInfo;
			timestamp = getTimer();
		}

		// FIXME : Google+
		private function get accessToken() : String
		{
			var currentAccessToken : String = NO_TOKEN;

			var FaceBookClass : Class = FileService.getClass( "com.spiral9.sn.FBcore" ) as Class;
			if( FaceBookClass is Class )
			{
				currentAccessToken = FaceBookClass[ "getAccessToken" ]();
			}

			return( currentAccessToken );
		}

		public function toURLvars() : URLVariables
		{
			//trace( CN + ".toURLvars" );
			var currentAccessToken : String = accessToken;

			urlVars = new URLVariables();
			urlVars.reportType = reportType;
			urlVars.clientID = clientID;
			urlVars.HWPID = HWPIDstore.HWPID;
			if( currentAccessToken != NO_TOKEN )
			{
				urlVars.accessToken = currentAccessToken;
			}
			urlVars.timestamp = getTimer();

			// eventData is only for passing back to the server for a custom event report - doesn't happen much
			if( eventData != null )
			{
				urlVars.eventData = eventData;
			}
			return( urlVars );
		}
	}
}
