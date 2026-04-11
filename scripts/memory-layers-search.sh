#!/bin/bash
# memory-layers-search.sh — Search through indexed memories using FTS5
# Usage: memory-layers-search.sh <query> [limit] [layer_filter]
# Example: memory-layers-search.sh "压力 决策"
# Example: memory-layers-search.sh "沟通" 10 L2

QUERY="$1"
LIMIT="${2:-10}"
LAYER_FILTER="$3"

# Resolve vault path from config
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
CONFIG="$SKILL_DIR/.config.json"

if [ -f "$CONFIG" ]; then
    VAULT=$(jq -r '.vault_path // empty' "$CONFIG" 2>/dev/null)
fi

if [ -z "$VAULT" ] || [ "$VAULT" = "null" ]; then
    echo "Error: vault path not configured. Run memory-layers setup first." >&2
    exit 1
fi

VAULT="$(cd "$VAULT" 2>/dev/null && pwd)"
DB="$VAULT/search/memory-search.db"

if [ ! -f "$DB" ]; then
    echo "No search database found. Index some memories first." >&2
    exit 1
fi

if [ -z "$QUERY" ]; then
    echo "Usage: memory-layers-search.sh <query> [limit] [layer_filter]" >&2
    exit 1
fi

# Escape single quotes in query for SQLite
ESCAPED_QUERY="$(echo "$QUERY" | sed "s/'/''/g")"

# Build SQL query
if [ -n "$LAYER_FILTER" ]; then
    SQL="SELECT layer, title, date, file_path,
                highlight(memories_fts, 1, '**', '**') as snippet
         FROM memories_fts
         JOIN memories ON memories_fts.rowid = memories.id
         WHERE memories_fts MATCH '$ESCAPED_QUERY'
           AND layer = '$LAYER_FILTER'
         ORDER BY layer_rank ASC, rank
         LIMIT $LIMIT;"
else
    SQL="SELECT layer, title, date, file_path,
                highlight(memories_fts, 1, '**', '**') as snippet
         FROM memories_fts
         JOIN memories ON memories_fts.rowid = memories.id
         WHERE memories_fts MATCH '$ESCAPED_QUERY'
         ORDER BY layer_rank ASC, rank
         LIMIT $LIMIT;"
fi

echo "=== Memory Search: \"$QUERY\" ==="
if [ -n "$LAYER_FILTER" ]; then
    echo "Filter: $LAYER_FILTER"
fi
echo ""

sqlite3 -header -column "$DB" "$SQL" 2>/dev/null || {
    echo "Search error. Try different keywords." >&2
    exit 1
}
