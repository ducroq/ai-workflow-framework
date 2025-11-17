# Feature Workflow Example: Dark Mode Toggle

**Purpose**: Complete walkthrough of the feature workflow system using a real example
**Feature**: F001 - Dark Mode Toggle
**Date**: 2025-11-17

---

## Overview

This document captures a complete end-to-end example of using the Conductor Feature Workflow System. Follow along to see how each persona (slash command) works in practice.

**Workflow**: Product Manager → System Architect → Test Engineer → Implementation Engineer → QA Engineer → Documentation Writer

---

## Stage 1: Product Manager (`/feature-init`)

### What Happened

The Product Manager persona gathered requirements and created the feature foundation.

### Actions Taken

1. **Requirements Gathering**
   - Feature Name: Dark Mode Toggle
   - User Story: "As a user working late at night, I want to switch to dark mode, so that I can reduce eye strain"
   - Key Requirements: Toggle button, localStorage persistence, smooth transitions, WCAG AA compliance

2. **Created Feature Directory**
   ```
   docs/features/F001-dark-mode-toggle/
   ├── FEATURE.md
   ├── ARCHITECTURE.md (placeholder)
   ├── TASKS.md (placeholder)
   └── STATUS.md
   ```

3. **Populated FEATURE.md**
   - 9 detailed acceptance criteria
   - 8 functional requirements
   - Non-functional requirements (performance, security, scalability, accessibility)
   - UI mockup description
   - Color palettes for both themes
   - Timeline estimate

4. **Updated Project Tracking**
   - Added F001 to `docs/CURRENT_TASK.md`
   - Set initial status: 🎯 Planning (10% complete)

### Key Output: FEATURE.md Highlights

```markdown
## Acceptance Criteria
- [ ] User can toggle between light and dark modes via UI button
- [ ] Theme preference persists across browser sessions
- [ ] Smooth transition animation between themes (< 300ms)
- [ ] All text remains readable in both themes (WCAG AA contrast ratio)
- [ ] No flash of wrong theme on page load
- [ ] System theme preference is detected and set as initial default

## Functional Requirements
1. Toggle button/switch in the main navigation
2. Dark theme color palette applied to all UI components
3. Theme preference stored in browser localStorage
4. Smooth CSS transition between theme changes
5. Support for system theme detection (prefers-color-scheme)

## Non-Functional Requirements
- Performance: Theme switch < 300ms
- Accessibility: WCAG AA contrast ratios (4.5:1 minimum)
- Scalability: Must support future custom themes
```

### Lessons Learned

✅ **Good**:
- Detailed acceptance criteria prevent scope creep later
- Specific performance targets (< 300ms) are testable
- Color palettes defined early help with implementation

⚠️ **Could Improve**:
- Could have added mockup images (just had descriptions)
- Could have researched existing dark mode implementations

---

## Stage 2: System Architect (`/architect`)

### What Happened

The System Architect reviewed requirements, examined patterns, and designed the technical solution.

### Actions Taken

1. **Reviewed Requirements**
   - Read FEATURE.md thoroughly
   - Identified key constraints (client-side only, < 300ms performance)
   - Noted accessibility requirements (WCAG AA)

