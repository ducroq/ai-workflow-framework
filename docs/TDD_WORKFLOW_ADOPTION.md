# Adopting the Enhanced TDD Workflow

**Quick guide for applying Conductor's validated TDD workflow to new or existing projects.**

---

## TL;DR - Copy & Use (5 Minutes)

```bash
# 1. Copy these files to your project:
.claude/commands/feature-init.md
.claude/commands/architect.md
.claude/commands/test-first.md
.claude/commands/implement.md
.claude/commands/qa-check.md
.claude/commands/document.md
.claude/commands/load-context.md
.claude/hooks/session-start-context.sh
.claude/templates/feature/*.md

# 2. Create docs directory
mkdir -p docs/features

# 3. Make hooks executable (Unix/Mac/Linux)
chmod +x .claude/hooks/*.sh

# 4. Initialize your first feature
# In Claude Code:
/feature-init
```

---

## What You're Getting

This workflow provides:

1. **Test-Driven Development with AI**
   - Write comprehensive tests BEFORE code
   - Red → Green → Refactor cycle
   - Quality gates prevent wasted effort

2. **Living Documentation (CLAUDE.md)**
   - Persistent project memory across Claude sessions
   - Captures decisions, patterns, problems, solutions
   - Auto-updates as you work

3. **Circuit-Breaker Pattern**
   - Max 7 iterations per component
   - Prevents infinite refinement loops
   - Forces reassessment when stuck

4. **Automated Context Loading**
   - Session start loads relevant documentation
   - Shows active features and blockers
   - Suggests next actions based on stage

---

## For New Projects

### Complete File Checklist

Copy these files from Conductor to your project:

```
your-project/
├── .claude/
│   ├── commands/
│   │   ├── feature-init.md      # Initialize new features
│   │   ├── architect.md         # Design technical architecture
│   │   ├── test-first.md        # Write tests before code
│   │   ├── implement.md         # Make tests pass
│   │   ├── qa-check.md          # Quality assurance review
│   │   ├── document.md          # Final documentation
│   │   └── load-context.md      # Smart context loading
│   ├── hooks/
│   │   └── session-start-context.sh  # Auto-load context
│   └── templates/
│       └── feature/
│           ├── ARCHITECTURE.md  # Technical design template
│           ├── CLAUDE.md        # Knowledge base template
│           ├── FEATURE.md       # Requirements template
│           ├── STATUS.md        # Progress tracking template
│           └── TASKS.md         # Task breakdown template
└── docs/
    ├── features/                # Feature-specific docs (create empty)
    ├── FEATURE_WORKFLOW_GUIDE.md     # Methodology reference
    └── TDD_WORKFLOW_ADOPTION.md      # This file
```

### Quick Setup

```bash
# From Conductor repository root
cd /path/to/conductor

# Copy to your project
cp -r .claude/commands/feature-init.md /path/to/your-project/.claude/commands/
cp -r .claude/commands/architect.md /path/to/your-project/.claude/commands/
cp -r .claude/commands/test-first.md /path/to/your-project/.claude/commands/
cp -r .claude/commands/implement.md /path/to/your-project/.claude/commands/
cp -r .claude/commands/qa-check.md /path/to/your-project/.claude/commands/
cp -r .claude/commands/document.md /path/to/your-project/.claude/commands/
cp -r .claude/commands/load-context.md /path/to/your-project/.claude/commands/
cp -r .claude/hooks/session-start-context.sh /path/to/your-project/.claude/hooks/
cp -r .claude/templates/feature/ /path/to/your-project/.claude/templates/
cp docs/FEATURE_WORKFLOW_GUIDE.md /path/to/your-project/docs/

# Make hooks executable
chmod +x /path/to/your-project/.claude/hooks/*.sh

# Create features directory
mkdir -p /path/to/your-project/docs/features
```

### Optional: Auto-Approve Permissions

Add to your project's `.claude/settings.json`:

```json
{
  "autoApprove": [
    "Read(docs/**)",
    "Write(docs/**)",
    "Edit(docs/**)",
    "Bash(.claude/hooks/*)"
  ]
}
```

This allows Claude Code to work with documentation without asking permission each time.

---

## For Existing Projects

### Integration Strategies

**Strategy 1: Full Adoption** (Recommended for active projects)
- Copy all workflow files
- Use `/feature-init` for all new work going forward
- Gradually document existing features as you touch them

**Strategy 2: Pilot One Feature**
- Copy minimal files (feature-init, templates, workflow guide)
- Try workflow on one new feature
- Expand if successful

