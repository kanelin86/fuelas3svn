package com.fuelindustries.svn.core.errors 
{

	/**
	 * @author julian
	 */
	public class SVNAuthenticationException extends SVNException 
	{
		public function SVNAuthenticationException(errorMessage:SVNErrorMessage)
		{
			super( errorMessage );
		}
	}
}
