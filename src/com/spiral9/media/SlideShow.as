package com.spiral9.media
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.spiral9.assets.BtnPause;
	import com.spiral9.assets.BtnPlay;
	import com.spiral9.data.media.ImageInfo;
	import com.spiral9.data.media.VisualMediaInfo;
	import com.spiral9.utils.StageReference;
	import com.spiral9.ux.BaseUI;

	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeSignal;

	import flash.events.Event;

	public class SlideShow extends BaseUI
	{
		public static var signalExitFrame : NativeSignal;
		public var signalSlideShowEnded : Signal = new Signal();

		public var btnPlay : BtnPlay;
		public var btnPause : BtnPause;

		private static var DURATION_VIEWING : int = 4;
		private static var DURATION_TRANSITION : int = 1;

		private var _slides : Vector.<PhotoSlide>;
		private var _imageURLs : Array;
		private var _index : int;
		private var _isCarousel : Boolean = false;
		private var _tween : TweenMax;
		private var _paused : Boolean = false;

		public function SlideShow( imageURLs : Array = null )
		{
			super();
			CN = "SlideShow";
			//trace( CN + " instantiated." );

			SlideShow.signalExitFrame = this.signalExitFrame;

			if( imageURLs != null )
			{
				_imageURLs = imageURLs;
			}
			else
			{
				_imageURLs = [
					VisualMediaInfo.PROTOCOL_LINKAGE + "com.spiral9.assets.NoImages",
					VisualMediaInfo.PROTOCOL_LINKAGE + "com.spiral9.assets.NoImages"
				];
			}
		}

		private function getImageInfoFromURL( url : String ) : ImageInfo
		{
			var imageInfo : ImageInfo = new ImageInfo();
			imageInfo.url = url;
			imageInfo.width = StageReference.stage.stageWidth;
			imageInfo.height = StageReference.stage.stageHeight;
			return imageInfo;
		}

		override protected function init( e : Event = null ) : void
		{
			//trace( CN + ".init" );

			super.init();
			signalExitFrame.addOnce( createUI );
		}

		public function togglePlaying( e : Event = null ) : void
		{
			//trace( CN + ".togglePlaying" );

			if( _paused )
			{
				resume();
			}
			else
			{
				pause();
			}
		}

		public function pause() : void
		{
			//trace( CN + ".pause" );

			_paused = true;
			_tween.kill();
			_slides[ 0 ].alpha = 1;
		}

		public function resume() : void
		{
			//trace( CN + ".resume" );

			_paused = false;
			_tween = new TweenMax( _slides[ 0 ], DURATION_TRANSITION, { alpha : 0, onComplete : switchSlides } );
		}

		private function startSlideShow() : void
		{
			//trace( CN + ".startSlideShow" );

			_slides = new Vector.<PhotoSlide>();

			var firstSlide : PhotoSlide = new PhotoSlide( getImageInfoFromURL( _imageURLs[ 0 ] ) );
			var secondSlide : PhotoSlide = new PhotoSlide( getImageInfoFromURL( _imageURLs[ 1 ] ) );

			_index = 1;

			firstSlide.visible = false;
			secondSlide.visible = false;

			addChild( secondSlide );
			addChild( firstSlide );

			firstSlide.signalImageLoaded.addOnce( displaySlides );
			secondSlide.signalImageLoaded.addOnce( startViewing );

			_slides.push( firstSlide );
			_slides.push( secondSlide );
		}

		private function displaySlides( photoSlide : PhotoSlide = null ) : void
		{
			_slides[ 0 ].visible = true;
			_slides[ 1 ].visible = true;
		}

		private function endSlideShow() : void
		{
			//trace( CN + ".endSlideShow" );

			removeChild( _slides[ 0 ] );
			removeChild( _slides[ 1 ] );
			signalSlideShowEnded.dispatch();
		}

		private function startViewing( photoSlide : PhotoSlide = null ) : void
		{
			//trace( CN + ".startViewing" );

			var onComplete : Function;

			if( photoSlide != null )
			{
				onComplete = switchSlides;
			}
			else
			{
				onComplete = displayEnd;
			}

			if( _tween != null ){ _tween.kill(); }

			_tween = new TweenMax( _slides[ 0 ], DURATION_TRANSITION, { delay : DURATION_VIEWING, alpha : 0, onComplete : onComplete } );
		}

		private function displayEnd() : void
		{
			//trace( CN + ".displayEnd" );

			TweenLite.to( _slides[ 1 ], DURATION_TRANSITION, { delay : DURATION_VIEWING, alpha : 0, onComplete : endSlideShow } );
		}

		private function switchSlides() : void
		{
			//trace( CN + ".switchSlides" );

			addChild( _slides[ 1 ] );
			_slides[ 0 ].alpha = 1;
			_slides.reverse();
			loadNextSlideImage();
		}

		private function loadNextSlideImage() : void
		{
			//trace( CN + ".loadNextSlideImage" );

			_index++;

			switch( true )
			{
				case ( _index >= _imageURLs.length && _isCarousel ) :
					_index = 0;
					_slides[ 1 ].loadImage( getImageInfoFromURL( _imageURLs[ _index ] ) );
					_slides[ 1 ].signalImageLoaded.addOnce( startViewing );
					break;
				case ( _index >= _imageURLs.length && !_isCarousel ) :
					startViewing();
					break;
				default :
					_slides[ 1 ].loadImage( getImageInfoFromURL( _imageURLs[ _index ] ) );
					_slides[ 1 ].signalImageLoaded.addOnce( startViewing );
			}
		}

		private function createUI( e : Event = null ) : void
		{
			//trace( CN + ".createUI" );

			startSlideShow();
		}
	}
}
