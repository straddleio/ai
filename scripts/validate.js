#!/usr/bin/env node
'use strict';

const fs = require('fs');
const path = require('path');
const { ROOT, SKILLS_DIR, SYNC_TARGETS, SKIP } = require('./shared');

let errors = 0;

function fail(msg) { console.error(`  FAIL: ${msg}`); errors++; }
function pass(msg) { console.log(`  OK: ${msg}`); }

function filesIn(dir, prefix = '') {
  const result = [];
  if (!fs.existsSync(dir)) return result;
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    if (SKIP.has(entry.name)) continue;
    const rel = prefix ? `${prefix}/${entry.name}` : entry.name;
    if (entry.isDirectory()) {
      result.push(...filesIn(path.join(dir, entry.name), rel));
    } else {
      result.push(rel);
    }
  }
  return result;
}

function parseFrontmatter(content) {
  const match = content.match(/^---\n([\s\S]*?)\n---/);
  if (!match) return null;
  const block = match[1];
  const fields = {};
  let currentKey = null;
  for (const line of block.split('\n')) {
    const keyMatch = line.match(/^(\w[\w-]*):\s*(.*)/);
    if (keyMatch) {
      currentKey = keyMatch[1];
      const val = keyMatch[2].trim();
      if (val && !['>', '>-', '|', '|-'].includes(val)) {
        fields[currentKey] = val;
      } else {
        fields[currentKey] = '';
      }
    } else if (currentKey && /^\s+\S/.test(line)) {
      fields[currentKey] = ((fields[currentKey] || '') + ' ' + line.trim()).trim();
    }
  }
  return fields;
}

// Walk up from a file to find the skill root (directory containing SKILL.md).
// Returns null if no skill root is found within the project.
function findSkillRoot(filePath) {
  let dir = path.dirname(filePath);
  while (dir !== ROOT && dir !== path.dirname(dir)) {
    if (fs.existsSync(path.join(dir, 'SKILL.md'))) return dir;
    dir = path.dirname(dir);
  }
  return null;
}

