#!/bin/bash
# memory-layers-index.sh — Index a memory entry into FTS5 database
# Usage: memory-layers-index.sh <layer> <title> <content> <file_path> <date>
# Example: memory-layers-index.sh L2 "决策教训" "在压力下做了X决策..." "layers/L2-experiences/xxx.md" "2026-04-10"

set -e

LAYER="$1"
TITLE="$2"
CONTENT="$3"
FILE_PATH="$4"
DATE="$5"

# Resolve vault path from config or derive from file path
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
CONFIG="$SKILL_DIR/.config.json"

# Get vault path from config, or derive from file path
if [ -f "$CONFIG" ]; then
    VAULT=$(jq -r '.vault_path // empty' "$CONFIG" 2>/dev/null)
fi

if [ -z "$VAULT" ] || [ "$VAULT" = "null" ]; then
    # Try to derive from the file path if it's an absolute path
    if [[ "$FILE_PATH" == /* ]]; then
        VAULT="$(dirname "$FILE_PATH")/../.."
    else
        echo "Error: vault path not configured. Run memory-layers setup first." >&2
        exit 1
    fi
fi

# Ensure vault path is absolute
VAULT="$(cd "$VAULT" 2>/dev/null && pwd)"
DB_DIR="$VAULT/search"
DB="$DB_DIR/memory-search.db"

# Create search directory if needed
mkdir -p "$DB_DIR"

# Initialize FTS5 table if not exists
sqlite3 "$DB" "CREATE TABLE IF NOT EXISTS memories (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    layer TEXT NOT NULL,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    file_path TEXT NOT NULL,
    date TEXT NOT NULL,
    layer_rank INTEGER DEFAULT 0
);

CREATE VIRTUAL TABLE IF NOT EXISTS memories_fts USING fts5(
    title,
    content,
    content='memories',
    content_rowid='id'
);

CREATE TRIGGER IF NOT EXISTS memories_ai AFTER INSERT ON memories BEGIN
    INSERT INTO memories_fts(rowid, title, content) VALUES (new.id, new.title, new.content);
END;

CREATE TRIGGER IF NOT EXISTS memories_ad AFTER DELETE ON memories BEGIN
    INSERT INTO memories_fts(memories_fts, rowid, title, content) VALUES('delete', old.id, old.title, old.content);
END;

CREATE TRIGGER IF NOT EXISTS memories_au AFTER UPDATE ON memories BEGIN
    INSERT INTO memories_fts(memories_fts, rowid, title, content) VALUES('delete', old.id, old.title, old.content);
    INSERT INTO memories_fts(rowid, title, content) VALUES (new.id, new.title, new.content);
END;" 2>/dev/null || true

# Insert the memory record
LAYER_RANK=0
case "$LAYER" in
    L1) LAYER_RANK=1 ;;
    L2) LAYER_RANK=2 ;;
    L3) LAYER_RANK=3 ;;
    L4) LAYER_RANK=4 ;;
    L5) LAYER_RANK=5 ;;
esac

sqlite3 "$DB" "INSERT INTO memories (layer, title, content, file_path, date, layer_rank) VALUES (
    '$LAYER',
    '$(echo "$TITLE" | sed "s/'/''/g")',
    '$(echo "$CONTENT" | sed "s/'/''/g")',
    '$(echo "$FILE_PATH" | sed "s/'/''/g")',
    '$DATE',
    $LAYER_RANK
);"

echo "Indexed: [$LAYER] $TITLE"
