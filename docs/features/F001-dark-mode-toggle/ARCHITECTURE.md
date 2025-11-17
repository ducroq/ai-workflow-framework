# Architecture: Dark Mode Toggle

**Feature ID**: F001
**Date**: 2025-11-17
**Architect**: System Architect Persona

---

## Overview

Client-side theme management system using CSS custom properties (variables) and localStorage for persistence. The architecture follows a reactive pattern where theme changes propagate through CSS variable updates, ensuring immediate visual feedback without page reloads.

**Key Architectural Choice**: CSS Custom Properties + Class-based Theming
- Centralized theme definitions
- No JavaScript required for actual styling
- Smooth transitions via CSS
- Easy to extend with additional themes

---

## Design Decisions

### Decision 1: CSS Custom Properties vs. Separate Stylesheets
- **Context**: Need efficient way to switch between themes without performance hit
- **Decision**: Use CSS custom properties (CSS variables) with a class toggle on `<html>` element
- **Alternatives Considered**:
  - Separate CSS files loaded dynamically (slow, flash of unstyled content)
  - Inline styles via JavaScript (poor maintainability, no CSS transitions)
  - SASS variables with build-time theming (requires rebuild for theme changes)
- **Rationale**: CSS custom properties provide instant switching, work with CSS transitions, and have excellent browser support (IE11+)
- **Consequences**:
  - ✅ Fast theme switching
  - ✅ Smooth transitions
  - ✅ Easy maintenance
  - ⚠️ Must define all theme colors as CSS variables

