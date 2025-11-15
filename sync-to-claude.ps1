#!/usr/bin/env pwsh
# Sync Conductor framework to global Claude Code directory (PowerShell version)

$ErrorActionPreference = "SilentlyContinue"

$SOURCE_DIR = Join-Path $PSScriptRoot ".claude"
$DEST_DIR = Join-Path $env:USERPROFILE ".claude"

Write-Host ""
Write-Host "🔄 Syncing Conductor framework to Claude Code..." -ForegroundColor Cyan
Write-Host ""

# Copy agents
Write-Host "  📋 Syncing agents..." -ForegroundColor Yellow
$agentsSource = Join-Path $SOURCE_DIR "agents\*"
$agentsDest = Join-Path $DEST_DIR "agents"
Copy-Item -Path $agentsSource -Destination $agentsDest -Recurse -Force -ErrorAction SilentlyContinue
if (-not $?) { Write-Host "    No agents to sync" -ForegroundColor Gray }

# Copy skills
Write-Host "  ⚡ Syncing skills..." -ForegroundColor Yellow
$skillsSource = Join-Path $SOURCE_DIR "skills\*"
$skillsDest = Join-Path $DEST_DIR "skills"
Copy-Item -Path $skillsSource -Destination $skillsDest -Recurse -Force -ErrorAction SilentlyContinue
if (-not $?) { Write-Host "    No skills to sync" -ForegroundColor Gray }

# Copy hooks
Write-Host "  🪝 Syncing hooks..." -ForegroundColor Yellow
$hooksSource = Join-Path $SOURCE_DIR "hooks\*"
$hooksDest = Join-Path $DEST_DIR "hooks"
Copy-Item -Path $hooksSource -Destination $hooksDest -Recurse -Force -ErrorAction SilentlyContinue
if (-not $?) { Write-Host "    No hooks to sync" -ForegroundColor Gray }

# Copy templates directory
Write-Host "  📄 Syncing templates..." -ForegroundColor Yellow
$templatesSource = Join-Path $SOURCE_DIR "templates"
$templatesDest = Join-Path $DEST_DIR "templates"
Copy-Item -Path $templatesSource -Destination $templatesDest -Recurse -Force -ErrorAction SilentlyContinue
if (-not $?) { Write-Host "    No templates to sync" -ForegroundColor Gray }

# Copy template files
Write-Host "  📋 Syncing template files..." -ForegroundColor Yellow
Copy-Item -Path (Join-Path $SOURCE_DIR "AGENT-TEMPLATE.md") -Destination $DEST_DIR -Force -ErrorAction SilentlyContinue
Copy-Item -Path (Join-Path $SOURCE_DIR "SKILL-TEMPLATE.md") -Destination $DEST_DIR -Force -ErrorAction SilentlyContinue

# Extract version from plugin.json
$pluginJson = Get-Content -Path ".claude-plugin\plugin.json" -Raw | ConvertFrom-Json
$version = $pluginJson.version

Write-Host ""
Write-Host "✅ Conductor framework synced! (version $version)" -ForegroundColor Green
Write-Host ""
Write-Host "⚠️  Restart Claude Code to see changes" -ForegroundColor Yellow
Write-Host ""
