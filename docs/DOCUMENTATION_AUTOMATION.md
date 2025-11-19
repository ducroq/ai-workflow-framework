# Documentation Automation Guide

**Last Updated**: 2025-11-19
**Version**: 1.0.0

---

## Overview

Conductor implements **living documentation** - documentation that automatically updates throughout your TDD workflow. This guide explains how the automation works and how to use it effectively.

## Core Concept: CLAUDE.md as Project Memory

Every feature has a `CLAUDE.md` file serving as persistent knowledge base containing:

- **Architectural Decisions**: Why choices were made (ADRs)
- **Implementation Journey**: Iteration tracking with timestamps
- **Problem-Solution Pairs**: Challenges solved during development
- **Failed Approaches**: What didn't work and why
- **Successful Patterns**: Reusable solutions discovered
- **Test Strategy**: Testing approach and edge cases
- **Key Learnings**: What went well, what could improve

**Purpose**: Maintain context between sessions, share team knowledge, accelerate future features.

---

## Automated Workflows

### 1. Session Startup (Automatic)

**Hook**: `session-start-context.sh`
**Trigger**: Every time you start Claude Code
**What It Does**:
- Loads current task from `CURRENT_TASK.md`
- Identifies most recent feature being worked on
- Shows CLAUDE.md knowledge stats (decisions, problems solved, patterns)
- Displays current development stage
- Checks for blockers and critical questions
- Suggests next slash command based on stage
- Shows recent git commits

**Example Output**:
```
📖 Loading project context...

Current Task:
**What I'm working on:** F001 Dark Mode Toggle
**Goal:** Validate TDD workflow

📚 Active Features with Knowledge Base: 1
   📍 Most Recent: F001-dark-mode-toggle

💡 Recent Context from CLAUDE.md:
   - 3 architectural decisions recorded
   - Implementation iterations tracked

   **Current Stage**: 📐 Architecture Complete

🎯 Next Actions:
   - Run /test-first to create comprehensive tests

📝 Recent Commits:
   bc7226e Update local permissions
   65c496e Clean up repository structure
```

### 2. Pre-Commit Validation (Automatic)

**Hook**: `validate-docs.sh`
**Trigger**: Before every `git commit`
**What It Validates**:

**CLAUDE.md**:
- ✅ All required sections present
- ✅ Valid markdown structure
- ⚠️  Recent decisions logged for major changes

**STATUS.md**:
- ✅ All required sections present
- ✅ "Last Updated" field exists
- ⚠️  Timestamp is current for modified features

**Test Coverage**:
- ⚠️  New implementation files have corresponding tests

**Exit Codes**:
- `0` - All validations passed
- `1` - Errors found (commit blocked)

**Override** (use sparingly):
```bash
git commit --no-verify -m "message"
```

### 3. Progress Auto-Update (Automatic)

**Hook**: `auto-update-progress.sh`
**Trigger**: After file edits, test runs, slash commands
**What It Updates**:

**On Code Edit**:
- Updates STATUS.md timestamp
- Logs test modifications in CLAUDE.md

**On Slash Command** (`/architect`, `/test-first`, `/implement`, etc.):
- Adds activity entry to STATUS.md
- Updates CLAUDE.md with workflow milestone
- Updates "Last Updated" timestamp

**Example Auto-Generated Entry** (STATUS.md):
```markdown
### 2025-11-19 14:30
**Stage**: Testing
**Action**: Test suite created
**By**: Automated (hook)
**Details**: Ran /test-first command - comprehensive tests written
```

### 4. Commit Sync (Automatic)

**Hook**: `sync-progress-on-commit.sh`
**Trigger**: After successful `git commit`
**What It Syncs**:

**STATUS.md Metrics**:
- Files Modified: +[count]
- Lines Added: +[count]
- Lines Removed: +[count]
- Tests Passing: [count] (if in commit message)

**CLAUDE.md Implementation Journey**:
```markdown
**Commit a3b4c5d** (2025-11-19 15:45): Implementation + Tests
- Add theme storage module with localStorage persistence
- Files changed: 2 src, 3 tests
```

**Best Commit Messages for Auto-Tracking**:
```bash
git commit -m "F001: Add ThemeStorage module with 4 tests passing"
git commit -m "test: All 14 unit tests passing for ThemeManager"
git commit -m "feat: Complete dark mode toggle - 33 tests passing"
```

---

## Manual Documentation Tasks

While many updates are automatic, you should **manually document**:

### In CLAUDE.md

