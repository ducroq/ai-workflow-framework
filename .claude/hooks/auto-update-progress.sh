#!/bin/bash
# Hook: PostToolUse - Auto-update progress in CLAUDE.md and STATUS.md
# Triggers after key development milestones to maintain living documentation

# This hook is called with: tool_name, feature_id (if applicable)
TOOL_NAME="${1:-unknown}"
FEATURE_ID="${2:-}"

# Function to update STATUS.md last updated date
update_status_timestamp() {
  local status_file=$1
  local today=$(date +%Y-%m-%d)

  if [[ -f "$status_file" ]]; then
    # Update Last Updated field
    if grep -q "Last Updated" "$status_file"; then
      sed -i.bak "s/Last Updated.*$/Last Updated: $today/" "$status_file" 2>/dev/null || \
        sed -i "" "s/Last Updated.*$/Last Updated: $today/" "$status_file" 2>/dev/null
      rm -f "${status_file}.bak"
    fi
  fi
}

# Function to add activity entry to STATUS.md
add_status_activity() {
  local status_file=$1
  local stage=$2
  local action=$3
  local details=$4

  if [[ ! -f "$status_file" ]]; then
    return 0
  fi

  local timestamp=$(date +"%Y-%m-%d %H:%M")

  # Create activity entry
  local entry="### $timestamp
**Stage**: $stage
**Action**: $action
**By**: Automated (hook)
**Details**: $details
"

  # Insert after "## Recent Activity" line
  if grep -q "## Recent Activity" "$status_file"; then
    # Use different sed syntax for macOS vs Linux
    if [[ "$OSTYPE" == "darwin"* ]]; then
      sed -i "" "/## Recent Activity/a\\
\\
$entry" "$status_file"
    else
      sed -i "/## Recent Activity/a\\
\\
$entry" "$status_file"
    fi
  fi
}

# Function to update CLAUDE.md with implementation progress
update_claude_implementation() {
  local claude_file=$1
  local iteration_note=$2

  if [[ ! -f "$claude_file" ]]; then
    return 0
  fi

  # Add to Implementation Journey if it exists
  if grep -q "## Implementation Journey" "$claude_file"; then
    local timestamp=$(date +"%Y-%m-%d %H:%M")

    local entry="
**$timestamp**: $iteration_note
"

    # Append to Implementation Journey section
    # Find line number of next ## heading after "## Implementation Journey"
    local start_line=$(grep -n "## Implementation Journey" "$claude_file" | cut -d: -f1)
    if [[ -n "$start_line" ]]; then
      local next_section=$(tail -n +$((start_line + 1)) "$claude_file" | grep -n "^## " | head -1 | cut -d: -f1)

      if [[ -n "$next_section" ]]; then
        local insert_line=$((start_line + next_section - 1))
        sed -i.bak "${insert_line}i\\
$entry" "$claude_file" 2>/dev/null || sed -i "" "${insert_line}i\\
$entry" "$claude_file" 2>/dev/null
        rm -f "${claude_file}.bak"
      fi
    fi
  fi
}

# Detect feature from current directory or git branch
detect_feature() {
  # Try to find feature from current directory
  local current_dir=$(pwd)
  if [[ "$current_dir" =~ docs/features/([^/]+) ]]; then
    echo "${BASH_REMATCH[1]}"
    return 0
  fi

  # Try to find from git branch
  if git rev-parse --git-dir > /dev/null 2>&1; then
    local branch=$(git branch --show-current 2>/dev/null)
    if [[ "$branch" =~ (F[0-9]+) ]]; then
      # Find matching feature directory
      local feature_id="${BASH_REMATCH[1]}"
      local feature_dir=$(find docs/features -type d -name "${feature_id}*" | head -1)
      if [[ -n "$feature_dir" ]]; then
        basename "$feature_dir"
        return 0
      fi
    fi
  fi

  # Try to find most recently modified feature
  local recent_status=$(find docs/features -name "STATUS.md" -type f -exec ls -t {} + 2>/dev/null | head -1)
  if [[ -n "$recent_status" ]]; then
    basename "$(dirname "$recent_status")"
    return 0
  fi

  return 1
}

# Main logic based on tool/command
FEATURE_DIR=""
if [[ -n "$FEATURE_ID" ]]; then
  FEATURE_DIR=$(find docs/features -type d -name "${FEATURE_ID}*" | head -1)
else
  FEATURE_NAME=$(detect_feature)
  if [[ -n "$FEATURE_NAME" ]]; then
    FEATURE_DIR="docs/features/$FEATURE_NAME"
  fi
fi

if [[ -z "$FEATURE_DIR" ]] || [[ ! -d "$FEATURE_DIR" ]]; then
  # No feature context, skip
  exit 0
fi

STATUS_FILE="$FEATURE_DIR/STATUS.md"
CLAUDE_FILE="$FEATURE_DIR/CLAUDE.md"

# Update based on tool/command used
case "$TOOL_NAME" in
  "Write"|"Edit")
    # Code was written/edited
    SRC_MODIFIED=$(git diff --name-only | grep -E "src/|lib/" | wc -l)
    TEST_MODIFIED=$(git diff --name-only | grep -E "test|spec" | wc -l)

    if [[ $SRC_MODIFIED -gt 0 ]] && [[ -f "$STATUS_FILE" ]]; then
      update_status_timestamp "$STATUS_FILE"
      # Note: We don't auto-add activity for every edit to avoid spam
      # Only major milestones trigger activity logs
    fi

    if [[ $TEST_MODIFIED -gt 0 ]] && [[ -f "$CLAUDE_FILE" ]]; then
      update_claude_implementation "$CLAUDE_FILE" "Tests modified - iteration in progress"
    fi
    ;;

  "Bash")
    # Command executed - could be tests running
    if [[ "$2" =~ test|npm.*test|pytest|jest ]]; then
      if [[ -f "$CLAUDE_FILE" ]]; then
        update_claude_implementation "$CLAUDE_FILE" "Tests executed"
      fi
    fi
    ;;

  "architect"|"test-first"|"implement"|"qa-check"|"document")
    # Major workflow command executed
    if [[ -f "$STATUS_FILE" ]]; then
      update_status_timestamp "$STATUS_FILE"

      case "$TOOL_NAME" in
        "architect")
          add_status_activity "$STATUS_FILE" "Architecture" \
            "Architecture design completed" \
            "Ran /architect command - architecture documented"
          ;;
        "test-first")
          add_status_activity "$STATUS_FILE" "Testing" \
            "Test suite created" \
            "Ran /test-first command - comprehensive tests written"
          ;;
        "implement")
          add_status_activity "$STATUS_FILE" "Implementation" \
            "Implementation completed" \
            "Ran /implement command - all tests passing"
          ;;
        "qa-check")
          add_status_activity "$STATUS_FILE" "QA" \
            "Quality assurance review" \
            "Ran /qa-check command - code reviewed"
          ;;
        "document")
          add_status_activity "$STATUS_FILE" "Documentation" \
            "Documentation completed" \
            "Ran /document command - user docs created"
          ;;
      esac
    fi

    if [[ -f "$CLAUDE_FILE" ]]; then
      local note="Workflow stage: /$TOOL_NAME completed"
      update_claude_implementation "$CLAUDE_FILE" "$note"
    fi
    ;;
esac

exit 0
