package com.fuelindustries.svn.core.io.commands 
{
	import com.fuelindustries.svn.core.io.SVNCommand;
	import com.fuelindustries.svn.core.io.svn.SVNReader;
	import com.fuelindustries.svn.events.GetDatedRevisionEvent;

	import flash.utils.ByteArray;

	/**
	 * @author julian
	 */
	public class GetDatedRevisionCommand extends SVNCommand 
	{
		public function GetDatedRevisionCommand(template:String = null, items:Array = null)
		{
			super( template, items );
		}
		
		override public function parseCommand( ba:ByteArray ):void
		{
			var values:Array = parse(ba, "r", null);
			var revision:int = SVNReader.getLong(values, 0);
			
			__event = new GetDatedRevisionEvent( GetDatedRevisionEvent.DATED_REVISION, revision, this );
			commandComplete();

		}
		
	}
}
