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

	import com.adobe.serialization.json.JSON;
	import com.spiral9.data.actionengine.ReportInfo;
	import com.spiral9.data.actionengine.Reports;
	import com.spiral9.net.URLservice;
	import com.spiral9.utils.Conversion;
	import com.spiral9.utils.DataUtils;
	import com.spiral9.utils.StringService;

	import flash.net.URLVariables;

	public class GameInfo extends ReportInfo implements IAnalyticsInfo
	{
		public static const HOST_TYPE_IFRAME : String = 				"hwpAppExternal";
		public static const HOST_TYPE_FLASH : String = 				"inFlash";

		public var baseURL : String;
		public var swfURL : String;
		public var engineType : String;
		public var gameID : String;
		public var width : int;
		public var height : int;
		public var authoredWidth : int;
		public var authoredHeight : int;
		public var hostType : String;
		public var score : Object;
		public var gameData : Object;
		public var gameRecords : Object;
		public var endScreenInfo : EndScreenInfo;
		public var skinInfo : ISkinInfo;

		protected static var _isGameDisplayed : Boolean;
		protected var _url : String;
		protected var _initObject : Object;

		public function GameInfo( initObject : Object = null )
		{
			super();
			CN = "GameInfo";
			trace( CN + " instantiated." );
			infoClass = GameInfo;

			if( initObject != null )
			{
				_initObject = initObject;
				transferProps( initObject, this );
			}
		}

		private function transferProps( initObject : Object, targetObject : Object ) : void
		{
			DataUtils.transferProp( initObject, targetObject, "baseURL" );
			DataUtils.transferProp( initObject, targetObject, "swfURL" );
			DataUtils.transferProp( initObject, targetObject, "engineType" );
			DataUtils.transferProp( initObject, targetObject, "gameID" );
			DataUtils.transferProp( initObject, targetObject, "width" );
			DataUtils.transferProp( initObject, targetObject, "height" );
			DataUtils.transferProp( initObject, targetObject, "authoredWidth" );
			DataUtils.transferProp( initObject, targetObject, "authoredHeight" );
			DataUtils.transferProp( initObject, targetObject, "hostType" );
			DataUtils.transferProp( initObject, targetObject, "score" );
			DataUtils.transferProp( initObject, targetObject, "gameData" );
			DataUtils.transferProp( initObject, targetObject, "gameRecords" );

			targetObject.url = initObject.url;

			if( targetObject is GameInfo )
			{
				if( DataUtils.hasProp( initObject, "EndScreenInfo" ) )
				{
					GameInfo( targetObject ).endScreenInfo = new EndScreenInfo( initObject.EndScreenInfo );
				}

				// TODO : we will need to add in cases for new skins
				if( DataUtils.hasProp( initObject, "GameSkinInfoMQT" ) )
				{
					GameInfo( targetObject ).skinInfo = new SkinInfoMQT( initObject.GameSkinInfoMQT );
				}
			}
			else
			{
				if( DataUtils.hasProp( initObject, "endScreenInfo" ) )
				{
					targetObject.EndScreenInfo = initObject.endScreenInfo.toObject();
				}

				// TODO : we will need to add in cases for new skins
				if( DataUtils.hasProp( initObject, "skinInfo" ) )
				{
					targetObject.GameSkinInfoMQT = initObject.skinInfo.toObject();
				}
			}
		}

		public function get url() : String
		{
			return _url;
		}

		public function set url( newURL : String ) : void
		{
			_url = URLservice.mapURL( newURL );
			setURLs();
		}

		private function setURLs() : void
		{
			trace( CN + ".setURLs" );
			// FIXME : INTEGRATION
			var fileNamePrefix : String = URLservice.isProductionEnvironment ? "" : "x_";

			switch( true )
			{
				case ( url.lastIndexOf( "/" ) == url.length - 1 ) :
					baseURL = URLservice.mapURL( url );
					break;
				case ( url.lastIndexOf( ".swf" ) == url.length - 4 ) :
					baseURL = URLservice.baseContentURL;
					break;
			}
			// FIXME : integration - some hard coded URLS to bypass cloufront for now
			switch( _initObject.engineType )
			{
				case null :
					trace( "\tERROR : no engineType in _initObject." );
					return;
					break;
				case "dx" :
				case "js" :
				case "mm" :
				case "tutorial" :
					swfURL = URLservice.baseContentURL + "swf/" + fileNamePrefix + "game_base_preloader.swf";
					break;
				case "intro" :
					swfURL = URLservice.baseContentURL + "swf/" + fileNamePrefix + "game_intro.swf";
					break;
				case "mq" :
				case "mqd":
					swfURL = URLservice.currentProtocol + "//s3.amazonaws.com/assets.hollywoodplayer.com/" + "swf/" + fileNamePrefix + "game_mq.swf";
					//swfURL = URLservice.baseContentURL + "swf/" + fileNamePrefix + "game_mq.swf";
					break;
				case "mqa" :
					swfURL = URLservice.currentProtocol + "//s3.amazonaws.com/assets.hollywoodplayer.com/" + "swf/" + fileNamePrefix + "game_esb.swf";
					//swfURL = URLservice.baseContentURL + "swf/" + fileNamePrefix + "game_esb.swf";
					break;
				case "mqt" :
					swfURL = URLservice.currentProtocol + "//s3.amazonaws.com/assets.hollywoodplayer.com/" + "swf/" + fileNamePrefix + "game_mqt.swf";
					//swfURL = URLservice.baseContentURL + "swf/" + fileNamePrefix + "game_mqt.swf";
					break;
				case "s2w" :
					swfURL = URLservice.baseContentURL + "swf/" + fileNamePrefix + "game_s2w.swf";
					break;
				case "dbr" :
					swfURL = URLservice.baseContentURL + "swf/" + fileNamePrefix + "game_dbr.swf";
					break;
				case "" :
					trace( "\tNo engineType - in a game session?" );
				default :
					trace( "\tA new or otherwise unknown engineType was encountered :" + engineType + ":" );
			}
		}

		public function toString( traceLevel : int = 0 ) : String
		{
			var indent : String = StringService.getIndent( traceLevel );

			var str : String = "\n" + indent + CN + " :\n";
			// simple
			if( DataUtils.hasProp( this, "url" ) ){ str += indent + "\t• url :\t\t" + String( url ) + "\n"; }
			if( DataUtils.hasProp( this, "baseURL" ) ){ str += indent + "\t• baseURL :\t\t" + String( baseURL ) + "\n"; }
			if( DataUtils.hasProp( this, "swfURL" ) ){ str += indent + "\t• swfURL :\t\t" + String( swfURL ) + "\n"; }
			if( DataUtils.hasProp( this, "engineType" ) ){ str += indent + "\t• engineType :\t\t" + String( engineType ) + "\n"; }
			if( DataUtils.hasProp( this, "gameID" ) ){ str += indent + "\t• gameID :\t\t" + String( gameID ) + "\n"; }
			if( DataUtils.hasProp( this, "width" ) ){ str += indent + "\t• width :\t\t" + String( width ) + "\n"; }
			if( DataUtils.hasProp( this, "height" ) ){ str += indent + "\t• height :\t\t" + String( height ) + "\n"; }
			if( DataUtils.hasProp( this, "authoredWidth" ) ){ str += indent + "\t• authoredWidth :\t\t" + String( authoredWidth ) + "\n"; }
			if( DataUtils.hasProp( this, "authoredHeight" ) ){ str += indent + "\t• authoredHeight :\t\t" + String( authoredHeight ) + "\n"; }
			if( DataUtils.hasProp( this, "hostType" ) ){ str += indent + "\t• hostType :\t\t" + String( hostType ) + "\n"; }
			// complex
			if( DataUtils.hasProp( this, "score" ) ){ str += indent + "\t• dropZoneInfos :\t\t" + StringService.stringify( score, traceLevel + 1 ) + "\n"; }
			if( DataUtils.hasProp( this, "gameData" ) ){ str += indent + "\t• gameData :\t\t" + StringService.stringify( gameData, traceLevel + 1 ) + "\n"; }
			if( DataUtils.hasProp( this, "gameRecords" ) ){ str += indent + "\t• gameRecords :\t\t" + StringService.stringify( gameRecords, traceLevel + 1 ) + "\n"; }
			if( DataUtils.hasProp( this, "endScreenInfo" ) ){ str += indent + "\t• endScreenInfo :\t\t" + StringService.stringify( endScreenInfo, traceLevel + 1 ) + "\n"; }
			if( DataUtils.hasProp( this, "skinInfo" ) ){ str += indent + "\t• skinInfo :\t\t" + StringService.stringify( skinInfo, traceLevel + 1 ); }

			return( str );
		}

		public function toObject() : Object
		{
			trace( CN + ".toObject" );

			var object : Object = new Object();
			transferProps( this, object );
			return( object );
		}

		override public function toURLvars() : URLVariables
		{
			trace( CN + ".toURLvars" );

			super.toURLvars();
			urlVars.gameID = gameID;

			if( score != null )
			{
				if( score.score != null )
				{
					urlVars.score = score.score;
				}
				if( score.bonus != null )
				{
					urlVars.bonus = score.bonus;
				}
			}

			if( gameData != null && reportType != Reports.REPORT_GAME_STARTED )
			{
				var str : String = "\ngameInfo.gameData :\n";
				str += StringService.stringify( gameData );
				trace( str );

				urlVars.gameData = Conversion.objectToBase64json( gameData );
			}
			return urlVars;
		}

		public static function get isGameDisplayed() : Boolean
		{
			return _isGameDisplayed;
		}

		public static function set isGameDisplayed( isDisplayed : Boolean ) : void
		{
			_isGameDisplayed = isGameDisplayed;
		}

		public function get analyticEventText() : String
		{
			return String( engineType ) + '-' + String( gameID );
		}

		public function toJSON() : String
		{
			return( com.adobe.serialization.json.JSON.encode( toObject() ) );
		}

	}
}
