#!/usr/bin/env bash
set -euo pipefail

# Push the current git repo to an SSH remote on GitHub.
# Required env var:
#   REPO_SSH - SSH URL like git@github.com:owner/repo.git

: "${REPO_SSH:?Set REPO_SSH (e.g., git@github.com:owner/marketing-director-agent.git)}"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: Must be run inside a git repository (e.g., /workspace/marketing)" >&2
  exit 1
fi

echo "Setting remote 'origin' to ${REPO_SSH}"

git remote remove origin 2>/dev/null || true
git remote add origin "${REPO_SSH}"

echo "Pushing main branch and tags over SSH..."

git push -u origin main --tags

echo "Done. Repo: ${REPO_SSH}"