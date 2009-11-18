package com.fuelindustries.svn.core.errors 
{

	/**
	 * @author julian
	 */
	public class SVNException extends Error 
	{
		private var myErrorMessage:SVNErrorMessage;

		public function SVNException( errorMessage:SVNErrorMessage ) 
		{
			myErrorMessage = errorMessage;
			super( getMessage(), errorMessage.getErrorCode() );
		}

		public function getErrorMessage():SVNErrorMessage 
		{
			return myErrorMessage;
		}

		public function getMessage():String 
		{
			var error:SVNErrorMessage = getErrorMessage( );
			if (error != null) 
			{
				return error.getFullMessage( );
			}
			return message;
		}
	}
}
