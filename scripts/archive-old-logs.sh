#!/bin/bash
#
# archive-old-logs.sh - Archive old memory logs
#
# Purpose: Move old weekly logs to archive directory
# Usage: ./scripts/archive-old-logs.sh [--weeks <n>] [--dry-run]
#
# Default: Archives logs older than 12 weeks
#

set -e

# Configuration
ARCHIVE_AFTER_WEEKS=12
DRY_RUN=false
TIMELINE_DIR="memory/timeline"
ARCHIVE_DIR="memory/archive"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --weeks) ARCHIVE_AFTER_WEEKS="$2"; shift ;;
        --dry-run) DRY_RUN=true ;;
        -h|--help)
            echo "Usage: $0 [--weeks <n>] [--dry-run]"
            echo ""
            echo "Options:"
            echo "  --weeks <n>   Archive logs older than n weeks (default: 12)"
            echo "  --dry-run     Show what would be archived without moving"
            echo "  -h, --help    Show this help"
            exit 0
            ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done

echo ""
echo "=========================================="
echo "  Archive Old Memory Logs"
echo "=========================================="
echo ""
echo "Archive threshold: $ARCHIVE_AFTER_WEEKS weeks"
if $DRY_RUN; then
    echo -e "${YELLOW}DRY RUN MODE - No files will be moved${NC}"
fi
echo ""

# Check if timeline directory exists
if [ ! -d "$TIMELINE_DIR" ]; then
    echo -e "${YELLOW}No timeline directory found${NC}"
    exit 0
fi

# Calculate cutoff date
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    CUTOFF_DATE=$(date -v-${ARCHIVE_AFTER_WEEKS}w +%Y-%m-%d)
else
    # Linux
    CUTOFF_DATE=$(date -d "-${ARCHIVE_AFTER_WEEKS} weeks" +%Y-%m-%d)
fi

echo "Cutoff date: $CUTOFF_DATE"
echo ""

# Find and archive old weekly logs
ARCHIVED_COUNT=0

for file in "$TIMELINE_DIR"/????-W??.md; do
    [ -f "$file" ] || continue

    # Extract year and week from filename
    basename=$(basename "$file" .md)
    year=$(echo "$basename" | cut -d'-' -f1)
    week=$(echo "$basename" | cut -d'W' -f2)

    # Convert to date (first day of that week)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS - use Python for ISO week date conversion
        file_date=$(python3 -c "from datetime import datetime; print(datetime.strptime('${year}-W${week}-1', '%G-W%V-%u').strftime('%Y-%m-%d'))" 2>/dev/null || echo "")
    else
        # Linux
        file_date=$(date -d "${year}-W${week}-1" +%Y-%m-%d 2>/dev/null || echo "")
    fi

    if [ -z "$file_date" ]; then
        echo -e "${YELLOW}[SKIP]${NC} Could not parse date for: $file"
        continue
    fi

    # Compare dates
    if [[ "$file_date" < "$CUTOFF_DATE" ]]; then
        # Determine quarter for archive directory
        month=$(python3 -c "from datetime import datetime; print(datetime.strptime('${file_date}', '%Y-%m-%d').month)" 2>/dev/null || echo "1")
        quarter=$(( (month - 1) / 3 + 1 ))
        quarter_dir="${ARCHIVE_DIR}/${year}-Q${quarter}"

        if $DRY_RUN; then
            echo -e "${BLUE}[DRY-RUN]${NC} Would archive: $file -> $quarter_dir/"
        else
            mkdir -p "$quarter_dir"
            mv "$file" "$quarter_dir/"
            echo -e "${GREEN}[ARCHIVED]${NC} $file -> $quarter_dir/"
        fi
        ((ARCHIVED_COUNT++))
    else
        echo -e "${CYAN}[KEEP]${NC} $file (${file_date})"
    fi
done

echo ""
echo "=========================================="

if $DRY_RUN; then
    echo -e "${YELLOW}DRY RUN: Would archive $ARCHIVED_COUNT file(s)${NC}"
else
    echo -e "${GREEN}Archived $ARCHIVED_COUNT file(s)${NC}"
fi

echo "=========================================="
echo ""

# Update NOW.md reference if files were archived
if [ $ARCHIVED_COUNT -gt 0 ] && ! $DRY_RUN; then
    echo -e "${CYAN}Note: You may need to update links in memory/NOW.md${NC}"
fi
