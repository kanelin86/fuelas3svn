package com.fuelindustries.svn.events 
{
	import com.fuelindustries.svn.core.io.SVNCommand;

	/**
	 * @author julian
	 */
	public class StatEvent extends SVNCommandEvent 
	{
		public static const STAT:String = "stat";
		
		private var __stats:Array;
		
		public function get stats():Array
		{
			return( __stats );	
		}
		
		public function StatEvent(type:String, stats:Array, command:SVNCommand )
		{
			super( type, command );
			__stats = stats;
		}
	}
}
