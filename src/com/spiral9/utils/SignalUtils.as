package com.spiral9.utils
{
	import org.osflash.signals.ISignal;

	public class SignalUtils
	{
		private static var CN : String = "SignalUtils";
		
		public function SignalUtils()
		{
		}
		
		public static function prepSignalForDisposal( signal : ISignal ) : void
		{
			//trace( CN + ".prepSignalForDisposal" );
			
			if( signal != null )
			{
				signal.removeAll();
			}
		}
		
		public static function disposeOfPublicSignal( signalName : String, owner : Object ) : void
		{
			if( owner == null || owner[ signalName ] == null )
			{
				//trace( "\tNOTICE : signal or owner are null." );
				return;
			}
			
			if( owner[ signalName ] is ISignal )
			{
				ISignal( owner[ signalName ] ).removeAll();
				owner[ signalName ] = null;
			}
		}
	}
	
}
