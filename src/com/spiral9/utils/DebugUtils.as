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

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.text.StaticText;
	import flash.text.TextField;

	public class DebugUtils
	{
		public static var CN : String = "DebugUtils";

		public static const CN_BITMAP : String =                   "Bitmap";
		public static const CN_MOVIE_CLIP : String =               "MovieClip";
		public static const CN_SHAPE : String =                    "Shape";
		public static const CN_SIMPLE_BUTTON : String =            "SimpleButton";
		public static const CN_SPRITE : String =                   "Sprite";
		public static const CN_STAGE : String =                    "Stage";
		public static const CN_STATIC_TEXT : String =              "StaticText";
		public static const CN_TEXT_FIELD : String =               "TextField";

		public static function enumDisplay( displayObject : DisplayObject, indentLevel : int = 0, textField : TextField = null, indentToUse : String = "\t" ) : void
		{
			var indent : String = "";
			if( indentToUse == "\t" ){ trace( "TAB" ); }
			for( i=0; i<indentLevel; i++ ){ indent += indentToUse; }

			if( indentLevel == 0 ){ tracer( CN + ".enumDisplay", textField ); }
			if( displayObject == null ) { tracer( "ERROR : this 'displayObject' is null.", textField ); return; }
			if( !( displayObject is DisplayObject ) ) { tracer( "ERROR : this 'displayObject' is not a DisplayObject.", textField ); return; }

			var i : int;
			var className : String = getDisplayObjectClassName( displayObject );
			var countChildren : int;
			var displayChild : DisplayObject;


			if( displayObject.name != null )
			{
				tracer( indent + displayObject.name + " : " + className + " : " + String( displayObject ), textField );
			}
			else
			{
				tracer( indent + className + " : " + String( displayObject ), textField );
			}

			if( className == CN_TEXT_FIELD || className == CN_STATIC_TEXT )
			{
				tracer( indent + indent + "text : " + displayObject[ "text" ], textField );
			}

			if( !( displayObject is DisplayObjectContainer ) ){ return; }

			countChildren = DisplayObjectContainer( displayObject ).numChildren;

			for( i=0; i<countChildren; i++ )
			{
				displayChild = DisplayObjectContainer( displayObject ).getChildAt( i );
				enumDisplay( displayChild, indentLevel + 1, textField, indentToUse );
			}
		}

		private static function tracer( msg : String, textField : TextField = null, shouldReplace : Boolean = false ) : void
		{
			switch( true )
			{
				case ( textField != null && shouldReplace ) :
					textField.text = msg + "\n";
					break;
				case ( textField != null && !shouldReplace ) :
					textField.appendText( msg + "\n" );
					break;
				default :
					trace( msg );
			}
		}

		public static function getDisplayObjectClassName( displayObject : DisplayObject ) : String
		{
			var className : String = "unknown";

			switch( true )
			{
				case ( displayObject is MovieClip ) :
					className = CN_MOVIE_CLIP;                 // "MovieClip";
					break;
				case ( displayObject is Stage ) :
					className = CN_STAGE;                      // "Stage";
					break;
				case ( displayObject is Sprite ) :
					className = CN_SPRITE;                     // "Sprite";
					break;
				case ( displayObject is TextField ) :
					className = CN_TEXT_FIELD;                 // "TextField";
					break;
				case ( displayObject is SimpleButton ) :
					className = CN_SIMPLE_BUTTON;              // "SimpleButton";
					break;
				case ( displayObject is Bitmap ) :
					className = CN_BITMAP;                     // "Bitmap";
					break;
				case ( displayObject is Shape ) :
					className = CN_SHAPE;                      // "Shape";
					break;
				case ( displayObject is StaticText ) :
					className = CN_STATIC_TEXT;                // "StaticText";
					break;
				default :
					className = String( displayObject );
			}
			return className;
		}
	}

}
