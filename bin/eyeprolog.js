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

// Writing into a pipe whose reader has already gone is a normal way for a
// command line to end -- `eyeprolog --proof p.pl | head`, or a checker that
// rejects a proof and exits before the producer finishes. Node reports it as
// an unhandled error event on stdout, which would otherwise turn an ordinary
// early exit into a crash dump.
process.stdout.on('error', (error) => {
  if (error?.code === 'EPIPE') process.exit(0);
  throw error;
});

const { main } = await import('../src/cli.js');

await main(process.argv.slice(2)).catch((error) => {
  console.error(`eyeprolog: ${error && error.message ? error.message : String(error)}`);
  process.exitCode = 1;
});
