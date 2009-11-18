package com.fuelindustries.svn.core.util 
{
	import com.fuelindustries.lang.Character;
	import com.fuelindustries.svn.core.errors.SVNErrorCode;
	import com.fuelindustries.svn.core.errors.SVNErrorManager;
	import com.fuelindustries.svn.core.errors.SVNErrorMessage;

	import flash.utils.ByteArray;

	/**
	 * @author julian
	 */
	public class SVNEncodingUtil
	{
		
		
		public static function isHexDigit( ch:String ):Boolean
		{
        	return Character.isDigit(ch) ||
               (Character.toUpperCase(ch) >= 'A' && Character.toUpperCase(ch) <= 'F');
   		}
		
		public static function autoURIEncode( src:String ):String 
		{
	       var sb:ByteArray = null;
	       var bytes:ByteArray = new ByteArray();
	       bytes.writeUTFBytes( src );
	       bytes.position = 0;

	        
	        for( var i:int = 0; i<bytes.length; i++ ) 
	        {
	            var index:int = bytes.readByte() & 0xFF;
	            
	            if(uri_char_validity[index] > 0) 
	            {
	                if (sb != null) 
	                {
	                    sb.writeByte( index );
	                }
	                continue;
	                
	            } 
	            else if( i + 2 < bytes.bytesAvailable )
	            {
	                var char1:String = bytes.readUTF();
	                var char2:String = bytes.readUTF();
	                bytes.position -= 2;
	                
	                if( isHexDigit( char1 ) && isHexDigit( char2 ) )
	                {

	                	if( index == "%".charCodeAt() )
	                	{
	                		if( sb != null )
	                		{
	                			sb.writeByte( index );
	                		}
	                		continue;
	                	}	
	                }	                
	            }
	            
	            if (sb == null) 
	            {
	                sb = new ByteArray();
	                sb.writeBytes( bytes, 0, i );
	            }
	            
	            sb.writeUTF("%");
	
	            sb.writeUTF(Character.toUpperCase(Character.forDigit((index & 0xF0) >> 4, 16)));
	            sb.writeUTF(Character.toUpperCase(Character.forDigit(index & 0x0F, 16)));
	        }
	        
	        if( sb != null )
	        	sb.position = 0;
	        
	        return sb == null ? src : sb.readUTFBytes( sb.bytesAvailable );
	    }

		public static function assertURISafe( path:String ):void
		{
	
	       path = path == null ? "" : path;
	       var bytes:ByteArray = new ByteArray();
	       bytes.writeUTFBytes( path );
	       bytes.position = 0;
	       
	
		    if (bytes == null || bytes.length != path.length ) 
		    {
		        SVNErrorManager.error(SVNErrorMessage.create(SVNErrorCode.BAD_URL, "path " + path + " doesn't look like URI-encoded path"), SVNLogType.DEFAULT);
		    }
		    
	        for( var i:int = 0; i<bytes.length; i++) 
	        {
	            var index:int = bytes.readByte();
	            
	            if( uri_char_validity[ index ] <= 0 && index != "%".charCodeAt() ) 
	            {
	                SVNErrorManager.error(SVNErrorMessage.create(SVNErrorCode.BAD_URL, "path " + path + " doesn't look like URI-encoded path"), SVNLogType.DEFAULT);
	            }
	        }
	        return;
	    }
    
	     public static function uriDecode( src:String ):String 
	     {
	        // this is string in ASCII-US encoding.
	        var query:Boolean = false;
	        var decoded:Boolean = false;
	        
	        var length:int = src.length;
	        
	        var bos:ByteArray = new ByteArray();
	        
	        for( var i:int = 0; i<length; i++ ) 
	        {
	            var ch:int = src.charCodeAt(i);
	           
	            if( ch == "?".charCodeAt() ) 
	            {
	                query = true;
	            } 
	            else if (ch == "+".charCodeAt() && query) 
	            {
	                ch = " ".charCodeAt();
	            } 
	            else if (ch == "%".charCodeAt() && i + 2 < length && isHexDigit(src.charAt(i + 1)) && isHexDigit(src.charAt(i + 2))) 
	            {
	                ch = (hexValue(src.charAt(i + 1))*0x10 + hexValue(src.charAt(i + 2)));
	                decoded = true;
	                i += 2;
	            } 
	            else 
	            {
	                // if character is not URI-safe try to encode it.
	            }
	            
	            bos.writeByte(ch);
	        }
	        
	        if (!decoded) 
	        {
	            return src;
	        }
	        
	        bos.position = 0;
	        
	        return bos.readUTFBytes( bos.bytesAvailable );
	    }
    
	    public static function uriEncode( src:String ):String
	    {
	        var sb:ByteArray = null;
	        var bytes:ByteArray = new ByteArray();
	        bytes.writeUTFBytes( src );
	        bytes.position = 0;
	        
	        for( var i:int = 0; i<bytes.length; i++) 
	        {
	            var index:int = bytes.readByte() & 0xFF;
	            
	            if (uri_char_validity[index] > 0) 
	            {
	                if (sb != null) 
	                {
	                    sb.writeByte( index );
	                }
	                continue;
	            }
	            
	            if (sb == null) 
	            {
	                sb = new ByteArray();
	                sb.writeBytes(bytes, 0, i );
	            }
	            
	            sb.writeUTF("%");
	
	            sb.writeUTF(Character.toUpperCase(Character.forDigit((index & 0xF0) >> 4, 16)));
	            sb.writeUTF(Character.toUpperCase(Character.forDigit(index & 0x0F, 16)));
	        }
	        
	        if( sb != null )
	        {
	        	sb.position = 0;	
	        }
	        
	        return sb == null ? src : sb.readUTFBytes( sb.bytesAvailable );
	    }
    
    
		 private static function hexValue( ch:String ):int
		 {
	        if (Character.isDigit(ch)) 
	        {
	            return ch.charCodeAt() - "0".charCodeAt();
	        }
	        
	        ch = Character.toUpperCase(ch);
	        return (ch.charCodeAt() - "A".charCodeAt()) + 0x0A;
	    }
	
	
		private static var uri_char_validity:Array = [
	        0, 0, 0, 0, 0, 0, 0, 0,   0, 0, 0, 0, 0, 0, 0, 0,
	        0, 0, 0, 0, 0, 0, 0, 0,   0, 0, 0, 0, 0, 0, 0, 0,
	        0, 1, 0, 0, 1, 0, 1, 1,   1, 1, 1, 1, 1, 1, 1, 1,
	        1, 1, 1, 1, 1, 1, 1, 1,   1, 1, 1, 0, 0, 1, 0, 0,
	
	        /* 64 */
	        1, 1, 1, 1, 1, 1, 1, 1,   1, 1, 1, 1, 1, 1, 1, 1,
	        1, 1, 1, 1, 1, 1, 1, 1,   1, 1, 1, 0, 0, 0, 0, 1,
	        0, 1, 1, 1, 1, 1, 1, 1,   1, 1, 1, 1, 1, 1, 1, 1,
	        1, 1, 1, 1, 1, 1, 1, 1,   1, 1, 1, 0, 0, 0, 1, 0,
	
	        /* 128 */
	        0, 0, 0, 0, 0, 0, 0, 0,   0, 0, 0, 0, 0, 0, 0, 0,
	        0, 0, 0, 0, 0, 0, 0, 0,   0, 0, 0, 0, 0, 0, 0, 0,
	        0, 0, 0, 0, 0, 0, 0, 0,   0, 0, 0, 0, 0, 0, 0, 0,
	        0, 0, 0, 0, 0, 0, 0, 0,   0, 0, 0, 0, 0, 0, 0, 0,
	
	        /* 192 */
	        0, 0, 0, 0, 0, 0, 0, 0,   0, 0, 0, 0, 0, 0, 0, 0,
	        0, 0, 0, 0, 0, 0, 0, 0,   0, 0, 0, 0, 0, 0, 0, 0,
	        0, 0, 0, 0, 0, 0, 0, 0,   0, 0, 0, 0, 0, 0, 0, 0,
	        0, 0, 0, 0, 0, 0, 0, 0,   0, 0, 0, 0, 0, 0, 0, 0,
	    ];
	}
}
