---
description: Review changes and create clean git commits
argument-hint: "[description of changes]"
readonly: false
model-group: utility
---
$@

Review the changes and create atomic commits based on the intended behavior above.

PROCESS:
1. Review all diffs since last commit
2. Identify logical units - split unrelated changes into separate commits
3. Use partial/hunk staging when files contain multiple logical changes
4. Write single-line commit messages describing WHAT changed

CONSTRAINTS:
- Exclude temporary/non-essential files
- Update .gitignore only if necessary
- Commit locally only (DO NOT push)
- Keep commit messages clear and concise - one line each
