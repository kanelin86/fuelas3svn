package com.fuelindustries.svn.core.io.diff 
{
	import flash.utils.ByteArray;

	/**
	 * @author julian
	 */
	public class SVNDiffInstruction 
	{
		public var type:int; 
		public var length:int;
		public var offset:int;
		
		public static var COPY_FROM_SOURCE:int = 0x00;
		public static var COPY_FROM_TARGET:int = 0x01;
		public static var COPY_FROM_NEW_DATA:int = 0x02;

		public function SVNDiffInstruction( t:int = 0,  l:int = 0,  o:int = 0) 
		{
			type = t;
			length = l;
			offset = o;        
		}

		public function toString():String 
		{
			var b:String = "";
			switch(type) 
			{
				case COPY_FROM_SOURCE:
					b += "S->";
					break;
				case COPY_FROM_TARGET:
					b += "T->";
					break;
				case COPY_FROM_NEW_DATA:
					b += "D->";
					break;
			}
			if (type == 0 || type == 1) 
			{
				b += offset;
			} 
			else 
			{
				b += offset;
			}
			b += ":";
			b += length;
			return b;
		}

		public function writeTo( target:ByteArray ):void 
		{
			var first:int = ( type << 6 );
			if (length <= 0x3f && length > 0) 
			{
				// single-byte lenght;
				first |= (length & 0x3f);
				target.writeByte( ( first & 0xff ) );
			} 
			else 
			{
				target.writeByte( ( first & 0xff ) );
				writeInt( target, length );
			}
			if (type == 0 || type == 1) 
			{
				writeInt( target, offset );
			}
		}

		public static function writeInt( os:ByteArray,  i:int ):void 
		{	
			if (i == 0) 
			{
				os.writeByte( 0 );
				return;
			}
			var count:int = 1;
			var v:int = i >> 7;
			while(v > 0) 
			{
				v = v >> 7;
				count++;
			}
			var b:int;
			var r:int;
			while(--count >= 0) 
			{
				b = int( (count > 0 ? 0x1 : 0x0) << 7 );
				r = (int( (i >> (7 * count)) & 0x7f )) | b;
				os.writeByte( r );
			}
		}

		public static function writeLong(os:ByteArray,  i:int ):void 
		{
			if (i == 0) 
			{
				os.writeByte( 0 );
				return;
			}
			// how many bytes there are:
			var count:int = 1;
			var v:int = i >> 7;
			while(v > 0) 
			{
				v = v >> 7;
				count++;
			}
			var b:int;
			var r:
			int;
			while(--count >= 0) 
			{
				b = int( (count > 0 ? 0x1 : 0x0) << 7 );
				r = (int( (i >> (7 * count)) & 0x7f )) | b;
				os.writeByte( r );
			}
		}
	}
}
