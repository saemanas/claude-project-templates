#!/usr/bin/env python3
"""
count-tokens.py - Token Usage Calculator for Memory System

Purpose: Calculate and track token usage across memory files
Usage: python3 scripts/count-tokens.py [--report] [--budget] [--watch]

Requirements: pip install tiktoken (optional, falls back to estimation)
"""

import argparse
import json
import os
import sys
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Tuple

# Try to import tiktoken for accurate counting
try:
    import tiktoken
    TIKTOKEN_AVAILABLE = True
except ImportError:
    TIKTOKEN_AVAILABLE = False

# Token budgets (zero tolerance limits)
TOKEN_BUDGETS = {
    "memory/NOW.md": 1200,
    "memory/FIND.md": 600,
    "memory/decisions/INDEX.md": 1200,
    "CLAUDE.md": 2500,
}

# Estimated tokens per line for different file types
TOKENS_PER_LINE = {
    "weekly_log": 4.0,
    "monthly_summary": 4.0,
    "decision_record": 4.0,
    "topic_readme": 4.0,
    "topic_content": 4.0,
    "default": 4.0,
}

# Session token budgets
SESSION_BUDGETS = {
    "minimal": 1200,      # NOW.md only
    "standard": 1800,     # NOW.md + FIND.md
    "full_context": 3800, # NOW.md + FIND.md + one topic doc
    "complex_task": 6000, # Multiple docs needed
}


class TokenCounter:
    def __init__(self, use_tiktoken: bool = True):
        self.encoder = None
        if use_tiktoken and TIKTOKEN_AVAILABLE:
            try:
                self.encoder = tiktoken.get_encoding("cl100k_base")
            except Exception:
                pass

    def count_tokens(self, text: str) -> int:
        """Count tokens in text, using tiktoken if available."""
        if self.encoder:
            return len(self.encoder.encode(text))
        else:
            # Fallback: estimate ~4 tokens per line, ~0.75 tokens per word
            words = len(text.split())
            return int(words * 0.75)

    def count_file_tokens(self, filepath: Path) -> Tuple[int, int]:
        """Count tokens and lines in a file."""
        if not filepath.exists():
            return 0, 0

        try:
            content = filepath.read_text(encoding="utf-8")
            lines = len(content.splitlines())
            tokens = self.count_tokens(content)
            return tokens, lines
        except Exception as e:
            print(f"Warning: Could not read {filepath}: {e}", file=sys.stderr)
            return 0, 0


def find_memory_files(base_path: Path) -> Dict[str, List[Path]]:
    """Find all memory system files organized by category."""
    files = {
        "core": [],
        "timeline": [],
        "decisions": [],
        "docs": [],
    }

    # Core files
    for name in ["memory/NOW.md", "memory/FIND.md", "CLAUDE.md"]:
        path = base_path / name
        if path.exists():
            files["core"].append(path)

    # Timeline files
    timeline_dir = base_path / "memory" / "timeline"
    if timeline_dir.exists():
        files["timeline"] = sorted(timeline_dir.glob("*.md"))

    # Decision files
    decisions_dir = base_path / "memory" / "decisions"
    if decisions_dir.exists():
        files["decisions"] = sorted(decisions_dir.glob("*.md"))

    # Documentation files
    docs_dir = base_path / "docs"
    if docs_dir.exists():
        files["docs"] = sorted(docs_dir.rglob("*.md"))

    return files


def generate_report(base_path: Path, counter: TokenCounter) -> Dict:
    """Generate comprehensive token usage report."""
    files = find_memory_files(base_path)
    report = {
        "generated_at": datetime.now().isoformat(),
        "tiktoken_available": TIKTOKEN_AVAILABLE and counter.encoder is not None,
        "categories": {},
        "totals": {
            "files": 0,
            "lines": 0,
            "tokens": 0,
        },
        "budget_status": {},
        "warnings": [],
    }

    # Process each category
    for category, file_list in files.items():
        category_data = {
            "files": [],
            "total_tokens": 0,
            "total_lines": 0,
        }

        for filepath in file_list:
            tokens, lines = counter.count_file_tokens(filepath)
            relative_path = str(filepath.relative_to(base_path))

            file_data = {
                "path": relative_path,
                "tokens": tokens,
                "lines": lines,
            }

            # Check budget if applicable
            if relative_path in TOKEN_BUDGETS:
                budget = TOKEN_BUDGETS[relative_path]
                file_data["budget"] = budget
                file_data["usage_percent"] = round(tokens / budget * 100, 1)

                if tokens > budget:
                    file_data["status"] = "OVER_BUDGET"
                    report["warnings"].append(
                        f"{relative_path}: {tokens}/{budget} tokens (OVER BUDGET)"
                    )
                elif tokens > budget * 0.9:
                    file_data["status"] = "WARNING"
                    report["warnings"].append(
                        f"{relative_path}: {tokens}/{budget} tokens (>90% used)"
                    )
                else:
                    file_data["status"] = "OK"

            category_data["files"].append(file_data)
            category_data["total_tokens"] += tokens
            category_data["total_lines"] += lines

        report["categories"][category] = category_data
        report["totals"]["files"] += len(file_list)
        report["totals"]["lines"] += category_data["total_lines"]
        report["totals"]["tokens"] += category_data["total_tokens"]

    # Calculate session budgets
    core_tokens = report["categories"].get("core", {}).get("total_tokens", 0)
    report["session_analysis"] = {
        "core_memory_tokens": core_tokens,
        "budgets": SESSION_BUDGETS,
        "recommended_session_type": (
            "minimal" if core_tokens <= SESSION_BUDGETS["minimal"]
            else "standard" if core_tokens <= SESSION_BUDGETS["standard"]
            else "full_context" if core_tokens <= SESSION_BUDGETS["full_context"]
            else "complex_task"
        ),
    }

    return report


