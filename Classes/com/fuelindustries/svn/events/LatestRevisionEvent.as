package com.fuelindustries.svn.events 
{
	import com.fuelindustries.svn.core.io.SVNCommand;

	/**
	 * @author julian
	 */
	public class LatestRevisionEvent extends SVNCommandEvent 
	{
		
		public static var LATEST_REVISION:String = "latestrevisionevent";
		
		
		private var __revision:int;
		
		public function get latestRevision():int
		{
			return __revision;
		}
				
		
		public function LatestRevisionEvent( type:String, revision:int, command:SVNCommand  )
		{
			super( type, command );
			__revision = revision;
		}
		
		//TODO need to implement clone and to string methods
	}
}
