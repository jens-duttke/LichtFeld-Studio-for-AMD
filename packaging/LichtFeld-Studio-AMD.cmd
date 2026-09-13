@echo off
setlocal
REM ---------------------------------------------------------------------------
REM  LichtFeld Studio for AMD - start through ZLUDA
REM
REM  ZLUDA supplies the nvcuda.dll this application loads, so it has to launch
REM  the executable. Put ZLUDA in one of these places:
REM    - a "zluda" folder next to this script
REM    - anywhere on PATH
REM    - the folder named by the ZLUDA_PATH environment variable
REM
REM  Usage:
REM    LichtFeld-Studio-AMD.cmd                          -> start the GUI
REM    LichtFeld-Studio-AMD.cmd --view scene.ply         -> arguments are passed through
REM    LichtFeld-Studio-AMD.cmd --headless -d DATA -o OUT
REM ---------------------------------------------------------------------------

set "APP_DIR=%~dp0"
set "APP_EXE=%APP_DIR%LichtFeld-Studio.exe"
if not exist "%APP_EXE%" set "APP_EXE=%APP_DIR%bin\LichtFeld-Studio.exe"

if not exist "%APP_EXE%" (
    echo [error] LichtFeld-Studio.exe not found next to this script.
    pause
    exit /b 1
)

set "ZLUDA_EXE="
if defined ZLUDA_PATH if exist "%ZLUDA_PATH%\zluda.exe" set "ZLUDA_EXE=%ZLUDA_PATH%\zluda.exe"
if not defined ZLUDA_EXE if exist "%APP_DIR%zluda\zluda.exe" set "ZLUDA_EXE=%APP_DIR%zluda\zluda.exe"
if not defined ZLUDA_EXE for %%I in (zluda.exe) do if not "%%~$PATH:I"=="" set "ZLUDA_EXE=%%~$PATH:I"

if not defined ZLUDA_EXE (
    echo [error] zluda.exe not found.
    echo.
    echo Download ZLUDA v7-preview.10 or newer from
    echo   https://github.com/vosen/ZLUDA/releases
    echo and unpack it into a "zluda" folder next to this script, or set
    echo ZLUDA_PATH to the folder containing zluda.exe.
    pause
    exit /b 1
)

pushd "%APP_DIR%"
"%ZLUDA_EXE%" -- "%APP_EXE%" %*
set "EXITCODE=%ERRORLEVEL%"
popd

if not "%EXITCODE%"=="0" (
    echo.
    echo LichtFeld Studio exited with code %EXITCODE%.
    pause
)
exit /b %EXITCODE%
