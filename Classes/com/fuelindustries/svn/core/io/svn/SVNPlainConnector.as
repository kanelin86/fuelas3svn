package com.fuelindustries.svn.core.io.svn 
{
	import com.fuelindustries.svn.core.SVNURL;
	import com.fuelindustries.svn.core.errors.SVNErrorCode;
	import com.fuelindustries.svn.core.errors.SVNErrorManager;
	import com.fuelindustries.svn.core.errors.SVNErrorMessage;
	import com.fuelindustries.svn.core.util.SVNLogType;
	import com.fuelindustries.svn.events.SocketDataEvent;

	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;

	/**
	 * @author julian
	 */
	public class SVNPlainConnector extends EventDispatcher implements ISVNConnector 
	{
		private var mySocket:Socket;

		public function SVNPlainConnector()
		{
		}
		
		public function sendCommand( command:ByteArray ):void
		{
			command.position = 0;
			
			trace( "sending command", command.readUTFBytes( command.bytesAvailable ) );
			
			command.position = 0;
			
			mySocket.writeBytes( command );
			mySocket.flush();
		}
		
		public function open( repository:SVNRepositoryImpl ):void
		{
			if(mySocket != null) 
			{
				return;
			}
       		
			var location:SVNURL = repository.getLocation();
       		
			try
			{
				mySocket = new Socket( location.getHost( ), location.getPort( ) );
				mySocket.addEventListener( ProgressEvent.SOCKET_DATA, onSocketData );
				mySocket.addEventListener( Event.CLOSE, onSocketClose );
				mySocket.addEventListener( Event.CONNECT, onSocketConnect );
				mySocket.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
				mySocket.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
			}
       		catch( e:SecurityError )
			{
				SVNErrorManager.error( SVNErrorMessage.create(SVNErrorCode.IO_ERROR, e.message ), SVNLogType.NETWORK );
			}
		}

		public function isConnected(repository:SVNRepositoryImpl):Boolean
		{
			 return mySocket != null && mySocket.connected;
		}

		public function close(repository:SVNRepositoryImpl):void
		{
			if( mySocket != null )
			{
				try
				{
					mySocket.close( );
				}
				catch( e:IOError )
				{
					SVNErrorManager.error( SVNErrorMessage.create(SVNErrorCode.IO_ERROR, e.message ), SVNLogType.NETWORK );
				}
				finally
				{
					mySocket.removeEventListener( ProgressEvent.SOCKET_DATA, onSocketData );
					mySocket.removeEventListener( Event.CLOSE, onSocketClose );
					mySocket.removeEventListener( Event.CONNECT, onSocketConnect );
					mySocket.removeEventListener( IOErrorEvent.IO_ERROR, onIOError );
					mySocket.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
					mySocket = null;
				}	
			}
		}

		private function onSocketData( e:ProgressEvent ):void
		{
			var ba:ByteArray = new ByteArray();
			mySocket.readBytes( ba );
			
			var maxbytes:int = 1000;
			
			var bytestooutput:int = ( ba.bytesAvailable > maxbytes ) ? maxbytes : ba.bytesAvailable;
			
			trace( "ondata", ba.readUTFBytes( bytestooutput ), ( bytestooutput == maxbytes ) ? "...... output truncated" : "" );
			
			ba.position = 0;
			
			
			dispatchEvent( new SocketDataEvent( SocketDataEvent.DATA, ba ) );
		}

		private function onSocketClose( e:Event ):void
		{
		}

		private function onSocketConnect( e:Event ):void
		{
		}

		private function onIOError( e:IOErrorEvent ):void
		{
		}

		private function onSecurityError( e:SecurityErrorEvent ):void
		{
		}
	}
}
