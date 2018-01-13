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
	import com.spiral9.net.URLservice;
	import com.spiral9.utils.DataUtils;
	import com.spiral9.utils.SignalUtils;
	import com.spiral9.utils.StringUtils;

	import org.osflash.signals.Signal;

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.media.Sound;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;

	public class FileInfo
	{
		public static const TYPE_IMAGE : String = "image";
		public static const TYPE_SWF_INTERNAL : String = "internalSWF";
		public static const TYPE_SWF_EXTERNAL : String = "externalSWF";
		public static const TYPE_BINARY : String = URLLoaderDataFormat.BINARY;
		public static const TYPE_VARIABLES : String = URLLoaderDataFormat.VARIABLES;
		public static const TYPE_TEXT : String = URLLoaderDataFormat.TEXT;
		public static const TYPE_SOUND : String = "typeSound";
		public static const STATUS_PENDING : String = "pending";
		public static const STATUS_LOADING : String = "loading";
		public static const STATUS_LOADED : String = "loaded";
		public static const STATUS_FAILED : String = "failed";

		public var sound : Sound;
		public var bitmap : Bitmap;
		public var byteArray : ByteArray;
		public var callBack : Function;
		public var checkPolicyFile : Boolean = false;
		public var error : *;
		public var lastEventType : String;
		public var loader : Loader;
		public var status : String = STATUS_PENDING;
		public var text : String;
		public var type : String;
		public var vars : URLVariables;
		public var wasCached : Boolean;
		public var id : String;

		public var signalAsyncErrorEncountered : Signal;
		public var signalSWFunloaded : Signal;
		public var signalNetworkingFinished : Signal;
		public var signalLoadingComplete : Signal;
		public var signalHTTPstatusReceived : Signal;
		public var signalUncaughtErrorEncountered : Signal;
		public var signalIOErrorEncountered : Signal;
		public var signalStreamOpened : Signal;
		public var signalProgress : Signal;
		public var signalSecurityErrorEncountered : Signal;
		public var signalLoaderUncaughtErrorEncountered : Signal;
		public var signalUnloaded : Signal;

		private var _url : String = URLservice.BAD_URL;

		public function FileInfo( initObject : Object = null )
		{
			if( initObject != null )
			{
				transferProps( initObject, this );
			}

			signalAsyncErrorEncountered = new Signal( AsyncErrorEvent );
			signalSWFunloaded = new Signal( Event );
			signalNetworkingFinished = new Signal( FileInfo );
			signalLoadingComplete = new Signal( Event );
			signalHTTPstatusReceived = new Signal( HTTPStatusEvent );
			signalUncaughtErrorEncountered = new Signal( UncaughtErrorEvent );
			signalIOErrorEncountered = new Signal( IOErrorEvent );
			signalProgress = new Signal( ProgressEvent );
			signalSecurityErrorEncountered = new Signal( SecurityErrorEvent );
			signalLoaderUncaughtErrorEncountered = new Signal( UncaughtErrorEvent );
			signalUnloaded = new Signal( Event );
		}
		
		private function transferProps( initObject : Object, targetObject : Object ) : void
		{
			DataUtils.transferProp( initObject, targetObject, "url" );
			DataUtils.transferProp( initObject, targetObject, "type" );
			DataUtils.transferProp( initObject, targetObject, "callBack" );
			DataUtils.transferProp( initObject, targetObject, "status" );
		}

		public function toString( traceLevel : int = 0 ) : String
		{
			var o : Object;
			transferProps( this, o );
			o.wasCached = wasCached;
			o.bitmap = bitmap.toString();
			o.byteArray = byteArray.toString();
			o.lastEventType = lastEventType;
			o.text = text;
			o.error = String( error );
			o.vars = vars.toString();
			o.loader = loader.toString();

			return StringUtils.objectToPrettyJSON( o );
		}

		public function get url() : String
		{
			return _url;
		}

		public function set url( url : String ) : void
		{
			_url = URLservice.mapURL( url );
		}

		public function dispose() : void
		{
			if( sound != null )
			{
				sound.close();
				sound = null;
			}

			if( loader != null )
			{
				loader.unloadAndStop( true );
				loader = null;
			}

			bitmap = null;
			byteArray = null;
			callBack = null;
			error = null;
			vars = null;

			/*
			 * checkPolicyFile : Boolean;
			 * wasCached : Boolean;
			 */

			lastEventType = "";
			status = "";
			text = "";
			type = "";
			id = "";

			SignalUtils.disposeOfPublicSignal( "signalAsyncErrorEncountered", this );
			SignalUtils.disposeOfPublicSignal( "signalAsyncErrorEncountered", this );
			SignalUtils.disposeOfPublicSignal( "signalSWFunloaded", this );
			SignalUtils.disposeOfPublicSignal( "signalNetworkingFinished", this );
			SignalUtils.disposeOfPublicSignal( "signalLoadingComplete", this );
			SignalUtils.disposeOfPublicSignal( "signalHTTPstatusReceived", this );
			SignalUtils.disposeOfPublicSignal( "signalUncaughtErrorEncountered", this );
			SignalUtils.disposeOfPublicSignal( "signalIOErrorEncountered", this );
			SignalUtils.disposeOfPublicSignal( "signalStreamOpened", this );
			SignalUtils.disposeOfPublicSignal( "signalProgress", this );
			SignalUtils.disposeOfPublicSignal( "signalSecurityErrorEncountered", this );
			SignalUtils.disposeOfPublicSignal( "signalLoaderUncaughtErrorEncountered", this );
			SignalUtils.disposeOfPublicSignal( "signalUnloaded", this );
		}
	}
}
