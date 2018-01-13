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

	import com.greensock.BlitMask;
	import org.osflash.signals.natives.NativeSignal;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.StaticText;
	import flash.text.TextField;

	public class BitmapCache extends Sprite
	{

		public static var CN : String = "BitmapCache";
		private static var NO_ID : String = "noID";
		protected static var cachedBitmapDataObjects : Object = {};

		public static function cacheDisplayObject( displayObjectToCache : *, id : String = "noID",  maxScaleFactor : int = 2 ) : Sprite
		{
			trace( CN + ".cacheDisplayObject" );

			var bitmap : Bitmap;
			var bitmapDataObject : Object = cachedBitmapDataObjects[ id ];
			var bitmapData : BitmapData;
			var bounds : Rectangle;
			var displayObject : DisplayObject;
			var matrix : Matrix;
			var sprite : Sprite = new Sprite();

			if( bitmapDataObject == null )
			{
				switch( true )
				{
					case ( displayObjectToCache is Class ) :
						displayObject = new displayObjectToCache();
						break;
					case ( displayObjectToCache is DisplayObject ) :
						displayObject = displayObjectToCache;
						break;
					default :
						trace( "\tERROR : displayObjectToCache is an unhandled type :" + displayObjectToCache + ":" );
				}

				if( id == "noID" )
				{
					id = getIDforDisplayObject( displayObject );
				}

				bitmapDataObject = cachedBitmapDataObjects[ id ];

				if( bitmapDataObject == null )
				{
					matrix = new Matrix();
					bounds = displayObject.getBounds( displayObject );
					matrix.translate( -bounds.x, -bounds.y );
					matrix.scale( maxScaleFactor, maxScaleFactor );

					bitmapData = new BitmapData( bounds.width * maxScaleFactor, bounds.height * maxScaleFactor, true, 0 );
					bitmapData.draw( displayObject, matrix, null, null, null, true );
					cachedBitmapDataObjects[ id ] = { "bitmapData" : bitmapData, "maxScaleFactor" : maxScaleFactor };
				}
			}

			bitmap = new Bitmap( bitmapData, PixelSnapping.AUTO, true );
			// inversely scale bitmap
			bitmap.scaleX = bitmap.scaleY = 1 / maxScaleFactor;
			sprite.addChild( bitmap );
			//mouseChildren = false;

			return sprite;
		}

		/*
		function BlitMask(
			target : DisplayObject,
			x : Number = 0,
			y : Number = 0,
			width : Number = 100,
			height : Number = 100,
			smoothing : Boolean = false,
			autoUpdate : Boolean = false,
			fillColor : uint = 0,
			wrap : Boolean = false ) : void;
		 */

		public static function getBlitMask( displayObject : DisplayObject, shouldAutoUpdate : Boolean = false ) : BlitMask
		{
			var blitMask : BlitMask = new BlitMask(
				displayObject,
				displayObject.x,
				displayObject.y,
				displayObject.width,
				displayObject.height,
				true,
				shouldAutoUpdate );

			var forceUpdate : Function = function( e : Event ) : void { blitMask.update( null, true ); };
			new NativeSignal( displayObject, "onKeyFrame", Event ).add( forceUpdate );
			new NativeSignal( displayObject, Event.ADDED_TO_STAGE, Event ).add( forceUpdate );

			return blitMask;
			//TweenLite.to( content, 30, { x:-3000, onUpdate: bm.update });
		}

		public static function getSpriteByID( id : String ) : Sprite
		{
			var bitmapDataObject : Object = cachedBitmapDataObjects[ id ];
			var bitmap : Bitmap;
			var sprite : Sprite = new Sprite();

			if( bitmapDataObject != null )
			{
				bitmap = new Bitmap( bitmapDataObject.bitmapData, PixelSnapping.AUTO, true );
				// inversely scale bitmap
				bitmap.scaleX = bitmap.scaleY = 1 / bitmapDataObject.maxScaleFactor;
				sprite.addChild( bitmap );
			}
			return( sprite );
		}


		public static function getIDforDisplayObject( displayObject : DisplayObject ) : String
		{
			if( displayObject == null ){ return( NO_ID ); }

			var displayObjectName : String;
			var frameName : String;
			var className : String = DataUtils.getSimpleClassName( displayObject );

			switch( true )
			{
				case ( displayObject is MovieClip ) :
				case ( displayObject is Stage ) :
				case ( displayObject is Sprite ) :
				case ( displayObject is TextField ) :
				case ( displayObject is SimpleButton ) :
				case ( displayObject is Bitmap ) :
				case ( displayObject is Shape ) :
				case ( displayObject is StaticText ) :
					switch( true )
					{
						case (
						className != "MovieClip" &&
						className != "Stage" &&
						className != "Sprite" &&
						className != "TextField" &&
						className != "SimpleButton" &&
						className != "Bitmap" &&
						className != "Shape" &&
						className != "StaticText" ) :
							displayObjectName = className;
							break;
						case ( displayObject.name != null ) :
							displayObjectName = displayObject.name;
							break;
						default :
							displayObjectName = className;
					}

					if( displayObject is MovieClip )
					{
						switch( true )
						{
							case ( MovieClip( displayObject ).currentFrameLabel != null ) :
								frameName = MovieClip( displayObject ).currentFrameLabel;
								break;
							default :
								frameName = MovieClip( displayObject ).currentFrame.toString();
						}
					}
					else
					{
						frameName = "0";
					}
					break;
				default :
					trace( "\tERROR : unhandled case :" + displayObject + ":" );
					return( NO_ID );
			}

			return( displayObjectName + "_" + frameName );
		}

	}
}
