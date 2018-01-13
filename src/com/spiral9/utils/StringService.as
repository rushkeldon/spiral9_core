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
package com.spiral9.utils
{
	//import com.spiral9.net.Bridge;

	import flash.net.URLVariables;
	import flash.utils.getQualifiedClassName;

	public class StringService
	{
		private static const CN : String = "StringService";
		private static var _instance : StringService;
		private static var _allowInstance : Boolean = false;
		private static var _lookups : Object;

		public function StringService()
		{
			if( _allowInstance )
			{
				trace( CN + " instantiated." );

				_lookups = new Object();
			}
			else
			{
				throw new Error( "singleton" );
			}
		}

		private static function createInstance() : void
		{
			if( _instance == null )
			{
				_allowInstance = true;
				_instance = new StringService();
				_allowInstance = false;
			}
		}

		public static function init() : void
		{
			createInstance();
		}

		public static function processServerString( svrStr : String ) : String
		{
			if( svrStr == null || svrStr == "null" )
			{
				return "null";
			}
			if( svrStr.indexOf( "{" ) == -1 )
			{
				return svrStr;
			}

			trace( CN + ".processServerString" );

			var r : String = "";
			var openBracketIndex : int = svrStr.indexOf( "{" );
			var closeBracketIndex : int;
			var jsonStr : String;
			var replacements : Array;
			var pair : Array;
			var i : int;

			while( openBracketIndex != -1 )
			{
				r += svrStr.substring( 0, openBracketIndex );
				closeBracketIndex = svrStr.indexOf( "}" );
				jsonStr = svrStr.substring( openBracketIndex + 1, closeBracketIndex );
				jsonStr = jsonStr.split( "\"" ).join( "" );
				replacements = jsonStr.split( "," );

				for( i = 0; i < replacements.length; i++ )
				{
					pair = replacements[ i ].split( ":" );
					r += lookup( pair[ 0 ], pair[ 1 ] );
				}
				svrStr = svrStr.substr( closeBracketIndex + 1, svrStr.length );
				openBracketIndex = svrStr.indexOf( "{" );
			}
			r += svrStr;
			return r;
		}

		public static function registerLookup( type : String, lookup : Function ) : void
		{
			_lookups[ type ] = lookup;
		}

		public static function removeLookup( type : String ) : void
		{
			_lookups[ type ] = null;
		}

		public static function lookup( type : String, id : String ) : String
		{
			// WELCOME TO {"userFirstName":"SNID"}'S WORLD

			return String( _lookups[ type ]( type, id ) );
		}

		public static function stringifyFromObject( subject : Object, initObject : Object, traceLevel : int = 0 ) : String
		{
			var str : String = "ERROR : StringService.stringifyFromObject received a null!!";

			if( subject != null && initObject != null )
			{
				var className : String = ( subject.hasOwnProperty( "CN" ) ) ? subject.CN : "NO_CN";
				var indent : String = getIndent( traceLevel );
				str = "\n" + indent + className + " :\n";
				var propName : String;

				for( propName in initObject )
				{
					if( subject.hasOwnProperty( propName ) )
					{
						str += indent + "\t• " + propName + " :\t\t\t" + stringify( subject[ propName ], traceLevel + 1 ) + "\n";
					}
					else
					{
						trace( "\tERROR : unknown propName:" + propName + ":" );
					}
				}
			}
			return( str );
		}

		public static function stringify( subject : *, traceLevel : int = 0 ) : String
		{
			// trace( CN + ".stringify" );
			var indent : String = getIndent( traceLevel );
			var classname : String = getQualifiedClassName( subject );
			var str : String = "";

			switch( true )
			{
				case (	subject == null || subject is Number || subject is int || subject is String || subject is Boolean ) :
					str = String( subject );
					break;
				case ( classname == "Object" || classname == "flash.display::MovieClip" || subject is URLVariables ) :
					var p : String;
					var innerIndent : String;
					for( p in subject )
					{
						switch( true )
						{
							case ( p.length < 4 ) :
								innerIndent = "\t\t\t";
								break;
							case ( p.length > 12 ) :
								innerIndent = "\t";
								break;
							default :
								innerIndent = "\t\t";
						}
						str += "\n" + indent + "\t• " + p + " :" + innerIndent + stringify( subject[ p ], traceLevel + 1 );
					}
					break;
				case ( ( classname.indexOf( '__AS3__.vec::Vector' ) == 0 ) ) :
				case ( subject is Array ) :
					var i : int;
					for( i = 0; i < subject.length; i++ )
					{
						str += stringify( subject[ i ], traceLevel );
					}
					break;
				case ( subject.toString is Function ) :
					if( subject.toString.length > 0 )
					{
						str = String( subject.toString( traceLevel ) );
					}
					else
					{
						trace( "stringify can't pass a param to this 'toString' function." );
						str = String( subject.toString() );
					}
					break;
				default :
					str = String( subject );
			}

			return str;
		}

		public static function getIndent( listLevel : int ) : String
		{
			var tab : String = "";
			var i : int;

			for( i = 0; i < listLevel; i++ )
			{
				tab += "\t";
			}

			return tab;
		}

		public static function getPrettyJSON( objectToStringify : Object, isDebug : Boolean = false ) : String
		{
			var prettyJSON : String = "{ \"errorMessageFromStringService\":\"No Bridge.\" }";
			//prettyJSON = Bridge.getPrettyJSON( objectToStringify, isDebug );
			return prettyJSON;
		}
	}
}
