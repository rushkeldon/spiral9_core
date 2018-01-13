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
	public class ArrayUtils
	{

		public static function shuffle( a : Array ) : void
		{
			a.sort( randomSort );
		}

		public static function randomSort( m0 : *, m1 : * ) : int
		{
			return Math.random() - .5;

			//return Math.round( Math.random() * 2 ) - 1;
		}

		public static function containsByString( arrayToCheck : Array, stringToCheck : String ) : Boolean
		{
			if( arrayToCheck == null ){ trace( "\tERROR : arrayToCheck == null" ); return false; }
			if( stringToCheck == "" ){ trace( "\tERROR : stringToCheck == \"\"" ); return false; }

			var arrayStr : String = arrayToCheck.toString();
			return( arrayStr.indexOf( "," + stringToCheck + "," ) != -1 );
		}
	}
}
