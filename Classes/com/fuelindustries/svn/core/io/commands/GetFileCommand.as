package com.fuelindustries.svn.core.io.commands 
{
	import com.fuelindustries.svn.core.io.SVNCommand;
	import com.fuelindustries.svn.core.io.svn.SVNItem;
	import com.fuelindustries.svn.core.io.svn.SVNReader;
	import com.fuelindustries.svn.core.util.SVNFileUtil;
	import com.fuelindustries.svn.events.GetFileEvent;

	import flash.utils.ByteArray;

	/**
	 * @author julian
	 */
	public class GetFileCommand extends SVNCommand 
	{
		private var __contents:ByteArray;
		private var __path:String;
		
		
		public function get contents():ByteArray
		{
			return( __contents );	
		}
		
		public function GetFileCommand(template:String = null, items:Array = null)
		{
			__path = items[ 1 ] as String;
			super( template, items );
		}

		override public function parseCommand(ba:ByteArray):void
		{
			var values:Array = parse(ba, "(?s)rl", null );
			var expectedChecksum:String = SVNReader.getString(values, 0);
			var contents:ByteArray = new ByteArray();
			
			var digest:ByteArray = new ByteArray();
			
			 while (true)
			  {
                    var item:SVNItem = SVNReader.readItem( ba );
                    if (item.getKind() != SVNItem.BYTES) 
                    {
                        //TODO Implement errors
                        //SVNErrorMessage err = SVNErrorMessage.create(SVNErrorCode.RA_SVN_MALFORMED_DATA, "Non-string as part of file contents");
                        //SVNErrorManager.error(err, SVNLogType.NETWORK);
                    }
                    
                    if (item.getBytes().length == 0) 
                    {
                        break;
                    }
                    
                    if (expectedChecksum != null) 
                    {
                        digest.writeBytes( item.getBytes() );
                    }
                    
                    contents.writeBytes( item.getBytes() );
			  }
			  
			  if (expectedChecksum != null) 
              {
              	var checksum:String = SVNFileUtil.toHexDigest(digest);
              	if( checksum != expectedChecksum )
              	{
              		//TODO implement proper error
              		//SVNErrorMessage err = SVNErrorMessage.create(SVNErrorCode.CHECKSUM_MISMATCH, "Checksum mismatch for ''{0}''\nexpected checksum: ''{1}''\nactual checksum: ''{2}''", new Object[]{path, expectedChecksum, resultChecksum});
                    //SVNErrorManager.error(err, SVNLogType.NETWORK);	
                    throw new Error( "Checksum mismatch for " + __path +"\nexpected checksum: " + expectedChecksum + "\nactual checksum: " + checksum  );
              	}

              }
              
              digest = null;
			  
			  __contents = contents;
			  __event = new GetFileEvent( GetFileEvent.GET_FILE, contents, __path, this );
			  commandComplete();
		}

		override protected function isComplete(str:String):Boolean
		{
			var pattern:String = str.substring( str.length - 20, str.length );
			              
			if( pattern == " 0: ( success ( ) ) " )
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
