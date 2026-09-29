#!/usr/bin/env node
import module from 'node:module';

// Reuse V8's compilation of the engine between runs. Starting the CLI compiles
// the whole reasoner before it can answer anything, which dominates the cost of
// a short query -- the shape most command-line use has. The cache makes that
// compilation a one-off rather than a per-invocation charge.
//
// src/cli.js is imported dynamically on purpose: static imports are evaluated
// before this module's body runs, so a static one would already have been
// compiled by the time the cache was enabled.
//
// enableCompileCache is Node 22.1+, hence the optional call for the supported
// Node 18 floor. It reports failure through a return value rather than
// throwing, and Node honours NODE_DISABLE_COMPILE_CACHE, so an unwritable or
// unwanted cache directory simply leaves startup as it was.
module.enableCompileCache?.();

const { main } = await import('../src/cli.js');

await main(process.argv.slice(2)).catch((error) => {
  console.error(`eyeprolog: ${error && error.message ? error.message : String(error)}`);
  process.exitCode = 1;
});
