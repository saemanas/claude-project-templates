# Project Memory System - Templates

> Token-efficient project memory system with GitHub integration, Gitflow enforcement, and full automation

| Version | Last Updated | Status |
|---------|--------------|--------|
| 2.1.0 | 2025-11-26 | Stable |

---

## One-Command Project Setup

```bash
# Clone this template repository first
git clone <this-repo-url> project-memory-templates
cd project-memory-templates

# Run interactive project initialization
./scripts/init-project.sh
```

**That's it!** The script will:
1. Check prerequisites (git, gh CLI, permissions)
2. Collect project information interactively
3. **Ask for confirmation** before creating GitHub repository
4. **Ask public/private** preference
5. Apply all templates automatically
6. Setup Gitflow branches (main, develop)
7. Configure git hooks and CI/CD
8. Generate CLAUDE.md (project-specific)
9. Create initial commit and push
10. Validate everything

---

## What's This?

This is a **complete, automated project memory system** that:

- Reduces token usage by **87%** (~2,600 vs 20,000+ tokens per session)
- **Enforces rules automatically** via Git hooks and CI/CD
- **Tracks ALL files** via Git (source of truth)
- **Enforces Gitflow** branching strategy
- **Docker-first development** (no venv/virtualenv)
- **Makefile-driven workflows** (standardized commands)
- Maintains complete project history with **zero information loss**
- Scales from 1-week to 5+ year projects
- Works for any project type (software, research, business, content)

---

## Requirements

| Requirement | Status | Install |
|-------------|--------|---------|
| Git | **Required** | `brew install git` |
| GitHub CLI (`gh`) | **Required** | `brew install gh` |
| Docker & Docker Compose | **Required** | `brew install docker` |
| GNU Make | **Required** | Pre-installed on macOS/Linux |
| GitHub Account (Free) | **Required** | github.com |
| Python 3 | Optional (scripts) | `brew install python3` |
| tiktoken | Optional | `pip3 install tiktoken` |

### GitHub Free Plan

This system works with **GitHub Free** (Public or Private):

| Feature | How It Works |
|---------|--------------|
| Branch Protection | **AI-enforced** (CLAUDE.md rules) |
| Pre-commit Hooks | **Local enforcement** (blocks bad commits) |
| GitHub Actions | **Remote validation** (2,000 min/month) |
| PR Validation | **CI/CD checks** (blocks bad PRs) |

**Note**: AI(You) handles ALL Git operations. No manual Git needed.

### Quick Install (macOS)

```bash
# Core tools (required)
brew install git gh docker

# Optional (for scripts)
brew install python3
pip3 install tiktoken

# Authenticate with GitHub
gh auth login
```

### Quick Install (Linux)

```bash
# Core tools (required)
sudo apt install git make
# Docker: https://docs.docker.com/engine/install/
# GitHub CLI: https://github.com/cli/cli/blob/trunk/docs/install_linux.md

# Optional (for scripts)
sudo apt install python3 python3-pip
pip3 install tiktoken

# Authenticate
gh auth login
```

---

## What's Included

