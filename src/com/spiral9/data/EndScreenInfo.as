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

	import com.adobe.serialization.json.JSON;
	import com.spiral9.data.media.ImageInfo;
	import com.spiral9.utils.StringService;

	public class EndScreenInfo
	{
		public var CN : String = "EndScreenInfo";

		//public var imageInfos : Vector.<ImageInfo>;
		public var linkInfos : Vector.<SmartLinkInfo>;

		// general
		public var endScreenBGImageInfo : ImageInfo;

		// headerBar
		public var headerBarBGImageInfo : ImageInfo;
		public var logoGameImageInfo : ImageInfo;
		public var logoBrandImageInfo : ImageInfo;
		public var merchantPanelBGImageInfo : ImageInfo;
		public var rewardPanelBGImageInfo : ImageInfo;
/* */
		public var btnCollectLinkInfo : SmartLinkInfo;
		public var btnFBconnectLinkInfo : SmartLinkInfo;
		public var btnFBinviteFriendsLinkInfo : SmartLinkInfo;
		public var btnPlayLinkInfo : SmartLinkInfo;
		public var btnPlayNextLinkInfo : SmartLinkInfo;
		public var btnPlayNowLinkInfo : SmartLinkInfo;
		public var btnPurchaseLinkInfo : SmartLinkInfo;
		public var btnStartLinkInfo : SmartLinkInfo;
		public var btnUseTicketsLinkInfo : SmartLinkInfo;
/* */

		// rewardPanel
		public var paneScore0LinkInfo : SmartLinkInfo;
		public var paneScore1LinkInfo : SmartLinkInfo;
		public var paneRewardCoinsLinkInfo : SmartLinkInfo;
		public var paneRewardTicketsLinkInfo : SmartLinkInfo;
		public var paneRewardXPLinkInfo : SmartLinkInfo;

		// merchantPanel LinkInfos
		public var imgCommerceLinkInfo : SmartLinkInfo;			//"poster";               // FIXME : JSON prop name needs fixing
		public var panelCourtesyLinkInfo : SmartLinkInfo;			//"courtesey";            // FIXME : JSON prop name needs fixing
		public var btnCommerce0LinkInfo : SmartLinkInfo;			//"button";               // FIXME : JSON prop name needs fixing
		public var btnCommerce1LinkInfo : SmartLinkInfo;

		// rewardPanel LinkInfos
		public var btnCollectAndGoLinkInfo : SmartLinkInfo;
		public var btnPlayAgainLinkInfo : SmartLinkInfo;
		public var btnFBshareLinkInfo : SmartLinkInfo;

		// adPanel LinkInfos
		public var panelAdLinkInfo : SmartLinkInfo;				//"endscreen_banner";     // FIXME : JSON prop name needs fixing

		// brandBar LinkInfos
		public var barBrandLinkInfo : SmartLinkInfo;				//"brandBar";             // FIXME : JSON prop name needs fixing
		/**/

		public function EndScreenInfo( initObject : Object = null )
		{
			if( initObject != null )
			{
				// ImageInfos
				endScreenBGImageInfo = ( initObject.endScreenBGinfo == null ) ? null : new ImageInfo( initObject.endScreenBGinfo );
				headerBarBGImageInfo = ( initObject.headerBarBGinfo == null ) ? null : new ImageInfo( initObject.headerBarBGinfo );
				logoBrandImageInfo = ( initObject.logoBrandImageInfo == null ) ? null : new ImageInfo( initObject.logoBrandImageInfo );
				logoGameImageInfo = ( initObject.logoBrandImageInfo == null ) ? null : new ImageInfo( initObject.logoGameImageInfo );
				merchantPanelBGImageInfo = ( initObject.logoBrandImageInfo == null ) ? null : new ImageInfo( initObject.merchantPanelBGinfo );
				rewardPanelBGImageInfo = ( initObject.rewardPanelBGinfo == null ) ? null : new ImageInfo( initObject.rewardPanelBGinfo );

				if( initObject.LinkInfos != null )
				{
					var linkInitObject : Object;
					var linkInfo : SmartLinkInfo;

					linkInfos = new Vector.<SmartLinkInfo>();

					for each( linkInitObject in initObject.LinkInfos )
					{
						linkInfo = new SmartLinkInfo( linkInitObject );
						linkInfos.push( linkInfo );

						// FIXME : this switch statment is only here to special case these odd property names
						//         once these are fixed then we will only need the default case
						switch( linkInfo.type )
						{
							case "poster" :
								imgCommerceLinkInfo = linkInfo;
								break;
							case "courtesey" :
								panelCourtesyLinkInfo = linkInfo;
								break;
							case "button" :
								if( btnCommerce0LinkInfo == null )
								{
									btnCommerce0LinkInfo = linkInfo;
								}
								else
								{
									btnCommerce1LinkInfo = linkInfo;
								}
								break;
							case "endscreen_banner" :
								panelAdLinkInfo = linkInfo;
								break;
							case "brandBar" :
								barBrandLinkInfo = linkInfo;
								break;
							default :
								try
								{
									this[ linkInitObject.type + "LinkInfo" ] = linkInfo;
								}
								catch( e : Error )
								{
									trace( "\t" + CN + " : there is no property with the name :" + linkInitObject.type + "LinkInfo" + ":" );
									trace( "\tERROR :" + e );
								}
						}
					}
				}
			}
		}

		public function toObject() : Object
		{
			trace( CN + ".toObject" );

			var o : Object = new Object();
			var linkInfo : SmartLinkInfo;

			// ImageInfos
			o.endScreenBGinfo = ( endScreenBGImageInfo == null ) ? null : endScreenBGImageInfo.toObject();
			o.headerBarBGinfo = ( headerBarBGImageInfo == null ) ? null : headerBarBGImageInfo.toObject();
			o.logoGameImageInfo = ( logoGameImageInfo == null ) ? null : logoGameImageInfo.toObject();
			o.logoBrandImageInfo = ( logoBrandImageInfo == null ) ? null : logoBrandImageInfo.toObject();
			o.merchantPanelBGinfo = ( merchantPanelBGImageInfo == null ) ? null : merchantPanelBGImageInfo.toObject();
			o.rewardPanelBGinfo = ( rewardPanelBGImageInfo == null ) ? null : rewardPanelBGImageInfo.toObject();

			o.LinkInfos = new Array();
			for each( linkInfo in linkInfos )
			{
				o.LinkInfos.push( linkInfo.toObject() );
			}

			return o;
		}

		public function toString( traceLevel : int = 0 ) : String
		{
			var indent : String = StringService.getIndent( traceLevel );

			var str : String = "\n" + indent + CN + " :\n";
			str += indent + "\t• headerBarBGImageInfo :\t\t" + StringService.stringify( headerBarBGImageInfo, traceLevel + 1 ) + "\n";
			str += indent + "\t• logoGameImageInfo :\t\t" + StringService.stringify( logoGameImageInfo, traceLevel + 1 ) + "\n";
			str += indent + "\t• logoBrandImageInfo :\t\t" + StringService.stringify( logoBrandImageInfo, traceLevel + 1 ) + "\n";
			str += indent + "\t• merchantPanelBGImageInfo :\t\t" + StringService.stringify( merchantPanelBGImageInfo, traceLevel + 1 ) + "\n";
			str += indent + "\t• rewardPanelBGImageInfo :\t\t" + StringService.stringify( rewardPanelBGImageInfo, traceLevel + 1 ) + "\n";
			str += indent + "\t• linkInfos :\t\t" + StringService.stringify( linkInfos, traceLevel + 1 );

			return( str );
		}

		public function toJSON() : String
		{
			return( com.adobe.serialization.json.JSON.encode( toObject() ) );
		}
	}
}