**Strategy 3: Documentation Only**
- Start with just CLAUDE.md template
- Document existing features manually
- Add slash commands later when comfortable

### Recommended Approach

```bash
# Week 1: Pilot
1. Copy core files (feature-init, test-first, implement, templates)
2. Pick one new feature to build with workflow
3. Complete full cycle: init → architect → test → implement → qa → document

# Week 2: Evaluate
4. Review CLAUDE.md - was it useful?
5. Did TDD workflow help or hinder?
6. What would you customize?

# Week 3+: Expand
7. Copy remaining files (hooks, automation)
8. Apply to all new features
9. Gradually document existing features
```

### Adapting to Your Tech Stack

The workflow is framework-agnostic but may need adjustments:

**Backend API Projects:**
```markdown
# Add to ARCHITECTURE.md template:
## API Design
### Endpoints
- POST /api/resource
- GET /api/resource/:id

### Request/Response Schemas
...
```

**Frontend Projects:**
```markdown
# Add to ARCHITECTURE.md template:
## Component Hierarchy
- App
  - Header
  - MainContent
  - Footer

## State Management
- Redux/Context/Zustand structure
```

**Libraries/Packages:**
```markdown
# Add to ARCHITECTURE.md template:
## Public API
### Exported Functions
### Type Definitions
```

**Test Framework Adjustments:**

Replace Jest examples in `/test-first` with your framework:

```markdown
# For Python/pytest:
def test_should_save_theme():
    storage.save('dark')
    assert storage.load() == 'dark'

# For Ruby/RSpec:
describe ThemeStorage do
  it 'saves theme preference' do
    storage.save('dark')
    expect(storage.load).to eq('dark')
  end
end

# For Go:
func TestSaveTheme(t *testing.T) {
    storage.Save("dark")
    if storage.Load() != "dark" {
        t.Error("Expected dark theme")
    }
}
```

---

## The Workflow in Action

### Step-by-Step: Building a Feature

Let's walk through adding a feature using this workflow:

#### 1. Initialize Feature (2 minutes)

```bash
/feature-init
```

**Claude prompts:**
- Feature name: "User Profile Page"
- Feature ID: F005
- Priority: High
- Target: End of sprint

**Creates:**
```
docs/features/F005-user-profile-page/
├── FEATURE.md        # Requirements (you'll edit)
├── ARCHITECTURE.md   # Technical design (generated)
├── TASKS.md          # Task breakdown (generated)
├── STATUS.md         # Progress tracking (auto-updated)
└── CLAUDE.md         # Knowledge base (grows over time)
```

#### 2. Define Requirements (5 minutes)

Edit `FEATURE.md`:

```markdown
## User Story
As a user, I want to view and edit my profile
So that I can keep my information up-to-date

## Acceptance Criteria
- [ ] Display current user information
- [ ] Allow editing name, email, bio
- [ ] Validate email format
- [ ] Save changes to backend
- [ ] Show success/error feedback
```

#### 3. Design Architecture (10 minutes)

```bash
/architect
```

**Claude analyzes requirements and creates:**

```markdown
# ARCHITECTURE.md

## Design Decisions
1. React component with local state
2. API call to PATCH /api/user/:id
3. Form validation with Yup
4. Optimistic UI updates

## Components
- UserProfilePage (container)
- ProfileForm (presentation)
- Avatar (reusable)

## Data Flow
User edits → Form validates → API call → Update local state → Show feedback

## Key Files
- src/components/UserProfilePage.jsx
- src/components/ProfileForm.jsx
- src/api/userService.js
- tests/UserProfilePage.test.jsx
```

**Also updates:**
- `TASKS.md` with atomic tasks
- `CLAUDE.md` with architectural decisions

#### 4. Write Tests First (20 minutes)

```bash
/test-first
```

**Claude creates comprehensive tests BEFORE implementation:**

```javascript
// tests/UserProfilePage.test.jsx

describe('UserProfilePage', () => {
  test('should display current user information', () => {
    // Arrange: Mock user data
    // Act: Render component
    // Assert: Check displayed data
  });

  test('should validate email format', () => {
    // Arrange: Enter invalid email
    // Act: Submit form
    // Assert: Show error message
  });

  test('should save changes to backend', async () => {
    // Arrange: Mock API
    // Act: Edit and submit
    // Assert: API called with correct data
  });

  // ... 8 more tests covering edge cases
});
```

