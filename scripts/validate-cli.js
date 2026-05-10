#!/usr/bin/env node
'use strict';

const fs = require('node:fs');
const path = require('node:path');
const { ROOT } = require('./shared');

const DEFAULT_CLI_DIR = path.join(ROOT, 'packages', 'cli', 'straddle-pp-cli');
const EXPECTED_SPEC_TITLE = 'Straddle API';
const TYPED_FRAMEWORK_MCP_TOOLS = new Set(['search', 'sql', 'context']);

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
  const mcpToolsPath = path.join(cliDir, 'internal', 'mcp', 'tools.go');

  const hasPrintingPressConfig = mustExist(printingPressConfigPath, 'Printing Press config');
  mustExist(cliMainPath, 'CLI entrypoint');
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
    mustExist(mcpMainPath, 'MCP entrypoint');
    mustBeDirectory(path.join(cliDir, 'internal', 'mcp'), 'internal/mcp');
    if (mustExist(mcpToolsPath, 'MCP tools source')) {
      const toolsGo = fs.readFileSync(mcpToolsPath, 'utf8');
      const typedMcpToolNames = [...toolsGo.matchAll(/mcplib\.NewTool\(\s*"([^"]+)"/g)].map((match) => match[1]);
      const typedFrameworkToolNames = typedMcpToolNames.filter((name) => TYPED_FRAMEWORK_MCP_TOOLS.has(name));
      const endpointToolCount = typedMcpToolNames.length - typedFrameworkToolNames.length;
      const expectedFrameworkToolCount = TYPED_FRAMEWORK_MCP_TOOLS.size;

      passes.push(`MCP typed endpoint tool count: ${endpointToolCount}`);
      passes.push(`MCP typed framework tool count: ${typedFrameworkToolNames.length} (${typedFrameworkToolNames.join(', ')})`);
      passes.push(`MCP typed tool total: ${typedMcpToolNames.length}`);

      const missingFrameworkTools = [...TYPED_FRAMEWORK_MCP_TOOLS].filter((name) => !typedFrameworkToolNames.includes(name));
      if (missingFrameworkTools.length > 0) {
        errors.push(`MCP framework typed tools missing from internal/mcp/tools.go: ${missingFrameworkTools.join(', ')}`);
      }
      if (typedFrameworkToolNames.length !== expectedFrameworkToolCount) {
        errors.push(
          `MCP framework typed tool count mismatch: expected ${expectedFrameworkToolCount}, got ${typedFrameworkToolNames.length}`
        );
      }

      const expectedEndpointToolCount = printingPressConfig && printingPressConfig.mcp_tool_count;
      if (typeof expectedEndpointToolCount === 'number') {
        const expectedTypedToolTotal = expectedEndpointToolCount + expectedFrameworkToolCount;
        if (typedMcpToolNames.length !== expectedTypedToolTotal) {
          errors.push(
            `MCP typed tool total mismatch: internal/mcp/tools.go has ${typedMcpToolNames.length} typed tools, ` +
              `but expected ${expectedEndpointToolCount} endpoint tools plus ${expectedFrameworkToolCount} framework typed tools`
          );
        } else {
          passes.push(
            `MCP typed tool total matches endpoint plus framework tools: ${expectedEndpointToolCount} + ` +
              `${expectedFrameworkToolCount} = ${expectedTypedToolTotal}`
          );
        }

        if (endpointToolCount !== expectedEndpointToolCount) {
          errors.push(
            `MCP endpoint tool count mismatch: .printing-press.json mcp_tool_count is ${expectedEndpointToolCount}, ` +
              `but internal/mcp/tools.go has ${endpointToolCount} typed endpoint tools after subtracting ` +
              `${expectedFrameworkToolCount} framework typed tools`
          );
        } else {
          passes.push(`MCP endpoint tool count matches .printing-press.json mcp_tool_count: ${expectedEndpointToolCount}`);
        }
      } else {
        errors.push(`${printingPressConfigPath}: mcp_tool_count must be a number when MCP output exists`);
      }
    }
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
