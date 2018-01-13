package com.spiral9.data.sn
{

	import com.spiral9.data.actionengine.ReportInfo;
	import com.spiral9.data.actionengine.Reports;

	import flash.net.URLVariables;

	public class UserLevelsInfo extends ReportInfo
	{
		public var userLevelObjects : Vector.<Object>;

		public function UserLevelsInfo( initObject : Object )
		{
			super();
			CN = "UserLevelsInfo";
			//trace( CN + " instantiated." );

			reportType = Reports.REPORT_FRIEND_LIST_RECEIVED;
			infoClass = UserLevelsInfo;

			var i : int = 0;
			var o : Object;
			userLevelObjects = new Vector.<Object>;

			for each( o in initObject )
			{
				userLevelObjects.push( { SNID : o.SNID, userLevel : parseInt( o.userLevel ) } );
				i++;
			}
			//trace( "\tthis many objects in initObject:" + i + ":" );
		}

		override public function toURLvars() : URLVariables
		{
			//trace( CN + ".toURLvars" );

			var o : Object;
			var snids : Array = new Array();

			for each( o in userLevelObjects )
			{
				snids.push( o.SNID );
			}

			super.toURLvars();
			urlVars.friendSNIDS = snids.toString();
			return urlVars;
		}
	}
}