// Extract <ref.md> references, skipping fenced code blocks.
function extractRefs(content) {
  const refs = [];
  let inFence = false;
  for (const line of content.split('\n')) {
    if (/^```/.test(line)) { inFence = !inFence; continue; }
    if (inFence) continue;
    for (const match of line.matchAll(/<([^>]+\.md)>/g)) {
      refs.push(match[1]);
    }
  }
  return refs;
}

// --- Check 1: Sync consistency ---

console.log('\n=== Sync consistency ===');
const canonical = new Set(filesIn(SKILLS_DIR));
for (const target of SYNC_TARGETS) {
  const label = path.relative(ROOT, target);
  const synced = new Set(filesIn(target));
  const before = errors;

  for (const f of canonical) {
    if (!synced.has(f)) {
      fail(`${label}: missing ${f}`);
    } else {
      const a = fs.readFileSync(path.join(SKILLS_DIR, f));
      const b = fs.readFileSync(path.join(target, f));
      if (Buffer.compare(a, b) !== 0) {
        fail(`${label}: out of sync -- ${f}`);
      }
    }
  }
  for (const f of synced) {
    if (!canonical.has(f)) {
      fail(`${label}: extra file -- ${f}`);
    }
  }
  if (errors === before) pass(`${label}: all files in sync`);
}

// --- Check 2: SKILL.md frontmatter ---

console.log('\n=== SKILL.md frontmatter ===');
const skillDirs = fs.readdirSync(SKILLS_DIR, { withFileTypes: true })
  .filter(e => e.isDirectory());

for (const dir of skillDirs) {
  const skillMd = path.join(SKILLS_DIR, dir.name, 'SKILL.md');
  if (!fs.existsSync(skillMd)) {
    fail(`skills/${dir.name}/: no SKILL.md`);
    continue;
  }
  const fm = parseFrontmatter(fs.readFileSync(skillMd, 'utf8'));
  if (!fm) { fail(`skills/${dir.name}/SKILL.md: no frontmatter`); continue; }
  if (!fm.name) fail(`skills/${dir.name}/SKILL.md: missing 'name'`);
  else pass(`skills/${dir.name}/SKILL.md: name = ${fm.name}`);
  if (!fm.description) fail(`skills/${dir.name}/SKILL.md: missing 'description'`);
  else pass(`skills/${dir.name}/SKILL.md: has description`);
}

// --- Check 3: Command frontmatter ---

console.log('\n=== Command frontmatter ===');
const cmdDir = path.join(ROOT, 'providers', 'claude', 'plugin', 'commands');
if (fs.existsSync(cmdDir)) {
  for (const file of fs.readdirSync(cmdDir).filter(f => f.endsWith('.md'))) {
    const content = fs.readFileSync(path.join(cmdDir, file), 'utf8');
    const fm = parseFrontmatter(content);
    if (!fm) { fail(`commands/${file}: no frontmatter`); continue; }
    if (!fm.description) fail(`commands/${file}: missing 'description'`);
    else pass(`commands/${file}: has description`);
    if (content.trim().split('\n').length < 3) fail(`commands/${file}: appears empty (fewer than 3 lines)`);
  }
}

// --- Check 4: Plugin manifests ---

console.log('\n=== Plugin manifests ===');

function checkJson(filePath, requiredFields) {
  const label = path.relative(ROOT, filePath);
  if (!fs.existsSync(filePath)) { fail(`${label}: file not found`); return null; }
  let data;
  try {
    data = JSON.parse(fs.readFileSync(filePath, 'utf8'));
  } catch (e) {
    fail(`${label}: invalid JSON`);
    return null;
  }
  let ok = true;
  for (const field of requiredFields) {
    if (!data[field]) { fail(`${label}: missing '${field}'`); ok = false; }
  }
  if (ok) pass(`${label}: required fields present`);
  return data;
}

const providerManifests = [
  { path: path.join(ROOT, 'providers', 'claude', 'plugin', '.claude-plugin', 'plugin.json'), fields: ['name', 'description', 'version'] },
  { path: path.join(ROOT, 'providers', 'cursor', 'plugin', '.cursor-plugin', 'plugin.json'), fields: ['name', 'description', 'version'] },
  { path: path.join(ROOT, 'providers', 'codex', 'plugin', '.codex-plugin', 'plugin.json'), fields: ['name', 'description', 'version'] },
];

const parsedManifests = new Map();
for (const m of providerManifests) {
  const data = checkJson(m.path, m.fields);
  if (data) parsedManifests.set(m.path, data);
}
checkJson(
  path.join(ROOT, '.claude-plugin', 'marketplace.json'),
  ['name', 'description', 'plugins']
);
checkJson(
  path.join(ROOT, '.agents', 'plugins', 'marketplace.json'),
  ['name', 'plugins']
);

// --- Check 5: Version consistency ---

console.log('\n=== Version consistency ===');
const pkgVersion = JSON.parse(
  fs.readFileSync(path.join(ROOT, 'package.json'), 'utf8')
).version;

let versionOk = true;
for (const m of providerManifests) {
  const data = parsedManifests.get(m.path);
  if (!data) continue;
  const label = path.relative(ROOT, m.path);
  if (data.version && data.version !== pkgVersion) {
    fail(`${label}: version ${data.version} does not match package.json ${pkgVersion}`);
    versionOk = false;
  }
}
if (versionOk) pass(`All manifests match package.json version ${pkgVersion}`);

// --- Check 6: MCP configs ---

console.log('\n=== MCP configs ===');
const mcpFiles = [
  path.join(ROOT, 'providers', 'claude', 'plugin', '.mcp.json'),
  path.join(ROOT, 'providers', 'codex', 'plugin', '.mcp.json'),
  path.join(ROOT, 'providers', 'cursor', 'plugin', 'mcp.json'),
];

for (const f of mcpFiles) {
  const label = path.relative(ROOT, f);
  if (!fs.existsSync(f)) { fail(`${label}: file not found`); continue; }
  let data;
  try { data = JSON.parse(fs.readFileSync(f, 'utf8')); }
  catch (e) { fail(`${label}: invalid JSON`); continue; }
  const servers = data.mcpServers;
  if (!servers) { fail(`${label}: missing mcpServers`); continue; }
  if (!servers.straddle) { fail(`${label}: missing straddle server`); continue; }
  pass(`${label}: valid`);
}

// --- Check 7: Internal references ---

console.log('\n=== Internal references ===');
let refsChecked = 0;

function checkRefs(dir) {
  if (!fs.existsSync(dir)) return;
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) { checkRefs(full); continue; }
    if (!entry.name.endsWith('.md')) continue;
    const content = fs.readFileSync(full, 'utf8');
    const refs = extractRefs(content);
    if (refs.length === 0) continue;
    const skillRoot = findSkillRoot(full);
    if (!skillRoot) {
      fail(`${path.relative(ROOT, full)}: has <ref> links but no SKILL.md in ancestor dirs`);
      continue;
    }
    for (const ref of refs) {
      refsChecked++;
      const resolved = path.resolve(skillRoot, ref);
      if (!fs.existsSync(resolved)) {
        fail(`${path.relative(ROOT, full)}: broken ref <${ref}>`);
      }
    }
  }
}

checkRefs(SKILLS_DIR);
pass(`Checked ${refsChecked} references across skill files`);

// --- Summary ---

console.log(`\n=== Summary: ${errors} error${errors !== 1 ? 's' : ''} ===`);
process.exit(errors > 0 ? 1 : 0);
