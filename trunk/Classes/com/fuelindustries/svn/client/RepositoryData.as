package com.fuelindustries.svn.client 
{
	import com.fuelindustries.svn.core.SVNDirEntry;

	/**
	 * @author julian
	 */
	public class RepositoryData 
	{
		
		private var __items:Array;
		private var __rootPath:String;
		
		public function get items():Array
		{
			return( __items );	
		}
		
		public function get rootPath():String
		{
			return( __rootPath );
		}	
		
		public function RepositoryData( rootPath:String )
		{
			__items = new Array();
			__rootPath = rootPath;
		}
		
		public function addEntries( entries:Array, path:String ):void
		{	
			if( path == __rootPath )
			{
				__items = createChildren( entries );
				return;
			}
			
			var parent:RepositoryDataItem = getParentNode( path );
			parent.children = createChildren( entries );
		}

		private function createChildren( entries:Array ):Array
		{
						
			var folders:Array = [];
			var files:Array = [];
					
			for( var i:int = 0; i<entries.length; i++ )
			{
				var dir:SVNDirEntry = entries[ i ] as SVNDirEntry;
				var obj:RepositoryDataItem = new RepositoryDataItem( dir );
				
				if( obj.isFolder )
				{
					folders.push( obj );
				}
				else
				{
					files.push( obj );	
				}
			}

			folders.sortOn( "label" );
			files.sortOn( "label" );
			
			var dp:Array = folders.concat( files );
			
			return dp;
		}
		
		private function getParentNode(path:String):RepositoryDataItem
		{
			var subpath:String = path.substring( path.indexOf( __rootPath ) );
			var dirs:Array = subpath.split( "/" );
			
			var folders:Array = __items;
			var parent:RepositoryDataItem;
			
			for( var i:int = 0; i<dirs.length; i++ )
			{
				var dirToCheck:String = dirs[ i ] as String;
				
				for( var j:int = 0; j<folders.length; j++ )
				{
					var item:RepositoryDataItem = folders[ j ] as RepositoryDataItem;
					
					if( item.isFolder )
					{
						if( item.label == dirToCheck )
						{
							folders = item.children;
							parent = item;
							break;	
						}
					}
				}		
			}
			
			return( item );
		}
	}
}
