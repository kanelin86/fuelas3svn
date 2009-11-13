package com.fuelindustries.svn.core 
{

	/**
	 * @author julian
	 */
	public interface ISVNLogEntryHandler 
	{
		function handleLogEntry( logEntry:SVNLogEntry ):void
	}
}
