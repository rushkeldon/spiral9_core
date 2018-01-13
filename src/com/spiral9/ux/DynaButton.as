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
package com.spiral9.ux
{

	import com.greensock.TweenMax;
	import com.spiral9.data.ButtonInfo;
	import com.spiral9.utils.MovieClipUtil;

	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeSignal;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class DynaButton extends MovieClip
	{
		public static const CN : String = "DynaButton";
		public static const MARGIN : int = 15;
		public static const MARGIN_OVERLAY : int = 3;
		public var overlay : MovieClip;
		public var echo : TextField;
		public var bg : MovieClip;
		public var signalClicked : NativeSignal;
		public var signalMouseOver : NativeSignal;
		public var signalMouseOut : NativeSignal;
		public var signalInitialized : Signal;
		private var _signalExitFrame : NativeSignal;
		private var _buttonInfo : ButtonInfo;
		private var _signalRemovedFromStage : NativeSignal;

		public function DynaButton( buttonInfo : ButtonInfo )
		{
			//trace( CN + " instantiated." );

			_buttonInfo = buttonInfo;

			signalMouseOver = new NativeSignal( this, MouseEvent.MOUSE_OVER, MouseEvent );
			signalMouseOut = new NativeSignal( this, MouseEvent.MOUSE_OUT, MouseEvent );
			signalClicked = MovieClipUtil.buttonizeWithNativeSignal( this, true );

			_signalRemovedFromStage = new NativeSignal( this, Event.REMOVED_FROM_STAGE, Event );
			_signalRemovedFromStage.addOnce( dispose );

			signalInitialized = new Signal( DynaButton );

			_signalExitFrame = new NativeSignal( this, Event.EXIT_FRAME, Event );
			_signalExitFrame.addOnce( init );
		}

		public function get info() : ButtonInfo
		{
			return _buttonInfo;
		}

		private function init( e : Event = null ) : void
		{
			//trace( CN + ".init" );

			echo.autoSize = TextFieldAutoSize.CENTER;
			echo.text = info.label;

			signalMouseOver.add( mousedOver );
			signalMouseOut.add( mousedOut );
			signalClicked.add( clicked );

			bg.width = echo.width + MARGIN * 2;
			overlay.width = bg.width - MARGIN_OVERLAY;
			echo.x = MARGIN;
			signalInitialized.dispatch( this );

			TweenMax.to( bg, 0, { colorMatrixFilter : { colorize : info.color, brightness : 1 } } );
		}

		private function clicked( e : MouseEvent = null ) : void
		{
		}

		private function mousedOut( e : MouseEvent = null ) : void
		{
			//trace( CN + ".mousedOut" );

			TweenMax.to( bg, 0, { colorMatrixFilter : { colorize : info.color, brightness : 1 } } );
		}

		private function mousedOver( e : MouseEvent = null ) : void
		{
			//trace( CN + ".mousedOver" );

			TweenMax.to( bg, 0, { colorMatrixFilter : { colorize : info.color, brightness : .5 } } );
		}

		private function dispose( e : Event = null ) : void
		{
			// listeners
			signalClicked.removeAll();
			signalMouseOver.removeAll();
			signalMouseOut.removeAll();
			signalInitialized.removeAll();
			_signalExitFrame.removeAll();
			_signalRemovedFromStage.removeAll();

			// references
			signalClicked = null;
			signalMouseOver = null;
			signalMouseOut = null;
			signalInitialized = null;
			_signalExitFrame = null;
			_signalRemovedFromStage = null;
			overlay = null;
			echo = null;
			bg = null;
			_buttonInfo = null;
		}
	}
}
