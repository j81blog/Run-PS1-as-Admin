@ECHO OFF
setlocal EnableDelayedExpansion
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

goto StartScript

rem ===== Help Example =====
rem Change "%~dp0RunScriptAsAdmin.ps1" to the name of your PoSH script, always start with %~dp0, that's the current path 
rem (or add your own full path, not recommended though).
rem ===== End Help Example =====

:StartScript

%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -NoLogo -NonInteractive -ExecutionPolicy Bypass -File "%~dp0RunScriptAsAdmin.ps1"
