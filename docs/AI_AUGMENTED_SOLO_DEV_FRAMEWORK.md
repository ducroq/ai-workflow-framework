
# AI-Augmented Solo Development Operating System
## Bootstrap Guide for Claude Code

**Purpose:** This document instructs Claude Code on how to implement and maintain a "living project memory system" that overcomes AI context window limitations through Progressive Disclosure and automated documentation.

**Core Principle:** This framework should require ZERO extra work from the human developer. Claude Code automates the friction of context management.

---

## Your Role as Claude Code

You are the **Documentation Scribe**, **Context Navigator**, and **Project Manager** for this project.

### Automated Responsibilities

| Trigger | Your Actions | Files to Update |
|---------|-------------|-----------------|
| **Code commit/change** | Analyze diffs, identify interface changes, update component docs | `/docs/components/*`, `/docs/REFACTORING_LOG.md` |
| **Task completion** | Generate status snapshot, update roadmap | `/docs/PROJECT_OVERVIEW.md`, `/docs/ROADMAP.md` |
| **Significant decision in conversation** | Draft ADR with Context/Decision/Consequences | `/docs/decisions/YYYY-MM-DD-title.md` |
| **"What should I work on?"** | Analyze work packages, suggest based on priority/energy/context | `/docs/WORK_PACKAGES/*` |
| **"Help me with X"** | Use RAG to find relevant docs, load only needed context (10-20k tokens) | Search all relevant files |
| **Session start** | Read CURRENT_TASK, OPEN_QUESTIONS, recent decisions | Provide focused context |

---

## Phase 1: Initial Setup

When the developer says "bootstrap the framework" or "initialize the structure", create these files:

### 1. `/docs/PROJECT_OVERVIEW.md`

```markdown
# Project Overview

## Vision
[2-3 sentences: What are we building and why?]

## Current Status
**Phase:** [Discovery/Development/Refinement/Production]
**Last Updated:** [Date]

[2-3 sentences on where things stand right now]

## Active Focus Areas
- [ ] [Current main focus]
- [ ] [Secondary focus]

## Recent Significant Decisions
- [Date]: [Brief decision summary] → See `/docs/decisions/YYYY-MM-DD-title.md`

## Quick Links
- Architecture: [ARCHITECTURE.md](ARCHITECTURE.md)
- Current Task: [CURRENT_TASK.md](CURRENT_TASK.md)
- Open Questions: [OPEN_QUESTIONS.md](OPEN_QUESTIONS.md)
- Roadmap: [ROADMAP.md](ROADMAP.md)
```

### 2. `/docs/ARCHITECTURE.md`

```markdown
# Architecture

## System Diagram
[ASCII diagram or description of major components and their relationships]

## Core Components

### [Component Name]
- **Purpose:** 
- **Responsibilities:**
- **Key Dependencies:**
- **Interface/API:**

[Repeat for each major component]

## Data Flow
[How data moves through the system]

## Key Principles & Constraints
- [Principle 1]
- [Principle 2]

## Layer Separation
[If applicable: frontend/backend, domain/infrastructure, etc.]
```

### 3. `/docs/CURRENT_TASK.md`

```markdown
# Current Task

**What I'm working on:** [Clear, specific description]

**Goal:** [What success looks like]

**Context:**
- Why now: [Why this task is the priority]
- Blockers: [Any impediments]
- Related: [Links to relevant component docs or decisions]

**Progress:**
- [x] [Completed step]
- [ ] [Next step]
- [ ] [Future step]

**Notes/Learnings:**
[Real-time capture of insights as you work]
```

### 4. `/docs/OPEN_QUESTIONS.md`

```markdown
# Open Questions

## Critical (Blocking Progress)
- [ ] **[Question]** - [Why it matters] - [What we need to learn]

## Important (Affects Design)
- [ ] **[Question]** - [Context]

## Nice to Know (Can Work Around)
- [ ] **[Question]** - [Context]

## Resolved
- [x] **[Question]** - [Resolution date] - [Answer/Decision]
```

### 5. `/docs/CONSTRAINTS.md`

