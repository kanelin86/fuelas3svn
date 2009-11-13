package com.fuelindustries.svn.core 
{
	import flash.utils.ByteArray;

	/**
	 * @author julian
	 */
	public class SVNPropertyValue 
	{
		private var myValue:String;
		private var myData:ByteArray;

		public static function create( propertyName:String, data:ByteArray ):SVNPropertyValue 
		{
			if (data == null) 
			{
				return null;
			}
			return createWithOffset( propertyName, data, 0, data.length );
		}

		public static function createWithOffset( propertyName:String, data:ByteArray, offset:int, length:int ):SVNPropertyValue
		{
			if (data == null) 
			{
				return null;
			}
			if (SVNProperty.isSVNProperty( propertyName )) 
			{
				data.position = offset;
				var value:String = data.readUTFBytes( length );
           
				return new SVNPropertyValue( value );
			}
			return new SVNPropertyValue( null, data, offset, length );
		}

		public static function getPropertyAsBytes( value:SVNPropertyValue ):ByteArray
		{
			if (value == null) 
			{
				return null;
			}
        
			if (value.isString( )) 
			{
				var bytes:ByteArray = new ByteArray( );
				bytes.writeUTFBytes( value.getString( ) );
				bytes.position = 0;
				return( bytes );
			}
			
			return value.getBytes();
		}
		
		public static function getPropertyAsString( value:SVNPropertyValue ):String
		{
			if( value == null ) return null;
			
			if( value.isBinary() )
			{
				var ba:ByteArray = value.getBytes();
				ba.position = 0;
				var str:String = ba.readUTFBytes( ba.bytesAvailable );
				return( str );
			}
			
			return( value.getString() );
		}

		public function SVNPropertyValue( propertyName:String = null, data:ByteArray = null, offset:int = 0, length:int = 0 )
		{
			if( propertyName != null )
			{
				myValue = propertyName;	
			}
    	
			if( data != null )
			{
				myData = new ByteArray( );
				data.writeBytes( myData, offset, length );	
			}
		}

		public function isBinary():Boolean 
		{
			return myData != null;
		}

		public function getBytes():ByteArray 
		{
			return myData;
		}

		public function isString():Boolean 
		{
			return myValue != null;
		}

		public function getString():String 
		{
			return myValue;
		}

		public function toString():String 
		{
			if (isBinary( )) 
			{
				return "property is binary";
			}
			return getString( );
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

			if (obj is SVNPropertyValue) 
			{
				var value:SVNPropertyValue = obj as SVNPropertyValue;
				if (isString( )) 
				{
					return myValue == value.getString( );
				} 
            else if (isBinary( )) 
				{
					var b2:ByteArray = getPropertyAsBytes( value );
					var size:uint = myData.length;
			
					if (myData.length == b2.length) 
					{
				
						myData.position = 0;
						b2.position = 0;
				
						while (myData.position < size) 
						{
							var v1:int = myData.readByte( );
					
							if (v1 != b2.readByte( )) 
							{
								return false;
							}
						}                            
					}
       
	
					if (myData.toString( ) == b2.toString( )) 
					{
						return true;
					}              

					return false;
				}
			}
			return false;
		}

		public function hashCode():int 
		{
			if (myValue != null) 
			{
				return( stringHashCode( myValue ) );
			}
        
			if (myData != null) 
			{
				myData.position = 0;
				var str:String = myData.readUTFBytes( myData.bytesAvailable );
            
				return( stringHashCode( str ) );
			}
        
			return 0;
		}

		private function stringHashCode( key:String ):int
		{
			var h:int = 0;
	
			var offset:int = 0;
			var off:int = offset;
			var len:int = key.length;
	
			for (var i:int = 0; i < len; i++) 
			{
				h = 31 * h + key.charCodeAt( off++ );
			}
			return h;
		}
	}
}
