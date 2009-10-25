package com.fuelindustries.svn.events 
{
	import flash.events.Event;

	/**
	 * @author julian
	 */
	public class SVNEvent extends Event 
	{
		
		public static const AUTHENTICATED:String = "svnauthenticated";
		
		public function SVNEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super( type, bubbles, cancelable );
		}
	}
}
