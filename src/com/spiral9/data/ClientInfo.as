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

	import flash.display.MovieClip;

	public class ClientInfo
	{
		public static const TYPE_CLIENT : String =            "typeClient";
		public static const TYPE_CLIENT_AND_GAME : String =   "typeClientAndGame";
		public static const TYPE_GAME_CONNECTED : String =    "typeGameConnected";
		public static const TYPE_GAME_SIMPLE : String =       "typeGameSimple";

		private var _clientID : String = "noID";

		public var clientType : String;
		public var mainMovieClip : MovieClip;      // the pointer to the document Class which must extend MovieClip ( no Sprite )
		public var actionEnginePluginClass : Class;
		public var analyticsClass : Class;
		public var audioClass : Class;
		public var sessionClass : Class;
		public var enableFeedbackWidget : Boolean = false;
		public var handlerGameInfoReceived : Function;
		public var handlerDisplayRewards : Function;

		public function ClientInfo( initObject : Object = null )
		{
			if( initObject != null )
			{
				DataUtils.transferProp( initObject, this, "clientID" );
				DataUtils.transferProp( initObject, this, "clientType" );
				DataUtils.transferProp( initObject, this, "mainMovieClip" );
				DataUtils.transferProp( initObject, this, "actionEngineClass" );
				DataUtils.transferProp( initObject, this, "analyticsClass" );
				DataUtils.transferProp( initObject, this, "audioClass" );
				DataUtils.transferProp( initObject, this, "sessionClass" );
			}
		}

		public function set clientID( newID : String ) : void
		{
			_clientID = newID;
		}

		public function get clientID() : String
		{
			return _clientID;
		}

		public static function get clientID() : String
		{
			return clientID;
		}
	}
}
