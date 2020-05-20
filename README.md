
<h3>It is VERY IMPORTANT that you'll open up the CMD and JAVA files after you've downloaded/checked-out/forked the repository to your computer, with an editor such as Notepad++ or Notepad2 and make sure that for each file the end-of-line format is Windows-EOL (<code>\r\n</code>) and that each file is encoded as "UTF-8" (in Notepad2. Not "UTF-8 with signature") or "UTF-8 without BOM (in Notepad++). GitHub tends to change those things and it can really mess up the batch files.</h3>

<hr/>

<h1>Overkill UTF-8 Support For Windows And Java With Full Code And Usage Example</h1>

The <code>input2stdout.java</code> accepts an input from an inputbox, 
which is a more friendly way that reading from the console directly (also supports Copy/Paste).

The input is explicitly handled as UTF-8, 
and written back to the STDOUT (standard-output).

<hr/>

Windows-console will support extended Unicode presenting and inputing by <code>chcp 65001 2&gt;nul 1&gt;nul</code>.

Java will be pre-prepared for UTF-8 input (both from STDIN and/or files) due to various combinations of system global environment variables.

<hr/>

the <code>_compile.cmd</code> shows additional switches uses to make sure the compilation with <code>javac</code> is also explicitly awared of the usage of UTF-8.


<hr/>

It is best to use <code>UTF-8</code> (and not <code>UTF8</code> nor <code>utf8</code> nor <code>utf-8</code>) due to compatibility with Java7-based products.

<hr/>

<del>You can learn how to generate a keystore and sign your own JAR files very easily with: <a href="https://gist.github.com/eladkarako/caa019c0ee5abff8e14ad26f44236c3a">https://gist.github.com/eladkarako/caa019c0ee5abff8e14ad26f44236c3a</a></del> - <strong>(not needed)</strong> - the <code>_compile.cmd</code> file now contains the steps: align, create keystore for signing, sign and verify signature. It uses a compatible SHA1 (RSA 2048) which works well for old java versions (and also APK for old Android versions).

<hr/>

Using jarsigner normally fails now days due to Java trying to communicate with the TSA server using SSL3. You need to force Java to use TLS1.2 (I think 1 or 1.1 will work too). 

I'll simply skip using the '-tsa' command-line-switch. 


```cmd
::note - SSL is no longer supported in '-tsa' command-line-switch and will fail, TLS 1.2 is prefered but not all Java7 supports it so I've left-in the 1.0 and 1.1 enabled.
::note - your operation-system might need to-set to-use TLS1.2 by default (google: "how to set Windows 7 to use TLS1.2).
::prefered:    "-Dhttps.protocols=TLSv1.2"               "-Ddeployment.security.SSLv2Hello=false" "-Ddeployment.security.SSLv3=false" "-Ddeployment.security.TLSv1=false" "-Ddeployment.security.TLSv1.1=false" "-Ddeployment.security.TLSv1.2=true"
::call jarsigner "-Dhttps.protocols=TLSv1,TLSv1.1,TLSv1.2" "-Ddeployment.security.SSLv2Hello=false" "-Ddeployment.security.SSLv3=false" "-Ddeployment.security.TLSv1=true"  "-Ddeployment.security.TLSv1.1=true"  "-Ddeployment.security.TLSv1.2=true" -keystore "foo.keystore" -storepass "123456" -keypass "123456" -digestalg "SHA1" -sigalg "SHA1withRSA" "-verbose:all" "input2stdout.jar" "alias_name"


::note - I will not use '-tsa'.
```

by the way here are a list of tsa servers:
<pre>
you need sha1 timestamp server (RFC3161).
this is the "classic" one:
http://sha1timestamp.ws.symantec.com/sha1/timestamp

here are others:
http://timestamp.globalsign.com/scripts/timstamp.dll
https://timestamp.geotrust.com/tsa
http://timestamp.comodoca.com/rfc3161
http://timestamp.wosign.com
http://tsa.startssl.com/rfc3161
http://time.certum.pl
http://timestamp.digicert.com
https://freetsa.org
http://dse200.ncipher.com/TSS/HttpTspServer
http://tsa.safecreative.org
http://zeitstempel.dfn.de
https://ca.signfiles.com/tsa/get.aspx
http://services.globaltrustfinder.com/adss/tsa
https://tsp.iaik.tugraz.at/tsp/TspRequest
http://timestamp.apple.com/ts01
http://timestamp.entrust.net/TSS/RFC3161sha2TS
http://tsa.wotrus.com
http://oscp.cocbuilder.su/tsa.php



here are others:
http://timestamp.comodoca.com/rfc3161
http://sha256timestamp.ws.symantec.com/sha256/timestamp
http://tsa.starfieldtech.com
http://timestamp.entrust.net/TSS/RFC3161sha1TS;digests=SHA-1,SHA-256
http://timestamp.entrust.net/TSS/RFC3161sha2TS;digests=SHA-1,SHA-256
http://rfc3161timestamp.globalsign.com/advanced;digests=SHA-256,SHA-512
http://rfc3161timestamp.globalsign.com/standard
http://timestamp.globalsign.com/scripts/timstamp.dll
http://timestamp.globalsign.com/?signature=sha2;digests=SHA-256,SHA-512
http://timestamp.digicert.com
http://time.certum.pl
http://tsa.swisssign.net
http://zeitstempel.dfn.de
https://tsp.iaik.tugraz.at/tsp/TspRequest
</pre>

resources: https://github.com/openjdk/shenandoah/tree/master/test/jdk/sun/security/tools/jarsigner/compatibility 
https://gist.github.com/Manouchehri/fd754e402d98430243455713efada710 
https://knowledge.digicert.com/generalinformation/INFO4231.html 
https://knowledge.digicert.com/alerts/migration-of-legacy-verisign-and-symantec-time-stamping-services.html 
https://stackoverflow.com/questions/25052925/does-anyone-know-a-freetrial-timestamp-server-service