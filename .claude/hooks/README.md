# Conductor Hooks Documentation

This directory contains hooks that automate documentation and context management throughout the TDD workflow.

## Hook Types

### Session Hooks

#### `session-start-context.sh` (SessionStart)
**When**: At the start of every Claude Code session
**Purpose**: Load project context and suggest next actions
**Features**:
- Shows current task from CURRENT_TASK.md
- Loads most recent feature context
- Displays CLAUDE.md knowledge base stats (problems solved, patterns, decisions)
- Shows current development stage
- Checks for blockers and critical questions
- Suggests appropriate slash command based on stage
- Shows recent git commits

**Output Example**:
```
📖 Loading project context...

Current Task:
**What I'm working on:** Testing Feature Workflow System with Dark Mode Toggle
**Goal:** Validate the new TDD-based feature workflow with a real example

📚 Active Features with Knowledge Base: 1
   📍 Most Recent: F001-dark-mode-toggle

💡 Recent Context from CLAUDE.md:
   - 3 architectural decisions recorded
   - Implementation iterations tracked

   **Current Stage**: 📐 Architecture Complete

🎯 Next Actions:
   - Continue work on feature branch: master
   - Run /test-first to create comprehensive tests
```

### Validation Hooks

#### `validate-docs.sh` (PreCommit)
**When**: Before git commit
**Purpose**: Ensure documentation stays synchronized with code changes
**Validations**:
- CLAUDE.md structure (required sections present)
- STATUS.md structure and required fields
- STATUS.md "Last Updated" date is current
- Major changes have corresponding decision logs
- New implementation files have corresponding tests
- Markdown syntax is valid

**Errors vs Warnings**:
- ❌ **Errors** (block commit): Missing required sections, invalid markdown
- ⚠️  **Warnings** (allow commit): Missing decision logs, outdated timestamps, no tests

**How to Skip** (if needed):
```bash
git commit --no-verify -m "message"
```

### Progress Tracking Hooks

#### `auto-update-progress.sh` (PostToolUse)
**When**: After file edits, command execution, slash commands
**Purpose**: Automatically update CLAUDE.md and STATUS.md
**Triggers**:
- **Write/Edit tools**: Updates timestamps when src/ or tests/ modified
- **Test execution**: Logs test runs in CLAUDE.md
- **Slash commands** (/architect, /test-first, /implement, etc.):
  - Updates STATUS.md with activity entry
  - Logs workflow milestone in CLAUDE.md
  - Updates "Last Updated" timestamp

**Auto-Generated Entries**:
```markdown
### 2025-11-19 14:30
**Stage**: Testing
**Action**: Test suite created
**By**: Automated (hook)
**Details**: Ran /test-first command - comprehensive tests written
```

#### `sync-progress-on-commit.sh` (PostCommit)
**When**: After successful git commit
**Purpose**: Sync metrics and progress with committed changes
**Updates**:
- **STATUS.md Metrics**:
  - Files Modified count
  - Lines Added count
  - Lines Removed count
  - Tests Passing count (if detected in commit message)
- **CLAUDE.md Implementation Journey**:
  - Commit hash and timestamp
  - Work type (Tests, Implementation, or Both)
  - Commit message summary
  - Files changed breakdown

**Auto-Generated Entries**:
```markdown
**Commit a3b4c5d** (2025-11-19 15:45): Implementation + Tests
- Add theme storage module with localStorage persistence
- Files changed: 2 src, 3 tests
```

### Decision Capture Hooks

#### `suggest-adr.sh` (PostToolUse - inherited)
**When**: After significant architectural changes
**Purpose**: Remind user to document architectural decisions
**Triggers**: Changes to ARCHITECTURE.md or major refactoring

#### `create-adr-draft.sh` (on-demand - inherited)
**When**: User creates new ADR
**Purpose**: Generate ADR template with context

## Slash Commands

### `/load-context`
**Purpose**: Load relevant CLAUDE.md sections for current work
**Use Case**: Starting work on a feature, need quick context
**Features**:
- Detects current feature from branch or modified files
- Loads and filters CLAUDE.md sections by relevance
- Surfaces architectural decisions, learnings, blockers
- Suggests next steps

