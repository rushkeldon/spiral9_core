package com.spiral9.net
{
	import air.net.URLMonitor;

	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.net.URLRequest;

	public class NetworkMonitor
	{
		private static var CN : String = "NetworkMonitor";
		private static var _urlMonitor : URLMonitor;
		private static var _testURL : String = "http://www.google.com";

		public static function init() : void
		{
			//SignalTower.signalNetworkChanged.add( networkStateChanged );
		}

		private static function networkStateChanged( e : Event ) : void
		{
			trace( CN + ".networkStateChanged" );
			
			if( _urlMonitor.running )
			{
				_urlMonitor.stop();
			}

			_urlMonitor = new URLMonitor( new URLRequest( _testURL ) );
			_urlMonitor.addEventListener( StatusEvent.STATUS, netConnectivity, false, 0, true );
			_urlMonitor.start();
		}

		private static function netConnectivity( e : StatusEvent ) : void
		{
			if( _urlMonitor.available )
			{
				//SignalTower.signalNetworkBecameAvailable.dispatch();
			}
			else
			{
				//SignalTower.signalErrorNetworkLost.dispatch();
			}
			_urlMonitor.stop();
		}
	}
}
