package com.spiral9.data
{

	import com.spiral9.data.actionengine.ReportInfo;
	import com.spiral9.utils.DataUtils;
	import com.spiral9.utils.StringService;

	import flash.net.URLVariables;

	public class ErrorInfo extends ReportInfo
	{
		public static const TYPE_CLIENT : String =                "clientError";
		public static const TYPE_CLIENT_FATAL : String =          "fatalClientError";
		public static const TYPE_GAME : String =                  "gameError";
		public static const TYPE_GAME_FATAL : String =            "fatalGameError";
		public static const TYPE_SERVER : String =                "serverError";
		public static const TYPE_SERVER_FATAL : String =          "fatalServerError";
		public static const SDB_UNAVAILABLE : String =            "Service AmazonSimpleDB is currently unavailable";//"Error on fetching document: Service AmazonSimpleDB is currently unavailable. Please try again later";

		// Service AmazonSimpleDB is currently unavailable
		public var errorID : String = "";
		public var type : String = "";
		public var message : String;
		public var exception : String;
		public var stackTrace : String;


		public function ErrorInfo( initObject : Object = null )
		{
			super();
			CN = "ErrorInfo";
			infoClass = ErrorInfo;

			if( initObject != null )
			{
				transferProps( initObject, this );
			}

			switch( true )
			{
				case ( type != "" ) :
					// doNothing
					break;
				case ( exception.indexOf( SDB_UNAVAILABLE ) > -1 ) :
					type = TYPE_SERVER;
					break;
				default :
					type = TYPE_SERVER_FATAL;
			}

			trace( this );
		}

		/*
		ERROR FROM SERVER :
			• message :		Application error
			• exception :	Error on fetching document: Service AmazonSimpleDB is currently unavailable. Please try again later
			• stackTrace :
		#0 /var/www/html/library/Hwp/SimpleDBMapper.php(254): Zend_Cloud_DocumentService_Adapter_SimpleDb->fetchDocument('hwp_port_test', 'PS0001_P046_L00...')
		#1 /var/www/html/library/Hwp/Record.php(52): Hwp_SimpleDBMapper->Load('hwp_port_test', 'PS0001_P046_L00...')
		#2 /var/www/html/library/Hwp/Port.php(401): Hwp_Record->Load('PS0001_P046_L00...')
		#3 /var/www/html/library/Hwp/Portscape.php(75): Hwp_Port::PortsToArray('PS0001', Object(stdClass))
		#4 /var/www/html/library/Hwp/StateMachine.php(88): Hwp_Portscape::CreatePortscapeInfo(Object(Hwp_User), 'PS0001')
		#5 /var/www/html/application/controllers/ServerController.php(16): Hwp_StateMachine->getResponse()
		#6 /var/www/html/library/Zend/Controller/Action.php(516): ServerController->reportAction()
		#7 /var/www/html/library/Zend/Controller/Dispatcher/Standard.php(295): Zend_Controller_Action->dispatch('reportAction')
		#8 /var/www/html/library/Zend/Controller/Front.php(954): Zend_Controller_Dispatcher_Standard->dispatch(Object(Zend_Controller_Request_Http), Object(Zend_Controller_Response_Http))
		#9 /var/www/html/library/Zend/Application/Bootstrap/Bootstrap.php(97): Zend_Controller_Front->dispatch()
		#10 /var/www/html/library/Zend/Application.php(366): Zend_Application_Bootstrap_Bootstrap->run()
		#11 /var/www/html/public/index.php(30): Zend_Application->run()
		#12 {main}
		*/

		private function transferProps( initObject : Object, targetObject : Object ) : void
		{
			DataUtils.transferProp( initObject, targetObject, "errorID" );
			DataUtils.transferProp( initObject, targetObject, "message" );
			DataUtils.transferProp( initObject, targetObject, "exception" );
			DataUtils.transferProp( initObject, targetObject, "stackTrace" );
		}

		public function toObject() : Object
		{
			var o : Object = {};
			transferProps( this, o );
			return( o );
		}

		public function toString() : String
		{
			return StringService.getPrettyJSON( toObject() );
		}

		override public function toURLvars() : URLVariables
		{
			super.toURLvars();
			transferProps( this, urlVars );
			return urlVars;
		}
	}
}
