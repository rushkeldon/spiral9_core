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
package com.spiral9.ux
{

	import org.osflash.signals.Signal;

	import flash.display.DisplayObject;

	public class SkinnableUI extends BaseUI
	{
		public var areAssetsLoaded : Boolean;
		public var signalAssetsLoaded : Signal;
		//protected var _assetPack : AssetPack;
		protected var _assetLoadCount : int = 0;


		public function SkinnableUI()
		{
			super();
			CN = "SkinnableUI";
			signalAssetsLoaded = new Signal( DisplayObject );
		}

	}
}
