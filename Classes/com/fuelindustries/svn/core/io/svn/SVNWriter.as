package com.fuelindustries.svn.core.io.svn 
{
	import com.fuelindustries.svn.core.SVNProperties;
	import com.fuelindustries.svn.core.util.SVNDate;

	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 * @author julian
	 */
	public class SVNWriter 
	{
		
		public static function write( template:String, src:Array ):ByteArray
		{
			var os:ByteArray = new ByteArray();
			
			var offset:int = 0;
			for (var i:int = 0; i < template.length; i++) 
			{
                var ch:String = template.charAt(i);
                if (ch == "(" || ch == ")") 
                {
                    os.writeByte( ch.charCodeAt() );
                    os.writeByte( ' '.charCodeAt() );
                    continue;
                }
                
                var item:Object = src[offset++];
                
                if (item == null) 
                {
                    if (ch == "*" || ch == "?") 
                    {
                        i++;
                    }
                    continue;
                }
                
                if(item is Date) 
                {
                    item = SVNDate.formatDate(item as Date, true);
                }
                
                
                if (ch == "i") 
                {

                    //TODO implement i write template
                    
                    /*
                    InputStream is = ((SVNDataSource) item).getInputStream();
                    long length = ((SVNDataSource) item).lenght();

                    os.write(Long.toString(length).getBytes("UTF-8"));
                    os.write(':');
                    byte[] buffer = new byte[Math.min(2048, (int) length)];
                    while (true) {
                        int read = is.read(buffer);
                        if (read > 0) {
                            os.write(buffer, 0, read);
                        } else {
                            break;
                        }
                    }
                    */
                    
                    throw new Error( "i write template not implemented. not sure what to do here" );
                }
                
                if (ch == "b") 
                {
                   var bytes:ByteArray = item as ByteArray;
                    os.writeBytes( StringUtils.getBytes( bytes.length.toString() ) );
                    os.writeByte( ':'.charCodeAt() );
                    os.writeBytes(bytes);
                    
                } 
                else if (ch == "n") 
                {
                     os.writeBytes( StringUtils.getBytes( item.toString() ) );
                } 
                else if (ch == "w") 
                {
                    os.writeBytes( StringUtils.getBytes( item.toString() ) );
                } 
                else if (ch == "s") 
                {
                    
                    var s:ByteArray = StringUtils.getBytes( item.toString() ); 
                    os.writeBytes( StringUtils.getBytes( s.length.toString() ) );
                    os.writeByte( ":".charCodeAt() );
                    os.writeBytes( s );
                    
                } 
                else if (ch == "*") 
                {
                    ch = template.charAt(i + 1);
                    
                    if (item is Array ) 
                    {
                        var list:Array = item as Array;
                        
                        for (var j:int = 0; j < list.length; j++) 
                        {
                            if (ch == "s") 
                            {
                                var sstar:ByteArray = StringUtils.getBytes( list[j].toString() ); 
                    			os.writeBytes( StringUtils.getBytes( sstar.length.toString() ) );
                    			os.writeByte( ":".charCodeAt() );
                    			os.writeBytes( sstar );   
                            } 
                            else if (ch == "w") 
                            {
                                os.writeBytes( StringUtils.getBytes( list[j].toString() ) );
                            }
                            os.writeByte( ' '.charCodeAt() );
                        }
                    } 
                    else if (item is Array && ch == "n") 
                    {
                        var nlist:Array = item as Array;
                        for (var n:int = 0; n < nlist.length; n++) 
                        {
                            os.writeBytes( StringUtils.getBytes( Number( nlist[n] ).toString() ) );
                            os.writeByte( ' '.charCodeAt() );
                        }
                    }
                    else if (item is Dictionary && ch == "l") 
                    {
                        var map:Dictionary = item as Dictionary;
                        
                        for( var key:String in map )
                        {
                        	var	path:String = map[ key ] as String;
                        	os.writeByte('('.charCodeAt());
                            os.writeByte(' '.charCodeAt());
                            os.writeBytes( StringUtils.getBytes( StringUtils.getBytes( path ).length.toString() ) );
                            os.writeByte(':'.charCodeAt());
                            os.writeBytes(StringUtils.getBytes( path ));
                            os.writeByte(' '.charCodeAt());
                            os.writeBytes(StringUtils.getBytes( StringUtils.getBytes( key ).length.toString() ));
                            os.writeByte(':'.charCodeAt());
                            os.writeBytes(StringUtils.getBytes( key ));
                            os.writeByte(' '.charCodeAt());
                            os.writeByte(')'.charCodeAt());
                            os.writeByte(' '.charCodeAt());
                        }
                        
                        
                        
                    } 
                    else if (item is SVNProperties && ch == "l") 
                    {
                        //TODO implement writer SVNProperties
                        /*
                        SVNProperties props = (SVNProperties) item;
                        for (Iterator iterator = props.nameSet().iterator(); iterator.hasNext();) {
                            String name = (String) iterator.next();
                            SVNPropertyValue value = props.getSVNPropertyValue(name);
                            os.write('(');
                            os.write(' ');
                            os.write(Integer.toString(name.getBytes("UTF-8").length).getBytes("UTF-8"));
                            os.write(':');
                            os.write(name.getBytes("UTF-8"));
                            os.write(' ');
                            byte[] bytes = SVNPropertyValue.getPropertyAsBytes(value);
                            os.write(Integer.toString(bytes.length).getBytes("UTF-8"));
                            os.write(':');
                            os.write(bytes);
                            os.write(' ');
                            os.write(')');
                            os.write(' ');
                        }
                        */
                        
                        throw new Error( "SVNProperties not implemented in SVNWriter ");
                    }
                    i++;
                }
                os.writeByte(' '.charCodeAt());
            }
			
			
			return( os );
		}
	}
}
