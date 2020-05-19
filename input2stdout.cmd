@echo off
::--------------------------------------------------------------
:: this is an example on how to run a jar
:: with full UTF-8 support, 
:: (Windows console reading/writing/presenting, 
:: and Java processing input/output content).
::--------------------------------------------------------------
:: this bathc-file passes any arguments to the JAR file as is, 
:: it also preserve the exit-code of the java program and 
:: pass it along.
:: if you don't need 'pause' just use 'exit /b %ErrorLevel%' 
:: right after the 'call java ....' line.
::--------------------------------------------------------------
::                                       Elad Karako. May 2020.
::--------------------------------------------------------------


chcp 65001 2>nul >nul

set "LC_ALL=en_US.UTF-8"
set "LANG=en_US.UTF-8"
set "JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8 -Duser.language=en"

call java "-Dfile.encoding=UTF-8" "-Duser.language=en" -jar "%~sdp0input2stdout.jar" %*
set "EXIT_CODE=%ErrorLevel%"

pause

exit /b %ErrorLevel%