---
argument-hint: [GitHub PR URL]
description: Receive and review PR feedback
readonly: true
model-group: review
---
You are a contributor to the project. Your PR `$ARGUMENTS` was reviewed and changes were requested. You are orchestrating a crew of agents and delegate work to assess the provided feedback as accurately as possible.
1. Review the requested changes using the `gh` CLI, download the attached agent-review Markdown file using curl and read it. Read any inline GitHub comments on the diff.
2. Spawn an agent to use the `gh` CLI and review the PR's file changes. Explain what changed and understand the overall context.
3. Follow this by splitting the requested changes into logical groups
4. Per logical group of changes, spawn an independent agent to review it.
5. Determine: Which are correct and which are mistakes. Provide your conclusions with evidence.
6. For feedback deemed wrong, spawn an independent agent to double-check and verify.
