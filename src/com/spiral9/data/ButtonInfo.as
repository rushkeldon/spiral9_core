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

	import com.spiral9.utils.Conversion;
	import com.spiral9.utils.StringService;

	public class ButtonInfo
	{
		public static const CN : String = "ButtonInfo";
		private static const DEFAULT_LABEL : String = "";

		public var label : String;
		public var color : uint;
		public var actions : Array;

		public function ButtonInfo( initObject : Object = null ) : void
		{
			//trace( CN + " instantiated." );

			if( initObject != null )
			{
				label = Conversion.assignProp( initObject, "label", DEFAULT_LABEL );
				if( initObject.hasOwnProperty( "color" ) )
				{
					color = uint( String( initObject.color ).replace( new RegExp( /#/g ), "0x" ) );
				}
				if( initObject.hasOwnProperty( "actions" ) )
				{
					actions = initObject.actions;
				}
			}

			//trace( this );
		}

		public function toString( traceLevel : int = 0 ) : String
		{
			var indent : String = StringService.getIndent( traceLevel );
			var str : String = "\n" + indent + "ButtonInfo :\n";

			str += indent + "\t• label :\t\t" + String( label ) + "\n";
			str += indent + "\t• color :\t\t" + String( color ) + "\n";
			str += indent + "\t• actions :\t\t" + StringService.stringify( actions, traceLevel + 1 );
			return( str );
		}
	}
}
