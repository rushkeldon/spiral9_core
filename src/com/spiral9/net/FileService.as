/* (C) 2008 - 2012 SPIRAL9, INC. ( SPIRAL9 )
 * All Rights Reserved.
 *
 * NOTICE:  SPIRAL9 permits you to use, modify, and distribute this file in
 * accordance with the terms of the SPIRAL9 license agreement accompanying it.
 * If you have received this file without a license agreement or from a source
 * other than SPIRAL9 then your use, modification, or distribution of it requires
 * the prior written permission of SPIRAL9, INC.
 *******************************************************************************/
package com.spiral9.net
{

	import com.spiral9.data.FileInfo;

	import org.osflash.signals.natives.NativeSignal;

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.AsyncErrorEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;

	public class FileService
	{
		public static const CN : String = "FileLoader";
		public static const INTERVAL_SWSPIRAL9P : int = 2 * 1000;
		private static var _loader : Loader;
		private static var _conversionLoader : Loader;
		private static var _URLLoader : URLLoader;
		private static var _urlRequest : URLRequest;
		private static var _loaderContext : LoaderContext;
		private static var _eventDispatcher : *;
		private static var _filesInMemory : Vector.<FileInfo>;
		private static var _pendingRequests : Array;
		private static var _currentFileInfo : FileInfo;
		private static var _lastFileInfo : FileInfo;
		private static var _instance : FileService;
		private static var _allowInstance : Boolean;
		private static var _signalAsyncErrorEncountered : NativeSignal;
		private static var _signalSWFunloaded : NativeSignal;
		private static var _signalInitialized : NativeSignal;
		private static var _signalLoadingComplete : NativeSignal;
		private static var _signalHTTPstatusReceived : NativeSignal;
		private static var _signalUncaughtErrorEncountered : NativeSignal;
		private static var _signalIOErrorEncountered : NativeSignal;
		private static var _signalStreamOpened : NativeSignal;
		private static var _signalProgress : NativeSignal;
		private static var _signalSecurityErrorEncountered : NativeSignal;
		private static var _signalLoaderUncaughtErrorEncountered : NativeSignal;
		private static var _signalLoaderConversionComplete : NativeSignal;
		private static var dispatcherEvents : Array;
		private static var loaderEvents : Array;
		private var signalLoaderUncaughtError : NativeSignal;

		public function FileService()
		{
			//trace( CN + " instantiated." );

			if( _allowInstance )
			{
				_loader = new Loader();
				_URLLoader = new URLLoader();
				_conversionLoader = new Loader();
				_loaderContext = new LoaderContext( false, ApplicationDomain.currentDomain );
				_loaderContext.allowCodeImport = true;
				_filesInMemory = new Vector.<FileInfo>();
				_pendingRequests = new Array();

				dispatcherEvents = new Array();
				loaderEvents = new Array();
				signalLoaderUncaughtError = new NativeSignal( _loader.uncaughtErrorEvents, UncaughtErrorEvent.UNCAUGHT_ERROR, UncaughtErrorEvent );
			}
			else
			{
				throw new Error( "singleton" );
			}
		}

		public static function getInstance() : FileService
		{
			createInstance();
			return _instance;
		}

		private static function createInstance() : void
		{
			if( _instance == null )
			{
				_allowInstance = true;
				_instance = new FileService();
				_allowInstance = false;
			}
		}

		public static function load( fileInfo : FileInfo, forceRefresh : Boolean = false ) : void
		{
			//trace( CN + ".load" );
			//trace( "\tfileInfo.url:" + fileInfo.url + ":" );

			createInstance();

			if( fileInfo.url == null || fileInfo.url == "" || fileInfo.url == "null" )
			{
				trace( "\tERROR : Not loading because no valid url found." );

				fileInfo.status = FileInfo.STATUS_FAILED;
				if( fileInfo.callBack != null )
				{
					callBack( fileInfo );
					return;
				}
			}

			var cachedFileInfo : FileInfo;

			if( !forceRefresh )
			{
				cachedFileInfo = getCachedFileInfo( fileInfo );

				if( cachedFileInfo != null )
				{
					remapFileInfo( cachedFileInfo, fileInfo );
					callBack( cachedFileInfo );
					return;
				}
			}

			_pendingRequests.push( fileInfo );

			// if this is the only one in line...
			if( _pendingRequests.length == 1 && _currentFileInfo == null )
			{
				sendNextPendingRequest();
			}
		}

		public static function unload( fileInfo : FileInfo ) : void
		{
		}

		private static function remapFileInfo( oldFileInfo : FileInfo, newFileInfo : FileInfo ) : void
		{
			oldFileInfo.callBack = newFileInfo.callBack;
		}

		public static function unloadAndStop() : void
		{
			_loader.unloadAndStop();
			// _URLLoader.unloadAndStop();
			_conversionLoader.unloadAndStop();
		}

		private static function currentResponseProcessed() : void
		{
			_lastFileInfo = _currentFileInfo;
			_currentFileInfo = null;
			_loader = null;
			_URLLoader = null;
			_conversionLoader = null;
			callBack();
			sendNextPendingRequest();
		}

		private static function getCachedFileInfo( fileInfo : FileInfo ) : FileInfo
		{
			//trace( CN + ".getCachedFileInfo" );

			var cachedFileInfo : FileInfo;
			var matchingFileInfo : FileInfo;

			for each( cachedFileInfo in _filesInMemory )
			{
				if( cachedFileInfo.url == fileInfo.url && cachedFileInfo.status == FileInfo.STATUS_LOADED )
				{
					//trace( "\tCached fileInfo found with :\n\t• A matching url :" + cachedFileInfo.url + ":\n\t• A status of :" + cachedFileInfo.status + ":" );

					matchingFileInfo = cachedFileInfo;
					matchingFileInfo.wasCached = true;
					break;
				}
			}
			return( matchingFileInfo );
		}
		
		public static function getClass( classname : String, url : String = "" ) : Class
		{
			//trace( CN + ".getClass", url, "::", classname );
			
			var cachedFileInfo : FileInfo = getCachedFileInfo( new FileInfo( url ) );
			var loadedClass : Class;
			
			if( cachedFileInfo != null )
			{
				try
				{
					loadedClass = cachedFileInfo.loader.contentLoaderInfo.applicationDomain.getDefinition( classname ) as Class;
					return loadedClass;
				}
				catch( e : Error )
				{
					loadedClass = null;
				}
			}
			
			// Only look here if we didn't find it already and we don't care what URL it came from, otherwise...
			// these aren't the droids you're looking for
			if( loadedClass == null && url == "" )
			{
				for each( cachedFileInfo in _filesInMemory )
				{
					try
					{
						loadedClass = cachedFileInfo.loader.contentLoaderInfo.applicationDomain.getDefinition( classname ) as Class;
						return loadedClass;
					}
					catch( e : Error )
					{
						loadedClass = null;
					}
				}
			}
			
			// Finally, try looking in the main AppDom
			if( loadedClass == null && url == "" )
			{
				try
				{
					loadedClass = ApplicationDomain.currentDomain.getDefinition( classname ) as Class;
				}
				catch( e : Error )
				{
					loadedClass = null;
				}
			}
			
			if( loadedClass == null ){ trace( "\tNOTICE : " + CN + ".getClass failed to find class >"+classname+"< Returning null."); }
			return loadedClass;
		}

		private static function sendNextPendingRequest() : void
		{
			//trace( CN + ".sendNextPendingRequest" );

			// check to see if we are all done with requests
			if( _pendingRequests.length == 0 )
			{
				if( _currentFileInfo != null )
				{
					switch( true )
					{
						case ( _currentFileInfo.status == FileInfo.STATUS_FAILED ) :
						case ( _currentFileInfo.status == FileInfo.STATUS_LOADED && _currentFileInfo.lastEventType == Event.COMPLETE ) :
							removeListeners();
							break;
					}
				}
				//trace( "\tNo more requests to send." );
				return;
			}

			_currentFileInfo = _pendingRequests.shift();

			switch( _currentFileInfo.type )
			{
				case FileInfo.TYPE_IMAGE :
				case FileInfo.TYPE_SWF_EXTERNAL :
					requestViaLoader();
					break;
				case FileInfo.TYPE_SWF_INTERNAL :
				case FileInfo.TYPE_BINARY :
				case FileInfo.TYPE_TEXT :
				case FileInfo.TYPE_VARIABLES :
					requestViaURLLoader();
					break;
				case FileInfo.TYPE_SOUND :
					requestViaSound();
					break;
				default :
					trace( "\tERROR : not have a valid type:" + _currentFileInfo.type );
					_currentFileInfo.status = FileInfo.STATUS_FAILED;
					return;
			}
		}

		private static function requestViaSound() : void
		{
			_currentFileInfo.sound = new Sound();

			addListeners();
			_urlRequest = new URLRequest( _currentFileInfo.url );
			_currentFileInfo.sound.load( _urlRequest );
		}

		private static function requestViaLoader() : void
		{
			//trace( CN + ".requestViaLoader" );

			_loader = new Loader();

			addListeners();
			_urlRequest = new URLRequest( _currentFileInfo.url );
			_loaderContext.checkPolicyFile = _currentFileInfo.checkPolicyFile;
			_loaderContext.applicationDomain = new ApplicationDomain();
			_loader.load( _urlRequest, _loaderContext );
		}

		private static function requestViaURLLoader() : void
		{
			//trace( CN + ".requestViaURLLoader" );

			_URLLoader = new URLLoader();
			if( _currentFileInfo.type == FileInfo.TYPE_SWF_INTERNAL )
			{
				_URLLoader.dataFormat = URLLoaderDataFormat.BINARY;
			}
			addListeners();
			_urlRequest = new URLRequest( _currentFileInfo.url );
			_URLLoader.load( _urlRequest );
		}

		private static function addListeners() : void
		{
			//trace( CN + ".addListeners" );

			removeListeners();

			//trace( "\t - now really addin the listeners." );

			switch( _currentFileInfo.type )
			{
				case FileInfo.TYPE_IMAGE :
				case FileInfo.TYPE_SWF_EXTERNAL :
					_eventDispatcher = _loader.contentLoaderInfo;
					_signalAsyncErrorEncountered = new NativeSignal( _eventDispatcher, AsyncErrorEvent.ASYNC_ERROR, AsyncErrorEvent );
					_signalSWFunloaded = new NativeSignal( _eventDispatcher, Event.UNLOAD, Event );
					_signalInitialized = new NativeSignal( _eventDispatcher, Event.INIT, Event );
					dispatcherEvents.push( _signalAsyncErrorEncountered, _signalSWFunloaded, _signalInitialized );
					_signalAsyncErrorEncountered.add( onAsyncErrorEvent );
					_signalSWFunloaded.add( onUnload );
					_signalInitialized.add( onInit );
					// add Loader specific
					_signalLoaderUncaughtErrorEncountered = new NativeSignal( _loader.uncaughtErrorEvents, UncaughtErrorEvent.UNCAUGHT_ERROR, UncaughtErrorEvent );
					loaderEvents.push( _signalLoaderUncaughtErrorEncountered );
					_signalLoaderUncaughtErrorEncountered.add( onUncaughtError );
					break;
				case FileInfo.TYPE_SWF_INTERNAL :
					_URLLoader.dataFormat = FileInfo.TYPE_BINARY;
					_eventDispatcher = _URLLoader;
					break;
				case FileInfo.TYPE_SOUND :
					_eventDispatcher = _currentFileInfo.sound;
					break;
				case FileInfo.TYPE_BINARY :
				case FileInfo.TYPE_TEXT :
				case FileInfo.TYPE_VARIABLES :
					_URLLoader.dataFormat = _currentFileInfo.type;
					_eventDispatcher = _URLLoader;
					break;
				default :
					trace( "\tERROR : listeners not added because there is an unsupported _currentFileInfo.type:" + _currentFileInfo.type + ":" );
					return;
			}

			// add common listeners
			_signalLoadingComplete = new NativeSignal( _eventDispatcher, Event.COMPLETE, Event );
			_signalHTTPstatusReceived = new NativeSignal( _eventDispatcher, HTTPStatusEvent.HTTP_STATUS, HTTPStatusEvent );
			_signalUncaughtErrorEncountered = new NativeSignal( _eventDispatcher, UncaughtErrorEvent.UNCAUGHT_ERROR, UncaughtErrorEvent );
			_signalIOErrorEncountered = new NativeSignal( _eventDispatcher, IOErrorEvent.IO_ERROR, IOErrorEvent );
			_signalStreamOpened = new NativeSignal( _eventDispatcher, Event.OPEN, Event );
			_signalProgress = new NativeSignal( _eventDispatcher, ProgressEvent.PROGRESS, ProgressEvent );
			_signalSecurityErrorEncountered = new NativeSignal( _eventDispatcher, SecurityErrorEvent.SECURITY_ERROR, SecurityErrorEvent );

			dispatcherEvents.push( _signalLoadingComplete, _signalHTTPstatusReceived, _signalUncaughtErrorEncountered, _signalIOErrorEncountered, _signalStreamOpened, _signalProgress, _signalSecurityErrorEncountered );

			_signalLoadingComplete.add( onComplete );
			_signalHTTPstatusReceived.add( onHTTPStatusEvent );
			_signalUncaughtErrorEncountered.add( onUncaughtError );
			_signalIOErrorEncountered.add( onIOErrorEvent );
			_signalStreamOpened.add( onOpen );
			_signalProgress.add( onProgressEvent );
			_signalSecurityErrorEncountered.add( onSecurityErrorEvent );
		}

		private static function removeListeners() : void
		{
			//trace( CN + ".removeListeners" );

			var signal : NativeSignal;

			if( _loader != null )
			{
				for each( signal in loaderEvents )
				{
					signal.removeAll();
				}
				loaderEvents = new Array();
			}
			if( _eventDispatcher != null )
			{
				for each( signal in dispatcherEvents )
				{
					signal.removeAll();
				}
				dispatcherEvents = new Array();
			}
		}

		private static function onInit( e : Event ) : void
		{
			//trace( CN + ".onInit" );

			_currentFileInfo.status = FileInfo.STATUS_LOADED;
			_currentFileInfo.lastEventType = e.type;
		}

		private static function onComplete( e : Event ) : void
		{
			//trace( CN + ".onComplete" );
			//trace( "\t_currentFileInfo.url:" + _currentFileInfo.url + ":" );
			_loaderContext.checkPolicyFile = false;
			_currentFileInfo.status = FileInfo.STATUS_LOADED;
			_currentFileInfo.lastEventType = e.type;

			switch( _currentFileInfo.type )
			{
				case FileInfo.TYPE_SWF_INTERNAL :
					_conversionLoader = new Loader();
					_signalLoaderConversionComplete = new NativeSignal( _conversionLoader.contentLoaderInfo, Event.COMPLETE, Event );
					_signalLoaderConversionComplete.addOnce( inductSWF );
					_conversionLoader.loadBytes( _URLLoader.data, _loaderContext );
					return;
					break;
				case FileInfo.TYPE_SWF_EXTERNAL :
					//trace( "\tNow assigning the loader to the _loader." );
					_currentFileInfo.loader = _loader;
					break;
				case FileInfo.TYPE_IMAGE :
					//trace( "\te.target.content:" + e.target.content + ":" );
					_currentFileInfo.bitmap = e.target.content as Bitmap;
					break;
				case FileInfo.TYPE_SOUND :
					// do nothing - already assigned the sound property
					break;
				case FileInfo.TYPE_BINARY :
					_currentFileInfo.byteArray = e.target.data as ByteArray;
					break;
				case FileInfo.TYPE_VARIABLES :
					_currentFileInfo.vars = e.target.data as URLVariables;
					break;
				case FileInfo.TYPE_TEXT :
					_currentFileInfo.text = String( e.target.data );
			}
			currentResponseProcessed();
		}

		private static function callBack( fileInfoToSend : FileInfo = null ) : void
		{
			//trace( CN + ".callBack" );

			var fileInfo : FileInfo;

			if( fileInfoToSend != null )
			{
				fileInfo = fileInfoToSend;
			}
			else
			{
				fileInfo = _lastFileInfo;
			}

			cacheFileInfo( fileInfo );

			fileInfo.callBack( fileInfo );
			fileInfo.signalNetworkingFinished.dispatch( fileInfo );	// TODO : probably should get rid of callback and *only* use this signal?
		}

		private static function cacheFileInfo( fileInfo : FileInfo ) : void
		{
			//trace( CN + ".cacheFileInfo" );

			if( _filesInMemory.indexOf( fileInfo ) == -1 )
			{
				//trace( "\tAdding to _filesInMemory : fileInfo.url:" + fileInfo.url + ":" );
				_filesInMemory.push( fileInfo );
			}
		}

		private static function inductSWF( e : Event ) : void
		{
			//trace( CN + ".inductSWF" );

			_currentFileInfo.loader = _conversionLoader;
			currentResponseProcessed();
		}

		private static function onUncaughtError( e : UncaughtErrorEvent ) : void
		{
			trace( CN + ".onUncaughtError" );

			var error : *;

			_currentFileInfo.status = FileInfo.STATUS_FAILED;
			_currentFileInfo.lastEventType = e.type;

			switch( true )
			{
				case ( e.error is Error ) :
					error = e.error as Error;
					break;
				case ( e.error is ErrorEvent ) :
					error = e.error as ErrorEvent;
					break;
				default :
					error = new Error( "unknownError" );
			}
			_currentFileInfo.error = error;
			_currentFileInfo.signalUncaughtErrorEncountered.dispatch( e );
			currentResponseProcessed();
		}

		private static function onAsyncErrorEvent( e : AsyncErrorEvent ) : void
		{
			trace( CN + ".onAsyncErrorEvent" );
			_currentFileInfo.lastEventType = e.type;
			_currentFileInfo.status = FileInfo.STATUS_FAILED;
			_currentFileInfo.signalAsyncErrorEncountered.dispatch( e );
			currentResponseProcessed();
		}

		private static function onHTTPStatusEvent( e : HTTPStatusEvent ) : void
		{
			//trace( CN + ".onHTTPStatusEvent" );
			_currentFileInfo.lastEventType = e.type;
		}

		private static function onIOErrorEvent( e : IOErrorEvent ) : void
		{
			trace( CN + ".onIOErrorEvent" );
			_currentFileInfo.lastEventType = e.type;
			_currentFileInfo.status = FileInfo.STATUS_FAILED;
			_currentFileInfo.signalIOErrorEncountered.dispatch( e );
			currentResponseProcessed();
		}

		private static function onSecurityErrorEvent( e : SecurityErrorEvent ) : void
		{
			trace( CN + ".onSecurityErrorEvent" );
			_currentFileInfo.lastEventType = e.type;
			_currentFileInfo.status = FileInfo.STATUS_FAILED;
			_currentFileInfo.signalSecurityErrorEncountered.dispatch( e );
			currentResponseProcessed();
		}

		private static function onProgressEvent( e : ProgressEvent ) : void
		{
			// //trace ( CN + ".onProgressEvent" );
			_currentFileInfo.lastEventType = e.type;
			_currentFileInfo.signalProgress.dispatch( e );
		}

		private static function onOpen( e : Event ) : void
		{
			//trace( CN + ".onOpen" );
			_currentFileInfo.lastEventType = e.type;
		}

		private static function onUnload( e : Event ) : void
		{
			//trace( CN + ".onUnload" );
			_currentFileInfo.lastEventType = e.type;
			_currentFileInfo.signalUnloaded.dispatch( e );
		}
	}
}
