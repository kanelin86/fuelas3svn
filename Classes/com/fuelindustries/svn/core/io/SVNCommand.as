package com.fuelindustries.svn.core.io 
{
	import com.fuelindustries.svn.core.io.svn.SVNConnection;
	import com.fuelindustries.svn.core.io.svn.SVNReader;
	import com.fuelindustries.svn.core.io.svn.SVNWriter;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;

	/**
	 * @author julian
	 */
	public class SVNCommand extends EventDispatcher 
	{
		protected var __bytes:ByteArray;
		protected var __event:Event;
		protected var __items:Array;
		protected var __template:String;
		protected var __connection:SVNConnection;
		protected var __authenticated:Boolean;
		protected var __commandBytes:ByteArray;
		
		public function set connection( connection:SVNConnection ):void
		{
			__connection = connection;	
		}
		
		public function get connection():SVNConnection
		{
			return( __connection );	
		}
		
		
		public function get event():Event
		{
			return( __event );	
		}
		
		public function get bytes():ByteArray
		{
			return( __bytes );	
		}
		
		public function SVNCommand( template:String = null, items:Array = null )
		{
			__items = items;
			__template = template;
			__authenticated = false;
			
			if( template != null && items != null )
			{
				write( template, items );
			}
		}
		
		public function read( ba:ByteArray ):void
		{
			if( __commandBytes == null )
			{
				__commandBytes = new ByteArray();
			}
			
			__commandBytes.writeBytes( ba );			
			__commandBytes.position = 0;
			authenticate( __commandBytes );
			var str:String = __commandBytes.readUTFBytes( __commandBytes.bytesAvailable );
			var complete:Boolean = isComplete( str );
			
			if( complete )
			{
				__commandBytes.position = 0;
				authenticate( __commandBytes );
				parseCommand( __commandBytes );
			}
		}
		
		protected function emptyInput():void
		{
			__commandBytes = null;	
		}
		
		protected function isComplete( str:String ):Boolean
		{
			var counter:int = 0;

			for( var i:int = 0; i<str.length; i++ )
			{
				var char:String = str.charAt( i );
				if( char == "(" ) counter++;
				if( char == ")" ) counter--;
				
				if( counter == 0 )
				{
					return( true );
				}
			}	
			
			return( false );
		}
		
		protected function parse( ba:ByteArray, template:String, items:Array ):Array
		{
			return( SVNReader.parse(ba, template, items) );	
		}
		
		public function parseCommand( ba:ByteArray ):void
		{
			//parse the command
		}
		
		protected function authenticate( ba:ByteArray ):void
		{
			var items:Array = parse( ba, "ls", null );
	        var mechs:Array = SVNReader.getList( items, 0 );
	        
	        if( mechs == null || mechs.length == 0 )
	        {
	        	__authenticated = true;
	        	return;	
	        }
	        
	        //TODO figure out what to do if a command needs authentication
	        throw new Error( "COMMAND NEEDS AUTHENTICATION" );	
		}
		
		protected function write( template:String, items:Array ):void
		{
			__bytes = SVNWriter.write(template, items);
			__bytes.position = 0;
		}
		
		protected function sendCommand( template:String, items:Array ):void
		{
			__connection.write( template, items );
		}
		
		protected function commandComplete():void
		{
			emptyInput();
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
	}
}
