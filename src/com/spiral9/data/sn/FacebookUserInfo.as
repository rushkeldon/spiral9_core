package com.spiral9.data.sn
{

	import com.spiral9.data.IAnalyticsInfo;
	import com.spiral9.data.actionengine.ReportInfo;
	import com.spiral9.data.actionengine.Reports;
	import com.spiral9.sn.FBcore;
	import com.spiral9.utils.StringService;
	import flash.net.URLVariables;



	public class FacebookUserInfo extends ReportInfo implements IAnalyticsInfo
	{
		public var isTheUser : Boolean;
		public var sn : String;
		public var username : String;		// keldon.rush
		public var verified : Boolean;
		public var timezone : int;			// -8
		public var name : String;			// Keldon Rush
		public var first_name : String;		// Keldon
		public var last_name : String;		// Rush
		public var id : String;				// 563350901
		public var updated_time : String;	// 2012-02-20T01:26:48+0000
		public var gender : String;			// male
		public var locale : String;			// en_US
		public var link : String;			// http://www.facebook.com/keldon.rush
		public var pic_square : String;		// http://profile.ak.fbcdn.net/hprofile-ak-snc4/157475_100003626705945_873428681_q.jpg
		public var email : String;			// keldon@spiral9.com
		public var userLevel : Number;

		public function FacebookUserInfo( initObject : Object )
		{
			trace( CN + " instantiated." );

			reportType = Reports.REPORT_FRIEND_VISIT_REQUESTED;
			sn = FBcore.SN;

			username = initObject.username;
			verified = initObject.verified;
			timezone = initObject.timezone;
			name = initObject.name;
			first_name = initObject.first_name;
			last_name = initObject.last_name;
			id = initObject.id;
			if( initObject.hasOwnProperty( "uid" ) )
			{
				id = initObject.uid;
			}
			updated_time = initObject.updated_time;
			gender = initObject.gender;
			locale = initObject.locale;
			link = initObject.link;
			pic_square = initObject.pic_square;
			email = initObject.email;
			//userLevel = Conversion.assignProp( initObject, "userLevel", 1 );
		}

		public function toString( traceLevel : int = 0 ) : String
		{
			var indent : String = StringService.getIndent( traceLevel );

			var str : String = "\n" + indent + "FacebookUserInfo :\n";
			str += indent + "\t• name :\t\t" + String( name ) + "\n";
			str += indent + "\t• username :\t\t" + String( username ) + "\n";
			str += indent + "\t• first_name :\t\t" + String( first_name ) + "\n";
			str += indent + "\t• last_name :\t\t" + String( last_name ) + "\n";
			str += indent + "\t• sn :\t\t\t" + String( sn ) + "\n";
			str += indent + "\t• gender :\t\t" + String( gender ) + "\n";
			str += indent + "\t• id :\t\t\t" + String( id ) + "\n";
			str += indent + "\t• link :\t\t" + String( link ) + "\n";
			str += indent + "\t• locale :\t\t" + String( locale ) + "\n";
			str += indent + "\t• timezone :\t\t" + String( timezone ) + "\n";
			str += indent + "\t• updated_time :\t" + String( updated_time ) + "\n";
			str += indent + "\t• verified :\t\t" + String( verified ) + "\n";
			str += indent + "\t• pic_square :\t\t" + String( pic_square ) + "\n";
			str += indent + "\t• email :\t\t" + String( email ) + "\n";
			str += indent + "\t• userLevel :\t\t" + String( userLevel );
			return( str );
		}

		override public function toURLvars() : URLVariables
		{
			//trace( CN + ".toURLvars" );

			super.toURLvars();
			urlVars.SN = sn;
			urlVars.targetSNID = id;
			return urlVars;
		}

		public function get analyticEventText() : String
		{
			return String( id );
		}
	}
}
