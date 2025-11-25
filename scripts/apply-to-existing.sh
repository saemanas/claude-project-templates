#!/bin/bash
#
# apply-to-existing.sh - Apply Template to Existing Project
#
# Purpose: Apply memory system to an existing project while preserving original files
# Usage: ./apply-to-existing.sh /path/to/existing/project
#
# This script:
# 1. Checks for existing refs/ directory
# 2. Moves existing content to refs/base/ (READ-ONLY)
# 3. Applies memory system templates
# 4. Sets up git hooks and CI/CD
# 5. Does NOT create GitHub repo (assumes existing or manual setup)
#

set -e

# ============================================================================
# PATH CONFIGURATION
# ============================================================================

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

# ============================================================================
# CONFIGURATION
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$(dirname "$SCRIPT_DIR")"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

print_banner() {
    echo ""
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}  ${BOLD}Apply Template to Existing Project${NC}                         ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  Version 2.0.0                                              ${CYAN}║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

log_step() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}[$1/$TOTAL_STEPS]${NC} ${BOLD}$2${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

log_info() {
    echo -e "${CYAN}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

confirm() {
    local prompt="$1"
    local default="${2:-n}"

    if [[ "$default" == "y" ]]; then
        prompt="$prompt [Y/n]: "
    else
        prompt="$prompt [y/N]: "
    fi

    read -p "$prompt" -n 1 -r
    echo

    if [[ -z "$REPLY" ]]; then
        REPLY="$default"
    fi

    [[ "$REPLY" =~ ^[Yy]$ ]]
}

# ============================================================================
# MAIN LOGIC
# ============================================================================

TOTAL_STEPS=6
PROJECT_PATH=""

check_args() {
    if [[ -z "$1" ]]; then
        echo -e "${RED}Usage: $0 /path/to/existing/project${NC}"
        echo ""
        echo "This script applies the memory system template to an existing project."
        echo "Existing files in refs/ will be moved to refs/base/ (READ-ONLY)."
        exit 1
    fi

    PROJECT_PATH="$1"

    if [[ ! -d "$PROJECT_PATH" ]]; then
        log_error "Directory does not exist: $PROJECT_PATH"
        exit 1
    fi
}

check_existing_refs() {
    log_step 1 "Checking Existing Project"

    cd "$PROJECT_PATH"
    log_info "Project path: $(pwd)"

    if [[ -d "refs" ]]; then
        log_warning "Existing refs/ directory found"
        echo ""

        # List existing content
        echo -e "${CYAN}Existing refs/ contents:${NC}"
        ls -la refs/ 2>/dev/null || true
        echo ""

        # Check for subdirectories
        local has_content=false
        for item in refs/*/; do
            if [[ -d "$item" && "$(basename "$item")" != "base" ]]; then
                has_content=true
                break
            fi
        done

        for item in refs/*; do
            if [[ -f "$item" ]]; then
                has_content=true
                break
            fi
        done

        if [[ "$has_content" == true ]]; then
            echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo -e "${BOLD}Existing content will be moved to refs/base/ (READ-ONLY)${NC}"
            echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo ""
            echo "  - Original files will be PRESERVED"
            echo "  - Files will be moved to refs/base/"
            echo "  - refs/base/ is READ-ONLY (no modifications allowed)"
            echo ""

            if ! confirm "Proceed with moving existing content to refs/base/?"; then
                log_info "Cancelled by user"
                exit 0
            fi

            EXISTING_REFS=true
        else
            log_info "refs/ exists but is empty or only contains base/"
            EXISTING_REFS=false
        fi
    else
        log_info "No existing refs/ directory"
        EXISTING_REFS=false
    fi

    # Check for git
    if [[ -d ".git" ]]; then
        log_success "Git repository detected"
        HAS_GIT=true
    else
        log_warning "Not a git repository"
        HAS_GIT=false
    fi
}

move_to_base() {
    log_step 2 "Moving Existing Content to refs/base/"

    if [[ "$EXISTING_REFS" != true ]]; then
        log_info "No existing content to move"
        return
    fi

    # Create refs/base/
    mkdir -p refs/base

    # Move all existing content except base/ itself
    local moved_count=0
    for item in refs/*; do
        local basename=$(basename "$item")

        # Skip base directory and README.md (will be overwritten)
        if [[ "$basename" == "base" ]]; then
            continue
        fi

        # Skip .DS_Store
        if [[ "$basename" == ".DS_Store" ]]; then
            continue
        fi

        # Move to base/
        if [[ -e "$item" ]]; then
            mv "$item" "refs/base/"
            log_success "Moved: refs/$basename → refs/base/$basename"
            ((moved_count++))
        fi
    done

    if [[ $moved_count -gt 0 ]]; then
        log_success "Moved $moved_count item(s) to refs/base/"
    fi

    # Copy base README
    cp "$TEMPLATE_DIR/refs/base/README.md" refs/base/
    log_success "Added refs/base/README.md (READ-ONLY rules)"
}

apply_templates() {
    log_step 3 "Applying Memory System Templates"

    cd "$PROJECT_PATH"

    # Create directories
    mkdir -p memory/timeline
    mkdir -p memory/decisions
    mkdir -p memory/archive
    mkdir -p docs
    mkdir -p scripts
    mkdir -p .githooks
    mkdir -p .github/workflows
    mkdir -p refs/prd
    mkdir -p refs/stack
    mkdir -p refs/dependencies/docs-cache
    mkdir -p refs/research

    # Copy scripts
    cp "$TEMPLATE_DIR/scripts/"*.sh scripts/ 2>/dev/null || true
    cp "$TEMPLATE_DIR/scripts/"*.py scripts/ 2>/dev/null || true
    chmod +x scripts/*.sh scripts/*.py 2>/dev/null || true
    log_success "Copied automation scripts"

    # Copy git hooks
    cp "$TEMPLATE_DIR/.githooks/"* .githooks/ 2>/dev/null || true
    chmod +x .githooks/* 2>/dev/null || true
    log_success "Copied git hooks"

    # Copy GitHub workflows
    cp "$TEMPLATE_DIR/.github/workflows/"*.yml .github/workflows/ 2>/dev/null || true
    log_success "Copied GitHub Actions workflows"

    # Copy memory templates
    cp "$TEMPLATE_DIR/memory/NOW-TEMPLATE.md" memory/NOW.md
    cp "$TEMPLATE_DIR/memory/FIND-TEMPLATE.md" memory/FIND.md
    cp "$TEMPLATE_DIR/memory/decisions/INDEX-TEMPLATE.md" memory/decisions/INDEX.md
    log_success "Copied memory templates"

    # Create first weekly log
    local current_week=$(date +%Y-W%V)
    local current_date=$(date +%Y-%m-%d)

    if [[ -f "$TEMPLATE_DIR/memory/timeline/YYYY-Wnn-TEMPLATE.md" ]]; then
        cp "$TEMPLATE_DIR/memory/timeline/YYYY-Wnn-TEMPLATE.md" "memory/timeline/${current_week}.md"

        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "s/YYYY-Wnn/${current_week}/g" "memory/timeline/${current_week}.md"
            sed -i '' "s/{YYYY-MM-DD}/${current_date}/g" "memory/timeline/${current_week}.md"
        else
            sed -i "s/YYYY-Wnn/${current_week}/g" "memory/timeline/${current_week}.md"
            sed -i "s/{YYYY-MM-DD}/${current_date}/g" "memory/timeline/${current_week}.md"
        fi
        log_success "Created weekly log: memory/timeline/${current_week}.md"
    fi

    # Copy docs template
    mkdir -p docs/example-topic
    cp "$TEMPLATE_DIR/docs/example-topic/README-TEMPLATE.md" docs/example-topic/README.md 2>/dev/null || true

    # Create .gitkeep files
    touch memory/archive/.gitkeep
    touch refs/research/.gitkeep
    touch refs/dependencies/docs-cache/.gitkeep

    # Copy documentation
    cp "$TEMPLATE_DIR/README.md" MEMORY-SYSTEM-README.md 2>/dev/null || true
    cp "$TEMPLATE_DIR/RULES.md" RULES.md 2>/dev/null || true
    cp "$TEMPLATE_DIR/QUICKSTART.md" QUICKSTART.md 2>/dev/null || true

    # Copy .gitignore (merge if exists)
    if [[ -f ".gitignore" ]]; then
        log_info "Existing .gitignore found - merging"
        cat "$TEMPLATE_DIR/.gitignore" >> .gitignore
        # Remove duplicates
        sort -u .gitignore -o .gitignore
    else
        cp "$TEMPLATE_DIR/.gitignore" .gitignore
    fi
    log_success "Updated .gitignore"

    # Create .claude/settings.local.json
    mkdir -p .claude
    cat > .claude/settings.local.json << 'CLAUDE_SETTINGS_EOF'
{
  "permissions": {
    "allow": [
      "Bash(*)",
      "Read(*)",
      "Write(*)",
      "Edit(*)"
    ],
    "deny": [],
    "ask": []
  }
}
CLAUDE_SETTINGS_EOF
    log_success "Created .claude/settings.local.json (auto-approve enabled)"

    # Copy refs/ templates (skip base/)
    cp "$TEMPLATE_DIR/refs/README.md" refs/
    cp "$TEMPLATE_DIR/refs/PROJECT-CONTEXT-TEMPLATE.md" refs/PROJECT-CONTEXT.md 2>/dev/null || true
    cp "$TEMPLATE_DIR/refs/prd/PRD-TEMPLATE.md" refs/prd/ 2>/dev/null || true
    cp "$TEMPLATE_DIR/refs/stack/STACK-DECISION-TEMPLATE.md" refs/stack/STACK-DECISION.md 2>/dev/null || true
    cp "$TEMPLATE_DIR/refs/stack/STACK-RESEARCH-TEMPLATE.md" refs/stack/STACK-RESEARCH.md 2>/dev/null || true
    cp "$TEMPLATE_DIR/refs/stack/STACK-ALTERNATIVES-TEMPLATE.md" refs/stack/STACK-ALTERNATIVES.md 2>/dev/null || true
    cp "$TEMPLATE_DIR/refs/dependencies/VERSIONS.lock-TEMPLATE.md" refs/dependencies/VERSIONS.lock.md 2>/dev/null || true
    cp "$TEMPLATE_DIR/refs/dependencies/UPGRADE-LOG-TEMPLATE.md" refs/dependencies/UPGRADE-LOG.md 2>/dev/null || true
    cp "$TEMPLATE_DIR/refs/dependencies/CONTEXT7-GUIDE.md" refs/dependencies/ 2>/dev/null || true
    cp "$TEMPLATE_DIR/refs/dependencies/docs-cache/README.md" refs/dependencies/docs-cache/ 2>/dev/null || true
    log_success "Copied refs/ templates"

    # Update NOW.md with project info
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/{YYYY-MM-DD.*}/${current_date}/g" memory/NOW.md
        sed -i '' "s/{CURRENT_PHASE}/Template Applied/g" memory/NOW.md
    else
        sed -i "s/{YYYY-MM-DD.*}/${current_date}/g" memory/NOW.md
        sed -i "s/{CURRENT_PHASE}/Template Applied/g" memory/NOW.md
    fi

    log_success "Templates applied"
}

setup_git_hooks() {
    log_step 4 "Setting Up Git Hooks"

    cd "$PROJECT_PATH"

    if [[ "$HAS_GIT" == true ]]; then
        git config core.hooksPath .githooks
        log_success "Configured git hooks path"
    else
        log_warning "Not a git repository - hooks not configured"
        echo "  Run 'git init' then 'git config core.hooksPath .githooks'"
    fi
}

generate_claude_md() {
    log_step 5 "Generating CLAUDE.md"

    cd "$PROJECT_PATH"

    local project_name=$(basename "$PROJECT_PATH")
    local current_date=$(date +%Y-%m-%d)
    local current_week=$(date +%Y-W%V)

    cat > CLAUDE.md << CLAUDE_EOF
# CLAUDE.md - ${project_name}

**Project**: ${project_name}
**Template Applied**: ${current_date}
**Version**: 0.1.0

---

## CRITICAL: refs/base/ Rules

> **refs/base/ is READ-ONLY. NEVER modify or delete any file in refs/base/**

This project was created from an existing project. Original materials are preserved in \`refs/base/\`:

\`\`\`
refs/base/
└── {original content preserved here}
\`\`\`

### Allowed Actions
- Read files for context
- Reference in PRD/decisions
- Quote content in new documents

### Forbidden Actions
- Edit any file in refs/base/
- Delete any file in refs/base/
- Rename or move files in refs/base/

---

## Project Structure

\`\`\`
/${project_name}/
├── CLAUDE.md (this file)
├── GITFLOW.md
├── RULES.md
│
├── memory/
│   ├── NOW.md - Current state (START HERE)
│   ├── FIND.md - How to find info
│   ├── timeline/
│   ├── decisions/
│   └── archive/
│
├── refs/
│   ├── base/              ← ORIGINAL PROJECT MATERIALS (READ-ONLY!)
│   │   └── {preserved}
│   ├── PROJECT-CONTEXT.md
│   ├── prd/
│   ├── stack/
│   ├── dependencies/
│   └── research/
│
├── docs/
├── scripts/
├── .githooks/
└── .github/workflows/
\`\`\`

---

## Every Session Start

1. **Read memory/NOW.md** (~1,200 tokens)
2. **Read refs/PROJECT-CONTEXT.md** (~500 tokens)
3. **If needed**: Scan refs/base/ for original context

---

## Git Workflow (AI Handles All Git)

\`\`\`
main      - Production (NEVER commit directly)
develop   - Integration (NEVER commit directly)
feature/* - New features
bugfix/*  - Bug fixes
hotfix/*  - Urgent fixes
release/* - Release prep
\`\`\`

---

## Key Locations

→ [memory/NOW.md](memory/NOW.md) - Current state
→ [refs/base/](refs/base/) - Original materials (READ-ONLY)
→ [refs/PROJECT-CONTEXT.md](refs/PROJECT-CONTEXT.md) - Project context
→ [RULES.md](./RULES.md) - Validation rules

---

**CLAUDE.md Version**: 1.0.0
**Last Updated**: ${current_date}
CLAUDE_EOF

    log_success "Generated CLAUDE.md (with refs/base/ rules)"
}

print_summary() {
    log_step 6 "Summary"

    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║${NC}  ${BOLD}Template Applied Successfully!${NC}                              ${GREEN}║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    echo -e "${BOLD}Project:${NC} $PROJECT_PATH"
    echo ""

    if [[ "$EXISTING_REFS" == true ]]; then
        echo -e "${BOLD}Original Content:${NC}"
        echo -e "  ${YELLOW}refs/base/${NC} - Original files preserved (READ-ONLY)"
        echo ""
    fi

    echo -e "${BOLD}Files Created:${NC}"
    echo -e "  ${GREEN}CLAUDE.md${NC}              - AI assistant guide"
    echo -e "  ${GREEN}memory/NOW.md${NC}          - Current state"
    echo -e "  ${GREEN}refs/PROJECT-CONTEXT.md${NC} - Project context (edit this)"
    echo ""

    echo -e "${BOLD}Next Steps:${NC}"
    echo -e "  1. ${CYAN}Edit refs/PROJECT-CONTEXT.md${NC} with project details"
    if [[ "$EXISTING_REFS" == true ]]; then
        echo -e "  2. ${CYAN}Review refs/base/${NC} contents for context"
    fi
    echo -e "  3. Discuss with AI to write PRD and decide stack"
    echo ""

    if [[ "$HAS_GIT" != true ]]; then
        echo -e "${YELLOW}Git Setup Required:${NC}"
        echo -e "  git init"
        echo -e "  git config core.hooksPath .githooks"
        echo ""
    fi

    echo -e "${GREEN}Ready for AI-assisted development!${NC}"
    echo ""
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    print_banner
    check_args "$1"
    check_existing_refs
    move_to_base
    apply_templates
    setup_git_hooks
    generate_claude_md
    print_summary
}

main "$@"
