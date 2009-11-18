package com.fuelindustries.svn.core.errors 
{

	/**
	 * @author julian
	 */
	public class SVNErrorMessage 
	{
		public static const TYPE_ERROR:int = 0;
		public static const TYPE_WARNING:int = 1;
		private var myMessage:String;
		private var myErrorCode:SVNErrorCode;
		private var myType:int;
		private var myChildErrorMessage:SVNErrorMessage;

		public static function create( code:SVNErrorCode, message:String = "",  type:int = TYPE_ERROR ):SVNErrorMessage
		{
			if( code == null ) code = SVNErrorCode.BASE;
			
			return( new SVNErrorMessage( code, message, type ) );
		}

		public function SVNErrorMessage( code:SVNErrorCode, message:String, type:int ) 
		{
			myErrorCode = code;
			
			var str:String = "svn: ";
			
			if (message != null && StringUtils.startsWith( message, str )) 
			{
				message = message.substring( str.length );
			}
			myMessage = message;

			myType = type;
		}

		public function getType():int 
		{
			return myType;
		}

		public function getErrorCode():SVNErrorCode 
		{
			return myErrorCode;
		}

		public function getMessage():String 
		{
			return toString( );
		}

		public function toString():String 
		{
			var line:String = "";
			if (getType( ) == TYPE_WARNING && getErrorCode( ) == SVNErrorCode.REPOS_POST_COMMIT_HOOK_FAILED) 
			{
				line += "Warning: ";
			} else if (getType( ) == TYPE_WARNING) 
			{
				line += "svn: warning: ";
			} 
			else 
			{
				line += "svn: ";
			}
			if ("" == myMessage) 
			{
				line += myErrorCode.getDescription( );
			} 
			else 
			{
            	line += myMessage;
			}
			return line.toString( );
		}

		public function getChildErrorMessage():SVNErrorMessage 
		{
			return myChildErrorMessage;
		}

		public function hasChildErrorMessage():Boolean 
		{
			return myChildErrorMessage != null;
		}

		public function getFullMessage():String 
		{
			var err:SVNErrorMessage = this;            
			var buffer:String = "";
			while (err != null) 
			{
				buffer += err.getMessage( );
				if (err.hasChildErrorMessage( )) 
				{
					buffer += "\n";
				}
				err = err.getChildErrorMessage( );
			}
			return buffer.toString( );
		}

		public function setChildErrorMessage( childMessage:SVNErrorMessage):void 
		{
			var parent:SVNErrorMessage = this;
			var child:SVNErrorMessage = childMessage;
			while (child != null) 
			{
				if (this == child) 
				{
					parent.setChildErrorMessage( null );
					break;
				}
				parent = child;
				child = child.getChildErrorMessage( );
			}
			myChildErrorMessage = childMessage;
		}
	}
}
