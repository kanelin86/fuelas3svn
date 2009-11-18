package com.fuelindustries.svn.core.io.commands 
{
	import com.fuelindustries.svn.core.SVNDirEntry;
	import com.fuelindustries.svn.core.SVNURL;
	import com.fuelindustries.svn.core.errors.SVNErrorCode;
	import com.fuelindustries.svn.core.errors.SVNErrorManager;
	import com.fuelindustries.svn.core.errors.SVNErrorMessage;
	import com.fuelindustries.svn.core.io.SVNCommand;
	import com.fuelindustries.svn.core.io.svn.SVNItem;
	import com.fuelindustries.svn.core.io.svn.SVNNodeKind;
	import com.fuelindustries.svn.core.io.svn.SVNReader;
	import com.fuelindustries.svn.core.util.SVNDate;
	import com.fuelindustries.svn.core.util.SVNLogType;
	import com.fuelindustries.svn.events.GetDirEvent;

	import flash.utils.ByteArray;

	/**
	 * @author julian
	 */
	public class GetDirCommand extends SVNCommand 
	{
		private var __repositoryRoot:SVNURL;
		private var __url:SVNURL;
		private var __path:String;
		private var __repositoryPath:String;
		private var __entries:Array;
		
		private var __statCommand:StatCommand;
		private var __state:String;
		
		private const STAT:String = "stat";
		private const GET_DIR:String = "get-dir";
		
		public function get entries():Array
		{
			return( __entries );	
		}
		
		public function GetDirCommand( path:String, url:SVNURL, repositoryRoot:SVNURL, repositoryPath:String, rev:int )
		{
			__state = STAT;
			
			__path = path;
			__url = url;
			__repositoryRoot = repositoryRoot;
			__repositoryPath = repositoryPath;
			
			__statCommand = new StatCommand( "(w(s(n)))", [ "stat", path, rev ] );
			__bytes = __statCommand.bytes;
		}

		override public function parseCommand(ba:ByteArray):void
		{
			
			switch( __state )
			{
				case STAT:
					readStat( ba );
					break;
				case GET_DIR:
					readGetDir( ba );
					break;	
			}
		}
		
		
		private function readStat( ba:ByteArray ):void
		{
			__statCommand.parseCommand(ba);
			
			emptyInput();
			
			var values:Array = __statCommand.stats;
			var parentEntry:SVNDirEntry;
			
			if (values != null) 
			{
                var direntProps:Array = SVNReader.parseTupleArray("wnsr(?s)(?s)", values, null);
                var kind:SVNNodeKind = SVNNodeKind.parseKind(SVNReader.getString(direntProps, 0));
                var size:int = SVNReader.getLong(direntProps, 1);
                var hasProps:Boolean = SVNReader.getBoolean(direntProps, 2);
                var createdRevision:int = SVNReader.getLong(direntProps, 3);
                var createdDate:Date = SVNDate.parseDate(SVNReader.getString(direntProps, 4)).getDate();
                var lastAuthor:String = SVNReader.getString(direntProps, 5);
                parentEntry = new SVNDirEntry(__url, __repositoryRoot, "", kind, size, hasProps, createdRevision, createdDate, lastAuthor);
            }
            
            __state = GET_DIR;
           	sendCommand("(w(s(n)ww))", [ "get-dir", __path, __statCommand.revision, false, true ]);
		}
		
		private function readGetDir( ba:ByteArray ):void
		{

			var values:Array = parse( ba, "rll", null);
            var revision:int = values[0] != null ? SVNReader.getLong(values, 0) : revision;
			var dirents:Array = values[2] as Array;
			
			__entries = [];
			
			for( var i:int = 0; i<dirents.length; i++ )
			{
				var item:SVNItem = dirents[ i ] as SVNItem;
				if (item.getKind() != SVNItem.LIST) 
				{
                    SVNErrorManager.error(SVNErrorMessage.create(SVNErrorCode.RA_SVN_MALFORMED_DATA, "Dirlist element not a list"), SVNLogType.NETWORK);
                }
                
                var direntProps:Array = SVNReader.parseTupleArray("swnsr(?s)(?s)", item.getItems(), null);
                var name:String = SVNReader.getString(direntProps, 0);
                var kind:SVNNodeKind = SVNNodeKind.parseKind(SVNReader.getString(direntProps, 1));
                var size:int = SVNReader.getLong(direntProps, 2);
                var hasProps:Boolean = SVNReader.getBoolean(direntProps, 3);
                var createdRevision:int = SVNReader.getLong(direntProps, 4);
                var createdDate:Date = SVNDate.parseDate(SVNReader.getString(direntProps, 5)).getDate();
                var lastAuthor:String = SVNReader.getString(direntProps, 6);
                var entry:SVNDirEntry = new SVNDirEntry(__url.appendPath(name, false), __repositoryRoot, name, kind, size, hasProps, createdRevision, createdDate, lastAuthor);
				__entries.push( entry );
			}
			
			__event = new GetDirEvent( GetDirEvent.GET_DIR, __entries, __path, this );
			commandComplete();
		}
	}
}
