package com.spiral9.utils
{

	import by.blooddy.crypto.Base64;
	import by.blooddy.crypto.image.JPEGEncoder;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	//import com.spiral9.tests.CrossHair;


	public class BitmapUtil
	{
		public static const CN : String = "BitmapUtil";

		public static const ALPHA_THRESHOLD_90 : uint =  	uint( .9 * 255 );
		public static const ALPHA_THRESHOLD_80 : uint =  	uint( .8 * 255 );
		public static const ALPHA_THRESHOLD_75 : uint =  	uint( .75 * 255 );
		public static const ALPHA_THRESHOLD_50 : uint = 		uint( .5 * 255 );
		public static const ALPHA_THRESHOLD_25 : uint = 		uint( .25 * 255 );
		public static const ALPHA_THRESHOLD_10 : uint = 		uint( .1 * 255 );
		public static const ALPHA_THRESHOLD_0 : uint = 		0;
		public static const ENCODING_BASE_64 : String = 	"encodingBase64";

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

		public static function getMonoChromeBitmapDataClone( sourceBitmapData : BitmapData, mono_color : uint = 0xFF000000 ) : BitmapData
		{
			var bitmapData : BitmapData = sourceBitmapData.clone();
			bitmapData.threshold( bitmapData, bitmapData.rect, new Point(), ">", 0x00000000, mono_color );
			return bitmapData;
		}

		public static function captureBitmap( targetDisplayObject : DisplayObject, desiredReturn : Class ) : *
		{
			var stage : Stage = StageReference.stage;
			var bounds : Rectangle = new Rectangle( -( Math.floor( targetDisplayObject.x ) ), -( Math.floor( targetDisplayObject.y ) ), stage.stageWidth, stage.stageHeight );//targetDisplayObject.getBounds( stage );
			var bitmapData : BitmapData = new BitmapData( stage.stageWidth, stage.stageHeight, false, 0 );
			bitmapData.draw( targetDisplayObject, new Matrix( 1, 0, 0, 1, bounds.x, bounds.y ) );

			switch( desiredReturn )
			{
				case ( ByteArray ) :
					return bitmapData.getPixels( bitmapData.rect );
					break;
				case ( BitmapData ) :
					return bitmapData;
					break;
				default :
					return new Bitmap( bitmapData, "auto", true );
					break;
			}

			stage = null;
			bounds = null;
			bitmapData = null;
		}

		public static function getScreenshot( initObject : Object = null ) : *
		{
			var stage : Stage = StageReference.stage;
			var targetDisplayObject : DisplayObject;
			var boundsRect : Rectangle;
			var quality : int = Conversion.assignProp( initObject, "quality", 0 );				// only used for JPEG
			var encoding : String = Conversion.assignProp( initObject, "encoding", "" );			// only used for Base64
			var blurDistance : Number = Conversion.assignProp( initObject, "blurDistance", 0 );
			var scaleFactor : Number = Conversion.assignProp( initObject, "scaleFactor", 1 );

			if( initObject.hasOwnProperty( targetDisplayObject ) )
			{
				targetDisplayObject = initObject.targetDisplayObject as DisplayObject;
				boundsRect = targetDisplayObject.getBounds( stage );
			}
			else
			{
				targetDisplayObject = stage;
				boundsRect = stage.getBounds( stage );
			}

			var bitmapData : BitmapData;
			var blurFilter : BlurFilter;
			var jpgBytes : ByteArray;
			var matrix : Matrix;
			var imgStr : String;

			if( blurDistance != 0 )
			{
				blurFilter = new BlurFilter( blurDistance, blurDistance, BitmapFilterQuality.HIGH );
			}

			matrix = new Matrix( scaleFactor, 0, 0, scaleFactor, boundsRect.x * -1, boundsRect.y * -1 );
			bitmapData = new BitmapData( stage.stageWidth * scaleFactor, stage.stageHeight * scaleFactor, true, 0 );
			bitmapData.draw( targetDisplayObject, matrix );

			if( blurFilter != null )
			{
				bitmapData.applyFilter( bitmapData, bitmapData.rect, new Point( 0, 0 ), blurFilter );
			}

			if( quality > 0 )
			{
				jpgBytes = JPEGEncoder.encode( bitmapData, quality );
			}

			if( jpgBytes != null && encoding == ENCODING_BASE_64 )
			{
				imgStr = Base64.encode( jpgBytes );
			}
			else if( encoding == ENCODING_BASE_64 )
			{
				imgStr = Base64.encode( bitmapData.getPixels( new Rectangle( 0, 0, bitmapData.width, bitmapData.height ) ) );
			}

			switch( true )
			{
				case ( imgStr != null ) :
					return imgStr;
				case ( jpgBytes != null ) :
					return jpgBytes;
			}

			return bitmapData;
		}

		public static function drawBitmap( container : Sprite, bitmap : Bitmap, rect : Rectangle = null ) : void
		{
			if( container == null || bitmap == null )
			{
				trace( "\tERROR : " + CN + ".drawBitmap has encountered a null container or bitmap." );
				trace( "\tcontainer:" + container + ":" );
				trace( "\tbitmap:" + bitmap + ":" );
				return;
			}
			var bitmapData : BitmapData = bitmap.bitmapData;
			if( rect == null )
			{
				rect = new Rectangle( 0, 0, bitmapData.width, bitmapData.height );
			}
			container.graphics.beginBitmapFill( bitmap.bitmapData, null, true, true );
			container.graphics.drawRect( rect.x, rect.y, rect.width, rect.height );
			container.graphics.endFill();
		}
	}
}
