package com.fuelindustries.svn.core.io.svn 
{

	/**
	 * @author julian
	 */
	public interface ISVNConnector 
	{
		function open( repository:SVNRepositoryImpl ):void

		function isConnected( repository:SVNRepositoryImpl ):Boolean

		function close( repository:SVNRepositoryImpl ):void
	}
}
