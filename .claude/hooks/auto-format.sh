#!/bin/bash
# Auto-formatting hook for code files
# Triggered by PostToolUse after Edit/Write operations

FILE_PATH="$1"
TOOL_NAME="$2"

# Only format if file exists
if [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

# Detect file type and run appropriate formatter
case "$FILE_PATH" in
  *.js|*.jsx|*.ts|*.tsx)
    # JavaScript/TypeScript - use Prettier if available
    if command -v prettier &> /dev/null; then
      prettier --write "$FILE_PATH" 2>/dev/null
      if [ $? -eq 0 ]; then
        echo "✓ Formatted with Prettier: $FILE_PATH"
      fi
    elif command -v eslint &> /dev/null; then
      eslint --fix "$FILE_PATH" 2>/dev/null
      if [ $? -eq 0 ]; then
        echo "✓ Formatted with ESLint: $FILE_PATH"
      fi
    fi
    ;;

  *.py)
    # Python - use Black if available
    if command -v black &> /dev/null; then
      black "$FILE_PATH" 2>/dev/null
      if [ $? -eq 0 ]; then
        echo "✓ Formatted with Black: $FILE_PATH"
      fi
    elif command -v autopep8 &> /dev/null; then
      autopep8 --in-place "$FILE_PATH" 2>/dev/null
      if [ $? -eq 0 ]; then
        echo "✓ Formatted with autopep8: $FILE_PATH"
      fi
    fi
    ;;

  *.go)
    # Go - use gofmt
    if command -v gofmt &> /dev/null; then
      gofmt -w "$FILE_PATH" 2>/dev/null
      if [ $? -eq 0 ]; then
        echo "✓ Formatted with gofmt: $FILE_PATH"
      fi
    fi
    ;;

  *.rs)
    # Rust - use rustfmt
    if command -v rustfmt &> /dev/null; then
      rustfmt "$FILE_PATH" 2>/dev/null
      if [ $? -eq 0 ]; then
        echo "✓ Formatted with rustfmt: $FILE_PATH"
      fi
    fi
    ;;

  *.java)
    # Java - use google-java-format if available
    if command -v google-java-format &> /dev/null; then
      google-java-format --replace "$FILE_PATH" 2>/dev/null
      if [ $? -eq 0 ]; then
        echo "✓ Formatted with google-java-format: $FILE_PATH"
      fi
    fi
    ;;

  *.md)
    # Markdown - use prettier if available
    if command -v prettier &> /dev/null; then
      prettier --write "$FILE_PATH" 2>/dev/null
      if [ $? -eq 0 ]; then
        echo "✓ Formatted with Prettier: $FILE_PATH"
      fi
    fi
    ;;

  *)
    # No formatter for this file type
    exit 0
    ;;
esac

exit 0
