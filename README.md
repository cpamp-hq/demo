# CPA Manager Plus — Demo Site (`cpamp-hq/demo`)

Live site: **<https://cpamp-demo.seakee.dev/>**

This repository hosts the public online demo for [CPA Manager Plus](https://github.com/seakee/CPA-Manager-Plus) on GitHub Pages.

- **Current root (`/`)**: Frozen **1.x Stable** demo built from the immutable product tag `v1.14.10` (`a67ed8834a914ab24c36d2490fa6bb6d4166724c`).
- All data displayed in the demo is synthetic/fictional. The demo is not a deployment or runtime mode and never connects to, manages, or monitors a real CPA instance.
- No external fonts, CDN scripts, or analytics SDKs are loaded.

## Deep Links

- Dashboard: <https://cpamp-demo.seakee.dev/> (`#/demo`)
- Request Monitoring: <https://cpamp-demo.seakee.dev/#/demo/monitoring>
- Usage & Cost Analytics: <https://cpamp-demo.seakee.dev/#/demo/usage-analytics>
- Unified Accounts & Quota: <https://cpamp-demo.seakee.dev/#/demo/accounts>

## Repository Layout

```text
.
├── .github/workflows/deploy.yml   # Uploads site/ directly to GitHub Pages (no build in CI)
├── PROVENANCE.md                  # Exact tag, commit, Node version, commands, and SHA-256 digests
├── scripts/
│   ├── build-v1.sh                # Reproduces the frozen 1.x build from a product git tag into site/
│   └── inject-v1-badge.mjs        # Post-processes raw dist-demo/index.html to add the 1.x Stable badge
└── site/
    ├── .nojekyll
    ├── 404.html                   # Redirects unknown paths to / while preserving location.hash
    ├── apple-touch-icon.png
    ├── favicon.ico
    └── index.html                 # Committed frozen 1.x Stable single-file demo bundle
```

## Reproducing the Frozen 1.x Build

With a local checkout of `seakee/CPA-Manager-Plus` containing tag `v1.14.10`:

```bash
./scripts/build-v1.sh v1.14.10 /path/to/CPA-Manager-Plus
```

See [`PROVENANCE.md`](PROVENANCE.md) for recorded build environment details and SHA-256 checksums.

## Related Sites

- Project Home: <https://cpamp.seakee.dev/>
- Documentation: <https://cpamp-docs.seakee.dev/>
- Product Repository: <https://github.com/seakee/CPA-Manager-Plus>