#### 1. Problem-Solution Pairs
**When**: You solve a non-trivial problem
**Format**:
```markdown
### Problem: ThemeStorage - localStorage Disabled in Privacy Mode
**Context**: Users in private browsing mode have localStorage disabled

**Problem**: Application crashed when accessing localStorage.setItem()

**Solution**: Wrapped all localStorage access in try-catch with fallback to in-memory storage

**Iteration**: Solved on iteration #3

**Code Reference**: `src/theme/storage.js:15-30`
```

#### 2. Failed Approaches
**When**: Something doesn't work, document before trying alternative
**Format**:
```markdown
### Tried: CSS-in-JS with Styled Components
**What I tried**: Use styled-components library for dynamic theming

**Why it failed**:
- Added 50KB to bundle size
- Performance impact on theme toggle (400ms vs < 50ms requirement)
- Overkill for simple color switching

**What worked instead**: CSS custom properties with single class toggle

**Lesson**: Prefer native CSS features for simple use cases
```

#### 3. Successful Patterns
**When**: You discover a reusable approach
**Format**:
```markdown
### Working Pattern: Module Pattern for Vanilla JS
**Use case**: Need testable modules without build tools

**Implementation**:
```javascript
const ThemeStorage = {
  save(theme) { /* ... */ },
  load() { /* ... */ },
  isAvailable() { /* ... */ }
};
```

**Tests covered**: All ThemeStorage unit tests (4/4 passing)

**Rationale**: Simple, testable, no transpilation needed
```

#### 4. Architectural Decisions
**When**: Making significant design choices
**Format**:
```markdown
### Decision 4: Three-Module Architecture
**Date**: 2025-11-19

**Context**: Need maintainable, testable code structure

**Decision**: Separate into ThemeStorage, ThemeManager, ThemeUI modules

**Alternatives Considered**:
1. Single monolithic file - Hard to test
2. Class-based OOP - More boilerplate
3. Framework (React/Vue) - Adds dependencies

**Rationale**: Clear separation of concerns, easy to test in isolation

**Consequences**:
- ✅ Benefits: Testable, maintainable, extensible
- ⚠️ Trade-offs: More files than monolithic

**Status**: Accepted
```

### In STATUS.md

#### 1. Stage Changes
**When**: Moving to new development phase
```markdown
**Current Stage**: 🧪 Testing Complete
```

#### 2. Blockers
**When**: You get stuck
```markdown
## Current Blockers

| Task | Blocker | Owner | ETA |
|------|---------|-------|-----|
| T007 | Need to mock localStorage for Jest | Developer | 2025-11-20 |
```

#### 3. Progress Percentage
**When**: Major milestone completed
```markdown
**Overall Completion**: 60%  # Was 30%, now architecture + tests done
```

---

## Slash Commands

### `/load-context`

**Purpose**: Load relevant CLAUDE.md sections
**Use Case**: Starting work, need quick context
**How It Works**:
1. Detects current feature from branch/files
2. Reads CLAUDE.md and STATUS.md
3. Filters sections by relevance
4. Surfaces decisions, learnings, blockers
5. Suggests next steps

**Example**:
```bash
User: /load-context

Output:
📚 Context Loaded: F001-dark-mode-toggle

## Current Stage
Architecture Complete

## Relevant Architectural Decisions
- **Three-Module Architecture**: ThemeStorage, ThemeManager, ThemeUI
  Why it matters: Keep modules independent for testing

## Recent Progress
- Architecture designed with 5 decisions
- 33 tests planned (14 unit, 5 integration, 6 E2E, 5 a11y, 3 perf)

## Suggested Next Steps
1. Run /test-first to create comprehensive tests
2. Start with ThemeStorage unit tests (localStorage focus)
3. Document test strategy in CLAUDE.md
```

---

## Daily Workflow

### Morning - Session Start

1. **Start Claude Code** → `session-start-context.sh` runs automatically
2. **Review context**: Current task, blockers, next actions
3. **Load detailed context** (if needed): `/load-context`
4. **Begin work**: Run suggested slash command

### During Development

1. **Make architectural decision** → Document in CLAUDE.md (manual)
2. **Edit code** → Auto-updates timestamps
3. **Run slash command** → Auto-logs in STATUS.md
4. **Solve problem** → Document in CLAUDE.md (manual)
5. **Try something that fails** → Document failed approach (manual)

### Before Commit

1. **Stage changes**: `git add .`
2. **Commit**: `git commit -m "F001: Message"`
3. **Pre-commit hook runs** → Validates documentation
4. **Fix errors if any** → Update CLAUDE.md or STATUS.md
5. **Commit succeeds**
6. **Post-commit hook runs** → Syncs metrics

