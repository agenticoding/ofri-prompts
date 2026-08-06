# ofri-prompts

Prompt template library for the **Agentic Coding stack** — `pi` + `pi-agenticoding` + `pi-mcp-adapter` + ChunkHound. Type `/name` in the pi editor to invoke a template.

## What's inside

| Path | Contents |
|---|---|
| `prompts/` | 13 prompt templates (`/commit`, `/pr-review`, `/release-notes`, `/review-worktree`, ...). Flat by design — pi template discovery is non-recursive. |
| `model-groups/` | `model-groups.json` — the model routing policy consumed by `pi-agenticoding`'s `model-group:` frontmatter. |
| `install.sh` | One-command local setup (symlinks — see [Install](#install)). |

## Requirements

| Component | Why it's required | Install |
|---|---|---|
| pi ≥ 0.83 | runtime; provides the built-in providers listed below | standard |
| `pi-agenticoding` | model groups (`model-group:` frontmatter), plus notebook/handoff/spawn flows referenced by several templates | `pi install git:github.com/agenticoding/pi-agenticoding` |
| `pi-mcp-adapter` | MCP tooling used by the ChunkHound-flavored templates | `pi install npm:pi-mcp-adapter` |
| `agent-browser` | browser automation referenced by review templates | see its docs |
| ChunkHound (MCP) | code research used by `/explain-branch`, `/review-worktree` | via `pi-mcp-adapter` |

## Install

```bash
git clone https://github.com/agenticoding/ofri-prompts.git
cd ofri-prompts && ./install.sh
```

`install.sh` symlinks `~/.pi/agent/prompts` → this repo's `prompts/` and `~/.pi/agent/pi-agenticoding/model-groups.json` → this repo's `model-groups/model-groups.json`. It never deletes existing content: existing templates are merged into the repo first, existing files that would be replaced are kept as `*.bak`.

Alternatively, load the prompts as a pi package (prompts only — you still place `model-groups.json` yourself, see [Model routing](#model-routing)):

```bash
pi install git:github.com/agenticoding/ofri-prompts
```

## Providers this build relies on

The reference setup routes models through these providers. All but one are **built into pi ≥ 0.83** — nothing to configure beyond authenticating with `/login`. The router skips providers that aren't configured or authenticated on your machine and uses the next usable model in the group, so you only need *one* of them.

| Provider | Role in this build | Setup |
|---|---|---|
| `deepseek` | default model; pinned in `/commit`, `/explain-worktree`, `/pr-create`, `/release-notes` | built-in, `pi /login` |
| `openai-codex` | groups: coder, frontend/UI/vision, architecture/design, review, merge-resolution, debugging | built-in, `pi /login` |
| `vercel-ai-gateway` | coder, architecture/design, merge-resolution, debugging (poolside, thinkingmachines, alibaba/qwen) | built-in, `pi /login` |
| `kimi-coding` | frontend/UI/vision, architecture/design | built-in, `pi /login` |
| `opencode-go` | coder, architecture/design, review | built-in, `pi /login` |
| `xiaomi-token-plan-sgp` | coder, review | built-in, `pi /login` |
| `opencode` | review | built-in, `pi /login` |
| `poolside` | coder (`poolside/laguna-s-2.1`) | **custom** — `models.json`, see below |
| `xai` | present in the reference setup; not referenced by current routing | built-in, `pi /login` |

Custom providers are declared in `~/.pi/agent/models.json` (see pi's `docs/custom-provider.md`). The reference setup defines `poolside` like this — substitute your own key:

```json
{
  "providers": {
    "poolside": {
      "api": "openai-completions",
      "baseUrl": "https://inference.poolside.ai/v1",
      "apiKey": "<your-key>",
      "models": [{ "id": "poolside/laguna-s-2.1" }]
    }
  }
}
```

## Customizing for your setup

There are three independent layers. Override the ones that don't match your setup; the rest work as-is.

### 1. Model routing — `model-groups.json`

`model-group:` frontmatter (e.g. `/pr-review`, `/merge-conflicts`, `/debug-tests`) routes to a **group**: an ordered fallback chain of `provider/model` entries with a thinking level. The router picks the first entry that is configured **and** authenticated on your machine; a group with no usable models falls back to your selected model.

To re-configure for your own providers:

```bash
cp model-groups/model-groups.json ~/.pi/agent/pi-agenticoding/model-groups.json
# edit: replace provider/model entries per group, keep the group names
# (templates reference them) and keep "version": 1
```

Project-scoped override: `.pi/pi-agenticoding/model-groups.json` (relative to the project root) wins over the global file.

### 2. Per-template model pins

Some templates pin a specific model in frontmatter — an author preference, e.g. `/commit` → `model: deepseek/deepseek-v4-flash`. To override a pin (or a `model-group:`), shadow the template: copy it to `~/.pi/agent/prompts/<name>.md` with the same filename and edit `model:`, `thinking:`, and/or `model-group:`. Local files in `~/.pi/agent/prompts/` take precedence over package/repo copies (first-wins resolution), so your copy wins.

> **Don't edit files inside the symlinked `prompts/` if you also `git pull`** — you'll hit merge conflicts. Shadow copies are the conflict-free path.

### 3. Providers

- Built-in providers: authenticate with `pi /login`.
- Custom/self-hosted providers: `~/.pi/agent/models.json` (example above).
- A provider must be authenticated before it counts as "usable" for group routing.

## Keeping up to date

- **Maintainer:** edit files in this repo (the symlinked paths apply instantly), then `git push`.
- **Consumer (clone):** `git pull`.
- **Consumer (pi package):** re-install or re-pin (`pi install git:github.com/agenticoding/ofri-prompts@<new-ref>`). Note that pi-managed clones under `~/.pi/agent/git/` are reconciled/reset by pi — don't edit templates there; shadow them instead.

## Security

- This repo intentionally contains **no credentials**. `~/.pi/agent/auth.json`, `models-store.json`, and `mcp-oauth/` hold keys — never commit or publish them.
- Pi packages run with full system access — review source before installing third-party packages.

## License

MIT — see [LICENSE](LICENSE).
