This is the SVN protocol implemented in AS3. This library gives you the ability to write your own SVN client completely in Flash.

Only the svn:// prototcol is implemented as of right now.

This is still very much a work in progress and needs a lot of work to get it ready for prime time, but I wanted to release it so people could track progress.

Here is a description of the svn protocol http://svn.collab.net/repos/svn/trunk/subversion/libsvn_ra_svn/protocol

### Supported methods ###

**get-latest-rev**<br>
<b>stat</b><br>
<b>get-dir</b><br>
<b>get-file</b><br>
<b>get-dated-rev</b><br>
<b>rev-proplist</b><br>
<b>log</b><br>
<b>update</b><br>
<b>reparent</b><br>


Check out the HowTo Wiki Page to see how to use some of these methods.<br>
<br>
<h3>Other Open Source Libraries Used</h3>

<a href='http://code.google.com/p/as3crypto/'>as3crypto</a> is used for CRAM MD5 authentication<br>
<br>
<a href='http://www.gskinner.com/blog/archives/2007/04/free_extension.html'>gskinner StringUtils</a> Using gskinner.com's String Utils class because I was too lazy to write my own.<br>
<br>
<a href='http://svnkit.com/'>SVNKit</a> Some of the code was converted from the Java SVNKit