# CLAUDE.md - {PROJECT_NAME}

**Project**: {PROJECT_NAME}
**Description**: {PROJECT_DESCRIPTION}
**Domain**: {INDUSTRY/DOMAIN}
**Version**: {CURRENT_VERSION}
**Last Updated**: {YYYY-MM-DD}

---

## Project Overview

### Mission
{Brief description of what this project aims to achieve}

### Current Phase
**{PHASE_NAME}** - {Brief phase description}

### Key Metrics
- {METRIC_1}: {VALUE}
- {METRIC_2}: {VALUE}
- {METRIC_3}: {VALUE}
- Target: {COMPLETION_TARGET}

---

## Project Structure

```
/{PROJECT_ROOT}/
├── CLAUDE.md (this file) - Read this first
├── PROJECT_MEMORY_TEMPLATE.md (Universal template reference)
│
├── memory/
│   ├── NOW.md - Current state (start here every session)
│   ├── FIND.md - How to find information
│   ├── timeline/ (Weekly logs, monthly/quarterly summaries)
│   ├── decisions/ (Decision records with rationale)
│   └── archive/ (Old logs after 3 months)
│
├── docs/
│   ├── {topic-1}/ ({Description})
│   ├── {topic-2}/ ({Description})
│   ├── {topic-3}/ ({Description})
│   └── {topic-n}/ ({Description})
│
└── refs/ (Project References - Project context, PRD, Tech stack)
    ├── PROJECT-CONTEXT.md - Project context (read every session)
    ├── base/              READ-ONLY - Original project materials
    │   └── {preserved}/   (NEVER modify or delete!)
    ├── prd/               (Product Requirements Documents)
    ├── stack/             LOCKED - Tech stack decisions
    │   ├── STACK-DECISION.md   (Final decision - no changes)
    │   └── STACK-RESEARCH.md   (AI(You) research results)
    ├── dependencies/      LOCKED - Dependency versions
    │   ├── VERSIONS.lock.md    (Version lock - no changes)
    │   └── UPGRADE-LOG.md      (Upgrade history)
    └── research/          (AI(You) research materials)
```

---

## Git Workflow (AI(You) MUST Follow)

**IMPORTANT**: User does NOT touch Git. AI(You) handles ALL Git operations.

### Branch Strategy (Enforced)

```
main      - Production (NEVER commit directly)
develop   - Integration (NEVER commit directly)
feature/* - New features (from develop)
bugfix/*  - Bug fixes (from develop)
hotfix/*  - Urgent fixes (from main)
release/* - Release prep (from develop)
```

### Before Starting Any Work

**CRITICAL**: NEVER work on main or develop branches directly!

```bash
# 1. Always start from develop
git checkout develop
git pull origin develop

# 2. IMMEDIATELY create feature branch (do NOT work on develop!)
git checkout -b feature/{short-description}
# or: bugfix/{issue-description}
# or: hotfix/{urgent-fix}

# 3. Verify you're on feature branch
git branch --show-current  # Must show feature/*, NOT main or develop
```

**If you accidentally started work on main/develop**:
```bash
# Save your work
git stash

# Create feature branch
git checkout -b feature/my-work

# Restore your work
git stash pop
```

### Commit Message Format (REQUIRED)

Every commit MUST follow this format for human developers to understand:

```
<type>: <short description>

## What
- Detailed description of what was done
- List each change

## Why
- Reason for this change
- Related decision: DEC-nnn (if applicable)

## Files Changed
- file1.ext: description of change
- file2.ext: description of change
```

**Valid types**: `feat`, `fix`, `hotfix`, `docs`, `refactor`, `test`, `chore`

### Example Commit

```
feat: add user authentication system

## What
- Implemented JWT-based authentication
- Added login/logout API endpoints
- Created user session management
- Added password hashing with bcrypt

## Why
- Users need secure access to their data
- Required for Phase 2 features
- Decision: DEC-003

## Files Changed
- src/auth/jwt.py: JWT token generation and validation
- src/api/auth.py: Login/logout endpoints
- src/models/user.py: User model with password field
- memory/NOW.md: Updated authentication status
- memory/timeline/2025-W48.md: Logged implementation
```

### After Work is Complete