```
claude-project-templates/
├── README.md                  # This file
├── QUICKSTART.md              # 5-minute manual guide
├── RULES.md                   # Zero-tolerance rules
├── CLAUDE-TEMPLATE.md         # AI assistant guide template
│
├── memory/                    # Memory system templates
│   ├── NOW-TEMPLATE.md        # Session ID + current state
│   ├── FIND-TEMPLATE.md       # Project structure map
│   ├── archive/.gitkeep
│   ├── timeline/
│   │   ├── YYYY-Wnn-TEMPLATE.md
│   │   └── YYYY-MM-SUMMARY-TEMPLATE.md
│   └── decisions/
│       ├── INDEX-TEMPLATE.md
│       └── DEC-nnn-TEMPLATE.md
│
├── refs/                              # Reference documents
│   ├── PROJECT-CONTEXT-TEMPLATE.md    # Project overview
│   ├── base/                          # Original materials (READ-ONLY)
│   ├── prd/PRD-TEMPLATE.md            # Product requirements
│   ├── stack/                         # Tech stack decisions
│   ├── dependencies/                  # Version locks
│   └── index/INDEX-TEMPLATE.md        # Auto-generated component index
│
├── docs/example-topic/
│   └── README-TEMPLATE.md
│
├── scripts/                           # Automation
│   ├── init-project.sh                # ONE-COMMAND SETUP
│   ├── apply-to-existing.sh           # Apply to existing project
│   ├── validate-memory.sh             # Validation + Session ID check
│   ├── count-tokens.py                # Token counter
│   ├── generate-index.sh              # Auto-index generator (NEW)
│   └── archive-old-logs.sh            # Archive manager
│
├── .githooks/                         # Local enforcement
│   ├── pre-commit                     # Blocks bad commits + memory sync
│   └── commit-msg                     # Message validation
│
├── .protected/                        # Core rules (never modify)
│   ├── CORE-RULES.md
│   └── MANIFEST.md
│
└── .github/workflows/                 # Remote enforcement
    ├── memory-validation.yml          # Validates on push
    ├── gitflow-check.yml              # Enforces Gitflow
    ├── protected-files.yml            # Blocks protected file changes
    ├── auto-archive.yml               # Weekly archive
    └── weekly-report.yml              # Friday reports
```

---

## Gitflow Branching (Enforced)

### Branch Structure

```
main (production) ──────────────────────────────────────────►
  │                                         ▲
  │                                         │ (PR only)
  └── develop (integration) ────────────────────────────────►
        │                                   ▲
        ├── feature/xxx ────────────────────┤ (PR only)
        ├── bugfix/xxx ─────────────────────┤
        ├── hotfix/xxx ─────────────────────┤ (also to main)
        └── release/x.x.x ──────────────────┘
```

### Rules (Enforced Automatically)

