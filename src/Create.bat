@echo off
title Create Buckshot Roulette Mod Loader Extended Patch
color 0A
echo ===================================================
echo      Create Buckshot Roulette Mod Loader Extended Patch
echo ===================================================
echo.

:: Check if files exist
if not exist "xdelta3.exe" echo [ERROR] xdelta3.exe missing & pause & exit
if not exist "Buckshot Roulette.exe" echo [ERROR] Original game not found & pause & exit
if not exist "BuckshotRoulette_Modded.exe" echo [ERROR] Modded game not found & pause & exit

:: Create the patch
echo Creating patch from original to modded...
"xdelta3.exe" -e -s "Buckshot Roulette.exe" "BuckshotRoulette_Modded.exe" "BRML-E.xdelta"

:: Check result
if exist "BRML-E.xdelta" (
    echo.
    echo ============== SUCCESS! ==============
    echo Patch created: BRML-E.xdelta
) else (
    echo.
    echo ============== ERROR ==============
    echo Failed to create patch
)

echo.

pause
