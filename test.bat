@echo off
SET EL=0

if "%msvs_toolset%"=="" SET msvs_toolset=12
if "%platform%"=="" SET platform=x64

ECHO msvs_toolset^: %msvs_toolset%
ECHO platform^: %platform%

:: https://msdn.microsoft.com/en-us/library/f2ccy3wt.aspx
ECHO "setting path for msbuild"
SET PATH=C:\Program Files (x86)\MSBuild\%msvs_toolset%.0\bin;%PATH%
IF %ERRORLEVEL% NEQ 0 GOTO ERROR

ECHO "setting path for VC"
SET PATH=C:\Program Files (x86)\Microsoft Visual Studio %msvs_toolset%.0\VC\bin;%PATH%
IF %ERRORLEVEL% NEQ 0 GOTO ERROR

:: note: will override %PLATFORM% to upper case
ECHO "enabling VC env"
if %platform% == x64 CALL "C:\Program Files (x86)\Microsoft Visual Studio %msvs_toolset%.0\VC\vcvarsall.bat" amd64
IF %ERRORLEVEL% NEQ 0 GOTO ERROR
if %platform% == x86 CALL "C:\Program Files (x86)\Microsoft Visual Studio %msvs_toolset%.0\VC\vcvarsall.bat" amd64_x86
IF %ERRORLEVEL% NEQ 0 GOTO ERROR

ECHO "compiling test program"
cl /MD /Zi /Fmight_crash.pdb /nologo /EHsc /D NDEBUG might_crash.cpp
IF %ERRORLEVEL% NEQ 0 GOTO ERROR

ECHO "running test program"
.\might_crash
IF %ERRORLEVEL% NEQ 0 GOTO ERROR

:: expected to crash so we ignore any error so the script continues
ECHO "running test program again"
set CRASH_PLEASE=1
.\might_crash

GOTO DONE

:ERROR
echo --------- ERROR! ------------
ECHO ERRORLEVEL %ERRORLEVEL%
SET EL=%ERRORLEVEL%

:DONE
echo --------- DONE ------------
EXIT /b %EL%
