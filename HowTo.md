This is an example of how to use the library and some of it's features.
The library only supports connecting to a svn:// protocol currently.
http:// and others will be implemented when the svn:// is completed.

```
<?xml version="1.0" encoding="utf-8"?>
<mx:Application xmlns:mx="http://www.adobe.com/2006/mxml" creationComplete="init()" >

<mx:Script>
	<![CDATA[
		
		import com.fuelindustries.svn.core.SVNDirEntry;
		import com.fuelindustries.svn.core.io.svn.*;
		import com.fuelindustries.svn.core.SVNURL;
		import mx.events.*;
		import mx.controls.listClasses.*;
		import mx.controls.treeClasses.*;
		
		import flash.ui.ContextMenu;
		import flash.ui.ContextMenuItem;
		import flash.events.ContextMenuEvent;
		import flash.filesystem.*;
		
		import com.fuelindustries.svn.client.*;
		
		private var svn:SVNClient;
		
		private var currentItem:IListItemRenderer;
		
		private var treeContextMenu:ContextMenu;
		
		private function init():void
		{
			
			var url:String = "svn://yoursvnpath";
			var username:String = "username";
			var password:String = "password";
			
			
			var menu:ContextMenu = new ContextMenu();
		    menu.hideBuiltInItems();
		    
		    var exportitem:ContextMenuItem = new ContextMenuItem( "Export" );
		    exportitem.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, exportSelected ); 
            menu.customItems.push(exportitem);
            
            var historyitem:ContextMenuItem = new ContextMenuItem( "Show History" );
            historyitem.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, historySelected ); 
            menu.customItems.push(historyitem);
            
            treeContextMenu = menu;
			
			svn = new SVNClient( File.desktopDirectory.resolvePath( "exports" ).url + "/" );
			svn.connect( url, username, password );
			svn.addEventListener( Event.CHANGE, updateTree );
			svn.addEventListener( Event.COMPLETE, commandComplete );
		
		}
		
		private function exportSelected( e:ContextMenuEvent ):void
		{
			tree1.enabled = false;
			var cell:IListItemRenderer = e.contextMenuOwner as IListItemRenderer;
			var item:RepositoryDataItem = cell.data as RepositoryDataItem;
			tree1.selectedItem = item;
			svn.export( item.entry );
		}
		
		private function historySelected( e:ContextMenuEvent ):void
		{
			tree1.enabled = false;
			var cell:IListItemRenderer = e.contextMenuOwner as IListItemRenderer;
			var item:RepositoryDataItem = cell.data as RepositoryDataItem;
			tree1.selectedItem = item;
			svn.getLog( item.entry );
		}
		
		private function commandComplete( e:Event ):void
		{
			tree1.enabled = true;	
		}
		
		private function updateTree( e:Event ):void
		{
			if( tree1.dataProvider == null )
			{
				tree1.dataProvider = svn.data;
			}
			else
			{
				tree1.invalidateList();	
			}
			
			
			tree1.enabled = true;
		}

		
		private function itemOpen( e:TreeEvent ):void
		{
			currentItem = e.itemRenderer;
			
			var item:RepositoryDataItem = currentItem.data as RepositoryDataItem;
			
			var children:Array = item.children;

			if( children.length == 1 )
			{
				var firstchild:RepositoryDataItem = children[ 0 ] as RepositoryDataItem;
				if( firstchild.label == RepositoryDataItem.DEFAULT_LABEL )
				{
					tree1.enabled = false;
					var dir:SVNDirEntry = item.entry;
					var url:SVNURL = dir.getURL();
			
					svn.getDir( url.getURIEncodedPath() );
				}
					
			}
		}
		
		
		
		private function itemOver( e:ListEvent ):void
		{
			TreeItemRenderer(e.itemRenderer).contextMenu = treeContextMenu;
		}
		
	]]>
</mx:Script>
<mx:Canvas width="100%" height="100%">
	<mx:Tree id="tree1" labelField="label" showRoot="false" width="300" height="100%" x="0" y="0" itemOpen="itemOpen( event )" itemRollOver="itemOver( event )">
	</mx:Tree>
</mx:Canvas>
</mx:Application>

```