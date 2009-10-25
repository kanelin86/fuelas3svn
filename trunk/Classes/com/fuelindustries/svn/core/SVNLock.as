package com.fuelindustries.svn.core 
{

	/**
	 * @author julian
	 */
	public class SVNLock 
	{
		private var myPath:String;
		private var myID:String;
		private var myOwner:String;
		private var myComment:String;
		private var myCreationDate:Date;
		private var myExpirationDate:Date;

		public function SVNLock( path:String, id:String, owner:String, comment:String, created:Date, expires:Date) 
		{
			myPath = path;
			myID = id;
			myOwner = owner;
			myComment = comment;
			myCreationDate = created;
			myExpirationDate = expires;
		}

		
		public function getComment():String 
		{
			return myComment;
		}

		
		public function getCreationDate():Date 
		{
			return myCreationDate;
		}

		public function getExpirationDate():Date 
		{
			return myExpirationDate;
		}

	
		public function getID():String 
		{
			return myID;
		}

	
		public function getOwner():String 
		{
			return myOwner;
		}

		
		public function getPath():String 
		{
			return myPath;
		}

		
		public function toString():String 
		{
			var result:String = "";
        
			result += "path=";
			result += myPath;
			result += ", token=";
			result += myID;
			result += ", owner=";
			result += myOwner;
			if (myComment != null) 
			{
				result += ", comment=";
				result += myComment;
			}
			result += ", created=";
			result += myCreationDate;
			if (myExpirationDate != null) 
			{
				result += ", expires=";
				result += myExpirationDate;
			}        
			return result;
		}
	}
}
