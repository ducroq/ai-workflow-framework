# Conductor - Project Context

## What This Repo Is

Conductor is the **source repository** for AI-augmented workflow components. It's NOT a tool you run - it's a collection of agents, skills, commands, and templates.

## How It's Used

The agents and skills from this repo are copied to **user-level** (`~/.claude/`) so they're available in ALL projects:

```
~/.claude/
├── agents/           <- Copied from Conductor
│   ├── software-engineering/code-reviewer.md, debugger.md, etc.
│   ├── security/security-auditor.md
│   ├── data-science/data-analyzer.md
│   └── meta/agent-creator.md, skill-creator.md, etc.
├── skills/           <- Copied from Conductor
└── templates/        <- Copied from Conductor
```

When Claude is asked to "review code" or "debug this" in ANY project, it reads the relevant agent from `~/.claude/agents/`.

## What Stays Project-Level

**Hooks stay in Conductor only** (not user-level) because:
- Hooks run automatically and need specific files to exist
- They would error in projects that don't have the expected structure
- Example: `session-start-context.sh` needs `docs/CURRENT_TASK.md`

## Workflow

1. **Improve agents/skills** in this Conductor repo
2. **Copy to `~/.claude/`** to make available everywhere
3. **Use in any project** - Claude automatically reads them

## Key Files

- `.claude/agents/` - Agent definitions (code-reviewer, debugger, security-auditor, etc.)
- `.claude/skills/` - Auto-invoked skills (refactoring patterns)
- `.claude/commands/` - Slash commands (/architect, /test-first, /implement, etc.)
- `.claude/hooks/` - Automation hooks (project-specific, not user-level)
- `docs/` - Documentation and guides

## Not For

- Simple scripts or one-off tasks
- Projects that don't need formal workflows
- Example: FluxusSource doesn't need Conductor's hooks - it has its own CLAUDE.md and is already well-structured