def print_report(report: Dict, verbose: bool = False):
    """Print formatted report to console."""
    print("\n" + "=" * 50)
    print("  Token Usage Report")
    print("=" * 50)
    print(f"\nGenerated: {report['generated_at']}")
    print(f"Token counting: {'tiktoken (accurate)' if report['tiktoken_available'] else 'estimation'}")

    # Category breakdown
    print("\n" + "-" * 50)
    print("  By Category")
    print("-" * 50)

    for category, data in report["categories"].items():
        if data["files"]:
            print(f"\n{category.upper()}:")
            for f in data["files"]:
                status = ""
                if "status" in f:
                    if f["status"] == "OVER_BUDGET":
                        status = " [OVER BUDGET]"
                    elif f["status"] == "WARNING":
                        status = " [>90%]"

                if "budget" in f:
                    print(f"  {f['path']}: {f['tokens']}/{f['budget']} tokens ({f['usage_percent']}%){status}")
                else:
                    print(f"  {f['path']}: {f['tokens']} tokens, {f['lines']} lines")

            print(f"  --- Subtotal: {data['total_tokens']} tokens, {data['total_lines']} lines")

    # Totals
    print("\n" + "-" * 50)
    print("  Totals")
    print("-" * 50)
    print(f"  Files: {report['totals']['files']}")
    print(f"  Lines: {report['totals']['lines']}")
    print(f"  Tokens: {report['totals']['tokens']}")

    # Session analysis
    print("\n" + "-" * 50)
    print("  Session Analysis")
    print("-" * 50)
    session = report["session_analysis"]
    print(f"  Core memory tokens: {session['core_memory_tokens']}")
    print(f"  Recommended session type: {session['recommended_session_type']}")
    print("\n  Session type budgets:")
    for session_type, budget in SESSION_BUDGETS.items():
        print(f"    {session_type}: {budget} tokens")

    # Warnings
    if report["warnings"]:
        print("\n" + "-" * 50)
        print("  WARNINGS")
        print("-" * 50)
        for warning in report["warnings"]:
            print(f"  [!] {warning}")

    print("\n" + "=" * 50)

    # Exit code based on warnings
    return 1 if any("OVER BUDGET" in w for w in report["warnings"]) else 0


def print_budget_check(report: Dict):
    """Print simple budget check for CI/CD."""
    has_errors = False

    print("Token Budget Check")
    print("-" * 40)

    for category, data in report["categories"].items():
        for f in data["files"]:
            if "budget" in f:
                status_icon = ""
                if f["status"] == "OVER_BUDGET":
                    status_icon = "FAIL"
                    has_errors = True
                elif f["status"] == "WARNING":
                    status_icon = "WARN"
                else:
                    status_icon = "OK"

                print(f"[{status_icon}] {f['path']}: {f['tokens']}/{f['budget']} ({f['usage_percent']}%)")

    return 1 if has_errors else 0


def main():
    parser = argparse.ArgumentParser(
        description="Token Usage Calculator for Memory System"
    )
    parser.add_argument(
        "--report", "-r",
        action="store_true",
        help="Generate full report"
    )
    parser.add_argument(
        "--budget", "-b",
        action="store_true",
        help="Check budget only (for CI/CD)"
    )
    parser.add_argument(
        "--json", "-j",
        action="store_true",
        help="Output as JSON"
    )
    parser.add_argument(
        "--path", "-p",
        type=str,
        default=".",
        help="Base path to check (default: current directory)"
    )
    parser.add_argument(
        "--no-tiktoken",
        action="store_true",
        help="Disable tiktoken even if available"
    )

    args = parser.parse_args()

    base_path = Path(args.path).resolve()
    counter = TokenCounter(use_tiktoken=not args.no_tiktoken)

    # Generate report
    report = generate_report(base_path, counter)

    # Output
    if args.json:
        print(json.dumps(report, indent=2))
        sys.exit(0)
    elif args.budget:
        sys.exit(print_budget_check(report))
    else:
        sys.exit(print_report(report))


if __name__ == "__main__":
    main()
