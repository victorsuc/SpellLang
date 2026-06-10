@echo off
call cleanup.bat

set "flex=lib\jflex-full-1.9.1.jar"
set "cup=lib\java-cup-11b.jar"
set "libs=.;lib\java-cup-11b.jar;lib\java-cup-11b-runtime.jar"

if "%SPELLLANG_VERBOSE_BUILD%"=="1" (
    java -jar %flex% spelllang.flex
    java -jar %cup% -parser parser -symbols sym spelllang.cup
    javac -cp "%libs%" *.java
) else (
    java -jar %flex% spelllang.flex >nul 2>&1
    java -jar %cup% -parser parser -symbols sym spelllang.cup >nul 2>&1
    javac -cp "%libs%" *.java >nul 2>&1
)

if "%~1"=="" (
    java -cp "%libs%" Main input.txt
) else (
    java -cp "%libs%" Main %*
)
