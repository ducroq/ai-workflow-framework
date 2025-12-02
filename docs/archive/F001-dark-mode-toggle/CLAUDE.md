# Feature Knowledge Base: Dark Mode Toggle

**Feature ID**: F001
**Created**: 2025-11-17
**Last Updated**: 2025-11-19

---

## Purpose

This document captures implementation knowledge, decisions, and lessons learned during the development of this feature. It serves as a knowledge base for:
- Future developers working on similar features
- AI pair programming context
- Team learning and pattern sharing
- Troubleshooting and debugging

---

## Test Strategy

### Overall Approach
**Test Framework**: Jest with jsdom environment for DOM testing
**Test Philosophy**: Write comprehensive tests BEFORE implementation (TDD)
**Coverage Target**: 100% for core modules (ThemeStorage, ThemeManager, ThemeUI)

**Test Pyramid**:
- Unit Tests (14): Foundation - test individual modules in isolation
- Integration Tests (6): Verify module interactions and data flow
- E2E Tests (6): Complete user workflows
- Accessibility Tests (5): WCAG AA compliance
- Performance Tests (3): Speed and efficiency requirements

**Total: 34 tests across 6 test files**

### Mocking Decisions

**localStorage**: Mocked globally in `tests/setup.js`
- Reason: Prevents side effects between tests
- Implementation: In-memory store that resets per test
- Behavior: Fully simulates localStorage API including errors

**window.matchMedia**: Mocked per test
- Reason: Need to simulate different system theme preferences
- Implementation: Jest mock returning configurable matches
- Scenarios: Dark preference, light preference, no support

**DOM Elements**: Created fresh per test
- Reason: Isolated test environment
- Implementation: `beforeEach` creates clean DOM structure
- Cleanup: `afterEach` or test-specific cleanup

**ThemeStorage in ThemeManager tests**: Mocked dependency
- Reason: Unit test ThemeManager in isolation
- Implementation: Jest mock functions
- Verified: save() and load() calls are made correctly

**ThemeManager in ThemeUI tests**: Mocked dependency
- Reason: Unit test ThemeUI in isolation
- Implementation: Jest mock functions
- Verified: getCurrentTheme() and setTheme() interactions

### Non-Obvious Edge Cases

**Corrupted localStorage data**:
- Test: load() returns null for invalid theme value
- Why: User might manually edit localStorage
- Expectation: Graceful fallback to default

**localStorage disabled (privacy mode)**:
- Test: isAvailable() returns false
- Why: Private browsing blocks localStorage
- Expectation: Theme works but doesn't persist

**System theme preference unsupported**:
- Test: matchMedia returns false for prefers-color-scheme
- Why: Older browsers don't support this query
- Expectation: Default to light theme

**"system" theme value**:
- Test: getCurrentTheme() resolves "system" to actual theme
- Why: User can save "system" as preference
- Expectation: Always returns "light" or "dark", never "system"

**Multiple theme change listeners**:
- Test: All listeners notified when theme changes
- Why: Multiple components may subscribe
- Expectation: Each listener called with new theme

**Reduced motion preference**:
- Test: No animation when prefers-reduced-motion: reduce
- Why: Accessibility requirement for motion-sensitive users
- Expectation: Transitions disabled or set to 0ms

### Test Patterns Used

**Arrange-Act-Assert (AAA)**:
Every test follows this pattern for clarity:
```javascript
// Arrange - Setup test conditions
// Act - Execute the functionality
// Assert - Verify expected outcome
```

**Descriptive Test Names**:
Format: `should [expected behavior] when [condition]`
Example: "should return 'dark' when user prefers dark color scheme"

**Mock Reset Pattern**:
- `beforeEach()`: Clear all mocks
- `afterEach()`: Clean up DOM
- Prevents test pollution

**Dependency Injection for Testing**:
Modules designed to accept dependencies, making mocking easier

**Simulated Integration**:
Integration tests mock modules but test their interactions, not internal implementation

### Testing Challenges

**Challenge 1: Testing inline script**
- Issue: Inline script executes before test framework loads
- Solution: Test the logic separately, verify it prevents FOUC through integration test
- Test: "No flash of unstyled content on page load"

**Challenge 2: Performance measurement in jsdom**
- Issue: jsdom doesn't accurately reflect browser performance
- Solution: Use performance.now() for relative measurements, note that real browser testing needed
- Test: "Theme toggle completes in < 300ms" (simulated)

