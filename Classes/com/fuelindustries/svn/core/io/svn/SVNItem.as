package com.fuelindustries.svn.core.io.svn 
{
	import flash.utils.ByteArray;

	/**
	 * @author julian
	 */
	public class SVNItem 
	{
		public static var WORD:int = 0;
		public static var BYTES:int = 1;
		public static var LIST:int = 2;
		public static var NUMBER:int = 3;
		private var myKind:int;
		private var myNumber:Number = -1;
		private var myWord:String;  // success
		private var myLine:ByteArray; // 3:abc
		private var myItems:Array;

		public function getKind():int 
		{
			return myKind;
		}

		public function setKind( kind:int ):void 
		{
			myKind = kind;
		}

		public function getNumber():Number 
		{
			return myNumber;
		}

		public function setNumber( number:Number ):void 
		{
			myNumber = number;
		}

		public function getWord():String 
		{
			return myWord;
		}

		public function setWord( word:String ):void 
		{
			myWord = word;
		}

		public function getBytes():ByteArray 
		{
			return myLine;
		}

		public function setLine( line:ByteArray ):void 
		{
			myLine = line;
		}

		public function getItems():Array 
		{
			return myItems;
		}

		public function setItems( items:Array ):void 
		{
			myItems = items;
		}

		public function toString():String 
		{
			var result:String = "";
			if (myKind == WORD) 
			{
				result += "W" + myWord;
			} 
        	else if (myKind == BYTES) 
			{
				result += "S" + myLine.length + ":";
				myLine.position = 0;
				result += myLine.readUTFBytes( myLine.bytesAvailable );
				result += " ";
			} 
        	else if (myKind == NUMBER) 
			{
				result += "N" + myNumber;
			} 
        	else if (myKind == LIST) 
			{
				result += "L(";
            
				for( var i:int = 0; i < myItems.length ; i++ )
				{
					var item:SVNItem = myItems[ i ] as SVNItem;
					result += item.toString( );
					result += " ";	
				}
           
				result += ") ";
			}
			return result.toString( );
		}

		public function equals( o:Object ):Boolean 
		{
			if( compare( this, o ) ) 
			{
				return true;
			}
        
			if (o is String) 
			{
				if (myKind == WORD) 
				{
					return myWord == o;
				} 
            	else if (myKind == BYTES) 
				{
					return myLine == o;
				}
				return false;
			} 
        	else if (o is ByteArray ) 
			{
				if (myKind == WORD) 
				{
					var ba:ByteArray = new ByteArray( );
					ba.writeUTFBytes( myWord );
					ba.position = 0;
                
					return compare( ba, o );
				} 
            	else if (myKind == BYTES) 
				{
					return compare( myLine, o );
				}
				return false;
			} 
        	else if( o is Number ) 
			{
				var value:Number = Number( o );
				return myKind == NUMBER && myNumber == value;
			} 
        	else if (o is int) 
			{
				var v:Number = Number( o as int );
				return myKind == NUMBER && myNumber == v;
			} 
        	else if (o is Array ) 
			{
				return myKind == LIST && compare( myItems, o );
			}
			
			return false;
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
