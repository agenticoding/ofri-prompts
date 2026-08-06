# ofri-prompts

Prompt template library for the **[Agentic Coding stack](https://agenticoding.ai)** — [pi](https://pi.dev) + [pi-agenticoding](https://github.com/agenticoding/pi-agenticoding) + [pi-mcp-adapter](https://github.com/nicobailon/pi-mcp-adapter) + [ChunkHound](https://chunkhound.ai) + [agent-browser](https://agent-browser.dev). Type `/command-name` in the pi editor to invoke a template.

## Install

Requires pi ≥ 0.83 and the two packages below; most commands rely on [ChunkHound](https://chunkhound.ai) for code research (MCP compatibility via [pi-mcp-adapter](https://github.com/nicobailon/pi-mcp-adapter)).

```bash
pi install npm:pi-agenticoding
pi install npm:pi-mcp-adapter
pi install git:github.com/agenticoding/ofri-prompts

mkdir -p ~/.pi/agent/pi-agenticoding
cp ~/.pi/agent/git/github.com/agenticoding/ofri-prompts/model-groups/model-groups.json ~/.pi/agent/pi-agenticoding/model-groups.json
```

Installs 13 `/command` templates as a pi package and places the model routing policy (`model-groups.json`) where `pi-agenticoding` reads it. Upgrade with `pi update --extensions`.

## ChunkHound (code research)

Most `/command` templates rely on ChunkHound — `code_research` over the git history (`vector_source="diff"`), semantic search, architecture research (`vector_source="db"`), and web search. Install it, configure it, and index your repo before using them — follow [ChunkHound's getting-started](https://chunkhound.ai/docs/getting-started/): `uv tool install chunkhound`, create `.chunkhound.json` (embedding + LLM keys — these also gate web search — [config docs](https://chunkhound.ai/docs/configuration/), gitignore it), then `chunkhound index .` from the repo root.

Then register the server in your project's `.mcp.json`. pi-mcp-adapter loads it automatically:

```json
{
  "mcpServers": {
    "ChunkHound": {
      "command": "chunkhound",
      "args": ["mcp"],
      "directTools": true,
      "lifecycle": "keep-alive",
      "idleTimeout": 12000,
      "requestTimeoutMs": 12000000
    }
  },
  "settings": {
    "outputGuard": false
  }
}
```

## Model routing

`model-group:` frontmatter (e.g. `/pr-review`, `/merge-conflicts`, `/debug-tests`) routes to a **group**: a set of `provider/model` entries with a thinking level. At spawn time the router picks whichever provider in the group is authenticated on your machine.

Maintain the policy in the copy you placed during install — swap `provider/model` entries for your own providers:

```bash
nano ~/.pi/agent/pi-agenticoding/model-groups.json
```

A project-scoped `.pi/pi-agenticoding/model-groups.json` (relative to the project root) wins over the global file.

## Providers

Everything except `poolside` is built into pi — authenticate with `pi /login` and you're done. Custom/self-hosted providers go in `~/.pi/agent/models.json` (see pi's `docs/custom-provider.md`); the reference setup defines `poolside` like this — substitute your own key:

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

## License

MIT — see [LICENSE](LICENSE).
