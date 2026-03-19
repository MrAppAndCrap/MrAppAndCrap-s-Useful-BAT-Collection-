@echo off
title Mouse Fixer for F*cking - Windows 11 
color 1F
echo              By MrAppAndCrap
echo           .                   .
echo                  /\_/\  
echo                =( o.o )= 
echo    ----------------------------------------
echo                    .
echo  Meow, Let's sort out your f*ing windows 11   
echo ==========================================
echo   Fixing f*cking Windows 11 Mouse Tool 1000  
echo ==========================================
echo.
echo This will:
echo  - restart Human Interface Device Service
echo  - restart Bluetooth Support Service
echo  - rescan hardware devices
echo  - restart Explorer
echo.

:: Require admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator permission...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo.
echo [1/5] Setting HID service to manual...
sc config hidserv start= demand >nul 2>&1

echo [2/5] Restarting HID service...
net stop hidserv /y >nul 2>&1
timeout /t 2 /nobreak >nul
net start hidserv >nul 2>&1

echo [3/5] Restarting Bluetooth Support Service...
net stop bthserv /y >nul 2>&1
timeout /t 2 /nobreak >nul
net start bthserv >nul 2>&1

echo [4/5] Rescanning hardware...
pnputil /scan-devices

echo [5/5] Restarting Windows shell...
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 2 /nobreak >nul
start explorer.exe

echo.
echo Done.
echo.
echo If the mouse still does not work, reboot once.
echo.

echo Thanks for using MrAppAndCrap's Bat collection.
echo.

choice /c YN /m "Visit GitHubRepo? [Y]es/[N]o"
if errorlevel 2 exit /b
if errorlevel 1 start "" "https://github.com/MrAppAndCrap/MrAppAndCrap-s-Useful-BAT-Collection-.git"

echo.
echo Thanks for using MrAppAndCrap's Bat collection.
pause