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

	/**
	 * Share the Application with a friend.
	 * <p>Facebook's documentation lists the following params to send to the API:<p>
	 * <a href="http://developers.facebook.com/docs/reference/dialogs/send/" >http://developers.facebook.com/docs/reference/dialogs/send/</a>
	 * <ul>
	 * 	<li>app_id : Your application's identifier. Required, but automatically specified by most SDKs.</li>
	 * 	<li>redirect_uri : The URL to redirect to after the user clicks the Send or Cancel buttons on the dialog. Required, but automatically specified by most SDKs.</li>
	 * 	<li>display : The display mode in which to render the dialog. This is automatically specified by most SDKs.</li>
	 * 	<li>to : A user ID or username to which to send the message. Once the dialog comes up, the user can specify additional users, Facebook groups, and email addresses to which to send the message. Sending content to a Facebook group will post it to the group's wall.</li>
	 * 	<li>link : (required) The link to send in the message.</li>
	 * 	<li>picture : By default a picture will be taken from the link specified. The URL of a picture to include in the message. The picture will be shown next to the link.</li>
	 * 	<li>name : By default a title will be taken from the link specified. The name of the link, i.e. the text to display that the user will click on.</li>
	 * 	<li>description : By default a description will be taken from the link specified. Descriptive text to show below the link.</li>
	 * </ul>
	 * @see http://developers.facebook.com/docs/reference/dialogs/send/
	 */
	public class ShareMessageInfo
	{
		public var to : String;
		public var link : String = "";
		public var picture : String;
		public var name : String;
		public var description : String;
		public var method : String;

		public function ShareMessageInfo() {}
	}
}
