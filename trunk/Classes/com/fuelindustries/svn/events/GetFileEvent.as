package com.fuelindustries.svn.events 
{
	import com.fuelindustries.svn.core.io.SVNCommand;

	import flash.utils.ByteArray;

	/**
	 * @author julian
	 */
	public class GetFileEvent extends SVNCommandEvent 
	{
		public static const GET_FILE:String = "get-file";
		
		private var __contents:ByteArray;
		private var __path:String;
		
		public function get contents():ByteArray
		{
			return( __contents );
		}
		
		public function get path():String
		{
			return( __path );	
		}
		
		public function GetFileEvent(type:String, contents:ByteArray, path:String, command:SVNCommand )
		{
			__contents = contents;
			__path = path;
			super( type, command );
		}
	}
}