### Decision 2: localStorage for Persistence
- **Context**: Theme preference must persist across sessions
- **Decision**: Use browser localStorage to store theme preference
- **Alternatives Considered**:
  - Cookies (unnecessary overhead, sent with every request)
  - SessionStorage (doesn't persist across browser sessions)
  - IndexedDB (overkill for simple key-value storage)
- **Rationale**: localStorage is perfect for client-side preferences, simple API, persistent across sessions
- **Consequences**:
  - ✅ Simple implementation
  - ✅ No server dependency
  - ⚠️ Doesn't sync across devices (could add cloud sync later)
  - ⚠️ User can disable localStorage (graceful degradation needed)

### Decision 3: System Theme Detection as Default
- **Context**: Users expect apps to respect their OS theme preference
- **Decision**: Use `prefers-color-scheme` media query to detect system preference on first visit
- **Alternatives Considered**:
  - Default to light theme always (poor UX for dark mode users)
  - Ask user on first visit (extra friction)
- **Rationale**: Respecting system preference is modern UX best practice
- **Consequences**:
  - ✅ Better first-time user experience
  - ✅ No setup required
  - ⚠️ Requires media query support (degrades to light on old browsers)

### Decision 4: Inline Critical Theme Script
- **Context**: Must avoid flash of wrong theme on page load
- **Decision**: Inline small (<1KB) script in `<head>` that applies theme before render
- **Alternatives Considered**:
  - External script (causes flash while loading)
  - Server-side rendering with theme (requires backend changes)
- **Rationale**: Inline script executes immediately, preventing FOUC (Flash of Unstyled Content)
- **Consequences**:
  - ✅ Zero flash of wrong theme
  - ✅ Works on static sites
  - ⚠️ Slightly larger HTML size (~500 bytes)

---

## System Components

### Component 1: ThemeManager (JavaScript)
- **Purpose**: Manages theme state and localStorage persistence
- **Location**: `src/theme/ThemeManager.js` (or inline in HTML)
- **Responsibilities**:
  - Detect system theme preference
  - Load saved theme from localStorage
  - Apply theme by toggling class on `<html>`
  - Save theme changes to localStorage
  - Provide API for theme toggling
- **Dependencies**: None (vanilla JS)
- **Interfaces**:
  ```javascript
  class ThemeManager {
    getCurrentTheme()     // Returns 'light' | 'dark'
    setTheme(theme)       // Sets and persists theme
    toggleTheme()         // Toggles between themes
    getSystemTheme()      // Detects system preference
  }
  ```

### Component 2: Theme Styles (CSS)
- **Purpose**: Define color palettes for both themes
- **Location**: `src/theme/themes.css`
- **Responsibilities**:
  - Define CSS custom properties for light theme (default)
  - Define CSS custom properties for dark theme
  - Define transition properties for smooth switching
- **Dependencies**: None
- **Interfaces**:
  ```css
  /* CSS Custom Properties */
  --color-background
  --color-surface
  --color-text-primary
  --color-text-secondary
  --color-accent
  --color-border
  ```

### Component 3: ThemeToggle (UI Component)
- **Purpose**: Interactive button to switch themes
- **Location**: `src/components/ThemeToggle.js` (or HTML)
- **Responsibilities**:
  - Render toggle button with icon
  - Call ThemeManager.toggleTheme() on click
  - Update icon based on current theme
  - Announce theme change to screen readers
- **Dependencies**: ThemeManager
- **Interfaces**:
  - Event: `click` → toggles theme
  - ARIA: `aria-label`, `aria-pressed` for accessibility

---

## Data Flow

```
[Page Load]
     |
     v
[ThemeManager.init()]
     |
     ├──> Check localStorage
     |    └──> Theme found? Use it
     |
     └──> No theme found?
          └──> Detect system preference (prefers-color-scheme)
               └──> Apply detected theme
     |
     v
[Apply theme class to <html>]
     |
     v
[CSS variables update]
     |
     v
[Page renders with correct theme]

[User Clicks Toggle]
     |
     v
[ThemeToggle onClick]
     |
     v
[ThemeManager.toggleTheme()]
     |
     ├──> Calculate new theme
     ├──> Apply class to <html>
     ├──> Save to localStorage
     └──> Update toggle button UI
     |
     v
[CSS transition to new theme]
```

---

## Implementation Plan

### File Structure
```
src/
├── theme/
│   ├── ThemeManager.js      # Theme state management
│   ├── themes.css            # Theme definitions
│   └── inline-theme.js       # Minimal inline script for <head>
├── components/
│   └── ThemeToggle.js        # Toggle button component
└── index.html                # Entry point
```

### CSS Variables Structure

```css
/* Light Theme (Default) */
:root {
  --color-background: #ffffff;
  --color-surface: #f5f5f5;
  --color-text-primary: #1a1a1a;
  --color-text-secondary: #666666;
  --color-accent: #0066cc;
  --color-border: #e0e0e0;

  --transition-theme: all 0.2s ease-in-out;
}

/* Dark Theme */
:root.dark-theme {
  --color-background: #1a1a1a;
  --color-surface: #2d2d2d;
  --color-text-primary: #e0e0e0;
  --color-text-secondary: #a0a0a0;
  --color-accent: #4a9eff;
  --color-border: #404040;
}

/* Apply transitions to themeable elements */
body, .card, .button {
  transition: var(--transition-theme);
}
```

### Inline Script (Critical Path)

```html
<head>
  <script>
    // Inline theme loader (executes before render)
    (function() {
      const savedTheme = localStorage.getItem('theme');
      const systemTheme = window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
      const theme = savedTheme || systemTheme;

      if (theme === 'dark') {
        document.documentElement.classList.add('dark-theme');
      }
    })();
  </script>
</head>
```

---

## Security Considerations

- **XSS Prevention**: Theme value sanitized before storage (only 'light' or 'dark' allowed)
- **localStorage Access**: Wrapped in try-catch for privacy mode browsers
- **No User Input**: Theme toggle is controlled input, no arbitrary user data
- **CSP Compliance**: Inline script is deterministic, can be replaced with nonce if needed

---

## Performance Considerations

- **Initial Load**: Inline script adds ~500 bytes to HTML (acceptable)
- **Theme Switch**: CSS transitions use GPU-accelerated properties (opacity, transform)
- **Reflow Prevention**: Only color changes, no layout shifts
- **Expected Load**: Negligible impact, < 5ms for theme switch

---

## Testing Strategy

### Unit Tests
- [ ] ThemeManager.getCurrentTheme() returns correct value
- [ ] ThemeManager.setTheme() updates class and localStorage
- [ ] ThemeManager.toggleTheme() switches between themes
- [ ] ThemeManager.getSystemTheme() detects prefers-color-scheme

### Integration Tests
- [ ] Page loads with saved theme from localStorage
- [ ] Page loads with system theme if no saved preference
- [ ] Toggle button changes theme
- [ ] Theme persists after page reload
- [ ] localStorage disabled fallback works

### E2E Tests
- [ ] User can toggle theme and see visual change
- [ ] Theme persists across page navigation
- [ ] No flash of wrong theme on page load
- [ ] Keyboard navigation works for toggle button
- [ ] Screen reader announces theme changes

### Accessibility Tests
- [ ] WCAG AA contrast ratios in both themes
- [ ] Toggle button has proper ARIA labels
- [ ] Keyboard accessible (Tab, Enter, Space)
- [ ] Respects prefers-reduced-motion

---

## Deployment Strategy

- **Feature Flags**: Not needed (client-side only, no backend)
- **Rollout Plan**: Deploy as opt-in initially, collect feedback, make default
- **Monitoring**: Track theme adoption via analytics (if available)
- **Rollback Plan**: Remove toggle button, default to light theme

---

## Technical Debt

- Current design doesn't sync across devices (could add backend later)
- No support for custom user themes (future enhancement)
- Could optimize by preloading theme assets

---

## Related Documentation

- [FEATURE.md](./FEATURE.md) - Feature requirements
- [WCAG 2.1 Contrast Guidelines](https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum.html)
- [CSS Custom Properties MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/--*)

---

## Open Questions

- [x] Should we support "auto" mode that follows system changes in real-time?
  - **Decision**: No for v1, add in v2 if requested
- [x] Should theme preference sync across devices?
  - **Decision**: No for v1 (client-side only), can add backend sync later
