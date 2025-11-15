# Hooks Guide - AI-Augmented Workflow Framework

**Purpose**: Documentation for implemented hooks (auto-formatting, documentation suggestions)

---

## Overview

Hooks are shell commands that execute automatically at specific points in Claude Code's lifecycle. This framework implements **3 hooks** for automation:

1. **Auto-formatting** (PostToolUse)
2. **SESSION_STATE update suggestions** (Stop)
3. **ADR creation suggestions** (SubagentStop)

---

## Hook 1: Auto-Formatting

**Event**: `PostToolUse`
**Matcher**: `Edit|Write`
**Script**: `.claude/hooks/auto-format.sh`

### What It Does

Automatically formats code files after you edit or write them using language-specific formatters:

- **JavaScript/TypeScript**: Prettier → ESLint
- **Python**: Black → autopep8
- **Go**: gofmt
- **Rust**: rustfmt
- **Java**: google-java-format
- **Markdown**: Prettier

### How It Works

```bash
# After you edit a file:
Edit: src/app.js

# Hook automatically runs:
prettier --write src/app.js
# Output: ✓ Formatted with Prettier: src/app.js
```

### Configuration

Located in `.claude/settings.json`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "command": "bash .claude/hooks/auto-format.sh \"{{file_path}}\" \"{{tool_name}}\"",
        "description": "Auto-format code files after edits"
      }
    ]
  }
}
```

### Requirements

Install formatters for the languages you use:

```bash
# JavaScript/TypeScript
npm install -g prettier eslint

# Python
pip install black autopep8

# Go (built-in)
# gofmt comes with Go installation

# Rust (built-in)
# rustfmt comes with Rust installation

# Java
# Download google-java-format
```

### Disabling

To disable auto-formatting for specific files, add to `.prettierignore`, `.eslintignore`, etc.

To disable the hook entirely, remove the `PostToolUse` section from `.claude/settings.json`.

---

## Hook 2: SESSION_STATE Update Suggestions

**Event**: `Stop`
**Matcher**: `*`
**Script**: `.claude/hooks/suggest-session-state-update.sh`

### What It Does

Reminds you to update `docs/SESSION_STATE.md` if it hasn't been updated in > 1 hour.

### How It Works

```bash
# When Claude finishes a response (Stop event):
# If SESSION_STATE.md last modified > 1 hour ago:

📝 SESSION_STATE.md hasn't been updated in 2 hours.
   Consider updating with today's progress:
   - Add accomplishments to 'Key Accomplishments'
   - Update 'Current Status' section
   - Refresh 'Next Steps'
```

### Configuration

```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "*",
        "command": "bash .claude/hooks/suggest-session-state-update.sh",
        "description": "Suggest SESSION_STATE.md update after significant work"
      }
    ]
  }
}
```

### Customization

Edit `.claude/hooks/suggest-session-state-update.sh` to change the time threshold:

```bash
# Current: 1 hour (3600 seconds)
if [ $TIME_DIFF -gt 3600 ]; then

# Change to 30 minutes:
if [ $TIME_DIFF -gt 1800 ]; then

# Change to 2 hours:
if [ $TIME_DIFF -gt 7200 ]; then
```

---

## Hook 3: ADR Creation Suggestions

**Event**: `SubagentStop`
**Matcher**: `*`
**Script**: `.claude/hooks/suggest-adr.sh`

### What It Does

Detects when an architectural decision has been made (based on keywords) and suggests creating an ADR (Architecture Decision Record).

### How It Works

```bash
# When a subagent completes and its output contains decision keywords:
# (decided, chose, selected, pattern, architecture, design, etc.)

📋 This looks like an architectural decision.
   Consider creating an ADR (Architecture Decision Record):
   1. Copy docs/decisions/ADR-TEMPLATE.md
   2. Document: Context, Decision, Consequences, Alternatives
   3. Save as: docs/decisions/YYYY-MM-DD-title.md
```

### Trigger Keywords

The hook looks for these keywords in agent output:
- decided
- chose
- selected
- pattern
- architecture
- design
- approach
- strategy
- trade-off

### Configuration

```json
{
  "hooks": {
    "SubagentStop": [
      {
        "matcher": "*",
        "command": "bash .claude/hooks/suggest-adr.sh \"{{agent_name}}\" \"{{agent_output}}\"",
        "description": "Suggest ADR creation for architectural decisions"
      }
    ]
  }
}
```

### Customization

Edit `.claude/hooks/suggest-adr.sh` to add/remove trigger keywords:

```bash
# Add more keywords:
DECISION_KEYWORDS="decided|chose|selected|pattern|architecture|design|approach|strategy|trade-off|refactor|migrate"
```

---

## Hook Variables

Claude Code provides these variables to hooks:

- `{{file_path}}` - Path to the file operated on
- `{{tool_name}}` - Name of the tool used (Edit, Write, Bash, etc.)
- `{{agent_name}}` - Name of the subagent (for SubagentStop)
- `{{agent_output}}` - Output from the subagent

---

## Testing Hooks

### Test Auto-Formatting

```bash
# Create a poorly formatted file
echo "function test(){console.log('test');}" > test.js

