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
package com.spiral9.data.sn
{
	public class PurchaseItemInfo
	{
		private var CN : String = "PurchaseItemInfo";
		
		public var id : String;
		public var value : Number;
		public var currency : String;
		public var type : String = "item";

		public function PurchaseItemInfo()
		{
			trace( CN + ".PurchaseItemInfo" );
			
		}
		
		public function toString() : String
		{
			return "PurchaseItemVO id=" + id + " value=" + value + " type=" + type;
		}
	}

}
