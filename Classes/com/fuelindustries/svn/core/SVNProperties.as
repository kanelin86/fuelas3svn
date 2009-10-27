package com.fuelindustries.svn.core 
{
	import flash.utils.Dictionary;

	/**
	 * @author julian
	 */
	public class SVNProperties 
	{
		private var myProperties:Dictionary;
		private var __size:int;

		
		public function SVNProperties()
		{
			myProperties = new Dictionary();
			__size = 0;
		}
		
		public function put( prop:String, value:Object ):void
		{
			__size++;
			myProperties[ prop ] = value;	
		}

		public function size():int
		{
			return( __size );	
		}
		
		public function items():Dictionary
		{
			return( myProperties );	
		}
	}
}
