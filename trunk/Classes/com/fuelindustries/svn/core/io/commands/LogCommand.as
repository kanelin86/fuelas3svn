package com.fuelindustries.svn.core.io.commands 
{
	import com.fuelindustries.svn.core.ISVNLogEntryHandler;
	import com.fuelindustries.svn.core.SVNLogEntry;
	import com.fuelindustries.svn.core.SVNLogEntryPath;
	import com.fuelindustries.svn.core.SVNProperties;
	import com.fuelindustries.svn.core.SVNRevisionProperty;
	import com.fuelindustries.svn.core.errors.SVNErrorCode;
	import com.fuelindustries.svn.core.errors.SVNErrorManager;
	import com.fuelindustries.svn.core.errors.SVNErrorMessage;
	import com.fuelindustries.svn.core.io.SVNCommand;
	import com.fuelindustries.svn.core.io.svn.SVNItem;
	import com.fuelindustries.svn.core.io.svn.SVNNodeKind;
	import com.fuelindustries.svn.core.io.svn.SVNReader;
	import com.fuelindustries.svn.core.util.SVNDate;
	import com.fuelindustries.svn.core.util.SVNHashMap;
	import com.fuelindustries.svn.core.util.SVNLogType;
	import com.fuelindustries.svn.events.LogEvent;

	import flash.utils.ByteArray;

	/**
	 * @author julian
	 */
	public class LogCommand extends SVNCommand 
	{
		
		private var wantCustomRevProps:Boolean;
		private var handler:ISVNLogEntryHandler;
		private var limit:int;
		private var revisionPropertyNames:Array;
		
		
		public function LogCommand(template:String = null, items:Array = null, _handler:ISVNLogEntryHandler = null)
		{
			handler = _handler;
			wantCustomRevProps = false;
			if( items[ 9 ] is Array )
			{
				revisionPropertyNames = items[ 9 ] as Array;
				for (var i:int = 0; i < revisionPropertyNames.length; i++) 
				 {
                    var propName:String = revisionPropertyNames[i] as String;
                    if (!SVNRevisionProperty.AUTHOR == propName && !SVNRevisionProperty.DATE == propName && !SVNRevisionProperty.LOG == propName ) 
                    {
                        wantCustomRevProps = true;
                        break;
                    }
				 }	
			}
			
			limit = items[ 6 ] as int;
			
			super( template, items );
		}

		override public function parseCommand(ba:ByteArray):void
		{
			var count:int = 0;
        var nestLevel:int = 0;
			
			while (true) 
			{
                var item:SVNItem = SVNReader.readItem( ba );
                if (item.getKind() == SVNItem.WORD && "done" == item.getWord()) {
                    break;
                }
                if (item.getKind() != SVNItem.LIST) {
                    SVNErrorManager.error(SVNErrorMessage.create(SVNErrorCode.RA_SVN_MALFORMED_DATA, "Log entry not a list"), SVNLogType.NETWORK);
                    throw new Error( "Log entry not a list" );
                }

                //now we read log response kind of
                // ( ( ) 1 ( ) ( 27:2008-04-02T13:32:15.165405Z ) ( 27:Log message for revision 1. ) false false 0 ( ) )
                // paths  athr                               date                            log msg hasChrn invR  rProps
                //     0 1   2                                  3                                  4     5     6 7   8

                var items:Array = SVNReader.parseTupleArray("lr(?s)(?s)(?s)?ssnl", item.getItems(), null);
                var changedPathsList:Array = items[ 0 ] as Array;
                var changedPathsMap:SVNHashMap = new SVNHashMap();
                
                if (changedPathsList != null && changedPathsList.length > 0) 
                {
                    for( var i:int = 0; i<changedPathsList.length; i++ ) 
                    {
                        var pathItem:SVNItem = changedPathsList[ i ] as SVNItem;
                        
                        if (pathItem.getKind() != SVNItem.LIST) 
                        {
                            SVNErrorManager.error(SVNErrorMessage.create(SVNErrorCode.RA_SVN_MALFORMED_DATA, "Changed-path entry not a list"), SVNLogType.NETWORK);
                        }
                        
                        var pathItems:Array = SVNReader.parseTupleArray("sw(?sr)?(?s)", pathItem.getItems(), null);
                        var path:String = SVNReader.getString(pathItems, 0);
                        var action:String = SVNReader.getString(pathItems, 1);
                        var copyPath:String = SVNReader.getString(pathItems, 2);
                        var copyRevision:int = SVNReader.getLong(pathItems, 3);
                        var kind:String = SVNReader.getString(pathItems, 4);
                        changedPathsMap.put(path, new SVNLogEntryPath(path, action.charAt(0), copyPath, copyRevision, kind != null ? SVNNodeKind.parseKind(kind) : new SVNNodeKind( SVNNodeKind.UNKNOWN )));
                    }
                }
                if (nestLevel == 0) {
                    count++;
                }
                var revision:int = 0;
                var revisionProperties:SVNProperties = null;
                var logEntryProperties:SVNProperties = new SVNProperties();
                var hasChildren:Boolean = false;
                
                if (handler != null && !(limit > 0 && count > limit && nestLevel == 0)) 
                {
                    revision = SVNReader.getLong(items, 1);
                    var author:String = SVNReader.getString(items, 2);
                    var date:Date = SVNReader.getDate(items, 3);
                   
                    var message:String = SVNReader.getString(items, 4);
                    hasChildren = SVNReader.getBoolean(items, 5);
                    var invalidRevision:Boolean = SVNReader.getBoolean(items, 6);
                    revisionProperties = SVNReader.getProperties(items, 8, null);
                    if (invalidRevision) {
                        //revision = SVNRepository.INVALID_REVISION;
                    }
                    if (wantCustomRevProps && (revisionProperties == null)) 
                    {
                        SVNErrorManager.error(SVNErrorMessage.create(SVNErrorCode.RA_NOT_IMPLEMENTED, "Server does not support custom revprops via log"), SVNLogType.NETWORK);
                    }

                    if (revisionProperties != null) 
                    {
                        var keys:Array = revisionProperties.nameSet();
                        
                        for( var j:int = 0; j<keys.length; j++ )
                        {
                        	var name:String = keys[ i ]	as String;
                        	logEntryProperties.put( name, revisionProperties.getSVNPropertyValue(name));
                        }
                    }

                    if (revisionPropertyNames == null || revisionPropertyNames.length == 0) {
                        if (author != null) {
                            logEntryProperties.put(SVNRevisionProperty.AUTHOR, author);
                        }
                        if (date != null) {
                            logEntryProperties.put(SVNRevisionProperty.DATE, SVNDate.formatDate(date));
                        }
                        if (message != null) {
                            logEntryProperties.put(SVNRevisionProperty.LOG, message);
                        }
                    } else {
                        for ( var k:int = 0; k< revisionPropertyNames.length; k++) {
                            var revPropName:String = revisionPropertyNames[k];
                            if (author != null && SVNRevisionProperty.AUTHOR == revPropName) {
                                logEntryProperties.put(SVNRevisionProperty.AUTHOR, author);
                            }
                            if (date != null && SVNRevisionProperty.DATE == revPropName) {
                                logEntryProperties.put(SVNRevisionProperty.DATE, SVNDate.formatDate(date));
                            }
                            if (message != null && SVNRevisionProperty.LOG == revPropName) {
                                logEntryProperties.put(SVNRevisionProperty.LOG, message);
                            }
                        }
                    }
  
                }
                if (handler != null && !(limit > 0 && count > limit && nestLevel == 0)) {
                    var logEntry:SVNLogEntry = new SVNLogEntry(changedPathsMap, revision, logEntryProperties, hasChildren);
                    handler.handleLogEntry(logEntry);
                    if (logEntry.hasChildren()) {
                        nestLevel++;
                    }
                    if (logEntry.getRevision() < 0) {
                        nestLevel--;
                        if (nestLevel < 0) {
                            nestLevel = 0;
                        }
                    }
                }
			}
			
			__event = new LogEvent( LogEvent.LOG, this );
			commandComplete();
		}

		override protected function isComplete(str:String):Boolean
		{
			var pattern:String = str.substring( str.length - 22, str.length );
     
			if( pattern == " done ( success ( ) ) " )
			{
				return true;
			}
			else
			{
				return false;
			}
		}
	}
}
