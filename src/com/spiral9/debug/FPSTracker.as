package com.spiral9.debug
{
	import flash.events.*;
	import flash.utils.getTimer;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.display.DisplayObjectContainer;

	public class FPSTracker
	{
		private var __root : DisplayObjectContainer;
		private var __time : int;
		private var __lastTime : int;
		private var __fps : int;
		private var __fpsText : TextField;
		
		public function FPSTracker ( target : DisplayObjectContainer ) : void
		{
			__root = target;
			
			init();
			
			__time = 0;
			__lastTime = getTimer();
			
			__root.addEventListener( Event.ENTER_FRAME, update );
		}
		
		public function update ( evt : Event ) : void
		{
			__time += getTimer() - __lastTime;
			__lastTime = getTimer();
			
			if ( __time >= 1000 )
			{
				__fpsText.text = ( "FPS: " + __fps );
				__time = 0;
				__fps = 0;
			}
			
			__fps++;
		}
		
		private function init ( ) : void
		{
			__fpsText = new TextField();
			__fpsText.autoSize = TextFieldAutoSize.LEFT;
			__fpsText.x = 40;
			__fpsText.y = 670;
			__fpsText.text = "FPS: ";
			__root.addChild( __fpsText );
		}
	}
}