package com.fuelindustries.svn.core 
{
	import flash.utils.ByteArray;
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
			
			if( value is SVNPropertyValue )
			{
				myProperties[ prop ] = value;	
			}
			else
			{
				myProperties[ prop ] = new SVNPropertyValue( value as String );	
			}		
		}

		public function size():int
		{
			return( __size );	
		}
		
		public function items():Dictionary
		{
			return( myProperties );	
		}

		public function nameSet():Array 
		{
			var arr:Array = [];
			
			for( var key:String in myProperties )
			{
				arr.push( key );
			}
			
			return( arr );
		}

		public function getSVNPropertyValue( propertyName:String ):SVNPropertyValue 
		{
			return myProperties[ propertyName ] as SVNPropertyValue;        
		}

		public function getStringValue( propertyName:String ):String 
		{
			var value:SVNPropertyValue = myProperties[ propertyName ] as SVNPropertyValue;
			return value == null ? null : value.getString( );
		}

		public function equals( obj:Object ):Boolean 
		{
			if (this == obj) 
			{
				return true;
			}
			
			if (obj == null) 
			{
				return false;
			}
			
			if (!(obj is SVNProperties )) 
			{
				return false;
			}
			
			var other:SVNProperties = obj as SVNProperties;
			
			if (myProperties == null) 
			{
				if (other.myProperties != null) 
				{
					return false;
				}
			} 
			else if (!compare( myProperties, other.myProperties )) 
			{
				return false;
			}
			return true;
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
