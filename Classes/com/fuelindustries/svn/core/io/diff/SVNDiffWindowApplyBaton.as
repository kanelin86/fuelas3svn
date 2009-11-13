package com.fuelindustries.svn.core.io.diff 
{
	import com.fuelindustries.svn.core.util.SVNFileUtil;

	import flash.utils.ByteArray;

	/**
	 * @author julian
	 */
	public class SVNDiffWindowApplyBaton 
	{
		
		public var mySourceStream:ByteArray;
    	public var myTargetStream:ByteArray;

	    public var mySourceViewOffset:int;
	    public var mySourceViewLength:int;
	    public var myTargetViewSize:int;

    	public var mySourceBuffer:ByteArray;
    	public var myTargetBuffer:ByteArray;
    	
    	public var myDigest:ByteArray;
		
		 public static function create( source:ByteArray,  target:ByteArray,  digest:ByteArray ):SVNDiffWindowApplyBaton 
		 {
	        var baton:SVNDiffWindowApplyBaton = new SVNDiffWindowApplyBaton();
	        baton.mySourceStream = source;
	        baton.myTargetStream = target;
	        baton.mySourceBuffer = new ByteArray();
	        baton.mySourceViewLength = 0;
	        baton.mySourceViewOffset = 0;
	        baton.myDigest = digest;
	        return baton;
	    }
	    
	    public function SVNDiffWindowApplyBaton()
	    {
	    }

		public function close():String 
		{
			if (myDigest != null) 
			{
				return SVNFileUtil.toHexDigest( myDigest );
			}
			return null;
		}
	}
}
