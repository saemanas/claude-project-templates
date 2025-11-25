# Quick Start Guide - 5 Minutes to Launch

**Time Required**: 5 minutes
**Prerequisites**: Git, GitHub CLI (gh) installed, GitHub account

---

## Choose Your Setup Path

| Scenario | Script | Description |
|----------|--------|-------------|
| **New Project** | `./scripts/init-project.sh` | Create new project with GitHub repo |
| **Existing Project** | `./scripts/apply-to-existing.sh /path` | Apply to existing project |

---

## Step 0: Claude Code Auto-Approve Setup (Optional but Recommended)

Claude Code asks for permission on every shell command by default. For smooth AI-driven development, configure auto-approve:

### Global Setting (All Projects)

Edit `~/.claude/settings.json`:

```json
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
```

### Project-Only Setting (Recommended)

Create `.claude/settings.local.json` in your project root:

```json
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
```

> **Note**: Local settings (`.claude/settings.local.json`) override global settings (`~/.claude/settings.json`). If you approved commands individually in a session, they get saved to local settings with specific patterns, which then override your global `Bash(*)` wildcard. Use the full config above to fix this.

### GitHub CLI Permissions (Recommended)

Grant full permissions for seamless AI-driven development:

```bash
# All permissions at once (recommended)
gh auth refresh -h github.com -s repo,delete_repo,admin:public_key,write:org,read:org,gist,workflow,admin:org_hook
```

Or add individually as needed:

| Permission | Command | Use Case |
|------------|---------|----------|
| `delete_repo` | `gh auth refresh -s delete_repo` | Delete test repositories |
| `workflow` | `gh auth refresh -s workflow` | Manage GitHub Actions |
| `admin:public_key` | `gh auth refresh -s admin:public_key` | Manage SSH keys |
| `write:org` | `gh auth refresh -s write:org` | Manage organization settings |
| `admin:org_hook` | `gh auth refresh -s admin:org_hook` | Manage organization webhooks |

> **Note**: Auto-approve settings are per-user. They cannot be distributed via templates for security reasons.

---

## Step 1: Run Init Script (1 minute)

```bash
# Navigate to PICSO templates
cd /path/to/claude-project-templates

# Run complete initialization
./scripts/init-project.sh
```

**What this does**:
- Checks prerequisites (git, gh, Python)
- Creates GitHub repository
- Applies memory system templates
- Sets up Gitflow (main/develop branches)
- Configures git hooks and CI/CD
- Generates CLAUDE.md automatically
- Optionally adds IT development stack

---

## Step 2: Follow Interactive Prompts (2 minutes)

The script will ask for the following:

```
1. Project name: my-project
2. Project description: A cool project
3. Project path: /Users/you/projects/my-project
4. GitHub visibility: 1 (Public) or 2 (Private)
5. GitHub organization: (Enter for personal account)
6. Add IT development stack?: y/n
   - Backend API (FastAPI)
   - Backend AI(ML) (Inference Service)
   - Frontend Web (React + Vite)
   - Mobile App (Expo)
```

**When IT Stack is selected**:
- Docker Compose environment setup
- Frontend (React + Vite)
- Backend (FastAPI + Python)
- Database (PostgreSQL)
- Cache (Redis)
- Monitoring (Prometheus + Grafana)

---

## Step 3: Define Project Context (2 minutes)

### 3.1 refs/PROJECT-CONTEXT.md (Required - Discuss with AI(You) first)

```markdown
# Project Context

## Mission
{Project goal - one sentence}

## Target Users
{Target users}

## Key Features
1. {Core feature 1}
2. {Core feature 2}

## Constraints
- Budget: Free tools only
- Platform: Mac (ARM + Intel)

## Non-Negotiables
- {Items that must never change}
```

### 3.2 Write PRD (Discuss with AI(You))

Discuss project requirements with AI(You) to write `refs/prd/PRD-001-overview.md`.

### 3.3 Decide Tech Stack (AI(You) Research then Discussion)

1. AI(You) writes research results in `refs/stack/STACK-RESEARCH.md`
2. Discuss and finalize with user
3. Write `refs/stack/STACK-DECISION.md` (LOCKED)
4. Write `refs/dependencies/VERSIONS.lock.md` (LOCKED)

### 3.4 memory/NOW.md (Required)

Open `memory/NOW.md` and update:

```markdown
# Current Project State

**Updated**: 2025-11-26 14:00  <!-- TODO: Current date/time -->
**Phase**: MVP Development     <!-- TODO: Your phase name -->
**Lines**: 50/300

---

## Status Dashboard

### Backend                    <!-- TODO: Your component 1 -->
- **Total**: 5 endpoints       <!-- TODO: Your metric -->
- **Status**: In progress      <!-- TODO: Your status -->
- **Detail**: [docs/api/README.md](../docs/api/README.md)

### Frontend                   <!-- TODO: Your component 2 -->
- **Total**: 10 components
- **Status**: Design complete
- **Detail**: [docs/frontend/README.md](../docs/frontend/README.md)

<!-- Add 2-5 components for your project -->
```

### 3.5 Create docs/ Structure

