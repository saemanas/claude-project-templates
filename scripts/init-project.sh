#!/bin/bash
#
# init-project.sh - Complete Project Initialization Script
#
# Purpose: One-command setup for new projects with GitHub integration
# Usage: ./init-project.sh
#
# This script:
# 1. Checks all prerequisites (git, gh, permissions)
# 2. Collects project information interactively
# 3. Creates GitHub repository (public/private)
# 4. Applies memory system templates
# 5. Sets up gitflow branching
# 6. Configures git hooks and CI/CD
# 7. Creates initial commit and pushes
# 8. Generates CLAUDE.md from template
#
# NOTE: IT stacks are NOT created here.
#       Stacks are decided after AI discussion and created separately.
#

set -e

# ============================================================================
# PATH CONFIGURATION (for Homebrew on macOS)
# ============================================================================

# Add common Homebrew paths
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
MAGENTA='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m'

# Project configuration (will be set interactively)
PROJECT_NAME=""
PROJECT_DESCRIPTION=""
PROJECT_PATH=""
GITHUB_VISIBILITY="public"  # public (recommended for GitHub Free) or private
GITHUB_ORG=""  # empty for personal repo
CREATE_REPO=true

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

print_banner() {
    echo ""
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}  ${BOLD}Project Memory System - Complete Initialization${NC}            ${CYAN}║${NC}"
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

prompt_input() {
    local prompt="$1"
    local default="$2"
    local var_name="$3"

    if [[ -n "$default" ]]; then
        read -p "$prompt [$default]: " input
        input="${input:-$default}"
    else
        read -p "$prompt: " input
    fi

    eval "$var_name=\"$input\""
}

# ============================================================================
# PREREQUISITE CHECKS
# ============================================================================

TOTAL_STEPS=8

check_prerequisites() {
    log_step 1 "Checking Prerequisites"

    local errors=0

    # Check git
    if command -v git &> /dev/null; then
        log_success "Git: $(git --version)"
    else
        log_error "Git is not installed"
        echo "  Install: https://git-scm.com/downloads"
        ((errors++))
    fi

    # Check gh (GitHub CLI)
    if command -v gh &> /dev/null; then
        log_success "GitHub CLI: $(gh --version | head -1)"

        # Check gh auth status
        if gh auth status &> /dev/null; then
            local gh_user=$(gh api user --jq '.login' 2>/dev/null || echo "unknown")
            log_success "GitHub authenticated as: $gh_user"
        else
            log_error "GitHub CLI not authenticated"
            echo ""
            echo -e "${YELLOW}Please authenticate with GitHub:${NC}"
            echo "  gh auth login"
            echo ""

            if confirm "Run 'gh auth login' now?"; then
                gh auth login
                if ! gh auth status &> /dev/null; then
                    log_error "Authentication failed"
                    ((errors++))
                fi
            else
                ((errors++))
            fi
        fi
    else
        log_error "GitHub CLI (gh) is not installed"
        echo ""
        echo -e "${YELLOW}Install GitHub CLI:${NC}"
        echo "  macOS:   brew install gh"
        echo "  Linux:   https://github.com/cli/cli/blob/trunk/docs/install_linux.md"
        echo "  Windows: winget install GitHub.cli"
        echo ""
        ((errors++))
    fi

    # Check Python (optional)
    if command -v python3 &> /dev/null; then
        log_success "Python: $(python3 --version)"

        # Check tiktoken
        if python3 -c "import tiktoken" 2>/dev/null; then
            log_success "tiktoken: installed (accurate token counting)"
        else
            log_warning "tiktoken not installed (will use estimation)"
            echo "  Install: pip install tiktoken"
        fi
    else
        log_warning "Python not found (token counting will use estimation)"
    fi

    # Check GitHub permissions
    if command -v gh &> /dev/null && gh auth status &> /dev/null; then
        local scopes=$(gh auth status 2>&1 | grep -i "token scopes" || echo "")
        if [[ -n "$scopes" ]]; then
            log_info "Token scopes: $scopes"
        fi

        # Test repo creation permission
        if gh api user/repos --method GET --jq '.[0].name' &> /dev/null; then
            log_success "GitHub repo access: OK"
        else
            log_warning "Could not verify repo permissions"
        fi
    fi

    echo ""

    if [[ $errors -gt 0 ]]; then
        log_error "Prerequisites check failed with $errors error(s)"
        echo ""
        echo -e "${YELLOW}Please fix the errors above and run this script again.${NC}"
        exit 1
    fi

    log_success "All prerequisites satisfied"
}

