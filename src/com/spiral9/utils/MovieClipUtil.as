package com.spiral9.utils
{

	import org.osflash.signals.Signal;
	import flash.events.Event;
	import org.osflash.signals.natives.NativeSignal;

	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.Scene;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;

	public class MovieClipUtil
	{
		public static const CN : String = "MovieClipUtil";

		public static const FRAME_LABEL_UP : String =            "_up";
		public static const FRAME_LABEL_OVER : String =          "_over";
		public static const FRAME_LABEL_DOWN : String =          "_down";
		public static const FRAME_LABEL_HIT : String =           "_hit";
		public static const FRAME_LABEL_DISABLED : String =      "_disabled";
		public static const FRAME_LABEL_DISMISSED : String =     "dismissed";
		public static const FRAME_LABEL_DISPLAYED : String =     "displayed";
		public static const FRAME_LABEL_INTRO : String =         "intro";
		public static const FRAME_LABEL_MAXIMIZED : String =     "maximized";
		public static const FRAME_LABEL_MINIMIZED : String =     "minimized";
		public static const FRAME_LABEL_OUTRO : String =         "outro";
		public static const ON_KEYFRAME : String =               "onKeyFrame";

		public static var lastFrameLabels : Array;

		public static function addFrameScript( mc : MovieClip, frameID : *, functionToAdd : Function ) : Boolean
		{
			var frameNum : int;
			switch( true )
			{
				case ( frameID is String ) :
					frameNum = getFrameNumByLabel( mc, frameID ) - 1;
					break;
				case ( frameID is int ) :
					frameNum = frameID - 1;
					break;
				default :
					trace( "\tERROR : the frameID was not a String or an int." );
					return false;
			}
			if( frameNum < 0 ){ trace( "\tERROR : frameNum is less than 0." ); return false; }
			mc.addFrameScript( frameNum, functionToAdd );
			return true;
		}

		/**
		 * Every keyframe with a label in the 'mc' MovieClip will dispatch a Signal
		 * with a reference to the MovieClip and the name of the keyframe.
		 **/
		public static function getNamedKeyFramesSignal( mc : MovieClip ) : Signal
		{
			trace( CN + ".getKeyFrameSignal" );

			if( mc == null ){ trace( "\tERROR : mc == null" ); return null; }

			var frameLabel : FrameLabel;
			// start listening for our custom event 'onKeyFrame'
			var nativeSignal : NativeSignal = new NativeSignal( mc, ON_KEYFRAME, Event );
			// the signal to return - and that eventHandler will dispatch
			var signal : Signal = new Signal( MovieClip, String );
			// the function that will handle the event via the nativeSignal
			var eventHandler : Function = function( e : Event ) : void
			{
				// dispatch a simple Signle with a reference to the MovieClip and its currentFrameLabel
				signal.dispatch( e.target, String( MovieClip( e.target ).currentFrameLabel ) );
			};
			nativeSignal.add( eventHandler );

			var frameScript : Function = function() : void
			{
				// make sure that it bubbles up the display list
				mc.dispatchEvent( new Event( ON_KEYFRAME, true ) );
			};

			for each( frameLabel in mc.currentLabels )
			{
				mc.addFrameScript( frameLabel.frame - 1, frameScript );
			}
			return signal;
		}

		public static function buttonize( mc : MovieClip, isUsingHandCursor : Boolean = false ) : void
		{
			if( getFrameNumByLabel( mc, FRAME_LABEL_UP ) != -1 )
			{
				mc.gotoAndStop( FRAME_LABEL_UP );
			}

			mc.buttonMode = true;
			mc.mouseChildren = false;
			mc.useHandCursor = isUsingHandCursor;
		}

		public static function addDropShadow( mc : MovieClip, dropShadowFilter : DropShadowFilter = null ) : void
		{
			if( mc == null ){ trace( CN + ".addDropShadow received a null MovieClip. - returning." ); return; }
			var existingFilters : Array = mc.filters;
			var newFilters : Array = new Array();
			var filter : *;
			var i : int;

			// if none supplied then let's create the default one
			if( dropShadowFilter == null )
			{
				dropShadowFilter = new DropShadowFilter();

				dropShadowFilter.distance = 3;
				dropShadowFilter.angle = 45;
				dropShadowFilter.color = 0;				// black
				dropShadowFilter.alpha = 1;
				dropShadowFilter.blurX = 3;
				dropShadowFilter.blurY = 3;
				dropShadowFilter.strength = 0.5;
				dropShadowFilter.quality = 1;
				dropShadowFilter.inner = false;
				dropShadowFilter.knockout = false;
				dropShadowFilter.hideObject = false;
			}

			for( i=0; i < existingFilters.length; i++ )
			{
				filter = existingFilters[ i ];
				if( !( filter is DropShadowFilter ) )
				{
					newFilters.push( filter );
				}
			}

			newFilters.push( dropShadowFilter );
			mc.filters = newFilters;
		}

		public static function removeDropShadow( mc : MovieClip ) : void
		{
			var existingFilters : Array = mc.filters;
			var newFilters : Array = new Array();
			var filter : *;
			var i : int;

			for( i=0; i < existingFilters.length; i++ )
			{
				filter = existingFilters[ i ];
				if( !( filter is DropShadowFilter ) )
				{
					newFilters.push( filter );
				}
			}

			mc.filters = newFilters;
		}

		public static function buttonizeWithNativeSignal( mc : MovieClip, isUsingHandCursor : Boolean = false ) : NativeSignal
		{
			if( getFrameNumByLabel( mc, FRAME_LABEL_UP ) != -1 )
			{
				mc.gotoAndStop( FRAME_LABEL_UP );
			}
			mc.buttonMode = true;
			mc.mouseChildren = false;
			mc.useHandCursor = isUsingHandCursor;
			return( new NativeSignal( mc, MouseEvent.CLICK, MouseEvent ) );
		}

		public static function setRolloverSignals( mc : MovieClip, rollOverListener : Function = null, rollOutListener : Function = null ) : void
		{
			mc.signalRollOver = new NativeSignal( mc, MouseEvent.ROLL_OVER, MouseEvent );
			mc.signalRollOut = new NativeSignal( mc, MouseEvent.ROLL_OUT, MouseEvent );

			if( rollOverListener != null ){ mc.signalRollOver.add( rollOverListener ); }
			if( rollOutListener != null ){ mc.signalRollOut.add( rollOutListener ); }
		}

		public static function getFrameNumByLabel( mc : MovieClip, frameLabel : String ) : int
		{
			//trace( CN + ".getFrameNumByLabel" );
			//trace( "\tframeLabel:" + frameLabel + ":" );

			if( mc == null ){ trace( "\tERROR : " + CN + ".getFrameNumByLabel got a null MovieClip passed in." ); return -1; }

			var frameNum : int = -1;
			var labels : Array = Scene( mc.currentScene ).labels;
			var foundFrameLabel : FrameLabel;

			for each( foundFrameLabel in labels )
			{
				//trace( "\tfoundFrameLabel.name:" + foundFrameLabel.name + ":" );
				if( foundFrameLabel.name == frameLabel )
				{
					frameNum = foundFrameLabel.frame;
					break;
				}
			}
			return frameNum;
		}

		public static function getVisibleBounds( mc : MovieClip ) : Rectangle
		{
			if( mc == null ) { return null; }

			// Get the bounds of the source object with respect to itself
			// so as to calculate the registration point offset.
			var visibleBounds    : Rectangle;
			var bounds           : Rectangle;
			var bitmapData       : BitmapData;
			var matrix           : Matrix;

			bounds = mc.getBounds( mc );
			var clipRectangle : Rectangle = new Rectangle( bounds.x, bounds.y, bounds.width, bounds.height );

			//Translate the bounds x,y coordinates so that it will clip even source objec
			matrix = new Matrix();
			matrix.translate( -clipRectangle.x, -clipRectangle.y );

			//Create the bitmap data
			bitmapData = new BitmapData( clipRectangle.width, clipRectangle.height, true, 0x00000000 );
			//Draw the item, including the translation
			bitmapData.draw( mc, matrix, null, null, new Rectangle( 0,0, clipRectangle.width, clipRectangle.height ) );

			visibleBounds = bitmapData.getColorBoundsRect( 0xFFFFFFFF, 0x000000, false );
			bitmapData.dispose();

			visibleBounds.x += clipRectangle.x;
			visibleBounds.y += clipRectangle.y;

			return visibleBounds;
		}

		// assumes that the refWidth is from the same reference 0,0
		public static function centerHorizontally( mc : DisplayObject, coordWidth : Number, useWidth : Number = 0 ) : void
		{
			if( !( mc is DisplayObject ) || !( coordWidth is Number ) ) { return; }

			var mcWidth : Number = ( useWidth <= 0 ) ? mc.width : useWidth;

			switch( true )
			{
				case ( coordWidth > mcWidth ) :
					mc.x = Math.ceil( ( coordWidth - mcWidth ) * 0.5 );
					break;
				case ( coordWidth < mcWidth ) :
					mc.x = Math.ceil( ( mcWidth - coordWidth ) * -0.5 );
					break;
				default :
					mc.x = 0;
					break;
			}
		}

		// assumes that the refHeight is from the same reference 0,0
		public static function centerVertically( mc : DisplayObject, refHeight : Number, useHeight : Number = 0 ) : void
		{
			// trace( CN + ".centerVertically" );
			if( !( mc is DisplayObject ) || !( refHeight is Number ) ){ return; }

			var mcHeight : Number = ( useHeight <= 0 ) ? mc.height : useHeight;

			switch( true )
			{
				case ( refHeight > mcHeight ) :
					mc.y = Math.ceil( ( refHeight - mcHeight ) * 0.5 );
					break;
				case ( refHeight < mcHeight ) :
					mc.y = Math.ceil( ( mcHeight - refHeight ) * -0.5 );
					break;
				default :
					mc.y = 0;
					break;
			}
		}

		public static function traceFrameLabels( mc : MovieClip ) : void
		{
			//trace( CN + ".traceFrameLabels :" );

			var i : int;
			var labels : Array = mc.currentScene.labels;

			lastFrameLabels = new Array();

			for( i = 0; i < labels.length ; i++ )
			{
				lastFrameLabels.push( labels[ i ].name );
				//trace( "\t\tcase : \"" + labels[ i ].name + "\" :\n\t\t\tbreak;\n" );
			}
		}

		public static function applyGlowFilter( mc : MovieClip, clr : int, distance : Number = 15, replace : Boolean = true ) : void
		{
			if( mc == null ){ trace( "\tERROR : applyGlowFilter was called for a MovieClip that is presently null." ); return; }

			var glow : GlowFilter = new GlowFilter();

			glow.color = clr;
			glow.alpha = .7;
			glow.blurX = distance;
			glow.blurY = distance;
			glow.quality = BitmapFilterQuality.MEDIUM;

			mc.filters = [ glow ];
		}

		public static function removeAllFilters( mc : MovieClip ) : void
		{
			if( mc != null )
			{
				mc.filters = [];
			}
		}

		public static function intersectsWithStageRect( mc : MovieClip ) : Boolean
		{
			// trace( CN + ".intersectsWithStageRect" );

			var stage : Stage = mc.stage;
			if( stage == null ){ stage = StageReference.stage; }
			if( stage == null ){ return false; }

			return mc.getBounds( stage ).intersects( new Rectangle( 0, 0, stage.stageWidth, stage.stageHeight ) );
		}

		public static function prune( container : DisplayObjectContainer, possibleChild : DisplayObject ) : void
		{
			// trace( CN + ".prune" );
			if( container == null || possibleChild == null )
			{
				trace( "\tNOTICE : " + CN + ".prune encountered a null." );
				trace( "\t\tcontainer:" + container + ":" );
				trace( "\t\tpossibleChild:" + possibleChild + ":" );
				return;
			}
			if( possibleChild.parent == container )
			{
				container.removeChild( possibleChild );
			}
			else
			{
				trace( "\tNOTICE : container does not contain possibleChild." );
				trace( "\t\tcontainer:" + container + ":" );
				trace( "\t\tpossibleChild:" + possibleChild + ":" );
			}
		}

		public static function graft( container : DisplayObjectContainer, newChild : DisplayObject ) : void
		{
			trace( CN + ".graft" );
			if( container == null || newChild == null )
			{
				trace( "\tNOTICE : " + CN + ".graft encountered a null." );
				trace( "\t\tcontainer:" + container + ":" );
				trace( "\t\tnewChild:" + newChild + ":" );
				return;
			}
			container.addChild( newChild );
		}

		public static function getRegistrationPointOffset( mc : MovieClip ) : Point
		{
			var rect : Rectangle = mc.getBounds( mc );
			var regPoint : Point = new Point( -rect.x, -rect.y );
			return regPoint;
		}

		public static function getSimpleClassName( targetClass : Class ) : String
		{
			return getQualifiedClassName( targetClass ).match( "[^:]*$" )[ 0 ];
		}

	}
}
