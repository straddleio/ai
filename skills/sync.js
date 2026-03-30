#!/usr/bin/env node
const fs = require('fs');
const path = require('path');
const { ROOT, SYNC_TARGETS, SKIP } = require('../scripts/shared');

const SKILLS_DIR = __dirname;

function copyDir(src, dest) {
  fs.mkdirSync(dest, { recursive: true });
  for (const entry of fs.readdirSync(src, { withFileTypes: true })) {
    if (SKIP.has(entry.name)) continue;
    const s = path.join(src, entry.name);
    const d = path.join(dest, entry.name);
    entry.isDirectory() ? copyDir(s, d) : fs.copyFileSync(s, d);
  }
}

for (const target of SYNC_TARGETS) {
  if (fs.existsSync(target)) fs.rmSync(target, { recursive: true });
  copyDir(SKILLS_DIR, target);
  console.log(`  -> ${path.relative(ROOT, target)}`);
}
console.log('Done.');
