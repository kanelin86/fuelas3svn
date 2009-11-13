package com.fuelindustries.svn.core.util 
{
	import com.hurlant.crypto.hash.MD5;

	import flash.system.Capabilities;
	import flash.utils.ByteArray;

	/**
	 * @author julian
	 */
	public class SVNFileUtil 
	{
		
		public static function get isWindows():Boolean
		{
			var OS:String = Capabilities.os;
			var isWindows:Boolean = OS.indexOf("Windows") == 0;
			return( isWindows );
		}
		
		
		public static function toHexDigest( digest:ByteArray ):String 
		{
			if (digest == null) 
			{
				return null;
			}
       	
			var md5:MD5 = new MD5( );
       	
			var md5Hash:ByteArray = md5.hash( digest );
			var table:String = "0123456789abcdef";
			var hexString:String = "";
			for (var i:int = 0; i < md5Hash.length * 4; i += 4)
			{
				hexString += table.charAt( (md5Hash[i >> 2] >> ((i % 4) * 8 + 4)) & 0xF ) + table.charAt( (md5Hash[i >> 2] >> ((i % 4) * 8)) & 0xF );
			}
       	
			return hexString;
		}
	}
}
