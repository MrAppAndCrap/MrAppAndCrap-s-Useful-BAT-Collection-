@echo off
title Stop Adobe services - Windows 11 
color 1F
echo              By MrAppAndCrap
echo           .                   .
echo                  /\_/\  
echo                =( o.o )= 
echo    ----------------------------------------
echo             Adobe Shutdown  
echo ==========================================
echo.             
echo ==========================================
echo.
echo This will:
echo  - Stop Acrobat Licensing Service
echo  - Stop Adobe Genuine services
echo  - Stop Adobe Genuine Software Integrity Services
echo.
@echo off
echo Stopping Acrobat Licensing Service...
sc stop "Acrobat Licensing Service" >nul 2>&1
sc config "Acrobat Licensing Service" start= disabled >nul 2>&1
sc failure "Acrobat Licensing Service" reset= 0 actions= "" >nul 2>&1

echo.
echo Stopping Adobe Licensing Service...
sc stop "Adobe Licensing Service" >nul 2>&1
sc config "Adobe Licensing Service" start= disabled >nul 2>&1
sc failure "Adobe Licensing Service" reset= 0 actions= "" >nul 2>&1

echo.
echo Stopping Adobe Genuine services...
sc stop "Adobe Genuine Monitor Service" >nul 2>&1
sc config "Adobe Genuine Monitor Service" start= disabled >nul 2>&1
sc failure "Adobe Genuine Monitor Service" reset= 0 actions= "" >nul 2>&1

sc stop "Adobe Genuine Software Integrity Service" >nul 2>&1
sc config "Adobe Genuine Software Integrity Service" start= disabled >nul 2>&1
sc failure "Adobe Genuine Software Integrity Service" reset= 0 actions= "" >nul 2>&1

echo.
echo Killing any running licensing processes...
taskkill /F /IM Adobe*.exe >nul 2>&1
taskkill /F /IM AGSService.exe >nul 2>&1
taskkill /F /IM armsvc.exe >nul 2>&1

echo.
echo Done.
echo.
echo Thanks for using MrAppAndCrap's Bat collection.
echo.
choice /c YN /m "Visit GitHubRepo? [Y]es/[N]o"
if errorlevel 2 exit /b
if errorlevel 1 start "" "https://github.com/MrAppAndCrap/MrAppAndCrap-s-Useful-BAT-Collection-.git"
echo.
echo Thanks for using MrAppAndCrap's Bat collection.
pause
