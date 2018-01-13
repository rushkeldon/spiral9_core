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

	//import com.spiral9.core.ActionEngineCore;

	public class HWPIDstore
	{
		private static const CN : String = "HWPIDstore";
		private static var _instance : HWPIDstore;
		private static var _allowInstance : Boolean = false;
		private static var _HWPID : String = "";

		public function HWPIDstore( hwpid : String = "" )
		{
			if( _allowInstance )
			{
				trace( CN + " instantiated." );
				_HWPID = hwpid;
				//ActionEngineCore.signalActionStartSession.addOnce( init );
			}
			else
			{
				throw new Error( "singleton" );
			}
		}

		public static function init( hwpid : String = "", isFirstRun : Boolean = false ) : void
		{
			if( _instance == null )
			{
				_allowInstance = true;
				_instance = new HWPIDstore( hwpid );
				_allowInstance = false;
			}
			else if( hwpid != "" )
			{
				_HWPID = hwpid;
			}
		}

		public static function get HWPID() : String
		{
			return _HWPID;
		}
	}
}
