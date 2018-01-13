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

/**
 * http://stackoverflow.com/questions/6455574/why-isnt-stage-global/13944542#13944542
 **/

package com.spiral9.utils
{
	public class GlobalReference
	{
		public static function get global() : Object
		{
			var g : Function = function() : Object { return this; };
			return g();
		}
	}
}