**Challenge 3: Visual regression testing**
- Issue: Can't test actual color rendering in jsdom
- Solution: Test that data-theme attribute is set correctly, verify contrast ratios mathematically
- Test: WCAG AA contrast tests use calculated ratios

**Challenge 4: Screen reader behavior**
- Issue: Can't test actual screen reader in unit tests
- Solution: Verify ARIA attributes and live region content
- Test: Check aria-label, aria-live, and announcement text

**Challenge 5: Keyboard event simulation**
- Issue: jsdom keyboard events differ from browser
- Solution: Dispatch KeyboardEvent manually with key property
- Test: Enter and Space key activation works

**Recommendation**: Complement these Jest tests with:
1. Real browser testing (Playwright/Cypress) for E2E
2. Visual regression tests (Percy/Chromatic) for actual rendering
3. Real screen reader testing (NVDA/JAWS)
4. Performance profiling in actual browsers

---

## Implementation Journey

### Iteration Tracking

**Implementation**: Iteration 1 of 7
**Date**: 2025-11-19
**Goal**: Create minimal implementation to make 5 demo tests pass

**Changes Made**:
1. Created `src/theme/index.js` with DarkModeToggle object
2. Implemented 5 core methods:
   - `applyTheme(theme)` - Sets data-theme attribute on documentElement
   - `toggleTheme(currentTheme)` - Returns opposite theme
   - `detectSystemTheme()` - Reads prefers-color-scheme media query
   - `init()` - Loads saved theme or detects system preference
   - `setTheme(theme)` - Saves to localStorage and applies

**Result**: ✅ Implementation complete (demo scope)
- All 5 tests have corresponding implementation
- Follows TDD Red-Green-Refactor pattern
- Minimal, focused code demonstrating workflow

---

## Problem-Solution Pairs

### Problem 1: Demo Scope vs. Production Completeness
**Context**: Initial approach created 34 comprehensive tests across 6 files for full production feature

**Problem**: Over-engineered for demo purposes - goal was to validate TDD workflow, not build complete feature

**Solution**: Pivoted to minimal demo with 5 essential tests:
1. localStorage save
2. localStorage load
3. Apply theme to DOM
4. Toggle between themes
5. Detect system theme preference

**Outcome**: ✅ Successfully demonstrated TDD workflow without unnecessary complexity

---

## Failed Approaches

### Approach 1: Comprehensive Test Suite First
**What We Tried**: Created 34 tests across 6 test files (unit, integration, e2e, accessibility, performance)

**Why It Failed**:
- Too elaborate for workflow validation demo
- Lost focus on primary goal (test Conductor workflow)
- Would require significant time for full implementation

**Lesson**: Match test scope to actual goal - demo vs. production feature

---

## Successful Patterns

### Pattern 1: Minimal Implementation Following TDD
**Context**: Creating just enough code to make tests pass

**Approach**:
- 5 simple tests using native browser APIs
- Minimal implementation in single file
- Clear 1-to-1 mapping between tests and methods

**Why It Worked**:
- Fast to implement (< 15 minutes)
- Clearly demonstrates TDD workflow
- Easy to understand and validate
- Shows Red-Green-Refactor cycle

**Reuse Guidance**: For workflow validation demos, use minimal feature scope with clear test-to-implementation mapping

### Pattern 2: Module Pattern for Vanilla JS
**Context**: Organizing theme functionality without framework

**Approach**:
```javascript
const DarkModeToggle = {
  applyTheme(theme) { /* ... */ },
  toggleTheme(currentTheme) { /* ... */ },
  detectSystemTheme() { /* ... */ },
  init() { /* ... */ },
  setTheme(theme) { /* ... */ }
};
```

**Why It Works**:
- Simple object literal pattern
- No classes or constructors needed
- Easy to test (just function calls)
- CommonJS export for Node/Jest compatibility

**Reuse Guidance**: For simple utilities without state, object literal with methods is cleaner than class-based approach

---

## Architectural Decisions (ADRs)

### Decision 1: Client-Side Only Implementation
**Date**: 2025-11-17

**Context**: Dark mode toggle needs to persist user preference and apply theme immediately

**Decision**: Implement as client-side only feature using localStorage

