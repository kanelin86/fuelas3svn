package com.fuelindustries.svn.core.io.commands 
{
	import com.fuelindustries.svn.core.io.SVNCommand;
	import com.fuelindustries.svn.events.ReparentEvent;

	import flash.utils.ByteArray;

	/**
	 * @author julian
	 */
	public class ReparentCommand extends SVNCommand 
	{
		private var __path:String;
		
		public function ReparentCommand(template:String = null, items:Array = null)
		{
			__path = items[ 1 ] as String;
			super( template, items );
		}

		override public function parseCommand(ba:ByteArray):void
		{
			super.parseCommand( ba );
			__event = new ReparentEvent( ReparentEvent.REPARENT, __path, this );
			commandComplete();
		}
	}
}
