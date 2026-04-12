#!/usr/bin/env node
'use strict';

const path = require('path');

const ROOT = path.resolve(__dirname, '..');
const SKILLS_DIR = path.join(ROOT, 'skills');
const SYNC_TARGETS = [
  path.join(ROOT, 'providers', 'claude', 'plugin', 'skills'),
  path.join(ROOT, 'providers', 'cursor', 'plugin', 'skills'),
  path.join(ROOT, 'providers', 'codex', 'plugin', 'skills'),
];
const SKIP = new Set(['sync.js', 'evals']);

module.exports = { ROOT, SKILLS_DIR, SYNC_TARGETS, SKIP };
