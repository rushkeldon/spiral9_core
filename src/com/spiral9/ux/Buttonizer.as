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

	import com.spiral9.utils.DataUtils;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.natives.NativeSignal;

	import flash.display.DisplayObject;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.Scene;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;

	public class Buttonizer
	{
		public static const CN : String = "Buttonizer";

		public static const FRAME_LABEL_UP : String =			"_up";
		public static const FRAME_LABEL_OVER : String =			"_over";
		public static const FRAME_LABEL_DOWN : String =			"_down";
		public static const FRAME_LABEL_HIT : String = 			"_hit";
		public static const FRAME_LABEL_DISABLED : String = 		"_disabled";

		public var signalClicked : NativeSignal;
		public var signalRolledOver : NativeSignal;
		public var signalRolledOut : NativeSignal;
		public var signalMousePressed : NativeSignal;
		public var signalMouseReleased : NativeSignal;
		public var signalRemovedFromStage : NativeSignal;

		private var _mc : MovieClip;
		private var _storedText : String;
		private var _storedHTMLtext : String;
		private var _textFieldName : String;
		private var _labels : Array;
		private var _useHandCursor : Boolean;
		private var _hasTextField : Boolean;
		private var _hasUpFrame : Boolean;
		private var _hasOverFrame : Boolean;
		private var _hasDownFrame : Boolean;
		private var _hasHitFrame : Boolean;
		private var _hasDisabledFrame : Boolean;
		private var _isHTML : Boolean = false;
		private var _btnVars : ButtonizerVars;
		private var _btnEnabled : Boolean = true;
		private var _keyFrameNumbers : Vector.<Number>;
		private var _frameFunctions : Vector.<Function>;
		private var _skinImages : Vector.<Image>;
		private var _isAutoUnbuttonized : Boolean = false;

		public function Buttonizer( btnVars : Object )
		{
			//trace( CN + ".Buttonizer" );

			switch( true )
			{
				case ( btnVars == null ) :
					break;
				case ( btnVars is ButtonizerVars ) :
					_btnVars = btnVars as ButtonizerVars;
					break;
				case ( btnVars is MovieClip ) :
					_btnVars = new ButtonizerVars( { movieClip : btnVars } );
					break;
				case ( btnVars is Object ) :
					_btnVars = new ButtonizerVars( btnVars );
					break;
			}

			//trace( _btnVars );

			if( _btnVars == null || _btnVars.movieClip == null )
			{
				trace( "\ERROR : there is no MovieClip to buttonize." );
				return;
			}

			_labels = new Array( FRAME_LABEL_UP, FRAME_LABEL_OVER, FRAME_LABEL_DOWN, FRAME_LABEL_HIT, FRAME_LABEL_DISABLED );
			_mc = _btnVars.movieClip;

			if( DataUtils.hasProp( _btnVars, "textFieldName" ) ){ _textFieldName = _btnVars.textFieldName; }
			if( DataUtils.hasProp( _btnVars, "skinImages" ) ){ _skinImages = _btnVars.skinImages; }
			if( DataUtils.hasProp( _btnVars, "text" ) ){ _storedText = _btnVars.text; }
			if( DataUtils.hasProp( _btnVars, "htmlText" ) ){ _storedHTMLtext = _btnVars.htmlText; }
			if( DataUtils.hasProp( _btnVars, "isHTML" ) ){ _isHTML = btnVars.isHTML; }
			if( DataUtils.hasProp( _btnVars, "isAutoUnbuttonized" ) ){ _isAutoUnbuttonized = btnVars.isAutoUnbuttonized; }

			_useHandCursor = _btnVars.useHandCursor;
			_hasTextField = ( _textFieldName != "" );
			_hasUpFrame = ( getFrameNumByLabel( _mc, FRAME_LABEL_UP ) != -1 );
			_hasOverFrame = ( getFrameNumByLabel( _mc, FRAME_LABEL_OVER ) != -1 );
			_hasDownFrame = ( getFrameNumByLabel( _mc, FRAME_LABEL_DOWN ) != -1 );
			_hasHitFrame = ( getFrameNumByLabel( _mc, FRAME_LABEL_HIT ) != -1 );
			_hasDisabledFrame = ( getFrameNumByLabel( _mc, FRAME_LABEL_DISABLED ) != -1 );

			// line up frameFunctions if there is even one
			if(	_btnVars.onUpFrame != null ||
				_btnVars.onOverFrame != null ||
				_btnVars.onDownFrame != null ||
				_btnVars.onHitFrame != null ||
				_btnVars.onDisabledFrame != null )
			{
				_frameFunctions = new Vector.<Function>();
				_frameFunctions.push( _btnVars.onUpFrame );
				_frameFunctions.push( _btnVars.onOverFrame );
				_frameFunctions.push( _btnVars.onDownFrame );
				_frameFunctions.push( _btnVars.onHitFrame );
				_frameFunctions.push( _btnVars.onDisabledFrame );
			}

			_keyFrameNumbers = new Vector.<Number>();
			_keyFrameNumbers.push( getFrameNumByLabel( _mc, FRAME_LABEL_UP ) - 1 );
			_keyFrameNumbers.push( getFrameNumByLabel( _mc, FRAME_LABEL_OVER ) - 1 );
			_keyFrameNumbers.push( getFrameNumByLabel( _mc, FRAME_LABEL_DOWN ) - 1 );
			_keyFrameNumbers.push( getFrameNumByLabel( _mc, FRAME_LABEL_HIT ) - 1 );
			_keyFrameNumbers.push( getFrameNumByLabel( _mc, FRAME_LABEL_DISABLED ) - 1 );

			// set button properties
			_mc.mouseChildren = false;

			// create signals
			signalClicked = new NativeSignal( _mc, MouseEvent.CLICK, MouseEvent );
			signalRolledOver = new NativeSignal( _mc, MouseEvent.ROLL_OVER, MouseEvent );
			signalRolledOut = new NativeSignal( _mc, MouseEvent.ROLL_OUT, MouseEvent );
			signalMousePressed = new NativeSignal( _mc, MouseEvent.MOUSE_DOWN, MouseEvent );
			signalMouseReleased = new NativeSignal( _mc, MouseEvent.MOUSE_UP, MouseEvent );
			signalRemovedFromStage = new NativeSignal( _mc, Event.REMOVED_FROM_STAGE, Event );

			// add listeners
			signalMousePressed.add( displayDownState );
			signalRolledOver.add( displayOverState );
			signalRolledOut.add( displayUpState );
			
			if( _isAutoUnbuttonized )
			{
				signalRemovedFromStage.addOnce( unbuttonize );
			}

			// FIXME : tweaking for iOS based on static ButtonizerVars.isTouchScreen
			// don't know if this will be universal for touchscreen devices or if this is just iOS - need to test more later
			if( ButtonizerVars.isTouchScreen )
			{
				signalClicked.add( displayUpState );
				signalMouseReleased.add( displayUpState );
			}
			else
			{
				signalMouseReleased.add( displayOverState );
			}

			var i : int;

			for( i=0; i<_keyFrameNumbers.length; i++ )
			{
				_mc.addFrameScript( _keyFrameNumbers[ i ], updateKeyFrame );
			}

			if( _hasUpFrame )
			{
				displayUpState();
			}
			else
			{
				_mc.gotoAndStop( 1 );
			}
		}

		protected function get hasStateImages() : Boolean
		{
			return ( _skinImages != null && _skinImages.length > 0 );
		}

		protected function skinButtonState() : void
		{

		}

		protected function stripAssetsToTextField() : void
		{
			var asset : DisplayObject = _mc.getChildAt( 0 );

			while( !( asset is TextField ) )
			{
				_mc.removeChild( asset );
				asset = _mc.getChildAt( 0 );
			}
		}

		public function displayUpState( e : MouseEvent = null ) : void
		{
			if( !_btnEnabled ){ return; }
			if( _hasUpFrame )
			{
				_mc.gotoAndStop( FRAME_LABEL_UP );
			}

			if( _useHandCursor ){ Mouse.cursor = MouseCursor.AUTO; }
		}

		public function displayOverState( e : MouseEvent = null ) : void
		{
			if( !_btnEnabled ){ return; }
			if( _hasOverFrame )
			{
				_mc.gotoAndStop( FRAME_LABEL_OVER );
			}
			if( _useHandCursor ){ Mouse.cursor = MouseCursor.HAND; }
		}

		public function displayDownState( e : MouseEvent = null ) : void
		{
			if( !_btnEnabled ){ return; }

			if( _hasDownFrame )
			{
				_mc.gotoAndStop( FRAME_LABEL_DOWN );
			}
			if( _useHandCursor ){ Mouse.cursor = MouseCursor.AUTO; }
		}

		public function updateKeyFrame() : void
		{
			//trace( CN + ".updateKeyFrame" );

			if( _hasTextField )
			{
				var textField : TextField = _mc[ _textFieldName ] as TextField;
				if( textField != null )
				{
					switch( true )
					{
						case ( !_isHTML ) :
							TextField( _mc[ _textFieldName ] ).text = String( _storedText );
							break;
						case ( _isHTML ) :
							TextField( _mc[ _textFieldName ] ).htmlText = String( _storedHTMLtext );
							break;
					}
				}
			}

			if( _frameFunctions != null )
			{
				var functionIndex : int = -1;
				var currentFrame : int = _mc.currentFrame - 1;

				switch( true )
				{
					case( currentFrame == _keyFrameNumbers[ 0 ] ) :
						functionIndex = 0;
						break;
					case( currentFrame == _keyFrameNumbers[ 1 ] ) :
						functionIndex = 1;
						break;
					case( currentFrame == _keyFrameNumbers[ 2 ] ) :
						functionIndex = 2;
						break;
					case( currentFrame == _keyFrameNumbers[ 3 ] ) :
						functionIndex = 3;
						break;
					case( currentFrame == _keyFrameNumbers[ 4 ] ) :
						functionIndex = 4;
						break;
				}

				if( functionIndex >= 0 && functionIndex <= 4 && _frameFunctions[ functionIndex ] != null )
				{
					_frameFunctions[ functionIndex ]( _mc );
				}
			}
		}

		public function set text( newText : String ) : void
		{
			if( newText == null ){ return; }
			_storedText = newText;
			updateKeyFrame();
		}

		public function get text() : String
		{
			return _storedText;
		}

		public function set htmlText( newHTMLtext : String ) : void
		{
			if( newHTMLtext == null ){ return; }
			_storedHTMLtext = newHTMLtext;
			updateKeyFrame();
		}

		public function get htmlText() : String
		{
			return _storedHTMLtext;
		}

		public function get btnEnabled() : Boolean
		{
			return _btnEnabled;
		}

		public function pause() : void
		{
			// trace( CN + ".pause" );

			_btnEnabled = false;
			Mouse.cursor = MouseCursor.AUTO;
		}

		public function resume() : void
		{
			// trace( CN + ".resume" );

			_btnEnabled = true;
			displayUpState();
		}

		public function unbuttonize( e : Event = null ) : void
		{
			//trace( CN + ".unbuttonize" );
			
			removeSignal( signalClicked );
			removeSignal( signalRolledOver );
			removeSignal( signalRolledOut );
			removeSignal( signalMousePressed );
			removeSignal( signalMouseReleased );
			removeSignal( signalRemovedFromStage );

			signalClicked = null;
			signalRolledOver = null;
			signalRolledOut = null;
			signalMousePressed = null;
			signalMouseReleased = null;
			signalRemovedFromStage = null;
		}

		private function removeSignal( signal : ISignal ) : void
		{
			//trace( CN + ".removeSignal" );

			if( signal is ISignal )
			{
				ISignal( signal ).removeAll();
			}
		}

		private function getFrameNumByLabel( mc : MovieClip, frameLabel : String = "" ) : int
		{
			if( mc == null ){ trace( CN + "\tERROR : no movieClip to search." ); return -1; }
			if( frameLabel == "" ){ trace( CN + "\tERROR : no frameLabel to search for." ); return -1; }

			var i : int;
			var labels : Array = Scene( mc.currentScene ).labels;
			var frameNum : int = -1;

			for( i = 0; i < labels.length ; i++ )
			{
				if( FrameLabel( labels[ i ] ).name == frameLabel )
				{
					frameNum = FrameLabel( labels[ i ] ).frame;
					break;
				}
			}
			return frameNum;
		}
	}
}
