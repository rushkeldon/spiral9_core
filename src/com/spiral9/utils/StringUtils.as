package com.spiral9.utils
{
	public class StringUtils
	{
		public static const NEWLINE_TOKENS : Array = new Array( '\n', '\r' );
		public static const WHITESPACE_TOKENS : Array = new Array( ' ', '\t' );
		public static const EMPTY_STRING : String = "";


		public static function count( haystack : String, needle : String, offset : Number = 0, length : Number = 0 ) : Number
		{
			if( length === 0 )
			{
				length = haystack.length;
			}
			var result : Number = 0;
			haystack = haystack.slice( offset, length );
			while( haystack.length > 0 && haystack.indexOf( needle ) != -1 )
			{
				haystack = haystack.slice( ( haystack.indexOf( needle ) + needle.length ) );
				result++;
			}
			return result;
		}

		public static function trim( str : String, charList : Array = null ) : String
		{
			var list : Array;

			if( charList )
			{
				list = charList;
			}
			else
			{
				list = WHITESPACE_TOKENS.concat( NEWLINE_TOKENS );
			}

			str = trimLeft( str, list );
			str = trimRight( str, list );

			return str;
		}

		public static function trimLeft( str : String, charList : Array = null ) : String
		{
			var list : Array;
			if( charList )
				list = charList;
			else
				list = WHITESPACE_TOKENS.concat( NEWLINE_TOKENS );

			while( list.toString().indexOf( str.substr( 0, 1 ) ) > -1 && str.length > 0 )
			{
				str = str.substr( 1 );
			}
			return str;
		}

		public static function trimRight( str : String, charList : Array = null ) : String
		{
			var list : Array;
			if( charList )
				list = charList;
			else
				list = WHITESPACE_TOKENS.concat( NEWLINE_TOKENS );

			while( list.toString().indexOf( str.substr( str.length - 1 ) ) > -1 && str.length > 0)
			{
				str = str.substr( 0, str.length - 1 );
			}
			return str;
		}

		public static function parsePaddedInt( str : String ) : Number
		{
			for( var i : Number = 0; i < str.length; i++ )
			{
				var c : String = str.charAt( i );
				if( c != "0" ) break;
			}

			return Number( str.substr( i ) );
		}
		

		public static function objectToPrettyJSON( initObject : Object, indent : Object = 3, shouldTrace : Boolean = false ) : String
		{
			var msg : String = JSON.stringify( initObject, null, indent );
			
			if( shouldTrace )
			{
				trace( msg );
			}
			return msg;
		}
	}
}
