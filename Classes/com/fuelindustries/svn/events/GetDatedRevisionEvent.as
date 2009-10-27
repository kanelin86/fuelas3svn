package com.fuelindustries.svn.events 
{
	import com.fuelindustries.svn.core.io.SVNCommand;

	/**
	 * @author julian
	 */
	public class GetDatedRevisionEvent extends SVNCommandEvent 
	{
		public static var DATED_REVISION:String = "get-dated-rev";

		private var __revision:int;
		
		public function get datedRevision():int
		{
			return __revision;
		}
		public function GetDatedRevisionEvent(type:String, revision:int, command:SVNCommand)
		{
			__revision = revision;
			super( type, command );
		}
	}
}
