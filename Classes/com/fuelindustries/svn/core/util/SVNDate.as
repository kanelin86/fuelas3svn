package com.fuelindustries.svn.core.util 
{

	/**
	 * @author julian
	 */
	public class SVNDate
	{
		public static const DATE_SEPARATORS:Array = [ '-', '-', 'T', ':', ':', '.', 'Z' ];

		public static function parseDate( str:String ):SVNDate 
		{
			if (str == null) 
			{
				return null;
			}
			return parseDatestamp( str );
		}

		public static function formatDate( date:Date, formatZeroDate:Boolean = false ):String
		{
			if (date == null) 
			{
				return null;
			} else if (!formatZeroDate && date.getTime( ) == 0) 
			{
				return null;
			}
        
			if (date is SVNDate) 
			{
				var extendedDate:SVNDate = date as SVNDate;
				return( extendedDate.format( ) );
			}
			else
			{
				var svndate:SVNDate = new SVNDate( );
				svndate.setDate( date );
				return( svndate.format( ) );	
			}
		}

		private static function parseDatestamp( str:String ):SVNDate 
		{
			if (str == null) 
        {
            //TODO Implement Error
            //SVNErrorMessage err = SVNErrorMessage.create(SVNErrorCode.BAD_DATE);
            //SVNErrorManager.error(err, SVNLogType.DEFAULT);
        }

			var index:int = 0;
			var charIndex:int = 0;
			var startIndex:int = 0;
			var result:Array = [];//array of ints
			var microseconds:int = 0;
        var timeZoneInd:int = -1;
        
        var segment:String;
        
        
        while (index < DATE_SEPARATORS.length && charIndex < str.length ) 
        {
            if (str.charAt(charIndex) == "-") {
                if (index > 1) {
                    timeZoneInd = charIndex;
                }
            } else if (str.charAt(charIndex) == "+") {
                timeZoneInd = charIndex;
            }
            if (str.charAt(charIndex) == DATE_SEPARATORS[index] ||
                    (index == 5 && str.charAt(charIndex) == DATE_SEPARATORS[index + 1])) {
                if (index == 5 && str.charAt(charIndex) == DATE_SEPARATORS[index + 1]) {
                    index++;
                }
        
                
                segment = str.substring(startIndex, charIndex);
                
                if (segment.length == 0) {
                    result[index] = 0;
                } else if (index + 1 < DATE_SEPARATORS.length) {
                    result[index] = parseInt(segment);
                } else {
                    result[index] = parseInt(segment.substring(0, Math.min(3, segment.length)));
                    if (segment.length > 3) {
                        microseconds = parseInt(segment.substring(3));
                    }
                }
                startIndex = charIndex + 1;
                index++;
            }
            charIndex++;
        }
        
        if (index < DATE_SEPARATORS.length) {
            segment = str.substring(startIndex);
            if (segment.length == 0) {
                result[index] = 0;
            } else {
                result[index] = parseInt(segment);
            }
        }

        var year:int = result[0] as int;
        var month:int = result[1] as int;
        var date:int = result[2] as int;

        var hour:int = result[3] as int;
        var min:int = result[4] as int;
        var sec:int = result[5] as int;
        var ms:int = result[6] as int;

        var timeZoneId:String;
        if (timeZoneInd != -1 && timeZoneInd < str.length - 1 && str.indexOf("Z") == -1 && str.indexOf("z") == -1) {
            timeZoneId = "GMT" + str.substring(timeZoneInd);
        }
        
        return new SVNDate( year, month - 1, date, hour, min, sec, ms );
		}
    	
    	
    	private var __date:Date;
    	
	    public function SVNDate(year:* = undefined, month:* = undefined, date:* = undefined, hours:* = undefined, minutes:* = undefined, seconds:* = undefined, ms:* = undefined)
	    {
	    	__date = new Date( year, month, date, hours, minutes, seconds, ms );	
	    }
	    
	    public function setDate( d:Date ):void
	    {
			__date = d;    	
		}
	    
	    public function getDate():Date
	    {
	    	return( __date );	
		}

		public function format():String 
		{
			//"yyyy-MM-dd'T'HH:mm:ss.SSS"
			var date:Date = getDate( );
			var dateString:String = date.getFullYear( ) + "-" + ( date.getMonth( ) + 1 ) + "-" + date.getDate( ) + "T" + date.getHours( ) + ":" + date.getMinutes( ) + ":" + date.getSeconds( ) + "." + date.getMilliseconds( ) + "Z";
			return( dateString );
		}
	}
}
