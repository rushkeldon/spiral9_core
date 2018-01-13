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

	public class FUIDgen
	{

		public static function getFUID() : String
		{
			var i : int;
			var str : String = "";
			var coinFlip : int;

			for( i=0; i<21; i++ )
			{
				coinFlip = int( Math.random() * 10 );

				if( coinFlip % 2 == 0 )
				{
					str += getLetter();
				}
				else
				{
					str += getInt();
				}
			}
			return str;
		}

		private static function getInt() : int
		{
			return( Math.floor( Math.random() * 10 ) );
		}

		private static function getLetter() : String
		{
			return String.fromCharCode( Math.floor( Math.random() * ( 91 - 65 ) + 65 ) );
		}
	}
}
