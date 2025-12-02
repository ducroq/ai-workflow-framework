# Tasks: Dark Mode Toggle

**Feature ID**: F001
**Last Updated**: 2025-11-17

---

## Task Breakdown

### Phase 1: Setup & Foundation (Estimated: 1-2 hours)

#### T001: Create File Structure
- **Status**: 🎯 Todo
- **Assignee**: Developer
- **Estimated**: 15 min
- **Dependencies**: None
- **Description**: Create directory structure and empty files for theme system
- **Acceptance Criteria**:
  - [ ] Created `src/theme/` directory
  - [ ] Created `src/theme/ThemeManager.js`
  - [ ] Created `src/theme/themes.css`
  - [ ] Created `src/theme/inline-theme.js`
  - [ ] Created `src/components/ThemeToggle.js`
- **Notes**: Simple setup task, no logic yet

#### T002: Define CSS Custom Properties
- **Status**: 🎯 Todo
- **Assignee**: Developer
- **Estimated**: 30 min
- **Dependencies**: T001
- **Description**: Define all CSS variables for both light and dark themes
- **Acceptance Criteria**:
  - [ ] Light theme variables defined in `:root`
  - [ ] Dark theme variables defined in `:root.dark-theme`
  - [ ] All 6 color variables defined (background, surface, text-primary, text-secondary, accent, border)
  - [ ] Transition variable defined
  - [ ] WCAG AA contrast ratios verified for both themes
- **Notes**: Use color contrast checker tool

### Phase 2: Core Implementation (Estimated: 2-3 hours)

#### T003: Implement ThemeManager Class
- **Status**: 🎯 Todo
- **Assignee**: Developer
- **Estimated**: 45 min
- **Dependencies**: T001
- **Description**: Create ThemeManager with all core methods
- **Acceptance Criteria**:
  - [ ] Class ThemeManager defined
  - [ ] Method: getCurrentTheme() implemented
  - [ ] Method: setTheme(theme) implemented
  - [ ] Method: toggleTheme() implemented
  - [ ] Method: getSystemTheme() implemented
  - [ ] localStorage integration working
  - [ ] Try-catch for localStorage errors
- **Notes**: Keep it vanilla JS, no framework dependencies

#### T004: Create Inline Theme Script
- **Status**: 🎯 Todo
- **Assignee**: Developer
- **Estimated**: 20 min
- **Dependencies**: T003
- **Description**: Create minimal inline script to prevent flash of wrong theme
- **Acceptance Criteria**:
  - [ ] Script checks localStorage for saved theme
  - [ ] Script detects system preference if no saved theme
  - [ ] Script applies dark-theme class if needed
  - [ ] Script is < 1KB minified
  - [ ] No dependencies on external code
- **Notes**: This must be completely standalone

#### T005: Implement ThemeToggle Component
- **Status**: 🎯 Todo
- **Assignee**: Developer
- **Estimated**: 45 min
- **Dependencies**: T003
- **Description**: Create toggle button UI component
- **Acceptance Criteria**:
  - [ ] Button renders with sun/moon icon
  - [ ] onClick calls ThemeManager.toggleTheme()
  - [ ] Icon updates based on current theme
  - [ ] Button has proper ARIA attributes
  - [ ] Smooth icon rotation animation
  - [ ] Tooltip shows on hover
- **Notes**: Can be HTML + vanilla JS or framework component

#### T006: Apply Theme Transitions
- **Status**: 🎯 Todo
- **Assignee**: Developer
- **Estimated**: 30 min
- **Dependencies**: T002, T003
- **Description**: Add CSS transitions to themeable elements
- **Acceptance Criteria**:
  - [ ] Transitions applied to body, cards, buttons
  - [ ] Transitions use GPU-accelerated properties
  - [ ] Transition duration < 300ms
  - [ ] No layout shifts during transition
  - [ ] Respects prefers-reduced-motion
- **Notes**: Test performance on slower devices

### Phase 3: Testing (Estimated: 3-4 hours)

#### T007: Write Unit Tests for ThemeManager
- **Status**: 🎯 Todo
- **Assignee**: Developer
- **Estimated**: 1 hour
- **Dependencies**: T003
- **Description**: Comprehensive unit tests for all ThemeManager methods
- **Acceptance Criteria**:
  - [ ] Test getCurrentTheme() returns correct value
  - [ ] Test setTheme() updates DOM and localStorage
  - [ ] Test toggleTheme() switches between themes
  - [ ] Test getSystemTheme() detects media query
  - [ ] Test localStorage error handling
  - [ ] 100% code coverage for ThemeManager
- **Notes**: Mock localStorage for tests

#### T008: Write Integration Tests
- **Status**: 🎯 Todo
- **Assignee**: Developer
- **Estimated**: 1 hour
- **Dependencies**: T003, T004, T005
- **Description**: Test theme system working end-to-end
- **Acceptance Criteria**:
  - [ ] Test page loads with saved theme
  - [ ] Test page loads with system theme (no saved preference)
  - [ ] Test toggle button changes theme
  - [ ] Test theme persists after reload
  - [ ] Test localStorage disabled fallback
