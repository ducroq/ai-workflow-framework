# Feature Workflow Guide

**Purpose**: Step-by-step guide for building features using the Conductor feature workflow system

**Version**: 1.0.0
**Date**: 2025-11-17

---

## Overview

The Conductor feature workflow system provides a structured, persona-based approach to building features using Test-Driven Development (TDD) principles. Each stage has a specialized "persona" (slash command) that focuses on one aspect of the feature lifecycle.

### Workflow Stages

```
/feature-init → /architect → /test-first → /implement → /qa-check → /document
    (PM)         (Architect)   (Test Eng)    (Impl Eng)    (QA)      (Doc Writer)
```

### Key Benefits

- ✅ **Structured Process** - Clear stages with defined responsibilities
- ✅ **Test-Driven** - Tests written before implementation
- ✅ **Quality Focused** - Built-in QA review before completion
- ✅ **Well Documented** - Each feature tracked from start to finish
- ✅ **Plan Mode** - Review before execution at each stage
- ✅ **Context Efficient** - Use `/clear` between stages to save tokens

---

## Complete Workflow Example

### Stage 1: Initialize Feature (`/feature-init`)

**Persona**: Product Manager

**Purpose**: Gather requirements and create feature directory structure

**Command**:
```
/feature-init
```

**What Happens**:
1. You'll be asked about the feature (name, purpose, requirements)
2. Feature directory created: `docs/features/F[XXX]-[name]/`
3. Four files created:
   - `FEATURE.md` - Requirements and acceptance criteria
   - `ARCHITECTURE.md` - Placeholder for design
   - `TASKS.md` - Placeholder for task breakdown
   - `STATUS.md` - Current status tracking

**Output Example**:
```
✅ Feature F001 initialized: User Authentication

📁 Created:
- docs/features/F001-user-auth/FEATURE.md
- docs/features/F001-user-auth/ARCHITECTURE.md
- docs/features/F001-user-auth/TASKS.md
- docs/features/F001-user-auth/STATUS.md

🎯 Current Stage: Planning (10% complete)

📋 Next Step: Run /architect to design the technical architecture
```

**Pro Tip**: Be thorough with requirements. Detailed acceptance criteria now saves rework later.

**When to `/clear`**: After feature initialization is complete and documented.

---

### Stage 2: Design Architecture (`/architect`)

**Persona**: System Architect

**Purpose**: Design technical solution and break down into tasks

**Command**:
```
/architect
```

**What Happens**:
1. Reviews FEATURE.md requirements
2. Examines existing codebase for patterns
3. Designs architecture (components, data models, APIs)
4. Documents design decisions in ARCHITECTURE.md
5. Breaks feature into atomic tasks in TASKS.md
6. Updates STATUS.md

**Key Deliverables**:
- Complete ARCHITECTURE.md with:
  - Design decisions and rationale
  - Component structure
  - API contracts
  - Database schema
  - Security considerations
  - Performance considerations
- Complete TASKS.md with atomic task breakdown
- ADR (Architecture Decision Record) if significant decision made

**Output Example**:
```
✅ Architecture designed for F001: User Authentication

📐 Design Decisions Made:
1. Use JWT for session management - Stateless, scalable
2. Password hashing with bcrypt - Industry standard, secure
3. Rate limiting with Redis - Prevent brute force attacks

🏗️ Components Designed:
- AuthService: Handle registration, login, logout
- TokenService: JWT generation and validation
- UserRepository: Database operations

📋 Tasks Created: 12 tasks across 4 phases

🎯 Next Step: Run /test-first to create tests
```

**Pro Tip**: Don't skip the "examine existing codebase" step. Reusing patterns ensures consistency.

**When to `/clear`**: After architecture is documented and reviewed.

---

### Stage 3: Write Tests (`/test-first`)

**Persona**: Test Engineer

**Purpose**: Create comprehensive tests BEFORE implementation

**Command**:
```
/test-first
```

**What Happens**:
1. Reads FEATURE.md and ARCHITECTURE.md
2. Examines existing test patterns in codebase
3. Creates test files for:
   - Unit tests (individual functions/components)
   - Integration tests (component interactions)
   - E2E tests (complete workflows)
4. Tests cover all acceptance criteria
5. Updates STATUS.md

**Key Deliverables**:
- Comprehensive test suite that:
  - Covers all acceptance criteria
  - Tests all components from ARCHITECTURE.md
  - Includes edge cases and error handling
  - Follows project test conventions
- All tests initially FAIL (nothing implemented yet)

