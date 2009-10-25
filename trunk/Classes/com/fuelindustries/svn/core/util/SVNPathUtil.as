package com.fuelindustries.svn.core.util 
{

	/**
	 * @author julian
	 */
	public class SVNPathUtil 
	{
		public static function append( f:String,  s:String ):String 
		{
			f = f == null ? "" : f;
			s = s == null ? "" : s;
			var l1:int = f.length;
			var l2:int = s.length;
        
			var r:Array = [];
        
			var index:int = 0;
        
			var i:int;
			var ch:String;
        
			for ( i = 0; i < l1; i++) 
			{
				ch = f.charAt( i );
            
				if (i + 1 == l1 && ch == "/") 
				{
					break;
				}
				r[index++] = ch;
			}
        
			for( i = 0; i < l2; i++) 
			{
				ch = s.charAt( i );
				if (i == 0 && ch != "/" && index > 0) 
				{
					r[index++] = "/";
				}
            
				if (i + 1 == l2 && ch == "/") 
				{
					break;
				}
				r[index++] = ch;
			}
        
			var result:String = "";
      
			for( i = 0; i < index; i++ )
			{
				result += r[ i ] as String;
			}
        
        
			return result;
		}
	}
}
