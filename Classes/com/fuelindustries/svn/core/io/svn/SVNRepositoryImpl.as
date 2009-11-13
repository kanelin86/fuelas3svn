package com.fuelindustries.svn.core.io.svn 
{
	import com.fuelindustries.svn.core.ISVNLogEntryHandler;
	import com.fuelindustries.svn.core.SVNURL;
	import com.fuelindustries.svn.core.auth.SVNAuthentication;
	import com.fuelindustries.svn.core.auth.SVNPasswordAuthentication;
	import com.fuelindustries.svn.core.io.ISVNEditor;
	import com.fuelindustries.svn.core.io.ISVNReporter;
	import com.fuelindustries.svn.core.io.SVNRepository;
	import com.fuelindustries.svn.core.io.commands.GetDatedRevisionCommand;
	import com.fuelindustries.svn.core.io.commands.GetDirCommand;
	import com.fuelindustries.svn.core.io.commands.GetFileCommand;
	import com.fuelindustries.svn.core.io.commands.GetRevisionPropertiesCommand;
	import com.fuelindustries.svn.core.io.commands.LatestRevisionCommand;
	import com.fuelindustries.svn.core.io.commands.LogCommand;
	import com.fuelindustries.svn.core.io.commands.ReparentCommand;
	import com.fuelindustries.svn.core.io.commands.StatCommand;
	import com.fuelindustries.svn.core.io.commands.UpdateCommand;
	import com.fuelindustries.svn.events.LatestRevisionEvent;
	import com.fuelindustries.svn.events.ReparentEvent;
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
		
		public function get latestRevision():int
		{
			return( __latestRevision );	
		}

		public function SVNRepositoryImpl( location:SVNURL )
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
		
		public function getDatedRevision( date:Date = null ):void
		{
			if( date == null ) date = new Date();
			
			var dateString:String = date.getFullYear() + "-" + ( date.getMonth() + 1 ) + "-" + date.getDate() + "T" + date.getHours() + ":" + date.getMinutes() + ":" + date.getSeconds() + "." + date.getMilliseconds() +"Z";
			var command:GetDatedRevisionCommand = new GetDatedRevisionCommand( "(w(s))", ["get-dated-rev", dateString] );
			myConnection.sendCommand( command );
		}
		
		public function reparent( url:String ):void
		{
			if( getLocation().toString() == url )
			{
				return;		
			}	
			
			var command:ReparentCommand = new ReparentCommand( "(w(s))", ["reparent", url ] );
			myConnection.sendCommand(command);
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
		
		public function getRevisionProperties( rev:int ):void
		{
			var command:GetRevisionPropertiesCommand = new GetRevisionPropertiesCommand("(w(n))", [ "rev-proplist", getRevisionObject(rev) ] );
			myConnection.sendCommand( command );
		}
		
		public function update( rev:int, target:String, recursive:Boolean, editor:ISVNEditor ):void
		{
			var command:UpdateCommand = new UpdateCommand("(w((n)swww))", [ "update", rev, target, recursive, "infinity", true ], editor );
			myConnection.sendCommand( command );	
		}
		
		public function log( path:String, startrev:int, endrev:int, changedpaths:Boolean, strictnode:Boolean, limit:int, includemergedrevisions:Boolean, revisionPropertyNames:Array, handler:ISVNLogEntryHandler ):void
		{
			if( path == null || path == "/" )
			{
				path = "";
			}
			
			var buffer:Array;
			var template:String;

			if( revisionPropertyNames != null && revisionPropertyNames.length > 0 )
			{
				buffer = ["log", [ path ], getRevisionObject(startrev), getRevisionObject(endrev), changedpaths, strictnode, limit, includemergedrevisions, "revprops", revisionPropertyNames ];
				 template = "(w((*s)(n)(n)wwnww(*s)))";
			}
			else
			{
				buffer = ["log", [ path ], getRevisionObject(startrev), getRevisionObject(endrev),changedpaths, strictnode,limit, includemergedrevisions, "all-revprops"];
				template = "(w((*s)(n)(n)wwnww()))";
			}
			
			var command:LogCommand = new LogCommand( template, buffer, handler );
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
				case ReparentEvent.REPARENT:
					myLocation = SVNURL.parseURIEncoded( ReparentEvent( e.event ).path );
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
