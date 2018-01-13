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

	//import com.spiral9.assets.core.BtnCollectandGo;
	//import com.spiral9.assets.core.BtnFB;
	//import com.spiral9.assets.core.BtnGreen;
	//import com.spiral9.assets.core.BtnRed;
	//import com.spiral9.assets.core.PaneRewardCoins;
	//import com.spiral9.assets.core.PaneRewardXP;
	//import com.spiral9.assets.core.PaneScore;
	import com.spiral9.data.SmartLinkInfo;
	import com.spiral9.data.SmartLinkTypes;
	import com.spiral9.data.media.ImageInfo;
	import com.spiral9.net.URLservice;
	import com.spiral9.utils.MovieClipUtil;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;



	public class SmartLink extends BaseUI
	{
		public var ui : MovieClip;
		public var btnCore : Buttonizer;
		public var btnLabel : String;
		public var signalClicked : ISignal;
		public var images : Vector.<Image>;
		public var areImagesLoaded : Boolean;
		public var signalImagesLoaded : Signal;

		protected var _btnVars : ButtonizerVars;
		protected var _apiToCall : Function;
		protected var _info : SmartLinkInfo;
		protected var _imageLoadCount : int;
		protected var _isSystemBtn : Boolean;
		protected var _coreUI : DisplayObject;

		public function SmartLink( smartLinkInfo : SmartLinkInfo = null )
		{
			super();
			CN = "SmartLink";
			if( smartLinkInfo == null ){ trace( CN + " ERROR : smartLinkInfo is null." ); return; }
			_info = smartLinkInfo;
		}

		protected function needsSkinning() : Boolean
		{
			return ( ( images != null && images.length > 0 ) || _info.hasOwnProperty( "btnClass" ) );
		}

		protected function getSystemUI() : void
		{
			_isSystemBtn = true;

			switch( _info.type )
			{
				case SmartLinkTypes.TYPE_BTN_FB_SHARE :
				case SmartLinkTypes.TYPE_BTN_FB_CONNECT :
				case SmartLinkTypes.TYPE_BTN_FB_INVITE_FRIENDS :
					//ui = new BtnFB();
					break;
				case SmartLinkTypes.TYPE_BTN_PLAY :
				case SmartLinkTypes.TYPE_BTN_PLAY_AGAIN :
				case SmartLinkTypes.TYPE_BTN_PLAY_NOW :
				case SmartLinkTypes.TYPE_BTN_PLAY_NEXT :
					//ui = new BtnRed();
					break;
				case SmartLinkTypes.TYPE_BTN_COLLECT_AND_GO :
					//ui = new BtnCollectandGo();
					break;
				case SmartLinkTypes.TYPE_PANE_SCORE_0 :
					//ui = new PaneScore();
					break;
				case SmartLinkTypes.TYPE_PANE_REWARD_XP :
					//ui = new PaneRewardXP();
					break;
				case SmartLinkTypes.TYPE_PANE_REWARD_COINS :
					//ui = new PaneRewardCoins();
					break;
				case SmartLinkTypes.TYPE_PANE_REWARD_TICKETS :
					//ui = new PaneRewardCoins();
					break;
				case SmartLinkTypes.TYPE_BTN_START :
				case SmartLinkTypes.TYPE_BTN_PURCHASE :
				case SmartLinkTypes.TYPE_BTN_COLLECT :
				case SmartLinkTypes.TYPE_BTN_USE_TICKETS :
					//ui = new BtnGreen();
					break;
				default :
					_isSystemBtn = false;
			}
		}

		override protected function init( e : Event = null ) : void
		{
			trace( CN + ".init" );

			getSystemUI();
			loadImagesAndButtonize();
			setShadow();
		}

		protected function loadImagesAndButtonize() : void
		{
			trace( CN + ".loadImagesAndButtonize" );

			var i : int;
			var imageInfo : ImageInfo;
			var image : Image;

			if( _info.imageInfos != null && _info.imageInfos.length > 0 )
			{
				signalImagesLoaded = new Signal( Vector.<Image> );
				signalImagesLoaded.addOnce( buttonize );
				images = new Vector.<Image>();
				for( i=0; i<_info.imageInfos.length; i++ )
				{
					_imageLoadCount++;
					imageInfo = _info.imageInfos[ i ];
					image = new Image( imageInfo );
					image.signalInitialized.addOnce( imageInitialized );
					images.push( image );
				}
			}
			else
			{
				buttonize();
			}
		}

		private function setShadow() : void
		{
			trace( CN + ".setShadow" );

			if( _info.hasDropShadow )
			{
				MovieClipUtil.addDropShadow( ui );
			}
		}

		protected function buttonize( imgs : Vector.<Image> = null ) : void
		{
			trace( CN + ".buttonize" );

			if( imgs != null ){ images = imgs; }

			/* cases to become a button :
			 * 0. _info.targetURL != null					: need to visit the URL on click
			 * 1. _info.imageURLs.length > 1 				: need to display states based on Mouse events
			 * 2. _info.type is on of the system buttons 	: need to dispatch signal on click
			 * 3. _info.shareInfo is ShareInfo				: need to dispatch share signal with ShareInfo on click
			 */

			var needsButtonizing : Boolean = (
				( _info.hasOwnProperty( "linkURL" ) && _info.linkURL != URLservice.BAD_URL ) ||
				( images != null && images.length > 1 ) ||
				_isSystemBtn ||
				_info.hasOwnProperty( "shareInfo" )
				);

			if( needsButtonizing )
			{
				var textFieldName : String = getTextFieldName();

				_btnVars = new ButtonizerVars();
				_btnVars.movieClip = ui;
				_btnVars.textFieldName = getTextFieldName();
				_btnVars.htmlText = _info.btnLabel;
				if( images != null && images.length > 0 )
				{
					_btnVars.skinImages = images;
				}

				btnCore = new Buttonizer( _btnVars );
				signalClicked = btnCore.signalClicked;
				signalClicked.addOnce( btnClicked );
			}
		}

		protected function getTextFieldName() : String
		{
			var textFieldName : String = "label";

			switch( true )
			{
				case ( ui == null ) :
					trace( "\tERROR : the ui is null - going with the default textFieldName!" );
					break;
				case ( ui[ "label" ] is TextField ) :
					// NOTE : accessing via associative array style because it forces a lookup
					textFieldName = "label";
					break;
				case ( ui[ "echo" ] is TextField ) :
					textFieldName = "echo";
					break;
			}
			return textFieldName;
		}

		// we leave this public so that future situations the click can be triggered from outside
		public function btnClicked( e : MouseEvent = null) : void
		{
			trace( CN + ".btnClicked" );

			// system event


			// url
			if( _info.linkURL != null )
			{
				URLservice.launchURL( _info.linkURL, _info.linkTarget );
			}

			// share

		}

		private function imageInitialized( image : DisplayObject = null ) : void
		{
			trace( CN + ".imageInitialized" );

			_imageLoadCount--;
			if( _imageLoadCount <= 0 )
			{
				areImagesLoaded = true;
				signalImagesLoaded.dispatch( images );
			}
		}
	}
}
