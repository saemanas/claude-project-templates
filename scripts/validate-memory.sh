#!/bin/bash
#
# validate-memory.sh - Memory System Validation Script
#
# Purpose: Enforce zero-tolerance rules for project memory system
# Usage: ./scripts/validate-memory.sh [--strict] [--fix]
#
# Exit codes:
#   0 - All validations passed
#   1 - Validation errors found
#   2 - Script error
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
STRICT_MODE=false
FIX_MODE=false
ERRORS=0
WARNINGS=0

# Line limits (zero tolerance)
declare -A LINE_LIMITS=(
    ["memory/NOW.md"]=300
    ["memory/FIND.md"]=200
    ["memory/decisions/INDEX.md"]=300
)

# Pattern-based limits
WEEKLY_LOG_LIMIT=500
MONTHLY_SUMMARY_LIMIT=500
DECISION_RECORD_LIMIT=500
TOPIC_README_LIMIT=100
TOPIC_CONTENT_LIMIT=500

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --strict) STRICT_MODE=true ;;
        --fix) FIX_MODE=true ;;
        -h|--help)
            echo "Usage: $0 [--strict] [--fix]"
            echo "  --strict  Treat warnings as errors"
            echo "  --fix     Attempt to auto-fix issues (creates backup)"
            exit 0
            ;;
        *) echo "Unknown parameter: $1"; exit 2 ;;
    esac
    shift
done

# Helper functions
log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
    ((ERRORS++))
}

log_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
    ((WARNINGS++))
    if $STRICT_MODE; then
        ((ERRORS++))
    fi
}

log_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Check if file exists
check_file_exists() {
    local file=$1
    local required=$2

    if [[ ! -f "$file" ]]; then
        if [[ "$required" == "true" ]]; then
            log_error "Required file missing: $file"
        else
            log_warning "Optional file missing: $file"
        fi
        return 1
    fi
    return 0
}

# Check line count
check_line_count() {
    local file=$1
    local max_lines=$2
    local file_type=$3

    if [[ ! -f "$file" ]]; then
        return 0
    fi

    local lines=$(wc -l < "$file" | tr -d ' ')

    if [[ $lines -gt $max_lines ]]; then
        log_error "$file_type '$file' has $lines lines (max: $max_lines)"

        if $FIX_MODE; then
            log_info "Creating backup: ${file}.backup"
            cp "$file" "${file}.backup"
            log_warning "Manual intervention required to split file"
        fi
        return 1
    else
        local percentage=$((lines * 100 / max_lines))
        if [[ $percentage -gt 90 ]]; then
            log_warning "$file_type '$file' is ${percentage}% full ($lines/$max_lines lines)"
        else
            log_success "$file_type '$file': $lines/$max_lines lines (${percentage}%)"
        fi
    fi
    return 0
}

# Check for required sections in NOW.md
check_now_md_structure() {
    local file="memory/NOW.md"

    if [[ ! -f "$file" ]]; then
        return 0
    fi

    local required_sections=(
        "Status Dashboard"
        "Active This Week"
        "Critical Facts"
        "Recent Decisions"
        "Quick Navigation"
    )

    for section in "${required_sections[@]}"; do
        if ! grep -q "## $section\|## .*$section" "$file"; then
            log_warning "NOW.md missing section: '$section'"
        fi
    done
}

# Check for required sections in FIND.md
check_find_md_structure() {
    local file="memory/FIND.md"

    if [[ ! -f "$file" ]]; then
        return 0
    fi

    local required_sections=(
        "By Topic"
        "By Time"
        "By Question Type"
    )

    for section in "${required_sections[@]}"; do
        if ! grep -q "## $section" "$file"; then
            log_warning "FIND.md missing section: '$section'"
        fi
    done
}

# Check decision ID uniqueness
check_decision_ids() {
    local decisions_dir="memory/decisions"

    if [[ ! -d "$decisions_dir" ]]; then
        return 0
    fi

    local dec_files=$(find "$decisions_dir" -name "DEC-*.md" 2>/dev/null)

    if [[ -z "$dec_files" ]]; then
        return 0
    fi

    # Extract IDs and check for duplicates
    local ids=$(echo "$dec_files" | xargs -I {} basename {} .md | sed 's/-.*$//' | sort)
    local duplicates=$(echo "$ids" | uniq -d)

    if [[ -n "$duplicates" ]]; then
        log_error "Duplicate decision IDs found: $duplicates"
        return 1
    else
        local count=$(echo "$ids" | wc -l | tr -d ' ')
        log_success "Decision IDs: $count unique IDs, no duplicates"
    fi
    return 0
}

