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
package com.spiral9.data.media
{
	public interface IVisualMediaInfo extends IMediaInfo
	{
		function get width() : Number;
		function set width( width : Number ) : void;
		function get height() : Number;
		function set height( height : Number ) : void;
		function get type() : String;
		function set type( type : String ) : void;
	}
}
