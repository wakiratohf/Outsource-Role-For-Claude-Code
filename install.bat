@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion

:: ═══════════════════════════════════════════════════════════
::  SKILLS INSTALLER v2.1
::  Cài đặt custom skills cho Claude Code / Claude Desktop
::  Target: %USERPROFILE%\.claude\skills\
::  Ngày build: 2026-04-15
:: ═══════════════════════════════════════════════════════════

set "SCRIPT_DIR=%~dp0"
set "SKILLS_SOURCE=%SCRIPT_DIR%skills"

if not "%~1"=="" (
    set "TARGET_DIR=%~1"
) else (
    if defined CLAUDE_CONFIG_DIR (
        set "TARGET_DIR=%CLAUDE_CONFIG_DIR%\skills"
    ) else (
        set "TARGET_DIR=%USERPROFILE%\.claude\skills"
    )
)

set TOTAL=8
set "SKILL[1]=ba-role"
set "DESC[1]=Business Analyst / Solution Architect"
set "SKILL[2]=bug-fix-pipeline"
set "DESC[2]=Bug Fix Pipeline (Auto Accept v2)"
set "SKILL[3]=code-review-pipeline"
set "DESC[3]=Code Review Pipeline (Auto Accept v2)"
set "SKILL[4]=dev-role"
set "DESC[4]=Developer / Tech Lead / DevOps"
set "SKILL[5]=google-play-aso"
set "DESC[5]=Google Play ASO"
set "SKILL[6]=ops-role"
set "DESC[6]=Release Manager / SysAdmin / SRE"
set "SKILL[7]=pm-role"
set "DESC[7]=Project Manager / Scrum Master"
set "SKILL[8]=qa-qc-role"
set "DESC[8]=QA Lead / QC Engineer / Automation"

echo.
echo ═══════════════════════════════════════════════════════════
echo   SKILLS INSTALLER v2.1 — Windows
echo ═══════════════════════════════════════════════════════════
echo.
echo   Skills:  %TOTAL% skills
echo   Target:  %TARGET_DIR%
echo.

:: Kiểm tra source
if not exist "%SKILLS_SOURCE%\" (
    echo   [X] Không tìm thấy thư mục skills\
    echo       Hãy chạy script từ thư mục đã giải nén.
    pause
    exit /b 1
)

:: Hiển thị danh sách
echo   Danh sách:
for /L %%i in (1,1,%TOTAL%) do (
    set "NAME=!SKILL[%%i]!"
    set "DESC=!DESC[%%i]!"
    if exist "%SKILLS_SOURCE%\!NAME!\SKILL.md" (
        echo     [%%i/%TOTAL%] !NAME! — !DESC!
    ) else (
        echo     [%%i/%TOTAL%] !NAME! — THIEU FILE!
    )
)

echo.
set /p "CONFIRM=  Bắt đầu cài đặt? [Y/n] "
if /i not "%CONFIRM%"=="Y" if not "%CONFIRM%"=="" (
    echo.
    echo   Đã huỷ.
    pause
    exit /b 0
)

echo.

:: Tạo thư mục gốc
if not exist "%TARGET_DIR%\" mkdir "%TARGET_DIR%"

:: Cài đặt
set INSTALLED=0
set FAILED=0

for /L %%i in (1,1,%TOTAL%) do (
    set "NAME=!SKILL[%%i]!"
    set "SRC=%SKILLS_SOURCE%\!NAME!\SKILL.md"
    set "DST=%TARGET_DIR%\!NAME!\SKILL.md"

    if not exist "!SRC!" (
        echo   [X] !NAME! — không tìm thấy source
        set /a FAILED+=1
    ) else (
        if not exist "%TARGET_DIR%\!NAME!\" mkdir "%TARGET_DIR%\!NAME!"

        if exist "!DST!" (
            copy /y "!DST!" "!DST!.bak" >nul 2>&1
            echo   [~] !NAME! — backup → SKILL.md.bak
        )

        copy /y "!SRC!" "!DST!" >nul 2>&1
        echo   [V] !NAME!
        set /a INSTALLED+=1
    )
)

echo.
echo ═══════════════════════════════════════════════════════════
if !FAILED!==0 (
    echo   [V] HOÀN TẤT — !INSTALLED!/%TOTAL% skills
    echo   Target: %TARGET_DIR%
) else (
    echo   [!] !INSTALLED! OK, !FAILED! lỗi
)
echo ═══════════════════════════════════════════════════════════
echo.
echo   Khởi động lại Claude Code / Claude Desktop để load skills.
echo.
pause