# ============================================================================
# PROJECT INFORMATION
# ============================================================================

collect_project_info() {
    log_step 2 "Project Information"

    echo -e "${CYAN}Please provide the following information:${NC}"
    echo ""

    # Project name
    local default_name=$(basename "$(pwd)")
    prompt_input "Project name" "$default_name" PROJECT_NAME

    # Validate project name (no spaces, lowercase)
    PROJECT_NAME=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd '[:alnum:]-_')
    log_info "Normalized project name: $PROJECT_NAME"

    # Project description
    prompt_input "Project description (one line)" "" PROJECT_DESCRIPTION

    # Project path
    local default_path="$(pwd)"
    if [[ "$(basename "$default_path")" != "$PROJECT_NAME" ]]; then
        default_path="$(pwd)/$PROJECT_NAME"
    fi
    prompt_input "Project path" "$default_path" PROJECT_PATH

    echo ""

    # GitHub visibility
    echo -e "${CYAN}GitHub Repository Visibility:${NC}"
    echo "  1) Public  - Open source, visible to everyone"
    echo "  2) Private - Only you and collaborators can see"
    echo ""
    read -p "Choose [1/2] (default: 1 - Public): " visibility_choice

    case "$visibility_choice" in
        2) GITHUB_VISIBILITY="private" ;;
        *) GITHUB_VISIBILITY="public" ;;
    esac

    log_info "Repository visibility: $GITHUB_VISIBILITY"

    # GitHub organization (optional)
    echo ""
    read -p "GitHub organization (leave empty for personal account): " GITHUB_ORG

    if [[ -n "$GITHUB_ORG" ]]; then
        log_info "Organization: $GITHUB_ORG"
    else
        log_info "Using personal account"
    fi

    # NOTE: Stack selection removed - decided after AI discussion
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}Note: IT Development Stacks${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "  Stacks are NOT selected during initialization."
    echo "  After project setup, discuss with AI to decide the appropriate stack."
    echo "  AI will create the stack after your approval."
    echo ""
    echo "  Available stacks (templates/stacks/):"
    echo "    - backend/api (FastAPI)"
    echo "    - backend/ai (Inference Service)"
    echo "    - frontend/web (React + Vite)"
    echo "    - mobile/app (Expo)"
    echo "    - infra (PostgreSQL, Redis, Monitoring)"
    echo ""

    # Confirm
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}Please confirm:${NC}"
    echo -e "  Project name:    ${GREEN}$PROJECT_NAME${NC}"
    echo -e "  Description:     ${GREEN}$PROJECT_DESCRIPTION${NC}"
    echo -e "  Path:            ${GREEN}$PROJECT_PATH${NC}"
    echo -e "  Visibility:      ${GREEN}$GITHUB_VISIBILITY${NC}"
    echo -e "  Organization:    ${GREEN}${GITHUB_ORG:-personal}${NC}"
    echo -e "  Stacks:          ${YELLOW}Decided after AI discussion${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    if ! confirm "Proceed with these settings?" "y"; then
        log_info "Cancelled by user"
        exit 0
    fi
}

# ============================================================================
# CREATE GITHUB REPOSITORY
# ============================================================================

