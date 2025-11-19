/**
 * Dark Mode Toggle - Minimal Implementation (Demo)
 * Makes the 5 tests pass
 */

const DarkModeToggle = {
  // Test 1 & 2: localStorage operations work natively
  // No implementation needed - tests use native localStorage API

  // Test 3: Apply theme to DOM
  applyTheme(theme) {
    document.documentElement.setAttribute('data-theme', theme);
  },

  // Test 4: Toggle logic
  toggleTheme(currentTheme) {
    return currentTheme === 'light' ? 'dark' : 'light';
  },

  // Test 5: Detect system theme preference
  detectSystemTheme() {
    const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
    return prefersDark ? 'dark' : 'light';
  },

  // Complete workflow
  init() {
    // Load saved theme from localStorage
    const savedTheme = localStorage.getItem('theme');

    // If no saved theme, detect system preference
    const theme = savedTheme || this.detectSystemTheme();

    // Apply theme to DOM
    this.applyTheme(theme);
  },

  // Save and apply theme
  setTheme(theme) {
    localStorage.setItem('theme', theme);
    this.applyTheme(theme);
  }
};

// Export for use
if (typeof module !== 'undefined' && module.exports) {
  module.exports = DarkModeToggle;
}
