package com.fuelindustries.svn.core 
{
	import com.fuelindustries.svn.core.util.SVNDate;
	import com.fuelindustries.svn.core.util.SVNHashMap;

	/**
	 * @author julian
	 */
	public class SVNLogEntry 
	{
		private var myRevision:int;
		private var myChangedPaths:SVNHashMap;
		private var myRevisionProperties:SVNProperties;
		private var myHasChildren:Boolean;

		public function SVNLogEntry( changedPaths:SVNHashMap, revision:int,  revisionProperties:SVNProperties, hasChildren:Boolean) 
		{
			myRevision = revision;
			myChangedPaths = changedPaths;
			myRevisionProperties = revisionProperties != null ? revisionProperties : new SVNProperties( );
			myHasChildren = hasChildren;
		}

		public function setHasChildren( hasChildren:Boolean ):void 
		{
			myHasChildren = hasChildren;
		}

		public function getChangedPaths():SVNHashMap 
		{
			return myChangedPaths;
		}

		public function getAuthor():String 
		{
			return myRevisionProperties.getStringValue( SVNRevisionProperty.AUTHOR );
		}

		public function getDate():SVNDate 
		{
			var date:String = myRevisionProperties.getStringValue( SVNRevisionProperty.DATE );
			return date == null ? null : SVNDate.parseDate( date );
		}

		public function getMessage():String 
		{
			return myRevisionProperties.getStringValue( SVNRevisionProperty.LOG );
		}

		public function getRevisionProperties():SVNProperties 
		{
			return myRevisionProperties;
		}

		public function getRevision():int 
		{
			return myRevision;
		}

		public function equals( obj:Object ):Boolean 
		{
			if (this == obj) 
			{
				return true;
			}
			if (obj == null || !( obj is SVNLogEntry ) ) 
			{
				return false;
			}
			var other:SVNLogEntry = obj as SVNLogEntry;
			return myRevision == other.myRevision && compare( myRevisionProperties, other.myRevisionProperties ) && compare( myChangedPaths, other.myChangedPaths );
		}

		public function toString():String 
		{
			var result:String = '';
			result += myRevision;
        
			var propNames:Array = myRevisionProperties.nameSet( );
        
			var i:int = 0;
			for (i = 0; i < propNames.length; i++ ) 
			{
				var propName:String = propNames[ i ] as String;
				var propVal:SVNPropertyValue = myRevisionProperties.getSVNPropertyValue( propName );
				result += '\n';
				result += propName;
				result += '=';
				result += propVal.toString( );
			}
        
			if (myChangedPaths != null && !myChangedPaths.isEmpty( ) ) 
			{
           
				var values:Array = myChangedPaths.values( );
           
				for (i = 0; i < values.length; i++) 
				{
					result += '\n';
					var path:SVNLogEntryPath = values[ i ] as SVNLogEntryPath;
					result += path.toString( );
				}
			}
			return result;
		}

		public function hasChildren():Boolean 
		{
			return myHasChildren;
		}

		public static function compare( o1:Object, o2:Object ):Boolean 
		{
			if (o1 == null) 
			{
				return o2 == null;
			} 
			return o1.equals( o2 );
		}
	}
}
