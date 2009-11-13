package com.fuelindustries.svn.core.io 
{
	import com.fuelindustries.svn.core.SVNCommitInfo;
	import com.fuelindustries.svn.core.SVNPropertyValue;

	/**
	 * @author julian
	 */
	public interface ISVNEditor extends ISVNDeltaConsumer
	{
		function targetRevision( revision:int ):void
		function openRoot( revision:int ):void
		function deleteEntry( path:String, revision:int ):void
		function addDir(path:String, copyFromPath:String, copyFromRevision:int ):void
		function openDir( path:String, revision:int ):void
		function changeDirProperty( name:String,  value:SVNPropertyValue ):void
		function closeDir():void
		function addFile(path:String, copyFromPath:String, copyFromRevision:int ):void
		function openFile( path:String, revision:int ):void
		function changeFileProperty( path:String, propertyName:String, propertyValue:SVNPropertyValue ):void
		function closeFile( path:String, textChecksum:String ):void
		function closeEdit():SVNCommitInfo;
		function abortEdit():void;
		function absentDir( path:String ):void
		function absentFile( path:String ):void

	}
}
