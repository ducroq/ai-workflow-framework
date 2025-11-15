# Auto-Documentation System Guide

## Overview

The AI Workflow Framework includes a complete **auto-documentation system** that automatically maintains living documentation for your project with zero manual effort. This system is based on the [AI-Augmented Solo Development Framework](../AI_AUGMENTED_SOLO_DEV_FRAMEWORK.md) and provides:

- **Automatic updates** - Docs stay fresh as you code
- **Progressive disclosure** - Load only needed context
- **Session continuity** - Resume work instantly with full context
- **Zero friction** - Never manually update docs again

## Quick Start

### Initialize Auto-Docs in Your Project

To enable auto-documentation in any project:

```bash
# Option 1: Use the bootstrap agent
# In Claude Code, say: "Bootstrap auto-docs for [your project description]"

# Option 2: Manual initialization
mkdir -p docs/{components,decisions,WORK_PACKAGES}
# Copy templates from .claude/templates/docs/
```

The bootstrap process will:
1. Ask you a few questions about your project (< 2 minutes)
2. Create the complete documentation structure
3. Set up automation hooks
4. Enable zero-friction documentation

### What Gets Created

```
docs/
├── PROJECT_OVERVIEW.md      # High-level status
├── ARCHITECTURE.md           # System structure
├── CURRENT_TASK.md           # What you're working on
├── OPEN_QUESTIONS.md         # Questions and blockers
├── ROADMAP.md                # Work planning
├── CONSTRAINTS.md            # Project boundaries
├── components/               # Component documentation
│   └── [component].md
├── decisions/                # Architecture Decision Records
│   └── YYYY-MM-DD-[title].md
└── WORK_PACKAGES/            # Rich task metadata
    └── [package].md
```

## How It Works

### Automatic Triggers

The system automatically updates documentation based on events:

| Event | What Happens | Files Updated |
|-------|-------------|---------------|
| **Edit/Write code** | Detect interface changes → Update component docs | `docs/components/` |
| **Session ends** | Review progress → Update task tracking | `docs/CURRENT_TASK.md` |
| **Agent completes work** | Detect decisions → Create ADR drafts | `docs/decisions/` |
| **Session starts** | Load context → Show where you left off | (read-only) |
| **Git commit** | Log completed work → Update progress | `docs/CURRENT_TASK.md` |

### Progressive Disclosure

Instead of loading your entire codebase, the system:
1. **Starts broad** - Read PROJECT_OVERVIEW and ARCHITECTURE
2. **Navigates down** - Find relevant component docs
3. **Loads specific** - Pull in only needed code (10-20k tokens max)
4. **Synthesizes** - Answer using multi-level understanding

This keeps Claude Code fast and context-efficient.

## Core Documents

### PROJECT_OVERVIEW.md
**Purpose**: One-screen snapshot of project status
**Auto-updated**: When milestones reached or phase changes
**Contains**:
- Vision (2-3 sentences)
- Current status and phase
- Active focus areas
- Recent decisions
- Quick links to other docs

### CURRENT_TASK.md
**Purpose**: Real-time task tracking
**Auto-updated**: Every significant progress increment
**Contains**:
- What you're working on
- Goal and success criteria
- Context (why now, blockers)
- Progress checklist (auto-updated!)
- Notes and learnings

### OPEN_QUESTIONS.md
**Purpose**: Living question log
**Auto-updated**: Questions added/resolved automatically
**Contains**:
- Critical questions (blocking progress)
- Important questions (affects design)
- Nice to know questions
- Resolved questions with answers

### Component Documentation
**Purpose**: Per-component interface and gotchas
**Auto-updated**: When code interfaces change
**Location**: `docs/components/[component-name].md`
**Contains**:
- Purpose and responsibilities
- Public interface (exports, API, signatures)
- Key dependencies
- Implementation notes and gotchas
- Recent changes (date-stamped)

### Architecture Decision Records (ADRs)
**Purpose**: Document significant decisions
**Auto-created**: When decisions detected in conversation
**Location**: `docs/decisions/YYYY-MM-DD-[title].md`
**Contains**:
- Context (why we faced this choice)
- Decision (what we chose)
- Consequences (positive/negative/neutral)
- Alternatives considered

## Agents

### auto-docs-bootstrap
**When to use**: Initializing auto-docs in a project
**What it does**:
- Asks about your project (vision, phase, constraints)
- Creates complete docs structure
- Initializes all foundation documents
- Sets up automation hooks

**Usage**:
```
"Bootstrap auto-docs for my e-commerce platform with Next.js and Node.js"
```

### auto-docs-maintainer
**When to use**: Automatically (via hooks)
**What it does**:
- Updates component docs when code changes
- Tracks progress in CURRENT_TASK
- Creates ADR drafts for decisions
- Loads context at session start
- Resolves questions in OPEN_QUESTIONS

**Usage**: This agent runs automatically - you don't invoke it directly!

## Hooks Configuration

