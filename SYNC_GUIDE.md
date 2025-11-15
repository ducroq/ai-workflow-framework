# Syncing Conductor to Claude Code

After making changes to the Conductor framework, use these scripts to sync to your global Claude Code directory.

## Usage

### Windows (Batch)
```cmd
sync-to-claude.bat
```

Double-click the file or run from Command Prompt.

### Windows (PowerShell)
```powershell
.\sync-to-claude.ps1
```

Run from PowerShell. If you get an execution policy error:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
.\sync-to-claude.ps1
```

### Linux/Mac (Bash)
```bash
./sync-to-claude.sh
```

## What Gets Synced

The scripts copy from your development directory to `~/.claude/`:

- ✅ **Agents** - All agents from `.claude/agents/`
- ✅ **Skills** - All skills from `.claude/skills/`
- ✅ **Hooks** - All hooks from `.claude/hooks/`
- ✅ **Templates** - Document templates from `.claude/templates/`
- ✅ **Template files** - AGENT-TEMPLATE.md, SKILL-TEMPLATE.md

## Complete Update Workflow

```bash
# 1. Make changes to Conductor
# Edit agents, add features, fix bugs, etc.

# 2. Test locally (optional)
# Sync and test in a sample project

# 3. Commit to git
git add .
git commit -m "Description of changes"
git push

# 4. Sync to Claude Code
./sync-to-claude.sh    # or .bat or .ps1

# 5. Restart Claude Code
# Close and reopen to see changes
```

## After Syncing

**Important**: You must restart Claude Code for changes to take effect!

All projects using Conductor will automatically get the updates:
- New agents become available
- Updated agents have new behavior
- New hooks start working
- Template updates apply to new bootstraps

## Troubleshooting

**"Permission denied" (Linux/Mac)**:
```bash
chmod +x sync-to-claude.sh
```

**"Execution policy" error (Windows PowerShell)**:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Changes not appearing**:
1. Make sure you ran the sync script
2. Restart Claude Code completely (close all windows)
3. Check that files copied correctly: `ls ~/.claude/agents/meta/`

## Version Management

The sync scripts automatically detect and display the framework version from `plugin.json`.

When you bump the version:
1. Update `.claude-plugin/plugin.json`
2. Update `README.md`
3. Run sync script
4. Tag the release: `git tag v1.2.0 && git push --tags`

## Notes

- These scripts only sync **from** your dev directory **to** Claude Code
- They don't modify your development directory
- Safe to run multiple times (overwrites destination)
- Existing agents/skills in Claude Code that aren't in Conductor won't be deleted
