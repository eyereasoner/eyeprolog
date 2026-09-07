#!/usr/bin/env node
// Regression coverage for call_cleanup/2 and setup_call_cleanup/3.
import path from 'node:path';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import {
  assertEqual,
  assertIncludes,
  assertNotIncludes,
  isMainModule,
  runStandalone,
} from './test-style.mjs';

const testRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)));
const packageRoot = path.resolve(testRoot, '..');
const bin = path.join(packageRoot, 'bin', 'eyeprolog.js');

export function runCleanup(reporter) {
  reporter.section('Cleanup control');

  reporter.test('call_cleanup/2 deterministic success has no leftover choicepoint', () => {
    const result = runRepl('call_cleanup(true,true).\nhalt.\n');
    assertEqual(result.status, 0, 'status');
    assertIncludes(result.stdout, 'true.', 'stdout');
    assertNotIncludes(result.stdout, '\n;', 'stdout');
    assertEqual(result.stderr, '', 'stderr');
  });

  reporter.test('call_cleanup/2 runs cleanup when the user stops enumeration', () => {
    const result = runRepl('call_cleanup((X=one;X=two),write(issue48_cleanup)).\n.\nhalt.\n');
    assertEqual(result.status, 0, 'status');
    assertIncludes(result.stdout, 'X = one', 'first answer');
    assertIncludes(result.stdout, 'issue48_cleanup', 'cleanup output');
    assertNotIncludes(result.stdout, 'X = two', 'unrequested answer');
    assertEqual(count(result.stdout, 'issue48_cleanup'), 1, 'cleanup count');
    assertEqual(result.stderr, '', 'stderr');
  });

  reporter.test('call_cleanup/2 runs before continuation after cut and sees current bindings', () => {
    const result = runRepl(
      'call_cleanup((X=one;X=two),assertz(issue48_saved(X))),!,issue48_saved(Y).\nhalt.\n',
    );
    assertEqual(result.status, 0, 'status');
    assertIncludes(result.stdout, 'X = one, Y = one.', 'cut cleanup answer');
    assertNotIncludes(result.stdout, 'false.', 'stdout');
    assertEqual(result.stderr, '', 'stderr');
  });

  reporter.test('call_cleanup/2 preserves protected exception over cleanup exception', () => {
    const result = runRepl('catch(call_cleanup(throw(original),throw(cleanup)),E,true).\nhalt.\n');
    assertEqual(result.status, 0, 'status');
    assertIncludes(result.stdout, 'E = original.', 'caught exception');
    assertNotIncludes(result.stdout, 'E = cleanup', 'exception priority');
    assertEqual(result.stderr, '', 'stderr');
  });

  reporter.test('exception unwind removes Goal bindings before Cleanup', () => {
    const result = runRepl(
      'catch((setup_call_cleanup(true,(G=bound;G=other),(var(G)->write(cleanup_unbound);write(cleanup_bound))),throw(cont)),E,true).\nhalt.\n',
    );
    assertEqual(result.status, 0, 'status');
    assertIncludes(result.stdout, 'cleanup_unbound', 'cleanup binding state');
    assertNotIncludes(result.stdout, 'cleanup_bound', 'unwound Goal binding');
    assertIncludes(result.stdout, 'E = cont.', 'continuation exception');
    assertEqual(result.stderr, '', 'stderr');
  });

  reporter.test('nested call_cleanup/2 cleanups run inside-out on cut', () => {
    const result = runRepl(
      'call_cleanup(call_cleanup((X=one;X=two),write(inner_cleanup)),write(outer_cleanup)),!,true.\nhalt.\n',
    );
    assertEqual(result.status, 0, 'status');
    const inner = result.stdout.indexOf('inner_cleanup');
    const outer = result.stdout.indexOf('outer_cleanup');
    if (inner < 0 || outer < 0 || inner >= outer) {
      throw new Error(`cleanup order mismatch\nstdout: ${JSON.stringify(result.stdout)}`);
    }
    assertEqual(count(result.stdout, 'inner_cleanup'), 1, 'inner cleanup count');
    assertEqual(count(result.stdout, 'outer_cleanup'), 1, 'outer cleanup count');
    assertEqual(result.stderr, '', 'stderr');
  });

  reporter.test('setup_call_cleanup/3 calls Setup once and ignores cleanup failure', () => {
    const result = runRepl('setup_call_cleanup((X=one;X=two),true,fail).\nhalt.\n');
    assertEqual(result.status, 0, 'status');
    assertIncludes(result.stdout, 'X = one.', 'setup result');
    assertNotIncludes(result.stdout, 'X = two', 'second setup solution');
    assertNotIncludes(result.stdout, '\n;', 'leftover choicepoint');
    assertEqual(result.stderr, '', 'stderr');
  });

  reporter.test('setup_call_cleanup/3 exposes deterministic Cleanup substitutions (issue #77)', () => {
    const result = runRepl(
      'setup_call_cleanup(true,A=1,throw(called(A))).\n' +
      'setup_call_cleanup(true,A=1,B=1).\n' +
      'halt.\n',
    );
    assertEqual(result.status, 0, 'exit status');
    assertIncludes(result.stdout, 'throw(called(1)).', 'Cleanup sees Goal substitutions');
    assertIncludes(result.stdout, 'A = 1, B = 1.', 'answer includes Cleanup substitutions');
    assertEqual(result.stderr, '', 'stderr');
  });

  reporter.test('setup_call_cleanup/3 does not install cleanup when Setup fails', () => {
    const result = runRepl('setup_call_cleanup(fail,true,write(should_not_run)).\nhalt.\n');
    assertEqual(result.status, 0, 'status');
    assertIncludes(result.stdout, 'false.', 'failed setup');
    assertNotIncludes(result.stdout, 'should_not_run', 'cleanup output');
    assertEqual(result.stderr, '', 'stderr');
  });

  reporter.test('setup_call_cleanup/3 validates Cleanup after successful Setup', () => {
    const result = runRepl('catch(setup_call_cleanup(true,true,_),E,true).\nhalt.\n');
    assertEqual(result.status, 0, 'status');
    assertIncludes(result.stdout, 'instantiation_error', 'cleanup validation error');
    assertEqual(result.stderr, '', 'stderr');
  });

  reporter.test('cleanup predicates remain outside strict ISO core', () => {
    const result = runRepl('catch(call_cleanup(true,true),E,true).\nhalt.\n', ['--iso-strict']);
    assertEqual(result.status, 0, 'status');
    assertIncludes(result.stdout, 'existence_error(procedure', 'strict ISO error');
    assertIncludes(result.stdout, 'call_cleanup', 'strict ISO predicate');
    assertEqual(result.stderr, '', 'stderr');
  });

  reporter.sectionTotal('cleanup');
}

function runRepl(input, args = []) {
  const result = spawnSync(process.execPath, [bin, ...args], {
    cwd: packageRoot,
    input,
    encoding: 'utf8',
    timeout: 10000,
  });
  if (result.error) throw result.error;
  return result;
}

function count(text, needle) {
  return String(text).split(needle).length - 1;
}

if (isMainModule(import.meta.url)) {
  await runStandalone((reporter) => runCleanup(reporter));
}
