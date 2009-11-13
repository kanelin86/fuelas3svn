package com.fuelindustries.svn.core 
{

	/**
	 * @author julian
	 */
	public class SVNProperty 
	{
		public static var SVN_PREFIX:String = "svn:";
		public static var SVNKIT_PREFIX:String = "svnkit:";

		public static function isSVNProperty( name:String ):Boolean 
		{
			return name != null && ( StringUtils.startsWith( name, SVN_PREFIX ) || StringUtils.startsWith( name, SVNKIT_PREFIX ));
		}
	}
}
