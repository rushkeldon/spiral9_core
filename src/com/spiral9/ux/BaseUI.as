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

	import com.spiral9.utils.SignalUtils;
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeSignal;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;

	public class BaseUI extends MovieClip
	{
		public var CN : String = "BaseUI";
		
		public var isRecyclable : Boolean;
		public var signalExitFrame : NativeSignal;
		public var signalInitialized : Signal;
		public var signalRemovedFromStage : NativeSignal;

		public function BaseUI()
		{
			signalInitialized = new Signal( DisplayObject );
			signalExitFrame = new NativeSignal( this, Event.EXIT_FRAME, Event );
			signalExitFrame.addOnce( init );

			signalRemovedFromStage = new NativeSignal( this, Event.REMOVED_FROM_STAGE, Event );
			signalRemovedFromStage.addOnce( dispose );
		}

		protected function init( e : Event = null ) : void
		{
			signalInitialized.dispatch( this );
		}

		public function display( e : Event = null ) : void
		{
			trace( "BaseUI.display" );

			this.visible = true;
		}

		public function dismiss( e : Event = null ) : void
		{
			trace( "BaseUI.dismiss" );

			this.visible = false;
		}

		public function toggleDisplay( e : Event = null ) : void
		{
			trace( "BaseUI.toggleDisplay" );

			if( visible )
			{
				visible = false;
			}
			else
			{
				visible = true;
			}
		}

		public function dispose( e : Event = null ) : void
		{
			trace( "BaseUI.dispose" );

			if( !isRecyclable )
			{
				SignalUtils.disposeOfPublicSignal( "signalInitialized", this );
				SignalUtils.disposeOfPublicSignal( "signalExitFrame", this );
				SignalUtils.disposeOfPublicSignal( "signalRemovedFromStage", this );
			}
			else
			{
				trace( "\tNOTICE : this instance of BaseUI isRecyclable - so not disposing." );
			}
		}
	}
}
