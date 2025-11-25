# Protected Files Manifest

**Version**: 1.0.0
**Last Updated**: 2025-11-26
**Purpose**: Define protected system files that CANNOT be modified without explicit user request

---

## Protection Policy

### Why Protection?

The Project Memory System is built on **two core principles**:

1. **Zero-tolerance long-term memory management**
2. **Token optimization (81% reduction)**

These principles are implemented through specific files and rules. Modifying these files without explicit user request would compromise the entire system's integrity.

### Protection Level

```
PROTECTED = Cannot be modified by AI without explicit user request
LOCKED    = Cannot be modified at all (system critical)
```

---

## Protected Files List

### LOCKED (System Critical - Never Modify)

```
.protected/
├── MANIFEST.md              # This file
├── CHECKSUMS.sha256         # File integrity checksums
└── CORE-RULES.md            # Immutable core rules

.githooks/
├── pre-commit               # Commit validation
└── commit-msg               # Message validation

.github/workflows/
├── memory-validation.yml    # Memory system validation
├── gitflow-check.yml        # Gitflow enforcement
├── protected-files.yml      # Protection enforcement
├── auto-archive.yml         # Auto-archive logic
└── weekly-report.yml        # Weekly report logic

scripts/
├── validate-memory.sh       # Validation logic
├── count-tokens.py          # Token counting logic
├── archive-old-logs.sh      # Archive logic
└── init-project.sh          # Project initialization
```

### PROTECTED (Require Explicit User Request)

```
RULES.md                     # Zero-tolerance rules
GITFLOW.md                   # Branching rules

memory/
├── Line limits (300/200/500/100)
├── File naming conventions
└── Archive policies
```

### NOT PROTECTED (Normal Project Files)

```
CLAUDE.md                    # Can be updated with project info
memory/NOW.md                # Should be updated regularly
memory/FIND.md               # Can be updated as needed
memory/timeline/*.md         # Active logging
memory/decisions/*.md        # Decision records
docs/**/*                    # Project documentation
```

---

## Modification Rules

### For AI Assistant

```
IF file in LOCKED:
    → REJECT modification
    → Explain: "This is a protected system file"
    → Suggest: "Ask user for explicit permission"

IF file in PROTECTED:
    → REJECT modification
    → Explain: "This file defines core rules"
    → Suggest: "Ask user for explicit permission"

IF user explicitly requests modification:
    → Ask: "Are you sure? This affects core system rules"
    → Proceed only with confirmation
```

### For Git Hooks

```
IF protected file modified:
    → Block commit
    → Show warning
    → Require --force flag with acknowledgment
```

### For CI/CD

```
IF protected file modified in PR:
    → Require additional review
    → Show protection warning
    → Log modification attempt
```

---

## How to Request Modification

### User Must Explicitly State:

```
"I want to modify the protected file [filename]"
"Please update [filename] - I understand this is protected"
"Change the rule in [filename] to [new rule]"
```

### AI Should Confirm:

```
"This file is protected because it defines core system rules.
Modifying it may affect:
- Token optimization
- Long-term memory consistency
- Automated enforcement

Are you sure you want to proceed?"
```

---

## Integrity Verification

### Checksum Verification

Protected files have SHA-256 checksums stored in `.protected/CHECKSUMS.sha256`.

```bash
# Verify integrity
cd .protected
sha256sum -c CHECKSUMS.sha256
```

### Restoration

If protected files are corrupted:

```bash
# Restore from template
./scripts/restore-protected.sh
```

---

## Version Control

### Protected files should:

1. Never be modified in feature branches
2. Only be modified in dedicated `system/*` branches
3. Require explicit approval for merge
4. Be tagged with version on modification

### Versioning

```
system/update-rules-v1.1.0
system/update-validation-v1.2.0
```

---

## Core Rules (Immutable)

These rules are the foundation of the system and should NEVER change without significant research proving a better approach:

### 1. Line Limits

| File | Limit | Reason |
|------|-------|--------|
| NOW.md | 300 | Token budget: ~1,200 |
| FIND.md | 200 | Token budget: ~600 |
| Weekly log | 500 | Token budget: ~2,000 |
| Decision | 500 | Token budget: ~2,000 |
| Topic README | 100 | Token budget: ~400 |

### 2. Token Budget

| Session Type | Budget | Reason |
|--------------|--------|--------|
| Minimal | 1,200 | NOW.md only |
| Standard | 1,800 | NOW.md + FIND.md |
| Full | 3,800 | + one topic doc |

### 3. Gitflow

| Branch | Protection | Reason |
|--------|------------|--------|
| main | No direct push | Production stability |
| develop | No direct push | Integration stability |

### 4. Enforcement

| Layer | Mechanism | Reason |
|-------|-----------|--------|
| Local | pre-commit | Immediate feedback |
| Remote | GitHub Actions | Guaranteed enforcement |

---

**This manifest is LOCKED and cannot be modified.**

**Last Updated**: 2025-11-26
**Protected By**: pre-commit + CI/CD + AI instruction
