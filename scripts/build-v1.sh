#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 || -z "${1:-}" ]]; then
  echo "Usage: $0 <tag> [product-repo-path]" >&2
  echo "Example: $0 v1.14.10" >&2
  exit 1
fi

TAG="$1"
PRODUCT_REPO="${2:-${CPAMP_PRODUCT_REPO:-/Users/seakee/WorkSpace/Node/CPA-Manager-Plus}}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SITE_DIR="$REPO_ROOT/site"

if [[ ! -d "$PRODUCT_REPO/.git" && ! -f "$PRODUCT_REPO/HEAD" ]]; then
  echo "Error: product git repository not found at: $PRODUCT_REPO" >&2
  echo "Pass the checkout path as the second argument or set CPAMP_PRODUCT_REPO." >&2
  exit 1
fi

COMMIT_SHA="$(git -C "$PRODUCT_REPO" rev-parse "${TAG}^{commit}")"
NODE_VER="$(node -v)"
NPM_VER="$(npm -v)"

WORK_DIR="$(mktemp -d /tmp/cpamp-demo-build-XXXXXX)"
cleanup() {
  rm -rf "$WORK_DIR"
}
trap cleanup EXIT

echo "==> Exporting $TAG ($COMMIT_SHA) into $WORK_DIR"
git -C "$PRODUCT_REPO" archive "$TAG" | tar -x -C "$WORK_DIR"

echo "==> Building 1.x demo with Node $NODE_VER / npm $NPM_VER"
(
  cd "$WORK_DIR"
  unset VERSION
  npm ci
  npm run build:demo
)

RAW_HTML="$WORK_DIR/apps/web/dist-demo/index.html"
if [[ ! -f "$RAW_HTML" ]]; then
  echo "Error: expected single-file output not found at $RAW_HTML" >&2
  exit 1
fi

mkdir -p "$SITE_DIR"
for asset in favicon.ico apple-touch-icon.png; do
  if [[ -f "$WORK_DIR/apps/web/dist-demo/$asset" ]]; then
    cp "$WORK_DIR/apps/web/dist-demo/$asset" "$SITE_DIR/$asset"
  fi
done

node "$SCRIPT_DIR/inject-v1-badge.mjs" "$RAW_HTML" "$SITE_DIR/index.html"
: > "$SITE_DIR/.nojekyll"

sha256_file() {
  if command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$1" | awk '{print $1}'
  else
    sha256sum "$1" | awk '{print $1}'
  fi
}

RAW_SHA256="$(sha256_file "$RAW_HTML")"
SHIPPED_SHA256="$(sha256_file "$SITE_DIR/index.html")"

echo "==> Build complete"
echo "    Tag:            $TAG"
echo "    Commit:         $COMMIT_SHA"
echo "    Node:           $NODE_VER (npm $NPM_VER)"
echo "    Raw SHA-256:    $RAW_SHA256"
echo "    Shipped SHA-256: $SHIPPED_SHA256"
