::@echo off

::***********************************************************************************************************************************************************************************************************
:: 1.  'UTF-8' is better than 'UTF8'/'utf8'/etc... for compatibility reasons (Java7 based-products).
:: 2.  this file compile and test run the application (first by class, lastly by jar).
:: 3.  various global-arguments and system-property-items are used to make sure that Windows will
::       pass along the textual-content properly, that Java will handle it properly, and return it to Windows,
::       and Windows will show it.
:: 4.  see the 'runner' example: 'input2stdout.cmd' calls for 'input2stdout.jar' with some of those switches passing along command-line arguments and preserving the exit-code of the application.
::***********************************************************************************************************************************************************************************************************
::                                                                                        Elad Karako. May 2020.
::***********************************************************************************************************************************************************************************************************


::make Windows console preset Unicode.
chcp 65001 2>nul >nul


::pre-cleanup
del /f /q "input2stdout.class"    1>nul 2>nul
del /f /q "input2stdout.jar"      1>nul 2>nul

::(optional) also delete the keystore-file (a new keystore file will be regenerated).
::del /f /q "foo.keystore"          1>nul 2>nul




::non-permanent operation-system global-settings for language (mostly used in Linux but Java can read it).
set "LC_ALL=en_US.UTF-8"
set "LANG=en_US.UTF-8"


::non-permanent java-specific    global-settings for charset-encoding and language ("system-property").
set "JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8 -Duser.language=en"


::a way to preserve the exit-code from various processes without loosing it from another process. also presenting it at the end.
set "EXIT_CODE=0"


::compile. explicit encoding with specific command-line switch of 'javac' (can't use system-property items).
call javac -classpath "." -encoding "UTF8" -g:none -Werror  "input2stdout.java"
set "EXIT_CODE=%ErrorLevel%"
if ["%EXIT_CODE%"] NEQ ["0"] ( goto ERROR_COMPILATION )


::---------------------------------
::-- TEST RUN (compiled class)   --
::---------------------------------
::run.     uses those system-property items (same as global).
call java  "-Dfile.encoding=UTF-8" "-Duser.language=en"  -classpath "."  "input2stdout"
set "EXIT_CODE=%ErrorLevel%"
if ["%EXIT_CODE%"] NEQ ["0"] ( goto ERROR_RUNTIME_FROMCLASS )


::create a stand-along application using the Manifest and an entry-point (after that, it's just file-names to store) - using '0' meaning no compression.
call jar cfme0 "input2stdout.jar" Manifest.txt input2stdout input2stdout.class
set "EXIT_CODE=%ErrorLevel%"
if ["%EXIT_CODE%"] NEQ ["0"] ( goto ERROR_JARPACK )



::align the jar (which is really a zip archive) to 4-byte (32-bit alignment). it is a good practice in both Java archives and Android archives. sadly this command cannot overwrite the file, so a "new" file is created, the old one deleted and the name changed to the old-name..
call zipalign.exe -f -v 4 "input2stdout.jar" "input2stdout_aligned.jar"
set "EXIT_CODE=%ErrorLevel%"
if ["%EXIT_CODE%"] NEQ ["0"] ( goto ERROR_ZIPALIGN )

del /f /q "input2stdout.jar"
ren "input2stdout_aligned.jar" "input2stdout.jar"




::(signing is optional).




::signing - pre-condition - having a keystore. generate a keystore if not already exist (very generic, very permissive)
if exist "foo.keystore" ( goto EXIST_KEYSTORE ) 



call keytool -genkeypair -alias "alias_name" -keyalg "RSA" -keysize "2048" -sigalg "SHA1withRSA" -validity "10000" -keypass "123456" -keystore "foo.keystore" -storepass "123456" -dname "CN=*, OU=*, O=*, L=*, S=*, C=*" -v
set "EXIT_CODE=%ErrorLevel%"
if ["%EXIT_CODE%"] NEQ ["0"] ( goto ERROR_KEYSTORE )



:EXIST_KEYSTORE

::sign jar with keystore (no '-tsa')
call jarsigner -keystore "foo.keystore" -storepass "123456" -keypass "123456" -digestalg "SHA1" -sigalg "SHA1withRSA" "-verbose:all" "input2stdout.jar" "alias_name"
set "EXIT_CODE=%ErrorLevel%"
if ["%EXIT_CODE%"] NEQ ["0"] ( goto ERROR_JARSIGN )


::verify signature
call jarsigner -verify "-verbose:all" "input2stdout.jar"
set "EXIT_CODE=%ErrorLevel%"
if ["%EXIT_CODE%"] NEQ ["0"] ( goto ERROR_JARSIGNATUREVERIFY )



::---------------------------------
::-- TEST RUN (stand-along jar)  --
::---------------------------------
call java  "-Dfile.encoding=UTF-8" "-Duser.language=en"  -jar "input2stdout.jar"
set "EXIT_CODE=%ErrorLevel%"
if ["%EXIT_CODE%"] NEQ ["0"] ( goto ERROR_RUNTIME_FROMJAR )




::if not jumped to error handling, it's all good.
echo [INFO] success. 1>&2
goto END



:ERROR_COMPILATION
  echo [ERROR] compilation.   1>&2
  goto END

:ERROR_RUNTIME_FROMCLASS
  echo [ERROR] runtime when ran directly from class.   1>&2
  goto END

:ERROR_JARPACK
  echo [ERROR] jar packing.   1>&2
  goto END
  
:ERROR_ZIPALIGN
  echo [ERROR] jar zip-archive alignment failed.   1>&2
  goto END

:ERROR_KEYSTORE
  echo [ERROR] keystore-file could not be created.   1>&2
  goto END

:ERROR_JARSIGN
  echo [ERROR] could not sign jar file.  1>&2
  goto END

:ERROR_JARSIGNATUREVERIFY
  echo [ERROR] the jar was modified after signing - original signature does not match current content. verification failed.  1>&2
  goto END

:ERROR_RUNTIME_FROMJAR
  echo [ERROR] runtime when ran directly from jar.   1>&2
  goto END

:END
  echo [INFO] EXIT-CODE: %EXIT_CODE%   1>&2
  pause
  exit /b %EXIT_CODE%
