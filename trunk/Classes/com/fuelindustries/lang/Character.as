package com.fuelindustries.lang 
{

	/**
	 * @author julian
	 */
	public class Character 
	{
		public static var MIN_RADIX:int = 2;
		public static var MAX_RADIX:int = 36;
		
		public static var UNASSIGNED:int = 0;
		public static var UPPERCASE_LETTER:int = 1;
		public static var LOWERCASE_LETTER:int = 2;
		public static var TITLECASE_LETTER:int = 3;
		public static var MODIFIER_LETTER:int = 4;
		public static var OTHER_LETTER:int = 5;
		public static var NON_SPACING_MARK:int = 6;
		public static var ENCLOSING_MARK:int = 7;
		public static var COMBINING_SPACING_MARK:int = 8;
		public static var DECIMAL_DIGIT_NUMBER:int = 9;
		public static var LETTER_NUMBER:int = 10;
		public static var OTHER_NUMBER:int = 11;
		public static var SPACE_SEPARATOR:int = 12;
		public static var LINE_SEPARATOR:int = 13;
		public static var PARAGRAPH_SEPARATOR:int = 14;
		public static var CONTROL:int = 15;
		public static var FORMAT:int = 16;
		public static var PRIVATE_USE:int = 18;
		public static var SURROGATE:int = 19;
		public static var DASH_PUNCTUATION:int = 20;
		public static var START_PUNCTUATION:int = 21;
		public static var  END_PUNCTUATION:int = 22;
		public static var  CONNECTOR_PUNCTUATION:int = 23;
		public static var OTHER_PUNCTUATION:int = 24;
		public static var MATH_SYMBOL:int = 25;
		public static var CURRENCY_SYMBOL:int = 26;
		public static var MODIFIER_SYMBOL:int = 27;
		public static var  OTHER_SYMBOL:int = 28;

		public static function isDigit( ch:String ):Boolean
		{
			return ( ch >= '0' && ch <= '9' );	
		}

		public static function toUpperCase( ch:String ):String
		{
			return( ch.toUpperCase( ) );	
		}

		public static function toLowerCase( ch:String ):String
		{
			return( ch.toLowerCase( ) );	
		}

		public static function forDigit( digit:int, radix:int ):String
		{
			if( (digit >= radix) || (digit < 0) ) 
			{
				return null;
			}
	        
			if( (radix < Character.MIN_RADIX) || (radix > Character.MAX_RADIX) ) 
			{
				return null;
			}
	        
			if(digit < 10) 
			{   
				var zero:Number = "0".charCodeAt( );
				return( String.fromCharCode( zero + 10 ) );
			}
	        
			return( String.fromCharCode( "a".charCodeAt( ) - 10 + digit ) );
		}

		public static function isWhitespace(character:String):Boolean
		{
			switch (character)
			{
				case " ":
				case "\t":
				case "\r":
				case "\n":
				case "\f":
					return true;
	       
				default:
					return false;
			}
		}
		
		public static function isLetter( ch:String ):Boolean 
		{
        	var type:int = getType(ch.charCodeAt());
        	return (((((1 << Character.UPPERCASE_LETTER) |
            (1 << Character.LOWERCASE_LETTER) |
            (1 << Character.TITLECASE_LETTER) |
            (1 << Character.MODIFIER_LETTER) |
            (1 << Character.OTHER_LETTER)) >> type) & 1) != 0);
		}
		
		public static function isLetterOrDigit( ch:String ):Boolean 
		{
        	var type:int = getType(ch.charCodeAt());
        	return (((((1 << Character.UPPERCASE_LETTER) |
	            (1 << Character.LOWERCASE_LETTER) |
	            (1 << Character.TITLECASE_LETTER) |
	            (1 << Character.MODIFIER_LETTER) |
	            (1 << Character.OTHER_LETTER) |
	            (1 << Character.DECIMAL_DIGIT_NUMBER)) >> type) & 1) != 0);
		}

		public static function digit( str:String, radix:int ):int 
		{
			var ch:int = str.charCodeAt( );
			var value:int = -1;
			if (radix >= Character.MIN_RADIX && radix <= Character.MAX_RADIX) 
			{
				var val:int = getProperties( ch );
				var kind:int = val & 0x1F;
				if (kind == Character.DECIMAL_DIGIT_NUMBER) 
				{
					value = ch + ((val & 0x3E0) >> 5) & 0x1F;
				}
            	else if ((val & 0xC00) == 0x00000C00) 
				{
					// Java supradecimal digit
					value = (ch + ((val & 0x3E0) >> 5) & 0x1F) + 10;
				}
			}
			return (value < radix) ? value : -1;
		}

		private static function getProperties( ch:int ):int 
		{
			var props:int = A[ch];
			return props;
		}

		private static function getType( ch:int ):int 
		{
			var props:int = getProperties( ch );
			return (props & 0x1F);
		}

		private static var A:Array = [1207963663,1207963663,1207963663,1207963663,1207963663,1207963663,1207963663,1207963663,1207963663,1476411407,1342193679,1476411407,1610629135,1342193679,1207963663,1207963663,1207963663,1207963663,1207963663,1207963663,1207963663,1207963663,1207963663,1207963663,1207963663,1207963663,1207963663,1207963663,1342193679,1342193679,1342193679,1476411407,1610629132,1744830488,1744830488,671088664,671113242,671088664,1744830488,1744830488,-402653163,-402653162,1744830488,671088665,939524120,671088660,939524120,536870936,402667017,402667017,402667017,402667017,402667017,402667017,402667017,402667017,402667017,402667017,939524120,1744830488,-402653159,1744830489,-402653159,1744830488,1744830488,8552417,8552417,8552417,8552417,8552417,8552417,8552417,8552417,8552417,8552417,8552417,8552417,8552417,8552417,8552417,8552417,8552417,8552417,8552417,8552417,8552417,8552417,8552417,8552417,8552417,8552417,-402653163,1744830488,-402653162,1744830491,1744850967,1744830491,8486882,8486882,8486882,8486882,8486882,8486882,8486882,8486882,8486882,8486882,8486882,8486882,8486882,8486882,8486882,8486882,8486882,8486882,8486882,8486882,8486882,8486882,8486882,8486882,8486882,8486882,-402653163,1744830489,-402653162,1744830489,1207963663,1207963663,1207963663,1207963663,1207963663,1207963663,1342181391,1207963663,1207963663,1207963663,1207963663,1207963663,1207963663,1207963663,1207963663,1207963663,1207963663,1207963663,1207963663,1207963663,1207963663,1207963663,1207963663,1207963663,1207963663,1207963663,1207963663,1207963663,1207963663,1207963663,1207963663,1207963663,1207963663,939524108,1744830488,671113242,671113242,671113242,671113242,1744830492,1744830492,1744830491,1744830492,28674,-402653155,1744830489,1744834576,1744830492,1744830491,671088668,671088665,402654731,402654731,1744830491,134049794,1744830492,1744830488,1744830491,402654475,28674,-402653154,1744832523,1744832523,1744832523,1744830488,8548353,8548353,8548353,8548353,8548353,8548353,8548353,8548353,8548353,8548353,8548353,8548353,8548353,8548353,8548353,8548353,8548353,8548353,8548353,8548353,8548353,8548353,8548353,1744830489,8548353,8548353,8548353,8548353,8548353,8548353,8548353,134049794,8482818,8482818,8482818,8482818,8482818,8482818,8482818,8482818,8482818,8482818,8482818,8482818,8482818,8482818,8482818,8482818,8482818,8482818,8482818,8482818,8482818,8482818,8482818,1744830489,8482818,8482818,8482818,8482818,8482818,8482818,8482818,102592514];
		
	}
}