```bash
# 1. Stage all changes
git add .

# 2. Commit with detailed message (format above)
git commit -m "feat: description

## What
...

## Why
...

## Files Changed
..."

# 3. Push to remote
git push -u origin feature/{branch-name}

# 4. Create Pull Request
gh pr create --base develop --title "feat: description" --body "..."
```

### Pull Request Requirements

Every PR must include:
- [ ] Summary of changes
- [ ] What changed (detailed list)
- [ ] Why it changed
- [ ] Files changed with descriptions
- [ ] Memory system updated
- [ ] All checks passing

---

## AI Commit/Merge Protocol (MANDATORY)

❌ NEVER commit without showing content to user first
❌ NEVER merge PR without explicit user approval
❌ NEVER assume silence = approval

✅ Create/Edit → Show content → Wait for approval → Commit
✅ Create PR → Show link → Wait for approval → Merge

**Detail**: [RULES.md Section 8](./RULES.md)

---

## Project References (refs/) - Tech Stack Management

### refs/base/ - Original Project Materials (CRITICAL)

> **refs/base/ is READ-ONLY. NEVER modify or delete any file in refs/base/**

When template is applied to an existing project, original materials are preserved in `refs/base/`:

| Action | Allowed |
|--------|---------|
| Read files for context | ✓ YES |
| Reference in PRD/decisions | ✓ YES |
| Quote content in new documents | ✓ YES |
| Edit any file | ✗ NEVER |
| Delete any file | ✗ NEVER |
| Rename or move files | ✗ NEVER |

**Violation Response**: If modification is attempted, STOP immediately and report to user.

### LOCKED Files (No Changes Allowed)

The following files are **LOCKED**. Never modify without explicit user request:

```
refs/base/**/*                     <- Original materials (READ-ONLY - NEVER modify)
refs/stack/STACK-DECISION.md       <- Tech stack decision (LOCKED)
refs/dependencies/VERSIONS.lock.md <- Dependency versions (LOCKED)
```

### Tech Stack Change Process

**When changes are needed, follow this process:**

1. **User must explicitly request**
   - "I want to change the stack" or "I want to use Vue instead of React"
   - Implicit requests are not processed

2. **AI(You) provides impact analysis**
   - Check current progress
   - Analyze affected files/code
   - Estimate migration cost
   - Present alternatives

3. **User final approval**
   - Confirm: "Should we proceed with the change?"
   - Change only after user responds "yes/proceed"

4. **Execute change and record**
   - Update refs/stack/STACK-DECISION.md
   - Update refs/dependencies/VERSIONS.lock.md
   - Record history in refs/dependencies/UPGRADE-LOG.md
   - Create memory/decisions/DEC-nnn.md
   - Update memory/NOW.md

### Stack Decision Workflow at Project Start

```
1. Write PRD (refs/prd/)
   └─ User defines requirements
   └─ AI(You) helps concretize

2. AI(You) Research (refs/stack/STACK-RESEARCH.md)
   └─ Research latest + stable technologies
   └─ Reference official docs, release notes
   └─ Must Have: Free/open source, Mac ARM+Intel, Docker compatible

3. Stack Discussion
   └─ AI(You) suggests options + pros/cons analysis
   └─ Discuss with user
   └─ Final decision

4. Lock Stack (refs/stack/STACK-DECISION.md)
   └─ Document decision
   └─ Set to LOCKED status
   └─ Maintain until change request
