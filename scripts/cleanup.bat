@echo off
setlocal

set "ROOT=%~dp0.."
cd /d "%ROOT%"

if exist build\parser.java del build\parser.java
if exist build\sym.java del build\sym.java
if exist build\scanner.java del build\scanner.java
for /r build %%f in (*.class) do del "%%f"
