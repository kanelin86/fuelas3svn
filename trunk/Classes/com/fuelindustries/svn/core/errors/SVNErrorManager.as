package com.fuelindustries.svn.core.errors 
{
	import com.fuelindustries.svn.core.util.SVNLogType;

	/**
	 * @author julian
	 */
	public class SVNErrorManager 
	{
		public static function error( err:SVNErrorMessage,  logType:SVNLogType):void
		{
			if (err == null) 
			{
				err = SVNErrorMessage.create( SVNErrorCode.UNKNOWN );
			}
			
			if (err.getErrorCode( ) == SVNErrorCode.CANCELLED) 
			{
				throw new SVNCancelException( err );
			} 
			else if (err.getErrorCode( ).isAuthentication( )) 
			{
				throw new SVNAuthenticationException( err );
			} 
			else 
			{
				throw new SVNException( err );
			}
		}
	}
}