- **Notes**: Use actual browser environment

#### T009: Write E2E Tests
- **Status**: 🎯 Todo
- **Assignee**: Developer
- **Estimated**: 45 min
- **Dependencies**: T005
- **Description**: Test complete user workflows
- **Acceptance Criteria**:
  - [ ] Test user can toggle and see visual change
  - [ ] Test theme persists across navigation
  - [ ] Test no flash on page load
  - [ ] Test keyboard navigation
  - [ ] Test screen reader announcements
- **Notes**: Use Playwright or Cypress

#### T010: Accessibility Audit
- **Status**: 🎯 Todo
- **Assignee**: Developer
- **Estimated**: 1 hour
- **Dependencies**: T002, T005, T006
- **Description**: Verify WCAG AA compliance
- **Acceptance Criteria**:
  - [ ] All text meets 4.5:1 contrast in light theme
  - [ ] All text meets 4.5:1 contrast in dark theme
  - [ ] Toggle button keyboard accessible
  - [ ] Toggle button has proper ARIA labels
  - [ ] Screen reader announces theme changes
  - [ ] Respects prefers-reduced-motion
- **Notes**: Use axe DevTools or similar

### Phase 4: Integration & Documentation (Estimated: 2-3 hours)

#### T011: Integrate with Existing Codebase
- **Status**: 🎯 Todo
- **Assignee**: Developer
- **Estimated**: 1 hour
- **Dependencies**: T002, T003, T004, T005
- **Description**: Add theme system to main application
- **Acceptance Criteria**:
  - [ ] Inline script added to <head> of index.html
  - [ ] themes.css imported
  - [ ] ThemeManager initialized on page load
  - [ ] ThemeToggle component added to navigation
  - [ ] All existing components use CSS variables
- **Notes**: May need to update existing styles

#### T012: Create Code Documentation
- **Status**: 🎯 Todo
- **Assignee**: Developer
- **Estimated**: 45 min
- **Dependencies**: T003, T005
- **Description**: Add JSDoc comments and inline documentation
- **Acceptance Criteria**:
  - [ ] JSDoc comments for all public methods
  - [ ] Inline comments for complex logic
  - [ ] README in src/theme/ directory
  - [ ] Usage examples in documentation
- **Notes**: Keep it concise but thorough

#### T013: Performance Testing
- **Status**: 🎯 Todo
- **Assignee**: Developer
- **Estimated**: 30 min
- **Dependencies**: T006, T011
- **Description**: Verify performance requirements met
- **Acceptance Criteria**:
  - [ ] Theme switch completes in < 300ms
  - [ ] No layout reflows during switch
  - [ ] Lighthouse performance score unchanged
  - [ ] Works smoothly on mobile devices
- **Notes**: Test on real devices, not just DevTools

---

## Task Dependencies

```
T001 (File Structure)
  ├──> T002 (CSS Variables)
  │     └──> T006 (Transitions) ──┐
  │                                 │
  └──> T003 (ThemeManager) ───────┼──> T011 (Integration)
        ├──> T004 (Inline Script) ─┤
        ├──> T005 (Toggle Button) ─┘
        ├──> T007 (Unit Tests)
        └──> T008 (Integration Tests)
              └──> T009 (E2E Tests)

T002 + T005 ──> T010 (A11y Audit)
T003 + T005 ──> T012 (Documentation)
T006 + T011 ──> T013 (Performance)
```

---

## Progress Summary

**Total Tasks**: 13
**Completed**: 0 (0%)
**In Progress**: 0
**Blocked**: 0
**Todo**: 13 (100%)

**Estimated Total Time**: 8-12 hours

---

## Completion Checklist

### Phase 1: Setup & Foundation ✅ = 0/2
- [ ] T001: File structure created
- [ ] T002: CSS variables defined

### Phase 2: Core Implementation ✅ = 0/4
- [ ] T003: ThemeManager implemented
- [ ] T004: Inline script created
- [ ] T005: Toggle button created
- [ ] T006: Transitions applied

### Phase 3: Testing ✅ = 0/4
- [ ] T007: Unit tests written
- [ ] T008: Integration tests written
- [ ] T009: E2E tests written
- [ ] T010: Accessibility verified

### Phase 4: Integration & Documentation ✅ = 0/3
- [ ] T011: Integrated with codebase
- [ ] T012: Documentation complete
- [ ] T013: Performance verified

---

## Blockers

None currently

---

## Notes

- Tasks are designed to be atomic (< 1 hour each)
- Dependencies clearly identified for parallel work
- Testing integrated throughout, not saved for end
- Total estimate: 8-12 hours for full implementation
- Can be completed in 2-3 days with focused work
