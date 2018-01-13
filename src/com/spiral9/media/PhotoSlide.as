package com.spiral9.media
{
	import com.greensock.loading.data.ImageLoaderVars;
	import com.greensock.events.LoaderEvent;
	import com.greensock.layout.ScaleMode;
	import com.greensock.loading.ImageLoader;
	import com.spiral9.data.media.ImageInfo;
	import com.spiral9.ux.BaseUI;

	import org.osflash.signals.Signal;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;

	public class PhotoSlide extends BaseUI
	{
		// create an ImageLoader:
		public var signalImageLoaded : Signal = new Signal();
		public var scaleMode : String = ScaleMode.PROPORTIONAL_INSIDE;

		private var _imageLoader : ImageLoader;
		private var _imageInfo : ImageInfo;

		public function PhotoSlide( imageInfo : ImageInfo = null )
		{
			super();
			CN = "PhotoSlide";
			isRecyclable = false;
			//trace( CN + " instantiated." );
			_imageInfo = imageInfo;
		}

		override protected function init( e : Event = null ) : void
		{
			//trace( CN + ".init" );
			super.init();

			switch( true )
			{
				case ( _imageInfo == null ) :
					//  do nothing
					break;
				default :
					loadImage( _imageInfo );
			}
		}

		public function loadImage( imageInfo : ImageInfo ) : void
		{
			var imageLoaderVars : ImageLoaderVars = new ImageLoaderVars();
			
			if( _imageLoader != null )
			{
				_imageLoader.dispose( true );
			}
			
			imageLoaderVars.name( imageInfo.imageID );
			imageLoaderVars.container( this );
			imageLoaderVars.x( 0 );
			imageLoaderVars.y( 0 );
			imageLoaderVars.width( imageInfo.width );
			imageLoaderVars.height( imageInfo.height );
			imageLoaderVars.scaleMode( imageInfo.scaleMode );
			imageLoaderVars.bgColor( 0x000000 );
			imageLoaderVars.centerRegistration( false );
			imageLoaderVars.onOpen( opened );
			imageLoaderVars.onProgress( progressReceived );
			imageLoaderVars.onComplete( completed );
			imageLoaderVars.onCancel( canceled );
			imageLoaderVars.onError( errorReceived );
			imageLoaderVars.onFail( failed );
			imageLoaderVars.onIOError( ioErrorReceived );
			imageLoaderVars.onHTTPStatus( httpStatusReceived );
			imageLoaderVars.onSecurityError( securityErrorReceived );

			_imageLoader = new ImageLoader( imageInfo.url, imageLoaderVars );
			_imageLoader.load();
		}
/*
		private function drawBG() : void
		{
			graphics.clear();
			graphics.beginFill( 0x000000 );
			graphics.drawRect(0, 0, StageReference.stage.stageWidth, StageReference.stage.stageHeight );
		}
*/
		public function opened( e : LoaderEvent = null ) : void
		{
			//trace( CN + ".opened" );

			//onOpen : Function - A handler function for LoaderEvent.OPEN events which are dispatched when the loader begins loading. Make sure your onOpen function accepts a single parameter of type LoaderEvent (com.greensock.events.LoaderEvent).
		}
/*
		public function initialized( e : LoaderEvent = null ) : void
		{
			//trace( CN + ".initialized" );

			//onInit : Function - A handler function for LoaderEvent.INIT events which are called when the image has downloaded and has been placed into the ContentDisplay Sprite. Make sure your onInit function accepts a single parameter of type LoaderEvent (com.greensock.events.LoaderEvent).
		}
*/
		public function progressReceived( e : LoaderEvent = null ) : void
		{
			//trace( CN + ".progressReceived" );

			//onProgress : Function - A handler function for LoaderEvent.PROGRESS events which are dispatched whenever the bytesLoaded changes. Make sure your onProgress function accepts a single parameter of type LoaderEvent (com.greensock.events.LoaderEvent). You can use the LoaderEvent's target.progress to get the loader's progress value or use its target.bytesLoaded and target.bytesTotal.
		}

		public function completed( e : LoaderEvent = null ) : void
		{
			trace( CN + ".completed" );

			signalImageLoaded.dispatch( this );
			//onComplete : Function - A handler function for LoaderEvent.COMPLETE events which are dispatched when the loader has finished loading successfully. Make sure your onComplete function accepts a single parameter of type LoaderEvent (com.greensock.events.LoaderEvent).
		}

		public function canceled( e : LoaderEvent ) : void
		{
			trace( CN + ".canceled" );

			//onCancel : Function - A handler function for LoaderEvent.CANCEL events which are dispatched when loading is aborted due to either a failure or because another loader was prioritized or cancel() was manually called. Make sure your onCancel function accepts a single parameter of type LoaderEvent (com.greensock.events.LoaderEvent).
		}

		public function errorReceived( e : LoaderEvent ) : void
		{
			trace( CN + ".errorReceived" );

			//onError : Function - A handler function for LoaderEvent.ERROR events which are dispatched whenever the loader experiences an error (typically an IO_ERROR or SECURITY_ERROR). An error doesn't necessarily mean the loader failed, however - to listen for when a loader fails, use the onFail special property. Make sure your onError function accepts a single parameter of type LoaderEvent (com.greensock.events.LoaderEvent).
		}

		public function failed( e : LoaderEvent ) : void
		{
			trace( CN + ".errorReceived" );

			//onFail : Function - A handler function for LoaderEvent.FAIL events which are dispatched whenever the loader fails and its status changes to LoaderStatus.FAILED. Make sure your onFail function accepts a single parameter of type LoaderEvent (com.greensock.events.LoaderEvent).
		}

		public function ioErrorReceived( e : LoaderEvent ) : void
		{
			trace( CN + ".ioErrorReceived" );

			//onIOError : Function - A handler function for LoaderEvent.IO_ERROR events which will also call the onError handler, so you can use that as more of a catch-all whereas onIOError is specifically for LoaderEvent.IO_ERROR events. Make sure your onIOError function accepts a single parameter of type LoaderEvent (com.greensock.events.LoaderEvent).
		}

		public function httpStatusReceived( e : LoaderEvent ) : void
		{
			trace( CN + ".httpStatusReceived" );

			//onHTTPStatus : Function - A handler function for LoaderEvent.HTTP_STATUS events. Make sure your onHTTPStatus function accepts a single parameter of type LoaderEvent (com.greensock.events.LoaderEvent). You can determine the httpStatus code using the LoaderEvent's target.httpStatus (LoaderItems keep track of their httpStatus when possible, although certain environments prevent Flash from getting httpStatus information).
		}

		public function securityErrorReceived( e : LoaderEvent ) : void
		{
			trace( CN + ".securityErrorReceived" );

			//onSecurityError : Function - A handler function for LoaderEvent.SECURITY_ERROR events which onError handles as well, so you can use that as more of a catch-all whereas onSecurityError is specifically for SECURITY_ERROR events. Make sure your onSecurityError function accepts a single parameter of type LoaderEvent (com.greensock.events.LoaderEvent).
		}
/*
		public function scriptAccessDenied( e : LoaderEvent ) : void
		{
			trace( CN + ".scriptAccessDenied" );

			//onScriptAccessDenied : Function - A handler function for LoaderEvent.SCRIPT_ACCESS_DENIED events which are dispatched when the image is loaded from another domain and no crossdomain.xml is in place to grant full script access for things like smoothing or BitmapData manipulation. You can also check the loader's scriptAccessDenied property after the image has loaded. Make sure your function accepts a single parameter of type LoaderEvent (com.greensock.events.LoaderEvent).
		}
*/
		override public function dispose( e : Event = null ) : void
		{
			trace( CN + ".dispose" );

			super.dispose();
			
			if( !isRecyclable )
			{
				if( signalImageLoaded != null )
				{
					signalImageLoaded.removeAll();
					signalImageLoaded = null;
				}
				
				if( _imageLoader != null )
				{
					_imageLoader.dispose( true );
					_imageLoader = null;
				}
				
				_imageInfo = null;
			}
		}

	}
}
