package com.fuelindustries.svn.events 
{
	import com.fuelindustries.svn.core.io.SVNCommand;

	/**
	 * @author julian
	 */
	public class UpdateCommandEvent extends SVNCommandEvent 
	{
		public static const UPDATE:String = "update";
		
		public function UpdateCommandEvent(type:String, command:SVNCommand)
		{
			super( type, command );
		}
	}
}
