# CLAUDE.md - {PROJECT_NAME}

**Project**: {PROJECT_NAME}
**Version**: {VERSION}
**Updated**: {YYYY-MM-DD}
**Lines**: {CURRENT}/300

---

## Session Start (MANDATORY - Self-Verify)

```text
1. Read memory/NOW.md → Extract "Session ID" from file
2. Read memory/FIND.md → Know project structure
3. Read refs/PROJECT-CONTEXT.md → Note project phase
4. git branch --show-current → Verify not on main/develop
5. State: "Session [ID], Phase: [X], Branch: [Y]"
```

> **CRITICAL**: If you cannot state the Session ID from NOW.md, you have NOT read it.
> Do NOT proceed with any work until verification is complete.

---

## Auto-Actions (AI Does Automatically)

### On Every Change

| Trigger | Auto-Action |
|---------|-------------|
| Any file created/modified | Update memory/NOW.md |
| Code file changed | Log in memory/timeline/YYYY-Wnn.md |
| Important decision made | Create memory/decisions/DEC-nnn.md |
| Task completed | Mark in NOW.md, log in timeline |

### On Session End

```text
1. Update memory/NOW.md with current state
2. Ensure timeline has today's entries
3. Commit all changes (if approved)
```

---

## File Tracking (Git = Source of Truth)

### Query Commands (Use When Needed)

```bash
# All project files
git ls-files

# Recent changes
git diff --name-only HEAD~5

# Files in specific folder
git ls-files refs/

# What changed today
git log --since="today" --name-only --oneline
```

### Line Limits (Auto-Enforced)

| File | Max Lines | Token Budget |
|------|-----------|--------------|
| memory/NOW.md | 150 | 600 |
| memory/FIND.md | 100 | 400 |
| refs/PROJECT-CONTEXT.md | 100 | 400 |
| CLAUDE.md | 300 | 1,200 |
| refs/prd/*.md | 300 | 1,200 |
| memory/decisions/DEC-*.md | 300 | 1,200 |
| memory/timeline/*.md | 300 | 1,200 |

> Session start total: ~2,600 tokens

---

## Git Workflow (AI Handles All)

### Branch Rules

```text
main/develop → NEVER commit directly
feature/*    → New features
bugfix/*     → Bug fixes
hotfix/*     → Urgent fixes
```

### Standard Flow

```bash
# 1. Start work
git checkout develop && git pull
git checkout -b feature/{description}

# 2. Work + commit
git add . && git commit -m "feat: description"

# 3. Create PR
git push -u origin feature/{description}
gh pr create --base develop
```

---

## Protected Files

### LOCKED (Change requires user request + DEC record)

- `refs/stack/STACK-DECISION.md`
- `refs/dependencies/VERSIONS.lock.md`

### READ-ONLY (Never modify)

- `refs/base/**/*`

### SYSTEM (Never modify without explicit request)

- `.githooks/*`, `.github/workflows/*`
- `scripts/*`, `RULES.md`

---

## Key Locations

| Need | Location |
|------|----------|
| Current state | [memory/NOW.md](memory/NOW.md) |
| Find info | [memory/FIND.md](memory/FIND.md) |
| Project context | [refs/PROJECT-CONTEXT.md](refs/PROJECT-CONTEXT.md) |
| Decisions | [memory/decisions/](memory/decisions/) |
| PRD | [refs/prd/](refs/prd/) |
| Tech stack | [refs/stack/STACK-DECISION.md](refs/stack/STACK-DECISION.md) |

---

## Session Consistency Rules

### Before ANY Work

- □ Session ID stated? → If NO, read NOW.md first
- □ Project phase known? → If NO, read PROJECT-CONTEXT.md first
- □ On feature branch? → If NO, create branch first

### After EVERY Change

- □ NOW.md updated with new Session ID timestamp?
- □ Timeline entry added for code changes?
- □ Decision record created for important choices?

### Before EVERY Commit

- □ memory/ files modified if code changed?
- □ All line limits respected?
- □ Branch naming correct?

> **Enforcement**: Pre-commit hook blocks commits missing memory updates.

---

## Do NOT

- Proceed without stating Session ID (proof you read NOW.md)
- Work on main/develop directly
- Modify LOCKED files without user request
- Skip memory updates after changes
- Let files exceed line limits

## Always DO

- State Session ID at conversation start (self-verification)
- Create feature branch before work
- Update memory after every change
- Increment Session ID in NOW.md on each update
- Wait for explicit approval before commit/merge

---

## Validation

```bash
# Check all rules
./scripts/validate-memory.sh

# Strict mode
./scripts/validate-memory.sh --strict

# Token count
python3 scripts/count-tokens.py --report
```

---

**Token cost**: ~1,200 tokens
**Read frequency**: Every session start
