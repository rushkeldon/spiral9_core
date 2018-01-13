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

	import com.spiral9.data.actionengine.ReportInfo;
	import com.spiral9.data.actionengine.Reports;
	import com.spiral9.utils.Conversion;
	import com.spiral9.utils.StringService;

	import org.osflash.signals.natives.NativeSignal;

	import flash.display.DisplayObject;
	import flash.net.URLVariables;

	public class TooltipInfo extends ReportInfo
	{
		public static const ID_DYNAMIC : String = "dynamic";
		public static const ELEMENT_TYPE_STATUSFIELD : String = "statusField";
		public static const ELEMENT_TYPE_PORT_USER : String = "userPort";
		public static const ELEMENT_TYPE_PORT_VISITOR : String = "visitingPort";

		public var tooltipID : String;
		public var elementType : String;
		public var elementID : String;

		private var _serverString : String;
		private var _title : String;
		private var _body : String;

		// runtime these are created and assigned when Tooltip.registerTooltip is called
		public var targetDisplayObject : DisplayObject;
		public var signalRolledOver : NativeSignal;
		public var signalRolledOut : NativeSignal;
		public var signalRemovedFromStage : NativeSignal;
		public var isReadyToDisplay : Boolean;

		public function TooltipInfo( initObject : Object = null )
		{
			super();

			CN = "TooltipInfo";
			reportType = Reports.REPORT_TOOLTIP_NEEDED;
			infoClass = TooltipInfo;

			tooltipID = Conversion.assignProp( initObject, "tooltipID", "null" );
			elementType = Conversion.assignProp( initObject, "elementType", "null" );
			elementID = Conversion.assignProp( initObject, "elementID", "null" );

			if( tooltipID == "null" ){ tooltipID = null; }
			if( elementType == "null" ){ elementType = null; }
			if( elementID == "null" ){ elementID = null; }

			serverString = Conversion.assignProp(initObject, "body", "null" );
			title = StringService.processServerString( Conversion.assignProp( initObject, "title", "null" ) );
			body = StringService.processServerString( Conversion.assignProp( initObject, "body", "null" ) );

			if( initObject != null )
			{
				if( initObject.hasOwnProperty( "targetDisplayObject" ) )
				{
					targetDisplayObject = initObject.targetDisplayObject;
				}
			}
		}

		public function set serverString( svrString : String ) : void
		{
			if( svrString != null && svrString != "null" )
			{
				_serverString = svrString;
			}
			else
			{
				_serverString = null;
			}
		}

		public function get serverString() : String
		{
			return _serverString;
		}

		public function hasDynamicBody() : Boolean
		{
			var isDynamic : Boolean = false;
			if( _serverString != null )
			{
				isDynamic = _serverString.indexOf( "{" ) >= 0;
			}
			return isDynamic;
		}

		public function set title( newTitle : String ) : void
		{
			if( newTitle != null && newTitle != "null" )
			{
				_title = newTitle;
			}
			else
			{
				_title = null;
			}
		}

		public function get title() : String
		{
			return _title;
		}

		public function set body( newBody : String ) : void
		{
			if( newBody != null && newBody != "null" )
			{
				_body = newBody;
			}
			else
			{
				_body = null;
			}
		}

		public function get body() : String
		{
			return _body;
		}
		override public function toURLvars() : URLVariables
		{
			//trace( CN + ".toURLvars" );

			super.toURLvars();
			urlVars.tooltipID = tooltipID;
			urlVars.elementType = elementType;
			urlVars.elementID = elementID;
			return urlVars;
		}

		public function dispose() : void
		{
			// remove listeners
			if( signalRolledOver != null )
			{
				signalRolledOver.removeAll();
			}
			if( signalRemovedFromStage != null )
			{
				signalRemovedFromStage.removeAll();
			}

			// remove references
			signalRolledOver = null;
			signalRemovedFromStage = null;
			targetDisplayObject = null;
			tooltipID = null;
			elementType = null;
			elementID = null;
			title = null;
			body = null;
		}

		public function toString( traceLevel : int = 0 ) : String
		{
			var indent : String = StringService.getIndent( traceLevel );

			var str : String = "\n" + indent + "TooltipInfo :\n";
			str += indent + "\t• tooltipID :\t\t" + String( tooltipID ) + ":\n";
			str += indent + "\t• title :\t\t" + String( _title ) + ":\n";
			str += indent + "\t• body :\t\t" + String( _body ) + ":\n";
			str += indent + "\t• elementType :\t\t" + String( elementType ) + ":\n";
			str += indent + "\t• elementID :\t\t" + String( elementID ) + ":\n";
			return( str );
		}
	}
}