# Check weekly log naming convention
check_weekly_log_naming() {
    local timeline_dir="memory/timeline"

    if [[ ! -d "$timeline_dir" ]]; then
        return 0
    fi

    # Check for incorrectly named files
    for file in "$timeline_dir"/*.md; do
        [[ -f "$file" ]] || continue
        local basename=$(basename "$file")

        # Skip summary files and templates
        if [[ "$basename" == *"-SUMMARY.md" ]] || [[ "$basename" == *"-TEMPLATE.md" ]]; then
            continue
        fi

        # Check YYYY-Wnn.md format
        if [[ ! "$basename" =~ ^[0-9]{4}-W[0-9]{2}\.md$ ]]; then
            log_warning "Non-standard weekly log name: $basename (expected: YYYY-Wnn.md)"
        fi
    done
}

# Check for orphaned links
check_internal_links() {
    local files=$(find memory docs -name "*.md" 2>/dev/null)

    for file in $files; do
        [[ -f "$file" ]] || continue

        # Extract markdown links
        local links=$(grep -oE '\[.*\]\([^)]+\.md[^)]*\)' "$file" 2>/dev/null | grep -oE '\([^)]+\.md' | tr -d '(' || true)

        for link in $links; do
            # Handle relative paths
            local dir=$(dirname "$file")
            local target=""

            if [[ "$link" == /* ]]; then
                target="$link"
            elif [[ "$link" == ../* ]]; then
                target=$(cd "$dir" && realpath "$link" 2>/dev/null || echo "")
            else
                target="$dir/$link"
            fi

            # Remove anchor if present
            target="${target%%#*}"

            if [[ -n "$target" ]] && [[ ! -f "$target" ]]; then
                log_warning "Broken link in $file: $link"
            fi
        done
    done
}

# Check update timestamps
check_update_timestamps() {
    local now_md="memory/NOW.md"

    if [[ ! -f "$now_md" ]]; then
        return 0
    fi

    # Extract update date from NOW.md
    local update_line=$(grep -E "^\*\*Updated\*\*:" "$now_md" | head -1)

    if [[ -z "$update_line" ]]; then
        log_warning "NOW.md missing **Updated**: timestamp"
        return 0
    fi

    # Check if update is within last 7 days
    local update_date=$(echo "$update_line" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' | head -1)

    if [[ -n "$update_date" ]]; then
        local update_epoch=$(date -j -f "%Y-%m-%d" "$update_date" "+%s" 2>/dev/null || date -d "$update_date" "+%s" 2>/dev/null || echo "0")
        local now_epoch=$(date "+%s")
        local diff_days=$(( (now_epoch - update_epoch) / 86400 ))

        if [[ $diff_days -gt 7 ]]; then
            log_warning "NOW.md not updated in $diff_days days (last: $update_date)"
        else
            log_success "NOW.md last updated: $update_date ($diff_days days ago)"
        fi
    fi
}

# Main validation
main() {
    echo ""
    echo "=========================================="
    echo "  Memory System Validation"
    echo "=========================================="
    echo ""

    # Check required directory structure
    log_info "Checking directory structure..."
    check_file_exists "memory/NOW.md" "true"
    check_file_exists "memory/FIND.md" "false"
    check_file_exists "memory/decisions/INDEX.md" "false"
    check_file_exists "CLAUDE.md" "false"
    echo ""

    # Check line limits for core files
    log_info "Checking line limits (zero tolerance)..."
    for file in "${!LINE_LIMITS[@]}"; do
        check_line_count "$file" "${LINE_LIMITS[$file]}" "Core file"
    done
    echo ""

    # Check timeline files
    log_info "Checking timeline files..."
    if [[ -d "memory/timeline" ]]; then
        for file in memory/timeline/????-W??.md; do
            [[ -f "$file" ]] && check_line_count "$file" $WEEKLY_LOG_LIMIT "Weekly log"
        done
        for file in memory/timeline/????-??-SUMMARY.md; do
            [[ -f "$file" ]] && check_line_count "$file" $MONTHLY_SUMMARY_LIMIT "Monthly summary"
        done
    fi
    echo ""

    # Check decision records
    log_info "Checking decision records..."
    if [[ -d "memory/decisions" ]]; then
        for file in memory/decisions/DEC-*.md; do
            [[ -f "$file" ]] && check_line_count "$file" $DECISION_RECORD_LIMIT "Decision record"
        done
    fi
    check_decision_ids
    echo ""

    # Check docs structure
    log_info "Checking documentation structure..."
    if [[ -d "docs" ]]; then
        for readme in docs/*/README.md; do
            [[ -f "$readme" ]] && check_line_count "$readme" $TOPIC_README_LIMIT "Topic README"
        done
        for file in docs/*/*.md; do
            [[ -f "$file" ]] || continue
            [[ "$(basename "$file")" == "README.md" ]] && continue
            check_line_count "$file" $TOPIC_CONTENT_LIMIT "Topic content"
        done
    fi
    echo ""

    # Structure checks
    log_info "Checking file structures..."
    check_now_md_structure
    check_find_md_structure
    check_weekly_log_naming
    echo ""

    # Timestamp checks
    log_info "Checking update timestamps..."
    check_update_timestamps
    echo ""

    # Link checks (optional, can be slow)
    if $STRICT_MODE; then
        log_info "Checking internal links (strict mode)..."
        check_internal_links
        echo ""
    fi

    # Summary
    echo "=========================================="
    echo "  Validation Summary"
    echo "=========================================="

    if [[ $ERRORS -gt 0 ]]; then
        echo -e "${RED}FAILED${NC}: $ERRORS error(s), $WARNINGS warning(s)"
        exit 1
    elif [[ $WARNINGS -gt 0 ]]; then
        echo -e "${YELLOW}PASSED WITH WARNINGS${NC}: $WARNINGS warning(s)"
        exit 0
    else
        echo -e "${GREEN}PASSED${NC}: All validations successful"
        exit 0
    fi
}

# Run main
main "$@"
