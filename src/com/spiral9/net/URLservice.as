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
package com.spiral9.net
{

	import flash.display.LoaderInfo;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	public class URLservice
	{
		public static var CN : String = "URLservice[2014_03_15_12_45]";
		private static var _instance : URLservice;

		public static const BLANK : String =                "_blank";  // specifies a new window.
		public static const PARENT : String =               "_parent"; // specifies the parent of the current frame.
		public static const SELF : String =                 "_self";   // specifies the current frame in the current window.
		public static const TOP : String =                  "_top";    // specifies the top-level frame in the current window.

		public static const BAD_URL : String =              "BAD_URL";

		private static var _allowInstance : Boolean =       false;
		private static var _currentProtocol : String =      "http:";
		private static var _baseContentURL : String =       "//d3crp60fns2zzg.cloudfront.net/";
		private static var _baseContentURLdev : String =    "//s3.amazonaws.com/assets.hollywoodplayer.com/";
		private static var _baseServerURL : String =        "//api.hollywoodplayer.com/";
		private static var _loaderInfo : LoaderInfo;
		private static var _swfURL : String;
		private static var _signedRequest : String;

		public function URLservice( loaderInfo : LoaderInfo )
		{
			if( _allowInstance )
			{
				trace( CN + " instantiated." );
				_loaderInfo = loaderInfo;
				_currentProtocol = extractProtocol( loaderInfo );
				if( _loaderInfo.parameters != null )
				{
					if( _loaderInfo.parameters.swfURL != null )
					{
						_swfURL = _loaderInfo.parameters.swfURL;
						trace( "\t_swfURL:" + _swfURL + ":" );
					}
					if( _loaderInfo.parameters.baseServerURL != null )
					{
						_baseServerURL = _loaderInfo.parameters.baseServerURL;
						trace( "\t_baseServerURL:" + _baseServerURL + ":" );
					}
					if( _loaderInfo.parameters.signedRequest != null )
					{
						_signedRequest = String( _loaderInfo.parameters._signedRequest );
						trace( "\t_signedRequest:" + _signedRequest + ":" );
					}
				}
				//trace( "\t_currentProtocol:" + _currentProtocol + ":" );

				_baseServerURL = mapURL( _baseServerURL );
				_baseContentURL = mapURL( _baseContentURL );
			}
			else
			{
				throw new Error( "singleton" );
			}
		}

		public static function init( loaderInfo : LoaderInfo ) : void
		{
			if( _instance == null )
			{
				_allowInstance = true;
				_instance = new URLservice( loaderInfo );
				_allowInstance = false;
			}
		}

		private static function extractProtocol( loaderInfo : LoaderInfo ) : String
		{
			// trace( CN + ".extractProtocol" );

			if( loaderInfo != null )
			{
				var protocol : String = loaderInfo.url.split( "//" )[ 0 ];

				if( protocol == "file:" )
				{
					protocol = "http:";
				}
				return protocol;
			}
			else
			{
				trace( "\tERROR : the LoaderInfo passed to CurrentProtocol is null." );
			}

			return "http:";
		}

		public static function get isProductionEnvironment() : Boolean
		{
			if( _baseServerURL.indexOf( "dev" ) == -1 && _baseServerURL.indexOf( "test" ) == -1 )
			{
				return true;
			}
			else
			{
				return false;
			}
		}

		public static function mapURL( url : String ) : String
		{
			url = String( url );

			switch( true )
			{
				case ( url == "null" ) :
				case ( url == "" ) :
				case ( url == "undefined" ) :
					url = BAD_URL;
					break;
				default :
					if( url.indexOf( "//" ) == 0 )
					{
						url = _currentProtocol + url;
					}
					break;
			}
			return url;
		}

		public static function get currentProtocol() : String
		{
			return _currentProtocol;
		}

		public static function set baseServerURL( newURL : String ) : void
		{
			_baseServerURL = mapURL( newURL );
		}

		public static function get reportURL() : String
		{
			return _baseServerURL + "server/report/";
		}

		public static function get gameXMLinitURL() : String
		{
			return _baseServerURL + "game/initial-xml/";
		}

		public static function get baseContentURL() : String
		{
			if( isProductionEnvironment )
			{
				return _baseContentURL;
			}
			else
			{
				return _baseContentURLdev;
			}
		}

		public static function set baseContentURL( newURL : String ) : void
		{
			if( isProductionEnvironment )
			{
				_baseContentURL = mapURL( newURL );
			}
			else
			{
				_baseContentURLdev = mapURL( newURL );
			}
		}

		static public function get loaderInfo() : LoaderInfo
		{
			return _loaderInfo;
		}

		static public function get swfURL() : String
		{
			return _swfURL;
		}

		static public function get signedRequest() : String
		{
			return _signedRequest;
		}

		static public function launchURL( url : String, targetWindow : String = "_blank" ) : void
		{
			url = mapURL( url );
			var request : URLRequest = new URLRequest( url );

			try
			{
				switch( targetWindow )
				{
					case BLANK :
					case PARENT :
					case SELF :
					case TOP :
						break;
					default :
						targetWindow = BLANK;
				}
				navigateToURL( request, targetWindow );
			}
			catch ( e : Error )
			{
				trace( "Could not open url." );
			}
		}

		static public function get flashVars() : Object
		{
			return _loaderInfo.parameters;
		}

		static public function get baseServerURL() : String
		{
			return _baseServerURL;
		}
	}
}
