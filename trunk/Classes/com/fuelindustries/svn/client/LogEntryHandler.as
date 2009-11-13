package com.fuelindustries.svn.client 
{
	import com.fuelindustries.svn.core.ISVNLogEntryHandler;
	import com.fuelindustries.svn.core.SVNLogEntry;

	/**
	 * @author julian
	 */
	public class LogEntryHandler implements ISVNLogEntryHandler 
	{
		public function handleLogEntry(logEntry:SVNLogEntry):void
		{
			trace( "log = " + logEntry.toString() );	
		}
	}
}
