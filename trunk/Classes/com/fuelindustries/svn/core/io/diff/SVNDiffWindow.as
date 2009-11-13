package com.fuelindustries.svn.core.io.diff 
{
	import flash.utils.ByteArray;

	/**
	 * @author julian
	 */
	public class SVNDiffWindow 
	{
		private var myData:ByteArray;
    	private var myDataOffset:int;
    	
    	private var mySourceViewOffset:int;
	    private var mySourceViewLength:int;
	    private var myTargetViewLength:int;
	    private var myNewDataLength:int;
	    private var myInstructionsLength:int;
    	
    	
    	public static var EMPTY:SVNDiffWindow = new SVNDiffWindow(0,0,0,0,0);
    	private var myTemplateInstruction:SVNDiffInstruction = new SVNDiffInstruction(0,0,0);
    	private var myTemplateNextInstruction:SVNDiffInstruction = new SVNDiffInstruction(0,0,0);
    	
    	 public function SVNDiffWindow( sourceViewOffset:int,  sourceViewLength:int,  targetViewLength:int,  instructionsLength:int,  newDataLength:int) 
    	 {
	        mySourceViewOffset = sourceViewOffset;
	        mySourceViewLength = sourceViewLength;
	        myTargetViewLength = targetViewLength;
	        myInstructionsLength = instructionsLength;
	        myNewDataLength = newDataLength;
		}

		public function getInstructionsLength():int 
		{
			return myInstructionsLength;
		}

		public function getSourceViewOffset():int 
		{
			return mySourceViewOffset;
		}

		public function getSourceViewLength():int 
		{
			return mySourceViewLength;
		}

		public function getTargetViewLength():int 
		{
			return myTargetViewLength;
		}

		public function getNewDataLength():int 
		{
			return myNewDataLength;
		}

		public function hasInstructions():Boolean 
		{
			return myInstructionsLength > 0;
		}

		public function setData( buffer:ByteArray ):void 
		{
        	myData = buffer;
        	myDataOffset = buffer.position;
    	}
		
		private function createByteArray( len:int ):ByteArray
		{
			var ba:ByteArray = new ByteArray();
			
			for( var i:int = 0; i<len; i++ )
			{
				ba.writeByte( 0 );	
			}
			
			return( ba );
		}
		
		public function apply( applyBaton:SVNDiffWindowApplyBaton):void 
		{
			// here we have streams and buffer from the previous calls (or nulls).
        
			// 1. buffer for target.
			if (applyBaton.myTargetBuffer == null || applyBaton.myTargetViewSize < getTargetViewLength( )) 
			{
				applyBaton.myTargetBuffer = createByteArray( getTargetViewLength( ) );
			}
			applyBaton.myTargetViewSize = getTargetViewLength( );
        
			// 2. buffer for source.
			var length:int = 0;
			if (getSourceViewOffset( ) != applyBaton.mySourceViewOffset || getSourceViewLength( ) > applyBaton.mySourceViewLength) 
			{
				var oldSourceBuffer:ByteArray = applyBaton.mySourceBuffer;
				// create a new buffer
				applyBaton.mySourceBuffer = new ByteArray( );
				// copy from the old buffer.
				if (applyBaton.mySourceViewOffset + applyBaton.mySourceViewLength > getSourceViewOffset( )) 
				{
					// copy overlapping part to the new buffer
					var start:int = int( getSourceViewOffset( ) - applyBaton.mySourceViewOffset );
					
					oldSourceBuffer.position = start;
					oldSourceBuffer.readBytes(applyBaton.mySourceBuffer, 0, (applyBaton.mySourceViewLength - start) );
					length = (applyBaton.mySourceViewLength - start);
				}            
			}
			if (length < getSourceViewLength( )) 
			{

				var toSkip:int = int( getSourceViewOffset( ) - (applyBaton.mySourceViewOffset + applyBaton.mySourceViewLength) );
				if (toSkip > 0) 
				{
					applyBaton.mySourceStream.position += toSkip;
				}
            
				applyBaton.mySourceStream.readBytes( applyBaton.mySourceBuffer, length, applyBaton.mySourceBuffer.length - length );
			}
			// update offsets in baton.
			applyBaton.mySourceViewLength = getSourceViewLength( );
			applyBaton.mySourceViewOffset = getSourceViewOffset( );
			
			
			var tpos:int = 0;
        	var npos:int = myInstructionsLength;
        	
        	var ii:InstructionsIterator = new InstructionsIterator(true, myInstructionsLength, myDataOffset, myData );
        	
        	for( var instructions:InstructionsIterator = ii; instructions.hasNext(); ) 
        	{
        	

        		var instruction:SVNDiffInstruction = instructions.next() as SVNDiffInstruction;
                var iLength:int = instruction.length < getTargetViewLength() - tpos ? instruction.length : getTargetViewLength() - tpos; 
                switch (instruction.type) 
                {
                    case SVNDiffInstruction.COPY_FROM_NEW_DATA:

                        arraycopy(myData, myDataOffset + npos, applyBaton.myTargetBuffer, tpos, iLength);
                        npos += iLength;
                        break;
                    case SVNDiffInstruction.COPY_FROM_TARGET:
                        var istart:int = instruction.offset;
                        var end:int = instruction.offset + iLength;
                        var tIndex:int = tpos;
                        for(var j:int = istart; j < end; j++) {
                            applyBaton.myTargetBuffer[tIndex] = applyBaton.myTargetBuffer[j];
                            tIndex++;
                        }
                        break;
                    case SVNDiffInstruction.COPY_FROM_SOURCE:
                        arraycopy(applyBaton.mySourceBuffer, instruction.offset, applyBaton.myTargetBuffer, tpos, iLength);
                        break;
                    default:
                }
                
                tpos += instruction.length;
                if (tpos >= getTargetViewLength()) {
                    break;
                }
        	}
        	
        	if (applyBaton.myDigest != null) 
        	{
                applyBaton.myDigest.writeBytes(applyBaton.myTargetBuffer, 0, getTargetViewLength());
            }
            
            applyBaton.myTargetBuffer.position = 0;
				trace( applyBaton.myTargetBuffer.readUTFBytes(applyBaton.myTargetBuffer.bytesAvailable) );
            
            applyBaton.myTargetStream.writeBytes(applyBaton.myTargetBuffer, 0, getTargetViewLength());
		}
		
		private function arraycopy( src:ByteArray, srcPos:int, dest:ByteArray, destpos:int, len:int ):void
		{
			for( var i:int = srcPos; i<srcPos + len; i++, destpos++ )
			{
				var b:int = src[ i ];
				dest[ destpos ] = b;	
			}
		}
	}
}

	import com.fuelindustries.svn.core.io.diff.SVNDiffInstruction;
	import flash.utils.ByteArray;

	internal class InstructionsIterator 
	{
        
        private var myNextInsruction:SVNDiffInstruction;
        private var myOffset:int;
        private var myNewDataOffset:int;
        private var myIsTemplate:Boolean;
        private var myTemplateNextInstruction:SVNDiffInstruction = new SVNDiffInstruction(0,0,0);
        private var myTemplateInstruction:SVNDiffInstruction = new SVNDiffInstruction(0,0,0);
        private var myInstructionsLength:int;
        private var myData:ByteArray;
        private var myDataOffset:int;
        
        public function InstructionsIterator( useTemplate:Boolean, instructionLength:int, dataOffset:int, data:ByteArray ) 
        {
            myIsTemplate = useTemplate;
            myInstructionsLength = instructionLength;
            myData = data;
            myDataOffset = dataOffset;
            myNextInsruction = readNextInstruction();
            
        }

        public function hasNext():Boolean {
            return myNextInsruction != null;
        }

        public function next():Object {
            if (myNextInsruction == null) {
                return null;
            }
        
            if (myIsTemplate) {
                myTemplateNextInstruction.type = myNextInsruction.type;
                myTemplateNextInstruction.length = myNextInsruction.length;
                myTemplateNextInstruction.offset = myNextInsruction.offset;
                myNextInsruction = readNextInstruction();
                return myTemplateNextInstruction;
            } 
            var next:Object = myNextInsruction;
            myNextInsruction = readNextInstruction();
            return next;
        }

        public function remove():void {
        }
        
        private function readNextInstruction():SVNDiffInstruction {
            if (myData == null || myOffset >= myInstructionsLength) {
                return null;
            }
            var instruction:SVNDiffInstruction = myIsTemplate ? myTemplateInstruction : new SVNDiffInstruction();

            var byte:int = myData[myDataOffset + myOffset];
            
            instruction.type = (byte & 0xC0) >> 6;
            instruction.length = byte & 0x3f;
            myOffset++;
            if (instruction.length == 0) 
            {
                // read length from next byte                
                instruction.length = readInt();
            }
            
            if (instruction.type == 0 || instruction.type == 1) 
            {
                // read offset from next byte (no offset without length).
                instruction.offset = readInt();
            } 
            else 
            { 
                // set offset to offset in newdata.
                instruction.offset = myNewDataOffset;
                myNewDataOffset += instruction.length;
            }
            return instruction;
        }
        
        private function readInt():int {
            var result:int = 0;
            while(true) 
            {
                var b:int = myData[myDataOffset + myOffset];
                result = result << 7;
                result = result | (b & 0x7f);
                if ((b & 0x80) != 0) {
                    myOffset++;
                    if (myOffset >= myInstructionsLength) {
                        return -1;
                    }
                    continue;
                }
                myOffset++;
                return result;
            }
            
            return result;
        }
    }
	
