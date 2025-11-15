@echo off
REM Sync Conductor framework to global Claude Code directory (Windows batch version)

set SOURCE_DIR=%~dp0.claude
set DEST_DIR=%USERPROFILE%\.claude

echo.
echo 🔄 Syncing Conductor framework to Claude Code...
echo.

REM Copy agents
echo   📋 Syncing agents...
xcopy /E /I /Y "%SOURCE_DIR%\agents\*" "%DEST_DIR%\agents\" >nul 2>&1
if errorlevel 1 echo     No agents to sync

REM Copy skills
echo   ⚡ Syncing skills...
xcopy /E /I /Y "%SOURCE_DIR%\skills\*" "%DEST_DIR%\skills\" >nul 2>&1
if errorlevel 1 echo     No skills to sync

REM Copy hooks
echo   🪝 Syncing hooks...
xcopy /E /I /Y "%SOURCE_DIR%\hooks\*" "%DEST_DIR%\hooks\" >nul 2>&1
if errorlevel 1 echo     No hooks to sync

REM Copy templates directory
echo   📄 Syncing templates...
xcopy /E /I /Y "%SOURCE_DIR%\templates" "%DEST_DIR%\templates\" >nul 2>&1
if errorlevel 1 echo     No templates to sync

REM Copy template files
echo   📋 Syncing template files...
copy /Y "%SOURCE_DIR%\AGENT-TEMPLATE.md" "%DEST_DIR%\" >nul 2>&1
copy /Y "%SOURCE_DIR%\SKILL-TEMPLATE.md" "%DEST_DIR%\" >nul 2>&1

REM Extract version from plugin.json
for /f "tokens=2 delims=:, " %%a in ('findstr /C:"\"version\"" .claude-plugin\plugin.json') do (
    set VERSION=%%a
    set VERSION=!VERSION:"=!
)

echo.
echo ✅ Conductor framework synced!
echo.
echo ⚠️  Restart Claude Code to see changes
echo.
pause
