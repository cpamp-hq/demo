# Provenance — Frozen 1.x Stable Demo

This repository ships a frozen single-file build of the CPA Manager Plus 1.x Stable demo at `site/index.html`. No product build runs in CI; GitHub Actions uploads `site/` directly to GitHub Pages.

## Source & Build Environment

| Field | Value |
|---|---|
| Product repository | `https://github.com/seakee/CPA-Manager-Plus` |
| Product tag | `v1.14.10` |
| Product commit SHA | `a67ed8834a914ab24c36d2490fa6bb6d4166724c` |
| Node.js version | `v22.21.1` (product `.nvmrc` pins `24.22.1`) |
| npm version | `10.9.4` |
| OS / architecture | `darwin 22.6.0 (x86_64)` |
| Build date | `2026-11-12` |

## Build & Post-Process Commands

1. Export the immutable tag from the product repository without modifying any working tree and build the single-file demo bundle:

   ```bash
   WORK_DIR="$(mktemp -d /tmp/cpamp-demo-build-XXXXXX)"
   git -C /Users/seakee/WorkSpace/Node/CPA-Manager-Plus archive v1.14.10 | tar -x -C "$WORK_DIR"
   (
     cd "$WORK_DIR"
     unset VERSION
     npm ci && npm run build:demo
   )
   ```

2. Copy static icon fallbacks from `apps/web/dist-demo/` and inject the fixed-position `1.x Stable 演示 / 1.x Stable demo` badge immediately before the closing `</body>` tag (no other bytes in the bundle are modified):

   ```bash
   cp "$WORK_DIR/apps/web/dist-demo/favicon.ico" site/favicon.ico
   cp "$WORK_DIR/apps/web/dist-demo/apple-touch-icon.png" site/apple-touch-icon.png
   node scripts/inject-v1-badge.mjs "$WORK_DIR/apps/web/dist-demo/index.html" site/index.html
   ```

3. Single-command reproduction from repository root:

   ```bash
   ./scripts/build-v1.sh v1.14.10
   ```

## Artifact Checksums (SHA-256)

| File | Bytes | SHA-256 |
|---|---:|---|
| Raw build (`apps/web/dist-demo/index.html`) | `6643546` | `a31e7be727c0659abad0b3f1bcc6cf687c8f8e55bdcb5963fa4a2b9d5d65ae21` |
| Shipped build (`site/index.html`) | `6644621` | `c36154ef13e7d7bb1f82379eaf339777d6a1045ce572fe4108b7c039c62e99a6` |
| `site/404.html` | `706` | `54d44a0ca80e8134bdcae21270386d29fd34c732c538dfa9471d35e254a0cc43` |
| `site/favicon.ico` | `5542` | `0e7d9d8d148662ec97091f9f49503524a91e3284ae9090161e532191e063f3b7` |
| `site/apple-touch-icon.png` | `2497` | `ad75e89a357fd8ac825efc90be2ef0ac12b820d7e69f369045efecd62f593927` |

## Verification

```bash
shasum -a 256 site/index.html site/404.html site/favicon.ico site/apple-touch-icon.png
```
