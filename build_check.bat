@echo off
setlocal EnableDelayedExpansion

echo ======================================================================
echo   SMART BOOKING PLATFORM - CLEAN AND BUILD CHECK
echo ======================================================================
echo.

set "TARGET_DIR=build/web/WEB-INF/classes"
if not exist "build\web\WEB-INF\classes" mkdir "build\web\WEB-INF\classes"

echo [1/3] Scanning Java source files...
if exist sources.txt del sources.txt

for /r src\java %%i in (*.java) do (
    set "file_path=%%i"
    set "file_path=!file_path:\=/!"
    echo "!file_path!">> sources.txt
)

echo [2/3] Compiling Java sources with javac...
javac -encoding UTF-8 -cp "web/WEB-INF/lib/*" -d "%TARGET_DIR%" @sources.txt

if %ERRORLEVEL% equ 0 (
    echo.
    echo ======================================================================
    echo   BUILD SUCCESS: All Java files compiled successfully with 0 errors!
    echo ======================================================================
) else (
    echo.
    echo ======================================================================
    echo   BUILD FAILED: Please check compilation errors above.
    echo ======================================================================
)

if exist sources.txt del sources.txt
echo.
pause
