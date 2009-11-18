package com.fuelindustries.svn.delta 
{
	import com.fuelindustries.svn.core.errors.SVNErrorCode;
	import com.fuelindustries.svn.core.errors.SVNErrorManager;
	import com.fuelindustries.svn.core.errors.SVNErrorMessage;
	import com.fuelindustries.svn.core.io.ISVNDeltaConsumer;
	import com.fuelindustries.svn.core.io.diff.SVNDiffWindow;
	import com.fuelindustries.svn.core.util.SVNLogType;

	import flash.utils.ByteArray;

	/**
	 * @author julian
	 */
	public class SVNDeltaReader 
	{
		
		private var myBuffer:ByteArray;
    
	    private var myHeaderBytes:int;
	    private var myLastSourceOffset:int;
	    private var myLastSourceLength:int;
	    private var myIsWindowSent:Boolean;
	    private var myVersion:int;
	    
	    private var __limit:int;
	    private var __capacity:int;

		 public function SVNDeltaReader() 
		 {
        	myBuffer = new ByteArray();
        	__capacity = 4096;
        	__limit = 0;
		}

		public function nextWindow( data:ByteArray,  offset:int, length:int,  path:String,  consumer:ISVNDeltaConsumer ):void
		{
			appendToBuffer( data, offset, length );

			if (myHeaderBytes < 4) 
			{
            
				if (myBuffer.bytesAvailable < 4) 
				{
					return;
				}
            
				var s:int = myBuffer.readByte( );
				var v:int = myBuffer.readByte( );
				var n:int = myBuffer.readByte( );
				var version:int = myBuffer.readByte( );
				
				trace( "S".charCodeAt( ), "V".charCodeAt( ), "N".charCodeAt( ), "0".charCodeAt( ), "1".charCodeAt( ) );
				
            
				if ( s != "S".charCodeAt( ) || v != 'V'.charCodeAt( ) || n != 'N'.charCodeAt( ) || (version != 0 && version != 1 )) 
				{
					SVNErrorManager.error(SVNErrorMessage.create(SVNErrorCode.SVNDIFF_CORRUPT_WINDOW, "Svndiff has invalid header"), SVNLogType.DEFAULT);
				}
            
				myVersion = version;
				myBuffer.position = 4;
				var remaining:int = myBuffer.bytesAvailable;
            
				var compact:ByteArray = new ByteArray( );
				compact.writeBytes( myBuffer, myBuffer.position );
				compact.position = 0;
            
				myBuffer.clear( );
				myBuffer.writeBytes( compact );
				myBuffer.position = 0;
				setLimit( remaining );
				myHeaderBytes = 4;
			}
			
			while(true) 
			{
				var sourceOffset:int = readLongOffset( );
				if (sourceOffset < 0) 
				{
					return;
				}
				var sourceLength:int = readOffset( );
				if (sourceLength < 0) 
				{
					return;
				}
				var targetLength:int = readOffset( );
				if (targetLength < 0) 
				{
					return;
				}
				var instructionsLength:int = readOffset( );
				if (instructionsLength < 0) 
				{
					return;
				}
				var newDataLength:int = readOffset( );
				if (newDataLength < 0) 
				{
					return;
				}
				if (sourceLength > 0 && (sourceOffset < myLastSourceOffset || sourceOffset + sourceLength < myLastSourceOffset + myLastSourceLength)) 
				{
					SVNErrorManager.error(SVNErrorMessage.create(SVNErrorCode.SVNDIFF_CORRUPT_WINDOW, "Svndiff has backwards-sliding source views"), SVNLogType.DEFAULT);
				}
            
				if ( myBuffer.bytesAvailable < instructionsLength + newDataLength) 
				{
					return;
				}
            
				myLastSourceOffset = sourceOffset;
				myLastSourceLength = sourceLength;
				var allDataLength:int = newDataLength + instructionsLength;
            	
            	var window:SVNDiffWindow;
            	
				if (myVersion == 1) 
				{
					var out:ByteArray = new ByteArray( );
					var bufferPosition:int = myBuffer.position;
               
					instructionsLength = deflate( instructionsLength, out );
					newDataLength = deflate( newDataLength, out );
                
					var bytes:ByteArray = new ByteArray( );
					bytes.writeBytes( out );
					bytes.position = 0;
					
					window = new SVNDiffWindow(sourceOffset, sourceLength, targetLength, instructionsLength, newDataLength);
                	window.setData(bytes);
                	myBuffer.position = bufferPosition;
				}
				else
				{
					window = new SVNDiffWindow(sourceOffset, sourceLength, targetLength, instructionsLength, newDataLength);
                	window.setData(myBuffer);
				}
				
				var position:int = myBuffer.position;
            	var os:ByteArray = consumer.textDeltaChunk(path, window);
            
				myBuffer.position += allDataLength;
			}
		}

		private function deflate( compressedLength:int,  out:ByteArray ):int
		{
			var originalPosition:int = myBuffer.position;
			var uncompressedLength:int = readOffset( );
        
			var offset:int;
        
			// substract offset length from the total length.
			if (uncompressedLength == (compressedLength - (myBuffer.position - originalPosition))) 
			{
				offset = myBuffer.position;
				out.writeBytes( myBuffer, offset, uncompressedLength );
			} 
			else 
			{
				var compressed:ByteArray = new ByteArray( );
				compressed.writeBytes( myBuffer );
            
				offset = myBuffer.position;
            
				var inflated:ByteArray = new ByteArray( );
				
				var len:int = ( ( offset + compressedLength ) < compressed.length ) ? ( offset + compressedLength ) : 0;
				
				
				inflated.writeBytes( compressed, offset, len );
				inflated.position = 0;
				inflated.uncompress( "zlib" );
				
				out.writeBytes( inflated );
			}
			myBuffer.position = originalPosition + compressedLength;
			return uncompressedLength;
		}

		public function reset( path:String, consumer:ISVNDeltaConsumer):void
		{
			myLastSourceLength = 0;
	        myLastSourceOffset = 0;
	        myHeaderBytes = 0;
	        myIsWindowSent = false;
	        myVersion = 0;
			
			myBuffer.clear();
			
	        myBuffer = new ByteArray();
        	__capacity = 4096;
        	__limit = 0;
		}


		private function appendToBuffer( data:ByteArray, offset:int, length:int ):void
		{
			var limit:int = __limit; // amount of pending data?
			if (__capacity < limit + length) 
			{
				var newBuffer:ByteArray = new ByteArray( );
            
				myBuffer.position = 0;
				newBuffer.writeBytes( myBuffer );
				myBuffer = newBuffer;
			} 
			else 
			{
				setLimit( limit + length );
				myBuffer.position = limit;
			}
        
			myBuffer.writeBytes( data, offset, length );
			myBuffer.position = 0;
			setLimit( limit + length );
		}

		private function setLimit( newLimit:int ):void
		{
			__limit = newLimit;
		}

		private function readOffset():int 
		{
        	
			var offset:int = 0;
			var b:int;
			while(myBuffer.bytesAvailable > 0 ) 
			{
				b = myBuffer.readByte( );
				offset = (offset << 7) | (b & 0x7F);
				if ((b & 0x80) != 0) 
				{
					continue;
				}
				return offset;
			}

			return -1;
		}

		private function readLongOffset():int 
		{
			var offset:int = 0;
			var b:int;
			while(myBuffer.bytesAvailable > 0) 
			{
				b = myBuffer.readByte( );
				offset = (offset << 7) | (b & 0x7F);
				if ((b & 0x80) != 0) 
				{
					continue;
				}
				return offset;
			}
			return -1;
		}
	}
}
