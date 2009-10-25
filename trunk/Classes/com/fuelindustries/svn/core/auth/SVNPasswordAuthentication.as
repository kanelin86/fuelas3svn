package com.fuelindustries.svn.core.auth 
{

	/**
	 * @author julian
	 */
	public class SVNPasswordAuthentication extends SVNAuthentication 
	{
		private var myPassword:String;

		public function SVNPasswordAuthentication( userName:String, password:String, storageAllowed:Boolean)
		{
			super( SVNAuthentication.PASSWORD, userName, storageAllowed );
			myPassword = ( password == null ) ? "" : password;
		}

		public function getPassword():String 
		{
			return myPassword;
		}
	}
}
