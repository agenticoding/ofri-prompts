# Coding Standards
- **The golden rules:**
  1. **If 2+ lines repeat, refactor to a shared utility**
  1. **If a low level code unit (function, method, etc) grows above 20 lines, break it into smaller units and compose**
- Assume only AI agents will ever read your code, never humans
- KISS - Keep It Simple. Less code is better code
- Always respect the architecture and module boundaries. Strive to actively fix any violations after an explicit approval from the user
- Code must be free from tech debt. When an existing tech debt is encountered, proactively suggest the user to to incorporate it into the next planning
- Code must compile and lint cleanly
- Fix bugs by deleting code when possible
- Optimize for readability and maintenance
- No over-engineering, no temporary compatibility layers, prefer simple direct coupling
- No silent errors - failures must be explicit and visible
- Document inline when necessary. Always explain the **WHY** and **WHAT** behind the code, not the how (which is the code itself). Inline comments must be optimized for AI agents and token efficiency.
- Keep comments short, concise, and token aware.
- Actively enforce DRY and reusability.
- Write tests that verify external invariants constraints, and user facing contracts that are socialable and stay robust across refactors. Search the web to find the industry best practices for testing the specific scenario reliably.

## Testing

- Tests exercise real code paths. No mocks, no stubs unless absolutely unavoidable.
- Actively seek to reduce mocks and stubs.
- Only test external invariants, constraints, user-facing contracts.
- Tests must reliably survive refactors.

# Critical Constraints

- NEVER Commit without explicit request, ALWAYS ask before committing
- NEVER Leave temporary/backup files (we have version control), ALWAYS clean up when done
- NEVER Hardcode keys or credentials, ALWASY ask the user what to do
- NEVER Assume your code works - ALWAYS verify
- NEVER modify AGENTS.md, CLAUDE.md or README.md without an explicit user request
- NEVER add backwards compatibility unless explicitly asked for
- ALWAYS Clean up after completing tasks
- When presenting plans to the user, ALWAYS format them so it's easy for a human to spot additions, removals and changes.
- When the user asks for a plan, ALWAYS present the full plan for approval before execution
- The full What, Why and How MUST ALWAYS be recoverable by reading the code
- Comments and code MUST ALWAYS follow single source of truth principal. NEVER duplicate information, always reference the single source of truth.

# Browser Automation (`agent-browser`)

**`agent-browser` is a cli for optimized browser automation.**

Use to validate visual tasks. Consult the help pages for advanced usage.

### Core Loop

```
open <url> → snapshot -ic → interact → snapshot -ic → ...
```
Always re-snapshot after any action that changes the page.

### Snapshot (how the agent "sees")
- `snapshot -ic` — interactive elements only, compact (default choice)
- `snapshot -c` — full page structure, compact
- `snapshot -s "css-selector" -ic` — scope to a section
- Returns refs like `@e1`, `@e2` — use these as selectors
