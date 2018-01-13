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

	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.motionPaths.LinePath2D;
	import com.spiral9.ux.Buttonizer;
	import com.spiral9.ux.ButtonizerVars;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;

	public class Alignment
	{
		public static var CN : String = "Alignment";

		/**
		* Distributes displayObjects across a linePath2D
		*
		* @param displayObjects : Array -- the DisplayObjects to be distributed
		* @param autoRotate : Boolean   -- should the DisplayObjects to oriented perpindicular to the linePath
		* @param linePath : LinePath2D  -- the line to distribute DisplayObjects across
		* @see LinePath2D
		* @return
		*/
		public static function distribute( displayObjects : Array, linePath : LinePath2D = null, autoRotate : Boolean = false ) : void
		{
			// trace( CN + ".distribute" );

			if( displayObjects == null ){ /* trace( "\tERROR : displayObjects == null" );*/ return; }
			if( displayObjects.length < 2 ){ /* trace( "\tERROR : displayObjects.length < 2" );*/ return; }

			var firstDisplayObject : DisplayObject = displayObjects[ 0 ];
			var lastDisplayObject : DisplayObject = displayObjects[ displayObjects.length - 1 ];
			var container : DisplayObjectContainer = firstDisplayObject.parent as DisplayObjectContainer;

			if( linePath == null )
			{
				var startPoint : Point = new Point(
					firstDisplayObject.x,
					firstDisplayObject.y
				);
				var endPoint : Point = new Point(
					lastDisplayObject.x,// + lastDisplayObject.width,
					lastDisplayObject.y
				);

				linePath = new LinePath2D( [ startPoint, endPoint ] );//, x, y, autoUpdatePoints );
				// trace( "\tlinePath:" + linePath + ":" );
			}

			if( linePath != null )
			{
				if( container != null )
				{
					// for debug
					//container.addChild( linePath );
				}
				linePath.distribute( displayObjects, 0, 1, autoRotate );
			}
		}
	}
}