| Branch | Direct Commit | Allowed Sources |
|--------|---------------|-----------------|
| `main` | **BLOCKED** | release/*, hotfix/* via PR |
| `develop` | **BLOCKED** | feature/*, bugfix/* via PR |
| `feature/*` | Allowed | - |
| `bugfix/*` | Allowed | - |
| `hotfix/*` | Allowed | - |
| `release/*` | Allowed | - |

### Workflow

```bash
# Start new feature
git checkout develop
git checkout -b feature/add-login

# Work on feature...
git add .
git commit -m "feat: add login"  # Pre-commit validates!

# Push and create PR
git push -u origin feature/add-login
gh pr create --base develop  # CI/CD validates!
```

---

## Automated Enforcement Summary

| When | What | Enforcement |
|------|------|-------------|
| Every commit | Branch rules, line limits, memory sync | Pre-commit hook |
| Every commit | Component index auto-regeneration | Pre-commit hook |
| Every push/PR | All validations + Gitflow + protected files | GitHub Actions |
| Weekly (Sunday) | Archive old logs | Auto-archive workflow |
| Weekly (Friday) | Token report | Weekly report workflow |

### New in v2.1: Session Verification & Memory Sync

**Session ID Verification**: AI must read `memory/NOW.md` and state Session ID before any work.

**Memory Sync Enforcement**: Any file change requires `memory/` update (BLOCKED if missing).

**Auto-Index Generation**: Code changes trigger automatic `refs/index/INDEX.md` regeneration.

### Pre-commit Example

```bash
$ git checkout main
$ git commit -m "direct change"

══════════════════════════════════════════════════════════════
  Pre-commit Validation
══════════════════════════════════════════════════════════════

[Gitflow] Checking branch rules...
[BLOCKED] Direct commits to 'main' are not allowed

  Create a branch instead:
    git checkout -b feature/my-feature
    git checkout -b hotfix/urgent-fix

COMMIT BLOCKED: 1 error(s)
```

---

## Zero Tolerance Rules

| File | Max Lines | Token Budget |
|------|-----------|--------------|
| `memory/NOW.md` | **150** | ~600 |
| `memory/FIND.md` | **100** | ~400 |
| `refs/PROJECT-CONTEXT.md` | **100** | ~400 |
| `CLAUDE.md` | **300** | ~1,200 |
| `refs/prd/*.md` | **300** | ~1,200 |
| Weekly log | **300** | ~1,200 |
| Decision record | **300** | ~1,200 |
| Topic README | **100** | ~400 |

> Session start total: ~2,600 tokens

See **[RULES.md](./RULES.md)** for complete details.

---

## Commands Reference

### Project Setup

```bash
# Interactive setup (recommended)
./scripts/init-project.sh

# Manual setup
./scripts/setup.sh --github-url https://github.com/user/repo.git
```

### Development Environment (Docker + Make)

```bash
# Start all services
cd stacks && make up

# View logs
make logs

# Run tests
make test

# Access shell
make shell-backend   # Python/FastAPI
make shell-frontend  # Node/React
make shell-db        # PostgreSQL
make shell-cache     # Redis

# Stop services
make down

# Clean everything
make clean
```

### Daily Development

**⚠️ NEVER work on main/develop directly! Always use feature branches.**

```bash
# Start environment
cd stacks && make up

# Create feature branch (REQUIRED)
git checkout develop
git pull origin develop
git checkout -b feature/my-feature  # IMMEDIATELY create branch

# Verify you're on feature branch
git branch --show-current  # Must show "feature/my-feature"

# Make changes (Docker auto-reloads)
# ...

# Run tests
make test

# Commit (auto-validated)
git commit -m "feat: description"

# Create PR
git push -u origin feature/my-feature
gh pr create --base develop
```

### Validation

```bash
./scripts/validate-memory.sh          # Basic
./scripts/validate-memory.sh --strict # Strict
python3 scripts/count-tokens.py --report
```

### Commit Message Format

```
<type>: <description>

Types:
  feat     New feature
  fix      Bug fix
  hotfix   Urgent fix
  docs     Documentation
  refactor Code refactoring
  test     Tests
  chore    Maintenance
```

---

## After Setup Complete

1. **Repository created** on GitHub (public/private)
2. **Branches ready**: main (production), develop (integration)
3. **You're on** `develop` branch
4. **Start working**:
   ```bash
   # Start development environment (Docker)
   cd stacks
   make up

   # Create feature branch
   git checkout -b feature/first-feature

   # Make changes (Docker auto-reloads)
   # ...

   # Run tests
   make test

   # Commit and create PR
   git commit -m "feat: first feature"
   gh pr create --base develop
   ```

5. **Every AI(You) session**:
   ```
   "Read memory/NOW.md"
   ```

6. **Development workflow**:
   - All code runs in Docker containers
   - Use `make` commands for common tasks
   - No venv/virtualenv needed

---

## Troubleshooting

### "gh: command not found"
```bash
# macOS
brew install gh

# Then authenticate
gh auth login
```

### "gh auth" fails
```bash
gh auth login --web
```

### Pre-commit not running
```bash
git config core.hooksPath .githooks
chmod +x .githooks/*
```

### "Permission denied"
```bash
chmod +x scripts/*.sh scripts/*.py .githooks/*
```

---

## Version History

### v2.1.0 (2025-11-26)

- **Session ID verification** - AI must state Session ID from NOW.md
- **Memory sync enforcement** - All file changes require memory update (BLOCKED)
- **Auto-index generation** - `refs/index/INDEX.md` auto-regenerates on code changes
- **Protected files workflow** - GitHub Action blocks protected file modifications
- **Enhanced pre-commit** - Memory sync check + index regeneration
- **FIND.md expansion** - 50 → 100 lines, Project Structure section added
- **Token budget adjustment** - 2,400 → 2,600 tokens (87% reduction)

### v2.0.0 (2025-11-26)

- **One-command setup** (`init-project.sh`)
- **Gitflow enforcement** (pre-commit + CI/CD)
- **GitHub CLI integration** (required)
- Interactive project configuration
- Auto-validation and auto-archive

### v1.0.0 (2025-11-26)

- Initial release
- Manual setup only

---

## License

Free for any purpose. Attribution optional but appreciated.
