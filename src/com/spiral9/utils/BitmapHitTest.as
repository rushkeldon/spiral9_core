package com.spiral9.utils {
	//import com.spiral9.tests.CrossHair;

	import flash.display.Bitmap;
	import flash.geom.Point;

	public class BitmapHitTest
	{
		public static const CN : String = "BitmapHitTest";

		public static const ALPHA_THRESHOLD_90 : uint =  uint( .9 * 255 );
		public static const ALPHA_THRESHOLD_80 : uint =  uint( .8 * 255 );
		public static const ALPHA_THRESHOLD_75 : uint =  uint( .75 * 255 );
		public static const ALPHA_THRESHOLD_50 : uint = uint( .5 * 255 );
		public static const ALPHA_THRESHOLD_25 : uint = uint( .25 * 255 );
		public static const ALPHA_THRESHOLD_10 : uint = uint( .1 * 255 );
		public static const ALPHA_THRESHOLD_0 : uint = 0;

		public static function isPixelOpaque( bitmap : Bitmap, testPoint : Point, isPointGlobal : Boolean = true, alphaThreshold : int = -1 ) : Boolean
		{
			//trace( CN + ".isPixelOpaque" );

			var threshold : uint;
			var result : Boolean;
			if( alphaThreshold == -1 )
			{
				alphaThreshold = ALPHA_THRESHOLD_90;
			}
			threshold = uint( alphaThreshold );

			var pointOne : Point = new Point( 1, 1 );

			if( isPointGlobal )
			{
				testPoint = bitmap.globalToLocal( testPoint );
			}

			result = bitmap.bitmapData.hitTest( pointOne, threshold, testPoint );
			//trace( "\tresult:" + result + ":" );

			return( result );
		}
	}
}
