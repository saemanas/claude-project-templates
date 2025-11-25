# Base References (refs/base/)

> **Status**: READ-ONLY - DO NOT MODIFY OR DELETE

---

## Purpose

This directory contains **original project materials** that existed before applying the template system:

- Client-provided documents
- Previous analysis results
- Legacy specifications
- Reference materials

---

## Rules (STRICTLY ENFORCED)

### 1. NO MODIFICATIONS

```
FORBIDDEN:
- Editing any file in refs/base/
- Renaming files or directories
- Deleting any content
- Moving files out of refs/base/
```

### 2. NO DELETIONS

```
FORBIDDEN:
- rm, rmdir, or any delete operation
- git rm on any refs/base/ content
- Overwriting with new content
```

### 3. READ-ONLY ACCESS

```
ALLOWED:
- Reading files for context
- Referencing in PRD/Stack discussions
- Citing in decision records
- Copying content TO other locations (not FROM)
```

---

## Directory Structure

```
refs/base/
├── README.md          ← This file (the only exception - created by template)
│
├── {original-dir-1}/  ← Preserved as-is
│   └── ...
│
├── {original-dir-2}/  ← Preserved as-is
│   └── ...
│
└── {original-files}   ← Preserved as-is
```

---

## How AI(You) Should Use This

### At Session Start

1. Check if `refs/base/` exists
2. If exists, scan contents to understand project background
3. Reference materials when making decisions

### When Writing PRD

```markdown
## Background
Based on analysis in refs/base/user/2-Analysis/:
- [Reference specific findings]
- [Cite relevant documents]
```

### When Deciding Stack

```markdown
## Constraints from Existing Materials
Per refs/base/client/requirements.xlsx:
- Must support X
- Must integrate with Y
```

---

## Why Read-Only?

| Reason | Explanation |
|--------|-------------|
| Audit Trail | Original materials preserved for reference |
| Client Trust | Client-provided documents remain untouched |
| Rollback | Can always refer to original requirements |
| Legal | Original documents may have contractual significance |

---

## Violation Response

If AI(You) attempts to modify `refs/base/`:

1. **STOP immediately**
2. **Report the attempted action to user**
3. **Do NOT proceed with modification**
4. **Suggest alternative approach**

---

**Status**: READ-ONLY
**Created**: Template application date
**Modified**: NEVER (this README is the only template-created file)
