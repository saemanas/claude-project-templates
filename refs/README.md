# Project References (refs/)

**Status**: VERSION CONTROLLED
**Purpose**: Project context, PRD, tech stack, dependency management

---

## Directory Role

```
refs/
├── README.md              ← This file (guide)
├── PROJECT-CONTEXT.md     ← Project context (AI(You) must read)
│
├── base/                  ← EXISTING PROJECT MATERIALS (READ-ONLY)
│   ├── README.md          ← Rules for base/ usage
│   └── {original-dirs}/   ← Preserved original content (DO NOT MODIFY)
│
├── prd/                   ← Product Requirements Documents
│   ├── PRD-001-overview.md
│   ├── PRD-002-features.md
│   └── ...
│
├── stack/                 ← Tech stack decisions (LOCKED after decision)
│   ├── STACK-DECISION.md  ← Final decision (locked until change request)
│   ├── STACK-RESEARCH.md  ← AI(You) research results
│   └── STACK-ALTERNATIVES.md ← Reviewed alternatives
│
├── dependencies/          ← Dependency version lock
│   ├── VERSIONS.lock.md   ← Locked versions (no changes)
│   └── UPGRADE-LOG.md     ← Upgrade history
│
└── research/              ← AI(You) research materials
    ├── {topic}-research.md
    └── ...
```

---

## refs/base/ - Existing Project Materials (CRITICAL)

### Purpose

When applying this template to an **existing project**, all original materials are moved to `refs/base/`:

```
refs/base/
├── client/          ← Client-provided documents
├── user/            ← Previous analysis results
└── {any-original}/  ← Any pre-existing content
```

### Rules (STRICTLY ENFORCED)

| Rule | Description |
|------|-------------|
| **NO MODIFY** | Never edit files in refs/base/ |
| **NO DELETE** | Never delete files in refs/base/ |
| **NO RENAME** | Never rename files in refs/base/ |
| **READ-ONLY** | Only read and reference |

### AI(You) Behavior

```
ALLOWED:
✓ Read files for context
✓ Reference in PRD/decisions
✓ Quote content in new documents
✓ Use as basis for analysis

FORBIDDEN:
✗ Edit any file
✗ Delete any file
✗ Move files out
✗ Rename anything
```

### Violation Response

If modification is attempted:
1. STOP immediately
2. Report to user
3. Suggest alternative approach

---

## Core Rules

### 1. PROJECT-CONTEXT.md (Required)

AI(You) references at **every session start** to understand project context:

```markdown
# Project Context

## Mission
{Project goal - one sentence}

## Target Users
{Target users}

## Key Features
{Core feature list}

## Constraints
{Constraints - budget, time, technical limitations}

## Non-Negotiables
{Items that must never change}
```

### 2. STACK-DECISION.md (LOCKED)

Tech stack decided after discussion with AI:

```markdown
# Stack Decision

**Status**: LOCKED
**Decided**: YYYY-MM-DD
**Decision**: DEC-001

## Frontend
- Framework: React 18.x
- Build: Vite 5.x
- ...

## Backend
- Framework: FastAPI 0.109.x
- Python: 3.11.x
- ...

## Infrastructure
- DB: PostgreSQL 16.x
- Cache: Redis 7.x
- ...
```

**To change**:
1. User explicitly requests: "I want to discuss changing the stack"
2. Discuss with AI(You) (impact, migration cost analysis)
3. On decision, update STACK-DECISION.md with new version
4. Create DEC-nnn record

### 3. VERSIONS.lock.md (LOCKED)

Exact versions for all dependencies:

```markdown
# Versions Lock

**Status**: LOCKED
**Last Updated**: YYYY-MM-DD

## Frontend Dependencies
| Package | Version | Locked |
|---------|---------|--------|
| react | 18.2.0 | Yes |
| vite | 5.0.12 | Yes |

## Backend Dependencies
| Package | Version | Locked |
|---------|---------|--------|
| fastapi | 0.109.0 | Yes |
| sqlalchemy | 2.0.25 | Yes |
```

---

## Workflow

### At Project Start

```
1. Write PRD (refs/prd/)
   └─ User defines requirements
   └─ AI(You) helps concretize

2. AI(You) Research (refs/research/)
   └─ AI(You) researches latest + stable technologies
   └─ References official docs, release notes
   └─ Documents research results

3. Stack Discussion
   └─ AI(You) suggests options + pros/cons analysis
   └─ Discuss with user
   └─ Final decision

4. Lock Stack (refs/stack/STACK-DECISION.md)
   └─ Document decision
   └─ Set to LOCKED status
   └─ Maintain until change request

5. Lock Dependencies (refs/dependencies/VERSIONS.lock.md)
   └─ Specify all package versions
   └─ Create lock file
```

### When Stack Change Requested

```
1. User request: "I want to change the stack" or "I want to use Vue instead of React"

2. AI(You) Analysis:
   - Check current progress
   - Analyze impact scope
   - Estimate migration cost
   - Present alternatives

3. User confirmation: "Should we proceed with the change?"

4. Execute change:
   - Update STACK-DECISION.md
   - Create memory/decisions/DEC-nnn.md
   - Update VERSIONS.lock.md
   - Update memory/NOW.md
```

---

## AI(You) Research Guide

### What AI(You) Should Check When Selecting Technology

1. **Stability**
   - Is it an LTS version?
   - Is it production-proven?
   - Are there major bug issues?

2. **Compatibility**
   - Compatible with other selected technologies?
   - Supports Mac M1/M2/M3 + Intel?
   - Works without issues in Docker?

3. **Documentation**
   - Is official documentation sufficient?
   - Is the community active?

4. **Long-term Support**
   - Is maintenance active?
   - What is the major version upgrade cycle?

### Documenting Research Results

```markdown
# {Topic} Research

**Researched**: YYYY-MM-DD
**Purpose**: {Research purpose}

## Options Considered
1. Option A - {reason}
2. Option B - {reason}

## Recommendation
{Recommendation + reasoning}

## Sources
- Official Docs: {URL}
- Release Notes: {URL}
- Benchmark: {URL if applicable}
```

---

## File Modification Permissions

| File | Permission |
|------|------------|
| `base/**/*` | **READ-ONLY** - NEVER modify or delete |
| `PROJECT-CONTEXT.md` | Updatable on user request |
| `prd/*.md` | Updatable on user request |
| `stack/STACK-DECISION.md` | **LOCKED** - Only after change discussion |
| `stack/STACK-RESEARCH.md` | AI(You) can freely update |
| `dependencies/VERSIONS.lock.md` | **LOCKED** - Only after change discussion |
| `research/*.md` | AI(You) can freely create/update |

---

## Version Control

All `refs/` files are version controlled with Git:
- Detailed commit messages required on changes
- DEC-nnn record required when changing STACK-DECISION.md, VERSIONS.lock.md

---

**Version**: 1.0.0
**Last Updated**: 2025-11-26
