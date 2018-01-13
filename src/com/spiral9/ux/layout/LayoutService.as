package com.spiral9.ux.layout
{
	import flash.display.DisplayObject;
	import flash.geom.Point;

	public class LayoutService 
	{
		public static const VERTICAL : String = "vertical";
		public static const HORIZONTAL : String = "horizontal";
		
		public static function getSpaceBetween( displayObject0 : DisplayObject , displayObject1 : DisplayObject ) : Point
		{
			var point : Point = new Point();
			
			switch( true )
			{
				case ( displayObject0 == null || displayObject1 == null ) :
					trace( "\tERROR : one of the displayObjects == null." );
					return point;
					break;
				default :
					// horizontal
					switch( true )
					{
						case ( displayObject0.x + displayObject0.width < displayObject1.x ) :
							point.x = displayObject1.x - ( displayObject0.x + displayObject0.width );
							break;
						case ( displayObject1.x + displayObject1.width < displayObject0.x ) :
							point.x = displayObject0.x - ( displayObject1.x + displayObject1.width );
							break;
					}
					// vertical
					switch( true )
					{
						case ( displayObject0.y + displayObject0.height < displayObject1.y ) :
							point.y = displayObject1.y - ( displayObject0.y + displayObject0.height );
							break;
						case ( displayObject1.y + displayObject1.height < displayObject0.y ) :
							point.y = displayObject0.y - ( displayObject1.y + displayObject1.height );
							break;
					}
			}
			return point;
		}
		
		public static function getVerticalSpaceBetween( displayObject0 : DisplayObject , displayObject1 : DisplayObject ) : Number
		{
			return getSpaceBetween( displayObject0, displayObject1 ).y;
		}
		
		public static function getHorizontalSpaceBetween( displayObject0 : DisplayObject , displayObject1 : DisplayObject ) : Number
		{
			return getSpaceBetween( displayObject0, displayObject1 ).x;
		}
		
		public static function getVerticalSpaceBetweenY( displayObject : DisplayObject, testY : Number ) : Number
		{
			var space : Number = 0;
			var bottomEdge : Number = displayObject.y + displayObject.height;
			
			switch( true )
			{
				case ( testY > bottomEdge ) :
					space = testY - bottomEdge;
					break;
				case ( testY < displayObject.y ) :
					space = displayObject.y - testY;
					break;
			}
			
			return space;
		}
		
		
		public static function getHorizontalSpaceBetweenX( displayObject : DisplayObject, testX : Number ) : Number
		{
			var space : Number = 0;
			var rightEdge : Number = displayObject.x + displayObject.width;
			
			switch( true )
			{
				case ( testX > rightEdge ) :
					space = testX - rightEdge;
					break;
				case ( testX < displayObject.x ) :
					space = displayObject.x - testX;
					break;
			}
			
			return space;
		}
	}
}