**Output Example**:
```
✅ Tests created for F001: User Authentication

📝 Test Coverage Planned:
- Unit Tests: 15 tests across 3 files
- Integration Tests: 8 tests across 2 files
- E2E Tests: 3 tests across 1 file

📁 Files Created:
- src/services/__tests__/AuthService.test.js
- src/services/__tests__/TokenService.test.js
- src/repositories/__tests__/UserRepository.test.js
- src/__tests__/integration/auth.integration.test.js
- src/__tests__/e2e/auth-flow.e2e.test.js

✅ Acceptance Criteria Covered:
- [x] User registration - AuthService.test.js
- [x] User login - AuthService.test.js
- [x] Password validation - AuthService.test.js
- [x] Rate limiting - auth.integration.test.js
- [x] Session management - TokenService.test.js

⚠️ Current Test Status:
- Tests Written: 26
- Tests Passing: 0 (expected - no implementation)
- Tests Failing: 26 (expected - ready for implementation)

🎯 Next Step: Run /implement to make tests pass
```

**Critical**: DO NOT implement any code. Only write tests.

**Pro Tip**: Run tests to verify they fail correctly. This ensures tests are working.

**When to `/clear`**: After all tests are written and verified to fail correctly.

---

### Stage 4: Implement Code (`/implement`)

**Persona**: Implementation Engineer

**Purpose**: Write minimal code to make tests pass

**Command**:
```
/implement
```

**What Happens**:
1. Reads ARCHITECTURE.md for design
2. Runs existing tests to see failures
3. Implements code to make tests pass
4. Follows Red → Green → Refactor cycle
5. Updates STATUS.md

**Key Deliverables**:
- Implementation code that:
  - Makes ALL tests pass
  - Follows ARCHITECTURE.md design
  - Adheres to project conventions
  - Is clean and maintainable
- All tests now PASS

**Output Example**:
```
✅ Implementation complete for F001: User Authentication

🎯 Test Results:
- Tests Passing: 26 / 26 (100%)
- Tests Failing: 0
- Test Coverage: 87%

📁 Files Created/Modified:
- ✨ Created: src/services/AuthService.js
- ✨ Created: src/services/TokenService.js
- ✨ Created: src/repositories/UserRepository.js
- ✏️ Modified: src/routes/auth.js
- ✏️ Modified: src/middleware/rateLimit.js

✅ Acceptance Criteria Met:
- [x] User registration - AuthService.js
- [x] User login - AuthService.js
- [x] Password validation - AuthService.js
- [x] Rate limiting - rateLimit.js
- [x] Session management - TokenService.js

🔧 Refactoring Done:
- Extracted password validation to separate method
- Created reusable token generation utility
- Simplified error handling with custom error classes

🎯 Next Step: Run /qa-check for quality assurance
```

**Critical Constraints**:
- DO NOT modify tests
- Write minimal code (YAGNI principle)
- Follow existing patterns

**Pro Tip**: Implement incrementally. Make one test pass, then refactor, then next test.

**When to `/clear`**: After all tests pass and code is refactored.

---

### Stage 5: Quality Assurance (`/qa-check`)

**Persona**: QA Engineer

**Purpose**: Comprehensive quality review before deployment

**Command**:
```
/qa-check
```

**What Happens**:
1. Runs automated quality checks (linting, coverage, security)
2. Reviews code for quality and patterns
3. Checks security (OWASP Top 10)
4. Analyzes performance
5. Creates comprehensive QA report
6. Provides PASS/REVIEW/FAIL decision
7. Updates STATUS.md

**Key Deliverables**:
- `QA_REPORT.md` with:
  - Test coverage metrics
  - Code quality assessment
  - Security audit results
  - Performance analysis
  - Issues categorized by severity
  - Clear PASS/REVIEW/FAIL decision

**Output Example**:
```
✅ QA complete for F001: User Authentication

📊 Quality Metrics:
- Test Coverage: 87%
- Linting Errors: 0
- Security Issues: 0 critical, 1 medium
- Performance: No bottlenecks identified

📝 QA Report Created:
- docs/features/F001-user-auth/QA_REPORT.md

⚠️ Decision: REVIEW

Issues Found:
- Medium: Session timeout too long (30 days → recommend 30 minutes)
- Low: Some variable names could be more descriptive

Recommendation: Address medium issue before deployment.
Estimated fix time: 30 minutes

🎯 Next Step:
- Fix medium severity issue
- Re-run /qa-check
- Then run /document
```

**Decision Criteria**:
- **PASS**: Zero critical/high issues → Proceed to documentation
- **REVIEW**: Medium issues → Fix recommended, then proceed
- **FAIL**: Critical issues → Must fix, re-run QA

**Pro Tip**: Take QA feedback seriously. These issues will become bugs in production.

**When to `/clear`**: After QA issues are addressed (if any).

---

### Stage 6: Documentation (`/document`)

**Persona**: Documentation Writer

**Purpose**: Create comprehensive user and developer documentation

**Command**:
```
/document
```

**What Happens**:
1. Reviews feature implementation
2. Creates user documentation (how to use)
3. Creates developer documentation (API reference)
4. Creates operational documentation (setup, troubleshooting)
5. Updates project-level documentation
6. Updates STATUS.md

