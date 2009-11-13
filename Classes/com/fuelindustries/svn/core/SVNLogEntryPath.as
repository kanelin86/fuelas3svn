package com.fuelindustries.svn.core 
{
	import com.fuelindustries.svn.core.io.svn.SVNNodeKind;

	/**
	 * @author julian
	 */
	public class SVNLogEntryPath 
	{
		public static const TYPE_ADDED:String = "A";
		public static const TYPE_DELETED:String = "D";
		public static const TYPE_MODIFIED:String = "M";
		public static const TYPE_REPLACED:String = "R";
		
		private var myPath:String;
		private var myType:String;
		private var myCopyPath:String;
		private var myCopyRevision:int;
		private var myNodeKind:SVNNodeKind;

		public function SVNLogEntryPath( path:String, type:String, copyPath:String, copyRevision:int,  kind:SVNNodeKind) 
		{
			myPath = path;
			myType = type;
			myCopyPath = copyPath;
			myCopyRevision = copyRevision;
			myNodeKind = kind;
		}

		public function toString():String 
		{
			var result:String = '';
			result += myType;
			result += ' ';
			result += myPath;
			if (myCopyPath != null) 
			{
				result += "(from ";
				result += myCopyPath;
				result += ':';
				result += myCopyRevision;
				result += ')';
			}
			return result;
		}
	}
}
