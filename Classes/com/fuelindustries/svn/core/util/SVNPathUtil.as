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

		public static function canonicalizePath(path:String):String 
		{
			if (path == null)
			{
				return null;           
			}
			var result:String = "";
			var i:int = 0;
			for (i = 0; i < path.length; i++) 
			{
				if (path.charAt( i ) == "/" || path.charAt( i ) == ":") 
				{
					break;
				}
			}
        
			var scheme:String = null;
			var index:int = 0;
			if (i > 0 && i + 2 < path.length && path.charAt( i ) == ":" && path.charAt( i + 1 ) == "/" && path.charAt( i + 2 ) == "/") 
			{
				scheme = path.substring( 0, i + 3 );
				result += scheme;
				index = i + 3;
			}
			if (index < path.length && path.charAt( index ) == "/") 
			{
				result += "/";
				index++;
            
				if (SVNFileUtil.isWindows && scheme == null && index < path.length && path.charAt( index ) == "/") 
				{
					result += "/";
					index++;
				}
			}
        
			var segmentCount:int = 0;
			while (index < path.length) 
			{
				var nextIndex:int = index;
				while (nextIndex < path.length && path.charAt( nextIndex ) != "/") 
				{
					nextIndex++;
				}
				var segmentLength:int = nextIndex - index;
				if (segmentLength == 0 || (segmentLength == 1 && path.charAt( index ) == ".")) 
				{
				} 
				else 
				{
					if (nextIndex < path.length) 
					{
						segmentLength++;
					}
					result += (path.substring( index, index + segmentLength ));
					segmentCount++;
				}
				index = nextIndex;
				if (index < path.length) 
				{
					index++;
				}
			}
			if ((segmentCount > 0 || scheme != null) && result.charAt( result.length - 1 ) == "/") 
			{
				result = result.slice( result.length - 1, result.length );
			}
			if (SVNFileUtil.isWindows && segmentCount < 2 && result.length >= 2 && result.charAt( 0 ) == "/" && result.charAt( 1 ) == "/") 
			{
				result = result.slice( 0, 1 );
			}
			return result.toString( );
		}
	}
}
