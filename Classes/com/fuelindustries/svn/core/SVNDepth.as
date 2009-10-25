package com.fuelindustries.svn.core 
{
	import flash.utils.getQualifiedClassName;

	/**
	 * @author julian
	 */
	public class SVNDepth 
	{
		public static var  UNKNOWN:SVNDepth = new SVNDepth( -2, "unknown" ); 
		public static var EXCLUDE:SVNDepth = new SVNDepth( -1, "exclude" ); 
		public static var EMPTY:SVNDepth = new SVNDepth( 0, "empty" ); 
		public static var FILES:SVNDepth = new SVNDepth( 1, "files" ); 
		public static var IMMEDIATES:SVNDepth = new SVNDepth( 2, "immediates" ); 
		public static var INFINITY:SVNDepth = new SVNDepth( 3, "infinity" ); 
		private var myId:int;
		private var myName:String;

		public function SVNDepth( id:int, name:String ) 
		{
			myId = id;
			myName = name;
		}

		public function getId():int 
		{
			return myId;
		}

		public function getName():String
		{
			return myName;
		}

		public function toString():String
		{
			return getName( );
		}

		public function isRecursive():Boolean
		{
			return this.equals( INFINITY ) || this.equals( UNKNOWN );
		}

		public function compareTo( o:Object ):int
		{
			if (o == null || getQualifiedClassName( o ) != getQualifiedClassName( SVNDepth ) ) 
			{
				return -1;
			}
	        
			var otherDepth:SVNDepth = o as SVNDepth;
			return myId == otherDepth.myId ? 0 : (myId > otherDepth.myId ? 1 : -1);
		}

		public function equals( obj:Object ):Boolean 
		{
			return compareTo( obj ) == 0;
		}

		public static function asString( depth:SVNDepth):String
		{
			if (depth != null) 
			{
				return depth.getName( );
			}
        	 
			return "INVALID-DEPTH";
		}

		public static function recurseFromDepth( depth:SVNDepth ):Boolean 
		{
			return depth == null || depth.equals( INFINITY ) || depth.equals( UNKNOWN );
		}

		public static function fromRecurse( recurse:Boolean ):SVNDepth
		{
			return recurse ? INFINITY : FILES;
		}

		public static function fromString( string:String ):SVNDepth
		{
			if (EMPTY.getName( ) == string ) 
			{
				return EMPTY;
			} 
	        else if (EXCLUDE.getName( ) == string ) 
			{
				return EXCLUDE;
			} 
	        else if (FILES.getName( ) == string ) 
			{
				return FILES;
			} 
	        else if (IMMEDIATES.getName( ) == string ) 
			{
				return IMMEDIATES;
			} 
	        else if (INFINITY.getName( ) == string ) 
			{
				return INFINITY;
			} 
			else 
			{
				return UNKNOWN;
			}
		}

		public function  fromID( id:int ):SVNDepth 
		{ 
			switch (id) 
			{
				case 3:
					return INFINITY;
				case 2:
					return IMMEDIATES;
				case 1:
					return FILES;
				case 0:
					return EMPTY;
				case -1:
					return EXCLUDE;
				case -2:
				default:
					return UNKNOWN;
			}
		}

		public static function getInfinityOrEmptyDepth(recurse:Boolean):SVNDepth 
		{
			return recurse ? INFINITY : EMPTY;
		}

		public static function getInfinityOrFilesDepth(recurse:Boolean):SVNDepth 
		{
			return recurse ? INFINITY : FILES;
		}

		public static function getInfinityOrImmediatesDepth(recurse:Boolean):SVNDepth 
		{
			return recurse ? INFINITY : IMMEDIATES;
		}

		public static function getUnknownOrEmptyDepth(recurse:Boolean):SVNDepth 
		{
			return recurse ? UNKNOWN : EMPTY;
		}

		public static function getUnknownOrFilesDepth(recurse:Boolean):SVNDepth 
		{
			return recurse ? UNKNOWN : FILES;
		}

		public static function getUnknownOrImmediatesDepth(recurse:Boolean):SVNDepth 
		{
			return recurse ? UNKNOWN : IMMEDIATES;
		}
	}
}
