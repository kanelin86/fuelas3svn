package com.fuelindustries.svn.client 
{
	import com.fuelindustries.svn.core.SVNDirEntry;
	import com.fuelindustries.svn.core.io.svn.SVNNodeKind;

	/**
	 * @author julian
	 */
	public class RepositoryDataItem 
	{
		
		public static const DEFAULT_LABEL:String = "Pending...";
		
		public var entry:SVNDirEntry;
		public var label:String;
		public var children:Array;
		public var isFolder:Boolean;
		
		public function RepositoryDataItem( dir:SVNDirEntry = null )
		{
			if( dir != null )
			{
				entry = dir;
				label = dir.getName();
				isFolder = ( dir.getKind().toString() == new SVNNodeKind( SVNNodeKind.DIR ).toString() );
				
				if( isFolder )
				{
					children = [];
					var defaultItem:RepositoryDataItem = new RepositoryDataItem();
					defaultItem.label = DEFAULT_LABEL;
					children.push( defaultItem );
				}
			}
		}
	}
}
