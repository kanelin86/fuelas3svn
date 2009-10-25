package com.fuelindustries.svn.core.io.commands 
{
	import com.fuelindustries.svn.core.io.SVNCommand;
	import com.fuelindustries.svn.events.StatEvent;

	import flash.utils.ByteArray;

	/**
	 * @author julian
	 */
	public class StatCommand extends SVNCommand 
	{
		
		private var __stats:Array;
		
		public function get stats():Array
		{
			return( __stats );	
		}
		
		public function get revision():int
		{
			return( __items[ 2 ] as int );
		}
		
		public function StatCommand(template:String, items:Array)
		{
			super( template, items );
		}

		override public function parseCommand(ba:ByteArray):void
		{
			var values:Array = parse(ba, "(?l)", null);
			__stats = values[ 0 ] as Array;

			__event = new StatEvent( StatEvent.STAT, __stats, this );			
			commandComplete();
		}
	}
}