create_github_repo() {
    log_step 3 "Creating GitHub Repository"

    local repo_name="$PROJECT_NAME"
    local full_repo_name=""

    if [[ -n "$GITHUB_ORG" ]]; then
        full_repo_name="$GITHUB_ORG/$repo_name"
    else
        local gh_user=$(gh api user --jq '.login')
        full_repo_name="$gh_user/$repo_name"
    fi

    # Check if repo already exists
    if gh repo view "$full_repo_name" &> /dev/null; then
        log_warning "Repository '$full_repo_name' already exists"

        if confirm "Use existing repository?"; then
            CREATE_REPO=false
            log_info "Will use existing repository"
        else
            log_error "Cannot proceed - repository already exists"
            exit 1
        fi
    else
        log_info "Repository '$full_repo_name' does not exist"

        # Create repository
        echo ""
        log_info "Creating GitHub repository..."

        if [[ -n "$GITHUB_ORG" ]]; then
            # Create in organization
            if gh repo create "$full_repo_name" --"$GITHUB_VISIBILITY" --description "$PROJECT_DESCRIPTION" -y; then
                log_success "Created repository: $full_repo_name"
            else
                log_error "Failed to create repository"
                exit 1
            fi
        else
            # Create in personal account
            if gh repo create "$repo_name" --"$GITHUB_VISIBILITY" --description "$PROJECT_DESCRIPTION" -y; then
                log_success "Created repository: $full_repo_name"
            else
                log_error "Failed to create repository"
                exit 1
            fi
        fi
    fi

    # Store repo URL
    GITHUB_REPO_URL="https://github.com/$full_repo_name.git"
    log_info "Repository URL: $GITHUB_REPO_URL"
}

# ============================================================================
# SETUP PROJECT DIRECTORY
# ============================================================================

setup_project_directory() {
    log_step 4 "Setting Up Project Directory"

    # Create project directory if needed
    if [[ ! -d "$PROJECT_PATH" ]]; then
        mkdir -p "$PROJECT_PATH"
        log_success "Created directory: $PROJECT_PATH"
    else
        log_info "Directory exists: $PROJECT_PATH"
    fi

    cd "$PROJECT_PATH"
    log_info "Working directory: $(pwd)"

    # Initialize git if needed
    if [[ ! -d ".git" ]]; then
        git init
        log_success "Initialized git repository"
    else
        log_info "Git repository already initialized"
    fi

    # Set default branch to main
    git branch -M main 2>/dev/null || true
    log_info "Default branch: main"
}

# ============================================================================
# APPLY TEMPLATES
# ============================================================================

apply_templates() {
    log_step 5 "Applying Memory System Templates"

    # Copy template files
    log_info "Copying template files..."

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

        # Replace placeholders in weekly log
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

    # Copy .gitignore
    cp "$TEMPLATE_DIR/.gitignore" .gitignore 2>/dev/null || true
    log_success "Copied .gitignore"

    # Copy refs/ templates
    log_info "Copying refs/ templates..."
    cp "$TEMPLATE_DIR/refs/README.md" refs/ 2>/dev/null || true
    cp "$TEMPLATE_DIR/refs/PROJECT-CONTEXT-TEMPLATE.md" refs/PROJECT-CONTEXT.md 2>/dev/null || true
    cp "$TEMPLATE_DIR/refs/prd/PRD-TEMPLATE.md" refs/prd/ 2>/dev/null || true
    cp "$TEMPLATE_DIR/refs/stack/STACK-DECISION-TEMPLATE.md" refs/stack/STACK-DECISION.md 2>/dev/null || true
    cp "$TEMPLATE_DIR/refs/stack/STACK-RESEARCH-TEMPLATE.md" refs/stack/STACK-RESEARCH.md 2>/dev/null || true
    cp "$TEMPLATE_DIR/refs/stack/STACK-ALTERNATIVES-TEMPLATE.md" refs/stack/STACK-ALTERNATIVES.md 2>/dev/null || true
    cp "$TEMPLATE_DIR/refs/dependencies/VERSIONS.lock-TEMPLATE.md" refs/dependencies/VERSIONS.lock.md 2>/dev/null || true
    cp "$TEMPLATE_DIR/refs/dependencies/UPGRADE-LOG-TEMPLATE.md" refs/dependencies/UPGRADE-LOG.md 2>/dev/null || true
    cp "$TEMPLATE_DIR/refs/dependencies/CONTEXT7-GUIDE.md" refs/dependencies/ 2>/dev/null || true
    cp "$TEMPLATE_DIR/refs/dependencies/docs-cache/README.md" refs/dependencies/docs-cache/ 2>/dev/null || true
    log_success "Copied refs/ templates (including Context7 guide)"

    log_success "Template files applied"

    # Update NOW.md with project info
    log_info "Updating NOW.md with project information..."

    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/{YYYY-MM-DD.*}/${current_date}/g" memory/NOW.md
        sed -i '' "s/{CURRENT_PHASE}/Initial Setup/g" memory/NOW.md
    else
        sed -i "s/{YYYY-MM-DD.*}/${current_date}/g" memory/NOW.md
        sed -i "s/{CURRENT_PHASE}/Initial Setup/g" memory/NOW.md
    fi

    log_success "NOW.md updated"
}

