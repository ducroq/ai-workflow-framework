#!/bin/bash
# Hook: PostToolUse(Edit|Write) - Update component documentation when code changes
# This hook analyzes code changes and automatically updates component documentation

FILE_PATH="$1"
TOOL_NAME="$2"

# Only process source code files (not docs, configs, etc.)
if [[ ! "$FILE_PATH" =~ \.(js|ts|jsx|tsx|py|go|java|rs|rb|php)$ ]]; then
  exit 0
fi

# Skip if file is in test directory
if [[ "$FILE_PATH" =~ /test/|/tests/|/__tests__/|\.test\.|\.spec\. ]]; then
  exit 0
fi

# Check if docs/components/ directory exists
if [[ ! -d "docs/components" ]]; then
  # Brief indicator that hook ran but no action needed
  FILENAME=$(basename "$FILE_PATH")
  echo "[docs] $FILENAME (no docs/components/ dir)"
  exit 0
fi

# Extract component name from file path
COMPONENT_NAME=$(basename "$FILE_PATH" | sed 's/\.[^.]*$//')
COMPONENT_DOC="docs/components/${COMPONENT_NAME}.md"

# Brief status output
echo "[docs] $COMPONENT_NAME"

# TODO: Invoke auto-docs-maintainer agent to:
# 1. Read the changed file
# 2. Extract public interface
# 3. Update or create component documentation
# 4. Update "Recent Changes" section

exit 0
