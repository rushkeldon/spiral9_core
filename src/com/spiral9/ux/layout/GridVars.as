package com.spiral9.ux.layout
{
	import com.spiral9.utils.StageReference;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class GridVars
	{
		private var CN : String = "GridVars";

		public var displayObjects : Vector.<DisplayObject>;
		public var cellDim : Point = new Point( 100, 100 );
		public var cellMargin : Point = new Point( 10, 10 );
		public var gridPadding : Point = new Point( 0, 0 );

		private var _boundingRect : Rectangle;

		public function GridVars()
		{
			trace( CN + " instantiated." );
		}

		public function get boundingRect() : Rectangle
		{
			if( _boundingRect == null )
			{
				_boundingRect = new Rectangle( 0, 0, StageReference.stage.stageWidth, StageReference.stage.stageHeight );
			}
			return _boundingRect;
		}

		public function set boundingRect( boundingRect : Rectangle ) : void
		{
			_boundingRect = boundingRect;
		}
	}
}
