/* (C) 2008 - 2012 SPIRAL9, INC. ( SPIRAL9 )
 * All Rights Reserved.
 *
 * NOTICE:  SPIRAL9 permits you to use, modify, and distribute this file in
 * accordance with the terms of the SPIRAL9 license agreement accompanying it.
 * If you have received this file without a license agreement or from a source
 * other than SPIRAL9 then your use, modification, or distribution of it requires
 * the prior written permission of SPIRAL9, INC.
 *******************************************************************************/
package com.spiral9.net
{

	//import flash.system.Capabilities;
	import flash.system.Security;

	public class SecurityManager
	{
		private static const CN : String = "SecurityManager_2012.06.21";

		private static var _instance : SecurityManager;
		private static var _allowInstance : Boolean = false;
		private static var _crossDomainFiles : Array;
		private static var _domainsToAllow : Array;

		public function SecurityManager()
		{
			// *** Security Sandbox Violation ***
			// SecurityDomain 'https://hwp20test.hollywoodplayer.com/alpha/?fb_source=feed_playing' tried to access incompatible context 'https://d3crp60fns2zzg.cloudfront.net/swf/app_hollywoodplayer.swf'
			if ( _allowInstance )
			{
				trace( CN + " instantiated." );
				checkPolicyFiles();
				allowDomains();
			}
			else
			{
				throw new Error( "singleton" );
			}
		}

		private static function allowDomains() : void
		{
			var i : int;
			var domainToAllow : String;

			_domainsToAllow = [
				"d3crp60fns2zzg.cloudfront.net",
				"hwp20test.hollywoodplayer.com",
				"api-dev.hollywoodplayer.com",
				"api-test.hollywoodplayer.com",
				"api.hollywoodplayer.com",
				"hollywoodplayer.com",
				"hollywoodplayer.local"
				];

			for( i=0; i < _domainsToAllow.length; i++ )
			{
				domainToAllow = _domainsToAllow[ i ];
				trace( "\tallowing domain : " + domainToAllow + ":" );
				Security.allowDomain( domainToAllow );
			}
		}

		public static function checkPolicyFiles() : void
		{
			trace( CN + ".checkPolicyFiles" );

			var i : int;
			var crossdomainXML : String;

			_crossDomainFiles = [
				"//profile.ak.fbcdn.net/crossdomain.xml",
				"//fbcdn-profile-a.akamaihd.net/crossdomain.xml",
				"//ia.media-imdb.com/crossdomain.xml",
				"//d3crp60fns2zzg.cloudfront.net/crossdomain.xml" ];

			for( i=0; i < _crossDomainFiles.length; i++ )
			{
				crossdomainXML = URLservice.currentProtocol + _crossDomainFiles[ i ];
				trace( "\tloading policy file : " + crossdomainXML + ":" );
				Security.loadPolicyFile( crossdomainXML );
			}
		}

		public static function init() : void
		{
			createInstance();
		}

		private static function createInstance() : void
		{
			if( _instance == null )
			{
				_allowInstance = true;
				_instance = new SecurityManager();
				_allowInstance = false;
			}
		}
	}
}
