package com.fuelindustries.svn.events 
{
	import com.fuelindustries.svn.core.io.SVNCommand;

	/**
	 * @author julian
	 */
	public class GetDirEvent extends SVNCommandEvent 
	{
		public static const GET_DIR:String = "get-dir";
		
		private var __entries:Array;
		
		public function get entries():Array
		{
			return( __entries );	
		}
		
		
		public function GetDirEvent(type:String, entries:Array, command:SVNCommand )
		{
			__entries = entries;
			super( type, command );
		}
	}
}
