@echo off
echo =========================================
echo  Building Financial Rules Engine
echo =========================================

echo.
echo [1/3] Running Bison...
bison -d parser.y
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Bison failed! Ensure bison is in your PATH.
    pause
    exit /b %ERRORLEVEL%
)

echo [2/3] Running Flex...
flex lexer.l
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Flex failed! Ensure flex is in your PATH.
    pause
    exit /b %ERRORLEVEL%
)

echo [3/3] Compiling C Code...
gcc lex.yy.c parser.tab.c -o engine.exe
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] GCC compilation failed! Ensure gcc is in your PATH.
    pause
    exit /b %ERRORLEVEL%
)

echo.
echo =========================================
echo  Build Successful! 
echo =========================================
echo.
echo Running the engine with input.txt:
echo.

engine.exe input.txt

pause