```

---

## How to Work with This Project

### Every Session Start

1. **Read memory/NOW.md first** (~1,200 tokens)
   - Get current state, active tasks, recent decisions
   - Understand what's blocked, what's in progress

2. **Read refs/PROJECT-CONTEXT.md** (~500 tokens)
   - Project mission, target users, core features
   - Constraints and non-negotiable items

3. **If you need specific information**:
   - Read memory/FIND.md (~600 tokens)
   - Follow links to relevant docs

4. **Before making changes**:
   - Check related decisions in memory/decisions/
   - Review current constraints
   - **For tech-related**: Check refs/stack/STACK-DECISION.md

### After Making Changes

1. **Update memory/NOW.md**:
   - Update status, metrics, active tasks
   - Add to "Completed" section

2. **Log in weekly timeline**:
   - Create entry in memory/timeline/YYYY-Wnn.md
   - Include: What, Why, How, Impact, Files changed

3. **Create decision record if significant**:
   - New file: memory/decisions/DEC-nnn-title.md
   - Update memory/decisions/INDEX.md

---

## Critical Constraints

### Development Environment (REQUIRED)
```
- venv/virtualenv/conda -> Use Docker only
- Local Python/Node install -> Use Docker containers
- Local package managers -> Use Docker + Makefile
+ Docker Compose (required)
+ Makefile for commands (required)
+ Gitflow (git + gh CLI)
```

**Why**:
- Consistent environment across all developers
- No "works on my machine" issues
- Simplified onboarding (just Docker + Make)
- All dependencies containerized

**Tools Required**:
- Docker & Docker Compose
- GNU Make
- Git & GitHub CLI (gh)

### {CONSTRAINT_CATEGORY_1}
```
- {CONSTRAINT_1} -> {ALTERNATIVE}
- {CONSTRAINT_2} -> {ALTERNATIVE}
+ {ALLOWED_APPROACH_1}
+ {ALLOWED_APPROACH_2}
```

**Why**: {RATIONALE}

**Decision**: [DEC-nnn](memory/decisions/DEC-nnn-title.md)

### {CONSTRAINT_CATEGORY_2}
```
- {CONSTRAINT_1} -> {ALTERNATIVE}
+ {ALLOWED_APPROACH_1}
```

**Why**: {RATIONALE}

### File Management Rules
```
+ All management files: 500 lines max
+ NOW.md: 300 lines max
+ FIND.md: 200 lines max
+ Topic README: 100 lines max
```

**Why**: Token efficiency (81% reduction proven)

### {PROJECT_SPECIFIC_CONSTRAINTS}
```
+ {REQUIREMENT_1}
+ {REQUIREMENT_2}
+ {REQUIREMENT_3}
```

---

## Key Documentation Locations

### Current State
-> [memory/NOW.md](memory/NOW.md) - Always start here

### How to Find Info
-> [memory/FIND.md](memory/FIND.md) - Search guide

### {Topic 1}
-> [docs/{topic-1}/README.md](docs/{topic-1}/README.md)
- {Subtopic 1}: [{filename}](docs/{topic-1}/{filename}.md)
- {Subtopic 2}: [{filename}](docs/{topic-1}/{filename}.md)

### {Topic 2}
-> [docs/{topic-2}/README.md](docs/{topic-2}/README.md)
- {Subtopic 1}: [{filename}](docs/{topic-2}/{filename}.md)

### {Topic 3}
-> [docs/{topic-3}/README.md](docs/{topic-3}/README.md)
- {Content description}

### {Implementation/Migration Plan (if applicable)}
-> [{PLAN_FILE}.md]({PLAN_FILE}.md)
- Phase 0: {Description}
- Phase 1: {Description}
- Phase 2: {Description}

### {External References (if applicable)}
-> [refs/external/](refs/external/)
-> [refs/internal/](refs/internal/)

### Version History (if applicable)
- v1.0.0: [refs/{path}/v1.0.0/](refs/{path}/v1.0.0/)
- v2.0.0: [refs/{path}/v2.0.0/](refs/{path}/v2.0.0/)
- {CURRENT_VERSION}: Current (in docs/)

---

## Common Tasks

### "Start Development Environment"
```bash
# Start all services
make up

# Check service health
make healthcheck

# View logs
make logs

# View specific service logs
make logs SERVICE=backend
```

### "Run Tests"
```bash
# Run all tests (in Docker)
make test

# Run backend tests only
make test-backend

# Run frontend tests only
make test-frontend
```

### "Access Service Shell"
```bash
# Backend Python shell
make shell-backend

# Frontend Node shell
make shell-frontend

# Database psql
make shell-db