```markdown
# Constraints

## Non-Negotiable
- [Hard constraint with reason]

## Technical Limitations
- Platform: [e.g., "Browser-only, no native code"]
- Performance: [e.g., "Must handle 10k items"]
- Compatibility: [e.g., "Support last 2 browser versions"]

## Resource Constraints
- Time: [Timeline constraints]
- Budget: [Cost limitations]
- Team: [Solo developer]

## Self-Imposed Principles
- [Design principles we're following]
```



## Phase 1.5: Experimental Sandbox Setup

**Purpose:** Create a safe space for AI-assisted experimentation without polluting the repository.

**Problem:** When working with AI assistants on exploratory work, prototypes, debugging, and failed experiments, you need freedom to try ideas without worrying about git status or accidental commits. Traditional approach leads to:
- Mental friction deciding "should I commit this?"
- Messy git history with experimental commits
- Prototype code accidentally making it to production
- Valuable learnings from failed approaches getting lost

**Solution:** Establish gitignored sandbox directories as first-class citizens of your dev workflow.

### Setup: Add to `.gitignore`

```gitignore
# Sandbox/Experimental - NOT committed (safe space for prototyping)
sandbox/              # General experimentation, prototypes
scratch/              # Quick tests, temporary work
playground/           # Testing new libraries/tools
experiments/local/    # Local experiments (keep experiments/ root tracked for systematic work)
notebooks/exploratory/  # Messy exploratory Jupyter notebooks

# Experimental file patterns
*.bak
*.old
*_backup.*
*_test.*
*_draft.*
```

### Create `/sandbox/README.md`

```markdown
# Sandbox Directory

**Purpose:** Safe space for experimentation without polluting the repository.
**Status:** This entire directory is `.gitignore`'d - nothing here will be committed.

## What Goes Here

### ✅ Safe to Add
- Prototypes - Test ideas before implementing properly
- One-off analyses - Quick data exploration scripts
- Debugging code - Isolated test files for troubleshooting
- Failed experiments - Document what didn't work (valuable!)
- Messy notebooks - Jupyter notebooks during exploration
- Draft implementations - Work in progress before moving to proper location

### ❌ Don't Put Here (Use Proper Locations)
- Production code → `/src` or appropriate directory
- Documented experiments → `/experiments` (tracked, not `/experiments/local`)
- Important analysis results → `/docs/` or `/reports/`
- Working implementations → Proper component directories

## Organization Patterns

### By Date (Recommended for Quick Tests)
```
sandbox/2025-11-10_model_testing/
sandbox/2025-11-11_api_experiments/
```

### By Topic (For Ongoing Explorations)
```
sandbox/hyperparameter_search/
sandbox/architecture_prototypes/
sandbox/debugging_memory_leak/
```

### By Status (For Systematic Work)
```
sandbox/active/       # Currently working on
sandbox/promising/    # Might return to
sandbox/failed/       # Documented failures
```

## Failed Experiment Template

When documenting a failed approach:

```markdown
# Failed Approach: [Name]

## Date
YYYY-MM-DD

## What I Tried
[Clear description of the approach]

## Why It Failed
[Specific problems encountered]

## What I Learned
[Key insights that will inform future work]

## Better Approach
[What to do instead, or link to ADR if you made a decision]
```

## Cleanup Guidelines
- Keep for learning value, but clean up occasionally
- Move working prototypes to proper locations
- Preserve failure documentation (it's valuable!)
- Delete truly temporary debugging files

**Remember:** This is YOUR workspace. Experiment freely!
```

### AI Assistant Responsibilities

When developer works in sandbox:

1. **Encourage its use:** Suggest sandbox for risky experiments, debugging, or exploratory work
2. **No repo pollution:** Never suggest moving sandbox content to main codebase unless it's proven and cleaned up
3. **Capture learnings:** When something useful emerges, help extract insights to proper documentation
4. **Document failures:** Encourage documenting what didn't work (prevents repeat attempts)

### AI Assistant Commands to Recognize

| Developer Says | You Do |
|----------------|--------|
| "Let's try something in sandbox" | Work freely, don't worry about git cleanliness |
| "This experiment failed" | Help document in `sandbox/failed/` with learnings |
| "This prototype works" | Help clean it up and move to proper location |
| "Clean up sandbox" | Review contents, archive old experiments |

### Integration with Main Framework

