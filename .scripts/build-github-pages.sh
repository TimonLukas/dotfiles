#!/usr/bin/env bash

set -eou pipefail

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  echo "Usage: $0 \$GITHUB_USERNAME [\$URL_INDEX_TXT]"
  exit 1
fi

param_github_username="$1"
param_url_index_txt="${2:-"https://$param_github_username.github.io/dotfiles/index.txt"}"

SCRIPT_DIR="$(realpath "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)")"
REPO_DIR="$(realpath "$SCRIPT_DIR/..")"
ASSETS_DIR="$SCRIPT_DIR/assets/github-pages"

TMP_DIR="$(mktemp -d --suffix=".build-github-pages")"
OUT_REPO_NAME="gh-pages-repo"
OUT_DIR="$TMP_DIR/$OUT_REPO_NAME"

repo_remote_url="$(git remote get-url origin)"

if [[ -v DEBUG ]]; then
  echo "[DEBUG] Parameters:"
  echo "- \$GITHUB_USERNAME: $param_github_username"
  echo "-   \$URL_INDEX_TXT: ${2:-"unset (defaulting to: $param_url_index_txt)"}"
  echo ""
  echo "[DEBUG] Paths:"
  echo "- SCRIPT_DIR: $SCRIPT_DIR"
  echo "-   REPO_DIR: $REPO_DIR"
  echo "- ASSETS_DIR: $ASSETS_DIR"
  echo "-    TMP_DIR: $TMP_DIR"
  echo "-    OUT_DIR: $OUT_DIR"
  echo ""
fi

echo "### Starting Github Pages build ###"

echo -n " 1. Initializing orphan branch in temporary repository..."
(
  cd "$TMP_DIR"
  git clone -q --depth 1 "$repo_remote_url" "$OUT_REPO_NAME"
  cd "$OUT_REPO_NAME"
  git switch -q --orphan gh-pages
)
echo " Done!"

echo -n " 2. Building index.txt..."
sed -e "s/\$GITHUB_USERNAME/$param_github_username/g" "$ASSETS_DIR/index.txt.template" > "$OUT_DIR/index.txt"
echo " Done!"

echo -n " 3. Building index.html..."
sed -e "s~\$URL_INDEX_TXT~$param_url_index_txt~g" "$ASSETS_DIR/index.html.template" > "$OUT_DIR/index.html"
echo " Done!"

echo -n " 4. Adding .nojekyll file..."
touch "$OUT_DIR/.nojekyll"
echo " Done!"

echo -n " 4. Pushing branch to remote..."
(
  cd "$OUT_DIR"
  git add .nojekyll index.txt index.html
  git commit -q -m "Build new Github Pages assets"
  git push -q -f origin gh-pages
)
echo "Done!"

echo "### Finished Github Pages build ###"
