#!/usr/bin/env bash
set -euo pipefail

# Creates a GitHub repo and pushes the current repo to it.
# Required env vars:
#   GITHUB_TOKEN  - GitHub Personal Access Token with repo scope
#   GITHUB_OWNER  - Username or org name to own the repo (e.g., your-username)
#   REPO_NAME     - Repository name to create (e.g., marketing-director-agent)
# Optional env vars:
#   GITHUB_ORG    - If set, creates under this org; otherwise under authenticated user
#   REPO_PRIVATE  - true|false (default: true)

: "${GITHUB_TOKEN:?Set GITHUB_TOKEN}"
: "${GITHUB_OWNER:?Set GITHUB_OWNER}"
: "${REPO_NAME:?Set REPO_NAME}"

REPO_PRIVATE=${REPO_PRIVATE:-true}
API_URL="https://api.github.com"

create_repo() {
  if [[ -n "${GITHUB_ORG:-}" ]]; then
    echo "Creating repo under org: ${GITHUB_ORG}/${REPO_NAME} (private=${REPO_PRIVATE})"
    curl -sSf -X POST \
      -H "Authorization: token ${GITHUB_TOKEN}" \
      -H "Accept: application/vnd.github+json" \
      "${API_URL}/orgs/${GITHUB_ORG}/repos" \
      -d "{\"name\":\"${REPO_NAME}\",\"private\":${REPO_PRIVATE}}" > /dev/null
  } else
    echo "Creating repo under user: ${REPO_NAME} (private=${REPO_PRIVATE})"
    curl -sSf -X POST \
      -H "Authorization: token ${GITHUB_TOKEN}" \
      -H "Accept: application/vnd.github+json" \
      "${API_URL}/user/repos" \
      -d "{\"name\":\"${REPO_NAME}\",\"private\":${REPO_PRIVATE}}" > /dev/null
  fi
}

push_code() {
  local token_remote="https://${GITHUB_TOKEN}@github.com/${GITHUB_OWNER}/${REPO_NAME}.git"
  local clean_remote="https://github.com/${GITHUB_OWNER}/${REPO_NAME}.git"

  git remote remove origin 2>/dev/null || true
  git remote add origin "${token_remote}"
  git push -u origin main --tags
  # Remove token from remote URL after push
  git remote set-url origin "${clean_remote}"
}

# Main
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: Must be run inside a git repository (e.g., /workspace/marketing)" >&2
  exit 1
fi

create_repo
push_code

echo "Done. Repo: https://github.com/${GITHUB_OWNER}/${REPO_NAME}"