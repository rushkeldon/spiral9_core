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
package com.spiral9.data.media
{
	import com.greensock.layout.ScaleMode;
	import com.spiral9.net.URLservice;
	import com.spiral9.utils.DataUtils;
	import com.spiral9.utils.StringUtils;

	import flash.display.DisplayObject;
	import flash.utils.getDefinitionByName;

	public class VisualMediaInfo
	{
		public static const PROTOCOL_LINKAGE : String = "linkage://";

		public var CN : String = "VisualMediaInfo";
		public var displayObject : DisplayObject;
		public var width : Number;
		public var height : Number;
		public var movieInfo : com.spiral9.data.media.MovieInfo;
		public var type : String;
		//public var scaleMode : String;

		protected var _url : String;
		protected var _scaleMode : String = ScaleMode.NONE;

		public function VisualMediaInfo( initObject : Object = null )
		{
			//trace( CN + " instantiated." );
			if( initObject != null )
			{
				transferProps( initObject, this );
			}
		}

		public function set url( newURL : String ) : void
		{
			_url = URLservice.mapURL( newURL );
			instantiateDisplayObject();
		}

		public function get url() : String
		{
			return _url;
		}

		protected function transferProps( initObject : Object, targetObject : Object ) : void
		{
			DataUtils.transferProp( initObject, targetObject, "url" );
			DataUtils.transferProp( initObject, targetObject, "width" );
			DataUtils.transferProp( initObject, targetObject, "height" );
			DataUtils.transferProp( initObject, targetObject, "type" );
			DataUtils.transferProp( initObject, targetObject, "displayObject" );
			DataUtils.transferProp( initObject, targetObject, "scaleMode" );

			switch( true )
			{
				case ( initObject is VisualMediaInfo ) :
					if( DataUtils.hasProp( initObject, "movieInfo" ) )
					{
						targetObject.MovieInfo = MovieInfo( initObject.movieInfo ).toObject();
					}
					break;
				case ( initObject is Object ) :
					if( DataUtils.hasProp( initObject, "MovieInfo" ) )
					{
						targetObject.movieInfo = new MovieInfo( initObject.MovieInfo );
					}
					break;
			}
		}
		
		public function set scaleMode( newMode : String ) : void
		{
			switch( newMode )
			{
				case ( ScaleMode.STRETCH ) :
				case ( ScaleMode.WIDTH_ONLY ) :
				case ( ScaleMode.HEIGHT_ONLY ) :
				case ( ScaleMode.PROPORTIONAL_OUTSIDE ) :
				case ( ScaleMode.PROPORTIONAL_INSIDE ) :
				case ( ScaleMode.NONE ) :
					_scaleMode = newMode;
					break;
			}
		}
		
		public function get scaleMode() : String
		{
			return _scaleMode;
		}

		private function instantiateDisplayObject() : void
		{
			trace( CN + ".instantiateDisplayObject" );

			var linkageID : String;
			var linkedClass : Class;

			if( displayObject != null )
			{
				trace( "\tNOTICE : already have a displayObject.  Returning." );
				return;
			}

			trace( "\t_url:" + _url + ":" );

			if( _url.indexOf( PROTOCOL_LINKAGE ) == 0 )
			{
				linkageID = _url.split( PROTOCOL_LINKAGE )[ 1 ];

				linkedClass = getDefinitionByName( linkageID ) as Class;

				displayObject = new linkedClass() as DisplayObject;

			}
		}

		public function toObject() : Object
		{
			var o : Object = new Object();
			transferProps( this, o );
			return( o );
		}

		public function toString() : String
		{
			return StringUtils.objectToPrettyJSON( toObject() );
		}
	}
}
