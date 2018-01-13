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

package com.spiral9.data.sn
{

	import com.spiral9.data.IAnalyticsInfo;
	import com.spiral9.data.actionengine.ReportInfo;
	import com.spiral9.data.actionengine.Reports;
	import com.spiral9.data.media.VideoInfo;
	import com.spiral9.utils.Conversion;
	import com.spiral9.utils.DataUtils;
	import com.spiral9.utils.StringService;

	import flash.net.URLVariables;


	public class SNShareInfo extends ReportInfo implements IAnalyticsInfo
	{
		public static const ID_DYNAMIC			: String = "dynamic";
		public static const EMBED_TYPE_VIDEO	: String = "video";
		public static const EMBED_TEYP_SWF		: String = "swf";

		public var sn                : String;
		public var shareID           : String;
		public var postName          : String;
		public var postLink          : String;
		public var postPicture       : String;
		public var postDescription   : String;
		public var postMessage       : String;
		public var postCaption       : String;
		public var postActionName    : String;
		public var postActionLink    : String;
		public var displayContainer  : String = "iframe";
		public var embedType		 : String;
		public var embedID			 : String;
		public var source			 : String;

		protected var _initObject : Object;

		public function SNShareInfo( initObject : Object = null )
		{
			super();
			CN = "SNShareInfo";
			trace( CN + ".instantiated" );

			reportType = Reports.REPORT_SN_SHARE_NEEDED;
			infoClass = SNShareInfo;

			StringService.registerLookup( "title", replaceMovieParams );
			StringService.registerLookup( "year", replaceMovieParams );
			StringService.registerLookup( "copyright", replaceMovieParams );
			StringService.registerLookup( "purchaseURL", replaceMovieParams );

			if( initObject != null )
			{
				_initObject = initObject;

				if( DataUtils.hasProp( initObject, "sn" ) ){ sn = initObject.sn; }
				if( DataUtils.hasProp( initObject, "shareID" ) ){ shareID = initObject.shareID; }
				if( DataUtils.hasProp( initObject, "postName" ) ){ postName = initObject.postName; }
				if( DataUtils.hasProp( initObject, "postLink" ) ){ postLink = initObject.postLink; }
				if( DataUtils.hasProp( initObject, "postPicture" ) ){ postPicture = initObject.postPicture; }
				if( DataUtils.hasProp( initObject, "postDescription" ) ){ postDescription = initObject.postDescription; }
				if( DataUtils.hasProp( initObject, "postMessage" ) ){ postMessage = initObject.postMessage; }
				if( DataUtils.hasProp( initObject, "postCaption" ) ){ postCaption = initObject.postCaption; }
				if( DataUtils.hasProp( initObject, "postActionName" ) ){ postActionName = initObject.postActionName; }
				if( DataUtils.hasProp( initObject, "postActionLink" ) ){ postActionLink = initObject.postActionLink; }
				if( DataUtils.hasProp( initObject, "displayContainer" ) ){ displayContainer = initObject.displayContainer; }
				if( DataUtils.hasProp( initObject, "embedType" ) ){ embedType = initObject.embedType; }
				if( DataUtils.hasProp( initObject, "embedID" ) ){ embedID = initObject.embedID; }
				if( DataUtils.hasProp( initObject, "source" ) ){ source = initObject.source; }
			}

			postActionName = StringService.processServerString( postActionName );
			postActionLink = StringService.processServerString( postActionLink );
			postMessage = StringService.processServerString( postMessage );
			postCaption = StringService.processServerString( postCaption );
			postDescription = StringService.processServerString( postDescription );

			StringService.removeLookup( "title" );
			StringService.removeLookup( "year" );
			StringService.removeLookup( "copyright" );
			StringService.removeLookup( "purchaseURL" );
		}


		public function replaceMovieParams( propName : String, type : String ) : String
		{
			trace( CN + ".replaceMovieParams" );

			var value : String = "";
			if( source == "" ){ return value; }

			var base64VideoInfo : String = source.slice( source.lastIndexOf( "vi=" ) + 3 );
			var vi : VideoInfo = new VideoInfo( Conversion.base64jsonToObject( base64VideoInfo ) );

			try
			{
				value = vi.movieInfo[propName];
			}
			catch( e : Error )
			{
				trace( "Replace Param", e );
				value = "";
			}

			return value;

		}

		public function get data() : Object
		{
			var action : Object = {	name : postActionName,
									link : postActionLink };

			var data : Object = {	name : postName,
									link : postLink,
									picture : postPicture,
									description : postDescription,
									caption : postCaption,
									message : postMessage,
									filters : [] };

			// Add embedded media 'source' to the FB share data
			if( source != null && source != "" )
			{
				data['source'] = source;
			}

			// Both a Name and Link are required for the action property
			if( action["name"] != null && action["name"] != "" &&
				action["link"] != null && action["link"] != "" )
			{
				data["actions"] = action;
			}

			return data;
		}

		public static function get testData() : Object
		{
			var action : Object = {	name : "actionName",
									link : "http://www.Hollywoodplayer.com" };

			var data : Object = {	name : "postName",
									link : "http://www.Facebook.com/Hollywoodplayer",
									picture : "assets.hollywoodplayer.com/img/big_lebowski_010_140x95.jpg",
									description : "postDescription",
									caption : "postCaption",
									actions : action,
									filters : [] };
			return data;
		}

		override public function toURLvars() : URLVariables
		{
			//trace( CN + ".toURLvars" );

			super.toURLvars();
			urlVars['shareID'] = shareID;

			// Add embedded media parameters if both exist
			if( embedType && embedID )
			{
				urlVars['embedType'] = embedType;
				urlVars['embedID'] = embedID;
			}

			return urlVars;
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

		public function get analyticEventText() : String
		{
			return String( sn ) + '-' + String( shareID );
		}
	}
}