### End of Day

- STATUS.md reflects latest work
- CLAUDE.md captures decisions/learnings
- Git history has progress metrics
- Next session will load exact state

---

## Cross-Session Continuity

### How Context Persists

**What Gets Saved**:
- Current stage in STATUS.md
- Recent activity log
- Architectural decisions
- Implementation iterations
- Problems solved and patterns discovered
- Test results and blockers

**How It Loads**:
1. Next session: `session-start-context.sh` runs
2. Loads most recent feature
3. Shows CLAUDE.md stats
4. Suggests next action based on stage
5. Developer continues exactly where they left off

**Example Flow**:
```
Day 1 - 5pm:
- Complete /architect
- STATUS.md: "Architecture Complete"
- CLAUDE.md: 3 decisions documented

Day 2 - 9am:
- session-start-context.sh shows:
  - Stage: Architecture Complete
  - Suggests: Run /test-first
- Developer continues with testing
```

---

## TDD Workflow Integration

### Feature Lifecycle

```
/feature-init
    ↓
[CLAUDE.md created with template]
    ↓
/architect
    ↓
[Auto-update: STATUS.md activity]
[Manual: Document ADRs in CLAUDE.md]
    ↓
/test-first
    ↓
[Auto-update: STATUS.md activity]
[Manual: Document test strategy in CLAUDE.md]
    ↓
/implement
    ↓
[Auto-update: Iteration tracking]
[Manual: Document problems/solutions in CLAUDE.md]
[git commit → Metrics synced]
    ↓
/qa-check
    ↓
[Auto-update: QA activity]
    ↓
/document
    ↓
[Complete!]
```

### Auto-Updates at Each Stage

| Stage | Auto-Updated | Manual Documentation |
|-------|-------------|---------------------|
| **Planning** | STATUS.md timestamp | FEATURE.md requirements |
| **Architecture** | STATUS.md activity | CLAUDE.md ADRs |
| **Testing** | STATUS.md activity | CLAUDE.md test strategy |
| **Implementation** | Iteration tracking, commit metrics | CLAUDE.md problems/solutions |
| **QA** | STATUS.md activity | CLAUDE.md blockers if any |
| **Documentation** | STATUS.md completion | DOCUMENTATION.md |

---

## Best Practices

### ✅ Do

- **Let automation handle timestamps and metrics**
- **Manually document decisions, problems, patterns**
- **Update STATUS.md stage when transitioning phases**
- **Include feature ID in commit messages**
- **Document failures before trying alternatives**
- **Add test counts to commit messages**

### ❌ Don't

- **Don't manually update timestamps** (auto-handled)
- **Don't skip documenting architectural decisions** (hook reminds you)
- **Don't commit without tests** (hook warns you)
- **Don't ignore validation warnings** (they indicate missing context)
- **Don't use `--no-verify` habitually** (bypasses safety checks)

---

## Troubleshooting

### Hook Not Running

```bash
# Check if executable
ls -la .claude/hooks/

# Make executable
chmod +x .claude/hooks/*.sh

# Test manually
./.claude/hooks/session-start-context.sh
```

### Validation Errors

```bash
# Run validation manually
./.claude/hooks/validate-docs.sh

# Common fixes:
# - Add missing sections to CLAUDE.md
# - Update "Last Updated" in STATUS.md
# - Document recent architectural decisions
```

### Context Not Loading

```bash
# Check if CLAUDE.md exists
ls docs/features/*/CLAUDE.md

# Check if STATUS.md has current stage
grep "Current Stage" docs/features/*/STATUS.md

# Manually load context
/load-context
```

---

## Future Enhancements

Planned improvements:
- [ ] Test coverage extraction from test output
- [ ] Performance metrics tracking (< 300ms theme toggle)
- [ ] Automatic decision extraction from code comments
- [ ] Cross-feature pattern aggregation
- [ ] AI-powered relevance scoring for context loading
- [ ] Team knowledge base compilation

---

## Summary

**Living documentation** means:
1. ✅ Context persists between sessions automatically
2. ✅ Progress syncs with git commits automatically
3. ✅ Validation prevents documentation drift
4. ✅ Manual effort focuses on valuable insights (decisions, learnings)
5. ✅ Team knowledge compounds over time

**Result**: Spend less time writing docs, more time coding. Documentation stays current without manual overhead.

For detailed hook documentation, see [`.claude/hooks/README.md`](../.claude/hooks/README.md)
