package com.spiral9.net
{
	import com.spiral9.data.URLrequestInfo;

	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.OutputProgressEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;

	public class FileDownloader
	{
		public var CN : String = "FileDownloader";

		private var _urlRequestInfo : URLrequestInfo;
		private var _urlStream : URLStream;
		private var _fileStream : FileStream;
		private var _isDownloadComplete : Boolean = false;
		private var _currentPosition : uint = 0;
		private var _urlRequest : URLRequest;

		public function FileDownloader( urlRequestInfo : URLrequestInfo )
		{
			trace( CN + " instantiated." );
			trace( "\turlRequestInfo.url:" + urlRequestInfo.url + ":" );
			trace( "\turlRequestInfo.targetFile.nativePath:" + urlRequestInfo.targetFile.nativePath + ":" );

			_urlRequestInfo = urlRequestInfo;
			_urlStream = new URLStream();
			_fileStream = new FileStream();
			_urlRequest = new URLRequest( _urlRequestInfo.url );

			_fileStream.addEventListener( OutputProgressEvent.OUTPUT_PROGRESS, fileStreamProgress, false, 0, true );
			_fileStream.openAsync( _urlRequestInfo.targetFile, FileMode.WRITE );
			_urlStream.addEventListener( ProgressEvent.PROGRESS, urlStreamProgress, false, 0, true );
			_urlStream.addEventListener( Event.COMPLETE, urlStreamCompleted, false, 0, true );
			_urlStream.addEventListener( IOErrorEvent.IO_ERROR, errorEncountered, false, 0, true );
			_urlStream.addEventListener( SecurityErrorEvent.SECURITY_ERROR, errorEncountered, false, 0, true );
			_urlStream.load( _urlRequest );
		}

		private function removeListeners() : void
		{
			trace( CN + ".removeListeners" );

			_fileStream.removeEventListener( OutputProgressEvent.OUTPUT_PROGRESS, fileStreamProgress );
			_urlStream.removeEventListener( ProgressEvent.PROGRESS, urlStreamProgress );
			_urlStream.removeEventListener( Event.COMPLETE, urlStreamCompleted );
			_urlStream.removeEventListener( IOErrorEvent.IO_ERROR, errorEncountered );
			_urlStream.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, errorEncountered );
		}

		private function urlStreamProgress( e : ProgressEvent ) : void
		{
			var bytes : ByteArray = new ByteArray();
			var thisStart : uint = _currentPosition;

			_currentPosition += _urlStream.bytesAvailable;
			_urlStream.readBytes( bytes, thisStart );
			_fileStream.writeBytes( bytes, thisStart );
			_urlRequestInfo.onProgress( e );
		}

		private function fileStreamProgress( e : OutputProgressEvent ) : void
		{
			if ( e.bytesPending == 0 && _isDownloadComplete )
			{
				_urlStream.close();
				_fileStream.close();
			}
		}

		private function urlStreamCompleted( e : Event ) : void
		{
			trace( CN + ".urlStreamCompleted" );

			_isDownloadComplete = true;
			_urlRequestInfo.onComplete( e );
			dispose();
		}

		private function errorEncountered( e : ErrorEvent ) : void
		{
			trace( CN + ".errorEncountered" );
			trace( e );

			_urlRequestInfo.onError( e );
			dispose();
		}

		private function dispose() : void
		{
			trace( CN + ".dispose" );

			removeListeners();
			_urlStream.close();
			_fileStream.close();

			_urlRequestInfo = null;
			_urlStream = null;
			_fileStream = null;
			_urlRequest = null;
		}
	}
}
