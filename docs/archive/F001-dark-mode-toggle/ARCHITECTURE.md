# Architecture: Dark Mode Toggle

**Feature ID**: F001
**Date**: 2025-11-19
**Architect**: Conductor Team

---

## Overview

This feature implements a client-side dark mode toggle using vanilla JavaScript, CSS custom properties, and localStorage. The architecture follows a simple module pattern with clear separation between theme state management (ThemeManager), UI rendering (ThemeUI), and persistence (ThemeStorage). The design prioritizes performance (< 300ms toggle), accessibility (WCAG AA), and maintainability.

**Key Architectural Choice**: CSS Custom Properties + Modular JavaScript
- Centralized theme definitions via CSS variables
- Minimal JavaScript for state management
- No framework dependencies
- Instant theme switching via single class toggle

---

## Design Decisions

### Decision 1: CSS Custom Properties (CSS Variables)
- **Context**: Need to apply theme colors consistently across all UI components with minimal performance impact
- **Decision**: Use CSS custom properties (variables) defined at `:root` level, toggled via `data-theme` attribute on `<html>`
- **Alternatives Considered**:
  1. Class-based theming (`.light-theme`, `.dark-theme`) - More verbose, harder to maintain
  2. CSS-in-JS - Adds dependency, increases bundle size
  3. Separate stylesheets per theme - Requires HTTP request, flash of unstyled content
- **Rationale**: CSS variables are native, performant, widely supported, and allow instant theme switching without re-rendering
- **Consequences**:
  - ✅ Instant theme switching via single attribute change
  - ✅ Easy to extend with additional themes
  - ✅ Works with CSS transitions
  - ⚠️ No IE11 support (acceptable based on modern browser requirement)

### Decision 2: LocalStorage for Persistence
- **Context**: Need to persist user theme preference across sessions without backend
- **Decision**: Store theme preference in localStorage as `theme` key with values: "light", "dark", "system"
- **Alternatives Considered**:
  1. Session storage - Lost when browser closes
  2. Cookies - More complex, larger footprint, sent with every request
  3. IndexedDB - Overkill for single value
  4. Backend user settings - Requires authentication, adds complexity
- **Rationale**: localStorage is simple, synchronous, and perfect for client-side preferences
- **Consequences**:
  - ✅ Simple implementation, no backend needed
  - ✅ Works for anonymous users
  - ⚠️ Preference doesn't sync across devices
  - ⚠️ Lost if user clears browser data

### Decision 3: Inline Critical Theme Script
- **Context**: Need to prevent flash of wrong theme on page load
- **Decision**: Inject inline `<script>` in `<head>` before any CSS to immediately apply saved theme
- **Alternatives Considered**:
  1. Apply theme after DOMContentLoaded - Causes flash
  2. Server-side rendering - No backend in this project
  3. Cookie-based server hints - Adds complexity
- **Rationale**: Inline script executes immediately, blocking render until theme is set
- **Consequences**:
  - ✅ No flash of unstyled content (FOUC)
  - ✅ Theme applied before first paint
  - ⚠️ Small inline script (< 1KB), acceptable performance trade-off

### Decision 4: System Theme Detection
- **Context**: Need to respect user's OS theme preference as default
- **Decision**: Use `window.matchMedia('(prefers-color-scheme: dark)')` to detect system preference
- **Alternatives Considered**:
  1. Always default to light - Poor UX for dark mode users
  2. Time-based auto-switching - Unreliable, assumes user location
- **Rationale**: Respects user OS settings, provides best default experience
- **Consequences**:
  - ✅ Better default UX
  - ✅ Follows platform conventions
  - ⚠️ Requires browser support (widely available)

### Decision 5: Three-Module Architecture
- **Context**: Need maintainable, testable code structure
- **Decision**: Separate concerns into ThemeStorage (persistence), ThemeManager (state), ThemeUI (rendering)
- **Alternatives Considered**:
  1. Single monolithic file - Hard to test, maintain
  2. Class-based architecture - More boilerplate
  3. Framework-based (React, Vue) - Overkill, adds dependencies
- **Rationale**: Clear separation of concerns, easy to test in isolation, minimal overhead
- **Consequences**:
  - ✅ Each module has single responsibility
  - ✅ Easy to unit test
  - ✅ Easy to extend
  - ✅ No framework lock-in

---

## System Components

### Component 1: ThemeStorage
- **Purpose**: Handle persistence of theme preference in localStorage
- **Location**: `src/theme/storage.js`
- **Responsibilities**:
  - Save theme preference to localStorage
  - Load theme preference from localStorage
  - Validate stored theme value
  - Handle localStorage unavailable scenarios (privacy mode)
- **Dependencies**: None (uses native localStorage API)
- **Interfaces**:
  ```javascript
  const ThemeStorage = {
    save(theme)      // Saves theme: 'light' | 'dark' | 'system'
    load()           // Returns saved theme or null
    isAvailable()    // Checks if localStorage is accessible
  }
  ```

