package com.fuelindustries.svn.events 
{
	import flash.events.Event;

	/**
	 * @author julian
	 */
	public class SVNCommandCompleteEvent extends Event 
	{
		
		private var __event:Event;
		
		public function get event():Event
		{
			return( __event );	
		}
		
		public function SVNCommandCompleteEvent( type:String, e:Event )
		{
			super( type, false, false );
			__event = e;
		}
	}
}
