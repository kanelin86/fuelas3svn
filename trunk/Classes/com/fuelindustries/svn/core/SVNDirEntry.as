package com.fuelindustries.svn.core 
{
	import com.fuelindustries.svn.core.io.svn.SVNNodeKind;

	/**
	 * @author julian
	 */
	public class SVNDirEntry 
	{
		private var myName:String;
		private var myKind:SVNNodeKind;
		private var mySize:int;
		private var myHasProperties:Boolean;
		private var myRevision:int;
		private var myCreatedDate:Date;
		private var myLastAuthor:String;
		private var myPath:String;
		private var myCommitMessage:String;
		private var myLock:SVNLock;
		private var myURL:SVNURL;
		private var myRepositoryRoot:SVNURL;

		public function SVNDirEntry( url:SVNURL, repositoryRoot:SVNURL,  name:String,  kind:SVNNodeKind, size:int, hasProperties:Boolean, revision:int, createdDate:Date,  lastAuthor:String) 
		{
			myURL = url;
			myRepositoryRoot = repositoryRoot;
			myName = name;
			myKind = kind;
			mySize = size;
			myHasProperties = hasProperties;
			myRevision = revision;
			myCreatedDate = createdDate;
			myLastAuthor = lastAuthor;
		}

		public function getURL():SVNURL 
		{
			return myURL;
		}

		public function getRepositoryRoot():SVNURL 
		{
			return myRepositoryRoot;
		}

		public function getName():String 
		{
			return myName;
		}

		public function getSize():int 
		{
			return mySize;
		}

		public function size():int 
		{
			return getSize( );
		}

		public function hasProperties():Boolean 
		{
			return myHasProperties;
		}

		public function getKind():SVNNodeKind 
		{
			return myKind;
		}

		public function getDate():Date 
		{
			return myCreatedDate;
		}

		public function getRevision():int 
		{
			return myRevision;
		}

		public function getAuthor():String 
		{
			return myLastAuthor;
		}

		public function getRelativePath():String 
		{
			return myPath == null ? getName( ) : myPath;
		}

		public function getPath():String 
		{
			return getRelativePath( );        
		}

		public function getCommitMessage():String 
		{
			return myCommitMessage;
		}

		public function getLock():SVNLock 
		{
			return myLock;
		}

		public function setRelativePath(path:String):void 
		{
			myPath = path;
		}

		public function setCommitMessage(message:String):void 
		{
			myCommitMessage = message;
		}

		public function setLock( lock:SVNLock ):void 
		{
			myLock = lock;
		}

		public function toString():String 
		{
			var result:String = "";
			result += "name=";
			result += myName;
			result += ", kind=";
			result += myKind;
			result += ", size=";
			result += mySize;
			result += ", hasProps=";
			result += myHasProperties;
			result += ", lastchangedrev=";
			result += myRevision;
			if (myLastAuthor != null) 
			{
				result += ", lastauthor=";
				result += myLastAuthor;
			}
			if (myCreatedDate != null) 
			{
				result += ", lastchangeddate=";
				result += myCreatedDate;
			}
			return result;
		}

		public function compareTo( o:Object ):int 
		{
			if (o == null || o is SVNDirEntry ) 
			{
				return -1;
			}
			var otherKind:SVNNodeKind = SVNDirEntry( o ).getKind( );
			if (otherKind != getKind( )) 
			{
				return getKind( ).compareTo( otherKind );    
			}
			var otherURL:String = SVNDirEntry( o ).getURL( ).toString( );
			return int( myURL.toString( ) == otherURL );
		}
	}
}
