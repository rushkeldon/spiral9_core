/*******************************************************************************
 *(C) 2008 - 2012 SPIRAL9, INC. ( SPIRAL9 )
 * All Rights Reserved.
 *
 * NOTICE:  SPIRAL9 permits you to use, modify, and distribute this file in
 * accordance with the terms of the SPIRAL9 license agreement accompanying it.
 * If you have received this file without a license agreement or from a source
 * other than SPIRAL9 then your use, modification, or distribution of it requires
 * the prior written permission of SPIRAL9, INC.
 *******************************************************************************/
package com.spiral9.sn
{
	import com.spiral9.data.sn.SNShareInfo;
	//import com.spiral9.net.Bridge;
	import com.spiral9.net.URLservice;
	import com.facebook.graph.Facebook;
	import org.osflash.signals.Signal;

	public class FBcore
	{
		public static const CN : String 		= "FBcore";

		//public static const APP_ID : String 	= "206320676107119";	// TODO : INTEGRATION
		public static const SN : String                     = "fb";
		private static var _appID : String                  = "206320676107119";

		public var signalFriendListReceived : Signal;
		public var signalSNinitialized : Signal;
		public var signalSessionEvent : Signal;

		protected static function get _authResponse() : Object
		{
			//trace( CN + "._authResponse" );

			//return Bridge.getAuthResponse();
			return {};
		}

		public function FBcore()
		{
			trace( CN + " instantiated." );

			if( URLservice.flashVars != null && URLservice.flashVars.FBappID != null )
			{
				trace( "Resetting _appID from FlashVars:" + URLservice.flashVars.FBappID + ":" );
				_appID = URLservice.flashVars.FBappID;
			}
			signalSNinitialized = new Signal();
			signalSessionEvent = new Signal( String, Object );
			signalFriendListReceived = new Signal();

			connectActionEngine();
		}

		public static function get APP_ID() : String
		{
			//trace( CN + " APP_ID getter called." );
			//trace( "\t_appID:" + _appID + ":" );
			return _appID;
		}

		protected function connectActionEngine() : void
		{
			//trace( CN + ".connectActionEngine" );

			//ActionEngineCore.signalActionSNShare.add( shareToWall );
		}

		public static function shareToWall( shareInfo : SNShareInfo ) : void
		{
			trace( CN + ".shareToWall" );

			if( shareInfo.sn != SN ){ return; }

			Facebook.ui( "feed", shareInfo.data, onAppRequestComplete, shareInfo.displayContainer );
		}

		public static function onAppRequestComplete( response : Object = null, error : Object = null ) : void
		{
			trace( CN + ".onAppRequestComplete" );

			var o : Object;

			if( response != null )
			{
				trace( "\t" + CN + ".received a *response* object" );
				for each( o in response )
				{
					trace( "\t", o );
				}
			}

			if( error != null )
			{
				trace( "\t" + CN + ".received a *error* object" );
				for each( o in response )
				{
					trace( "\t", o );
				}
			}
		}

		public static function getAccessToken() : String
		{
			trace( CN + ".getAccessToken" );

			var accessToken : String = "NO_TOKEN";//ReportInfo.NO_TOKEN;
			var response : Object = _authResponse;

			if( response != null )
			{
				accessToken = response.accessToken;
			}

			return accessToken;
		}

	}
}
