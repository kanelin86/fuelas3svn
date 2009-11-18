package com.fuelindustries.svn.core.errors 
{

	/**
	 * @author julian
	 */
	public class SVNCancelException extends SVNException 
	{
		public function SVNCancelException( errorMessage:SVNErrorMessage )
		{
			if( errorMessage == null )
			{
				errorMessage = SVNErrorMessage.create(SVNErrorCode.CANCELLED, "Operation cancelled");	
			}
			
			super( errorMessage );
		}
	}
}
