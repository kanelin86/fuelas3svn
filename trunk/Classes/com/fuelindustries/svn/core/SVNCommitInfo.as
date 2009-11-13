package com.fuelindustries.svn.core 
{

	/**
	 * @author julian
	 */
	public class SVNCommitInfo 
	{
		public static var NULL:SVNCommitInfo = new SVNCommitInfo( -1, null, null );
		private var myNewRevision:int;
		private var myDate:Date;
		private var myAuthor:String;

		//private var myErrorMessage:SVNErrorMessage;
		public function SVNCommitInfo( revision:int ,  author:String, date:Date ) 
		{
			myNewRevision = revision;
			myAuthor = author;
			myDate = date;     
		}

		public function getNewRevision():int 
		{
			return myNewRevision;
		}

		public function getAuthor():String 
		{
			return myAuthor;
		}

		public function getDate():Date 
		{
			return myDate;
		}

		public function toString():String 
		{
			if(this == NULL) 
			{
				return "EMPTY COMMIT";
			} 
			else
			{
				var sb:String = "";
				sb += "r";
				sb += myNewRevision;
				if (myAuthor != null) 
				{
					sb += " by '";
					sb += myAuthor;
					sb += "'";
				}
            
				if (myDate != null) 
				{
					sb += " at ";
					sb += myDate;
				}
				return sb;
			} 
		}
	}
}
