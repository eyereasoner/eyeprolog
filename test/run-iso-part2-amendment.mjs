#!/usr/bin/env node
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { run } from '../src/index.js';
import { Program } from '../src/program.js';
import { TestReporter, assertEqual, isMainModule, runStandalone } from './test-style.mjs';

function withModuleTree(files, test) {
  const directory = fs.mkdtempSync(path.join(os.tmpdir(), 'eyeprolog-part2-amendment-'));
  try {
    for (const [name, source] of Object.entries(files)) {
      fs.writeFileSync(path.join(directory, name), source);
    }
    return test(directory);
  } finally {
    fs.rmSync(directory, { recursive: true, force: true });
  }
}

function programFrom(directory, source, filename = 'main.pl') {
  return Program.parseSources([{ text: source, filename: path.join(directory, filename), baseDir: directory }]);
}

export function runIsoPart2Amendment(reporter = new TestReporter()) {
  reporter.section('ISO/IEC 13211-2 amendment 2013');

  reporter.test('module/2 exports are imported by use_module/1 while private predicates stay local', () => {
    withModuleTree({
      'colors.pl': [
        ':- module(colors, [tone/1]).',
        'tone(blue).',
        'hidden(private).',
        '',
      ].join('\n'),
    }, (directory) => {
      const program = programFrom(directory, [
        ":- use_module('colors.pl').",
        'answer(X) :- tone(X).',
        '',
      ].join('\n'));
      assertEqual(run(program, { goal: 'answer(X)' }).stdout, 'answer(blue).\n', 'use_module/1 export import');
      assertEqual(program.findGroup('hidden', 1, 'user'), null, 'private predicate not imported');
      assertEqual(program.findGroup('hidden', 1, 'colors')?.module, 'colors', 'private predicate remains in defining module');
    });
  });

  reporter.test('use_module/2 selectively imports named exported predicates', () => {
    withModuleTree({
      'palette.pl': [
        ':- module(palette, [red/0, blue/0]).',
        'red.',
        'blue.',
        '',
      ].join('\n'),
    }, (directory) => {
      const program = programFrom(directory, [
        ":- use_module('palette.pl', [red/0]).",
        'answer :- red.',
        '',
      ].join('\n'));
      assertEqual(run(program, { goal: 'answer' }).stdout, 'answer.\n', 'selective import execution');
      assertEqual(program.findGroup('red', 0, 'user')?.module, 'palette', 'selected export imported');
      assertEqual(program.findGroup('blue', 0, 'user'), null, 'unselected export not imported');
    });
  });

  reporter.test('ensure_loaded/1 imports public predicates from a module like use_module/1', () => {
    withModuleTree({
      'colors.pl': [
        ':- module(colors, [tone/1]).',
        'tone(blue).',
        '',
      ].join('\n'),
    }, (directory) => {
      const program = programFrom(directory, [
        ":- ensure_loaded('colors.pl').",
        'answer(X) :- tone(X).',
        '',
      ].join('\n'));
      assertEqual(run(program, { goal: 'answer(X)' }).stdout, 'answer(blue).\n', 'ensure_loaded/1 module import');
    });
  });

  reporter.test('repeated ensure_loaded/1 still imports an already loaded module into each caller', () => {
    withModuleTree({
      'colors.pl': [
        ':- module(colors, [tone/1]).',
        'tone(blue).',
        '',
      ].join('\n'),
      'left.pl': [
        ':- module(left, [answer/1]).',
        ":- ensure_loaded('colors.pl').",
        'answer(X) :- tone(X).',
        '',
      ].join('\n'),
      'right.pl': [
        ':- module(right, [answer/1]).',
        ":- ensure_loaded('colors.pl').",
        'answer(X) :- tone(X).',
        '',
      ].join('\n'),
    }, (directory) => {
      const program = programFrom(directory, [
        ":- use_module('left.pl', [answer/1]).",
        ":- use_module('right.pl', []).",
        'both(X,Y) :- left:answer(X), right:answer(Y).',
        '',
      ].join('\n'));
      assertEqual(run(program, { goal: 'both(X,Y)' }).stdout, 'both(blue, blue).\n', 'per-caller ensure_loaded import');
    });
  });

  reporter.test('module source loaded by use_module/1 begins with module/2', () => {
    withModuleTree({
      'late.pl': [
        'before_module.',
        ':- module(late, [visible/0]).',
        'visible.',
        '',
      ].join('\n'),
    }, (directory) => {
      let error = null;
      try {
        programFrom(directory, ":- use_module('late.pl').\n");
      } catch (caught) {
        error = caught;
      }
      assertEqual(error?.formal, 'existence_error(module)', 'late module directive rejection');
    });
  });

  reporter.test('a second module/2 cannot restart a module body within the same Prolog text', () => {
    let error = null;
    try {
      Program.parse([
        ':- module(first, [one/0]).',
        'one.',
        ':- module(second, [two/0]).',
        'two.',
        '',
      ].join('\n'));
    } catch (caught) {
      error = caught;
    }
    assertEqual(Boolean(error), true, 'second module directive rejected');
  });

  reporter.test('distinct Prolog texts may each begin and end their own module body', () => {
    const program = Program.parseSources([
      { text: ':- module(first, [value/1]).\nvalue(first).\n', filename: '<first>' },
      { text: ':- module(second, [value/1]).\nvalue(second).\n', filename: '<second>' },
    ]);
    assertEqual(run(program, { goal: 'first:value(X)' }).stdout, 'first:value(first).\n', 'first text body');
    assertEqual(run(program, { goal: 'second:value(X)' }).stdout, 'second:value(second).\n', 'second text body');
  });

  reporter.test('meta_predicate directive accepts the amendment operator spelling', () => {
    const program = Program.parse([
      ':- module(example, [capture/2]).',
      ':- meta_predicate capture(:, *).',
      'capture(Goal, Module) :- Goal = Module:_G.',
      '',
    ].join('\n'));
    assertEqual(program.findGroup('capture', 2, 'example')?.metaArgumentModes?.[0]?.kind,
      'context', 'colon meta mode registered');
  });

  reporter.test('colon meta-arguments are visibly prefixed with the calling source module', () => {
    withModuleTree({
      'trace.pl': [
        ':- module(trace, [capture/2]).',
        ':- meta_predicate capture(:, *).',
        'capture(Goal, Module) :- Goal = Module:_G.',
        '',
      ].join('\n'),
      'foo.pl': [
        ':- module(foo, [seen/1]).',
        ":- use_module('trace.pl').",
        'seen(Module) :- capture(local_goal, Module).',
        '',
      ].join('\n'),
    }, (directory) => {
      const program = programFrom(directory, ":- use_module('foo.pl').\n");
      assertEqual(run(program, { goal: 'foo:seen(Module)' }).stdout,
        'foo:seen(foo).\n', 'visible caller module prefix');
    });
  });

  reporter.test('colon meta-arguments preserve caller context when the argument is a variable', () => {
    withModuleTree({
      'trace.pl': [
        ':- module(trace, [invoke/1]).',
        ':- meta_predicate invoke(:).',
        'invoke(Goal) :- call(Goal).',
        '',
      ].join('\n'),
      'foo.pl': [
        ':- module(foo, [answer/1]).',
        ":- use_module('trace.pl').",
        'answer(X) :- Goal = private(X), invoke(Goal).',
        'private(ok).',
        '',
      ].join('\n'),
    }, (directory) => {
      const program = programFrom(directory, ":- use_module('foo.pl').\n");
      assertEqual(run(program, { goal: 'foo:answer(X)' }).stdout,
        'foo:answer(ok).\n', 'variable meta-argument caller context');
    });
  });

  reporter.test('strict Part 1 does not predeclare the Part 2 colon operator', () => {
    assertEqual(run('', { isoStrict: true, goal: "current_op(600,xfy,':')" }).stats.completed_goal_lists,
      0, 'strict Part 1 colon current_op');
    let error = null;
    try {
      Program.parse('p :- user:true.\n', { isoStrict: true });
    } catch (caught) {
      error = caught;
    }
    assertEqual(Boolean(error), true, 'strict Part 1 colon operator syntax rejected');
  });

  reporter.sectionTotal('ISO/IEC 13211-2 amendment 2013');
}

if (isMainModule(import.meta.url)) await runStandalone(runIsoPart2Amendment);
