#!/usr/bin/env node
'use strict';

const fs = require('node:fs');
const path = require('node:path');
const { ROOT } = require('./shared');

const DEFAULT_CLI_DIR = path.join(ROOT, 'packages', 'cli', 'straddle-pp-cli');
const EXPECTED_SPEC_TITLE = 'Straddle API';

function readJson(filePath, errors) {
  try {
    return JSON.parse(fs.readFileSync(filePath, 'utf8'));
  } catch (e) {
    errors.push(`${filePath}: invalid JSON (${e.message})`);
    return null;
  }
}

function validateCli(cliDir = DEFAULT_CLI_DIR) {
  const errors = [];
  const passes = [];

  function mustExist(filePath, label) {
    if (!fs.existsSync(filePath)) {
      errors.push(`${label} is missing: ${filePath}`);
      return false;
    }
    passes.push(`${label}: ${filePath}`);
    return true;
  }

  function mustBeDirectory(dirPath, label) {
    if (!fs.existsSync(dirPath)) {
      errors.push(`${label} is missing: ${dirPath}`);
      return false;
    }
    if (!fs.statSync(dirPath).isDirectory()) {
      errors.push(`${label} is not a directory: ${dirPath}`);
      return false;
    }
    passes.push(`${label}: ${dirPath}`);
    return true;
  }

  const printingPressConfigPath = path.join(cliDir, '.printing-press.json');
  const specPath = path.join(cliDir, 'spec.json');
  const cliMainPath = path.join(cliDir, 'cmd', 'straddle-pp-cli', 'main.go');
  const defaultMcpMainPath = path.join(cliDir, 'cmd', 'straddle-pp-mcp', 'main.go');

  const hasPrintingPressConfig = mustExist(printingPressConfigPath, 'Printing Press config');
  mustExist(cliMainPath, 'CLI main.go');
  mustExist(path.join(cliDir, 'README.md'), 'generated README.md');
  mustExist(path.join(cliDir, 'SKILL.md'), 'generated SKILL.md');

  let printingPressConfig = null;
  if (hasPrintingPressConfig) {
    printingPressConfig = readJson(printingPressConfigPath, errors);
  }

  if (mustExist(specPath, 'spec.json')) {
    const spec = readJson(specPath, errors);
    const specTitle = spec && spec.info && spec.info.title;
    if (specTitle !== EXPECTED_SPEC_TITLE) {
      errors.push(`${specPath}: expected info.title to be "${EXPECTED_SPEC_TITLE}", got ${JSON.stringify(specTitle)}`);
    } else {
      passes.push(`spec.json identifies ${EXPECTED_SPEC_TITLE}`);
    }
  }

  const configuredMcpBinary = printingPressConfig && printingPressConfig.mcp_binary;
  const mcpMainPath = configuredMcpBinary
    ? path.join(cliDir, 'cmd', configuredMcpBinary, 'main.go')
    : defaultMcpMainPath;
  const shouldCheckMcp = Boolean(configuredMcpBinary) || fs.existsSync(defaultMcpMainPath);

  if (shouldCheckMcp) {
    mustExist(mcpMainPath, 'MCP main.go');
    mustBeDirectory(path.join(cliDir, 'internal', 'mcp'), 'internal/mcp');
    mustExist(path.join(cliDir, 'internal', 'mcp', 'tools.go'), 'MCP tools.go');
  }

  return { errors, passes };
}

function printResult(result) {
  console.log('\n=== Generated CLI artifacts ===');
  for (const msg of result.passes) {
    console.log(`  OK: ${msg}`);
  }
  for (const msg of result.errors) {
    console.error(`  FAIL: ${msg}`);
  }
  console.log(`\n=== CLI validation summary: ${result.errors.length} error${result.errors.length !== 1 ? 's' : ''} ===`);
}

if (require.main === module) {
  const cliDir = process.argv[2] ? path.resolve(process.argv[2]) : DEFAULT_CLI_DIR;
  const result = validateCli(cliDir);
  printResult(result);
  process.exit(result.errors.length > 0 ? 1 : 0);
}

module.exports = {
  DEFAULT_CLI_DIR,
  validateCli,
};
