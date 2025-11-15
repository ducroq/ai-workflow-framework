#!/bin/bash
# Suggest SESSION_STATE.md update after significant work
# Triggered by Stop event (when Claude finishes responding)

# Check if SESSION_STATE.md exists
if [ ! -f "docs/SESSION_STATE.md" ]; then
  exit 0
fi

# Get last modified time of SESSION_STATE.md
if [ -f "docs/SESSION_STATE.md" ]; then
  LAST_MODIFIED=$(stat -c %Y "docs/SESSION_STATE.md" 2>/dev/null || stat -f %m "docs/SESSION_STATE.md" 2>/dev/null)
  CURRENT_TIME=$(date +%s)
  TIME_DIFF=$((CURRENT_TIME - LAST_MODIFIED))

  # If SESSION_STATE hasn't been updated in > 1 hour (3600 seconds)
  if [ $TIME_DIFF -gt 3600 ]; then
    echo ""
    echo "📝 SESSION_STATE.md hasn't been updated in $(($TIME_DIFF / 3600)) hours."
    echo "   Consider updating with today's progress:"
    echo "   - Add accomplishments to 'Key Accomplishments'"
    echo "   - Update 'Current Status' section"
    echo "   - Refresh 'Next Steps'"
    echo ""
  fi
fi

exit 0
