package com.spiral9.data
{
	import com.spiral9.utils.StringUtils;

	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	public class URLrequestInfo
	{
		public var CN : String = "URLrequestInfo";
		
		public var url : String;
		public var urlVars : URLVariables;
		public var targetFile : File;
		
		private var _onComplete : Function;
		private var _onProgress : Function;
		private var _onStatus : Function;
		private var _onError : Function;
		private var _method : String = URLRequestMethod.GET;
		private var _requestHeaders : Array;

		public function URLrequestInfo( initObject : Object = null )
		{
			if ( initObject != null )
			{
				url = initObject.url;
				urlVars = initObject.urlVars;
				onComplete = initObject.onComplete;
				onStatus = initObject.onStatus;
				onError = initObject.onError;
				method = initObject.method;
				requestHeaders = initObject.requestHeaders;
			}
		}

		public function get method() : String
		{
			if ( _method == null || _method == "" )
			{
				_method = URLRequestMethod.GET;
			}

			return _method;
		}

		public function set method( newMethod : String ) : void
		{
			switch( true )
			{
				case( newMethod == URLRequestMethod.DELETE ) :
				case( newMethod == URLRequestMethod.GET ) :
				case( newMethod == URLRequestMethod.HEAD ) :
				case( newMethod == URLRequestMethod.OPTIONS ) :
				case( newMethod == URLRequestMethod.POST ) :
				case( newMethod == URLRequestMethod.PUT ) :
					_method = newMethod;
					break;
				default :
					_method = URLRequestMethod.GET;
					break;
			}
		}

		public function get requestHeaders() : Array
		{
			//if ( _requestHeaders == null )
			//{
			//	_requestHeaders = [ HTTPservice.getBasicAuthHeader( UserInfo.username, UserInfo.password ) ];
			//}
			return _requestHeaders;
		}

		public function set requestHeaders( newRequestHeaders : * ) : void
		{
			switch( true )
			{
				case( newRequestHeaders is Array ) :
					_requestHeaders = newRequestHeaders;
					break;
				case( newRequestHeaders != null ) :
					_requestHeaders = [ newRequestHeaders ];
					break;
				default :
					_requestHeaders = null;
			}
		}

		public function get onStatus() : Function
		{
			if( _onStatus == null )
			{
				_onStatus = function( e : HTTPStatusEvent ) : void
				{
					//trace( e );
				};
			}
			return _onStatus;
		}

		public function set onStatus( newOnStatus : Function ) : void
		{
			_onStatus = newOnStatus;
		}

		public function get onError() : Function
		{
			if( _onError == null )
			{
				_onError = function( e : ErrorEvent ) : void
				{
					trace( e );
				};
			}
			return _onError;
		}

		public function set onError( newOnError : Function ) : void
		{
			_onError = onError;
		}

		public function toString() : String
		{
			return CN + ":\n" + StringUtils.objectToPrettyJSON( this );
		}

		public function get onComplete() : Function
		{
			if( _onComplete == null )
			{
				_onComplete = function( e : Event ) : void
				{
					trace( e );
				};
			}
			return _onComplete;
		}

		public function set onComplete( onComplete : Function ) : void
		{
			_onComplete = onComplete;
		}

		public function get onProgress() : Function
		{
			if( _onProgress == null )
			{
				_onProgress = function( e : ProgressEvent ) : void
				{
					trace( e );
				};
			}
			return _onProgress;
		}

		public function set onProgress( onProgress : Function ) : void
		{
			_onProgress = onProgress;
		}
	}
}
