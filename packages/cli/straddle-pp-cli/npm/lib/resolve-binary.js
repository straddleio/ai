'use strict';

const fs = require('fs');
const path = require('path');
const { spawnSync } = require('child_process');

const platformMap = {
  darwin: 'darwin',
  linux: 'linux',
  win32: 'win32'
};

const archMap = {
  arm64: 'arm64',
  x64: 'x64'
};

module.exports = function runBundledBinary(commandName) {
  const platform = platformMap[process.platform];
  const arch = archMap[process.arch];
  if (!platform || !arch) {
    console.error(`Unsupported platform for ${commandName}: ${process.platform}/${process.arch}`);
    process.exit(1);
  }

  const executable = process.platform === 'win32' ? `${commandName}.exe` : commandName;
  const binaryPath = path.join(__dirname, '..', 'vendor', `${platform}-${arch}`, executable);
  if (!fs.existsSync(binaryPath)) {
    console.error(`Missing bundled ${commandName} binary for ${platform}-${arch}: ${binaryPath}`);
    process.exit(1);
  }

  const result = spawnSync(binaryPath, process.argv.slice(2), { stdio: 'inherit' });
  if (result.error) {
    console.error(result.error.message);
    process.exit(1);
  }
  if (result.signal) {
    process.kill(process.pid, result.signal);
    return;
  }
  process.exit(result.status === null ? 1 : result.status);
};
