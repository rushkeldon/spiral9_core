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
package com.spiral9.data {
	import com.spiral9.utils.TimeKeeper;
	import com.spiral9.data.actionengine.ReportInfo;
	import com.spiral9.data.actionengine.Reports;
	import com.spiral9.utils.Conversion;
	import com.spiral9.utils.StringService;

	import org.osflash.signals.natives.NativeSignal;

	import flash.events.TimerEvent;
	import flash.net.URLVariables;
	import flash.utils.Timer;

	public class TimerInfo extends ReportInfo
	{
		public static const DEFAULT_TIMER_INTERVAL : Number = 1;
		public static const DEFAULT_TIMER_ID : String = null;
		public static const MILLISECONDS_PER_MINUTE : Number = 1000 * 60;
		public static const MILLISECONDS_PER_HOUR : Number = MILLISECONDS_PER_MINUTE * 60;
		public static const MILLISECONDS_PER_DAY : Number = MILLISECONDS_PER_HOUR * 24;

		public var timerID : String;
		public var startTime : int;
		public var interval : Number;

		// runtime
		public var timerSignal : NativeSignal;
		public var timer : Timer;

		public function TimerInfo( initObject : Object = null )
		{
			super();

			infoClass = TimerInfo;
			reportType = Reports.REPORT_TIMER_EXPIRED;

			if( initObject != null )
			{
				timerID = Conversion.assignProp( initObject, "timerID", DEFAULT_TIMER_ID );
				interval = Conversion.assignProp( initObject, "interval", DEFAULT_TIMER_INTERVAL );
				timer = new Timer( interval );
				timerSignal = new NativeSignal( timer, TimerEvent.TIMER, TimerEvent );
			}
		}

		public function get remainingTime() : String
		{
			//trace( CN + ".remainingTime" );

			if( !timer.running ){ return "0:00"; }

			var str : String = "";

			var remainingMs : int = interval - (TimeKeeper.getTimeStamp() - startTime);
			var remainingHours : int = remainingMs / 3600000;
			var remainingMinutes : int = (remainingMs % 3600000) / 60000;
			var remainingSeconds : int = (remainingMs % 60000) / 1000;

			str += (remainingHours > 0) ? remainingHours.toString()+":" : "";
			
			
			if( remainingMinutes < 0 )
			{
				str += "00";
			}
			else if ( remainingMinutes < 10 )
			{
				str += "0"+remainingMinutes.toString();
			}
			else
			{
				str += remainingMinutes.toString();
			}
			
			str += ":";

			if( remainingSeconds < 0 )
			{
				str += "00";
			}
			else if ( remainingSeconds < 10 )
			{
				str += "0"+remainingSeconds.toString();
			}
			else
			{
				str += remainingSeconds.toString();
			}

			return str;
		}

		public static function remainingDateAndTime( targetTime : Number ) : String
		{
			var str : String = "";

			var today : Date = new Date();
			var diff:Number = targetTime - today.time;
			var target : Date = new Date();
			target.time = targetTime;

			var daysLeft:int = Math.floor(diff / TimerInfo.MILLISECONDS_PER_DAY);
			diff -= daysLeft * TimerInfo.MILLISECONDS_PER_DAY;

			var hoursLeft:int = Math.floor(diff/TimerInfo.MILLISECONDS_PER_HOUR);
			diff -= hoursLeft * TimerInfo.MILLISECONDS_PER_HOUR;

			var minutesLeft:int = Math.floor(diff / TimerInfo.MILLISECONDS_PER_MINUTE );
			diff -= minutesLeft * TimerInfo.MILLISECONDS_PER_MINUTE;

			var secondsLeft:int = Math.floor(diff/1000);
			diff -= secondsLeft * 1000;

			if( daysLeft > 0 ) {
				str += String( daysLeft ) + ' days, ';
			}

			str += String( hoursLeft ) + ' hours, ';
			str += String( minutesLeft ) + ' minutes, ';
			str += String( secondsLeft ) + ' seconds';

			return str;
		}

		public function toString( traceLevel : int = 0 ) : String
		{
			var indent : String = StringService.getIndent( traceLevel );

			var str : String = "\n" + indent + "TimerInfo :\n";

			str += indent + "\t• reportType :\t\t" + reportType + "\n";
			str += indent + "\t• infoClass :\t\t" + infoClass + "\n";
			str += indent + "\t• timerID :\t\t" + timerID + "\n";
			str += indent + "\t• interval :\t\t" + interval + "\n";

			return str;
		}

		override public function toURLvars() : URLVariables
		{
			//trace( CN + ".toURLvars" );

			super.toURLvars();
			urlVars.reportType = reportType;
			urlVars.timerID = timerID;
			urlVars.interval = interval;

			return urlVars;
		}
	}
}
