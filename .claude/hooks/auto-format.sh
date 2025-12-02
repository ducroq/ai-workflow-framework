#!/bin/bash
# Auto-formatting hook for code files
# Triggered by PostToolUse after Edit/Write operations

FILE_PATH="$1"
TOOL_NAME="$2"

# Only format if file exists
if [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

# Show brief status
FILENAME=$(basename "$FILE_PATH")

# Detect file type and run appropriate formatter
case "$FILE_PATH" in
  *.js|*.jsx|*.ts|*.tsx)
    # JavaScript/TypeScript - use Prettier if available
    if command -v prettier &> /dev/null; then
      prettier --write "$FILE_PATH" 2>/dev/null
      if [ $? -eq 0 ]; then
        echo "[format] $FILENAME (prettier)"
      fi
    elif command -v eslint &> /dev/null; then
      eslint --fix "$FILE_PATH" 2>/dev/null
      if [ $? -eq 0 ]; then
        echo "[format] $FILENAME (eslint)"
      fi
    else
      echo "[hook] $FILENAME (no JS formatter)"
    fi
    ;;

  *.py)
    # Python - use Black if available
    if command -v black &> /dev/null; then
      black "$FILE_PATH" 2>/dev/null
      if [ $? -eq 0 ]; then
        echo "[format] $FILENAME (black)"
      fi
    elif command -v autopep8 &> /dev/null; then
      autopep8 --in-place "$FILE_PATH" 2>/dev/null
      if [ $? -eq 0 ]; then
        echo "[format] $FILENAME (autopep8)"
      fi
    else
      echo "[hook] $FILENAME (no Python formatter)"
    fi
    ;;

  *.go)
    # Go - use gofmt
    if command -v gofmt &> /dev/null; then
      gofmt -w "$FILE_PATH" 2>/dev/null
      if [ $? -eq 0 ]; then
        echo "[format] $FILENAME (gofmt)"
      fi
    else
      echo "[hook] $FILENAME (no Go formatter)"
    fi
    ;;

  *.rs)
    # Rust - use rustfmt
    if command -v rustfmt &> /dev/null; then
      rustfmt "$FILE_PATH" 2>/dev/null
      if [ $? -eq 0 ]; then
        echo "[format] $FILENAME (rustfmt)"
      fi
    else
      echo "[hook] $FILENAME (no Rust formatter)"
    fi
    ;;

  *.java)
    # Java - use google-java-format if available
    if command -v google-java-format &> /dev/null; then
      google-java-format --replace "$FILE_PATH" 2>/dev/null
      if [ $? -eq 0 ]; then
        echo "[format] $FILENAME (google-java-format)"
      fi
    else
      echo "[hook] $FILENAME (no Java formatter)"
    fi
    ;;

  *.md)
    # Markdown - use prettier if available
    if command -v prettier &> /dev/null; then
      prettier --write "$FILE_PATH" 2>/dev/null
      if [ $? -eq 0 ]; then
        echo "[format] $FILENAME (prettier)"
      fi
    else
      echo "[hook] $FILENAME (markdown)"
    fi
    ;;

  *.json|*.yaml|*.yml)
    # Config files - brief acknowledgment
    echo "[hook] $FILENAME (config)"
    ;;

  *)
    # No formatter for this file type - silent
    ;;
esac

exit 0
