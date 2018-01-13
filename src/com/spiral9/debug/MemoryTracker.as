package com.spiral9.debug
{
	import flash.events.*;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.display.DisplayObjectContainer;

	public class MemoryTracker
	{
		private var __root : DisplayObjectContainer;
		private var __mem : String;
		private var __memText : TextField;
		
		public function MemoryTracker ( target : DisplayObjectContainer ) : void
		{
			__root = target;
			
			init();
			
			__root.addEventListener( Event.ENTER_FRAME, update );
		}
		
		public function update ( evt : Event ) : void
		{
			__mem = ( "Memory Usage: " + Number( System.totalMemory / 1024 / 1024 ).toFixed( 2 ) + "Mb" );
			__memText.text = __mem;
		}
		
		private function init ( ) : void
		{
			__memText = new TextField();
			__memText.autoSize = TextFieldAutoSize.LEFT;
			__memText.x = 40;
			__memText.y = 650;
			__root.addChild( __memText );
		}
	}
}