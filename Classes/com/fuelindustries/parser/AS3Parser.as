package com.fuelindustries.parser 
{
	import com.fuelindustries.lang.Character;

	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 * @author julian
	 */
	public class AS3Parser 
	{
		
		public static function parse( contents:ByteArray ):void
		{
			
			contents = removeBlockComments( contents );
			contents = removeLineComments( contents );

			var dataTypes:Array = readDataTypes( contents );
			var imports:Array = readImports( contents );
			
			trace( dataTypes );
			trace( imports );
		}
		
		private static function readImports( contents:ByteArray ):Array
		{
			var imports:Array = [];
			contents.position = 0;
			var str:String = contents.readUTFBytes(contents.bytesAvailable);
			
			var split:Array = str.split( "import " );
			
			for( var i:int = 1; i<split.length; i++ )
			{
				var classname:String = "";
				var result:String = split[ i ] as String;
				var counter:int = 0;
				var foundvalidchar:Boolean = false;
				
				while( true )
				{
					var ch:String = result.charAt(counter);
					
					var isvalidchar:Boolean = Character.isLetterOrDigit(ch);
					if( ch == "." || ch == "*") isvalidchar = true;
					
					if( !foundvalidchar && !isvalidchar)
					{
						counter++;
						continue;		
					}
					
					
					if( isvalidchar )
					{
						foundvalidchar = true;
						classname += ch;
						counter++;
						continue;	
					}
					
					imports.push( classname );
					
					break;
				}
			}

			return ( removeDuplicates( imports ) );		
		}
		
		private static function readDataTypes( contents:ByteArray ):Array
		{
			var dependencies:Array = [];

			contents.position = 0;
			var str:String = contents.readUTFBytes(contents.bytesAvailable);
			
			var split:Array = str.split( ":" );
			
			for( var i:int = 1; i<split.length; i++ )
			{
				var classname:String = "";
				var result:String = split[ i ] as String;
				var counter:int = 0;
				var foundvalidchar:Boolean = false;
				
				while( true )
				{
					var ch:String = result.charAt(counter);
					
					var isvalidchar:Boolean = Character.isLetterOrDigit(ch);
					
					if( ch == "*" )
					{
						break;	
					}
					
					if( !foundvalidchar && !isvalidchar)
					{
						counter++;
						continue;		
					}
					
					
					if( isvalidchar )
					{
						foundvalidchar = true;
						classname += ch;
						counter++;
						continue;	
					}
					
					dependencies.push( classname );
					
					break;
				}
			}
			
			
			
			return( removeDuplicates( dependencies ) );
		}
		
		private static function removeBlockComments( contents:ByteArray ):ByteArray
		{
			contents.position = 0;
			var str:String = contents.readUTFBytes(contents.bytesAvailable);
			
			var split:Array = str.split( "/**" );
			
			for( var i:int = 1; i<split.length; i++ )
			{
				var result:String = split[ i ] as String;
				var counter:int = 0;
				var lastchar:String = "";
				
				while( true )
				{
					var ch:String = result.charAt(counter);
					
					if( lastchar == "*" && ch == "/" )
					{
						break;		
					}
					lastchar = ch;
					counter++;
				}
				
				split[ i ] = result.substring( counter+1 );
			}
			
			var ba:ByteArray = new ByteArray();
			ba.writeUTFBytes(split.join( "" ));
			
			return( ba );
		}
		
		private static function removeLineComments( contents:ByteArray ):ByteArray
		{
			contents.position = 0;
			var str:String = contents.readUTFBytes(contents.bytesAvailable);
			
			var lastchar:String = "";
			var startindex:int = -1;
			
			var result:String = "";
			
			for( var i:int = 0; i<str.length; i++ )
			{
				var ch:String = str.charAt(i);

				if( lastchar == "/" && ch == "/" && startindex == -1 )
				{
					startindex = i;
				}
				
				if( ch == "\n" || ch == "\r" )
				{
					startindex = -1;	
				}
				
				if( startindex >= 0 )
				{
					result += "";
				}
				else
				{
					if( ch == "/" && str.charAt( i + 1 ) == "/" )
					{
						result += "";	
					}
					else
					{
						result += ch;
					}
				}
				
				lastchar = ch;
			}
			
			var ba:ByteArray = new ByteArray();
			ba.writeUTFBytes( result );
			
			return( ba );

		}
		
		private static function removeDuplicates(haystack:Array):Array
		{

			var dict:Dictionary = new Dictionary( true );
			var output:Array = new Array( );
			var item:*;
			var total:int = haystack.length;
			var pointer:int = 0;
			for(pointer; pointer < total ; pointer++) 
			{
				item = haystack[pointer];
				if(dict[item] == undefined) 
				{
					output.push( item );
					dict[item] = true;
				}
			}
			return output;     
		}
	}
}
