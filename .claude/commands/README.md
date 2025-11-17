# Conductor Slash Commands

**Purpose**: Persona-based slash commands for structured feature development

---

## Available Commands

### Feature Workflow Commands

These commands implement a structured, TDD-based feature development workflow:

| Command | Persona | Purpose | Stage |
|---------|---------|---------|-------|
| `/feature-init` | Product Manager | Initialize feature with requirements | 1️⃣ Planning |
| `/architect` | System Architect | Design technical architecture | 2️⃣ Architecture |
| `/test-first` | Test Engineer | Write tests before implementation | 3️⃣ Testing |
| `/implement` | Implementation Engineer | Write minimal code to pass tests | 4️⃣ Implementation |
| `/qa-check` | QA Engineer | Comprehensive quality review | 5️⃣ QA |
| `/document` | Documentation Writer | Create comprehensive docs | 6️⃣ Documentation |

---

## Quick Start

### Complete Workflow Example

```bash
# 1. Initialize a new feature
/feature-init
# → Creates docs/features/F001-[name]/ with templates

# 2. Design the architecture
/architect
# → Populates ARCHITECTURE.md and TASKS.md

# 3. Write tests (TDD)
/test-first
# → Creates test files that initially fail

# 4. Implement to make tests pass
/implement
# → Writes minimal code, all tests now pass

# 5. Quality assurance review
/qa-check
# → Creates QA_REPORT.md with PASS/REVIEW/FAIL decision

# 6. Create documentation
/document
# → Creates DOCUMENTATION.md and updates project docs

# ✅ Feature complete!
```

---

## Command Details

### `/feature-init`

**When to use**: Starting a new feature

**What it does**:
- Asks about feature requirements
- Creates feature directory: `docs/features/F[XXX]-[name]/`
- Populates `FEATURE.md` with requirements
- Creates placeholder `ARCHITECTURE.md`, `TASKS.md`, `STATUS.md`

**Constraints**:
- Gathers requirements only
- Does NOT design architecture
- Does NOT create tasks yet

**Next step**: `/architect`

---

### `/architect`

**When to use**: After feature requirements are defined

**What it does**:
- Reviews `FEATURE.md`
- Examines existing codebase
- Designs technical solution
- Documents in `ARCHITECTURE.md`
- Creates task breakdown in `TASKS.md`

**Constraints**:
- Designs only, does NOT implement
- Does NOT write tests

**Next step**: `/test-first`

---

### `/test-first`

**When to use**: After architecture is designed

**What it does**:
- Reviews `ARCHITECTURE.md`
- Creates comprehensive test suite
- Tests cover all acceptance criteria
- Tests initially FAIL (nothing implemented)

**Constraints**:
- Writes tests ONLY
- Does NOT write implementation code
- Does NOT modify existing non-test files

**Next step**: `/implement`

---

### `/implement`

**When to use**: After tests are written

**What it does**:
- Runs existing tests
- Implements minimal code to pass tests
- Follows Red → Green → Refactor
- All tests now PASS

**Constraints**:
- Does NOT modify tests
- Writes minimal implementation (YAGNI)
- Must make ALL tests pass

**Next step**: `/qa-check`

---

### `/qa-check`

**When to use**: After implementation is complete

**What it does**:
- Runs automated quality checks
- Reviews code quality
- Security audit (OWASP Top 10)
- Performance analysis
- Creates `QA_REPORT.md`
- Provides PASS/REVIEW/FAIL decision

**Constraints**:
- Reviews only, does NOT fix issues
- Creates report, does NOT modify code

**Decisions**:
- **PASS**: Proceed to `/document`
- **REVIEW**: Fix issues, then `/document`
- **FAIL**: Must fix critical issues, re-run `/qa-check`

**Next step**: `/document` (after any issues fixed)

---

### `/document`

**When to use**: After QA approval

**What it does**:
- Creates user documentation
- Creates developer documentation
- Creates operational documentation
- Updates project-level docs
- Creates `DOCUMENTATION.md`

**Constraints**:
- Documents only
- Does NOT modify implementation

**Next step**: Feature complete! 🎉

---

## Best Practices

### 1. Use `/clear` Between Commands
Save context/tokens by clearing between stages:
```
/feature-init → /clear → /architect → /clear → /test-first → ...
```

### 2. Follow the Sequence
Don't skip stages. Each catches different issues.

### 3. Respect Constraints
Each persona has specific boundaries. If it's doing something it shouldn't, remind it of its constraints.

### 4. Start Small
First feature? Pick something small (1-2 day effort) to learn the workflow.

---

## Directory Structure Created

After using these commands, each feature has:

```
docs/features/F[XXX]-[feature-name]/
├── FEATURE.md           # Requirements (from /feature-init)
├── ARCHITECTURE.md      # Design (from /architect)
├── TASKS.md            # Task breakdown (from /architect)
├── STATUS.md           # Progress (updated by all commands)
├── QA_REPORT.md        # Quality review (from /qa-check)
└── DOCUMENTATION.md    # User/dev docs (from /document)
```

---

## Templates Used

These commands use templates from:
- `.claude/templates/feature/` - Feature file templates
- `.claude/templates/docs/` - Project doc templates

---

## See Also

- [FEATURE_WORKFLOW_GUIDE.md](../../docs/FEATURE_WORKFLOW_GUIDE.md) - Complete workflow guide
- [GETTING_STARTED.md](../../GETTING_STARTED.md) - General Conductor setup
- [HOOKS_GUIDE.md](../../docs/HOOKS_GUIDE.md) - Automation hooks

---

**Version**: 1.0.0
**Last Updated**: 2025-11-17
