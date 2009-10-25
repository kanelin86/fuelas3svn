package com.fuelindustries.svn.core.io.commands 
{
	import Array;
	import String;
	import com.fuelindustries.svn.core.io.SVNCommand;
	import com.fuelindustries.svn.core.io.svn.SVNReader;
	import com.fuelindustries.svn.events.LatestRevisionEvent;

	import flash.utils.ByteArray;

	/**
	 * @author julian
	 */
	public class LatestRevisionCommand extends SVNCommand 
	{
		public function LatestRevisionCommand( template:String, items:Array)
		{
			super( template, items );
		}
		
		override public function parseCommand( ba:ByteArray ):void
		{
			var values:Array = parse(ba, "r", null);
			var revision:int = SVNReader.getLong(values, 0);
			
			__event = new LatestRevisionEvent( LatestRevisionEvent.LATEST_REVISION, revision, this );
			commandComplete();

		}
	}
}
