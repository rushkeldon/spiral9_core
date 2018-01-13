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

	import by.blooddy.crypto.Base64;
	import com.adobe.serialization.json.JSON;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import flash.utils.describeType;


	public class Conversion
	{
		public static const CN : String = "Conversion";
		public static const DATA_TYPE_BOOLEAN : String = 	"boolean";
		public static const DATA_TYPE_FUNCTION : String = 	"function";
		public static const DATA_TYPE_NUMBER : String = 		"number";
		public static const DATA_TYPE_OBJECT : String = 		"object";
		public static const DATA_TYPE_STRING : String = 		"string";
		public static const DATA_TYPE_XML : String = 		"xml";
		public static const DATA_TRUE_STRING : String = 		"true";
		public static const DATA_NULL_STRING : String = "null";

		/*
		Array			object
		Boolean			boolean
		Function			function
		int				number
		Number			number
		Object			object
		String			string
		uint				number
		XML				xml
		XMLList			xml
		 */

		public static function toArray( iterable : * ) : Array
		{
			var array : Array = new Array();
			var e : *;
			for each( e in iterable )
			{
				array[ array.length ] = e;
			}
			return array;
		}

		public static function assignProp( initObject : Object, propName : String, defaultValue : * ) : *
		{
			//trace( "Conversion.assignProp" );
			if( initObject == null ){ initObject = new Object(); }

			var prop : *;
			var val : *;
			var dataType : String = typeof( defaultValue );

			if( defaultValue == null )
			{
				dataType = DATA_NULL_STRING;
			}

			if( initObject.hasOwnProperty( propName ) )
			{
				val = initObject[ propName ];
			}

			switch( true )
			{
				case ( initObject.hasOwnProperty( propName ) && typeof( val ) == dataType ) :
					prop = val;
					break;
				case ( initObject.hasOwnProperty( propName ) ) :
					switch( true )
					{
						case ( dataType == DATA_TYPE_NUMBER ) :
							prop = Number( val );
							break;
						case ( dataType == DATA_TYPE_STRING ) :
							prop = String( val );
							break;
						case ( dataType == DATA_TYPE_BOOLEAN ) :
							prop = ( val == DATA_TRUE_STRING );
							break;
						default :
							prop = val;
							break;
					}
					break;
				default :
					prop = defaultValue;
			}
			//trace( "\tprop:" + prop + ":" );
			//trace( "\ttypeof( prop ):" + typeof( prop ) + ":" );
			return( prop );
		}

		public static function infoToURLvars( info : *, infoClass : Class, propNames : Array = null, isDebug : Boolean = false ) : URLVariables
		{
			//trace( "Conversion.infoToURLvars" );
			//trace( "\tpropNames:" + propNames + ":" );

			var urlVars : URLVariables = new URLVariables();
			var defXML : XML = describeType( infoClass );
			var variable : XML;
			var propName : String;
			var shouldInclude : Boolean;
			var i : int;

			if( isDebug )
			{
				trace( defXML );
			}

			for each( variable in defXML.factory.variable )
			{
				//trace( "\tvariable.@name:" + variable.@name + ":" );
				shouldInclude = true;

				if( propNames != null )
				{
					shouldInclude = false;
					for( i=0; i<propNames.length; i++ )
					{
						propName = propNames[ i ];
						//trace( "\tpropName:" + propName + ":" );
						if( variable.@name == propName )
						{
							shouldInclude = true;
							//trace( "\tshould include." );
							break;
						}
					}
				}

				switch( String( variable.@type ).toLowerCase() )
				{
					case "string" :
					case "number" :
					case "int" :
					case "uint" :
					case "array" :
					case "boolean" :
						if( shouldInclude &&
							info[ variable.@name ] != null &&
							info[ variable.@name ] != "null" )
						{
							urlVars[ variable.@name ] = info[ variable.@name ];
						}
						else
						{
							//trace( "\tnot including: " + variable.@name + ":" );
						}
						break;
					default :
						//trace( "\tnot adding a non-simple type: " + variable.@name + ":" );
				}
			}

			// get from the source every time
			//urlVars.HWPID = HWPIDstore.HWPID;

			return( urlVars );
		}

		public static function objectToBase64json( obj : Object ) : String
		{
			var byteArray : ByteArray = new ByteArray();
			byteArray.position = 0;
			byteArray.writeUTF( com.adobe.serialization.json.JSON.encode( obj ) );
			byteArray.position = 0;
			return Base64.encode( byteArray );
		}

		public static function base64jsonToObject( encodedString : String ) : Object
		{
			var byteArray : ByteArray = Base64.decode( encodedString );
			return com.adobe.serialization.json.JSON.decode( byteArray.toString() );
		}

	}
}
