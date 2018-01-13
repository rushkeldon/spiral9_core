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

    import com.spiral9.utils.DataUtils;
    import com.spiral9.utils.StringService;

    import flash.display.MovieClip;
    public class ButtonizerVars extends Object
    {
        public var CN : String =                            "ButtonizerVars";
        public static const LABEL : String =                "label";
        public static var isTouchScreen : Boolean =         false;

        public var textFieldName : String;
        public var useHandCursor : Boolean;
        public var text : String;
        public var isHTML : Boolean;
        public var onUpFrame : Function;
        public var onOverFrame : Function;
        public var onDownFrame : Function;
        public var onHitFrame : Function;
        public var onDisabledFrame : Function;
        public var skinImages : Vector.<Image>;

        private var _movieClip : MovieClip;
        private var _trackAsMenu : Boolean = false;
        private var _htmlText : String;
        private var _initObject : Object;

        public function ButtonizerVars( initObject : Object = null )
        {
            if( initObject != null )
            {
                _initObject = initObject;

                if( DataUtils.hasProp( initObject, "movieClip" ) ){ movieClip = initObject.movieClip; }
                if( DataUtils.hasProp( initObject, "trackAsMenu" ) ){ trackAsMenu = initObject.movieClip; }
                if( DataUtils.hasProp( initObject, "textFieldName" ) ){ textFieldName = initObject.textFieldName; }
                if( DataUtils.hasProp( initObject, "useHandCursor" ) ){ useHandCursor = initObject.useHandCursor; }
                if( DataUtils.hasProp( initObject, "text" ) ){ text = initObject.text; }
                if( DataUtils.hasProp( initObject, "onUpFrame" ) ){ onUpFrame = initObject.onUpFrame; }
                if( DataUtils.hasProp( initObject, "onOverFrame" ) ){ onOverFrame = initObject.onOverFrame; }
                if( DataUtils.hasProp( initObject, "onDownFrame" ) ){ onDownFrame = initObject.onDownFrame; }
                if( DataUtils.hasProp( initObject, "onHitFrame" ) ){ onHitFrame = initObject.onHitFrame; }
                if( DataUtils.hasProp( initObject, "onDisabledFrame" ) ){ onDisabledFrame = initObject.onDisabledFrame; }
                if( DataUtils.hasProp( initObject, "skinImages" ) && initObject.skinImages is Vector.<*> )
                {
                    skinImages = initObject.skinImages as Vector.<Image>;
                }
            }
        }

        public function toString( traceLevel : int = 0 ) : String
        {
            return StringService.stringify( this, traceLevel + 1 );
        }

        public function toObject() : Object
        {
            return _initObject;
        }

        public function get htmlText() : String
        {
            return _htmlText;
        }

        public function set htmlText( htmlText : String ) : void
        {
            _htmlText = htmlText;
            isHTML = true;
        }

        public function set trackAsMenu( shouldTrackAsMenu : Boolean ) : void {
            _trackAsMenu = shouldTrackAsMenu;
            if( !!movieClip ) {
                movieClip.trackAsMenu = _trackAsMenu;
            }
        }

        public function get trackAsMenu() : Boolean {
            return _trackAsMenu;
        }

        public function get movieClip() : MovieClip {
            return _movieClip;
        }

        public function set movieClip( value : MovieClip ) : void {
            _movieClip = value;
            _movieClip.trackAsMenu = _trackAsMenu;
        }
    }
}
