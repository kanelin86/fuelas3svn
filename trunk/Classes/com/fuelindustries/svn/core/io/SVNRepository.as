package com.fuelindustries.svn.core.io 
{
	import com.fuelindustries.svn.core.SVNURL;
	import com.fuelindustries.svn.core.util.SVNPathUtil;

	import flash.events.EventDispatcher;

	/**
	 * @author julian
	 */
	public class SVNRepository extends EventDispatcher
	{
		public static var INVALID_REVISION:Number = -1;
		protected var myRepositoryUUID:String;
		protected var myRepositoryRoot:SVNURL;
		protected var myLocation:SVNURL;

		public function SVNRepository( location:SVNURL ) 
		{
			myLocation = location;
		}
		
		public function setLocation( url:SVNURL ):void
		{
			myLocation = url;	
		}		
		
		public function getLocation():SVNURL 
		{
			return myLocation;
		}

		protected function isInvalidRevision( revision:int ):Boolean 
		{
			return revision < 0;
		}    

		protected function isValidRevision( revision:int ):Boolean 
		{
			return revision >= 0;
		}

		protected function getRevisionObject( revision:int ):int 
		{
			return isValidRevision( revision ) ? revision : 0;
		}

		public function getFullPath( relativeOrRepositoryPath:String ):String 
		{

			if (relativeOrRepositoryPath == null) 
			{
				return getFullPath( "/" );
			}
			var fullPath:String;
			if (relativeOrRepositoryPath.length > 0 && relativeOrRepositoryPath.charAt( 0 ) == "/") 
			{
				fullPath = SVNPathUtil.append( getRepositoryRoot( true ).getPath( ), relativeOrRepositoryPath );
			} 
			else 
			{
				fullPath = SVNPathUtil.append( getLocation( ).getPath( ), relativeOrRepositoryPath );
			}
			if (!StringUtils.startsWith( fullPath, "/" )) 
			{
				fullPath = "/" + fullPath;
			}
			return fullPath;
		}

		public function getRepositoryRoot( forceConnection:Boolean ):SVNURL 
		{
			if (forceConnection && myRepositoryRoot == null) 
			{
            	throw new Error( "SVNRepository.getRepositoryRoot() - myRepositoryRoot is null so you probably aren't connected or authenticated" ); 
			}
			return myRepositoryRoot;
		}

		protected function setRepositoryCredentials( uuid:String,  rootURL:SVNURL):void 
		{
			if (uuid != null && rootURL != null) 
			{
				myRepositoryUUID = uuid;
				myRepositoryRoot = rootURL;
			}
		}

		public function getRepositoryPath( relativePath:String):String
		{
			if (relativePath == null) 
			{
				return "/";
			}
			if (relativePath.length > 0 && relativePath.charAt( 0 ) == "/") 
			{
				return relativePath;
			}
			var fullPath:String = SVNPathUtil.append( getLocation( ).getPath( ), relativePath );
			var repositoryPath:String = fullPath.substring( getRepositoryRoot( true ).getPath( ).length );
        
			if ("" == repositoryPath) 
			{
				return "/";
			}

			//if url does not contain a repos root path component, then it results here in 
			//a path that lacks leading slash, fix that
			if (!StringUtils.startsWith( repositoryPath, "/" )) 
			{
				repositoryPath = "/" + repositoryPath;
			}
			return repositoryPath;
		}
	}
}