**Example**:
```
User: /load-context

Output:
📚 Context Loaded: F001-dark-mode-toggle

## Current Stage
Architecture Complete

## Relevant Architectural Decisions
- **Three-Module Architecture**: Separated into ThemeStorage, ThemeManager, ThemeUI for testability
- **CSS Custom Properties**: Using CSS variables for instant theme switching

## Suggested Next Steps
1. Run /test-first to create comprehensive tests
2. Focus on ThemeStorage unit tests first (localStorage integration)
```

## Hook Configuration

All hooks are automatically executed by Claude Code. No manual configuration needed.

### Disabling Hooks Temporarily

If you need to disable a hook temporarily:

```bash
# Rename to .disabled
mv .claude/hooks/validate-docs.sh .claude/hooks/validate-docs.sh.disabled

# Re-enable later
mv .claude/hooks/validate-docs.sh.disabled .claude/hooks/validate-docs.sh
```

### Hook Debugging

To see hook output:
```bash
# Run hook manually
./.claude/hooks/session-start-context.sh

# Check hook execution in git
git config --local core.hooksPath
```

## Living Documentation Workflow

### Daily Routine

**Session Start**:
1. `session-start-context.sh` runs automatically → Shows context
2. User sees current task, blockers, next actions
3. User runs suggested slash command

**During Development**:
1. User edits code → `auto-update-progress.sh` updates timestamps
2. User runs `/test-first` → Activity logged in STATUS.md
3. User makes architectural decision → Document in CLAUDE.md

**Before Commit**:
1. `validate-docs.sh` runs → Checks documentation consistency
2. Fix any errors or warnings
3. Commit succeeds

**After Commit**:
1. `sync-progress-on-commit.sh` runs → Updates metrics
2. CLAUDE.md gets commit summary
3. STATUS.md metrics updated

### Cross-Session Continuity

**End of Session**:
- STATUS.md has latest updates
- CLAUDE.md captures decisions and learnings
- Git commits have progress metrics

**Next Session Start**:
- `session-start-context.sh` loads exact state
- User sees where they left off
- Suggested next action based on stage

## Best Practices

### When to Update CLAUDE.md Manually

Auto-updates handle timestamps and metrics, but you should manually add:
- **Problem-Solution Pairs**: When you solve a tricky problem
- **Failed Approaches**: When something doesn't work, document why
- **Successful Patterns**: When you discover a reusable pattern
- **Architectural Decisions**: Major design choices (hook will remind you)

### When to Update STATUS.md Manually

Auto-updates handle activity logs and metrics, but you should manually:
- Change current stage when moving to new phase
- Add blockers when you get stuck
- Update next steps when priorities change
- Adjust progress percentage for overall completion

### Commit Message Best Practices

For best auto-tracking:
- Include feature ID: "F001: Add theme storage"
- Mention test status: "All 12 tests passing"
- Use conventional commits: "feat:", "test:", "fix:"

## Troubleshooting

### Hook Not Running
```bash
# Check if executable
ls -la .claude/hooks/

# Make executable
chmod +x .claude/hooks/*.sh
```

### Hook Errors
Check the hook output in terminal. Most hooks exit gracefully on errors.

### Documentation Out of Sync
Run validation manually:
```bash
./.claude/hooks/validate-docs.sh
```

## Architecture

### Hook Dependencies

```
session-start-context.sh
├── Reads: CURRENT_TASK.md, STATUS.md, CLAUDE.md
└── No modifications

validate-docs.sh (PreCommit)
├── Reads: CLAUDE.md, STATUS.md, git diff
└── No modifications (validation only)

auto-update-progress.sh (PostToolUse)
├── Reads: STATUS.md, CLAUDE.md
└── Writes: STATUS.md (timestamp), CLAUDE.md (iterations)

sync-progress-on-commit.sh (PostCommit)
├── Reads: git log, git diff-tree
└── Writes: STATUS.md (metrics), CLAUDE.md (commit log)
```

### Data Flow

```
[Code Changes]
     ↓
[auto-update-progress.sh] → STATUS.md (timestamp)
     ↓                      → CLAUDE.md (iteration note)
[git add]
     ↓
[validate-docs.sh] → Check consistency
     ↓
[git commit]
     ↓
[sync-progress-on-commit.sh] → STATUS.md (metrics)
                               → CLAUDE.md (commit summary)
```

## Future Enhancements

Planned improvements:
- [ ] Test coverage tracking from test output
- [ ] Performance metrics tracking
- [ ] Automatic decision extraction from code comments
- [ ] Cross-feature pattern detection
- [ ] Team knowledge aggregation
- [ ] AI-powered context relevance scoring
