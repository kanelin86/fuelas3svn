package com.fuelindustries.svn.core.io.diff 
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	/**
	 * @author julian
	 */
	public class SVNDeltaProcessor 
	{
		private var myApplyBaton:SVNDiffWindowApplyBaton;
		 
		public function SVNDeltaProcessor() 
		{
    	}
    	
    	public function applyTextDelta( base:ByteArray,  target:ByteArray,  computeCheksum:Boolean):void
    	{
	        reset();
	        var digest:ByteArray = computeCheksum ? new ByteArray() : null;
	        base = base == null ? new ByteArray() : base;
	        myApplyBaton = SVNDiffWindowApplyBaton.create(base, target, digest);
		}

		public function textDeltaChunk( window:SVNDiffWindow ):ByteArray 
		{
			window.apply( myApplyBaton );
			
			//myApplyBaton.myTargetStream.position = 0;
			//trace( myApplyBaton.myTargetStream.readUTFBytes(myApplyBaton.myTargetStream.bytesAvailable) );
			
			
			//writeFile( "myTargetBuffer.as", myApplyBaton.myTargetBuffer );
			//writeFile( "myTargetStream.as", myApplyBaton.myTargetStream );
			
			myApplyBaton.myTargetStream.position = 0;
			return myApplyBaton.myTargetBuffer;
		}
		
		private function writeFile( name:String, contents:ByteArray ):void
		{
			contents.position = 0;
			var f:File = new File( "/Users/julian/Work/Projects/Fuel Internal Projects/SVNBrowser/trunk/exports/" + name );
			var stream:FileStream = new FileStream();
			stream.open( f , FileMode.WRITE );
			stream.writeBytes( contents );
			stream.close();	
		}

		private function reset():void
		{
			if (myApplyBaton != null) 
			{
				myApplyBaton.close( );
				myApplyBaton = null;
			}
		}
	}
}
