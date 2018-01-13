package com.spiral9.utils
{

	import flash.geom.ColorTransform;
	import fl.motion.Color;

	import com.spiral9.data.ColorValues;
	import com.greensock.plugins.ColorTransformPlugin;
	import com.greensock.plugins.TweenPlugin;

	import flash.display.DisplayObject;

	public class Tinter
	{
		private static const CN : String = "Tinter";
		private static var _instance : Tinter;
		private static var _allowInstance : Boolean = false;
		private static var _clr : uint;

		// private static var _alpha : Number;
		public function Tinter()
		{
			trace( CN + " instantiated." );

			if( _allowInstance )
			{
				// activation is permanent in the SWF, so this line only needs to be run once.
				TweenPlugin.activate( [ ColorTransformPlugin ] );
				_clr = ColorValues.CLR_GRSPIRAL9N_FOREST;
				// _alpha = 1;
			}
			else
			{
				throw new Error( "singleton" );
			}
		}

		private static function createInstance() : void
		{
			if( _instance == null )
			{
				_allowInstance = true;
				_instance = new Tinter();
				_allowInstance = false;
			}
		}

		public static function getInstance() : Tinter
		{
			createInstance();
			return _instance;
		}

		public static function tint( toTint : DisplayObject, clr : uint = 0, alpha : Number = 1 ) : void
		{
			trace( CN + ".tint" );

			createInstance();

			// this requires the 'flash.swc' to be in your build path
			var color : Color = new Color();
			color.setTint( clr, alpha );
			toTint.transform.colorTransform = color;
		}
		
		public static function untint( toUntint : DisplayObject ) : void
		{
			trace( CN + ".untint" );
			
			createInstance();
			
			toUntint.transform.colorTransform = new ColorTransform();
		}
	}
}
