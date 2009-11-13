package com.fuelindustries.svn.events 
{
	import com.fuelindustries.svn.core.io.SVNCommand;

	/**
	 * @author julian
	 */
	public class ReparentEvent extends SVNCommandEvent 
	{
		
		public static const REPARENT:String = "reparent";
		
		private var __path:String;
		
		public function get path():String
		{
			return( __path );	
		}
		
		public function ReparentEvent(type:String, path:String, command:SVNCommand)
		{
			__path = path;
			super( type, command );
		}
	}
}