### Component 2: ThemeManager
- **Purpose**: Core theme state management and system theme detection
- **Location**: `src/theme/manager.js`
- **Responsibilities**:
  - Initialize theme based on saved preference or system default
  - Apply theme by setting `data-theme` attribute on `<html>` element
  - Detect system theme preference via media query
  - Handle theme changes and notify listeners
  - Resolve "system" theme to actual "light" or "dark"
- **Dependencies**: ThemeStorage
- **Interfaces**:
  ```javascript
  const ThemeManager = {
    init()                     // Initialize theme system
    setTheme(theme)            // Set theme and persist
    getTheme()                 // Get stored preference
    getCurrentTheme()          // Get resolved theme (light|dark)
    detectSystemTheme()        // Detect OS preference
    onThemeChange(callback)    // Subscribe to theme changes
  }
  ```

### Component 3: ThemeUI
- **Purpose**: Handle UI rendering for theme toggle button
- **Location**: `src/theme/ui.js`
- **Responsibilities**:
  - Render theme toggle button in nav bar
  - Update button icon based on current theme (sun/moon)
  - Handle click events on toggle button
  - Update ARIA attributes for accessibility
  - Announce theme changes to screen readers
- **Dependencies**: ThemeManager
- **Interfaces**:
  ```javascript
  const ThemeUI = {
    init(containerSelector)    // Render toggle button
    updateButton()             // Update icon and ARIA
    toggle()                   // Handle toggle click
  }
  ```

### Component 4: Theme Styles
- **Purpose**: Define color palettes and CSS for theming
- **Location**: `src/theme/styles.css`
- **Responsibilities**:
  - Define CSS custom properties for light theme (default)
  - Define CSS custom properties for dark theme
  - Apply theme-specific colors based on `data-theme` attribute
  - Handle smooth transitions between themes
  - Respect `prefers-reduced-motion` for animations
- **Dependencies**: None
- **Interfaces**: CSS custom properties exposed globally
  ```css
  --color-background
  --color-surface
  --color-text-primary
  --color-text-secondary
  --color-accent
  --color-border
  ```

### Component 5: Inline Theme Loader
- **Purpose**: Prevent flash of wrong theme on page load
- **Location**: Inline `<script>` in `<head>` of `index.html`
- **Responsibilities**:
  - Immediately load saved theme from localStorage
  - Apply theme before first paint
  - Fall back to system theme if no saved preference
- **Dependencies**: None (standalone, duplicates minimal logic)
- **Interfaces**: None (self-executing)

---

## Data Flow

```
[Page Load]
     |
     v
[Inline Script in <head>]
     |
     ├──> Load from localStorage
     ├──> Detect system theme if needed
     └──> Apply data-theme to <html>
     |
     v
[CSS Variables Apply]
     |
     v
[DOMContentLoaded]
     |
     v
[ThemeManager.init()]
     |
     ├──> ThemeStorage.load()
     ├──> Validate and resolve theme
     └──> Confirm data-theme attribute
     |
     v
[ThemeUI.init('#nav-container')]
     |
     ├──> Render toggle button
     ├──> Set initial icon (sun/moon)
     └──> Attach event listeners
     |
     v
[Page Ready]

[User Clicks Toggle]
     |
     v
[ThemeUI.toggle()]
     |
     v
[Calculate new theme]
     |
     v
[ThemeManager.setTheme(newTheme)]
     |
     ├──> Set data-theme on <html>
     ├──> ThemeStorage.save(newTheme)
     ├──> Notify change listeners
     └──> Return new theme
     |
     v
[ThemeUI.updateButton()]
     |
     ├──> Update icon (sun ↔ moon)
     ├──> Update ARIA label
     └──> Announce to screen reader
     |
     v
[CSS Transition (< 300ms)]
```

---

## File Structure

```
conductor/
├── docs/                           # Documentation
│   └── features/F001-dark-mode-toggle/
├── src/
│   ├── theme/
│   │   ├── storage.js              # ThemeStorage module
│   │   ├── manager.js              # ThemeManager module
│   │   ├── ui.js                   # ThemeUI module
│   │   └── styles.css              # Theme CSS variables
│   ├── index.html                  # Main HTML with inline script
│   └── main.js                     # App initialization
└── tests/
    ├── theme.storage.test.js       # ThemeStorage unit tests
    ├── theme.manager.test.js       # ThemeManager unit tests
    ├── theme.ui.test.js            # ThemeUI unit tests
    ├── theme.integration.test.js   # Integration tests
    └── theme.e2e.test.js           # End-to-end tests
```

---

## Security Considerations

- **XSS Prevention**:
  - Validate localStorage values against whitelist: ["light", "dark", "system"]
  - Use `setAttribute()` instead of direct property manipulation
  - Never use `eval()` or `innerHTML` with localStorage values
- **Data Validation**:
  - Sanitize theme value before storing
  - Default to "light" if corrupted data detected
  - Try-catch around localStorage access
- **Privacy**:
  - Handle localStorage disabled gracefully (privacy mode)
  - No user tracking or analytics in this component
- **CSP Compliance**:
  - Inline script is deterministic and minimal
  - Can be replaced with nonce or hash if strict CSP required

---

## Performance Considerations

