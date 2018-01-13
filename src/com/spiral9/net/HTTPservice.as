package com.spiral9.net
{
	import flash.utils.ByteArray;
	import by.blooddy.crypto.Base64;

	import com.spiral9.data.URLrequestInfo;

	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;

	public class HTTPservice
	{
		public static var CN : String = "HTTPservice";

		public static function sendRequest( urlRequestInfo : URLrequestInfo ) : void
		{
			//trace( CN + ".sendRequest" );

			// trace( StringUtils.objectToPrettyJSON( urlRequestInfo ) );

			switch( true )
			{
				case( urlRequestInfo == null ) :
					trace( "\tERROR : urlRequestInfo == null" );
					return;
					break;
				case( urlRequestInfo.url == null || urlRequestInfo.url == "" ) :
					trace( "\tERROR : urlRequestInfo has no 'url' property" );
					return;
					break;
			}

			var statusHandler : Function;
			var completeHandler : Function;
			var ioErrorHandler : Function;
			var urlRequest : URLRequest = new URLRequest( urlRequestInfo.url );
			var urlLoader : URLLoader = new URLLoader();

			urlRequest.authenticate = false;
			urlRequest.method = urlRequestInfo.method;
			urlRequest.requestHeaders = urlRequestInfo.requestHeaders;

			if ( urlRequestInfo.urlVars != null )
			{
				urlRequest.data = urlRequestInfo.urlVars;
			}

			if ( urlRequestInfo.onStatus is Function )
			{
				statusHandler = function( e : HTTPStatusEvent ) : void
				{
					urlRequestInfo.onStatus( e );
				};
				urlLoader.addEventListener( HTTPStatusEvent.HTTP_RESPONSE_STATUS, statusHandler, false, 0, true );
			}

			if ( urlRequestInfo.onComplete is Function )
			{
				completeHandler = function( e : Event ) : void
				{
					urlRequestInfo.onComplete( e.target.data );
				};
				urlLoader.addEventListener( Event.COMPLETE, completeHandler, false, 0, true );
			}

			if ( urlRequestInfo.onError is Function )
			{
				ioErrorHandler = function( e : ErrorEvent ) : void
				{
					urlRequestInfo.onError( e );
				};
				urlLoader.addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true );
			}

			try
			{
				urlLoader.load( urlRequest );
			}
			catch( e : Error )
			{
				trace( e );
			}
		}

		public static function getBasicAuthHeader( username : String, password : String ) : URLRequestHeader
		{
			//encoder.insertNewLines = false;
			var byteArray : ByteArray = new ByteArray();
			byteArray.writeUTFBytes( username + ':' + password );
			var encodedString : String = Base64.encode( byteArray );

			return new URLRequestHeader( "Authorization", "Basic " + encodedString );
		}

	}
}
