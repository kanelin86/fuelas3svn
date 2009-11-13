package com.fuelindustries.svn.core.io.commands 
{
	import com.fuelindustries.svn.client.ExportEditor;
	import com.fuelindustries.svn.core.io.ISVNEditor;
	import com.fuelindustries.svn.core.io.SVNCommand;
	import com.fuelindustries.svn.core.io.svn.SVNEditModeReader;
	import com.fuelindustries.svn.core.io.svn.SVNReader;
	import com.fuelindustries.svn.events.UpdateCommandEvent;

	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	/**
	 * @author julian
	 */
	public class UpdateCommand extends SVNCommand 
	{
		
		private var __state:String;
		private var __path:String;
		private var __rev:int;
		private var __editor:ISVNEditor;
		
		public function UpdateCommand( template:String, items:Array, editor:ISVNEditor )
		{
			__editor = editor;
			__rev = items[ 1 ] as int;
			__path = items[ 2 ] as String;
			__state = "UPDATE";
			super( template, items );
		}

		override public function parseCommand(ba:ByteArray):void
		{
			switch( __state )
			{
				case "UPDATE":
					__state = "REPORT_FINISHED";
					__commandBytes.clear();
					__commandBytes = null;
					setPath();
					finishReport();
					break;
				case "REPORT_FINISHED":
					__state = "EDITING";
					writeFinalData();
					var editReader:SVNEditModeReader = new SVNEditModeReader( ba, __connection, __editor, false );
            		editReader.driveEditor();
            		__commandBytes.clear();
					__commandBytes = null;
					break;
				case "EDITING":
					__state = "DONE";
					ba.position = 0;
					var items1:Array = SVNReader.readTuple( ba, "wl" );
					var command:String = SVNReader.getString( items1, 0 );
					var done:Boolean = "abort-edit" == command || "success" == command;
					
					if( done )
					{
						__event = new UpdateCommandEvent( UpdateCommandEvent.UPDATE, this );
						commandComplete();
					}
					
					break;
			}
		}
		
		private function writeFinalData():void
		{
			var oldpos:int = __commandBytes.position;
			var f:File = new File( "/Users/julian/Work/Projects/Fuel Internal Projects/SVNBrowser/trunk/exports/update.txt" );
			var stream:FileStream = new FileStream();
			stream.open( f , FileMode.WRITE );
			stream.writeBytes( __commandBytes );
			stream.close();
			__commandBytes.position = oldpos;
		}
		
		
		private function setPath():void
		{
        	sendCommand("(w(snw(s)w))", [ "set-path", "", __rev, true, null, "infinity" ]);	
		}
		
		private function finishReport():void
		{
			sendCommand( "(w())", [ "finish-report" ] );	
		}
		
		override public function read( ba:ByteArray ):void
		{
			//( close-edit ( ) ) 
			
			if( __commandBytes == null )
			{
				__commandBytes = new ByteArray();
			}
			
			__commandBytes.writeBytes( ba );

			__commandBytes.position = 0;
			authenticate( __commandBytes );
			
			var complete:Boolean = false;
			
			if( __state == "REPORT_FINISHED" )
			{
				complete = reportFinished();
			}
			else if( __state == "EDITING" )
			{
				__commandBytes.position = 0;
				complete = isComplete( __commandBytes.readUTFBytes( __commandBytes.bytesAvailable ) );
			}
			else if( __state == "UPDATE" )
			{
				var str:String = __commandBytes.readUTFBytes( __commandBytes.bytesAvailable );
				if( str == "" )
				{
					complete = true;	
				}
			}
			else
			{
				complete = isComplete( __commandBytes.readUTFBytes( __commandBytes.bytesAvailable ) );
			}
			
			
			if( complete )
			{
				__commandBytes.position = 0;
				authenticate( __commandBytes );
				parseCommand( __commandBytes );
			}
		}
		
		protected function reportFinished():Boolean
		{
			__commandBytes.position = __commandBytes.length - 20;
			var str:String = __commandBytes.readUTFBytes( __commandBytes.bytesAvailable );
			
			var pattern:String = str.substring( str.length - 20, str.length );
     
			if( pattern == " ( close-edit ( ) ) " )
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
