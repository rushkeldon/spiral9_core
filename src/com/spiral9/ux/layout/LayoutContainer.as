package com.spiral9.ux.layout
{

	import com.spiral9.utils.BitmapUtil;
	import com.spiral9.data.ColorValues;

	import org.osflash.signals.Signal;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	public class LayoutContainer extends Sprite
	{
		public var CN : String = "LayoutContainer";

		public static const VERTICAL : String = "vertical";
		public static const HORIZONTAL : String = "horizontal";

		public var alignment : String = HORIZONTAL;
		public var isDistributed : Boolean = true;
		public var margin : int = 0;
		public var signalInitialized : Signal;

		private var _childrenWidth : int = 0;
		private var _childrenHeight : int = 0;
		private var _isBGdrawn : Boolean = false;

		/* TODO
		 * add isRecyclable : Boolean                       // flags whether to dispose upon removal from stage
		 * add signalRemovedFromStage : NativeSignal        // public signal for removal from stage
		 * add function dispose( e : Event )                // cleanup : removes listeners and references
		 */

		public function LayoutContainer()
		{
			trace( CN + " instantiated." );
			super();
			signalInitialized = new Signal( LayoutContainer );
		}

		public function layout() : void
		{
			var childContainer : DisplayObject;
			var i : int;

			for( i = 0; i < numChildren; i++ )
			{
				childContainer = getChildAt( i );

				// get the children laid out
				if( childContainer is LayoutContainer )
				{
					LayoutContainer( childContainer ).layout();
				}

				_childrenWidth += childContainer.width;
				_childrenHeight += childContainer.height;
			}

			switch( alignment )
			{
				case VERTICAL:
					layoutVertical();
					break;
				case HORIZONTAL:
				default:
					layoutHorizontal();
					break;
			}

			signalInitialized.dispatch( this );
		}

		protected function layoutVertical() : void
		{
			var child : DisplayObject;
			var prevChild : DisplayObject;
			var parentContainer : LayoutContainer;
			var childY : Number = 0;
			var i : int;

			if( isDistributed )
			{
				parentContainer = getParentWithBG();
				margin = ( parentContainer.height - _childrenWidth ) / ( numChildren + 1 );
			}

			for( i = 0; i < numChildren; i++ )
			{
				child = getChildAt( i );

				if( i > 0 )
				{
					prevChild = getChildAt( i - 1 );
					childY += prevChild.y + prevChild.height + margin;
				}

				// align horizontally TODO : enable horizontal alignment : left, center, or right
				child.x = ( width - child.width ) * .5;

				// distribute vertically
				child.y = childY;
				childY = 0;
			}
		}

		protected function layoutHorizontal() : void
		{
			var child : DisplayObject;
			var prevChild : DisplayObject;
			var parentContainer : LayoutContainer;
			var childX : Number = 0;
			var i : int;

			if( isDistributed )
			{
				parentContainer = getParentWithBG();
				margin = ( parentContainer.width - _childrenWidth ) / ( numChildren + 1 );
			}

			for( i = 0; i < numChildren; i++ )
			{
				child = getChildAt( i );

				if( i > 0 )
				{
					prevChild = getChildAt( i - 1 );
					childX += prevChild.x + prevChild.width + margin;
				}

				// align vertically TODO : enable vertical alignment : top, middle, or bottom
				child.y = ( height - child.height ) * .5;

				// distribute horizontally
				child.x = childX;
				childX = 0;
			}
		}

		public function drawBG( bitmap : Bitmap ) : void
		{
			trace( CN + ".drawBG" );

			BitmapUtil.drawBitmap( this, bitmap );
			_isBGdrawn = true;
		}

		public function drawBGrect( rect : Rectangle ) : void
		{
			trace( CN + ".drawBGrect" );

			graphics.lineStyle( 0, ColorValues.CLR_LIGHT_GRSPIRAL9N, .2, false, LineScaleMode.NONE );
			graphics.beginFill( ColorValues.CLR_LIGHT_GRSPIRAL9N, .2 );
			graphics.drawRect( rect.x, rect.y, rect.width, rect.height );
			graphics.endFill();

			_isBGdrawn = true;
		}

		public function get isBGdrawn() : Boolean
		{
			return _isBGdrawn;
		}

		public function getParentWithBG() : LayoutContainer
		{
			var layoutContainer : DisplayObject = this;

			while( layoutContainer != null )
			{
				if( layoutContainer is LayoutContainer &&
					LayoutContainer( layoutContainer ).isBGdrawn )
				{
					break;
				}
				layoutContainer = layoutContainer.parent;
			}
			return layoutContainer as LayoutContainer;
		}
	}
}
