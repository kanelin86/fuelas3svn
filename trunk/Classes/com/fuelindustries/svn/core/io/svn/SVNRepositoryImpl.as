package com.fuelindustries.svn.core.io.svn 
{
	import com.fuelindustries.svn.core.SVNURL;
	import com.fuelindustries.svn.core.auth.SVNAuthentication;
	import com.fuelindustries.svn.core.auth.SVNPasswordAuthentication;
	import com.fuelindustries.svn.core.io.ISVNReporter;
	import com.fuelindustries.svn.core.io.SVNRepository;
	import com.fuelindustries.svn.core.io.commands.GetDirCommand;
	import com.fuelindustries.svn.core.io.commands.GetFileCommand;
	import com.fuelindustries.svn.core.io.commands.LatestRevisionCommand;
	import com.fuelindustries.svn.core.io.commands.StatCommand;
	import com.fuelindustries.svn.events.LatestRevisionEvent;
	import com.fuelindustries.svn.events.SVNCommandCompleteEvent;
	import com.fuelindustries.svn.events.SVNEvent;

	import flash.events.Event;

	/**
	 * @author julian
	 */
	public class SVNRepositoryImpl extends SVNRepository implements ISVNReporter 
	{
		private static var DIRENT_KIND:String = "kind";
		private static var DIRENT_SIZE:String = "size";
		private static var DIRENT_HAS_PROPS:String = "has-props";
		private static var DIRENT_CREATED_REV:String = "created-rev";
		private static var DIRENT_TIME:String = "time";
		private static var DIRENT_LAST_AUTHOR:String = "last-author";
		
		private var myConnection:SVNConnection;
		private var myAuthentication:SVNAuthentication;
		
		private var __latestRevision:int;
		
		public function getAuthentication():SVNAuthentication
		{
			return( myAuthentication );
		}

		public function SVNRepositoryImpl(location:SVNURL )
		{
			super( location );
		}
		
		public function connect( username:String = null, password:String = null ):void
		{
			myAuthentication = new SVNPasswordAuthentication(username, password, false);
			openConnection();
		}
		
		protected function openConnection():void
		{
			//connector is our socket
			var connector:SVNPlainConnector = new SVNPlainConnector();
			
			//connection handles reading and writing of data
			myConnection = new SVNConnection( connector, this );
			myConnection.addEventListener( Event.COMPLETE, commandComplete );
			myConnection.addEventListener( SVNEvent.AUTHENTICATED, onAuthenticated );
			
			try
			{
				myConnection.open( this );
			}
			catch( e:SecurityError )
			{
				trace( e.getStackTrace() );
			}
		}

		public function getLatestRevision():void
		{
			var command:LatestRevisionCommand = new LatestRevisionCommand( "(w())", ["get-latest-rev"] );
			myConnection.sendCommand( command );
		}
		
		public function stat( rev:int ):void
		{
			var command:StatCommand = new StatCommand( "(w(s(n)))", [ "stat", "/", rev ] );
			myConnection.sendCommand(command);	
		}
		
		public function getDir( path:String, rev:int ):void
		{
			var url:SVNURL = getLocation().setPath(getFullPath(path), false);
			var repositoryRoot:SVNURL = getRepositoryRoot(false);
			var repositoryPath:String = getRepositoryPath(path);
			
			var command:GetDirCommand = new GetDirCommand(path, url, repositoryRoot, repositoryPath, rev);
			myConnection.sendCommand( command );
		}
		
		public function getFile( path:String, wantprops:Boolean = false, wantcontents:Boolean = true, rev:int = -1 ):void
		{
			if( rev <= 0 )
			{
				throw new Error( "Get File Revision needs to be bigger then 0" );	
			}
			
			var command:GetFileCommand = new GetFileCommand( "(w(s(n)ww))", ["get-file", getRepositoryPath(path), rev, wantprops, wantcontents] );
			myConnection.sendCommand( command );
		}
		
		private function commandComplete( e:SVNCommandCompleteEvent ):void
		{
			
			switch( e.event.type )
			{
				case LatestRevisionEvent.LATEST_REVISION:
					__latestRevision = LatestRevisionEvent( e.event ).latestRevision;
					dispatchEvent( e.event );
					break;
				default:
					dispatchEvent( e.event );
					break;
			}	
		}

		
		private function onAuthenticated( e:Event ):void
		{
			dispatchEvent( new Event( e.type ) );	
		}

		public function updateCredentials( uuid:String,  rootURL:SVNURL):void
		{
			if (getRepositoryRoot( false ) != null) 
			{
				return;
			}
			setRepositoryCredentials( uuid, rootURL );
		}
	}
}
