package com.fuelindustries.svn.client 
{
	import com.fuelindustries.svn.events.UpdateCommandEvent;
	import com.fuelindustries.svn.core.ISVNLogEntryHandler;
	import com.fuelindustries.svn.core.SVNDirEntry;
	import com.fuelindustries.svn.core.SVNRevisionProperty;
	import com.fuelindustries.svn.core.SVNURL;
	import com.fuelindustries.svn.core.io.ISVNEditor;
	import com.fuelindustries.svn.core.io.svn.SVNNodeKind;
	import com.fuelindustries.svn.core.io.svn.SVNRepositoryImpl;
	import com.fuelindustries.svn.events.GetDirEvent;
	import com.fuelindustries.svn.events.GetFileEvent;
	import com.fuelindustries.svn.events.LatestRevisionEvent;
	import com.fuelindustries.svn.events.LogEvent;
	import com.fuelindustries.svn.events.SVNEvent;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.Capabilities;

	/**
	 * @author julian
	 */
	public class SVNClient extends Sprite 
	{
		public static const HEAD_REVISION:int = -100;
		
		private var repository:SVNRepositoryImpl;
		private var __data:RepositoryData;
		private var __exportDir:String;
		
		public function get data():Array
		{
			return( __data.items );	
		}
		
		public function SVNClient( exportDir:String = "" )
		{
			__exportDir = exportDir;
		}
		
		public function connect( url:String, username:String, password:String ):void
		{
        	repository = new SVNRepositoryImpl( SVNURL.parseURIEncoded( url ) );
        	repository.addEventListener( SVNEvent.AUTHENTICATED, onAuthenticated );
        	repository.addEventListener( LatestRevisionEvent.LATEST_REVISION, onLatestRevision );
        	repository.addEventListener( GetDirEvent.GET_DIR, onGetDir );
        	repository.addEventListener( GetFileEvent.GET_FILE, onGetFile );
        	repository.addEventListener( LogEvent.LOG, onComplete );
        	repository.addEventListener( UpdateCommandEvent.UPDATE, onComplete );
        	repository.connect( username, password );	
		}
		
		private function onComplete( e:Event ):void
		{
			dispatchEvent( new Event( Event.COMPLETE ) );	
		}
		
		private function onAuthenticated( e:Event ):void
		{
			__data = new RepositoryData( repository.getLocation().getPath() );
			repository.getLatestRevision();
		}
		
		private function onLatestRevision( e:LatestRevisionEvent ):void
		{
			getDir( __data.rootPath ); 
		}

		private function onGetDir( e:GetDirEvent ):void
		{
			__data.addEntries( e.entries, e.path );
			dispatchEvent( new Event( Event.CHANGE ) );
		}
		
		private function onGetFile(event:GetFileEvent):void
		{
			var path:String = ( event.path.charAt() == "/" ) ? event.path.substring( 1 ) : event.path;

			var f:File = new File( __exportDir + path );
			var stream:FileStream = new FileStream();
			stream.open( f , FileMode.WRITE );
			stream.writeBytes( event.contents );
			stream.close();
			
			onComplete( new Event( Event.COMPLETE ) );
		}
		
		public function getLog( entry:SVNDirEntry, handler:ISVNLogEntryHandler = null ):void
		{
			if( handler == null )
			{
				handler = new LogEntryHandler();	
			}
			
			var path:String = entry.getURL().getURIEncodedPath();
			repository.log( path, repository.latestRevision, 0, true, false, 26, false, [SVNRevisionProperty.AUTHOR, SVNRevisionProperty.DATE,SVNRevisionProperty.LOG], handler );
		}
		
		public function export( entry:SVNDirEntry ):void
		{
			if( entry.getKind().toString() == new SVNNodeKind( SVNNodeKind.DIR ).toString() )
			{
				//it's a folder we need to work on this
				
				var path:String = entry.getURL().getURIEncodedPath();
				
				var exportEditor:ISVNEditor = new ExportEditor( __exportDir + entry.getName(), path );
				
				repository.update(repository.latestRevision, path, true, exportEditor );
			}
			else
			{
				var url:SVNURL = entry.getURL();
				getFile( url.getURIEncodedPath(), entry.getRevision() );
			}
		}
		
		private function getFile( path:String, rev:int=-100 ):void
		{
			if( rev == -100 ) rev = repository.latestRevision;
			
			repository.getFile( path, false, true, rev );	
		}
		
		public function getDir( path:String, rev:int = -100 ):void
		{
			if( rev == -100 ) rev = repository.latestRevision;
			
			repository.getDir( path, rev );	
		}

	}
}
