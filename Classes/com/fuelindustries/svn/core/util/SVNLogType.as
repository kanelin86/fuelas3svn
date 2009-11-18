package com.fuelindustries.svn.core.util 
{

	/**
	 * @author julian
	 */
	public class SVNLogType 
	{
		public static const  NETWORK:SVNLogType = new SVNLogType( "svnkit-network", "NETWORK" );
		public static const WC:SVNLogType = new SVNLogType( "svnkit-wc", "WC" );
		public static const FSFS:SVNLogType = new SVNLogType( "svnkit-fsfs", "FSFS" );
		public static const CLIENT:SVNLogType = new SVNLogType( "svnkit-cli", "CLI" );
		public static const DEFAULT:SVNLogType = new SVNLogType( "svnkit", "DEFAULT" );
		
		private var myName:String;
		private var myShortName:String;

		public function SVNLogType( name:String, shortName:String ) 
		{
			myName = name;
			myShortName = shortName;
		}

		public function getName():String 
		{
			return myName;
		}

		public function getShortName():String 
		{
			return myShortName;
		}
	}
}
