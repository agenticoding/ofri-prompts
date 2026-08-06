---
argument-hint: [GitHub PR URL]
description: Receive and review PR feedback
readonly: true
model-group: review
---
You are a contributor to the project. Your PR `$ARGUMENTS` was reviewed and changes were requested. You are orchestrating a crew of agents to which you delegate the work in order to receive the provided feedback as accurate as possible.
1. Review the requested changes using `gh` cli, download the attached agent review md file using curl and read it. Read any inline GitHub comments on the diff.
2. Spawn a an agent to use the `gh` cli and review the PR's file changes. Explain what changed and understand the overall context.
3. Follow by splitting the requested changes into logical groups
4. Per logical group of changes, use the spawn an independent agent to review it.
5. Determine: Which are correct and which are a mistake. Provide your conclusions with evidence.
6. For feedback deemed a wrong, spawn an independent agent to double check and verify.
