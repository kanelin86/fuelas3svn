package com.fuelindustries.net 
{

    public class URL
    {
        private static const PATTERN:RegExp = /^([A-Za-z0-9_+.]{1,8}:\/\/)?([!-~]+@)?([^\/?#:]*)(:[0-9]*)?(\/[^?#]*)?(\?[^#]*)?(\#.*)?/i;
        private var __url:String;
        private var __protocol:String;
        private var __userinfo:String;
        private var __host:String;
        private var __port:String;
        private var __path:String;
        private var __query:String;
        private var __ref:String;


        function URL(url:String):void
        {
           parseURL( url ); 
        }
        
        private function parseURL( url:String ):void
        {
        	var result:Array = url.match(URL.PATTERN);
            
            for( var i:int; i<result.length; i++ )
            {
            	if( result[ i ] == undefined ) result[ i ] = "";	
            }
            
            __url = result[ 0 ];      
            __protocol = result[ 1 ];
            __userinfo = result[ 2 ];
            __host = result[ 3 ];
            __port = result[ 4 ];
            __path = result[ 5 ];
            __query = result[ 6 ];
            __ref = result[ 7 ];
			
			
			__host.replace( "@", "" );
			
			if( __protocol != "" )
			{
				__protocol = __protocol.substring( 0, __protocol.length - 3 );	
			}
			
			if( __port != ""  )
			{
				__port = __port.substring( 1, __port.length );	
			}
			
			if( __query != ""  )
			{
				if( __query.charAt( 0 ) == "?" )
				{
					__query = __query.substr( 1 );	
				}
			}
			
			if( __ref != ""  )
			{
				if( __ref.charAt( 0 ) == "#" )
				{
					__ref = __ref.substr( 1 );	
				}
			}

			
			if( __userinfo != ""  && __userinfo != "@" )
			{	
				if( __userinfo.charAt( __userinfo.length - 1 ) == "@" )
				{
					__userinfo = __userinfo.substr( 0, __userinfo.length - 1 );	
				}	
			}
        }
        
        public function get userinfo():String
        {
        	return( __userinfo );	
        }
        
        public function get port():int
        {
        	return( int( __port ) );	
        }
        
        public function get authority():String
        {
        	var str:String = "";
        	
        	if( __userinfo != null && __userinfo != "" ) str += __userinfo;
        	if( __host != null  && __host != "") str += __host;
        	if( __port != null && __port != ""  ) str += ":" + __port;
        	
        	return( str );
        } 
        
        public function get host():String
        {
        	return( __host );	
        }      
        
        public function get path():String
        {
        	return( __path );	
        }
        
        public function get ref():String
        {
        	return( __ref );	
        }
      
    }
}
