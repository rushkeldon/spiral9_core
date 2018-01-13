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
	public class ColorValues
	{
		private static var _clrs : Vector.<int>;

		public static const CLR_AQUA : int = 				0x33CCCC;
		public static const CLR_BLACK : int = 				0x000000;
		public static const CLR_BLUE : int = 				0x0000FF;
		public static const CLR_BLUE_BABY : int = 			0x99CCFF;
		public static const CLR_BLUE_CONFEDERATE : int = 	0x003366;
		public static const CLR_BLUE_LIGHT : int = 			0xCCFFFF;
		public static const CLR_BLUE_NAVY : int = 			0x000080;
		public static const CLR_BLUE_SKY : int = 			0x0066CC;
		public static const CLR_CYAN : int = 				0x00FFFF;
		public static const CLR_FLESH : int = 				0xFF8080;
		public static const CLR_GOLD : int = 				0xFFCC00;
		public static const CLR_GRAY_DARK : int = 			0x808080;
		public static const CLR_GRAY_LIGHT : int = 			0xC0C0C0;
		public static const CLR_GRSPIRAL9N : int = 				0x00FF00;
		public static const CLR_GRSPIRAL9N_FOREST : int = 		0x008000;
		public static const CLR_GRSPIRAL9N_LIGHT : int = 			0x99CC00;
		public static const CLR_GRSPIRAL9N_MOSS : int = 			0x339966;
		public static const CLR_GRSPIRAL9N_OLIVE : int = 			0x808000;
		public static const CLR_GRSPIRAL9N_PURPLE : int = 		0x800080;
		public static const CLR_GRSPIRAL9N_TURQUOISE : int = 		0x008080;
		public static const CLR_LAVENDER : int = 			0x9999FF;
		public static const CLR_LAVENDER2 : int = 			0xCC99FF;
		public static const CLR_LAVENDER_LIGHT : int = 		0xCCCCFF;
		public static const CLR_LIGHT_GRSPIRAL9N : int = 			0xCCFFCC;
		public static const CLR_MAGENTA : int = 				0xFF00FF;
		public static const CLR_MAROON : int = 				0x800000;
		public static const CLR_OCHRE_BURNT : int = 			0x993300;
		public static const CLR_ORANGE : int = 				0xFF9900;
		public static const CLR_ORANGE_BURNT : int = 		0xFF6600;
		public static const CLR_ORANGE_LIGHT : int = 		0xFFCC99;
		public static const CLR_PERIWINKLE : int = 			0x3366FF;
		public static const CLR_PINK : int = 				0xFF99CC;
		public static const CLR_PLUMB : int = 				0x993366;
		public static const CLR_PURPLE : int = 				0x333399;
		public static const CLR_RED : int = 					0xFF0000;
		public static const CLR_YELLOW : int = 				0xFFFF00;
		public static const CLR_YELLOW_BUTTER : int = 		0xFFFF99;

		public static const CLR_PORT_DROP_GOOD : int = 		0x00FF00;
		public static const CLR_PORT_DROP_BAD : int = 		0xFF0000;
		public static const CLR_DROPZONE : int =				0x800080;
		public static const ALPHA_DROPZONE : Number = 0;
		public static const CLR_DEFAULT_PORT_SELECTION : int = 0x119CC5;
		public static const CLR_STATUSFIELD_METER_OVERFILL : int = 0x00DB00;
		public static const CLR_STATUSFIELD_METER_NORMAL : int = 0xE36E09;

		public static function get ALL_CLRS() : Vector.<int>
		{
			if( _clrs == null )
			{
				_clrs = new Vector.<int>;

				_clrs.push( CLR_RED );
				_clrs.push( CLR_GRSPIRAL9N );
				_clrs.push( CLR_BLUE );
				_clrs.push( CLR_YELLOW );
				_clrs.push( CLR_MAGENTA );
				_clrs.push( CLR_BLACK );
				_clrs.push( CLR_CYAN );
				_clrs.push( CLR_MAROON );
				_clrs.push( CLR_GRSPIRAL9N_FOREST );
				_clrs.push( CLR_BLUE_NAVY );
				_clrs.push( CLR_GRSPIRAL9N_OLIVE );
				_clrs.push( CLR_GRSPIRAL9N_PURPLE );
				_clrs.push( CLR_GRSPIRAL9N_TURQUOISE );
				_clrs.push( CLR_GRAY_LIGHT );
				_clrs.push( CLR_GRAY_DARK );
				_clrs.push( CLR_LAVENDER );
				_clrs.push( CLR_PLUMB );
				_clrs.push( CLR_BLUE_LIGHT );
				_clrs.push( CLR_FLESH );
				_clrs.push( CLR_BLUE_SKY );
				_clrs.push( CLR_LAVENDER_LIGHT );
				_clrs.push( CLR_LIGHT_GRSPIRAL9N );
				_clrs.push( CLR_YELLOW_BUTTER );
				_clrs.push( CLR_BLUE_BABY );
				_clrs.push( CLR_PINK );
				_clrs.push( CLR_LAVENDER2 );
				_clrs.push( CLR_ORANGE_LIGHT );
				_clrs.push( CLR_PERIWINKLE );
				_clrs.push( CLR_AQUA );
				_clrs.push( CLR_GRSPIRAL9N_LIGHT );
				_clrs.push( CLR_GOLD );
				_clrs.push( CLR_ORANGE );
				_clrs.push( CLR_ORANGE_BURNT );
				_clrs.push( CLR_BLUE_CONFEDERATE );
				_clrs.push( CLR_GRSPIRAL9N_MOSS );
				_clrs.push( CLR_OCHRE_BURNT );
				_clrs.push( CLR_PURPLE );
				// repeat
				_clrs.push( CLR_BLACK );
				_clrs.push( CLR_RED );
				_clrs.push( CLR_GRSPIRAL9N );
				_clrs.push( CLR_BLUE );
				_clrs.push( CLR_YELLOW );
				_clrs.push( CLR_MAGENTA );
				_clrs.push( CLR_CYAN );
				_clrs.push( CLR_MAROON );
				_clrs.push( CLR_GRSPIRAL9N_FOREST );
				_clrs.push( CLR_BLUE_NAVY );
				_clrs.push( CLR_GRSPIRAL9N_OLIVE );
				_clrs.push( CLR_GRSPIRAL9N_PURPLE );
				_clrs.push( CLR_GRSPIRAL9N_TURQUOISE );
				_clrs.push( CLR_GRAY_LIGHT );
				_clrs.push( CLR_GRAY_DARK );
				_clrs.push( CLR_LAVENDER );
				_clrs.push( CLR_PLUMB );
				_clrs.push( CLR_BLUE_LIGHT );
				_clrs.push( CLR_FLESH );
				_clrs.push( CLR_BLUE_SKY );
				_clrs.push( CLR_LAVENDER_LIGHT );
				_clrs.push( CLR_LIGHT_GRSPIRAL9N );
				_clrs.push( CLR_YELLOW_BUTTER );
				_clrs.push( CLR_BLUE_BABY );
				_clrs.push( CLR_PINK );
				_clrs.push( CLR_LAVENDER2 );
				_clrs.push( CLR_ORANGE_LIGHT );
				_clrs.push( CLR_PERIWINKLE );
				_clrs.push( CLR_AQUA );
				_clrs.push( CLR_GRSPIRAL9N_LIGHT );
				_clrs.push( CLR_GOLD );
				_clrs.push( CLR_ORANGE );
				_clrs.push( CLR_ORANGE_BURNT );
				_clrs.push( CLR_BLUE_CONFEDERATE );
				_clrs.push( CLR_GRSPIRAL9N_MOSS );
				_clrs.push( CLR_OCHRE_BURNT );
				_clrs.push( CLR_PURPLE );
			}
			return _clrs;
		}
	}
}
