package com.fuelindustries.svn.events 
{
	import com.fuelindustries.svn.core.SVNProperties;
	import com.fuelindustries.svn.core.io.SVNCommand;

	/**
	 * @author julian
	 */
	public class GetRevisionPropertiesEvent extends SVNCommandEvent 
	{
		public static const GET_REVISION_PROPERTIES:String = "rev-proplist";
		
		private var __properties:SVNProperties;
		
		public function get properties():SVNProperties
		{
			return( __properties );	
		}
		
		public function GetRevisionPropertiesEvent(type:String, properties:SVNProperties, command:SVNCommand)
		{
			__properties = properties;
			super( type, command );
		}
	}
}
