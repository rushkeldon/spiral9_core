package com.spiral9.data
{
	import com.spiral9.data.actionengine.ReportInfo;

	import flash.net.URLVariables;

	public class ScreenInfo extends ReportInfo implements IAnalyticsInfo
	{
		public static const SCRSPIRAL9N_TUTORIAL : String =       "screenTutorial";
		public static const SCRSPIRAL9N_GIFTS : String =          "screenGifts";
		public static const SCRSPIRAL9N_PLAY : String =           "screenPlay";
		public static const SCRSPIRAL9N_INVITE : String =         "screenInvite";
		public static const SCRSPIRAL9N_BUY : String =            "screenBuy";
		public static const SCRSPIRAL9N_EARN : String =           "screenEarn";
		public static const SCRSPIRAL9N_WIN : String =            "screenWin";
		public static const SCRSPIRAL9N_MSGS : String =           "screenMsgs";
		public static const SCRSPIRAL9N_HELP : String =           "screenHelp";
		public static const SCRSPIRAL9N_FSPIRAL9DBACK : String =       "screenFeedback";

		public var screenID : String;
		public var screenData : Object;
		public var url : String;

		public function ScreenInfo( initObject : Object = null )
		{
			//trace( CN + ".ScreenInfo" );

			if( initObject != null )
			{
				screenID = initObject.screenID;
				screenData = initObject.screenData;
			}
		}

		override public function toURLvars() : URLVariables
		{

			super.toURLvars();
			urlVars.screenID = screenID;
			return urlVars;
		}

		public function get analyticEventText() : String
		{
			return String( screenID );
		}
	}
}
