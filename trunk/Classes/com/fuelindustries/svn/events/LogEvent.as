package com.fuelindustries.svn.events 
{
	import com.fuelindustries.svn.core.io.SVNCommand;

	/**
	 * @author julian
	 */
	public class LogEvent extends SVNCommandEvent 
	{
		public static const LOG:String = "log";
		
		public function LogEvent(type:String, command:SVNCommand)
		{
			super( type, command );
		}
	}
}
