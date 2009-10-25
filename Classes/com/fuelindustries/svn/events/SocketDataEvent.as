package com.fuelindustries.svn.events 
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	/**
	 * @author jdolce
	 */
	public class SocketDataEvent extends Event 
	{
		
		public static var DATA:String = "onsocketdata";
		
		private var __data:ByteArray;
		
		public function get data():ByteArray
		{
			return( __data );	
		}
		
		public function SocketDataEvent( type:String, data:ByteArray ):void
		{
			super( type, false, false );
			__data = data;	
		}
		
		override public function clone():Event
		{
			return( new SocketDataEvent( type, __data ) );	
		}
				
	}
}