**All tests currently FAIL (Red phase)**

**Also updates:**
- `CLAUDE.md` with test strategy, mocking decisions, edge cases

#### 5. Implement Code (30-60 minutes)

```bash
/implement
```

**Claude writes minimal code to make tests pass:**

```javascript
// src/components/UserProfilePage.jsx

const UserProfilePage = () => {
  const [user, setUser] = useState(null);
  const [errors, setErrors] = useState({});

  const handleSubmit = async (values) => {
    // Validate
    // Call API
    // Update state
    // Show feedback
  };

  return <ProfileForm user={user} onSubmit={handleSubmit} errors={errors} />;
};
```

**Circuit-breaker tracks iterations:**
- Iteration 1: Basic structure, 5/11 tests passing
- Iteration 2: Add validation, 9/11 tests passing
- Iteration 3: Fix edge cases, 11/11 tests passing ✅ (Green phase)
- Iteration 4: Refactor for clarity (Refactor phase)

**All tracked in CLAUDE.md:**
```markdown
## Implementation Journey

### Iteration 1 of 7
**Goal**: Basic component structure
**Result**: 5/11 tests passing
**Problem**: Email validation not working
**Solution**: Added Yup schema validation

### Iteration 2 of 7
...
```

#### 6. Quality Assurance (10 minutes)

```bash
/qa-check
```

**Claude reviews:**
- Code quality (no duplication, clear naming)
- Test coverage (100% for core logic)
- Acceptance criteria (all met)
- Security (input validation, XSS prevention)
- Performance (no unnecessary re-renders)

**Result:** PASS with 2 minor suggestions (add loading state, improve error messages)

#### 7. Final Documentation (5 minutes)

```bash
/document
```

**Claude creates:**
- User-facing documentation
- Developer notes in CLAUDE.md
- Updates STATUS.md to "Complete"

**Total time: ~90 minutes for complete feature with tests, docs, and quality review**

---

## Daily Workflow

### Starting Your Day

Open Claude Code in your project:

```
📖 Loading project context...

Current Task: Implementing user authentication

📚 Active Features: 2
   📍 F005-user-profile-page (Implementation 80%)
   📍 F006-password-reset (Testing 40%)

💡 Recent Context from CLAUDE.md:
   - 3 problem-solution pairs documented
   - Circuit-breaker: Iteration 4/7 for ProfileForm

🚫 1 active blocker: API rate limiting on dev server

🎯 Next Actions:
   - Run /implement to continue ProfileForm
   - Address blocker: API rate limiting
   - Run /qa-check when implementation complete
```

**This auto-loads via `session-start-context.sh` hook**

### During Development

**Need context?**
```bash
/load-context
```

Shows relevant patterns, decisions, and solutions from CLAUDE.md based on current work.

**Stuck on something?**

Document in CLAUDE.md → Problem-Solution Pairs:
```markdown
### Problem 3: Form Re-renders on Every Keystroke
**Context**: ProfileForm re-rendering causing performance issues

**Problem**: React re-renders entire form on each character typed

**Solution**: Memoized child components with React.memo()

**Outcome**: ✅ 10x improvement in input responsiveness
```

Future Claude sessions will reference this solution!

---

## Customization

### Adjusting Commands

All commands are markdown files in `.claude/commands/`.

**Example: Add your company's coding standards**

Edit `.claude/commands/implement.md`:

```markdown
## Coding Standards

Before implementing, ensure you follow:
- [ ] Company style guide (link)
- [ ] Security checklist (link)
- [ ] Accessibility standards (WCAG AA)
- [ ] Performance budgets (< 300ms interaction)

## Our Tech Stack

**Frontend**: React 18, TypeScript, TailwindCSS
**Backend**: Node.js, Express, PostgreSQL
**Testing**: Jest, React Testing Library, Playwright
```

### Adding Team-Specific Templates

Create `.claude/templates/feature/API_DESIGN.md`:

```markdown
# API Design: {Feature Name}

## Endpoints

### POST /api/...
**Request:**
```json
{
  "field": "value"
}
```

**Response:**
```json
{
  "id": 123,
  "created": "2025-11-19"
}
```

**Errors:**
- 400: Validation error
- 401: Unauthorized
- 500: Server error

## Database Schema Changes

...
```

Reference from `/architect` command.

### Creating Custom Commands

`.claude/commands/deploy.md`:

```markdown
# Deploy Feature

You are a **Deployment Engineer** helping deploy a feature to production.

## Pre-Deployment Checklist
- [ ] All tests passing
- [ ] QA review complete
- [ ] Documentation updated
- [ ] Feature flags configured

## Deployment Steps
1. Run production build
2. Run database migrations
3. Deploy to staging
4. Smoke test on staging
5. Deploy to production
6. Monitor for errors

## Rollback Plan
If issues occur:
1. Revert to previous version
2. Document incident in CLAUDE.md
3. Create fix plan

## Update Documentation
- Update STATUS.md to "Deployed"
- Add deployment notes to CLAUDE.md
```

Use with `/deploy`

---

## Tips for Success

### 1. Trust the Test-First Process

It feels slow at first, but pays off:
- **Without TDD**: Write code → manual testing → bugs → fix → repeat
- **With TDD**: Write tests → write code once → all tests pass → done

**Real example from F001 demo:**
- Tests written: 15 minutes
- Implementation: 10 minutes (guided by tests)
- Total: 25 minutes
- Bugs after: 0

### 2. Document Problems in CLAUDE.md

**Bad:**
```markdown
Fixed the validation bug
```

**Good:**
```markdown
### Problem: Email Validation Not Triggering

**Context**: Form submission wasn't checking email format

**Problem**: Yup schema not attached to Formik form

**Solution**: Added `validationSchema={emailSchema}` prop to Formik

**Outcome**: ✅ All validation tests now pass

**Pattern**: Always attach Yup schemas to Formik forms, not manual validation
```

Future sessions will reference this!

### 3. Follow Circuit-Breaker Limits

When you hit 7 iterations:

**DON'T:**
- "Just one more try"
- Keep tweaking without stepping back
- Blame the tests

**DO:**
- Review if tests are correct
- Consider if architecture needs adjustment
- Document blocker in CLAUDE.md
- Ask for user guidance

### 4. Use Small Commits

Commit after each workflow stage:

```bash
git commit -m "F005: Complete architecture design

- Created 3-component hierarchy
- Defined API contract
- Planned validation strategy"

git commit -m "F005: Write comprehensive tests

- 11 tests covering happy path and edge cases
- Mock API and validation
- All tests currently failing (Red)"

git commit -m "F005: Implement ProfileForm component

- Basic structure and validation
- API integration
- All 11 tests passing (Green)"
```

This creates clear history and enables easy rollback.

### 5. Review Workflow Effectiveness

Every 3-5 features, ask:
- Which commands do I use most?
- What documentation is valuable?
- What feels like busywork?
- What should be automated?

**Evolve the workflow to fit your reality**

---

## Real-World Examples

### Example 1: Backend API Endpoint

**Feature**: Add password reset endpoint

```bash
# 1. Initialize
/feature-init  # Creates F007-password-reset

# 2. Define requirements
Edit FEATURE.md:
- User requests reset via email
- Generate secure token
- Send reset link
- Token expires in 1 hour

# 3. Design architecture
/architect
Creates:
- POST /api/auth/request-reset
- POST /api/auth/confirm-reset/:token
- Database: reset_tokens table
- Email service integration

# 4. Write tests
/test-first
Creates:
- Test: Valid email sends reset link
- Test: Invalid email returns 404
- Test: Token expires after 1 hour
- Test: Used token cannot be reused
- Test: SQL injection attempt fails

# 5. Implement
/implement
Writes code to make all tests pass

# 6. Review
/qa-check
Checks security, error handling, edge cases

# 7. Document
/document
Creates API documentation, updates STATUS
```

### Example 2: React Component

**Feature**: Add data table with sorting

```bash
/feature-init  # F008-sortable-table

Edit FEATURE.md:
- Display tabular data
- Click column headers to sort
- Support ascending/descending
- Keyboard navigation

/architect
Creates:
- DataTable component
- useSort custom hook
- Accessibility with ARIA

/test-first
Creates:
- Test: Renders data correctly
- Test: Click header sorts ascending
- Test: Second click sorts descending
- Test: Keyboard Enter key sorts
- Test: ARIA labels present

/implement
Makes tests pass with minimal code

/qa-check
Verifies accessibility and performance

/document
Creates component docs and examples
```

---

## Troubleshooting

### "Tests are taking too long to write"

**Symptoms**: Spending > 30 minutes writing tests for simple feature

**Solutions**:
1. Simplify tests - focus on behavior, not implementation
2. Use `/test-first` with "minimal test scope" guidance
3. Write fewer, more focused tests initially
4. Remember: Time writing tests saves debugging time later

