---
description: Merge branches with conflicts
argument-hint: "[branch name]"
readonly: true
model-group: merge-resolution
---
You are merging the git branch `$@` into the current branch under **cwd**, and the merge currently has conflicts.

1. Use `git` to find the last merge point between the current branch and `$@`. Follow up with ChunkHound research with `vector_source="diff"` to analyze the changes on this branch since the last merge point.
2. Follow up with code research `vector_source="db"` to understand the big picture, architecture, design, modules, etc of the changed areas in the code.
3. Start the merge in a temp dir using it as a scratchpad, carefully inspect the conflicts, then explain why each conflict happened—what each branch tried to accomplish and why that resulted in a conflict.
4. Clean up the temp dir and present the conflicts in a concise and human-optimized format.

Do NOT resolve the merge, ONLY explain the resolution strategy. READONLY mode.
