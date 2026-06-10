@echo off
setlocal

set "ROOT=%~dp0.."
cd /d "%ROOT%"

call "%ROOT%\scripts\cleanup.bat"

set "flex=lib\jflex-full-1.9.1.jar"
set "cup=lib\java-cup-11b.jar"
set "libs=build;lib\java-cup-11b.jar;lib\java-cup-11b-runtime.jar"

if "%SPELLLANG_VERBOSE_BUILD%"=="1" (
    java -jar %flex% -d build grammar\spelllang.flex
    java -jar %cup% -destdir build -parser parser -symbols sym grammar\spelllang.cup
    javac -cp "lib\java-cup-11b.jar;lib\java-cup-11b-runtime.jar" -d build src\*.java build\*.java
) else (
    java -jar %flex% -d build grammar\spelllang.flex >nul 2>&1
    java -jar %cup% -destdir build -parser parser -symbols sym grammar\spelllang.cup >nul 2>&1
    javac -cp "lib\java-cup-11b.jar;lib\java-cup-11b-runtime.jar" -d build src\*.java build\*.java >nul 2>&1
)

if "%~1"=="" (
    java -cp "%libs%" Main examples\input.txt
) else (
    java -cp "%libs%" Main %*
)