The system uses hooks to automate documentation:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "command": "bash .claude/hooks/update-component-docs.sh",
        "description": "Update component docs when code changes"
      }
    ],
    "Stop": [
      {
        "matcher": "*",
        "command": "bash .claude/hooks/update-current-task.sh",
        "description": "Update CURRENT_TASK with progress"
      }
    ],
    "SubagentStop": [
      {
        "matcher": "*",
        "command": "bash .claude/hooks/create-adr-draft.sh",
        "description": "Create ADR draft when decisions detected"
      }
    ],
    "SessionStart": [
      {
        "matcher": "*",
        "command": "bash .claude/hooks/session-start-context.sh",
        "description": "Load context at session start"
      }
    ]
  }
}
```

## Customization

### Adjusting Automation Level

You can customize which hooks are active:

**Full Auto** (Recommended):
- All hooks enabled
- Docs update automatically
- Zero manual work

**Suggestions Only**:
- Disable update hooks
- Keep suggestion hooks
- Review before updating

**Hybrid**:
- Enable some hooks (e.g., component docs)
- Disable others (e.g., ADR creation)
- Balance automation and control

### Custom Templates

Modify templates in `.claude/templates/docs/` to match your preferences:
- Different ADR format (use RFCs instead)
- Additional doc types
- Custom sections in PROJECT_OVERVIEW
- Domain-specific component templates

## Best Practices

### DO
✅ Let the system update docs automatically
✅ Review ADR drafts and approve/refine them
✅ Keep docs lean (1-2 screens for overviews)
✅ Use CURRENT_TASK as your single source of truth
✅ Trust the context loading at session start

### DON'T
❌ Manually edit auto-maintained sections
❌ Over-document (create docs only when valuable)
❌ Ignore critical questions in OPEN_QUESTIONS
❌ Skip reviewing ADR drafts (they guide the project)
❌ Create files "just because" (pragmatic over dogmatic)

## Troubleshooting

### Docs aren't updating automatically
**Check**:
1. Is `.claude/settings.json` configured with hooks?
2. Are hook scripts executable? (`chmod +x .claude/hooks/*.sh`)
3. Do hooks have permission to read/write docs? (Check `permissions.allow`)

### Too many updates / noise
**Solution**: Reduce hook sensitivity
- Disable `PostToolUse` hook for less frequent component doc updates
- Keep `Stop` hook for task tracking only
- Adjust what counts as "significant" in hook scripts

### Docs feel stale / out of sync
**Solution**: Re-bootstrap or manual sync
- Run auto-docs-bootstrap again to reset structure
- Manually update PROJECT_OVERVIEW if major changes occurred
- Check if hooks are actually running (add debug logging)

### Context at session start is wrong
**Solution**: Update CURRENT_TASK manually
- Edit `docs/CURRENT_TASK.md` to reflect actual work
- System will sync from there going forward

## Examples

### Example 1: New Web App Project

```
User: "Bootstrap auto-docs for a real-time chat application with React and WebSockets"

System creates:
- PROJECT_OVERVIEW: "Building real-time chat with React frontend and WebSocket backend"
- ARCHITECTURE: Client (React) ↔ WebSocket Server ↔ Message Queue ↔ Database
- CURRENT_TASK: "Setting up project structure"
- CONSTRAINTS: "Must support 1000 concurrent users"
- OPEN_QUESTIONS: "Which message queue? (Redis vs RabbitMQ)"
```

### Example 2: ML Pipeline Project

```
User: "Initialize auto-docs for data pipeline: ingestion → training → deployment"

System creates:
- PROJECT_OVERVIEW: "ML pipeline for automated model training"
- ARCHITECTURE: Data Ingestion → Preprocessing → Training → Model Registry → Deployment
- CURRENT_TASK: "Building data ingestion module"
- ROADMAP: Now: Ingestion, Next: Preprocessing, Later: Training
```

### Example 3: Session Continuity

```
# End of Monday session:
CURRENT_TASK progress: [x] Design auth flow, [x] Implement JWT, [ ] Frontend integration

# Tuesday session start:
System loads:
"📖 Context Summary

Current Task: Implementing user authentication
Progress: API complete ✓, Frontend in progress (60%)

Open Questions:
- ❗ Should we support OAuth providers? (Critical)

Recent Decisions:
- 2025-11-15: Using JWT for session management

Suggestion: Continue with frontend authentication UI, then tackle OAuth question."
```

## Integration with Existing Docs

If your project already has documentation:

1. **Migrate valuable content** - Move existing docs into new structure
2. **Preserve history** - Keep old docs in `docs/archive/`
3. **Link strategically** - Reference technical docs from component docs
4. **Let auto-docs complement** - Use for high-level overview, keep technical details separate

## Performance Considerations

- **Doc updates**: < 1 second (doesn't block your workflow)
- **Context loading**: < 30 seconds at session start (goal)
- **Storage**: Minimal (markdown files, ~100KB total)
- **Claude tokens**: Progressive disclosure keeps usage low (10-20k tokens for context)

## Advanced Features

### Work Packages

For complex features, create rich task metadata:

```markdown
# User Authentication Work Package

**Priority:** P0 (Critical)
**Effort:** Medium (3-5 days)
**Risk:** Medium (OAuth integration unknown)
**Fun/Energy:** 😊 Enjoy
**Learning Potential:** High (new OAuth patterns)
```

This helps Claude suggest what to work on based on your energy, time, and context.

### Decision Records Evolution

ADRs can be updated when decisions change:

```markdown
**Status:** Superseded by decision-2025-11-20-graphql-api.md
```

This creates a decision timeline and prevents lost context.

### Sandbox Integration

The foundation document recommends git-ignored `sandbox/` directories for experimentation. Auto-docs integrates:

- Failed experiments → Document in sandbox with learnings
- Successful prototypes → Migrate to main codebase + create ADR
- Learnings flow upward → Reference sandbox failures in ADRs

## Getting Help

- **Foundation Document**: [AI_AUGMENTED_SOLO_DEV_FRAMEWORK.md](../AI_AUGMENTED_SOLO_DEV_FRAMEWORK.md)
- **Hooks Guide**: [HOOKS_GUIDE.md](HOOKS_GUIDE.md)
- **Examples**: [EXAMPLES.md](../EXAMPLES.md)
- **FAQ**: [FAQ.md](../FAQ.md)

---

**Remember**: The goal is **zero manual work**. If you find yourself updating docs manually, something's not configured correctly. The system should feel magical, not burdensome!
