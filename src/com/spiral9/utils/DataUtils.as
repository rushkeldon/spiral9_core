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

	import flash.utils.describeType;

	public class DataUtils
	{
		public static const CN : String = "DataUtils[2014_03_15_12_45]";
		public static var typeDescriptions : Object;


		public static function initFromObject( instance : *, initObject : Object ) : void
		{
			//trace( CN + ".initFromObject" );
			if( instance == null || initObject == null ) { trace( "ERROR : " + CN + ".initFromObject received a null." ); return; }

			var propName : String;
			var instanceClassName : String = getSimpleClassName( instance );
			var success : Boolean;

			//trace( "\tinstanceClassName:" + instanceClassName + ":" );

			for( propName in initObject )
			{
				success = assignPropByName( instance, initObject, propName );

				if( !success )
				{
					trace( "WARNING : " + CN + ".initFromObject propName:" + propName + ": NOT assigned." );
				}
			}
		}


		private static function assignPropByName( instance : *, initObject : Object, propName : String ) : Boolean
		{
			//trace( CN + ".assignPropByName propName :" + propName + ":" );
			var changedPropName : String = "";
			var assignPropName : String;

			if( instance == null || initObject == null || propName == null ){ trace( CN + ".assignPropByName passed a null." ); return false; }

			// TODO : this toggling of case is hokey and here only for instaLegacy that Keldon ASKED Kyle for...

			var instanceHasProp : Boolean = DataUtils.hasProp( instance, propName, true );

			if( !instanceHasProp )
			{
				changedPropName = toggleCap( propName );
				instanceHasProp = DataUtils.hasProp( instance, changedPropName, true );

				if( !instanceHasProp )
				{
					trace( "WARNING : no prop of name :" + propName + ": capital or lower cased." );
					return false;
				}
			}

			assignPropName = ( changedPropName != "" ) ? changedPropName : propName;

			if( hasSetter( instance, assignPropName ) || isPropSimpleType( instance, assignPropName ) )
			{
				instance[ assignPropName ] = initObject[ propName ];
				return true;
			}
			trace( "WARNING : DataUtils.hasProp reports that instance :" + instance + ": DOES NOT have this property :" + propName + ":" );
			return false;
		}

		public static function getTypeDescription( instance : * ) : XML
		{
			//trace( CN + ".getTypeDescription" );

			var key : String = getSimpleClassName( instance );

			switch( true )
			{
				case ( typeDescriptions == null ) :
					typeDescriptions = new Object();
					typeDescriptions[ key ] = describeType( instance );
					break;
				case ( typeDescriptions[ key ] == null ) :
					typeDescriptions[ key ] = describeType( instance );
					break;
				case ( typeDescriptions[ key ] != null ) :
					// do nothing
					break;
				default :
					trace( "\tERROR : unhandled case DataUtils.getTypeDescription." );
					break;
			}

			return typeDescriptions[ key ] as XML;
		}

		public static function hasSetter( instance : *, propName : String ) : Boolean
		{
			//trace( CN + ".hasSetter" );

			var desc : XML = getTypeDescription( instance );
			var access : String = desc.accessor.(@name == propName).@access.toString();
			return ( access.indexOf( "write" ) > -1 );
		}

		public static function hasGetter( instance : *, propName : String ) : Boolean
		{
			//trace( CN + ".hasGetter" );

			var desc : XML = getTypeDescription( instance );
			var access : String = desc.accessor.(@name == propName).@access.toString();
			return ( access.indexOf( "read" ) > -1 );
		}

		private static function toggleCap( propName : String ) : String
		{
			//trace( CN + ".toggleCap" );
			//trace( "\tpropName:" + propName + ":" );

			var toggledPropName : String = propName;
			var firstChar : String = propName.charAt( 0 );
			var restOfPropName : String = propName.substring( 1, propName.length );
			var lowerCase : String = firstChar.toLowerCase();
			var upperCase : String = firstChar.toUpperCase();

			switch( true )
			{
				case ( firstChar != lowerCase ) :
					toggledPropName = lowerCase + restOfPropName;
					break;
				case ( firstChar != upperCase ) :
					toggledPropName = upperCase + restOfPropName;
					break;
				default :
					trace( "\tERROR : the first character of this property is not an alpha char? firstChar:" + firstChar + ":" )
			}

			//trace( CN + ".toggleCap is returning toggledPropName:" + toggledPropName + ":" );
			return toggledPropName;
		}

		public static function hasProp( propOwner : Object, propName : String, acceptNull : Boolean = false ) : Boolean
		{
			//trace( CN + ".hasProp" );
			//trace( "\tpropName:" + propName + ":" );

			var assignProp : Boolean = false;

			if( propOwner.hasOwnProperty( propName ) )
			{
				assignProp = true;
				if( !acceptNull )
				{
					assignProp = ( propOwner[ propName ] != null );
				}
			}
			return assignProp;
		}

		public static function isSimpleType( subject : * ) : Boolean
		{
			//trace( CN + ".isSimpleType" );
			//trace( "\tpropName:" + propName + ":" );

			var isSimple : Boolean = false;

			switch( true )
			{
				case ( subject == null ) :
					trace( "WARNING: " + CN + ".isSimpleType is returning 'true' for null." );
					isSimple = true;
					break;
				case ( subject is int ) :
				case ( subject is uint ) :
				case ( subject is Number ) :
				case ( subject is String ) :
				case ( subject is Boolean ) :
				case ( subject is Array ) :
				case ( getSimpleClassName( subject ) == "Object" ) :
					isSimple = true;
					break;
				default :
					trace( CN + ".isSimpleType doesn't have the type of this subject :" + subject + ": registered as simple." );
					break;
			}
			return isSimple;
		}

		public static function isPropSimpleType( instance : *, propName : String ) : Boolean
		{
			var isSimple : Boolean = false;
			var desc : XML = getTypeDescription( instance );
			var type : String = desc.variable.(@name == propName).@type.toString();
			//trace( CN + ".isPropSimpleType says type:" + type + ":" );

			switch( type )
			{
				case "" :
					trace( CN + ".isPropSimpleType didn't find a variable with the name :" + propName + ":" );
					break;
				case "int" :
				case "uint" :
				case "Number" :
				case "String" :
				case "Boolean" :
				case "Array" :
				case "Object" :
					isSimple = true;
					break;
			}
			//trace( CN + ".isPropSimpleType reports:" + isSimple + ":" );
			return isSimple;
		}

		public static function isVector( test : * ) : Boolean
		{
			return ( test is Vector.<*> ||
					test is Vector.<Number> ||
					test is Vector.<int> ||
					test is Vector.<uint> );
		}

		public static function getClass( instance : * ) : Class
		{
			var theClass : Class;

			try
			{
				theClass = Object( instance ).constructor as Class;
			}
			catch( e : Error )
			{
				trace( CN + ".getClass ERROR :\n" + e );
			}

			return theClass;
		}

		public static function getSimpleClassName( instance : * ) : String
		{
			var className : String;

			switch( true )
			{
				case ( instance is Class ) :
					className = String( getClass( new instance() ) );
					break;
				default :
					className = String( getClass( instance ) );
			}
			className = className.substring( 7, className.length - 1 );
			//trace( CN + ".getSimpleClassName says className:" + className + ":" );
			return( className );
		}

		public static function transferProp( initObject : Object, targetObject : Object, propName : String ) : void
		{
			if( hasProp( initObject, propName ) ){ targetObject[ propName ] = initObject[ propName ]; }
		}
	}
}
