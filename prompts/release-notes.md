---
description: Update CHANGELOG.md for a production release
argument-hint: "[VERSION] (e.g. 4.2.0)"
readonly: false
model: deepseek/deepseek-v4-flash
thinking: high
---
Update `CHANGELOG.md` only. No tags, commits, pushes, or GitHub releases.

```
$ARGUMENTS
```

## Flow

1. **Research** → notebook
2. **Handoff** → draft section + version
3. **User confirms** → apply `CHANGELOG.md`

Set topic `changelog-release`. Durable findings go to notebook pages; handoff at the research→draft boundary.

## Research

### Baseline
- `git fetch --tags` (best effort)
- `PREV_TAG`: if latest tag is a prerelease (`vX.Y.ZaN` / `bN` / `rcN`), use it (promotion). Else latest stable `vX.Y.Z`
- Abort if the range looks stale (ancient tag / huge unexpected commit count); tell the user to refresh tags

### Commit index (raw git — required)
```bash
git log ${PREV_TAG}..HEAD --format="---%nSubject: %s%nBody:%b" --no-merges
git log ${PREV_TAG}..HEAD --merges --format="PR: %s"
```
Use messages as the narrative index (intent, feature names). Do not dump full patches into context.

### Code evidence (ChunkHound)
- `code_research(query="user-facing changes since last release", commit_range="${PREV_TAG}..HEAD", vector_source="diff")`
- Deepen by `path=` and/or tighter ranges; binary-search large ranges
- `search` only to pin specifics
- Messages = intent; ChunkHound = evidence and clustering

### Synthesize
- Unit = user-facing feature/fix, never a commit
- Fold same-release fixups into the feature; list fixes only for prior-release regressions
- Skip CI/chore/docs/style/release-bump noise with no user impact
- When unsure, include
- Dedupe against **all** existing `CHANGELOG.md` sections — skip anything already shipped; fold `[Unreleased]` and matching prerelease sections into this release once

### Notebook
Write at least:
- `release-baseline` — PREV_TAG, range sanity, version candidate
- `release-candidates` — bullets with disposition: NEW / FOLD / SKIP

### Version
- `$ARGUMENTS` version wins if provided
- Else promote prerelease → stable, or bump from latest stable:
  1. Breaking → major
  2. Added/Enhanced → minor
  3. Fixed/Performance/Security only → patch
- Confirm version once with the draft

## Draft (after handoff)

Keep a Changelog. Omit empty sections.

```markdown
## [X.Y.Z] - YYYY-MM-DD

### Breaking Changes
### Added
### Enhanced
### Performance
### Fixed
### Removed
### Security
```

Bullets: **Bold name** — outcome-first, 1–2 sentences. No SHAs, PR numbers, or file paths.

Present: candidate table (NEW/FOLD/SKIP), suggested version + rationale, full proposed section.

## Apply

1. Insert `## [X.Y.Z] - YYYY-MM-DD` after the file header
2. Reset `## [Unreleased]` to an empty template
3. Remove folded prerelease sections **and** their footer link refs
4. Fix footer compares:
   - `[Unreleased]` → `vX.Y.Z...HEAD`
   - `[X.Y.Z]` → `vPREV_STABLE...vX.Y.Z` (`PREV_STABLE` = last stable before this release)