- **Theme Toggle**: Target < 50ms (requirement: < 300ms)
  - Single attribute change triggers CSS cascade
  - GPU-accelerated transitions (`background-color`, `color`)
  - No JavaScript-based style calculations
- **Page Load**: < 10ms overhead
  - Inline script executes before render
  - localStorage read is synchronous
  - No external HTTP requests
- **Memory**: < 50KB total
  - Three small modules (< 5KB each)
  - CSS variables cached by browser
- **Rendering**:
  - No layout shifts (only color changes)
  - Respects `prefers-reduced-motion`
  - Single reflow on theme change

---

## Testing Strategy

### Unit Tests (14 tests)
**ThemeStorage** (4 tests):
- [ ] `save()` stores theme to localStorage
- [ ] `load()` retrieves theme from localStorage
- [ ] `load()` returns null for corrupted data
- [ ] `isAvailable()` detects localStorage support

**ThemeManager** (6 tests):
- [ ] `detectSystemTheme()` returns 'dark' for dark preference
- [ ] `detectSystemTheme()` returns 'light' for light/no preference
- [ ] `setTheme()` applies data-theme to HTML element
- [ ] `setTheme()` calls ThemeStorage.save()
- [ ] `getCurrentTheme()` resolves 'system' to actual theme
- [ ] `onThemeChange()` notifies listeners

**ThemeUI** (4 tests):
- [ ] `init()` renders toggle button in container
- [ ] `updateButton()` shows sun icon for light theme
- [ ] `updateButton()` shows moon icon for dark theme
- [ ] `toggle()` cycles between light and dark

### Integration Tests (5 tests)
- [ ] Full toggle flow: click → ThemeManager → ThemeStorage → DOM
- [ ] Page init with saved preference loads correctly
- [ ] Page init without saved preference uses system theme
- [ ] Theme persists across simulated page reload
- [ ] Listeners receive theme change notifications

### E2E Tests (6 tests)
- [ ] User clicks toggle, sees visual theme change
- [ ] User refreshes page, theme persists
- [ ] User with dark OS preference sees dark theme initially
- [ ] User with light OS preference sees light theme initially
- [ ] Keyboard navigation (Tab, Enter) works on toggle
- [ ] Screen reader announces theme change

### Accessibility Tests (5 tests)
- [ ] Light mode passes WCAG AA contrast (automated)
- [ ] Dark mode passes WCAG AA contrast (automated)
- [ ] Toggle button has correct ARIA attributes
- [ ] Keyboard accessibility works (Tab, Enter, Space)
- [ ] Respects `prefers-reduced-motion` (no animation)

### Performance Tests (3 tests)
- [ ] Theme toggle completes in < 300ms
- [ ] No flash of unstyled content on page load
- [ ] No layout shift on theme change

**Total: 33 tests**

---

## Deployment Strategy

- **Feature Flags**: Not needed (low risk, client-side only)
- **Rollout Plan**: Full deployment (static HTML page update)
- **Monitoring**:
  - Track localStorage errors in console
  - Optional: Analytics for adoption rate (future)
- **Rollback Plan**:
  - Remove toggle button from nav
  - Remove inline script from HTML
  - Default to light theme
  - Zero data migration needed

---

## Accessibility Requirements

1. **WCAG AA Contrast** (4.5:1 minimum):
   - Light mode: #1a1a1a on #ffffff (21:1) ✓
   - Dark mode: #e0e0e0 on #1a1a1a (14.3:1) ✓
2. **Keyboard Navigation**:
   - Toggle button focusable
   - Enter/Space key activates
   - Tab order logical
3. **Screen Reader Support**:
   - ARIA label: "Toggle dark mode"
   - ARIA live region announces changes
   - Icon is decorative (aria-hidden)
4. **Motion Sensitivity**:
   - Respect `prefers-reduced-motion`
   - No animation if user prefers reduced motion

---

## Technical Debt

- **No real-time OS theme sync**: Detects system theme only on load. Future: Listen to `matchMedia` change events
- **No theme preview**: Theme applies immediately. Future: Preview modal before confirming
- **Single variant per mode**: Only light and dark. Future: High contrast, custom themes
- **No cross-device sync**: Requires backend. Future: User account integration

---

## Related Documentation

- [FEATURE.md](./FEATURE.md) - Requirements and acceptance criteria
- [TASKS.md](./TASKS.md) - Atomic task breakdown
- [CLAUDE.md](./CLAUDE.md) - Implementation knowledge base
- [STATUS.md](./STATUS.md) - Current development status
- [MDN: prefers-color-scheme](https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-color-scheme)
- [MDN: CSS Custom Properties](https://developer.mozilla.org/en-US/docs/Web/CSS/Using_CSS_custom_properties)
- [WCAG 2.1 Contrast Guidelines](https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum.html)

---

## Open Questions

- [x] Should we support IE11? **NO** (requirement states modern browsers)
- [x] Should theme sync to backend? **NO** (client-side only for v1, future enhancement)
- [x] Should we animate transitions? **YES** (with prefers-reduced-motion respect)
- [x] Where should toggle button be? **Top-right of nav bar** (per FEATURE.md)
- [x] Support "system" as permanent choice? **YES** (three options: light, dark, system)