**Example**:
```javascript
// TOO DETAILED (testing implementation)
test('should set loading state to true before API call', () => {
  // Testing internal state is fragile
});

// JUST RIGHT (testing behavior)
test('should show loading spinner while saving', () => {
  // User-visible behavior is stable
});
```

### "Circuit-breaker keeps hitting limit"

**Symptoms**: Regularly reaching 7 iterations without passing tests

**Solutions**:
1. Review test expectations - are they realistic?
2. Check architecture - is it too complex?
3. Break into smaller components
4. Document blocker in CLAUDE.md and ask user for guidance

**Example**:
```markdown
## Blockers

### Blocker 1: ProfileForm Not Validating
**Date**: 2025-11-19
**Stage**: Implementation (Iteration 7/7)
**Issue**: Email validation tests failing despite correct Yup schema

**Attempts**:
1. Added validation schema - still failing
2. Checked Yup version - matches docs
3. Simplified schema - same result
4-7. Various tweaks - no progress

**Assessment**: May need to revisit architecture decision to use Yup
**Next**: Consider alternative validation libraries or manual validation
```

### "CLAUDE.md getting too long"

**Symptoms**: File > 1000 lines, taking too long to load context

**Solutions**:
1. Archive completed sections to `CLAUDE_ARCHIVE.md`
2. Keep only recent iterations, problems, patterns
3. Use `/load-context` to filter relevance
4. Remember: Only document what's useful for future sessions

**Archive old content:**
```markdown
# CLAUDE.md (keep recent)
## Implementation Journey
### Iteration 8-10 (most recent)
...

# CLAUDE_ARCHIVE.md (archive old)
## Implementation Journey (Archive)
### Iteration 1-7 (completed)
...
```

### "Session context not loading"

**Symptoms**: No context message when opening Claude Code

**Solutions**:

```bash
# Check hook is executable
ls -la .claude/hooks/session-start-context.sh

# Should show: -rwxr-xr-x (x for executable)
# If not:
chmod +x .claude/hooks/session-start-context.sh

# Test hook manually
bash .claude/hooks/session-start-context.sh

# Check for errors in output
```

---

## What's Next?

### After Your First Feature

1. ✅ Review CLAUDE.md - was it useful across sessions?
2. ✅ Check if TDD helped catch bugs early
3. ✅ Evaluate if circuit-breaker prevented wasted time
4. ✅ Decide what to customize for your project

### Scaling Up

**5-10 features**: You'll develop patterns
- Reusable test patterns emerge
- Common problems documented in CLAUDE.md
- Architecture templates stabilize

**10+ features**: The workflow becomes natural
- CLAUDE.md becomes primary project memory
- Less time documenting, more time referencing
- New features benefit from accumulated knowledge

### Advanced Usage

**Multiple features in parallel:**
```bash
# Feature 1
/feature-init  # F009-feature-a
/architect
/test-first

# Switch to Feature 2
/feature-init  # F010-feature-b
/architect

# Session context shows both:
📚 Active Features: 2
   📍 F009-feature-a (Testing 100%, Impl 0%)
   📍 F010-feature-b (Architecture 100%)
```

**Team collaboration:**
- Each developer drives Claude Code on their features
- CLAUDE.md becomes shared knowledge base
- Patterns discovered by one developer help whole team

---

## Summary

### Core Workflow

```
/feature-init → /architect → /test-first → /implement → /qa-check → /document
```

### Key Benefits

1. **Test-First prevents bugs** - Catch issues before they exist
2. **Living documentation persists knowledge** - No context loss between sessions
3. **Circuit-breaker prevents waste** - Stop spinning wheels after 7 tries
4. **Automation reduces manual work** - Context loads automatically

### Files to Copy

```
.claude/commands/*.md (7 files)
.claude/hooks/session-start-context.sh
.claude/templates/feature/*.md (5 files)
docs/FEATURE_WORKFLOW_GUIDE.md
```

### Time Investment

- **Setup**: 5 minutes
- **Learning**: First feature ~2 hours
- **Payoff**: Every feature after is faster and better documented

---

**Ready to start?** Run `/feature-init` in your project and build your first feature with this workflow!

**Questions?** Check `docs/FEATURE_WORKFLOW_GUIDE.md` for complete methodology

**See it in action?** Review `docs/features/F001-dark-mode-toggle/` for working example

---

**Last Updated**: 2025-11-19
**Validated With**: F001 Dark Mode Toggle demo
**Framework Version**: 1.0
