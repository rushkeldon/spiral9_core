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

	import com.spiral9.utils.DataUtils;
	import com.spiral9.utils.StringService;

	import flash.display.MovieClip;

	public class StatusChangeInfo
	{
		public static const CN : String = "StatusChangeInfo";

		public static const CHANGE_TYPE_ADD : String =          "add";
		public static const CHANGE_TYPE_SET : String =          "set";

		public static const STATUS_TYPE_CASH : String =         "cash";
		public static const STATUS_TYPE_COINS : String =        "coins";
		public static const STATUS_TYPE_ENERGY : String =       "energy";
		public static const STATUS_TYPE_TICKETS : String =      "tickets";
		public static const STATUS_TYPE_XP : String =           "xp";

		public static const LOOKUP_CURRENT_STATUS : String =    "currentStatus";
		public static const LOOKUP_LEVEL_UP_VALUE : String =    "levelUpValue";
		public static const LOOKUP_REMAINING_TIME : String =    "remainingTime";
		public static const LOOKUP_NEXT_USER_LEVEL : String =   "nextLevel";
		public static const LOOKUP_MAX_VALUE : String =         "maxValue";
		public static const LOOKUP_USER_LEVEL : String =        "userLevel";

		public var statusType : String;
		public var changeType : String;
		public var value : int = -1;
		public var level : int = -1;
		public var minPossible : int = -1;
		public var maxPossible : int = -1;

		// runtime
		public var rewardTarget : MovieClip;

		public function StatusChangeInfo( initObject : Object = null )
		{
			if( initObject != null )
			{
				transferProps( initObject, this );
			}
		}

		private function transferProps( initObject : Object, targetObject : Object ) : void
		{
			DataUtils.transferProp( initObject, targetObject, "statusType" );
			DataUtils.transferProp( initObject, targetObject, "changeType" );
			DataUtils.transferProp( initObject, targetObject, "value" );
			DataUtils.transferProp( initObject, targetObject, "level" );
			DataUtils.transferProp( initObject, targetObject, "minPossible" );
			DataUtils.transferProp( initObject, targetObject, "maxPossible" );
			DataUtils.transferProp( initObject, targetObject, "rewardTarget" );
		}

		public function toObject() : Object
		{
			var o : Object = new Object();
			transferProps( this, o );
			return( o );
		}

		public function toString() : String
		{
			return StringService.getPrettyJSON( toObject() );
		}
		/*
				",userLevel:" + _userLevel +
				",xp:" + String( StringService.lookup( StatusChangeInfo.LOOKUP_CURRENT_STATUS, StatusChangeInfo.STATUS_TYPE_XP ) ) +
				",cash:" + String( StringService.lookup( StatusChangeInfo.LOOKUP_CURRENT_STATUS, StatusChangeInfo.STATUS_TYPE_CASH ) ) +
				",coins:" + String( StringService.lookup( StatusChangeInfo.LOOKUP_CURRENT_STATUS, StatusChangeInfo.STATUS_TYPE_COINS ) ) +
				",energy:" + String( StringService.lookup( StatusChangeInfo.LOOKUP_CURRENT_STATUS, StatusChangeInfo.STATUS_TYPE_ENERGY ) ) +
				",tickets:" + String( StringService.lookup( StatusChangeInfo.LOOKUP_CURRENT_STATUS, StatusChangeInfo.STATUS_TYPE_TICKETS )
		 */

		public static function get userLevel() : int
		{
			return parseInt( StringService.lookup( StatusChangeInfo.LOOKUP_USER_LEVEL, StatusChangeInfo.LOOKUP_USER_LEVEL ) );
		}

		public static function get xp() : int
		{
			return parseInt( StringService.lookup( StatusChangeInfo.LOOKUP_CURRENT_STATUS, StatusChangeInfo.STATUS_TYPE_XP ) );
		}

		public static function get cash() : int
		{
			return parseInt( StringService.lookup( StatusChangeInfo.LOOKUP_CURRENT_STATUS, StatusChangeInfo.STATUS_TYPE_CASH ) );
		}

		public static function get coins() : int
		{
			return parseInt( StringService.lookup( StatusChangeInfo.LOOKUP_CURRENT_STATUS, StatusChangeInfo.STATUS_TYPE_COINS ) );
		}

		public static function get energy() : int
		{
			return parseInt( StringService.lookup( StatusChangeInfo.LOOKUP_CURRENT_STATUS, StatusChangeInfo.STATUS_TYPE_ENERGY ) );
		}

		public static function get tickets() : int
		{
			return parseInt( StringService.lookup( StatusChangeInfo.LOOKUP_CURRENT_STATUS, StatusChangeInfo.STATUS_TYPE_TICKETS ) );
		}
	}
}