# Redis CLI
make shell-cache
```

### "Add New Feature (Full Workflow)"
1. Read [memory/NOW.md](memory/NOW.md) for current state
2. Start environment: `make up`
3. Create feature branch: `git checkout -b feature/my-feature`
4. Make changes in code (Docker auto-reloads)
5. Test: `make test`
6. Commit with detailed message (see Git Workflow section)
7. Push: `git push -u origin feature/my-feature`
8. Create PR: `gh pr create --base develop`
9. Update [memory/NOW.md](memory/NOW.md)
10. Log in [memory/timeline/YYYY-Wnn.md](memory/timeline/YYYY-Wnn.md)

### "{Common Task 1}"
1. Read [memory/NOW.md](memory/NOW.md) for current state
2. Check {relevant location}: [docs/{topic}/README.md](docs/{topic}/README.md)
3. Read specific file (500 lines)
4. Make changes, update docs
5. Log in [memory/timeline/YYYY-Wnn.md](memory/timeline/YYYY-Wnn.md)
6. Update [memory/NOW.md](memory/NOW.md)

### "{Common Task 2}"
1. Check existing: [docs/{topic}/README.md](docs/{topic}/README.md)
2. Create new file: docs/{topic}/{filename}.md
3. {Task-specific steps}
4. Log in timeline
5. Update NOW.md

### "Make a significant decision"
1. Create: memory/decisions/DEC-nnn-title.md
2. Include: Context, Decision, Alternatives, Impact
3. Update: memory/decisions/INDEX.md
4. Update: memory/NOW.md -> "Recent Decisions"
5. Log in timeline

### "Review project history"
1. Check [memory/NOW.md](memory/NOW.md) for recent (30 days)
2. Check [memory/timeline/](memory/timeline/) for specific weeks
3. Check [memory/decisions/INDEX.md](memory/decisions/INDEX.md) for decisions

---

## Diagrams (if applicable)

All diagrams use Mermaid syntax for easy rendering:

- {Diagram 1}: [docs/diagrams/{name}.md](docs/diagrams/{name}.md)
- {Diagram 2}: [docs/diagrams/{name}.md](docs/diagrams/{name}.md)
- {Diagram 3}: [docs/diagrams/{name}.md](docs/diagrams/{name}.md)

---

## Working Principles

### 1. Single Source of Truth
- Each piece of information lives in ONE place only
- memory/NOW.md has summaries + links (not full content)
- Full content lives in docs/ or refs/

### 2. Token Efficiency
- Always read NOW.md first (1,200 tokens)
- Use FIND.md to locate specific info (600 tokens)
- Only read necessary docs (2,000 tokens each)
- Total: ~3,800 tokens per session (vs 20,000+ without system)

### 3. Lazy Loading
- Don't read everything upfront
- Load only what's needed for current task
- Trust the memory system to guide you

### 4. Keep History
- Never delete logs or decisions
- Archive old content (memory/archive/)
- Maintain full traceability

### 5. Update Actively
- Update NOW.md after every significant change
- Log all actions in weekly timeline
- Create decision records for important choices

---

## Protected System Files (IMMUTABLE)

### DO NOT MODIFY These Files

The following files are **LOCKED** and cannot be modified without explicit user request:

```
LOCKED (Never modify without explicit user request + acknowledgment):
├── .protected/*                      # Core rules and manifest
├── .githooks/*                       # Git hooks (pre-commit, commit-msg)
├── .github/workflows/*               # CI/CD automation
├── scripts/*                         # Automation scripts
├── RULES.md                          # Zero tolerance rules
├── GITFLOW.md                        # Gitflow documentation
├── refs/base/**/*                    # Original materials (READ-ONLY - NEVER modify)
├── refs/stack/STACK-DECISION.md      # Tech stack decision (change discussion needed)
└── refs/dependencies/VERSIONS.lock.md # Dependency versions (change discussion needed)
```

### Why These Files Are Protected

These files enforce:
- **81% token reduction** (3,800 vs 20,000+ tokens/session)
- **Zero information loss** over project lifetime
- **Automated rule enforcement** (pre-commit + CI/CD)
- **Gitflow compliance** (branch naming, merge rules)

**Modifying these files breaks the core system.**

### If Modification Is Needed

1. **User must explicitly request**: "Modify {filename}"
2. **User must acknowledge**: "I understand this affects the core system"
3. **Create system/* branch**: `git checkout -b system/update-{description}`
4. **Make changes**
5. **Update version** in affected files
6. **Create PR** with additional review required

### What Happens If You Try

- **Local (pre-commit)**: Commit BLOCKED with error message
- **Remote (CI/CD)**: PR BLOCKED unless from system/* branch
- **System branch**: Allowed but requires additional review

### Core Rules Reference

See [RULES.md](./RULES.md) for:
- Line limits (NOW.md: 300, FIND.md: 200, etc.)
- Token budgets (Session: 3,800 tokens max)
- Gitflow rules (main/develop protected)
- Naming conventions (YYYY-Wnn.md, DEC-nnn-title.md)

---

## Don't Do This

- Read all files at session start (waste tokens)
- Skip updating NOW.md (lose current state)
- Skip weekly log entries (lose history)
- Duplicate information across files (sync issues)
- Let files grow beyond line limits (token bloat)
- **Work on main/develop branches directly** (NEVER checkout main/develop for work)
- **Commit directly to main/develop** (always use feature/* branches)
- **Push directly to main/develop** (use Pull Requests only)
- **Use venv/virtualenv/conda** (Docker only!)
- **Install packages locally** (use Docker containers)
- **Run code outside Docker** (except Makefile commands)
- **Modify protected files** (.protected/, .githooks/, scripts/, RULES.md)
- **Bypass pre-commit hooks** (git commit --no-verify)
- **Modify or delete refs/base/** (READ-ONLY - original project materials)
- **Change STACK-DECISION.md/VERSIONS.lock.md** without user explicit request
- {PROJECT_SPECIFIC_DON'T_1}
- {PROJECT_SPECIFIC_DON'T_2}
- Change project structure without decision record

---

## Do This

- Start every session with NOW.md
- Use FIND.md to locate information
- Update NOW.md after changes
- Log actions in weekly timeline
- Create decision records for significant choices
- Keep files under line limits
- **Use Docker Compose for all development** (`make up`)
- **Use Makefile commands** for common tasks
- **Test in Docker containers** (`make test`)
- **Use Git + gh CLI** for version control
- {PROJECT_SPECIFIC_DO_1}
- {PROJECT_SPECIFIC_DO_2}
- Link between files (bidirectional)
- Archive old logs regularly

---

## Success Metrics

This project aims to achieve:

- {SUCCESS_METRIC_1}
- {SUCCESS_METRIC_2}
- {SUCCESS_METRIC_3}
- **80% reduction** in token usage (memory system)
- **100% recall** of decisions and rationale

---

## Troubleshooting

### "Can't find information"
-> Read [memory/FIND.md](memory/FIND.md)

### "Don't understand current state"
-> Read [memory/NOW.md](memory/NOW.md)

### "Need to understand a decision"
-> Check [memory/decisions/INDEX.md](memory/decisions/INDEX.md)

### "Need historical context"
-> Check [memory/timeline/](memory/timeline/) for specific week

### "File structure confusing"
-> Re-read this CLAUDE.md from the top

### "{PROJECT_SPECIFIC_ISSUE}"
-> {SOLUTION}

---

## Contact & Context

**User**: {USER_NAME} ({ROLE})
**Project Owner**: {OWNER}
**Language Preference**:
- Files/Code: {LANGUAGE_1}
- Explanations: {LANGUAGE_2}
- {Other context}: {LANGUAGE_3}

**Communication Style**:
- Be direct and concise
- Explain reasoning ("Why")
- Show implementation ("How")
- Reference files with line numbers when possible

---

## Version Control

**CLAUDE.md Version**: 1.0.0
**Last Updated**: {YYYY-MM-DD}
**Next Review**: When phase changes or major milestone

### Change Log
- {YYYY-MM-DD}: Initial version created
- (Future updates here)

---

## Additional Resources

### Templates
- [PROJECT_MEMORY_TEMPLATE.md](PROJECT_MEMORY_TEMPLATE.md) - Universal template guide
- [claude-project-templates/](claude-project-templates/) - Template files

### External References (if applicable)
- {RESOURCE_1}: {URL}
- {RESOURCE_2}: {URL}
- {RESOURCE_3}: {URL}

---

**Remember**: This file is your orientation guide. After reading this once, always start with [memory/NOW.md](memory/NOW.md) for current state.

**Token Cost**: ~2,500 tokens (this file)
**Read Frequency**: Once at project start, then reference as needed