**Key Deliverables**:
- `DOCUMENTATION.md` with:
  - User guide with examples
  - API reference
  - Setup instructions
  - Troubleshooting guide
  - FAQs
- Updated README.md, API.md, CHANGELOG.md

**Output Example**:
```
✅ Documentation complete for F001: User Authentication

📚 Documentation Created:
- ✅ User Guide (how to register, login, logout)
- ✅ API Reference (3 endpoints documented)
- ✅ Setup Instructions (environment variables, config)
- ✅ Troubleshooting Guide (5 common issues)
- ✅ Examples (3 complete examples)

📁 Files Updated:
- ✨ Created: docs/features/F001-user-auth/DOCUMENTATION.md
- ✏️ Updated: README.md (added authentication section)
- ✏️ Updated: docs/API.md (added auth endpoints)
- ✏️ Updated: CHANGELOG.md (added v1.1.0 entry)

🎯 Feature F001 is COMPLETE! 🎉
```

**Pro Tip**: Test your documentation. Can someone follow it without asking questions?

**When to `/clear`**: After documentation is complete.

---

## Best Practices

### 1. Use `/clear` Between Stages
Save context by clearing between personas:
```
/feature-init → work done → /clear
/architect → work done → /clear
/test-first → work done → /clear
/implement → work done → /clear
/qa-check → work done → /clear
/document → work done → done!
```

### 2. Review in Plan Mode
Each persona starts in plan mode. Review the plan before proceeding.

### 3. Follow the Constraints
Each persona has strict constraints (e.g., test engineer can't implement). These prevent scope creep.

### 4. Update STATUS.md
STATUS.md is your single source of truth for feature progress. Keep it updated.

### 5. Don't Skip Stages
Tempted to skip QA? Don't. Each stage catches different issues.

### 6. Use /clear Strategically
Clear often to save tokens, but not so often you lose important context.

---

## Troubleshooting

### "I skipped a stage by accident"
Go back and run it. Example: Forgot to run `/architect`? Run it now.

### "The persona is doing things it shouldn't"
Remind it of its constraints. Example: "You are the test engineer. You must not write implementation code."

### "Tests are passing but QA found issues"
Tests only verify functionality. QA checks quality, security, performance.

### "Feature is taking too long"
Break it into smaller features. Each feature should be completable in 1-2 days max.

---

## Advanced Usage

### Parallel Features
Work on multiple features simultaneously:
```
docs/features/
├── F001-user-auth/      # In implementation stage
├── F002-payment/        # In architecture stage
└── F003-notifications/  # In planning stage
```

Use CURRENT_TASK.md to track which feature you're actively working on.

### Iterative Development
Features don't have to be perfect. Ship F001 v1.0, then create F004 for enhancements.

### Hot Fixes
For urgent bugs, you can skip to `/implement` and `/qa-check`. But document why in STATUS.md.

---

## File Structure Reference

After completing a feature, you'll have:

```
docs/features/F001-user-auth/
├── FEATURE.md           # Requirements (from /feature-init)
├── ARCHITECTURE.md      # Technical design (from /architect)
├── TASKS.md            # Task breakdown (from /architect)
├── STATUS.md           # Progress tracking (updated by all)
├── QA_REPORT.md        # Quality review (from /qa-check)
└── DOCUMENTATION.md    # User/dev docs (from /document)

src/
├── services/
│   ├── AuthService.js           # Implementation
│   └── __tests__/
│       └── AuthService.test.js  # Tests
└── ...

docs/
├── CURRENT_TASK.md     # Shows F001 in deployed stage
└── ROADMAP.md          # Shows F001 complete
```

---

## Comparison to Traditional Development

| Aspect | Traditional | Conductor Feature Workflow |
|--------|-------------|---------------------------|
| **Requirements** | Often vague | Detailed in FEATURE.md |
| **Architecture** | Ad-hoc or upfront | Designed before coding |
| **Tests** | After code (if at all) | Before code (TDD) |
| **Implementation** | Varies widely | Minimal code to pass tests |
| **QA** | End of project | Built into workflow |
| **Documentation** | Last (often skipped) | Required stage |
| **Context Management** | All in memory | /clear between stages |

---

## Next Steps

Ready to try it? Start with a small feature:

```
/feature-init
```

Then follow the workflow. You'll be shipping quality features in no time!

---

**See Also**:
- [GETTING_STARTED.md](GETTING_STARTED.md) - General Conductor setup
- [HOOKS_GUIDE.md](HOOKS_GUIDE.md) - Automation hooks
- [AUTO_DOCS_GUIDE.md](AUTO_DOCS_GUIDE.md) - Auto-documentation system

---

**Last Updated**: 2025-11-17
**Version**: 1.0.0
