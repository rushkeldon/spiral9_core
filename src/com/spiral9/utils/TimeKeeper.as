package com.spiral9.utils
{

	import com.spiral9.data.TimerInfo;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	public class TimeKeeper
	{
		private static const CN : String = "TimeKeeper";
		private static var _allowInstance : Boolean = false;
		private static var _instance : TimeKeeper;
		private static var _isActionEngineConnected : Boolean = false;
		private static var _startTime : int;
		private static var _timerDictionary : Dictionary;       // Indexed by Timer objects
		private static var _timerInfos : Object;                // Indexed by TimerInfo.timerID

		public function TimeKeeper()
		{
			trace( CN + " instantiated." );

			if( _allowInstance )
			{
				_startTime = flash.utils.getTimer();
				_timerInfos = new Object();
				_timerDictionary = new Dictionary();
			}
		}

		public static function init() : void
		{
			if( _instance == null )
			{
				_allowInstance = true;
				_instance = new TimeKeeper();
				_allowInstance = false;
				StringService.registerLookup( "timers", stringServiceLookup );
			}
		}

		public static function addTimer( timerInfo : TimerInfo ) : TimerInfo
		{
			trace( CN + ".addTimer" );

			init();

			if( timerInfo == null ) return null;

			trace( timerInfo );

			var existingTimerInfo : TimerInfo = _timerInfos[ timerInfo.timerID ];

			// Create timer if it doesn't already exist, otherwise update its interval
			if( existingTimerInfo == null )
			{
				_timerInfos[ timerInfo.timerID ] = timerInfo;
				_timerDictionary[ timerInfo.timer ] = timerInfo;
				existingTimerInfo = timerInfo;
			}
			else
			{
				existingTimerInfo.interval = timerInfo.interval;
				existingTimerInfo.timer.delay = existingTimerInfo.interval;
			}

			existingTimerInfo.timer.reset();

			return existingTimerInfo;
		}

		public static function startTimer( timerInfo : TimerInfo ) : void
		{
			// trace( CN + ".startTimer" );

			init();

			var existingTimerInfo : TimerInfo = addTimer( timerInfo );
			existingTimerInfo.timerSignal.add( onTimer );

			if( existingTimerInfo.timer.delay > 20 )
			{
				existingTimerInfo.timer.start();
				existingTimerInfo.startTime = getTimeStamp();
			}
		}

		public static function getTimerInfoByID( timerID : String ) : TimerInfo
		{
			trace( CN + ".getTimerInfoByID" );

			if( _timerInfos == null ){ return null; }
			return _timerInfos[ timerID ];
		}

		public static function stopTimer( timerInfo : TimerInfo ) : void
		{
			// trace( CN + ".stopTimer" );

			init();

			var existingTimer : TimerInfo = _timerInfos[timerInfo.timerID];

			if( existingTimer != null )
			{
				existingTimer.timer.stop();
				existingTimer.startTime = 0;
			}
		}

		private static function onTimer( e : TimerEvent ) : void
		{
			trace( CN + ".onTimer" );

			var existingTimerInfo : TimerInfo = _timerDictionary[ e.target ];
			/*
			if( existingTimerInfo != null )
			{
				ActionEngineCore.fileReport( Reports.REPORT_TIMER_EXPIRED, existingTimerInfo );
			}
			else
			{
				trace( "\tERROR  : unknown timer." );
			}
			*/
		}

		public static function stringServiceLookup( id : String, timerName : String ) : String
		{
			//trace( CN + ".stringSericeLookup" );
			if( id != "timers" ){ return returnStr; }

			var returnStr : String = "?:??";
			var info : TimerInfo = getTimerInfoByID( timerName );

			if( info != null )
			{
				returnStr = info.remainingTime;
			}

			return returnStr;
		}

		public static function getTimeElapsed() : uint
		{
			// trace( CN + ".getTimeElapsed" );
			init();
			return( flash.utils.getTimer() - _startTime );
		}

		public static function getTimeStamp() : int
		{
			return new Date().getTime();
		}
	}
}
