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

	import flash.display.MovieClip;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	// import fl.text.TLFTextField;

	public class ContextMenuHWP
	{
		private static const CN : String = "ContextMenuHWP";

		public var TCMText : *;
		private static var _instance : ContextMenuHWP;
		private static var _allowInstance : Boolean = false;
		private static var _contextMenu : ContextMenu;

		public function ContextMenuHWP( documentClassInstance : MovieClip, newItems : Array )
		{
			if( _allowInstance )
			{
				trace( CN + " instantiated." );

				var i : int;
				var item : *;
				var customItems : Array = new Array();
				//TLFTextField
				_contextMenu = new ContextMenu();
				_contextMenu.hideBuiltInItems();

				for( i=0; i<newItems.length; i++ )
				{
					item = newItems[ i ];

					switch( true )
					{
						case ( item is String ) :
							customItems.push( new ContextMenuItem( item ) );
							break;
						case ( item is ContextMenuItem ) :
							customItems.push( item );
							break;
					}
				}

				_contextMenu.customItems = customItems;
				documentClassInstance.contextMenu = _contextMenu;
			}
			else
			{
				throw new Error( "singleton" );
			}
		}

		public static function init( documentClassInstance : MovieClip, newItems : Array ) : void
		{
			if( _instance == null )
			{
				_allowInstance = true;
				_instance = new ContextMenuHWP( documentClassInstance, newItems );
				_allowInstance = false;
			}
		}
	}
}