# ============================================================================
# SETUP GITFLOW
# ============================================================================

setup_gitflow() {
    log_step 6 "Setting Up Gitflow Branching"

    # Create GITFLOW.md documentation (before commit)
    cat > GITFLOW.md << 'GITFLOW_EOF'
# Gitflow Branching Strategy

**Enforced by**: Git hooks + GitHub Actions
**Bypass**: NOT ALLOWED

---

## Branch Structure

```
main (production)
  │
  └── develop (integration)
        │
        ├── feature/xxx (new features)
        ├── bugfix/xxx (bug fixes)
        ├── hotfix/xxx (urgent fixes → main)
        └── release/x.x.x (release preparation)
```

---

## Branch Rules

### Protected Branches

| Branch | Direct Push | Merge From | Merge To |
|--------|-------------|------------|----------|
| `main` | BLOCKED | release/*, hotfix/* | - |
| `develop` | BLOCKED | feature/*, bugfix/*, release/* | - |

### Working Branches

| Prefix | Purpose | Branch From | Merge To |
|--------|---------|-------------|----------|
| `feature/` | New features | develop | develop |
| `bugfix/` | Bug fixes | develop | develop |
| `hotfix/` | Urgent fixes | main | main + develop |
| `release/` | Release prep | develop | main + develop |

---

## Workflow

### Starting New Feature

```bash
git checkout develop
git pull origin develop
git checkout -b feature/my-feature

# Work on feature...

git add .
git commit -m "feat: add my feature"
git push -u origin feature/my-feature

# Create PR: feature/my-feature → develop
```

### Bug Fix

```bash
git checkout develop
git pull origin develop
git checkout -b bugfix/fix-issue

# Fix bug...

git add .
git commit -m "fix: resolve issue"
git push -u origin bugfix/fix-issue

# Create PR: bugfix/fix-issue → develop
```

### Hotfix (Urgent)

```bash
git checkout main
git pull origin main
git checkout -b hotfix/critical-fix

# Fix critical issue...

git add .
git commit -m "hotfix: critical fix"
git push -u origin hotfix/critical-fix

# Create PR: hotfix/critical-fix → main
# Then merge main → develop
```

### Release

```bash
git checkout develop
git pull origin develop
git checkout -b release/1.0.0

# Prepare release (version bump, changelog)...

git add .
git commit -m "release: v1.0.0"
git push -u origin release/1.0.0

# Create PR: release/1.0.0 → main
# After merge, tag: git tag v1.0.0
# Then merge main → develop
```

---

## Commit Message Convention

```
<type>: <description>

Types:
- feat:     New feature
- fix:      Bug fix
- hotfix:   Urgent fix
- docs:     Documentation
- refactor: Code refactoring
- test:     Tests
- chore:    Maintenance
```

---

## Enforcement

### Pre-commit Hook
- Validates branch naming
- Checks commit message format
- Validates memory system

### CI/CD
- Blocks direct push to main/develop
- Requires PR approval
- Runs all validations

---

**Last Updated**: $(date +%Y-%m-%d)
GITFLOW_EOF

    log_success "Created GITFLOW.md"

    # Configure git hooks path
    git config core.hooksPath .githooks
    log_success "Configured git hooks path"

    log_info "Gitflow documentation ready"
}

# ============================================================================
# GENERATE CLAUDE.MD
# ============================================================================

generate_claude_md() {
    log_step 7 "Generating CLAUDE.md"

    local current_date=$(date +%Y-%m-%d)
    local current_week=$(date +%Y-W%V)

    cat > CLAUDE.md << CLAUDE_EOF
# CLAUDE.md - ${PROJECT_NAME}

**Project**: ${PROJECT_NAME}
**Description**: ${PROJECT_DESCRIPTION}
**Version**: 0.1.0
**Last Updated**: ${current_date}

---

## Project Overview

### Mission
${PROJECT_DESCRIPTION}

### Current Phase
**Initial Setup** - Project infrastructure and memory system configured

### Key Metrics
- Phase: Initial Setup
- Memory System: Configured
- GitHub: Connected
- CI/CD: Active
- Stacks: Not yet decided (discuss with AI)

---

## Project Structure

\`\`\`
/${PROJECT_NAME}/
├── CLAUDE.md (this file) - Read this first
├── GITFLOW.md - Branching strategy (enforced)
├── RULES.md - Zero tolerance rules
├── Makefile - Unified project management
│
├── memory/
│   ├── NOW.md - Current state (start here every session)
│   ├── FIND.md - How to find information
│   ├── timeline/ (Weekly logs, monthly summaries)
│   ├── decisions/ (Decision records with rationale)
│   └── archive/ (Old logs after 3 months)
│
├── refs/ (Project References - PRD, Stack, Dependencies)
│   ├── PROJECT-CONTEXT.md - Project context (read every session)
│   ├── prd/ - Product Requirements Documents
│   ├── stack/ - Technology stack decisions (LOCKED after decision)
│   │   ├── STACK-DECISION.md - Final decision (no changes)
│   │   └── STACK-RESEARCH.md - AI research results
│   ├── dependencies/ - Dependency versions (LOCKED after decision)
│   │   ├── VERSIONS.lock.md - Version lock (no changes)
│   │   ├── UPGRADE-LOG.md - Upgrade history
│   │   └── docs-cache/ - Context7 documentation cache
│   └── research/ - AI research materials
│
├── docs/
│   └── {topics}/ (Project documentation)
│
├── scripts/
│   ├── validate-memory.sh - Validate memory system
│   ├── count-tokens.py - Count token usage
│   └── archive-old-logs.sh - Archive old logs
│
├── .githooks/ (Git hooks - auto validation)
└── .github/workflows/ (CI/CD)
\`\`\`

---

## Stack Decision Process

**IMPORTANT**: Stacks are NOT pre-created. Follow this process:

1. **Discuss with AI** - Describe your project requirements
2. **AI Research** - AI researches and recommends appropriate stack
3. **User Decision** - You approve the recommended stack
4. **AI Creates Stack** - AI creates the stack with:
   - All necessary files and configurations
   - healthz/readyz endpoints for deployment readiness
   - Docker Compose integration
   - Makefile targets for unified management

### Available Stack Templates

| Stack | Description |
|-------|-------------|
| backend/api | FastAPI + PostgreSQL + Redis + SQLAlchemy |
| backend/ai | AI/ML Inference Service |
| frontend/web | React + Vite + TypeScript + Tailwind |
| mobile/app | Expo (React Native) |
| infra | PostgreSQL, Redis, Prometheus, Grafana, Mailhog |

### After Stack Creation

All services will be manageable via:

\`\`\`bash
make up              # Start all services
make down            # Stop all services
make logs            # View logs
make test            # Run tests
make build           # Build all services
make deploy          # Deploy (when configured)
\`\`\`

---

## Git Workflow (AI MUST Follow)

**CRITICAL**: User does NOT touch Git. AI handles ALL Git operations.

### Branch Strategy (Enforced)

\`\`\`
main      - Production (NEVER commit directly)
develop   - Integration (NEVER commit directly)
feature/* - New features (from develop)
bugfix/*  - Bug fixes (from develop)
hotfix/*  - Urgent fixes (from main)
release/* - Release prep (from develop)
\`\`\`

### Commit Message Format (REQUIRED)

\`\`\`
<type>: <short description>

## What
- Detailed description of what was done

## Why
- Reason for this change

## Files Changed
- file1.ext: description
\`\`\`

---

## How to Work with This Project

### Every Session Start

1. **Read memory/NOW.md first** (~1,200 tokens)
2. **Read refs/PROJECT-CONTEXT.md** (~500 tokens)
3. **If stack exists**: Check refs/stack/STACK-DECISION.md

### After Making Changes

1. **Update memory/NOW.md**
2. **Log in weekly timeline** (memory/timeline/${current_week}.md)
3. **Create decision record if significant**

---

## Context7 MCP - Official Documentation (Preferred)

**Context7 MCP is PREFERRED for stack decisions.** Always try Context7 first.

- Context7 + cache = query once, reuse = saves tokens (OPTIMAL)
- If unavailable: Notify user, use web search fallback
- Cache location: refs/dependencies/docs-cache/{dependency}/

→ Detailed Guide: [refs/dependencies/CONTEXT7-GUIDE.md](refs/dependencies/CONTEXT7-GUIDE.md)

---

## Key Documentation Locations

→ [memory/NOW.md](memory/NOW.md) - Current state (START HERE)
→ [memory/FIND.md](memory/FIND.md) - How to find info
→ [refs/PROJECT-CONTEXT.md](refs/PROJECT-CONTEXT.md) - Project context
→ [refs/stack/STACK-DECISION.md](refs/stack/STACK-DECISION.md) - Tech stack (LOCKED after decision)
→ [GITFLOW.md](./GITFLOW.md) - Branching rules
→ [RULES.md](./RULES.md) - Validation rules

---

**CLAUDE.md Version**: 1.0.0
**Last Updated**: ${current_date}

---

**Remember**: This file is your orientation guide. Start every session with [memory/NOW.md](memory/NOW.md).
CLAUDE_EOF

    log_success "Generated CLAUDE.md"
}

# ============================================================================
# SETUP GITHUB REMOTE AND PUSH
# ============================================================================

setup_github_remote() {
    log_step 8 "Connecting to GitHub"

    # Add remote if not exists
    if ! git remote get-url origin &> /dev/null; then
        git remote add origin "$GITHUB_REPO_URL"
        log_success "Added remote: origin → $GITHUB_REPO_URL"
    else
        local current_remote=$(git remote get-url origin)
        if [[ "$current_remote" != "$GITHUB_REPO_URL" ]]; then
            git remote set-url origin "$GITHUB_REPO_URL"
            log_success "Updated remote: origin → $GITHUB_REPO_URL"
        else
            log_info "Remote already set: $GITHUB_REPO_URL"
        fi
    fi

    # Create initial commit with all files (CLAUDE.md, GITFLOW.md, memory templates)
    log_info "Creating initial commit with all project files..."

    git add .

    # Create the initial commit with all files
    # Use --no-verify because this is the initial setup (protected files are expected)
    git commit --no-verify -m "chore: initialize project with memory system

## What
- Set up project memory system (v2.0.0)
- Configure gitflow branching (main, develop)
- Add automation scripts and git hooks
- Add GitHub Actions for CI/CD
- Add CLAUDE.md, GITFLOW.md, RULES.md

## Why
- Establish project infrastructure
- Enable AI-assisted development workflow

## Files Changed
- memory/: Memory system templates
- refs/: Project references and stack templates
- scripts/: Automation scripts
- .github/: CI/CD workflows
- .githooks/: Git hooks

Project: ${PROJECT_NAME}
Description: ${PROJECT_DESCRIPTION}
" || {
        log_warning "Nothing to commit or commit failed"
    }

    log_success "Initial commit created"

    # Create develop branch from main (now that we have a commit)
    git branch -M main 2>/dev/null || true
    git checkout -b develop 2>/dev/null || git checkout develop
    log_success "Created branch: develop"

    # Go back to main for pushing
    git checkout main

    # Push to GitHub
    log_info "Pushing to GitHub..."

    # Push main
    git push -u origin main --force 2>/dev/null || git push -u origin main
    log_success "Pushed branch: main"

    # Push develop
    git push -u origin develop --force 2>/dev/null || git push -u origin develop
    log_success "Pushed branch: develop"

    # Go back to develop (default working branch)
    git checkout develop

    log_info "Branch protection enforced via:"
    log_info "  - AI rules (CLAUDE.md) - Never push to main/develop"
    log_info "  - Pre-commit hooks - Blocks direct commits locally"
    log_info "  - GitHub Actions - Validates all PRs"
    log_success "Protection configured (AI-enforced)"
}

# ============================================================================
# PRINT SUMMARY
# ============================================================================

print_summary() {
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║${NC}  ${BOLD}Project Initialization Complete!${NC}                           ${GREEN}║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    echo -e "${BOLD}Project Details:${NC}"
    echo -e "  Name:        ${GREEN}$PROJECT_NAME${NC}"
    echo -e "  Path:        ${GREEN}$PROJECT_PATH${NC}"
    echo -e "  GitHub:      ${GREEN}$GITHUB_REPO_URL${NC}"
    echo -e "  Visibility:  ${GREEN}$GITHUB_VISIBILITY${NC}"
    echo ""

    echo -e "${BOLD}Branches:${NC}"
    echo -e "  ${GREEN}main${NC}     - Production (protected)"
    echo -e "  ${GREEN}develop${NC}  - Integration (protected)"
    echo -e "  Current: $(git branch --show-current)"
    echo ""

    echo -e "${BOLD}Files Created:${NC}"
    echo -e "  ${GREEN}CLAUDE.md${NC}                  - AI assistant guide"
    echo -e "  ${GREEN}GITFLOW.md${NC}                 - Branching rules"
    echo -e "  ${GREEN}RULES.md${NC}                   - Zero tolerance rules"
    echo -e "  ${GREEN}memory/NOW.md${NC}              - Current state"
    echo -e "  ${GREEN}memory/FIND.md${NC}             - Search guide"
    echo -e "  ${GREEN}refs/PROJECT-CONTEXT.md${NC}    - Project context"
    echo -e "  ${GREEN}refs/stack/STACK-DECISION.md${NC} - Tech stack (to be decided)"
    echo ""

    echo -e "${BOLD}Automation:${NC}"
    echo -e "  ${GREEN}pre-commit hook${NC}  - Validates every commit"
    echo -e "  ${GREEN}CI/CD${NC}            - Validates every push/PR"
    echo -e "  ${GREEN}Auto-archive${NC}     - Weekly (Sundays)"
    echo ""

    echo -e "${BOLD}Next Steps:${NC}"
    echo -e "  1. ${CYAN}cd $PROJECT_PATH${NC}"
    echo -e "  2. Customize ${CYAN}refs/PROJECT-CONTEXT.md${NC} with project details"
    echo -e "  3. Discuss with AI to decide on the appropriate tech stack"
    echo -e "  4. AI will create the stack after your approval"
    echo -e "  5. Start working on ${CYAN}develop${NC} branch"
    echo ""

    echo -e "${BOLD}Quick Commands:${NC}"
    echo -e "  ${CYAN}git checkout -b feature/my-feature${NC}  # Start new feature"
    echo -e "  ${CYAN}./scripts/validate-memory.sh${NC}        # Validate memory"
    echo -e "  ${CYAN}gh pr create${NC}                        # Create pull request"
    echo ""

    echo -e "${BOLD}GitHub Repository:${NC}"
    echo -e "  ${CYAN}${GITHUB_REPO_URL%.git}${NC}"
    echo ""

    echo -e "${GREEN}Happy coding!${NC}"
    echo ""
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    print_banner

    check_prerequisites
    collect_project_info
    create_github_repo
    setup_project_directory
    apply_templates
    setup_gitflow
    generate_claude_md
    setup_github_remote
    print_summary
}

# Run main
main "$@"
