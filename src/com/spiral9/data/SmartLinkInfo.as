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
package com.spiral9.data
{

	import com.spiral9.data.media.ImageInfo;
	import com.spiral9.data.sn.SNShareInfo;
	import com.spiral9.utils.DataUtils;
	import com.spiral9.utils.StringService;

	public class SmartLinkInfo
	{
		public var CN : String = "LinkInfo";

		//public var linkID : String;
		public var type : String;

		public var title : String;			// future
		public var body : String;			// future
		public var btnLabel : String;		// future

		public var btnClass : String;
		public var hasDropShadow : Boolean;
		public var glowColor : int;			// future
		public var linkTarget : String = "_blank";
		public var linkURL : String;

		protected var _shareInfo : SNShareInfo;
		protected var _imageInfos : Vector.<ImageInfo>;
		protected var _initObject : Object;

		public function SmartLinkInfo( initObject : Object = null )
		{

			if( initObject != null )
			{
				_initObject = initObject;
				DataUtils.initFromObject( this, _initObject );
			}
		}

		public function toObject() : Object
		{
			trace( CN + ".toObject" );

			return _initObject;
		}

		public function toString( traceLevel : int = 0 ) : String
		{
			return StringService.stringify( this, traceLevel + 1 );
		}

		public function get shareInfo() : Object
		{
			return _shareInfo;
		}

		public function set shareInfo( shareInfo : Object ) : void
		{
			_shareInfo = new SNShareInfo( shareInfo );
		}

		public function get imageInfos() : Object
		{
			return _imageInfos;
		}

		public function set imageInfos( imageInfos : Object ) : void
		{
			switch( true )
			{
				case ( imageInfos is Vector.<*> ) :
					_imageInfos = imageInfos as Vector.<ImageInfo>;
					break;
				case ( imageInfos is Array ) :
					var i : int;
					_imageInfos = new Vector.<ImageInfo>();
					for( i=0; i<imageInfos.length; i++ )
					{
						_imageInfos.push( new ImageInfo( imageInfos[ i ] ) );
					}
					break;
				default :
					trace( "\tERROR : imageInfos cannot be assigned :" + imageInfos + ":" );
			}
		}

		protected function setBtnLabel() : void
		{
			if( !hasOwnProperty( "btnLabel" ) )
			{
				switch( type )
				{
					case SmartLinkTypes.TYPE_BTN_FB_SHARE :
						btnLabel = SmartLinkTypes.LABEL_BTN_FB_SHARE;
						break;
					case SmartLinkTypes.TYPE_BTN_FB_CONNECT :
						btnLabel = SmartLinkTypes.LABEL_BTN_FB_CONNECT;
						break;
					case SmartLinkTypes.TYPE_BTN_FB_INVITE_FRIENDS :
						btnLabel = SmartLinkTypes.LABEL_BTN_FB_INVITE_FRIENDS;
						break;
					case SmartLinkTypes.TYPE_BTN_PLAY :
						btnLabel = SmartLinkTypes.LABEL_BTN_PLAY;
						break;
					case SmartLinkTypes.TYPE_BTN_PLAY_AGAIN :
						btnLabel = SmartLinkTypes.LABEL_BTN_PLAY_AGAIN;
						break;
					case SmartLinkTypes.TYPE_BTN_PLAY_NOW :
						btnLabel = SmartLinkTypes.LABEL_BTN_PLAY_NOW;
						break;
					case SmartLinkTypes.TYPE_BTN_PLAY_NEXT :
						btnLabel = SmartLinkTypes.LABEL_BTN_PLAY_NEXT;
						break;
					case SmartLinkTypes.TYPE_BTN_COLLECT_AND_GO :
						// no default
						btnLabel = "";
						break;
					case SmartLinkTypes.TYPE_PANE_SCORE_0 :
						btnLabel = SmartLinkTypes.LABEL_PANE_SCORE_0;
						break;
					case SmartLinkTypes.TYPE_PANE_REWARD_XP :
						// no default
						btnLabel = "";
						break;
					case SmartLinkTypes.TYPE_PANE_REWARD_COINS :
						// no default
						btnLabel = "";
						break;
					case SmartLinkTypes.TYPE_PANE_REWARD_TICKETS :
						// no default
						btnLabel = "";
						break;
					case SmartLinkTypes.TYPE_BTN_START :
						btnLabel = SmartLinkTypes.LABEL_BTN_START;
						break;
					case SmartLinkTypes.TYPE_BTN_PURCHASE :
						btnLabel = SmartLinkTypes.LABEL_BTN_PURCHASE;
						break;
					case SmartLinkTypes.TYPE_BTN_COLLECT :
						btnLabel = SmartLinkTypes.LABEL_BTN_COLLECT;
						break;
					case SmartLinkTypes.TYPE_BTN_USE_TICKETS :
						// FIXME : not too useful of a default...
						btnLabel = SmartLinkTypes.LABEL_BTN_USE_TICKETS;
						break;
					default :
						btnLabel = "";
				}
			}
		}
	}
}
