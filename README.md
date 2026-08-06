# ofri-prompts

Prompt template library for the **Agentic Coding stack** — `pi` + `pi-agenticoding` + `pi-mcp-adapter` + ChunkHound. Type `/command-name` in the pi editor to invoke a template.

## What's inside

| Path | Contents |
|---|---|
| `prompts/` | 13 prompt templates (`/commit`, `/pr-review`, `/release-notes`, `/review-worktree`, ...). Loaded by pi as a package. |
| `model-groups/` | `model-groups.json` — the model routing policy consumed by `pi-agenticoding`'s `model-group:` frontmatter. User-owned config; copied into place once. |

## Requirements

| Component | Why it's required | Install |
|---|---|---|
| pi ≥ 0.83 | runtime; provides the built-in providers listed below (all present since 0.73) | standard |
| `pi-agenticoding` | model groups (`model-group:` frontmatter), plus notebook/handoff/spawn flows referenced by several templates | `pi install npm:pi-agenticoding` |
| `pi-mcp-adapter` | MCP tooling used by the ChunkHound-flavored templates | `pi install npm:pi-mcp-adapter` |
| `agent-browser` | browser automation referenced by review templates | see its docs |
| ChunkHound (MCP) | code research used by `/explain-branch`, `/review-worktree` | via `pi-mcp-adapter` |

## Install

```bash
pi install npm:pi-agenticoding
pi install npm:pi-mcp-adapter
pi install git:github.com/agenticoding/ofri-prompts

mkdir -p ~/.pi/agent/pi-agenticoding
cp ~/.pi/agent/git/github.com/agenticoding/ofri-prompts/model-groups/model-groups.json ~/.pi/agent/pi-agenticoding/model-groups.json
```

The templates install as a pi package; the last two lines place the routing policy where the extension reads it.

- **Your own templates:** drop `.md` files into `~/.pi/agent/prompts/` — they load alongside these and **win by name** (your `/commit` beats ours). Upgrades never touch that directory.
- **Override one of ours:** copy it to `~/.pi/agent/prompts/<name>.md` and edit — it's now yours; upstream updates to that template stop applying.
- **Upgrade:** `pi update --extensions`, or move to a newer version with `pi install git:github.com/agenticoding/ofri-prompts@v0.1.1` (each release is tagged).
- **Routing policy updates:** re-run the `cp` line above, or fetch `https://raw.githubusercontent.com/agenticoding/ofri-prompts/main/model-groups/model-groups.json` — the policy is user-owned config, last-writer-wins is fine.

### Contributor setup

Want to edit or fork the templates? Use the symlink layout (what the author runs):

```bash
git clone https://github.com/agenticoding/ofri-prompts.git ~/agenticoding/ofri-prompts

ln -s ~/agenticoding/ofri-prompts/prompts ~/.pi/agent/prompts
mkdir -p ~/.pi/agent/pi-agenticoding
ln -s ~/agenticoding/ofri-prompts/model-groups/model-groups.json ~/.pi/agent/pi-agenticoding/model-groups.json
```

Edits apply instantly; updates are `git pull`. Keep personal templates out of the repo's `prompts/` dir (they'd end up in the published package) — put them in a separate directory and register it via the `prompts` setting instead.

## Providers this build relies on

The reference setup routes models through these providers. All but one are **built into pi ≥ 0.73** — nothing to configure beyond authenticating with `/login`. The router skips providers that aren't configured or authenticated on your machine and uses another usable model in the group, so you only need *one* of them.

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

`model-group:` frontmatter (e.g. `/pr-review`, `/merge-conflicts`, `/debug-tests`) routes to a **group**: a set of `provider/model` entries with a thinking level. At spawn time the router picks a usable entry — one that is configured **and** authenticated on your machine (random among the usable ones). Edits to `model-groups.json` are picked up on the next agent run; no restart needed.

If no entry in a group is usable on your machine, the routed spawn **errors** — keep at least one provider you have access to in every group you use.

Edit the copy you placed during install (keep the group names — templates reference them — and keep `"version": 1`):

```bash
$EDITOR ~/.pi/agent/pi-agenticoding/model-groups.json
```

Project-scoped override: `.pi/pi-agenticoding/model-groups.json` (relative to the project root) wins over the global file.

### 2. Per-template model pins

Some templates pin a specific model in frontmatter — an author preference, e.g. `/commit` → `model: deepseek/deepseek-v4-flash`. To override a pin (or a `model-group:`), shadow the template: copy it to `~/.pi/agent/prompts/<name>.md` with the same filename and edit `model:`, `thinking:`, and/or `model-group:`. Local files in `~/.pi/agent/prompts/` take precedence over package copies (first-wins resolution), so your copy wins.

> **Contributors:** don't edit files inside the symlinked `prompts/` if you also `git pull` — you'll hit merge conflicts. Shadow copies (above) are the conflict-free path.

### 3. Providers

- Built-in providers: authenticate with `pi /login`.
- Custom/self-hosted providers: `~/.pi/agent/models.json` (example above).
- A provider must be authenticated before it counts as "usable" for group routing.

## Keeping up to date

- **Package install (recommended):** `pi update --extensions`, or re-pin to a newer tag (`pi install git:github.com/agenticoding/ofri-prompts@v0.2.0`). Your local templates are never touched.
- **Contributor (clone + symlink):** `git pull` in the repo.
- **Author:** edit in the repo (the symlinked paths apply instantly), `git push` — publishing is a normal commit.

## Security

- This repo intentionally contains **no credentials**. `~/.pi/agent/auth.json`, `models-store.json`, and `mcp-oauth/` hold keys — never commit or publish them.
- Pi packages run with full system access — review source before installing third-party packages.

## License

MIT — see [LICENSE](LICENSE).
