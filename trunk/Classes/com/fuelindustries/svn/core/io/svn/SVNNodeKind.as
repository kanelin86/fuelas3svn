package com.fuelindustries.svn.core.io.svn 
{

	/**
	 * @author julian
	 */
	public class SVNNodeKind 
	{
		public static const  NONE:int = 2;
		/**
		 * Defines the file node kind
		 */
		public static const  FILE:int = 1;
		/**
		 * Defines the directory node kind
		 */
		public static const  DIR:int = 0;
		/**
		 * This node kind is used to say that the kind of a node is
		 * actually unknown
		 */
		public static const  UNKNOWN:int = 3;
		private var myID:int;

		public function SVNNodeKind( id:int ) 
		{
			myID = id;
		}

		public static function parseKind(kind:String):SVNNodeKind 
		{
			if ("file" == kind ) 
			{
				return new SVNNodeKind( FILE );
			} 
			else if ("dir" == kind) 
			{
				return new SVNNodeKind( DIR );
			} 
			else if ("none" == kind || kind == null) 
			{
				return new SVNNodeKind( NONE );
			}
			return new SVNNodeKind( UNKNOWN );
		}

		public function toString():String 
		{
			if (myID == NONE) 
			{
				return "none";
			} 
			else if (myID == FILE) 
			{
				return "file";
			} 
			else if (myID == DIR) 
			{
				return "dir";
			}
			return "unknown";
		}

		public function compareTo( o:Object ):int 
		{
			if (o == null || o is SVNNodeKind) 
			{
				return -1;
			}
			var otherID:int = SVNNodeKind( o ).myID;
			return myID > otherID ? 1 : myID < otherID ? -1 : 0;
		}
	}
}
