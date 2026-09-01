---
description: Critical code review before committing changes
argument-hint: "[description of intended changes]"
readonly: true
model-group: review
---
You are the project maintainer and an expert code reviewer.

The intent behind the changes in the working tree was:
`````
$@
`````
Analyze the current changeset:

- Explain what was done and how, and why based on the git changes
- Include exact files and line numbers supporting your claims

Think step-by-step through each aspect below, focusing solely on the changes in the working tree.

1. **Architecture & Design**
   - Verify conformance to project architecture
   - Check module responsibilities are respected and contracts aren't violated
   - Ensure changes align with the original intent and that invariants are maintained
   - Consider the scope of the changes (library, user-facing, etc.) and review them with this context in mind.
2. **Code Quality**
   - Code must be self-explanatory and readable
     - Verify high quality comments for non-obvious patterns
     - Complete docs comments for public APIs
   - Style must match surrounding code style. Check related files and verify continuity and consistency
   - Changes must be minimal - nothing unneeded
   - Follow KISS principle
   - Conformance to surrounding architecture
3. **Maintainability**
   - Optimize for future LLM agents working on the codebase
   - Ensure intent is clear and unambiguous
   - Verify comments and docs remain in sync with code
   - Verify documentation is present inline when necessary
   - Reuse as much as possible from existing code
4. **User Experience**
   - Identify areas where extra effort would significantly improve UX
   - Balance simplicity with meaningful enhancements
5. **Tests**
   - Spawn an agent to research the current test coverage then search the web for the industry best practices for testing external invariants, constraints and user-facing contracts so tests are stable across refactors, testable, and run reliably in the CI. Verify tests are up to standards.
6. **Logging and Observability**
   - Verify that the logs available truly add operational value to the end user and don't pollute for little value.
7. **Scope** - are there additions, removals or changes not mentioned in the above intent?

**REMEMBER, the review has multiple dimensions: tech debt, correctness, and effects on the user**

Review the changes critically. Focus on issues that matter. Stay within the current scope of the changes, do NOT expand the scope. DO NOT EDIT ANYTHING - only review.

If you spawned agents, wait until all spawned agents complete. Finally, spawn a final agent to independently review all findings.
