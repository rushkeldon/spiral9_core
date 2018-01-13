package com.spiral9.ux.layout
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;

	public class Grid extends MovieClip
	{
		public var CN : String = "Grid";

		private var _gridVars : GridVars;
		private var _cellPoint : Point;
		private var _width : Number = 0;
		private var _height : Number = 0;

		public function Grid( initGridVars : GridVars = null )
		{
			trace( CN + " instantiated." );

			if( initGridVars != null )
			{
				_gridVars = initGridVars;
				layout();
			}
		}

		public function layout() : void
		{
			//trace( CN + ".layout" );

			if( _gridVars == null ){ trace( CN + " ERROR : _gridVars == null" ); return; }

			x = _gridVars.boundingRect.x;
			y = _gridVars.boundingRect.y;

			_cellPoint = new Point( _gridVars.gridPadding.x, _gridVars.gridPadding.y );
			var i : int;
			var displayObject : DisplayObject;

			for( i=0; i<_gridVars.displayObjects.length; i++ )
			{
				displayObject = _gridVars.displayObjects[ i ];
				displayObject.x = _cellPoint.x;
				displayObject.y = _cellPoint.y;
				addChild( displayObject );
				updateCellPoint();
			}

			_height -= ( _gridVars.cellMargin.y + _gridVars.cellDim.y );
		}

		override public function get width() : Number
		{
			trace( "\t_width:" + _width + ":" );
			
			return _width;
		}
		
		override public function get height() : Number
		{
			trace( "\t_height:" + _height + ":" );
			
			return _height;
		}

		private function updateCellPoint() : void
		{
			//trace( CN + ".updateCellPoint" );
			
			var newWidth : Number;
			var newHeight : Number;
			
			_cellPoint.x += _gridVars.cellMargin.x + _gridVars.cellDim.x;

			if( _cellPoint.x + _gridVars.cellDim.x > _gridVars.boundingRect.width )
			{
				_cellPoint.x = _gridVars.gridPadding.x;
				_cellPoint.y += _gridVars.cellDim.y + _gridVars.cellMargin.y;
			}
			
			newWidth = _cellPoint.x + _gridVars.cellMargin.x + _gridVars.cellDim.x;
			if( newWidth > _width ){ _width = newWidth; }

			newHeight = _cellPoint.y + _gridVars.cellMargin.y + _gridVars.cellDim.y;
			if( newHeight > _height ){ _height = newHeight; }
		}

		public function get gridVars() : GridVars
		{
			return _gridVars;
		}

		public function set gridVars( gridVars : GridVars ) : void
		{
			_gridVars = gridVars;
			layout();
		}
	}
}