- **Sandbox is pre-documentation:** Ideas prove themselves here before becoming ADRs or component docs
- **Failed experiments inform decisions:** Reference sandbox failures in `/docs/decisions/` ADRs
- **Prototypes become components:** Successful sandbox code graduates to `/docs/components/` 
- **Learnings flow upward:** Insights from sandbox inform `/docs/LESSONS.md` or `/docs/PATTERNS.md`

### Example Workflow

```
1. Have risky idea → Work in sandbox/2025-11-10_new_approach/
2. Experiment succeeds → Clean up, create ADR, move to proper location
3. Document decision → /docs/decisions/2025-11-10-chose-new-approach.md
                       Reference sandbox/failed/old_approach.md for context
```

### Benefits for AI-Augmented Development

- **Mental freedom:** No git anxiety during exploration
- **Faster iteration:** Skip committing ceremony for throwaway code
- **Better documentation:** Failed approaches documented, not lost
- **Cleaner history:** Main repo contains only polished work
- **Learning capture:** Experiments become institutional knowledge

---

---

## Phase 2: Component Documentation

Create `/docs/components/` directory. For each major module/component, create a file:

### `/docs/components/[component-name].md`

```markdown
# [Component Name]

## Purpose
[Why this component exists]

## Public Interface
[Exported functions, classes, or API endpoints]

## Key Dependencies
- [Dependency 1]: [Why needed]
- [Dependency 2]: [Why needed]

## Implementation Notes

### Current Approach
[How it works now]

### Gotchas
- [Tricky behavior to be aware of]

### TODOs
- [ ] [Future improvement]

## Recent Changes
- **[Date]:** [Change description]
```

**Update these automatically when:**
- Interface changes (function signatures, exports)
- New dependencies added
- Major refactoring

---

## Phase 3: Decision Records

Create `/docs/decisions/` directory. When a significant decision is made in conversation:

### `/docs/decisions/YYYY-MM-DD-title-in-kebab-case.md`

```markdown
# [Decision Title]

**Date:** YYYY-MM-DD
**Status:** Accepted | Superseded | Deprecated

## Context
[What was the situation? What problem were we solving?]

## Decision
[What did we decide to do?]

## Consequences

### Positive
- [Good outcome]

### Negative
- [Trade-off or limitation]

### Neutral
- [Other effects]

## Alternatives Considered
- **[Alternative 1]:** [Why rejected]
- **[Alternative 2]:** [Why rejected]
```

**Create these when:**
- Choosing between architectural approaches
- Selecting libraries/frameworks
- Making trade-offs with long-term impact
- Establishing patterns or conventions

---

## Phase 4: Work Management

### `/docs/ROADMAP.md`

```markdown
# Roadmap

## Now (This Week/Sprint)
- [High-priority item] (Risk: H/M/L, Effort: S/M/L)

## Next (Coming Soon)
- [Queued item]

## Later (Backlog)
- [Future consideration]

## Completed
- [x] [Done item] - [Completion date]
```

### `/docs/WORK_PACKAGES/[package-name].md`

For complex features, create detailed work packages with rich metadata:

```markdown
# [Feature/Work Package Name]

## Description
[What needs to be built]

## Metrics
- **Priority:** P0 (Critical) | P1 (High) | P2 (Medium) | P3 (Low)
- **Risk:** High | Medium | Low
- **Effort:** Small (hours) | Medium (days) | Large (weeks)
- **Value/Impact:** High | Medium | Low
- **Fun/Energy:** 😍 Love it | 😊 Enjoy | 😐 Neutral | 😓 Draining
- **Context Switch Cost:** High | Medium | Low
- **Learning Potential:** High | Medium | Low
- **Reversibility:** Easy | Hard | Impossible

## Dependencies
- Blocks: [What this unblocks]
- Blocked by: [What must happen first]

## Acceptance Criteria
- [ ] [Specific, testable criterion]

## Notes
[Any additional context]
```

---

## Phase 5: Specialized Documents (As Needed)

Create these when complexity demands:

### `/docs/GLOSSARY.md`
Domain-specific terms and abbreviations

### `/docs/TESTING_STRATEGY.md`
How we test, what we test, test patterns

### `/docs/CONVENTIONS.md`
Code style, naming patterns, file organization

### `/docs/PATTERNS.md`
Reusable design patterns we're using

### `/docs/RISKY_AREAS.md`
Fragile code, high-churn areas, technical debt

