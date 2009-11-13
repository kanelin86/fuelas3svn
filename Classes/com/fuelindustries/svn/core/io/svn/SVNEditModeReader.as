package com.fuelindustries.svn.core.io.svn 
{
	import com.fuelindustries.svn.core.SVNPropertyValue;
	import com.fuelindustries.svn.core.io.ISVNEditor;
	import com.fuelindustries.svn.core.util.SVNHashMap;
	import com.fuelindustries.svn.core.util.SVNPathUtil;
	import com.fuelindustries.svn.delta.SVNDeltaReader;

	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 * @author julian
	 */
	public class SVNEditModeReader 
	{
		private var COMMANDS_MAP:Dictionary;
    	private var myConnection:SVNConnection;
	    private var myEditor:ISVNEditor;
	    private var myDeltaReader:SVNDeltaReader;
	    private var myFilePath:String;
	
	    private var myDone:Boolean;
	    private var myAborted:Boolean;
	    private var myForReplay:Boolean;
	    private var myTokens:SVNHashMap;
	    private var myData:ByteArray;
    	
    	public function SVNEditModeReader( data:ByteArray, connection:SVNConnection, editor:ISVNEditor, forReplay:Boolean )
    	{
    		initCommands();
    		myData = data;
    		myConnection = connection;
	        myEditor = editor;
	        myDeltaReader = new SVNDeltaReader();
	        myDone = false;
	        myAborted = false;
	        myForReplay = forReplay;
	        myTokens = new SVNHashMap();
    	}
    	
    	private function initCommands():void
    	{
    		COMMANDS_MAP = new Dictionary();    
	    	COMMANDS_MAP["target-rev"] = "r";
	        COMMANDS_MAP["open-root"] = "(?r)s";
	        COMMANDS_MAP["delete-entry"] = "s(?r)s";
	        COMMANDS_MAP["add-dir"] = "sss(?sr)";
	        COMMANDS_MAP["open-dir"] = "sss(?r)";
	        COMMANDS_MAP["change-dir-prop"] = "ss(?b)";
	        COMMANDS_MAP["close-dir"] = "s";
	        COMMANDS_MAP["add-file"] = "sss(?sr)";
	        COMMANDS_MAP["open-file"] = "sss(?r)";
	        COMMANDS_MAP["apply-textdelta"] = "s(?s)";
	        COMMANDS_MAP["textdelta-chunk"] = "sb";
	        COMMANDS_MAP["textdelta-end"] = "s";
	        COMMANDS_MAP["change-file-prop"] = "ss(?b)";
	        COMMANDS_MAP["close-file"] = "s(?b)";
	        COMMANDS_MAP["close-edit"] = "()";
	        COMMANDS_MAP["abort-edit"] = "()";
	        COMMANDS_MAP["finish-replay"] = "()";
	        COMMANDS_MAP["absent-dir"] = "ss";
	        COMMANDS_MAP["absent-file"] = "ss";
    	}

		public function isAborted():Boolean 
		{
			return myAborted;
		}

		private function storeToken( token:String, isFile:Boolean ):void 
		{
			myTokens.put( token, isFile );
		}

		private function lookupToken( token:String, isFile:Boolean ):void
		{
			var tokenType:Boolean = myTokens.getValue( token ) as Boolean;
			if( tokenType != isFile) 
			{
				//TODO implement proper errors
            
				//SVNErrorMessage err = SVNErrorMessage.create(SVNErrorCode.RA_SVN_MALFORMED_DATA, "Invalid file or dir token during edit");
				//SVNErrorManager.error(err, SVNLogType.NETWORK);
				throw new Error( "Invalid file or dir token during edit" );
			}
		}

		private function removeToken( token:String ):void 
		{
			myTokens.remove( token );
		}

		private function processCommand( commandName:String,  params:Array ):void 
		{
		 	
			var path:String;
			var token:String;
			var copyFromPath:String;
			var bytes:ByteArray;
		 	
			if ("target-rev" == commandName) 
			{
				myEditor.targetRevision( SVNReader.getLong( params, 0 ) );
			} 
        	else if ("open-root" == commandName) 
			{
				myEditor.openRoot( SVNReader.getLong( params, 0 ) );
				token = SVNReader.getString( params, 1 );
				storeToken( token, false );
			} 
       		else if ("delete-entry" == commandName ) 
			{
				lookupToken( SVNReader.getString( params, 2 ), false );
				path = SVNPathUtil.canonicalizePath( SVNReader.getString( params, 0 ) );
				myEditor.deleteEntry( path, SVNReader.getLong( params, 1 ) );
			} 
        	else if ("add-dir" == commandName ) 
			{
				lookupToken( SVNReader.getString( params, 1 ), false );
				path = SVNPathUtil.canonicalizePath( SVNReader.getString( params, 0 ) );
				copyFromPath = SVNReader.getString( params, 3 );
				if (copyFromPath != null) 
				{
					copyFromPath = SVNPathUtil.canonicalizePath( copyFromPath );
				}
				myEditor.addDir( path, copyFromPath, SVNReader.getLong( params, 4 ) );
				storeToken( SVNReader.getString( params, 2 ), false );
			} 
			else if ("open-dir" == commandName) 
			{
				lookupToken( SVNReader.getString( params, 1 ), false );
				path = SVNPathUtil.canonicalizePath( SVNReader.getString( params, 0 ) );
				myEditor.openDir( path, SVNReader.getLong( params, 3 ) );
				storeToken( SVNReader.getString( params, 2 ), false );
			} 
			else if ("change-dir-prop" == commandName) 
			{
				lookupToken( SVNReader.getString( params, 0 ), false );
				bytes = SVNReader.getBytes( params, 2 );
				var propertyName:String = SVNReader.getString( params, 1 );
				myEditor.changeDirProperty( propertyName, SVNPropertyValue.create( propertyName, bytes ) );
			} 
			else if ("close-dir" == commandName) 
			{
				token = SVNReader.getString( params, 0 );
				lookupToken( token, false );
				myEditor.closeDir( );
				removeToken( token );
			} 
			else if ("add-file" == commandName) 
			{
				lookupToken( SVNReader.getString( params, 1 ), false );
				path = SVNPathUtil.canonicalizePath( SVNReader.getString( params, 0 ) );
				copyFromPath = SVNReader.getString( params, 3 );
				if (copyFromPath != null) 
				{
					copyFromPath = SVNPathUtil.canonicalizePath( copyFromPath );
				}
				storeToken( SVNReader.getString( params, 2 ), true );
				myEditor.addFile( path, copyFromPath, SVNReader.getLong( params, 4 ) );
				myFilePath = path;
			} 
			else if ("open-file" == commandName) 
			{
				lookupToken( SVNReader.getString( params, 1 ), false );
				path = SVNPathUtil.canonicalizePath( SVNReader.getString( params, 0 ) );
				storeToken( SVNReader.getString( params, 2 ), true );
				myEditor.openFile( SVNReader.getString( params, 0 ), SVNReader.getLong( params, 3 ) );
				myFilePath = path;
			} 
			else if ("change-file-prop" == commandName) 
			{
				lookupToken( SVNReader.getString( params, 0 ), true );
				bytes = SVNReader.getBytes( params, 2 );
				propertyName = SVNReader.getString( params, 1 );
				myEditor.changeFileProperty( myFilePath, propertyName, SVNPropertyValue.create( propertyName, bytes ) );
			} 
			else if ("close-file" == commandName) 
			{
				token = SVNReader.getString( params, 0 );
				lookupToken( token, true );
				myEditor.closeFile( myFilePath, SVNReader.getString( params, 1 ) );
				removeToken( token );
			} 
			else if ("apply-textdelta" == commandName) 
			{
				lookupToken( SVNReader.getString( params, 0 ), true );
				myEditor.applyTextDelta( myFilePath, SVNReader.getString( params, 1 ) );
			} 
			else if ("textdelta-chunk" == commandName) 
			{
				lookupToken( SVNReader.getString( params, 0 ), true );
				var chunk:ByteArray = SVNReader.getBytes( params, 1 );
				myDeltaReader.nextWindow( chunk, 0, chunk.length, myFilePath, myEditor );
			} 
			else if ("textdelta-end" == commandName) 
			{
				// reset delta reader,
				// this should send empty window when diffstream contained only header.
				lookupToken( SVNReader.getString( params, 0 ), true );
				myDeltaReader.reset( myFilePath, myEditor );
				myDeltaReader = new SVNDeltaReader();
				myEditor.textDeltaEnd( myFilePath );
			} 
			else if ("close-edit" == commandName) 
			{
				myEditor.closeEdit( );
				myDone = true;
				myAborted = false;
				myConnection.write( "(w())", [ "success" ] );
			} 
			else if ("abort-edit" == commandName) 
			{
				myEditor.abortEdit( );
				myDone = true;
				myAborted = true;
				myConnection.write( "(w())", [ "success" ] );
			} 
			else if ("absent-dir" == commandName) 
			{
				lookupToken( SVNReader.getString( params, 1 ), false );
				myEditor.absentDir( SVNReader.getString( params, 0 ) );
			} 
			else if ("absent-file" == commandName) 
			{
				lookupToken( SVNReader.getString( params, 1 ), false );
				myEditor.absentFile( SVNReader.getString( params, 0 ) );
			} 
			else if ("finish-replay" == commandName) 
			{
				if (!myForReplay) 
				{
					//TODO implement errors
                
					//SVNErrorMessage error = SVNErrorMessage.create(SVNErrorCode.RA_SVN_UNKNOWN_CMD, "Command 'finish-replay' invalid outside of replays");
					//SVNErrorManager.error(error, SVNLogType.NETWORK);
					throw new Error( "Command 'finish-replay' invalid outside of replays" );
				}
				myDone = true;
				myAborted = false;
			}
		}

		public function driveEditor():void 
		{
			while (!myDone) 
			{
				//SVNErrorMessage error = null;
				var items:Array = readTuple( "wl", false );
				var commandName:String = SVNReader.getString( items, 0 );
				var template:String = COMMANDS_MAP[commandName] as String;
            
				if (template == null) 
				{
                
					//TODO implement proper errors
					//SVNErrorMessage child = SVNErrorMessage.create(SVNErrorCode.RA_SVN_UNKNOWN_CMD, "Unknown command ''{0}''", commandName);
					//error = SVNErrorMessage.create(SVNErrorCode.RA_SVN_CMD_ERR);
					//error.setChildErrorMessage(child);
					throw new Error( "Unknown Command " + commandName );
				}
            
				var parameters:Array = SVNReader.parseTupleArray( template, items[ 1 ] as Array, null );
				processCommand( commandName, parameters );
				
           
           //TODO need to write and send error messages here
			}

		}

		private function readTuple( template:String, readMalformedData:Boolean ):Array
		{
			if (myConnection == null) 
			{
				//SVNErrorManager.error(SVNErrorMessage.create(SVNErrorCode.RA_SVN_CONNECTION_CLOSED), SVNLogType.NETWORK);
				throw new Error( "No Connection" );
			}
			
			var data:Array = SVNReader.readTuple( myData, template);
			
			return data;
		}
	}
}