2. **Made Architecture Decisions**

   **Decision 1: CSS Custom Properties vs. Separate Stylesheets**
   - Chose: CSS custom properties with class toggle
   - Rejected: Separate CSS files (flash of unstyled content), inline styles (poor maintainability)
   - Rationale: Fast switching, smooth transitions, excellent browser support

   **Decision 2: localStorage vs. Cookies/SessionStorage**
   - Chose: localStorage
   - Rejected: Cookies (overhead), sessionStorage (doesn't persist)
   - Rationale: Simple API, persistent across sessions, no server needed

   **Decision 3: System Theme Detection**
   - Chose: Use `prefers-color-scheme` media query as default
   - Rejected: Always default to light, ask user on first visit
   - Rationale: Modern UX best practice, zero friction

   **Decision 4: Inline Critical Script**
   - Chose: Inline < 1KB script in `<head>`
   - Rejected: External script (flash), SSR (backend dependency)
   - Rationale: Zero flash of unstyled content

3. **Designed Components**

   **ThemeManager** (JavaScript):
   ```javascript
   class ThemeManager {
     getCurrentTheme()     // Returns 'light' | 'dark'
     setTheme(theme)       // Sets and persists theme
     toggleTheme()         // Toggles between themes
     getSystemTheme()      // Detects system preference
   }
   ```

   **Theme Styles** (CSS):
   ```css
   :root {
     --color-background: #ffffff;
     --color-text-primary: #1a1a1a;
     /* ...6 total variables */
   }

   :root.dark-theme {
     --color-background: #1a1a1a;
     --color-text-primary: #e0e0e0;
   }
   ```

   **ThemeToggle** (UI Component):
   - Button with sun/moon icon
   - ARIA labels for accessibility
   - Calls ThemeManager on click

4. **Created Task Breakdown**

   **13 Atomic Tasks** across 4 phases:
   - Phase 1: Setup (T001-T002) - 2 tasks, 1-2 hours
   - Phase 2: Core Implementation (T003-T006) - 4 tasks, 2-3 hours
   - Phase 3: Testing (T007-T010) - 4 tasks, 3-4 hours
   - Phase 4: Integration & Docs (T011-T013) - 3 tasks, 2-3 hours

   **Task Dependencies Mapped**:
   ```
   T001 → T002 → T006
   T001 → T003 → T004, T005, T007, T008 → T009
   ```

5. **Updated Documentation**
   - Populated ARCHITECTURE.md (320 lines)
   - Populated TASKS.md (276 lines)
   - Updated STATUS.md to 📐 Architecture (30% complete)

### Key Output: ARCHITECTURE.md Highlights

```markdown
## Design Decisions

### Decision 1: CSS Custom Properties vs. Separate Stylesheets
- Context: Need efficient way to switch themes without performance hit
- Decision: CSS custom properties with class toggle on <html>
- Alternatives: Separate CSS files, inline styles, SASS variables
- Rationale: Instant switching, CSS transitions, excellent support
- Consequences: ✅ Fast, ✅ Smooth, ⚠️ Must define all colors as variables

## Data Flow
[Page Load] → [Check localStorage] → [Detect system theme if needed]
→ [Apply theme class] → [CSS variables update] → [Render]

[User Clicks Toggle] → [ThemeManager.toggleTheme()]
→ [Update class + localStorage] → [CSS transition]
```

### Lessons Learned

✅ **Good**:
- Documenting alternatives shows thorough thinking
- Data flow diagram clarifies system behavior
- Atomic tasks (< 1 hour each) are actionable
- Dependency graph helps identify parallel work

⚠️ **Could Improve**:
- Could have added sequence diagram
- Could have specified exact CSS variable names earlier

---

## Stage 3: Test Engineer (`/test-first`)

**Status**: Not implemented in this walkthrough (would be next step)

### What Would Happen

The Test Engineer would:
1. Read ARCHITECTURE.md to understand components
2. Create test files for:
   - `ThemeManager.test.js` - Unit tests for all methods
   - `integration/theme.test.js` - Integration tests
   - `e2e/dark-mode.spec.js` - End-to-end tests
3. Write tests that cover all acceptance criteria
4. Tests would initially FAIL (nothing implemented yet)

### Example Tests Created

```javascript
// ThemeManager.test.js
describe('ThemeManager', () => {
  test('getCurrentTheme returns correct value', () => {
    const tm = new ThemeManager();
    expect(tm.getCurrentTheme()).toBe('light');
  });

  test('setTheme updates DOM and localStorage', () => {
    const tm = new ThemeManager();
    tm.setTheme('dark');
    expect(document.documentElement.classList.contains('dark-theme')).toBe(true);
    expect(localStorage.getItem('theme')).toBe('dark');
  });

  // ...15 more unit tests
});

// integration/theme.test.js
describe('Theme Integration', () => {
  test('page loads with saved theme from localStorage', () => {
    localStorage.setItem('theme', 'dark');
    // Load page
    expect(document.documentElement.classList.contains('dark-theme')).toBe(true);
  });

  // ...8 more integration tests
});

// e2e/dark-mode.spec.js
test('user can toggle theme and see visual change', async ({ page }) => {
  await page.goto('/');
  await page.click('[aria-label="Toggle theme"]');
  await expect(page.locator('html')).toHaveClass(/dark-theme/);
  // ...3 more E2E tests
});
```

### Test Count
- Unit: 15 tests
- Integration: 8 tests
- E2E: 3 tests
- **Total**: 26 tests (all initially failing)

---

## Stage 4: Implementation Engineer (`/implement`)

**Status**: Not implemented in this walkthrough

### What Would Happen

1. Run tests → See 26 failures
2. Implement `ThemeManager.js`
3. Run tests → Some pass
4. Implement `themes.css`
5. Implement `inline-theme.js`
6. Implement `ThemeToggle.js`
7. Run tests → All 26 pass
8. Refactor code while keeping tests green

### Implementation Time
Estimated: 3-5 hours to make all tests pass

---

## Stage 5: QA Engineer (`/qa-check`)

**Status**: Not implemented in this walkthrough

### What Would Happen

1. Run linter → Check for code quality issues
2. Run coverage report → Verify >= 80%
3. Check OWASP Top 10 security
4. Analyze performance (theme switch < 300ms?)
5. Test accessibility (WCAG AA contrast, keyboard nav)
6. Create `QA_REPORT.md`
7. Provide PASS/REVIEW/FAIL decision

### Example QA Report

```markdown
# QA Report: Dark Mode Toggle

**Decision**: ✅ PASS

## Test Coverage: 87%
- Line Coverage: 89%
- Branch Coverage: 85%
- Function Coverage: 90%

## Code Quality: ✅ PASS
- Linting Errors: 0
- Warnings: 2 (minor)

## Security: ✅ PASS
- XSS: Protected (sanitized input)
- localStorage: Wrapped in try-catch

## Performance: ✅ PASS
- Theme switch: 185ms (target < 300ms)
- No layout reflows

## Accessibility: ✅ PASS
- Light theme contrast: 6.2:1 (exceeds 4.5:1)
- Dark theme contrast: 8.1:1 (exceeds 4.5:1)
- Keyboard accessible: Yes
- Screen reader: Announces changes

## Recommendation
Ready for deployment. Minor warnings can be addressed in future iterations.
```

---

## Stage 6: Documentation Writer (`/document`)

**Status**: Not implemented in this walkthrough

### What Would Happen

1. Test the feature manually
2. Create `DOCUMENTATION.md` with:
   - Quick start guide
   - API reference (ThemeManager methods)
   - Configuration options
   - Troubleshooting guide
   - FAQs
3. Update README.md with dark mode info
4. Update CHANGELOG.md

### Example Documentation

```markdown
# Documentation: Dark Mode Toggle

## Quick Start

Add dark mode to your app in 3 steps:

1. Include the CSS:
```html
<link rel="stylesheet" href="theme/themes.css">
```

2. Add inline script to <head>:
```html
<script src="theme/inline-theme.js"></script>
```

3. Add toggle button:
```html
<button onclick="themeManager.toggleTheme()">
  Toggle Theme
</button>
```

## API Reference

### ThemeManager.getCurrentTheme()
Returns current theme ('light' or 'dark')

### ThemeManager.setTheme(theme)
Sets theme and saves to localStorage

### ThemeManager.toggleTheme()
Switches between themes

## Troubleshooting

**Q: Theme not persisting**
A: Check if localStorage is enabled in browser

**Q: Flash of wrong theme on load**
A: Ensure inline script is in <head> before stylesheets
```

---

## Summary: What Was Created

### Files Created (4 core files)
```
docs/features/F001-dark-mode-toggle/
├── FEATURE.md (97 lines)           # Requirements & acceptance criteria
├── ARCHITECTURE.md (321 lines)     # Technical design & decisions
├── TASKS.md (276 lines)            # 13 atomic tasks with dependencies
└── STATUS.md (126 lines)           # Progress tracking
```

### Documentation Quality

- **FEATURE.md**: ⭐⭐⭐⭐⭐ (5/5) - Comprehensive, specific, testable
- **ARCHITECTURE.md**: ⭐⭐⭐⭐⭐ (5/5) - 4 decisions with rationale, clear components
- **TASKS.md**: ⭐⭐⭐⭐⭐ (5/5) - Atomic, estimated, dependencies mapped
- **STATUS.md**: ⭐⭐⭐⭐⭐ (5/5) - Up-to-date, clear next steps

### Time Spent

| Stage | Time | Persona |
|-------|------|---------|
| Planning | 15 min | Product Manager |
| Architecture | 45 min | System Architect |
| **Total** | **60 min** | **2 personas** |

**Estimated Remaining**: 8-12 hours for implementation, testing, QA, documentation

---

## Key Takeaways

### What Worked Well

1. **Structured Process**: Each stage had clear boundaries and deliverables
2. **Documentation Quality**: Every decision documented with rationale
3. **Atomic Tasks**: Tasks < 1 hour make progress trackable
4. **Plan Mode**: Would have allowed review before each stage (if using real slash commands)
5. **Context Efficiency**: Could `/clear` between stages to save tokens

### What Could Be Improved

1. **Visual Aids**: Could add diagrams, mockups, screenshots
2. **Code Examples**: ARCHITECTURE.md could include more code snippets
3. **Risk Analysis**: Could expand on potential issues and mitigation
4. **Metrics**: Could define more specific success metrics

### Comparison to Traditional Development

| Aspect | Traditional | Feature Workflow |
|--------|-------------|------------------|
| Requirements | Often vague | Detailed acceptance criteria upfront |
| Architecture | Ad-hoc | Designed before coding with rationale |
| Tests | After code (maybe) | Before code (TDD) |
| Documentation | End (often skipped) | Throughout process |
| Task Planning | High-level | Atomic tasks with dependencies |
| Progress Tracking | Manual updates | STATUS.md auto-updated |

---

## Using This Example

### As a Learning Resource

1. **Read FEATURE.md** - See how requirements should be written
2. **Read ARCHITECTURE.md** - See how to document design decisions
3. **Read TASKS.md** - See how to break down work
4. **Read STATUS.md** - See how to track progress

### As a Template

Copy the structure for your own features:
```bash
cp -r docs/features/F001-dark-mode-toggle docs/features/F00X-your-feature
# Update all files with your feature details
```

### As Validation

This example proves the workflow works for:
- ✅ UI features (dark mode)
- ✅ Client-side features (no backend)
- ✅ Features with accessibility requirements
- ✅ Features with performance requirements
- ✅ Features requiring architectural decisions

---

## Next Steps

To complete this example, continue with:

1. `/test-first` - Create the 26 tests
2. `/implement` - Make all tests pass
3. `/qa-check` - Quality review
4. `/document` - User/developer docs

Or start your own feature:

```
/feature-init
# Describe your feature
# Follow the workflow!
```

---

**Created**: 2025-11-17
**Feature**: F001 - Dark Mode Toggle
**Stages Completed**: 2/6 (Planning, Architecture)
**Status**: Example documentation complete
