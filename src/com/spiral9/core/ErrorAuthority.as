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
package com.spiral9.core
{
	import com.spiral9.data.ErrorInfo;
	public class ErrorAuthority
	{
		public static var CN : String = "ErrorAuthority";

		public static const CODE_REPORT_NO : int =      0;  // don't report to server
		public static const CODE_REPORT_YES : int =     1;  // report to server
		public static const CODE_RETRY : int =          2;  // retry

		public static function submitError( errorInfo : ErrorInfo ) : int
		{
			trace( CN + ".submitError" );

			var handleCode : int = CODE_REPORT_NO;

			switch( errorInfo.type )
			{
				case ErrorInfo.TYPE_CLIENT :
					handleCode = CODE_REPORT_YES;
					break;
				case ErrorInfo.TYPE_CLIENT_FATAL :
					handleCode = CODE_REPORT_YES;
					break;
				case ErrorInfo.TYPE_GAME : String :
					handleCode = CODE_REPORT_YES;
					break;
				case ErrorInfo.TYPE_GAME_FATAL : String :
					handleCode = CODE_REPORT_YES;
					break;
				case ErrorInfo.TYPE_SERVER : String :
					handleCode = CODE_RETRY;
					break;
				case ErrorInfo.TYPE_SERVER_FATAL :
					handleCode = CODE_REPORT_NO;
					break;
			}

			return handleCode;
		}
	}
}
