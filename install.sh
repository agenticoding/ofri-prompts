#!/usr/bin/env bash
# ofri-prompts — one-command local setup.
# Symlinks the repo's prompts/ and model-groups.json into the global pi agent dir
# so edits in this repo take effect immediately and publishing is just `git push`.
# Never destroys existing content: existing templates are merged into the repo
# first; existing files that would be replaced are kept as *.bak.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENT_DIR="${HOME}/.pi/agent"
PROMPTS_SRC="${REPO_DIR}/prompts"
PROMPTS_DEST="${AGENT_DIR}/prompts"
MG_SRC="${REPO_DIR}/model-groups/model-groups.json"
MG_DEST="${AGENT_DIR}/pi-agenticoding/model-groups.json"

link_or_merge() {
  local src="$1" dest="$2" name="$3"
  if [ -L "$dest" ]; then
    local target
    target="$(readlink "$dest")"
    if [ "$target" = "$src" ]; then
      echo "ok    ${name}: already linked to ${src}"
    else
      echo "swap  ${name}: replacing existing symlink (${target})"
      rm "$dest"
      ln -s "$src" "$dest"
    fi
    return
  fi
  if [ -e "$dest" ]; then
    if [ -d "$dest" ]; then
      echo "merge ${name}: moving existing templates from ${dest} into the repo"
      mkdir -p "$src"
      cp -n "$dest"/*.md "$src"/ 2>/dev/null || true
      rm -rf "$dest"
    else
      echo "backup ${name}: existing file kept as ${dest}.bak"
      mv "$dest" "${dest}.bak"
    fi
  fi
  mkdir -p "$(dirname "$dest")"
  ln -s "$src" "$dest"
  echo "link  ${name}: ${dest} -> ${src}"
}

mkdir -p "$AGENT_DIR"
link_or_merge "$PROMPTS_SRC" "$PROMPTS_DEST" "prompts"
link_or_merge "$MG_SRC" "$MG_DEST" "model-groups"

echo
echo "Done. Templates load from ${REPO_DIR}."
echo "Publish with: git -C ${REPO_DIR} push"
