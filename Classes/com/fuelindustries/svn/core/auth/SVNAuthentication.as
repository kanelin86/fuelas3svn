package com.fuelindustries.svn.core.auth 
{

	/**
	 * @author julian
	 */
	public class SVNAuthentication 
	{
		public static var PASSWORD:String = "svn.simple";
		public static var SSH:String = "svn.ssh";
		public static var SSL:String = "svn.ssl";
		public static var USERNAME:String = "svn.username";
		
		private var myUserName:String;
		private var myIsStorageAllowed:Boolean;
		private var myKind:String;

		public function SVNAuthentication( kind:String, userName:String, storageAllowed:Boolean) 
		{
			myUserName = userName;
			myIsStorageAllowed = storageAllowed;
			myKind = kind;
		}

		public function getUserName():String 
		{
			return myUserName;
		}

		public function isStorageAllowed():Boolean 
		{
			return myIsStorageAllowed;
		}

		public function getKind():String 
		{
			return myKind;
		}
	}
}
