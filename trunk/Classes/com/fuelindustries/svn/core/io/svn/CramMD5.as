package com.fuelindustries.svn.core.io.svn 
{
	import com.fuelindustries.svn.core.auth.SVNPasswordAuthentication;
	import com.hurlant.crypto.hash.HMAC;
	import com.hurlant.crypto.hash.MD5;

	import flash.utils.ByteArray;

	/**
	 * @author julian
	 */
	public class CramMD5 
	{
		private var myCredentials:SVNPasswordAuthentication;

		public function setUserCredentials( credentials:SVNPasswordAuthentication ):void 
		{
			myCredentials = credentials;
		}
		
		public function buildChallengeResponse( challenge:ByteArray ):ByteArray
		{
			var md5:MD5 = new MD5();
			var hmac:HMAC = new HMAC( md5 );
			var password_ba:ByteArray = new ByteArray();
			password_ba.writeUTFBytes( myCredentials.getPassword() );
			
			var md5Hash:ByteArray = hmac.compute( password_ba, challenge );
			var table:String = "0123456789abcdef";
			var hexString:String = "";
			for (var i:int = 0;i < md5Hash.length*4;i += 4)
			{
				hexString += table.charAt((md5Hash[i >> 2] >> ((i%4)*8+4)) & 0xF) + table.charAt((md5Hash[i >> 2] >> ((i%4)*8)) & 0xF);
			}
			
			var response:String = myCredentials.getUserName() + " " + hexString;
			response = response.length + ":" + response + " ";
			
			trace( "CHALLENGE RESPONSE", response );
			trace( myCredentials.getUserName(), myCredentials.getPassword() );
        	return StringUtils.getBytes( response );
		}
	}
}
