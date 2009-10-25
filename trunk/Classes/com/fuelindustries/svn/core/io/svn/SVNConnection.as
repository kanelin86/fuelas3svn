package com.fuelindustries.svn.core.io.svn 
{
	import com.fuelindustries.svn.core.SVNURL;
	import com.fuelindustries.svn.core.auth.SVNPasswordAuthentication;
	import com.fuelindustries.svn.core.io.SVNCommand;
	import com.fuelindustries.svn.events.SVNCommandCompleteEvent;
	import com.fuelindustries.svn.events.SVNEvent;
	import com.fuelindustries.svn.events.SocketDataEvent;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;

	/**
	 * @author julian
	 */
	public class SVNConnection extends EventDispatcher
	{		
		private static var EDIT_PIPELINE:String = "edit-pipeline";
		private static var SVNDIFF1:String = "svndiff1";
		private static var ABSENT_ENTRIES:String = "absent-entries";
		private static var COMMIT_REVPROPS:String = "commit-revprops";
		private static var MERGE_INFO:String = "mergeinfo";
		private static var DEPTH:String = "depth";
		private static var LOG_REVPROPS:String = "log-revprops";
		
		private static var HANDSHAKE:String = "handshake";
		private static var AUTHENTICATE:String = "autenticate";
		private static var CRAM_MD5:String = "crammd5";
		private static var COMMAND:String = "command";
		
		private var myRepository:SVNRepositoryImpl;
		private var myConnector:SVNPlainConnector;
		private var myIsCredentialsReceived:Boolean;
		private var myInputStream:ByteArray;
		private var myCapabilities:Array;
		private var myIsSVNDiff1:Boolean;
		private var myIsCommitRevprops:Boolean;
		private var myState:String;
		private var myRealm:String;
		private var myRoot:String;
		
		private var currentCommand:SVNCommand;
		
		public function SVNConnection( connector:SVNPlainConnector,  repository:SVNRepositoryImpl) 
		{
			myConnector = connector;
			myRepository = repository;
		}
		
		public function open( repository:SVNRepositoryImpl ):void
		{
			if( !myConnector.isConnected(repository) )
			{
				myIsCredentialsReceived = false;
				myConnector.addEventListener( SocketDataEvent.DATA, onSocketData );
				myState = HANDSHAKE;
				myRepository = repository;
				myConnector.open( repository );
			}
		}
		
		private function onSocketData( e:SocketDataEvent ):void
		{
			myInputStream = e.data;
			
			switch( myState )
			{
				case HANDSHAKE:
					handshake();
					break;
				case AUTHENTICATE:
					authenticate();
					break;
				case CRAM_MD5:
					parseMD5();
					break;
				case COMMAND:
					if( currentCommand == null ) throw new Error( "No SVNCommand set" );
					currentCommand.read( myInputStream );
					break;
			}
		}
		
		private function handshake():void
		{
			var ba:ByteArray = skipLeadingGrabage();
			ba.position = 0;
			var items:Array = SVNReader.parse( ba, "nnll", null );
			
			var minVer:Number = items[ 0 ] as Number;
			var maxVer:Number = items[ 1 ] as Number;
        
			if( minVer > 2) 
			{
				//TODO implement errors
				//SVNErrorManager.error(SVNErrorMessage.create(SVNErrorCode.RA_SVN_BAD_VERSION, "Server requires minimum version {0}", minVer), SVNLogType.NETWORK);
				throw new Error( "Server requires minimum version " + minVer );
			} 
        	else if (maxVer < 2) 
			{
				//TODO implement errors
				//SVNErrorManager.error(SVNErrorMessage.create(SVNErrorCode.RA_SVN_BAD_VERSION, "Server requires maximum version {0}", maxVer), SVNLogType.NETWORK);
				throw new Error( "Server requires maximum version " + maxVer );
			}

			var capabilities:Array = items[ 3 ] as Array;
        
			addCapabilities( capabilities );
        
			if (!hasCapability( EDIT_PIPELINE )) 
			{
				//TODO implement error
				//SVNErrorManager.error(SVNErrorMessage.create(SVNErrorCode.RA_SVN_BAD_VERSION, "Server does not support edit pipelining"), SVNLogType.NETWORK);
				throw new Error( "Server does not support edit pipelining" );
			}
        
        
			myIsSVNDiff1 = SVNReader.hasValue( items, 3, SVNDIFF1 );
			myIsCommitRevprops = SVNReader.hasValue( items, 3, COMMIT_REVPROPS );
			
			myState = AUTHENTICATE;
			
			write("(n(wwwwww)s)", ["2", EDIT_PIPELINE, SVNDIFF1, ABSENT_ENTRIES, DEPTH, MERGE_INFO, LOG_REVPROPS, myRepository.getLocation().toString()]);
		}

		private function addCapabilities( capabilities:Array ):void 
		{
			if (myCapabilities == null) 
			{
				myCapabilities = new Array( );
			}
			if (capabilities == null || capabilities.length == 0 ) 
			{
				return;
			}
        
			for( var i:int = 0; i < capabilities.length ; i++ )
			{
				var item:SVNItem = capabilities[ i ] as SVNItem;
				if( item.getKind( ) != SVNItem.WORD )
				{
					//TODO implement Errors
					//SVNErrorMessage err = SVNErrorMessage.create(SVNErrorCode.RA_SVN_MALFORMED_DATA, "Capability entry is not a word"); 
					//SVNErrorManager.error(err, SVNLogType.NETWORK);
					throw new Error( "Capability entry is not a word" );
				}
				else
				{
					myCapabilities.push( item.getWord() );
				}
			}
		}

		protected function hasCapability( capability:String ):Boolean 
		{
			if (myCapabilities != null) 
			{
				for( var i:int = 0; i < myCapabilities.length ; i++ )
				{
					if( myCapabilities[ i ] as String == capability )
					{
						return true;	
					}	
				}
			}
			return false;
		}

		private function skipLeadingGrabage():ByteArray
		{
			var bytes:ByteArray = new ByteArray();
			myInputStream.position = 0;
			myInputStream.readBytes(bytes);

			bytes.position = 0;
			
			for( var i:int = 0; i<bytes.length; i++ )
			{
				
				if( bytes.bytesAvailable < 2 ) break;
				
				var byte:int = bytes.readByte( );
				var next:int = bytes.readByte( );
				bytes.position -= 1;

				if( byte == "(".charCodeAt() && next == ' '.charCodeAt() ) 
				{
					var ba:ByteArray = new ByteArray();
					bytes.position = i;
					bytes.readBytes( ba, 0, bytes.length - i  );
					return ba;
				}
			}
			
			//TODO Error if for whatever reason it gets here it's malformed data
			throw new Error( "data is malformed" );
			return bytes;
		}
		
		private function authenticate():void
		{
			//implement authentication
			//( success ( ( CRAM-MD5 ) 36:0b490fdd-6d02-e842-8655-fd354a742aa5 ) )

	        var items:Array = read( "ls", null, true );
	        var mechs:Array = SVNReader.getList( items, 0 );
	        if( mechs == null || mechs.length == 0 )
	        {
	        	trace( "no mechs in authentication" );
	        	return;	
	        }
	        
	        myRealm = SVNReader.getString( items, 1 );
	        
	        if( arrayContains( mechs, "ANONYMOUS") && ( arrayContains( mechs, "CRAM-MD5") || arrayContains( mechs, "DIGEST-MD5") ) )
	        {
	        	for( var i:int = 0; i<mechs.length; i++ )
	        	{
	        		if( mechs[ i ] == "ANONYMOUS" )
	        		{
	        			mechs.splice( i, 1 );
	        			break;		
	        		}
	        	}
	        }
	        
	        var location:SVNURL = myRepository.getLocation();
	        
	        if( arrayContains( mechs, "EXTERNAL") )
	        {
	        	//TODO This needs to be tested and implemented properly.
	        	//write( "(w(s))", ["EXTERNAL", ""] );
	        }
	        else if( arrayContains( mechs, "ANONYMOUS") )
	        {
	        	//TODO this needs to be tested and implemented properly
	        	//write("(w(s))", ["ANONYMOUS", ""]);	
	        }
	        else if( arrayContains( mechs, "CRAM-MD5") )
	        {
	        	if (location != null) 
            	{
               		myRealm = "<" + location.getProtocol() + "://" + location.getHost() + ":" + location.getPort() + "> " + myRealm;
            	}
            	
            	myState = CRAM_MD5;
				write("(w())", ["CRAM-MD5"]);
	        }
	        
		}
		
		private function parseMD5():void
		{
			var authenticator:CramMD5 = new CramMD5();
			authenticator.setUserCredentials( myRepository.getAuthentication() as SVNPasswordAuthentication );
			var items:Array = readTuple("w(?s)", true);
			var status:String = SVNReader.getString(items, 0);
			
			if( "success" == status ) 
            {
            	trace( "successful connection" );
            	myState = COMMAND;
   				
   				receiveRepositoryCredentials( myRepository );
            	dispatchEvent( new Event( SVNEvent.AUTHENTICATED ) );
            }
            else if ( "failure" == status ) 
            {
            	var message:String = SVNReader.getString(items, 1);
            	trace( "Autentication error", message );
            	
            	//TODO Should probably close the connection and shut everthing down at this point.
            }
            else if ( "step" == status ) 
            {
            	var response:ByteArray = authenticator.buildChallengeResponse( SVNReader.getBytes( items, 1 ) );
            	myConnector.sendCommand( response );
            }
		}

		private function receiveRepositoryCredentials( repository:SVNRepositoryImpl ):void
		{
			if (myIsCredentialsReceived) 
			{
				return;
			}
			var creds:Array = read( "s?s?l", null, true, myInputStream.position );
			myIsCredentialsReceived = true;
			if (creds != null && creds.length >= 2 && creds[0] != null && creds[1] != null) 
			{
				var rootURL:SVNURL = creds[1] != null ? SVNURL.parseURIEncoded( SVNReader.getString( creds, 1 ) ) : null;
            
				if (rootURL != null && rootURL.toString( ).length > repository.getLocation( ).toString( ).length) 
				{
               //TODO implement Error
               // SVNErrorManager.error(SVNErrorMessage.create(SVNErrorCode.RA_SVN_MALFORMED_DATA, "Impossibly long repository root from server"), SVNLogType.NETWORK);
				}
            
				if (repository != null && repository.getRepositoryRoot( false ) == null) 
				{
					repository.updateCredentials( SVNReader.getString( creds, 0 ), rootURL );
				}
				if (myRealm == null) 
				{
					myRealm = SVNReader.getString( creds, 0 );
				}
				if (myRoot == null) 
				{
					myRoot = SVNReader.getString( creds, 1 );
				}
            
				if (creds.length > 2 && creds[ 2 ] is Array) 
				{
					var capabilities:Array = creds[2] as Array;
					addCapabilities( capabilities );
				}
			}
		}

		//TODO abstract this out
		private function arrayContains( arr:Array, value:String ):Boolean
		{
			for( var i:int = 0; i<arr.length; i++ )
			{
				if( arr[ i ] == value )
				{
					return true;	
				}	
			}
			
			return false;
		}
	
		public function sendCommand( command:SVNCommand ):void
		{
			currentCommand = command;
			currentCommand.connection = this;
			trace( "current Command", command );
			currentCommand.addEventListener( Event.COMPLETE, commandComplete );
			myConnector.sendCommand( command.bytes );	
		}
		
		public function write( template:String, items:Array ):void
		{
			var ba:ByteArray = SVNWriter.write(template, items);
			ba.position = 0;
			myConnector.sendCommand( ba );
		}
		
		public function read( template:String, items:Array, readMalformedData:Boolean, position:int = 0 ):Array
		{
			myInputStream.position = position;
			var data:Array = SVNReader.parse( myInputStream, template, items );
			
			if( readMalformedData )
			{
				//TODO read any malformed data	
			}
			
			return data;
		}
		
		public function readTuple( template:String, readMalformedData:Boolean ):Array
		{
			var data:Array = SVNReader.readTuple( myInputStream, template);
			
			if( readMalformedData )
			{
				//TODO read any malformed data	
			}
			
			return data;
		}
		
		private function commandComplete( e:Event ):void
		{
			trace( "commandComplete connection", currentCommand );
			currentCommand.removeEventListener( Event.COMPLETE, commandComplete );
			
			var event:SVNCommandCompleteEvent = new SVNCommandCompleteEvent( Event.COMPLETE, currentCommand.event );
			currentCommand.connection = null;
			currentCommand = null;
			dispatchEvent( event );
			
		}
	}
}
