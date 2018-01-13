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
package com.spiral9.media
{
	import com.greensock.TweenMax;
	import com.spiral9.data.media.SoundInfo;
	import com.spiral9.net.URLservice;

	import org.osflash.signals.natives.NativeSignal;

	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;



	public class AudioMixer
	{
		public static var CN : String = "AudioMixer";

		private static var _currentBackgroundMusic : SoundInfo;
		private static var _isMuted : Boolean = false;
		private static var _isBackgroundMuted : Boolean = false;

		public static function playSound( soundInfo : SoundInfo ) : void
		{
			trace( CN + ".playSound" );
			trace( "\tsoundClass:" + soundInfo.soundClass + ":" );

			switch( true )
			{
				case ( soundInfo == null ) :
					trace( "\tERROR : soundInfo == null" );
					return;
					break;
				case ( soundInfo.sound == null && soundInfo.soundClass != null ) :
					soundInfo.sound = new soundInfo.soundClass();
				case ( soundInfo.sound != null ) :
					// NOTE : a new SoundChannel is returned with each call to Sound.play() - the old one is gone
					soundInfo.soundChannel = soundInfo.sound.play( soundInfo.startTime, soundInfo.loops, soundInfo.soundTransform );
					soundInfo.isPlaying = true;
					soundInfo.signalSoundComplete = new NativeSignal( soundInfo.soundChannel, Event.SOUND_COMPLETE, Event );
					soundInfo.signalSoundComplete.addOnce( function( e : Event ) : void { soundInfo.isPlaying = false; } );
					break;
				case ( soundInfo.url != URLservice.BAD_URL ) :
					// TODO : solve the url case... (or use Greensock)
					break;
				default :
					trace( "\t" + CN + " ERROR : unhandled case." );
			}

			try
			{
				if( soundInfo.signalSoundComplete != null )
				{
					// TODO : seems like we should *somehow* get the list of listeners on the current signal and add them to this one
					// ISlot??
					if( soundInfo.signalSoundComplete != null )
					{
						soundInfo.signalSoundComplete.removeAll();
					}
				}
				// NOTE : a new SoundChannel is returned with each call to Sound.play() - the old one is gone
				soundInfo.soundChannel = soundInfo.sound.play( soundInfo.startTime, soundInfo.loops, soundInfo.soundTransform );
				soundInfo.isPlaying = true;
				soundInfo.signalSoundComplete = new NativeSignal( soundInfo.soundChannel, Event.SOUND_COMPLETE, Event );
				soundInfo.signalSoundComplete.addOnce( function( e : Event ) : void { soundInfo.isPlaying = false; } );

			}
			catch( e : Error )
			{
				trace( "\tERROR : an error was encountered trying to play the sound from class :" + soundInfo.soundClass + ":" );
				trace( e );
			}
		}

		public static function stopSound( soundInfo : SoundInfo ) : void
		{
			trace( CN + ".stopSound" );

			if( soundInfo.sound is Sound && soundInfo.soundChannel is SoundChannel )
			{
				soundInfo.soundChannel.stop();
			}
			if( !soundInfo.isRecyclable )
			{
				clearSound( soundInfo );
			}
		}

		public static function clearSound( soundInfo : SoundInfo ) : void
		{
			trace( CN + ".clearSound" );

			if( soundInfo.sound is Sound )
			{
				var dump : ByteArray = new ByteArray();
				soundInfo.sound.extract( dump, soundInfo.sound.bytesTotal );
				dump.clear();
			}
		}

		public static function fadeOut( soundInfo : SoundInfo, inSeconds : Number = 1 ) : void
		{
			trace( CN + ".fadeOut" );

			if( soundInfo.sound is Sound && soundInfo.soundChannel is SoundChannel )
			{
				TweenMax.to( soundInfo.soundChannel, inSeconds,
				{
					volume : 0,
					onComplete : function() : void
					{
						AudioMixer.stopSound( soundInfo );
					}
				} );
			}
		}

		public static function stopAllSounds() : void
		{
			SoundMixer.stopAll();
		}

		public static function unMute() : void
		{
			_isMuted = false;
			resumeBackgroundMusic();
		}

		public static function mute() : void
		{
			stopAllSounds();
			_isMuted = true;
		}

		public static function toggleMute() : void
		{
			if( _isMuted )
			{
				unMute();
			}
			else
			{
				mute();
			}
		}

		public static function resumeBackgroundMusic() : void
		{
			if( !_isMuted && !_isBackgroundMuted && _currentBackgroundMusic != null )
			{
				playSound( _currentBackgroundMusic );
			}
		}

		public static function toggleBackgroundMusic() : void
		{
			if( !_isMuted )
			{
				if( _isBackgroundMuted )
				{
					_isBackgroundMuted = false;
					resumeBackgroundMusic();
				}
				else
				{
					stopAllSounds();
					_isBackgroundMuted = true;
				}
			}
		}
	}
}
