@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion

:: ═══════════════════════════════════════════════════════════
::  SKILLS UNINSTALLER v2.1 — Windows
:: ═══════════════════════════════════════════════════════════

if not "%~1"=="" (
    set "TARGET_DIR=%~1"
) else (
    if defined CLAUDE_CONFIG_DIR (
        set "TARGET_DIR=%CLAUDE_CONFIG_DIR%\skills"
    ) else (
        set "TARGET_DIR=%USERPROFILE%\.claude\skills"
    )
)

set "SKILL[1]=ba-role"
set "SKILL[2]=bug-fix-pipeline"
set "SKILL[3]=code-review-pipeline"
set "SKILL[4]=dev-role"
set "SKILL[5]=google-play-aso"
set "SKILL[6]=ops-role"
set "SKILL[7]=pm-role"
set "SKILL[8]=qa-qc-role"
set TOTAL=8

echo.
echo ═══════════════════════════════════════════════════════════
echo   SKILLS UNINSTALLER v2.1 — Windows
echo ═══════════════════════════════════════════════════════════
echo.
echo   Target: %TARGET_DIR%
echo.

echo   Sẽ gỡ:
for /L %%i in (1,1,%TOTAL%) do (
    set "NAME=!SKILL[%%i]!"
    if exist "%TARGET_DIR%\!NAME!\" (
        echo     [X] !NAME!
    ) else (
        echo     [-] !NAME! (không tồn tại)
    )
)

echo.
echo   CẢNH BÁO: Không thể hoàn tác!
set /p "CONFIRM=  Xác nhận gỡ? [y/N] "
if /i not "%CONFIRM%"=="y" (
    echo.
    echo   Đã huỷ.
    pause
    exit /b 0
)

echo.
set REMOVED=0
for /L %%i in (1,1,%TOTAL%) do (
    set "NAME=!SKILL[%%i]!"
    if exist "%TARGET_DIR%\!NAME!\" (
        rmdir /s /q "%TARGET_DIR%\!NAME!"
        echo   [X] !NAME! — đã gỡ
        set /a REMOVED+=1
    )
)

echo.
echo ═══════════════════════════════════════════════════════════
echo   Đã gỡ !REMOVED! skills
echo ═══════════════════════════════════════════════════════════
echo.
pause
