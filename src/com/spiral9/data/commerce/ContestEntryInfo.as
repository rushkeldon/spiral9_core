package com.spiral9.data.commerce
{

	//import com.spiral9.core.EEcore;
	import com.spiral9.data.actionengine.ReportInfo;

	import flash.net.URLVariables;

	// import com.spiral9.app.Session;

	public class ContestEntryInfo extends ReportInfo
	{
		public var contestID : String;

		public function ContestEntryInfo( initObject : Object = null )
		{
			super();

			if( initObject != null )
			{
				contestID = initObject.contestID;
			}
		}

		override public function toURLvars() : URLVariables
		{
			//trace( CN + ".toURLvars" );

			super.toURLvars();
			urlVars.contestID = contestID;
			///urlVars.email = EEcore.clientInfo.sessionClass[ "email" ];

			return urlVars;
		}
	}
}
