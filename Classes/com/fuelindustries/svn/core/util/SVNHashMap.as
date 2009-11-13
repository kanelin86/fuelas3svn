package com.fuelindustries.svn.core.util 
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 * @author julian
	 */
	public class SVNHashMap 
	{
		
		private var __items:Dictionary;
		
		
		public function SVNHashMap()
		{
			__items = new Dictionary();
		}
		
		public function put( key:String, value:Object ):void
		{
			__items[ key ] = value;	
		}
		
		public function getValue( key:String ):Object
		{
			return( __items[ key ] );	
		}
		
		public function remove( key:String ):void
		{
			__items[ key ] = null;	
		}
		
		public function isEmpty():Boolean
		{
			var val:Boolean = true;
			
			for( var key:String in __items )
			{
				return( true );	
			}
			
			return( val );	
		}
		
		public function size():int
		{
			var total:int = 0;
			
			for( var key:String in __items )
			{
				total++;
			}
			
			return total;	
		}
		
		public function values():Array
		{
			var arr:Array = [];
			
			for( var key:String in __items )
			{
				arr.push( __items[ key ] );
			}
			
			return( arr );
		}
		
		public function items():Dictionary
		{
			return( __items );	
		}

		public function equals( o:Object ):Boolean 
		{
			if (o == this) 
			{
				return true;
			}
			if (!(o is SVNHashMap)) 
			{
				return false;
			}
			var t:SVNHashMap = o as SVNHashMap;
			if (t.size( ) != size( )) 
			{
				return false;
			}
			
			return( compare( t, this ) );
		}
		
		public function compare(obj1:Object, obj2:Object):Boolean 
		{
		
			var b1:ByteArray = new ByteArray( );
			var b2:ByteArray = new ByteArray( );

			b1.writeObject( obj1 );
			b2.writeObject( obj2 );

			// compare the lengths first
			var size:uint = b1.length;
			
			if (b1.length == b2.length) 
			{
				
				b1.position = 0;
				b2.position = 0;
				
				while (b1.position < size) 
				{
					var v1:int = b1.readByte( );
					
					if (v1 != b2.readByte( )) 
					{
						return false;
					}
				}                            
			}
       
	
			if (b1.toString( ) == b2.toString( )) 
			{
				return true;
			}              

			return false;
		}
	}
}
