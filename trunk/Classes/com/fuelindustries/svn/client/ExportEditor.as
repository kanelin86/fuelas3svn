package com.fuelindustries.svn.client 
{
	import com.fuelindustries.svn.core.SVNCommitInfo;
	import com.fuelindustries.svn.core.SVNPropertyValue;
	import com.fuelindustries.svn.core.io.ISVNEditor;
	import com.fuelindustries.svn.core.io.diff.SVNDeltaProcessor;
	import com.fuelindustries.svn.core.io.diff.SVNDiffWindow;

	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	/**
	 * @author julian
	 */
	public class ExportEditor implements ISVNEditor 
	{
		
		private var myRootDirectory:String;
		private var myRepositoryRoot:String;
		private var myDeltaProcessor:SVNDeltaProcessor;
		private var __files:Array;
		
		private var __currentFile:ByteArray;
        
        public function ExportEditor( root:String, repositoryRoot:String )
        {
        	myRootDirectory = root;
        	myRepositoryRoot = repositoryRoot;
        	 myDeltaProcessor = new SVNDeltaProcessor();
        	__files = [];
        }
		
		public function targetRevision(revision:int):void
		{
		}
		
		public function openRoot(revision:int):void
		{
		}
		
		public function deleteEntry(path:String, revision:int):void
		{
		}
		
		public function addDir(path:String, copyFromPath:String, copyFromRevision:int):void
		{
			trace( "ExportEditor.addDir", path, copyFromPath, copyFromRevision );
			
			__files.push( path );
		}
		
		public function openDir(path:String, revision:int):void
		{
		}
		
		public function changeDirProperty(name:String, value:SVNPropertyValue):void
		{
		}
		
		public function closeDir():void
		{
		}
		
		public function addFile(path:String, copyFromPath:String, copyFromRevision:int):void
		{
			trace( "ExportEditor.addFile", path, copyFromPath, copyFromRevision );
			__currentFile = new ByteArray();
		}
		
		public function openFile(path:String, revision:int):void
		{
		}
		
		public function changeFileProperty(path:String, propertyName:String, propertyValue:SVNPropertyValue):void
		{
		}
		
		public function closeFile(path:String, textChecksum:String):void
		{
		}
		
		public function applyTextDelta(path:String, baseChecksum:String):void
		{
			 myDeltaProcessor.applyTextDelta( null, __currentFile, false);
		}
		
		public function closeEdit():SVNCommitInfo
		{
			
			return null;
		}
		
		public function abortEdit():void
		{
		}
		
		public function absentDir(path:String):void
		{
		}
		
		public function absentFile(path:String):void
		{
		}
		
		public function textDeltaEnd(path:String):void
		{
			__currentFile.position = 0;
			
			path = path.replace( myRepositoryRoot, "" );			
			
			var f:File = new File( myRootDirectory + path );
			var stream:FileStream = new FileStream();
			stream.open( f , FileMode.WRITE );
			stream.writeBytes( __currentFile );
			stream.close();
		}
		
		public function textDeltaChunk(path:String, diffWindow:SVNDiffWindow):ByteArray
		{
			return myDeltaProcessor.textDeltaChunk(diffWindow);
		}
	}
}
