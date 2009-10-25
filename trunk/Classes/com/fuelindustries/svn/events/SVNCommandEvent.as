package com.fuelindustries.svn.events 
{
	import com.fuelindustries.svn.core.io.SVNCommand;

	import flash.events.Event;

	/**
	 * @author julian
	 */
	public class SVNCommandEvent extends Event 
	{
		private var __command:SVNCommand;
		
		public function get command():SVNCommand
		{
			return( __command );	
		}
		
		
		public function SVNCommandEvent( type:String, command:SVNCommand )
		{
			super( type, false, false );
			__command = command;
		}
		
		//TODO implement clone and to string methods.
	}
}
