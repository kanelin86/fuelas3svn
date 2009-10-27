package com.fuelindustries.svn.core.io.commands 
{
	import com.fuelindustries.svn.events.GetRevisionPropertiesEvent;
	import com.fuelindustries.svn.core.SVNProperties;
	import com.fuelindustries.svn.core.io.SVNCommand;
	import com.fuelindustries.svn.core.io.svn.SVNReader;

	import flash.utils.ByteArray;

	/**
	 * @author julian
	 */
	public class GetRevisionPropertiesCommand extends SVNCommand 
	{
		
		
		public function GetRevisionPropertiesCommand(template:String = null, items:Array = null)
		{
			super( template, items );
		}

		override public function parseCommand(ba:ByteArray):void
		{
			super.parseCommand( ba );
			var items:Array = parse( ba, "l", null );
            var properties:SVNProperties = SVNReader.getProperties(items, 0, null);
           
           __event = new GetRevisionPropertiesEvent( GetRevisionPropertiesEvent.GET_REVISION_PROPERTIES, properties, this );
           commandComplete();
		}
	}
}