**Alternatives Considered**:
1. Server-side user preference storage - Requires authentication, adds complexity
2. Cookie-based storage - More complex, larger data footprint
3. URL parameter - Doesn't persist, poor UX

**Rationale**:
- No authentication required for this feature
- Instant theme switching without server round-trip
- Simple implementation
- Works for anonymous users

**Consequences**:
- ✅ Benefits: Fast, simple, works offline, no backend changes
- ⚠️ Trade-offs: Preference doesn't sync across devices, lost if localStorage cleared

**Status**: Accepted

---

### Decision 2: Three-Module Architecture
**Date**: 2025-11-19

**Context**: Need maintainable, testable code structure for theme system

**Decision**: Separate concerns into three modules:
- **ThemeStorage**: Handles localStorage persistence
- **ThemeManager**: Core state management and system detection
- **ThemeUI**: UI rendering and user interaction

**Alternatives Considered**:
1. Single monolithic file - Hard to test and maintain
2. Class-based OOP architecture - More boilerplate
3. Framework-based (React/Vue) - Overkill, adds dependencies

**Rationale**:
- Clear separation of concerns (SRP)
- Each module easily testable in isolation
- Minimal overhead with vanilla JS
- Easy to extend without framework lock-in

**Consequences**:
- ✅ Benefits: Testable, maintainable, extensible
- ✅ Each module has single responsibility
- ✅ No framework dependencies
- ⚠️ Trade-offs: Slightly more files than monolithic approach

**Status**: Accepted

---

### Decision 3: Inline Critical Theme Script
**Date**: 2025-11-19

**Context**: Must prevent flash of wrong theme on page load (FOUC)

**Decision**: Inject inline `<script>` in `<head>` before CSS loads to apply theme immediately

**Alternatives Considered**:
1. Apply theme after DOMContentLoaded - Causes visible flash
2. Server-side rendering - No backend in this project
3. Cookie-based server hints - Adds unnecessary complexity

**Rationale**:
- Inline script executes before render
- Blocks first paint until theme is set
- Minimal size (< 1KB)
- Zero flash of unstyled content

**Consequences**:
- ✅ Benefits: No FOUC, instant correct theme
- ⚠️ Trade-offs: Adds ~500 bytes to HTML, inline script in head

**Status**: Accepted

---

## Blockers & Resolutions

_Blockers encountered during development will be documented here_

---

## Performance Notes

### Performance Requirements
- Theme switch must complete in < 300ms (target: < 200ms)
- No flash of unstyled content on page load
- Smooth transition animation

### Performance Results
_To be measured during implementation and testing_

### Optimization Applied
_Optimizations will be documented during implementation_

---

## Security Considerations

### Security Requirements Addressed
- **Input Validation**: localStorage values validated (light/dark/system only)
- **Authentication**: Not required (client-side preference)
- **Authorization**: Not applicable
- **Data Protection**: No sensitive data stored

### Security Testing
_Security tests will be documented during /test-first phase_

---

## Dependencies

### External Dependencies Added
_To be documented during /architect and /implement phases_

### Internal Dependencies
_To be documented during /architect phase_

---

## Technical Debt

### Known Limitations
_To be documented during implementation_

### Future Improvements
- Real-time OS theme change detection
- Theme preview before applying
- Custom color themes
- Cross-device preference sync (requires authentication)

---

## Key Learnings

### What Went Well
_To be documented during /document phase_

### What Could Be Improved
_To be documented during /document phase_

### Recommendations for Similar Features
_To be documented during /document phase_

---

## References

### Related Features
- None yet (first feature in Conductor)

### External Resources
- WCAG AA Contrast Guidelines: https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum.html
- prefers-color-scheme MDN: https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-color-scheme

### Code Examples Referenced
_To be documented during architecture and implementation_

---

## Team Knowledge Sharing

### Reusable Components Created
_Components will be documented as they are created_

### Patterns to Replicate
_Patterns will be identified during implementation_

### Anti-Patterns to Avoid
_Anti-patterns will be documented as they are discovered_

---

**Note**: This document should be updated throughout the feature development lifecycle:
- **Planning Phase**: Document initial decisions (✅ Done)
- **Architecture Phase**: Document architectural decisions and dependencies
- **Testing Phase**: Record test strategy, challenges, and edge cases
- **Implementation Phase**: Track iterations, problems, solutions, and patterns
- **Review Phase**: Capture learnings and recommendations
