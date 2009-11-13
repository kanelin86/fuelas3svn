package com.fuelindustries.svn.core.io 
{
	import com.fuelindustries.svn.core.io.diff.SVNDiffWindow;

	import flash.utils.ByteArray;

	/**
	 * @author julian
	 */
	public interface ISVNDeltaConsumer 
	{
		function applyTextDelta( path:String,  baseChecksum:String ):void
		function textDeltaEnd( path:String):void
		function textDeltaChunk( path:String,  diffWindow:SVNDiffWindow):ByteArray
	}
}
