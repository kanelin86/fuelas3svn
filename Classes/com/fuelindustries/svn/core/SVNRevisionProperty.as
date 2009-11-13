package com.fuelindustries.svn.core 
{

	/**
	 * @author julian
	 */
	public class SVNRevisionProperty 
	{
		public static var AUTHOR:String = "svn:author";
		public static var LOG:String = "svn:log";
		public static var DATE:String = "svn:date";
		public static var LOCK:String = "svn:sync-lock";
		public static var FROM_URL:String = "svn:sync-from-url";
		public static var FROM_UUID:String = "svn:sync-from-uuid";
		public static var LAST_MERGED_REVISION:String = "svn:sync-last-merged-rev";
		public static var CURRENTLY_COPYING:String = "svn:sync-currently-copying";
		public static var AUTOVERSIONED:String = "svn:autoversioned";
		public static var ORIGINAL_DATE:String = "svn:original-date";

		public static function isRevisionProperty( name:String ):Boolean 
		{
			switch( name )
			{
				case AUTHOR:
				case LOG:
				case DATE:
				case LOCK:
				case FROM_URL:
				case FROM_UUID:
				case LAST_MERGED_REVISION:
				case CURRENTLY_COPYING:
				case AUTOVERSIONED:
				case ORIGINAL_DATE:
					return true;
					break;
			}
			
			return false;
		}
	}
}
