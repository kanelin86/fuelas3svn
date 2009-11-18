package com.fuelindustries.svn.core 
{
	import com.fuelindustries.net.URL;
	import com.fuelindustries.svn.core.errors.SVNErrorCode;
	import com.fuelindustries.svn.core.errors.SVNErrorManager;
	import com.fuelindustries.svn.core.errors.SVNErrorMessage;
	import com.fuelindustries.svn.core.util.SVNEncodingUtil;
	import com.fuelindustries.svn.core.util.SVNLogType;
	import com.fuelindustries.svn.core.util.SVNPathUtil;

	import flash.utils.Dictionary;

	/**
	 * @author julian
	 */
	public class SVNURL 
	{
		public static function parseURIEncoded( url:String ):SVNURL //throws SVNException 
		{
			return new SVNURL( url, true );
		}

		private var myURL:String;
		private var myProtocol:String;
		private var myHost:String;
		private var myPath:String;
		private var myUserName:String;
		private var myPort:int;
		private var myEncodedPath:String;
		private var myIsDefaultPort:Boolean;
		private static var DEFAULT_PORTS:Dictionary = new Dictionary( );

		

		public function SVNURL( url:String, uriEncoded:Boolean )
		{
			DEFAULT_PORTS["svn"]= 3690;
			DEFAULT_PORTS[ "svn+ssh"]= 22;
			DEFAULT_PORTS[ "http"]= 80;
			DEFAULT_PORTS[ "https"]= 443;
			DEFAULT_PORTS[ "file"]= 0;
			init( url, uriEncoded );
	    	
	    	/*
			trace( "protocol " + myProtocol );
			trace( "host " + myHost );
			trace( "path " + myPath );
			trace( "username " + myUserName );
			trace( "port " + myPort );
			trace( "encodedpath " + myEncodedPath );
			trace( "myIsDefaultPort " + myIsDefaultPort );
			*/
		}

		private function init(url:String, uriEncoded:Boolean ):void// throws SVNException {
		{
			if (url == null) 
			{
				SVNErrorManager.error(SVNErrorMessage.create(SVNErrorCode.BAD_URL, "URL cannot be NULL"), SVNLogType.DEFAULT);
			}
	        
			if( StringUtils.endsWith( url, "/" ) )
			{
				url = url.substring( 0, url.length - 1 );
			}


			var index:int = url.indexOf( "://" );
        	
			if (index <= 0) 
			{
				SVNErrorManager.error(SVNErrorMessage.create(SVNErrorCode.BAD_URL, "Malformed URL " + url), SVNLogType.DEFAULT);
			}
	        
	        
			myProtocol = url.substring( 0, index );
			myProtocol = myProtocol.toLowerCase( );
        	
			if( !DEFAULT_PORTS[ myProtocol ] && !StringUtils.startsWith( myProtocol, "svn+" ) ) 
			{
				SVNErrorManager.error(SVNErrorMessage.create(SVNErrorCode.BAD_URL, "URL protocol is not supported " + url), SVNLogType.DEFAULT);
			}
            
			if( myProtocol == "file" ) 
			{
            	
				var normalizedPath:String = norlmalizeURLPath( url, url.substring( "file://".length ) );
				var slashInd:int = normalizedPath.indexOf( '/' );
            	
				if (slashInd == -1) 
				{
					SVNErrorManager.error(SVNErrorMessage.create(SVNErrorCode.RA_ILLEGAL_URL, "Local URL " + url +  " contains only a hostname, no path" ), SVNLogType.DEFAULT);
					throw new Error( "Local URL " + url + " contains only a hostname, no path" );
				}
            
				myPath = normalizedPath.substring( slashInd );
            	
				if(normalizedPath == myPath ) 
				{
					myHost = "";
				} 
				else 
				{
					myHost = normalizedPath.substring( 0, slashInd );
				}
            

				var testURL:URL = new URL( myProtocol + "://" + normalizedPath );
				
				//SVNErrorManager.error(SVNErrorMessage.create(SVNErrorCode.BAD_URL, "Malformed URL: " + url ), SVNLogType.DEFAULT);
				if (uriEncoded) 
				{
					//do it before decoding - if a caller said url is encoded 
					//but however typed \ instead of / - this replace will recover
					//his url
					myPath = myPath.replace( '\\', '/' );
					// autoencode it.
					myEncodedPath = SVNEncodingUtil.autoURIEncode( myPath );
	                
					SVNEncodingUtil.assertURISafe( myEncodedPath );
					myPath = SVNEncodingUtil.uriDecode( myEncodedPath );
	                
					if( !StringUtils.startsWith( myPath, "/" ) )
					{
						myPath = "/" + myPath;
					}
				} 
				else 
				{
					myEncodedPath = SVNEncodingUtil.uriEncode( myPath );
					myPath = myPath.replace( '\\', '/' );
	                
					if( !StringUtils.startsWith( myPath, "/" ) )
					{
						myPath = "/" + myPath;
					}
				}
	            
				myUserName = testURL.userinfo;
				myPort = testURL.port;
			} 
			else 
			{
				var httpURL:URL = new URL( "http" + url.substring( index ) );
				//SVNErrorManager.error(SVNErrorMessage.create(SVNErrorCode.BAD_URL, "Malformed URL: " + url ), SVNLogType.DEFAULT);
				myHost = httpURL.host;
	            
				var httpPath:String = norlmalizeURLPath( url, getURLPath( httpURL ) );
	            
				if (uriEncoded) 
				{
					// autoencode it.
					myEncodedPath = SVNEncodingUtil.autoURIEncode( httpPath );
					SVNEncodingUtil.assertURISafe( myEncodedPath );
					myPath = SVNEncodingUtil.uriDecode( myEncodedPath );
				} 
				else 
				{
					// do not use httpPath. 
					var originalPath:String = url.substring( index + "://".length );
	                
					if (originalPath.indexOf( "/" ) < 0) 
					{
						originalPath = "";
					} 
					else 
					{
						originalPath = originalPath.substring( originalPath.indexOf( "/" ) + 1 );
					}
	                
					myPath = originalPath;
	                
					if( !StringUtils.startsWith( myPath, "/" ) )
					{
						myPath = "/" + myPath;
					}
	                
					myEncodedPath = SVNEncodingUtil.uriEncode( myPath );
				}
	            
				myUserName = httpURL.userinfo;
				myPort = httpURL.port;
				myIsDefaultPort = myPort < 0;
	            
				if (myPort <= 0) 
				{
					myPort = ( DEFAULT_PORTS[ myProtocol ] != null ) ? int( DEFAULT_PORTS[ myProtocol ] ) : 0;
				} 
			}
        
			if( myEncodedPath == "/" ) 
			{
				myEncodedPath = "";
				myPath = "";
			}
	        
			if( myHost != null ) 
			{
				myHost = myHost.toLowerCase( );
			}
		}

		private static function norlmalizeURLPath( url:String, path:String ):String
		{
			var result:String = "";
			var tokens:Array = path.split( "/" );
	        
			for( var i:int = 0; i < tokens.length ; i++ )
			{
				var token:String = tokens[ i ] as String;
				if( token == "" || token == "." )
				{
					continue;	
				}
	        	else if( token == ".." )
				{
					
					SVNErrorManager.error(SVNErrorMessage.create(SVNErrorCode.BAD_URL, "URL " + url + " contains '..' element"), SVNLogType.DEFAULT);
					throw new Error( "URL " + url + " contains '..' element" );
				}
				else
				{
					result += "/";
					result += token;	
				}
			}
	        
	       
			if( !StringUtils.startsWith( path, "/" ) && result.length > 0) 
			{
				result = StringUtils.deleteChars( result, 0, 1 );
			}
			return result;
		}

		private static function getURLPath( url:URL ):String 
		{	
			var path:String = url.path;
			var ref:String = url.ref;
	        
			if (ref != "") 
			{
				path += "#" + ref;
			}
			return path;
		}

		public function toString():String 
		{
			if (myURL == null) 
			{
				myURL = composeURL( getProtocol( ), getUserInfo( ), getHost( ), myIsDefaultPort ? -1 : getPort( ), getURIEncodedPath( ) );
			}
			return myURL;
		}

		public function getProtocol():String
		{
			return( myProtocol );	
		}

		public function getUserInfo():String
		{
			return( myUserName );	
		}

		public function getHost():String
		{
			return( myHost );	
		}

		public function getPort():int
		{
			return( myPort );	
		}

		public function getURIEncodedPath():String
		{
			return( myEncodedPath );	
		}

		public function getPath():String 
		{
			return myPath;
		}

		private static function composeURL( protocol:String, userInfo:String, host:String, port:int, path:String):String 
		{
			var url:String = "";
        
			url += protocol;
			url += "://";
        
			if (userInfo != null && userInfo != "" ) 
			{
				url += userInfo;
				url += "@";
			}
			
			if (host != null) 
			{
				url += host;
			}
			
			if (port >= 0) 
			{
				url += ":";
				url += port;
			}
			
			if (path != null && !StringUtils.startsWith( path, "/" )) 
			{
				path = '/' + path;
			}
			
			if ("/" == path) 
			{
				path = "";
			}
			
			url += path;
			return url.toString( );
		}

		public function setPath( path:String,  uriEncoded:Boolean):SVNURL
		{
			if (path == null || "" == path ) 
			{
				path = "/";
			}
			if (!uriEncoded) 
			{
				path = SVNEncodingUtil.uriEncode( path );
			} 
			else 
			{
				path = SVNEncodingUtil.autoURIEncode( path );
			}
			var url:String = composeURL( getProtocol( ), getUserInfo( ), getHost( ), myIsDefaultPort ? -1 : getPort( ), path );
			return parseURIEncoded( url );
		}
		
		public function appendPath( segment:String, uriEncoded:Boolean ):SVNURL
		{
			if (segment == null || "" == segment) 
			{
				return this;
			}
			
			if (!uriEncoded) 
			{
				segment = SVNEncodingUtil.uriEncode( segment );
			} 
			else 
			{
				segment = SVNEncodingUtil.autoURIEncode( segment );
			}
			
			var path:String = getURIEncodedPath();
			
			if ("" == path) 
			{
				path = "/" + segment;
			} 
			else 
			{
				path = SVNPathUtil.append( path, segment );
			}
			
			var protocol:String = getProtocol();
			var user:String = getUserInfo();
			var host:String = getHost();
			var port:int =  myIsDefaultPort ? -1 : getPort( );
			
			var url:String = composeURL(  protocol, user, host, port, path );
			
			return parseURIEncoded( url );
		}
	}
}
