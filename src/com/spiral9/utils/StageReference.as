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

	import org.osflash.signals.natives.NativeSignal;

	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Rectangle;

	public class StageReference
	{
		private static const CN : String = "StageReference";
		private static var _instance : StageReference;
		private static var _allowInstance : Boolean = false;
		private static var _stageReference : Stage;
		private static var _displayObjectContainer : DisplayObjectContainer;
		private static var _signalEnterFrame : NativeSignal;
		private static var _authoredWidth : int;
		private static var _authoredHeight : int;

		public function StageReference( displayObjectContainer : DisplayObjectContainer )
		{
			_displayObjectContainer = displayObjectContainer;

			if( _allowInstance )
			{
				//trace( CN + " instantiated." );

				switch( true )
				{
					case ( _displayObjectContainer is Stage ) :
						_stageReference = _displayObjectContainer as Stage;
						break;
					case ( _displayObjectContainer is MovieClip && _displayObjectContainer.stage != null ) :
						_stageReference = MovieClip( _displayObjectContainer ).stage;
						break;
					case ( _displayObjectContainer is MovieClip && _displayObjectContainer.stage == null ) :
						startPollingForStage();
						break;
					default :
						trace( "\tERROR : an unhandled case was encountered.  No StageReference for you." );
						break;
				}
			}
		}

		private static function startPollingForStage() : void
		{
			_signalEnterFrame = new NativeSignal( _displayObjectContainer, Event.ENTER_FRAME, Event );
			_signalEnterFrame.add( checkForStage );
			checkForStage();
		}

		private static function checkForStage( e : Event = null ) : void
		{
			switch( true )
			{
				case ( _displayObjectContainer.stage != null ) :
					_stageReference = _displayObjectContainer.stage;
					stopPollingForStage();
					break;
				case ( _displayObjectContainer is Stage ) :
					_stageReference = _displayObjectContainer as Stage;
					stopPollingForStage();
					break;
			}
		}

		private static function stopPollingForStage() : void
		{
			_signalEnterFrame.removeAll();
			_signalEnterFrame = null;
		}

		public static function init( displayObjectContainer : DisplayObjectContainer, originalAuthoredWidth : int = 550, originalAuthoredHeight : int = 400 ) : void
		{
			authoredWidth = originalAuthoredWidth;
			authoredHeight = originalAuthoredHeight;

			if( _instance == null )
			{
				_allowInstance = true;
				_instance = new StageReference( displayObjectContainer );
				_allowInstance = false;
			}
			else
			{
				_displayObjectContainer = displayObjectContainer;
				startPollingForStage();
			}
		}

		public static function get stage() : Stage
		{
			return _stageReference;
		}

		public static function get stageRect() : Rectangle
		{
			return( new Rectangle( 0, 0, _stageReference.stageWidth, _stageReference.stageHeight ) );
		}

		public static function get authoredWidth() : int
		{
			return _authoredWidth;
		}

		public static function set authoredWidth( authoredWidth : int ) : void
		{
			_authoredWidth = authoredWidth;
		}

		public static function get authoredHeight() : int
		{
			return _authoredHeight;
		}

		public static function set authoredHeight( authoredHeight : int ) : void
		{
			_authoredHeight = authoredHeight;
		}
	}
}
