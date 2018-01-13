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
package com.spiral9.data.actionengine
{
	import org.osflash.signals.Signal;

	public class StoredSignal
	{
		public var CN : String = "StoredSignal";

		public var signal : Signal;
		public var args : Array;

		public function StoredSignal( signalToStore : Signal = null, signalArgs : Array = null )
		{
			trace( CN + " instantiated." );

			if( signalToStore != null ){ signal = signalToStore; }
			if( signalArgs != null ){ args = signalArgs; }
		}
	}
}