# Edit it with Claude Code
# The hook should auto-format it:
# function test() {
#   console.log("test");
# }
```

### Test SESSION_STATE Suggestions

```bash
# Modify SESSION_STATE.md timestamp to be > 1 hour old
touch -t 202511140900 docs/SESSION_STATE.md

# Trigger a Stop event (complete any Claude response)
# You should see the suggestion message
```

### Test ADR Suggestions

```bash
# Use an agent that makes decisions (architecture-advisor, refactoring-guide)
# The output should trigger the ADR suggestion
```

---

## Troubleshooting

### Hook Not Running

1. **Check permissions**:
   ```bash
   chmod +x .claude/hooks/*.sh
   ```

2. **Check settings.json syntax**:
   ```bash
   # Validate JSON
   cat .claude/settings.json | python -m json.tool
   ```

3. **Check hook script paths**:
   ```bash
   # Ensure scripts exist
   ls -la .claude/hooks/
   ```

### Formatter Not Found

```bash
# Check if formatter is installed
which prettier  # JavaScript/TypeScript
which black     # Python
which gofmt     # Go
which rustfmt   # Rust
```

Install missing formatters using package managers.

### Hook Errors

Check hook output in Claude Code logs:

```bash
# Hooks output to stderr
# Check recent errors
tail -f ~/.claude/logs/hooks.log  # (if logging is enabled)
```

---

## Adding New Hooks

### Example: Auto-Log Bash Commands

Create `.claude/hooks/log-bash.sh`:

```bash
#!/bin/bash
COMMAND="$1"
DESCRIPTION="$2"

echo "$(date): $COMMAND - $DESCRIPTION" >> .claude/bash-log.txt
```

Add to `.claude/settings.json`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Bash",
        "command": "bash .claude/hooks/log-bash.sh \"{{command}}\" \"{{description}}\"",
        "description": "Log all bash commands"
      }
    ]
  }
}
```

### Example: Validate Commit Messages

Create `.claude/hooks/validate-commit.sh`:

```bash
#!/bin/bash
MESSAGE="$1"

# Require format: "type: description"
if ! echo "$MESSAGE" | grep -qE "^(feat|fix|docs|refactor|test|chore): .+"; then
  echo "❌ Commit message must follow format: type: description"
  echo "   Types: feat, fix, docs, refactor, test, chore"
  exit 1  # Block the commit
fi
```

Add to `.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash:git commit",
        "command": "bash .claude/hooks/validate-commit.sh \"{{message}}\"",
        "description": "Validate commit message format"
      }
    ]
  }
}
```

---

## Best Practices

### 1. Keep Hooks Fast
- Hooks run synchronously (block workflow)
- Use background processing for slow operations
- Exit quickly for non-applicable files

### 2. Handle Errors Gracefully
- Always `exit 0` for non-critical issues
- Use `exit 1` only to block operations (PreToolUse)
- Don't crash on missing formatters

### 3. Provide Clear Feedback
- Echo success messages for user awareness
- Use emojis for visual distinction (✓, 📝, 📋, ❌)

### 4. Test Before Deploying
- Test hooks with various file types
- Verify error handling
- Check performance with large files

### 5. Document Custom Hooks
- Add description in settings.json
- Update this guide with new hooks
- Provide examples of usage

---

## Security Considerations

### Hooks Run with Your Credentials

Hooks execute in your shell environment with your permissions. **Never** run untrusted hook scripts.

### Validate Inputs

Always validate hook inputs:

```bash
# Good
FILE_PATH="$1"
if [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

# Bad - could execute arbitrary code
eval "$1"  # NEVER DO THIS
```

### Limit Tool Access

Use `.claude/settings.json` permissions to restrict hook access:

```json
{
  "permissions": {
    "allow": [
      "Bash(.claude/hooks/*)"  # Only allow hooks directory
    ]
  }
}
```

---

## Summary

**Implemented Hooks**:
- ✅ Auto-formatting (Prettier, Black, gofmt, etc.)
- ✅ SESSION_STATE update suggestions (> 1 hour)
- ✅ ADR creation suggestions (architectural decisions)

**Benefits**:
- Consistent code formatting automatically
- Never forget to update SESSION_STATE
- Systematic decision documentation

**Next Steps**:
- Install formatters for your languages
- Test hooks with sample files
- Customize thresholds as needed
- Add custom hooks for your workflow

---

**Last Updated**: 2025-11-15
**Version**: 1.0
