@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion

:: ═══════════════════════════════════════════════════════════
::  SKILLS UNINSTALLER v2.4
::  Go cai dat custom skills
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

set TOTAL=9
set "SKILL[1]=ba-role"
set "SKILL[2]=bug-fix-pipeline"
set "SKILL[3]=code-review-pipeline"
set "SKILL[4]=dev-role"
set "SKILL[5]=google-play-aso"
set "SKILL[6]=ops-role"
set "SKILL[7]=pm-role"
set "SKILL[8]=qa-qc-role"
set "SKILL[9]=tech-lead-review"

echo.
echo ===============================================================
echo   SKILLS UNINSTALLER v2.4 - Windows
echo ===============================================================
echo.
echo   Target: %TARGET_DIR%
echo.

echo   Se go cac skills sau:
for /L %%i in (1,1,%TOTAL%) do (
    set "NAME=!SKILL[%%i]!"
    if exist "%TARGET_DIR%\!NAME!\" (
        echo     [X] !NAME!
    ) else (
        echo     [-] !NAME! (khong ton tai)
    )
)

echo.
echo   CANH BAO: Thao tac nay khong the hoan tac!
set /p "CONFIRM=  Xac nhan go cai dat? [y/N] "
if /i not "%CONFIRM%"=="Y" (
    echo.
    echo   Da huy.
    pause
    exit /b 0
)

echo.
set REMOVED=0

for /L %%i in (1,1,%TOTAL%) do (
    set "NAME=!SKILL[%%i]!"
    if exist "%TARGET_DIR%\!NAME!\" (
        rmdir /s /q "%TARGET_DIR%\!NAME!" >nul 2>&1
        echo   [X] !NAME! - da go
        set /a REMOVED+=1
    )
)

echo.
echo ===============================================================
echo   [V] Da go !REMOVED! skills
echo ===============================================================
echo.
pause