### `/docs/OUT_OF_SCOPE.md`
What we explicitly won't do (and why)

### `/docs/LESSONS.md`
Things learned the hard way

---

## Simulator-Driven Development (Optional)

For projects involving modeling/simulation:

### `/docs/PROBLEM_DOMAIN.md`
Current understanding of reality, key variables, assumptions

### `/docs/SIMULATIONS/iteration-XX-[name]/`
Each iteration documents:
- Hypothesis
- Model
- Results  
- Learnings (gap between hypothesis and reality)

### `/docs/REALITY_CHECKS.md`
Real-world data points and fit metrics

### `/docs/MODEL_EVOLUTION.md`
Timeline of how mental model changed

---

## Daily Workflow Integration

### When the developer starts a session:
1. **Read:** `/docs/CURRENT_TASK.md`, `/docs/OPEN_QUESTIONS.md`, relevant component docs
2. **Summarize:** "Here's where we left off..."
3. **Suggest:** "Based on ROADMAP and current context, consider..."

### During development:
1. **Track changes** in real-time (mental note of what's changing)
2. **Ask clarifying questions** that should become OPEN_QUESTIONS
3. **Note decisions** that should become ADRs

### When developer commits/finishes:
1. **Update** relevant component documentation
2. **Update** PROJECT_OVERVIEW if significant progress
3. **Suggest** if decision should be recorded
4. **Update** CURRENT_TASK progress

### When developer asks "What should I work on?":
1. **Analyze** ROADMAP and WORK_PACKAGES
2. **Consider** time available, energy level, context
3. **Suggest** 2-3 options with reasoning

---

## Progressive Context Loading

When helping with a query:

1. **Start broad:** Read `/docs/PROJECT_OVERVIEW.md`, `/docs/ARCHITECTURE.md`
2. **Navigate down:** Find relevant component docs in `/docs/components/`
3. **Load specific:** Pull in only the needed code/context (aim for 10-20k tokens max)
4. **Synthesize:** Answer using multi-level understanding

**Never** dump entire files unless specifically asked.

---

## Maintenance Rules

### Keep files lean:
- PROJECT_OVERVIEW: 1-2 screens max
- Component docs: Focus on interface + gotchas, not full code
- ADRs: Concise, one clear decision per file

### Archive when needed:
- Old decisions → `/docs/decisions/archive/`
- Completed work packages → `/docs/WORK_PACKAGES/done/`
- Dated roadmap snapshots → `/docs/ROADMAP_ARCHIVE/`

### Weekly health check (if asked):
- Any stale OPEN_QUESTIONS?
- CURRENT_TASK accurate?
- Component docs still relevant?

---

## Commands to Implement

Recognize and respond to these patterns:

| Developer Says | You Do |
|----------------|--------|
| "Bootstrap the framework" | Create Phase 1 files in `/docs/` with project-specific content |
| "Document this component" | Create/update `/docs/components/[name].md` |
| "Record this decision" | Create ADR in `/docs/decisions/` |
| "What should I work on?" | Analyze work packages, suggest tasks |
| "Update docs" | Review recent changes, update relevant files |
| "What's the status?" | Summarize from PROJECT_OVERVIEW, CURRENT_TASK |
| "Find info about X" | RAG search across all docs |
| "Create work package for X" | Generate rich work package file |

---

## Success Metrics

You're doing this right when:
- ✅ Developer never manually updates docs (you do it)
- ✅ Context is always fresh (auto-updates)
- ✅ Navigation is quick (good file organization)
- ✅ No cognitive overhead (system feels invisible)
- ✅ Can resume after weeks away (excellent context)

---

## Anti-Patterns to Avoid

- ❌ Over-documenting (keep it lean)
- ❌ Requiring manual updates (automate everything)
- ❌ Creating files "just because" (pragmatic over dogmatic)
- ❌ Dumping entire codebase for every question (progressive disclosure)
- ❌ Forgetting to update docs after changes (maintain consistency)

---

## Getting Started

**Minimal viable start:**
1. Create `/docs/` directory with PROJECT_OVERVIEW, ARCHITECTURE, CURRENT_TASK
2. Start coding
3. Build out `/docs/components/`, `/docs/decisions/` as you go
4. Add work management when complexity demands

**Developer: Say "Initialize the framework for [brief project description]" to begin.**
