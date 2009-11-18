package com.fuelindustries.svn.core.errors 
{
	import flash.utils.Dictionary;

	/**
	 * @author julian
	 */
	public class SVNErrorCode 
	{
		private var myDescription:String;
		private var myCategory:int;
		private var myCode:int;
		private static var ourErrorCodes:Dictionary = new Dictionary( );

		public static function getErrorCode(code:int):SVNErrorCode 
		{
			var errorCode:SVNErrorCode = ourErrorCodes[ code ] as SVNErrorCode;
			if (errorCode == null) 
			{
				errorCode = UNKNOWN;
			}
			return errorCode;
		}

		//this should never get called outside of this class
		//use the statics below.
		public function SVNErrorCode( category:int, index:int, description:String) 
		{
			myCategory = category;
			myCode = category + index;
			myDescription = description;
			ourErrorCodes[ myCode ] = this;
		}

		public function getCode():int 
		{
			return myCode;
		}

		public function getCategory():int 
		{
			return myCategory;
		}

		public function getDescription():String 
		{
			return myDescription;
		}

		public function hashCode():int 
		{
			return myCode;
		}

		public function equals( o:Object ):Boolean 
		{
			if (o == null || o is SVNErrorCode ) 
			{
				return false;
			}
			return myCode == SVNErrorCode( o ).myCode;
		}

		public function isAuthentication():Boolean 
		{
			return this.equals( RA_NOT_AUTHORIZED ) || this.equals( RA_UNKNOWN_AUTH ) || getCategory( ) == AUTHZ_CATEGORY || getCategory( ) == AUTHN_CATEGORY;
		}

		public function toString():String 
		{
			return myCode + ": " + myDescription;
		}

		private static const ERR_BASE:int = 120000;
		private static const ERR_CATEGORY_SIZE:int = 5000;
		public static const BAD_CATEGORY:int = ERR_BASE + 1 * ERR_CATEGORY_SIZE;
		public static const XML_CATEGORY:int = ERR_BASE + 2 * ERR_CATEGORY_SIZE;
		public static const IO_CATEGORY:int = ERR_BASE + 3 * ERR_CATEGORY_SIZE;
		public static const STREAM_CATEGORY:int = ERR_BASE + 4 * ERR_CATEGORY_SIZE;
		public static const NODE_CATEGORY:int = ERR_BASE + 5 * ERR_CATEGORY_SIZE;
		public static const ENTRY_CATEGORY:int = ERR_BASE + 6 * ERR_CATEGORY_SIZE;
		public static const WC_CATEGORY:int = ERR_BASE + 7 * ERR_CATEGORY_SIZE;
		public static const FS_CATEGORY:int = ERR_BASE + 8 * ERR_CATEGORY_SIZE;
		public static const REPOS_CATEGORY:int = ERR_BASE + 9 * ERR_CATEGORY_SIZE;
		public static const RA_CATEGORY:int = ERR_BASE + 10 * ERR_CATEGORY_SIZE;
		public static const RA_DAV_CATEGORY:int = ERR_BASE + 11 * ERR_CATEGORY_SIZE;
		public static const RA_LOCAL_CATEGORY:int = ERR_BASE + 12 * ERR_CATEGORY_SIZE;
		public static const SVNDIFF_CATEGORY:int = ERR_BASE + 13 * ERR_CATEGORY_SIZE;
		public static const APMOD_CATEGORY:int = ERR_BASE + 14 * ERR_CATEGORY_SIZE;
		public static const CLIENT_CATEGORY:int = ERR_BASE + 15 * ERR_CATEGORY_SIZE;
		public static const MISC_CATEGORY:int = ERR_BASE + 16 * ERR_CATEGORY_SIZE;
		public static const CL_CATEGORY:int = ERR_BASE + 17 * ERR_CATEGORY_SIZE;
		public static const RA_SVN_CATEGORY:int = ERR_BASE + 18 * ERR_CATEGORY_SIZE;
		public static const AUTHN_CATEGORY:int = ERR_BASE + 19 * ERR_CATEGORY_SIZE;
		public static const AUTHZ_CATEGORY:int = ERR_BASE + 20 * ERR_CATEGORY_SIZE;
		public static const UNKNOWN:SVNErrorCode = new SVNErrorCode( MISC_CATEGORY, ERR_CATEGORY_SIZE - 100, "Unknown error" );
		public static const IO_ERROR:SVNErrorCode = new SVNErrorCode( MISC_CATEGORY, ERR_CATEGORY_SIZE - 101, "Generic IO error" );
		public static const BAD_CONTAINING_POOL:SVNErrorCode = new SVNErrorCode( BAD_CATEGORY, 0, "Bad parent pool passed to svn_make_pool()" );
		public static const BAD_FILENAME:SVNErrorCode = new SVNErrorCode( BAD_CATEGORY, 1, "Bogus filename" );
		public static const BAD_URL:SVNErrorCode = new SVNErrorCode( BAD_CATEGORY, 2, "Bogus URL" );
		public static const BAD_DATE:SVNErrorCode = new SVNErrorCode( BAD_CATEGORY, 3, "Bogus date" );
		public static const BAD_MIME_TYPE:SVNErrorCode = new SVNErrorCode( BAD_CATEGORY, 4, "Bogus mime-type" );
		public static const BAD_PROPERTY_VALUE:SVNErrorCode = new SVNErrorCode( BAD_CATEGORY, 5, "Wrong or unexpected property value" );
		public static const BAD_VERSION_FILE_FORMAT:SVNErrorCode = new SVNErrorCode( BAD_CATEGORY, 6, "Version file format not correct" );
		public static const BAD_RELATIVE_PATH:SVNErrorCode = new SVNErrorCode( BAD_CATEGORY, 7, "Path is not an immediate child of the specified directory" );
		/**
		 * @since 1.2.0, SVN 1.5
		 */
		public static const BAD_UUID:SVNErrorCode = new SVNErrorCode( BAD_CATEGORY, 8, "Bogus UUID" );
		public static const XML_ATTRIB_NOT_FOUND:SVNErrorCode = new SVNErrorCode( XML_CATEGORY, 0, "No such XML tag attribute" );
		public static const XML_MISSING_ANCESTRY:SVNErrorCode = new SVNErrorCode( XML_CATEGORY, 1, "<delta-pkg> is missing ancestry" );
		public static const XML_UNKNOWN_ENCODING:SVNErrorCode = new SVNErrorCode( XML_CATEGORY, 2, "Unrecognized binary data encoding; can't decode" );
		public static const XML_MALFORMED:SVNErrorCode = new SVNErrorCode( XML_CATEGORY, 3, "XML data was not well-formed" );
		public static const XML_UNESCAPABLE_DATA:SVNErrorCode = new SVNErrorCode( XML_CATEGORY, 4, "Data cannot be safely XML-escaped" );
		public static const IO_INCONSISTENT_EOL:SVNErrorCode = new SVNErrorCode( IO_CATEGORY, 0, "Inconsistent line ending style" );
		public static const IO_UNKNOWN_EOL:SVNErrorCode = new SVNErrorCode( IO_CATEGORY, 1, "Unrecognized line ending style" );
		public static const IO_CORRUPT_EOL:SVNErrorCode = new SVNErrorCode( IO_CATEGORY, 2, "Line endings other than expected" );
		public static const IO_UNIQUE_NAMES_EXHAUSTED:SVNErrorCode = new SVNErrorCode( IO_CATEGORY, 3, "Ran out of unique names" );
		public static const IO_PIPE_FRAME_ERROR:SVNErrorCode = new SVNErrorCode( IO_CATEGORY, 4, "Framing error in pipe protocol" );
		public static const IO_PIPE_READ_ERROR:SVNErrorCode = new SVNErrorCode( IO_CATEGORY, 5, "Read error in pipe" );
		public static const IO_WRITE_ERROR:SVNErrorCode = new SVNErrorCode( IO_CATEGORY, 6, "Write error" );
		public static const STREAM_UNEXPECTED_EOF:SVNErrorCode = new SVNErrorCode( STREAM_CATEGORY, 0, "Unexpected EOF on stream" );
		public static const STREAM_MALFORMED_DATA:SVNErrorCode = new SVNErrorCode( STREAM_CATEGORY, 1, "Malformed stream data" );
		public static const STREAM_UNRECOGNIZED_DATA:SVNErrorCode = new SVNErrorCode( STREAM_CATEGORY, 2, "Unrecognized stream data" );
		public static const NODE_UNKNOWN_KIND:SVNErrorCode = new SVNErrorCode( NODE_CATEGORY, 0, "Unknown svn_node_kind" );
		public static const NODE_UNEXPECTED_KIND:SVNErrorCode = new SVNErrorCode( NODE_CATEGORY, 1, "Unexpected node kind found" );
		public static const ENTRY_NOT_FOUND:SVNErrorCode = new SVNErrorCode( ENTRY_CATEGORY, 0, "Can't find an entry" );
		public static const ENTRY_EXISTS:SVNErrorCode = new SVNErrorCode( ENTRY_CATEGORY, 2, "Entry already exists" );
		public static const ENTRY_MISSING_REVISION:SVNErrorCode = new SVNErrorCode( ENTRY_CATEGORY, 3, "Entry has no revision" );
		public static const ENTRY_MISSING_URL:SVNErrorCode = new SVNErrorCode( ENTRY_CATEGORY, 4, "Entry has no URL" );
		public static const ENTRY_ATTRIBUTE_INVALID:SVNErrorCode = new SVNErrorCode( ENTRY_CATEGORY, 5, "Entry has an invalid attribute" );
		public static const WC_OBSTRUCTED_UPDATE:SVNErrorCode = new SVNErrorCode( WC_CATEGORY, 0, "Obstructed update" );
		public static const WC_UNWIND_MISMATCH:SVNErrorCode = new SVNErrorCode( WC_CATEGORY, 1, "Mismatch popping the WC unwind stack" );
		public static const WC_UNWIND_EMPTY:SVNErrorCode = new SVNErrorCode( WC_CATEGORY, 2, "Attempt to pop empty WC unwind stack" );
		public static const WC_UNWIND_NOT_EMPTY:SVNErrorCode = new SVNErrorCode( WC_CATEGORY, 3, "Attempt to unlock with non-empty unwind stack" );
		public static const WC_LOCKED:SVNErrorCode = new SVNErrorCode( WC_CATEGORY, 4, "Attempted to lock an already-locked dir" );
		public static const WC_NOT_LOCKED:SVNErrorCode = new SVNErrorCode( WC_CATEGORY, 5, "Working copy not locked; this is probably a bug, please report" );
		public static const WC_INVALID_LOCK:SVNErrorCode = new SVNErrorCode( WC_CATEGORY, 6, "Invalid lock" );
		public static const WC_NOT_DIRECTORY:SVNErrorCode = new SVNErrorCode( WC_CATEGORY, 7, "Path is not a working copy directory" );
		public static const WC_NOT_FILE:SVNErrorCode = new SVNErrorCode( WC_CATEGORY, 8, "Path is not a working copy file" );
		public static const WC_BAD_ADM_LOG:SVNErrorCode = new SVNErrorCode( WC_CATEGORY, 9, "Problem running log" );
		public static const WC_PATH_NOT_FOUND:SVNErrorCode = new SVNErrorCode( WC_CATEGORY, 10, "Can't find a working copy path" );
		public static const WC_NOT_UP_TO_DATE:SVNErrorCode = new SVNErrorCode( WC_CATEGORY, 11, "Working copy is not up-to-date" );
		public static const WC_LEFT_LOCAL_MOD:SVNErrorCode = new SVNErrorCode( WC_CATEGORY, 12, "Left locally modified or unversioned files" );
		public static const WC_SCHEDULE_CONFLICT:SVNErrorCode = new SVNErrorCode( WC_CATEGORY, 13, "Unmergeable scheduling requested on an entry" );
		public static const WC_PATH_FOUND:SVNErrorCode = new SVNErrorCode( WC_CATEGORY, 14, "Found a working copy path" );
		public static const WC_FOUND_CONFLICT:SVNErrorCode = new SVNErrorCode( WC_CATEGORY, 15, "A conflict in the working copy obstructs the current operation" );
		public static const WC_CORRUPT:SVNErrorCode = new SVNErrorCode( WC_CATEGORY, 16, "Working copy is corrupt" );
		public static const WC_CORRUPT_TEXT_BASE:SVNErrorCode = new SVNErrorCode( WC_CATEGORY, 17, "Working copy text base is corrupt" );
		public static const WC_NODE_KIND_CHANGE:SVNErrorCode = new SVNErrorCode( WC_CATEGORY, 18, "Cannot change node kind" );
		public static const WC_INVALID_OP_ON_CWD:SVNErrorCode = new SVNErrorCode( WC_CATEGORY, 19, "Invalid operation on the current working directory" );
		public static const WC_BAD_ADM_LOG_START:SVNErrorCode = new SVNErrorCode( WC_CATEGORY, 20, "Problem on first log entry in a working copy" );
		public static const WC_UNSUPPORTED_FORMAT:SVNErrorCode = new SVNErrorCode( WC_CATEGORY, 21, "Unsupported working copy format" );
		public static const WC_BAD_PATH:SVNErrorCode = new SVNErrorCode( WC_CATEGORY, 22, "Path syntax not supported in this context" );
		public static const WC_INVALID_SCHEDULE:SVNErrorCode = new SVNErrorCode( WC_CATEGORY, 23, "Invalid schedule" );
		public static const WC_INVALID_RELOCATION:SVNErrorCode = new SVNErrorCode( WC_CATEGORY, 24, "Invalid relocation" );
		public static const WC_INVALID_SWITCH:SVNErrorCode = new SVNErrorCode( WC_CATEGORY, 25, "Invalid switch" );
		/**
		 * @since 1.2.0, SVN 1.5
		 */
		public static const WC_MISMATCHED_CHANGELIST:SVNErrorCode = new SVNErrorCode( WC_CATEGORY, 26, "Changelist doesn't match" );
		/**
		 * @since 1.2.0, SVN 1.5
		 */
		public static const WC_CONFLICT_RESOLVER_FAILURE:SVNErrorCode = new SVNErrorCode( WC_CATEGORY, 27, "Conflict resolution failed" );
		/**
		 * @since 1.2.0, SVN 1.5
		 */
		public static const WC_COPYFROM_PATH_NOT_FOUND:SVNErrorCode = new SVNErrorCode( WC_CATEGORY, 28, "Failed to locate 'copyfrom' path in working copy" );
		/**
		 * @since 1.2.0, SVN 1.5
		 */
		public static const WC_CHANGELIST_MOVE:SVNErrorCode = new SVNErrorCode( WC_CATEGORY, 29, "Moving a path from one changelist to another" );
		/**
		 * @since 1.3, SVN 1.6
		 */
		public static const WC_CANNOT_DELETE_FILE_EXTERNAL:SVNErrorCode = new SVNErrorCode( WC_CATEGORY, 30, "Cannot delete a file external" );
		/**
		 * @since 1.3, SVN 1.6
		 */
		public static const WC_CANNOT_MOVE_FILE_EXTERNAL:SVNErrorCode = new SVNErrorCode( WC_CATEGORY, 31, "Cannot move a file external" );
		public static const FS_GENERAL:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 0, "General filesystem error" );
		public static const FS_CLEANUP:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 1, "Error closing filesystem" );
		public static const FS_ALREADY_OPEN:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 2, "Filesystem is already open" );
		public static const FS_NOT_OPEN:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 3, "Filesystem is not open" );
		public static const FS_CORRUPT:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 4, "Filesystem is corrupt" );
		public static const FS_PATH_SYNTAX:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 5, "Invalid filesystem path syntax" );
		public static const FS_NO_SUCH_REVISION:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 6, "Invalid filesystem revision number" );
		public static const FS_NO_SUCH_TRANSACTION:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 7, "Invalid filesystem transaction name" );
		public static const FS_NO_SUCH_ENTRY:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 8, "Filesystem directory has no such entry" );
		public static const FS_NO_SUCH_REPRESENTATION:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 9, "Filesystem has no such representation" );
		public static const FS_NO_SUCH_STRING:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 10, "Filesystem has no such string" );
		public static const FS_NO_SUCH_COPY:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 11, "Filesystem has no such copy" );
		public static const FS_TRANSACTION_NOT_MUTABLE:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 12, "The specified transaction is not mutable" );
		public static const FS_NOT_FOUND:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 13, "Filesystem has no item" );
		public static const FS_ID_NOT_FOUND:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 14, "Filesystem has no such node-rev-id" );
		public static const FS_NOT_ID:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 15, "String does not represent a node or node-rev-id" );
		public static const FS_NOT_DIRECTORY:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 16, "Name does not refer to a filesystem directory" );
		public static const FS_NOT_FILE:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 17, "Name does not refer to a filesystem file" );
		public static const FS_NOT_SINGLE_PATH_COMPONENT:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 18, "Name is not a single path component" );
		public static const FS_NOT_MUTABLE:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 19, "Attempt to change immutable filesystem node" );
		public static const FS_ALREADY_EXISTS:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 20, "Item already exists in filesystem" );
		public static const FS_ROOT_DIR:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 21, "Attempt to remove or recreate fs root dir" );
		public static const FS_NOT_TXN_ROOT:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 22, "Object is not a transaction root" );
		public static const FS_NOT_REVISION_ROOT:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 23, "Object is not a revision root" );
		public static const FS_CONFLICT:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 24, "Merge conflict during commit" );
		public static const FS_REP_CHANGED:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 25, "A representation vanished or changed between reads" );
		public static const FS_REP_NOT_MUTABLE:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 26, "Tried to change an immutable representation" );
		public static const FS_MALFORMED_SKEL:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 27, "Malformed skeleton data" );
		public static const FS_TXN_OUT_OF_DATE:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 28, "Transaction is out of date" );
		public static const FS_BERKELEY_DB:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 29, "Berkeley DB error" );
		public static const FS_BERKELEY_DB_DEADLOCK:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 30, "Berkeley DB deadlock error" );
		public static const FS_TRANSACTION_DEAD:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 31, "Transaction is dead" );
		public static const FS_TRANSACTION_NOT_DEAD:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 32, "Transaction is not dead" );
		public static const FS_UNKNOWN_FS_TYPE:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 33, "Unknown FS type" );
		public static const FS_NO_USER:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 34, "No user associated with filesystem" );
		public static const FS_PATH_ALREADY_LOCKED:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 35, "Path is already locked" );
		public static const FS_PATH_NOT_LOCKED:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 36, "Path is not locked" );
		public static const FS_BAD_LOCK_TOKEN:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 37, "Lock token is incorrect" );
		public static const FS_NO_LOCK_TOKEN:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 38, "No lock token provided" );
		public static const FS_LOCK_OWNER_MISMATCH:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 39, "Username does not match lock owner" );
		public static const FS_NO_SUCH_LOCK:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 40, "Filesystem has no such lock" );
		public static const FS_LOCK_EXPIRED:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 41, "Lock has expired" );
		public static const FS_OUT_OF_DATE:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 42, "Item is out of date" );
		public static const FS_UNSUPPORTED_FORMAT:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 43, "Unsupported FS format" );
		public static const FS_REP_BEING_WRITTEN:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 44, "Representation is being written" );
		public static const FS_TXN_NAME_TOO_LONG:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 45, "The generated transaction name is too long" );
		public static const FS_NO_SUCH_NODE_ORIGIN:SVNErrorCode = new SVNErrorCode( FS_CATEGORY, 46, "Filesystem has no such node origin record" );
		public static const REPOS_LOCKED:SVNErrorCode = new SVNErrorCode( REPOS_CATEGORY, 0, "The repository is locked, perhaps for db recovery" );
		public static const REPOS_HOOK_FAILURE:SVNErrorCode = new SVNErrorCode( REPOS_CATEGORY, 1, "A repository hook failed" );
		public static const REPOS_BAD_ARGS:SVNErrorCode = new SVNErrorCode( REPOS_CATEGORY, 2, "Incorrect arguments supplied" );
		public static const REPOS_NO_DATA_FOR_REPORT:SVNErrorCode = new SVNErrorCode( REPOS_CATEGORY, 3, "A report cannot be generated because no data was supplied" );
		public static const REPOS_BAD_REVISION_REPORT:SVNErrorCode = new SVNErrorCode( REPOS_CATEGORY, 4, "Bogus revision report" );
		public static const REPOS_UNSUPPORTED_VERSION:SVNErrorCode = new SVNErrorCode( REPOS_CATEGORY, 5, "Unsupported repository version" );
		public static const REPOS_DISABLED_FEATURE:SVNErrorCode = new SVNErrorCode( REPOS_CATEGORY, 6, "Disabled repository feature" );
		public static const REPOS_POST_COMMIT_HOOK_FAILED:SVNErrorCode = new SVNErrorCode( REPOS_CATEGORY, 7, "Error running post-commit hook" );
		public static const REPOS_POST_LOCK_HOOK_FAILED:SVNErrorCode = new SVNErrorCode( REPOS_CATEGORY, 8, "Error running post-lock hook" );
		public static const REPOS_POST_UNLOCK_HOOK_FAILED:SVNErrorCode = new SVNErrorCode( REPOS_CATEGORY, 9, "Error running post-unlock hook" );
		public static const RA_ILLEGAL_URL:SVNErrorCode = new SVNErrorCode( RA_CATEGORY, 0, "Bad URL passed to RA layer" );
		public static const RA_NOT_AUTHORIZED:SVNErrorCode = new SVNErrorCode( RA_CATEGORY, 1, "Authorization failed" );
		public static const RA_UNKNOWN_AUTH:SVNErrorCode = new SVNErrorCode( RA_CATEGORY, 2, "Unknown authorization method" );
		public static const RA_NOT_IMPLEMENTED:SVNErrorCode = new SVNErrorCode( RA_CATEGORY, 3, "Repository access method not implemented" );
		public static const RA_OUT_OF_DATE:SVNErrorCode = new SVNErrorCode( RA_CATEGORY, 4, "Item is out-of-date" );
		public static const RA_NO_REPOS_UUID:SVNErrorCode = new SVNErrorCode( RA_CATEGORY, 5, "Repository has no UUID" );
		public static const RA_UNSUPPORTED_ABI_VERSION:SVNErrorCode = new SVNErrorCode( RA_CATEGORY, 6, "Unsupported RA plugin ABI version" );
		public static const RA_NOT_LOCKED:SVNErrorCode = new SVNErrorCode( RA_CATEGORY, 7, "Path is not locked" );
		/**
		 * @since  1.2.0, SVN 1.5
		 */
		public static const RA_PARTIAL_REPLAY_NOT_SUPPORTED:SVNErrorCode = new SVNErrorCode( RA_CATEGORY, 8, "Server can only replay from the root of a repository" );
		/**
		 * @since  1.2.0, SVN 1.5
		 */
		public static const RA_UUID_MISMATCH:SVNErrorCode = new SVNErrorCode( RA_CATEGORY, 9, "Repository UUID does not match expected UUID" );
		/**
		 * @since  1.3, SVN 1.6
		 */
		public static const RA_REPOS_ROOT_URL_MISMATCH:SVNErrorCode = new SVNErrorCode( RA_CATEGORY, 10, "Repository root URL does not match expected root URL" );
		public static const RA_DAV_SOCK_INIT:SVNErrorCode = new SVNErrorCode( RA_DAV_CATEGORY, 0, "RA layer failed to init socket layer" );
		public static const RA_DAV_CREATING_REQUEST:SVNErrorCode = new SVNErrorCode( RA_DAV_CATEGORY, 1, "RA layer failed to create HTTP request" );
		public static const RA_DAV_REQUEST_FAILED:SVNErrorCode = new SVNErrorCode( RA_DAV_CATEGORY, 2, "RA layer request failed" );
		public static const RA_DAV_OPTIONS_REQ_FAILED:SVNErrorCode = new SVNErrorCode( RA_DAV_CATEGORY, 3, "RA layer didn't receive requested OPTIONS info" );
		public static const RA_DAV_PROPS_NOT_FOUND:SVNErrorCode = new SVNErrorCode( RA_DAV_CATEGORY, 4, "RA layer failed to fetch properties" );
		public static const RA_DAV_ALREADY_EXISTS:SVNErrorCode = new SVNErrorCode( RA_DAV_CATEGORY, 5, "RA layer file already exists" );
		public static const RA_DAV_INVALID_CONFIG_VALUE:SVNErrorCode = new SVNErrorCode( RA_DAV_CATEGORY, 6, "Invalid configuration value" );
		public static const RA_DAV_PATH_NOT_FOUND:SVNErrorCode = new SVNErrorCode( RA_DAV_CATEGORY, 7, "HTTP Path Not Found" );
		public static const RA_DAV_PROPPATCH_FAILED:SVNErrorCode = new SVNErrorCode( RA_DAV_CATEGORY, 8, "Failed to execute WebDAV PROPPATCH" );
		public static const RA_DAV_MALFORMED_DATA:SVNErrorCode = new SVNErrorCode( RA_DAV_CATEGORY, 9, "Malformed network data" );
		public static const RA_DAV_RESPONSE_HEADER_BADNESS:SVNErrorCode = new SVNErrorCode( RA_DAV_CATEGORY, 10, "Unable to extract data from response header" );
		/**
		 * @since 1.2.0, SVN 1.5
		 */
		public static const RA_DAV_RELOCATED:SVNErrorCode = new SVNErrorCode( RA_DAV_CATEGORY, 11, "Repository has been moved" );
		public static const RA_LOCAL_REPOS_NOT_FOUND:SVNErrorCode = new SVNErrorCode( RA_LOCAL_CATEGORY, 0, "Couldn't find a repository" );
		public static const RA_LOCAL_REPOS_OPEN_FAILED:SVNErrorCode = new SVNErrorCode( RA_LOCAL_CATEGORY, 1, "Couldn't open a repository" );
		public static const RA_SVN_CMD_ERR:SVNErrorCode = new SVNErrorCode( RA_SVN_CATEGORY, 0, "Special code for wrapping server errors to report to client" );
		public static const RA_SVN_UNKNOWN_CMD:SVNErrorCode = new SVNErrorCode( RA_SVN_CATEGORY, 1, "Unknown svn protocol command" );
		public static const RA_SVN_CONNECTION_CLOSED:SVNErrorCode = new SVNErrorCode( RA_SVN_CATEGORY, 2, "Network connection closed unexpectedly" );
		public static const RA_SVN_IO_ERROR:SVNErrorCode = new SVNErrorCode( RA_SVN_CATEGORY, 3, "Network read/write error" );
		public static const RA_SVN_MALFORMED_DATA:SVNErrorCode = new SVNErrorCode( RA_SVN_CATEGORY, 4, "Malformed network data" );
		public static const RA_SVN_REPOS_NOT_FOUND:SVNErrorCode = new SVNErrorCode( RA_SVN_CATEGORY, 5, "Couldn't find a repository" );
		public static const RA_SVN_BAD_VERSION:SVNErrorCode = new SVNErrorCode( RA_SVN_CATEGORY, 6, "Client/server version mismatch" );
		public static const AUTHN_CREDS_UNAVAILABLE:SVNErrorCode = new SVNErrorCode( AUTHN_CATEGORY, 0, "Credential data unavailable" );
		public static const AUTHN_NO_PROVIDER:SVNErrorCode = new SVNErrorCode( AUTHN_CATEGORY, 1, "No authentication provider available" );
		public static const AUTHN_PROVIDERS_EXHAUSTED:SVNErrorCode = new SVNErrorCode( AUTHN_CATEGORY, 2, "All authentication providers exhausted" );
		public static const AUTHN_CREDS_NOT_SAVED:SVNErrorCode = new SVNErrorCode( AUTHN_CATEGORY, 3, "Credentials not saved" );
		public static const AUTHZ_ROOT_UNREADABLE:SVNErrorCode = new SVNErrorCode( AUTHZ_CATEGORY, 0, "Read access denied for root of edit" );
		public static const AUTHZ_UNREADABLE:SVNErrorCode = new SVNErrorCode( AUTHZ_CATEGORY, 1, "Item is not readable" );
		public static const AUTHZ_PARTIALLY_READABLE:SVNErrorCode = new SVNErrorCode( AUTHZ_CATEGORY, 2, "Item is partially readable" );
		public static const AUTHZ_INVALID_CONFIG:SVNErrorCode = new SVNErrorCode( AUTHZ_CATEGORY, 3, "Invalid authz configuration" );
		public static const AUTHZ_UNWRITABLE:SVNErrorCode = new SVNErrorCode( AUTHZ_CATEGORY, 4, "Item is not writable" );
		public static const SVNDIFF_INVALID_HEADER:SVNErrorCode = new SVNErrorCode( SVNDIFF_CATEGORY, 0, "Svndiff data has invalid header" );
		public static const SVNDIFF_CORRUPT_WINDOW:SVNErrorCode = new SVNErrorCode( SVNDIFF_CATEGORY, 1, "Svndiff data contains corrupt window" );
		public static const SVNDIFF_BACKWARD_VIEW:SVNErrorCode = new SVNErrorCode( SVNDIFF_CATEGORY, 2, "Svndiff data contains backward-sliding source view" );
		public static const SVNDIFF_INVALID_OPS:SVNErrorCode = new SVNErrorCode( SVNDIFF_CATEGORY, 3, "Svndiff data contains invalid instruction" );
		public static const SVNDIFF_UNEXPECTED_END:SVNErrorCode = new SVNErrorCode( SVNDIFF_CATEGORY, 4, "Svndiff data ends unexpectedly" );
		public static const APMOD_MISSING_PATH_TO_FS:SVNErrorCode = new SVNErrorCode( APMOD_CATEGORY, 0, "Apache has no path to an SVN filesystem" );
		public static const APMOD_MALFORMED_URI:SVNErrorCode = new SVNErrorCode( APMOD_CATEGORY, 1, "Apache got a malformed URI" );
		public static const APMOD_ACTIVITY_NOT_FOUND:SVNErrorCode = new SVNErrorCode( APMOD_CATEGORY, 2, "Activity not found" );
		public static const APMOD_BAD_BASELINE:SVNErrorCode = new SVNErrorCode( APMOD_CATEGORY, 3, "Baseline incorrect" );
		public static const APMOD_CONNECTION_ABORTED:SVNErrorCode = new SVNErrorCode( APMOD_CATEGORY, 4, "Input/output error" );
		public static const CLIENT_VERSIONED_PATH_REQUIRED:SVNErrorCode = new SVNErrorCode( CLIENT_CATEGORY, 0, "A path under version control is needed for this operation" );
		public static const CLIENT_RA_ACCESS_REQUIRED:SVNErrorCode = new SVNErrorCode( CLIENT_CATEGORY, 1, "Repository access is needed for this operation" );
		public static const CLIENT_BAD_REVISION:SVNErrorCode = new SVNErrorCode( CLIENT_CATEGORY, 2, "Bogus revision information given" );
		public static const CLIENT_DUPLICATE_COMMIT_URL:SVNErrorCode = new SVNErrorCode( CLIENT_CATEGORY, 3, "Attempting to commit to a URL more than once" );
		public static const CLIENT_IS_BINARY_FILE:SVNErrorCode = new SVNErrorCode( CLIENT_CATEGORY, 4, "Operation does not apply to binary file" );
		public static const CLIENT_INVALID_EXTERNALS_DESCRIPTION:SVNErrorCode = new SVNErrorCode( CLIENT_CATEGORY, 5, "Format of an svn:externals property was invalid" );
		public static const CLIENT_MODIFIED:SVNErrorCode = new SVNErrorCode( CLIENT_CATEGORY, 6, "Attempting restricted operation for modified resource" );
		public static const CLIENT_IS_DIRECTORY:SVNErrorCode = new SVNErrorCode( CLIENT_CATEGORY, 7, "Operation does not apply to directory" );
		public static const CLIENT_REVISION_RANGE:SVNErrorCode = new SVNErrorCode( CLIENT_CATEGORY, 8, "Revision range is not allowed" );
		public static const CLIENT_INVALID_RELOCATION:SVNErrorCode = new SVNErrorCode( CLIENT_CATEGORY, 9, "Inter-repository relocation not allowed" );
		public static const CLIENT_REVISION_AUTHOR_CONTAINS_NEWLINE:SVNErrorCode = new SVNErrorCode( CLIENT_CATEGORY, 10, "Author name cannot contain a newline" );
		public static const CLIENT_PROPERTY_NAME:SVNErrorCode = new SVNErrorCode( CLIENT_CATEGORY, 11, "Bad property name" );
		public static const CLIENT_UNRELATED_RESOURCES:SVNErrorCode = new SVNErrorCode( CLIENT_CATEGORY, 12, "Two versioned resources are unrelated" );
		public static const CLIENT_MISSING_LOCK_TOKEN:SVNErrorCode = new SVNErrorCode( CLIENT_CATEGORY, 13, "Path has no lock token" );
		/**
		 * @since  1.2.0, SVN 1.5
		 */
		public static const CLIENT_MULTIPLE_SOURCES_DISALLOWED:SVNErrorCode = new SVNErrorCode( CLIENT_CATEGORY, 14, "Operation does not support multiple sources" );
		/**
		 * @since  1.2.0, SVN 1.5
		 */
		public static const CLIENT_NO_VERSIONED_PARENT:SVNErrorCode = new SVNErrorCode( CLIENT_CATEGORY, 15, "No versioned parent directories" );
		/**
		 * @since  1.2.0, SVN 1.5
		 */
		public static const CLIENT_NOT_READY_TO_MERGE:SVNErrorCode = new SVNErrorCode( CLIENT_CATEGORY, 16, "Working copy and merge source not ready for reintegration" );
		/**
		 * @since  1.3, SVN 1.6
		 */
		public static const CLIENT_FILE_EXTERNAL_OVERWRITE_VERSIONED:SVNErrorCode = new SVNErrorCode( CLIENT_CATEGORY, 17, "A file external cannot overwrite an existing versioned item" );
		public static const BASE:SVNErrorCode = new SVNErrorCode( MISC_CATEGORY, 0, "A problem occurred; see later errors for details" );
		public static const PLUGIN_LOAD_FAILURE:SVNErrorCode = new SVNErrorCode( MISC_CATEGORY, 1, "Failure loading plugin" );    
		public static const MALFORMED_FILE:SVNErrorCode = new SVNErrorCode( MISC_CATEGORY, 2, "Malformed file" );
		public static const INCOMPLETE_DATA:SVNErrorCode = new SVNErrorCode( MISC_CATEGORY, 3, "Incomplete data" );
		public static const INCORRECT_PARAMS:SVNErrorCode = new SVNErrorCode( MISC_CATEGORY, 4, "Incorrect parameters given" );
		public static const UNVERSIONED_RESOURCE:SVNErrorCode = new SVNErrorCode( MISC_CATEGORY, 5, "Tried a versioning operation on an unversioned resource" );
		public static const TEST_FAILED:SVNErrorCode = new SVNErrorCode( MISC_CATEGORY, 6, "Test failed" );
		public static const UNSUPPORTED_FEATURE:SVNErrorCode = new SVNErrorCode( MISC_CATEGORY, 7, "Trying to use an unsupported feature" );
		public static const BAD_PROP_KIND:SVNErrorCode = new SVNErrorCode( MISC_CATEGORY, 8, "Unexpected or unknown property kind" );
		public static const ILLEGAL_TARGET:SVNErrorCode = new SVNErrorCode( MISC_CATEGORY, 9, "Illegal target for the requested operation" );
		public static const DELTA_MD5_CHECKSUM_ABSENT:SVNErrorCode = new SVNErrorCode( MISC_CATEGORY, 10, "MD5 checksum is missing" );
		public static const DIR_NOT_EMPTY:SVNErrorCode = new SVNErrorCode( MISC_CATEGORY, 11, "Directory needs to be empty but is not" );
		public static const EXTERNAL_PROGRAM:SVNErrorCode = new SVNErrorCode( MISC_CATEGORY, 12, "Error calling external program" );
		public static const SWIG_PY_EXCEPTION_SET:SVNErrorCode = new SVNErrorCode( MISC_CATEGORY, 13, "Python exception has been set with the error" );
		public static const CHECKSUM_MISMATCH:SVNErrorCode = new SVNErrorCode( MISC_CATEGORY, 14, "A checksum mismatch occurred" );
		public static const CANCELLED:SVNErrorCode = new SVNErrorCode( MISC_CATEGORY, 15, "The operation was interrupted" );
		public static const INVALID_DIFF_OPTION:SVNErrorCode = new SVNErrorCode( MISC_CATEGORY, 16, "The specified diff option is not supported" );
		public static const PROPERTY_NOT_FOUND:SVNErrorCode = new SVNErrorCode( MISC_CATEGORY, 17, "Property not found" );
		public static const NO_AUTH_FILE_PATH:SVNErrorCode = new SVNErrorCode( MISC_CATEGORY, 18, "No auth file path available" );
		public static const VERSION_MISMATCH:SVNErrorCode = new SVNErrorCode( MISC_CATEGORY, 19, "Incompatible library version" );
		/**
		 * @since  1.2.0, SVN 1.5
		 */
		public static const MERGE_INFO_PARSE_ERROR:SVNErrorCode = new SVNErrorCode( MISC_CATEGORY, 20, "Merge info parse error" );
		/**
		 * @since  1.2.0, SVN 1.5
		 */
		public static const CEASE_INVOCATION:SVNErrorCode = new SVNErrorCode( MISC_CATEGORY, 21, "Cease invocation of this API" );
		/**
		 * @since  1.2.0, SVN 1.5
		 */
		public static const REVISION_NUMBER_PARSE_ERROR:SVNErrorCode = new SVNErrorCode( MISC_CATEGORY, 22, "Revision number parse error" );
		/**
		 * @since  1.2.0, SVN 1.5
		 */
		public static const ITER_BREAK:SVNErrorCode = new SVNErrorCode( MISC_CATEGORY, 23, "Iteration terminated before completion" );
		/**
		 * @since  1.2.0, SVN 1.5
		 */
		public static const UNKNOWN_CHANGELIST:SVNErrorCode = new SVNErrorCode( MISC_CATEGORY, 24, "Unknown changelist" );
		public static const RESERVED_FILENAME_SPECIFIED:SVNErrorCode = new SVNErrorCode( MISC_CATEGORY, 25, "Reserved directory name in command line arguments" );
		public static const UNKNOWN_CAPABILITY:SVNErrorCode = new SVNErrorCode( MISC_CATEGORY, 26, "Inquiry about unknown capability" );
		public static const CL_ARG_PARSING_ERROR:SVNErrorCode = new SVNErrorCode( CL_CATEGORY, 0, "Client error in parsing arguments" );
		public static const CL_INSUFFICIENT_ARGS:SVNErrorCode = new SVNErrorCode( CL_CATEGORY, 1, "Not enough args provided" );
		public static const CL_MUTUALLY_EXCLUSIVE_ARGS:SVNErrorCode = new SVNErrorCode( CL_CATEGORY, 2, "Mutually exclusive arguments specified" );
		public static const CL_ADM_DIR_RESERVED:SVNErrorCode = new SVNErrorCode( CL_CATEGORY, 3, "Attempted command in administrative dir" );
		public static const CL_LOG_MESSAGE_IS_VERSIONED_FILE:SVNErrorCode = new SVNErrorCode( CL_CATEGORY, 4, "The log message file is under version control" );
		public static const CL_LOG_MESSAGE_IS_PATHNAME:SVNErrorCode = new SVNErrorCode( CL_CATEGORY, 5, "The log message is a pathname" );
		public static const CL_COMMIT_IN_ADDED_DIR:SVNErrorCode = new SVNErrorCode( CL_CATEGORY, 6, "Committing in directory scheduled for addition" );
		public static const CL_NO_EXTERNAL_EDITOR:SVNErrorCode = new SVNErrorCode( CL_CATEGORY, 7, "No external editor available" );
		public static const CL_BAD_LOG_MESSAGE:SVNErrorCode = new SVNErrorCode( CL_CATEGORY, 8, "Something is wrong with the log message's contents" );
		public static const CL_UNNECESSARY_LOG_MESSAGE:SVNErrorCode = new SVNErrorCode( CL_CATEGORY, 9, "A log message was given where none was necessary" );
		/**
		 * @since  1.2.0, SVN 1.5
		 */
		public static const CL_NO_EXTERNAL_MERGE_TOOL:SVNErrorCode = new SVNErrorCode( CL_CATEGORY, 10, "No external merge tool available" );
	}
}