```bash
# Create your topic directories
mkdir -p docs/api
mkdir -p docs/database
mkdir -p docs/frontend
# Add directories for your project's topics
```

---

## Step 4: Start Development (AI(You)-Driven)

**IMPORTANT**: AI(You) handles all Git operations. User does not use Git directly.

### Development Principles

1. **Spec-Driven Development** (Core)
   - PRD → Tech Stack Decision → Implementation
   - Manage all specs in refs/

2. **Test-Driven Development** (Branch)
   - Write tests first
   - Verify tests pass after implementation

### Git Operations Handled by AI(You)

```bash
# AI(You) executes automatically
git checkout develop
git checkout -b feature/my-feature
# ... work ...
git add .
git commit -m "feat: description

## What
- Change 1
- Change 2

## Why
- Reason

## Files Changed
- file1.py: description"
git push -u origin feature/my-feature
gh pr create --base develop --title "feat: description"
```

---

## Step 5: Verify Setup

### Check validation
```bash
./scripts/validate-memory.sh
```

### Check token usage
```bash
python3 scripts/count-tokens.py --report
```

### Verify GitHub Actions
- Go to your GitHub repo → Actions tab
- You should see "Memory System Validation" workflow

---

## You're Done!

### Daily Usage

**Session Start**:
```
Files AI(You) should read:
1. memory/NOW.md (current state)
2. refs/PROJECT-CONTEXT.md (project context)
3. refs/stack/STACK-DECISION.md (tech stack - LOCKED)
```

**After Work**:
```
Files AI(You) should update:
1. memory/NOW.md (status update)
2. memory/timeline/YYYY-Wnn.md (work log)
```

**When Making Important Decisions**:
```
Files AI(You) should create:
1. memory/decisions/DEC-nnn-title.md
2. Update memory/decisions/INDEX.md
```

**When Requesting Stack Changes**:
```
User: "I want to change the stack"
AI: Provides impact analysis
User: Approves
AI: Updates refs/stack/STACK-DECISION.md + records DEC
```

### Automated Features

| Feature | Trigger | Action |
|---------|---------|--------|
| Pre-commit validation | Every commit | Blocks if rules violated |
| CI/CD validation | Every push | Validates on GitHub |
| Auto-archive | Weekly (Sunday) | Archives old logs |
| Weekly report | Weekly (Friday) | Generates token report |

---

## Quick Reference

### Line Limits (Zero Tolerance)

| File | Max Lines |
|------|-----------|
| memory/NOW.md | 300 |
| memory/FIND.md | 200 |
| Weekly log | 500 |
| Decision record | 500 |
| Topic README | 100 |

### Commands

```bash
# Validate memory system
./scripts/validate-memory.sh

# Check with strict mode
./scripts/validate-memory.sh --strict

# Count tokens
python3 scripts/count-tokens.py --report

# Archive old logs manually
./scripts/archive-old-logs.sh --dry-run
./scripts/archive-old-logs.sh
```

---

## Troubleshooting

### "Pre-commit hook failed"
→ Check which file exceeded line limit
→ Split or archive content

### "Validation script not found"
```bash
chmod +x scripts/*.sh
```

### "GitHub Action failed"
→ Check Actions tab for error details
→ Usually line limit or missing file

### "Token count too high"
→ Move detailed content to docs/
→ Keep NOW.md summary only

---

## Next Steps

1. Read [RULES.md](./RULES.md) for zero-tolerance rules
2. Read [README.md](./README.md) for full documentation
3. Start discussing project requirements with AI!

---

## IT Stack Commands (If Selected)

```bash
# Start all services
docker compose up -d

# View logs
docker compose logs -f

# Stop all services
docker compose down

# Service URLs
# Frontend:  http://localhost:3000
# Backend:   http://localhost:8000
# API Docs:  http://localhost:8000/docs
# Grafana:   http://localhost:3001 (admin/admin)
# Mailhog:   http://localhost:8025
```

---

## LOCKED Files (No Changes Allowed)

| File | Purpose | Change Process |
|------|---------|----------------|
| `refs/base/**/*` | Original Materials | **READ-ONLY - NEVER modify or delete** |
| `refs/stack/STACK-DECISION.md` | Tech Stack | User request → AI(You) analysis → Approval → Change |
| `refs/dependencies/VERSIONS.lock.md` | Dependency Versions | User request → AI(You) analysis → Approval → Change |

---

## Applying to Existing Project

For projects with existing files (e.g., `refs/` already exists):

```bash
# From template directory
./scripts/apply-to-existing.sh /path/to/existing/project
```

**What happens**:
1. Existing `refs/` content moves to `refs/base/` (READ-ONLY)
2. Template structure is applied
3. Original files are **preserved, never deleted**

### refs/base/ Rules (STRICTLY ENFORCED)

| Action | Allowed |
|--------|---------|
| Read files for context | ✓ YES |
| Reference in PRD/decisions | ✓ YES |
| Quote content in new documents | ✓ YES |
| **Edit any file** | ✗ **NEVER** |
| **Delete any file** | ✗ **NEVER** |
| **Rename or move files** | ✗ **NEVER** |

> **AI(You) Violation Response**: If modification is attempted, STOP immediately and report to user.

---

**Setup complete in 5 minutes!**
