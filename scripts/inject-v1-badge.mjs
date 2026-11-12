#!/usr/bin/env node
import fs from 'node:fs';
import path from 'node:path';

const [, , inputPath, outputPath] = process.argv;

if (!inputPath || !outputPath) {
  console.error('Usage: node scripts/inject-v1-badge.mjs <raw-index.html> <output-index.html>');
  process.exit(1);
}

const BADGE_SNIPPET = `<style id="cpamp-v1-demo-badge-style">
#cpamp-v1-demo-badge{position:fixed;right:14px;bottom:14px;z-index:950;display:inline-flex;align-items:center;gap:6px;padding:5px 11px;border-radius:999px;background:rgba(15,23,42,.88);color:#f8fafc;border:1px solid rgba(148,163,184,.36);box-shadow:0 2px 8px rgba(15,23,42,.22);font:600 12px/1.35 -apple-system,BlinkMacSystemFont,"Segoe UI","PingFang SC","Hiragino Sans GB","Microsoft YaHei",sans-serif;letter-spacing:.01em;pointer-events:none;user-select:none;-webkit-backdrop-filter:blur(6px);backdrop-filter:blur(6px);transition:opacity .15s ease}
#cpamp-v1-demo-badge::before{content:"";width:7px;height:7px;border-radius:50%;background:#38bdf8;box-shadow:0 0 0 2px rgba(56,189,248,.24);flex:none}
body:has(.sidebar.open,[role="dialog"]) #cpamp-v1-demo-badge{opacity:0;visibility:hidden}
@media (max-width:640px){#cpamp-v1-demo-badge{right:10px;bottom:10px;padding:4px 9px;font-size:11px}}
</style>
<div id="cpamp-v1-demo-badge" role="note" aria-label="1.x Stable 演示 / 1.x Stable demo">1.x Stable 演示 / 1.x Stable demo</div>
`;

const raw = fs.readFileSync(inputPath);
const marker = Buffer.from('id="cpamp-v1-demo-badge"', 'utf8');
if (raw.includes(marker)) {
  console.error('Error: input HTML already contains #cpamp-v1-demo-badge');
  process.exit(1);
}

const closeBody = Buffer.from('</body>', 'utf8');
const insertOffset = raw.lastIndexOf(closeBody);
if (insertOffset === -1) {
  console.error('Error: closing </body> tag not found in input HTML');
  process.exit(1);
}

const injected = Buffer.concat([
  raw.subarray(0, insertOffset),
  Buffer.from(BADGE_SNIPPET, 'utf8'),
  raw.subarray(insertOffset),
]);

fs.mkdirSync(path.dirname(outputPath), { recursive: true });
fs.writeFileSync(outputPath, injected);
