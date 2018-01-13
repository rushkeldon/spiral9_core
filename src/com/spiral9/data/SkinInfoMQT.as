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
package com.spiral9.data
{

	import com.spiral9.utils.DataUtils;
	import com.spiral9.utils.StringService;
	import com.spiral9.ux.AssetPack;

	import org.osflash.signals.Signal;

	public class SkinInfoMQT implements ISkinInfo
	{
		public var CN : String = "SkinInfoMQT";

		public static const ID_COMMON : String =           "allScreens";
		public static const ID_SPLASH_SCRSPIRAL9N : String =    "splashScreen";
		public static const ID_HELP_SCRSPIRAL9N : String =      "helpScreen";
		public static const ID_QUESTION_SCRSPIRAL9N : String =  "questionScreen";

		public var signalGeneralAssetsLoaded : Signal;
		public var signalSplashScreenAssetsLoaded : Signal;
		public var signalHelpScreenAssetsLoaded : Signal;
		public var signalQuestionScreenAssetsLoaded : Signal;

		private var _allScreens : AssetPack;
		private var _splashScreen : AssetPack;
		private var _helpScreen : AssetPack;
		private var _questionScreen : AssetPack;
		private var _initObject : Object;

		public function SkinInfoMQT( initObject : Object = null )
		{
			trace( CN + " instantiated." );

			_initObject = initObject;
		}

		public function loadAssets() : void
		{
			trace( CN + ".loadAssets" );

			DataUtils.initFromObject( this, _initObject );
		}

		public function getAssetPackByID( id : String ) : AssetPack
		{
			var assetPack : AssetPack;

			switch( id )
			{
				case ID_COMMON :
					assetPack = _allScreens;
					break;
				case ID_SPLASH_SCRSPIRAL9N :
					assetPack = _splashScreen;
					break;
				case ID_HELP_SCRSPIRAL9N :
					assetPack = _helpScreen;
					break;
				case ID_QUESTION_SCRSPIRAL9N :
					assetPack = _questionScreen;
					break;
			}
			return assetPack;
		}

		public function set allScreens( initObject : Object ) : void
		{
			_allScreens = new AssetPack( initObject );
			signalGeneralAssetsLoaded = _allScreens.signalAllAssetsLoaded;
		}

		public function set splashScreen( initObject : Object ) : void
		{
			_splashScreen = new AssetPack( initObject );
		}

		public function set helpScreen( initObject : Object ) : void
		{
			_helpScreen = new AssetPack( initObject );
		}

		public function set questionScreen( initObject : Object ) : void
		{
			_questionScreen = new AssetPack( initObject );
		}

		public function toString( traceLevel : int = 0 ) : String
		{
			return StringService.stringify( this, traceLevel + 1 );
		}

		public function toObject() : Object
		{
			return _initObject;
		}
	}
}
