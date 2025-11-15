#!/bin/bash
# Hook: Stop - Update CURRENT_TASK.md when session ends/pauses
# This hook updates task progress based on work completed

# Check if docs/CURRENT_TASK.md exists
if [[ ! -f "docs/CURRENT_TASK.md" ]]; then
  exit 0  # Auto-docs not initialized yet
fi

# Invoke auto-docs-maintainer to handle the update
echo "📝 Updating CURRENT_TASK.md with progress..."

# TODO: Invoke auto-docs-maintainer agent to:
# 1. Review recent conversation for work completed
# 2. Update progress checklist
# 3. Add notes/learnings if any
# 4. Update PROJECT_OVERVIEW if milestone reached

exit 0
