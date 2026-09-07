#!/usr/bin/env node
// Offline execution of the vendored WG17 conformity-testing syntax matrix.
// Every case is checked against the upstream Codex expectation. Reviewed
// exact EyeProlog outcomes are an additional regression lock, never a
// replacement for the upstream assertion.
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import {
  Env, Program, Solver, parseGoalText, run,
} from '../src/index.js';
import { parseTermText } from '../src/parser.js';
import { variantTerms } from '../src/term.js';
import { TestReporter, isMainModule, runStandalone } from './test-style.mjs';

const testRoot = path.dirname(fileURLToPath(import.meta.url));
const fixturePath = path.join(testRoot, 'conformance', 'wg17-syntax-cases.json');

function runnerStage(index, maximum) {
  if (index > maximum) return `write('\\n<WG17-COMPLETE>')`;
  return `read_term(G${index}, [variable_names(V${index})]), ` +
    `(G${index} == end_of_file -> write('\\n<WG17-COMPLETE>') ; (` +
    `write('\\n<WG17-BEGIN-${index}>'), call(G${index}), ` +
    `write('<WG17-VARS>'), write_term(V${index}, [quoted(true), variable_names(V${index})]), write('<WG17-END>'), ` +
    `${runnerStage(index + 1, maximum)}))`;
}

function capturedStages(stdout) {
  const complete = stdout.indexOf('<WG17-COMPLETE>');
  if (complete < 0) return null;
  const captured = stdout.slice(0, complete);
  return [...captured.matchAll(/<WG17-BEGIN-(\d+)>([\s\S]*?)<WG17-VARS>([\s\S]*?)<WG17-END>/g)]
    .map((match) => ({ output: match[2], variables: match[3] }));
}

function executeFinite(item, isoStrict = true) {
  try {
    // Match the upstream protocol: the Query cell plus its terminating newline
    // is input to read(G), G (and subsequent read/call stages when present).
    // This is essential for stream-sensitive cases such as #270 and #271.
    const result = run('', {
      isoStrict,
      goal: runnerStage(1, item.readCount ?? 16),
      ioOptions: { input: `${item.input}\n` },
    });
    const stages = capturedStages(result.stdout);
    return stages == null ? { type: 'failure' } : { type: 'success', stages };
  } catch (error) {
    return { type: 'error', formal: error?.formal ?? null };
  }
}

function executeWait(item, isoStrict = true) {
  const program = Program.parse('', { isoStrict });
  const solver = new Solver(program, {
    isoStrict,
    ioOptions: { input: `${item.input}\n` },
  });
  const stream = solver.io.resolve('user_input');
  let requests = 0;
  stream.interactiveReadTerm = () => {
    requests++;
    return null;
  };
  const goal = parseGoalText('read_term(G, [])', {
    isoStrict,
    operatorDefinitions: [...program.operators.values()],
  });
  try {
    [...solver.solve([goal], new Env(), 0)];
  } catch (_) {
    // Returning null models EOF only after EyeProlog has requested the extra
    // input that the upstream case classifies as "waits".
  }
  return requests === 1 ? { type: 'waits' } : { type: 'did_not_wait', requests };
}

function presentationText(value) {
  return String(value ?? '')
    .replace(/&sup[23];/gi, '')
    .replace(/[²³°]/g, '')
    .replace(/\u00a0/g, ' ')
    .replace(/\r\n?/g, '\n')
    .trim();
}

function canonicalUpstreamExpected(expected) {
  return presentationText(expected).replace(/[ \t\n]+/g, ' ').trim();
}

function bindingAnswer(text) {
  let value = String(text ?? '').trim();
  if (value === '[]') return '';
  if (value.startsWith('[') && value.endsWith(']')) value = value.slice(1, -1);
  return value.replace(/'([A-Z_][A-Za-z0-9_]*)'\s*=/g, '$1 =');
}

function observableCandidates(actual) {
  if (actual.type !== 'success') return [];
  const outputs = actual.stages.map(({ output }) => output ?? '').filter(Boolean);
  const bindings = actual.stages.map(({ variables }) => bindingAnswer(variables)).filter(Boolean);
  const candidates = new Set([...outputs, ...bindings]);
  if (outputs.length > 0) {
    candidates.add(outputs.join(''));
    candidates.add(outputs.join(' '));
  }
  if (bindings.length > 0) candidates.add(bindings.join(', '));
  if (outputs.length > 0 && bindings.length > 0) {
    candidates.add([...outputs, ...bindings].join(' '));
    candidates.add(`${outputs.join('')} ${bindings.join(', ')}`);
  }
  return [...candidates].filter(Boolean);
}

function stripLayoutOutsideQuotes(text) {
  const source = presentationText(text);
  let output = '';
  let quote = null;
  for (let index = 0; index < source.length; index++) {
    const ch = source[index];
    if (quote != null) {
      output += ch;
      if (ch === '\\' && index + 1 < source.length) {
        output += source[++index];
        continue;
      }
      if (ch === quote) {
        if (source[index + 1] === quote) output += source[++index];
        else quote = null;
      }
      continue;
    }
    if (ch === "'" || ch === '"' || ch === '`') {
      quote = ch;
      output += ch;
    } else if (!/\s/.test(ch)) {
      output += ch;
    }
  }
  return output.replace(/\.$/, '').replace(/([eE])\+(?=\d)/g, '$1');
}

function leadingGraphicOperatorParenSignature(text) {
  const source = presentationText(text);
  let index = 0;
  const operators = [];
  while (index < source.length) {
    const match = source.slice(index).match(/^[!#$&*+\-./<=>?@^~\\]+/);
    if (match == null) return null;
    operators.push(match[0]);
    index += match[0].length;
    const layoutStart = index;
    while (/\s/.test(source[index] ?? '')) index++;
    if (index === layoutStart) return null;
    if (source[index] === '(') return operators;
  }
  return null;
}

function preservesLeadingOperatorParenLayout(expected, actual) {
  const signature = leadingGraphicOperatorParenSignature(expected);
  if (signature == null) return true;
  const source = presentationText(actual);
  let index = 0;
  for (const operator of signature) {
    if (!source.startsWith(operator, index)) return false;
    index += operator.length;
    const layoutStart = index;
    while (/\s/.test(source[index] ?? '')) index++;
    if (index === layoutStart) return false;
  }
  return source[index] === '(';
}

function normalizeExampleVariables(text) {
  const names = new Map();
  let next = 0;
  return String(text).replace(/(?<![A-Za-z0-9_])_[A-Za-z0-9]+/g, (name) => {
    if (!names.has(name)) names.set(name, `_V${++next}`);
    return names.get(name);
  });
}

function unquoteAtomText(text) {
  const source = text.trim();
  if (!(source.startsWith("'") && source.endsWith("'"))) return source;
  let output = '';
  for (let index = 1; index < source.length - 1; index++) {
    const ch = source[index];
    if (ch === "'" && source[index + 1] === "'") {
      output += "'";
      index++;
      continue;
    }
    if (ch === '\\' && index + 1 < source.length - 1) {
      const escaped = source[++index];
      const symbolic = { a: '\x07', b: '\b', f: '\f', n: '\n', r: '\r', t: '\t', v: '\v' };
      output += symbolic[escaped] ?? escaped;
      continue;
    }
    output += ch;
  }
  return output;
}

function splitOperatorNames(text) {
  const source = text.trim();
  if (!source.startsWith('[')) return [unquoteAtomText(source)];
  const body = source.slice(1, -1);
  const names = [];
  let quote = false;
  let start = 0;
  for (let index = 0; index <= body.length; index++) {
    const ch = body[index];
    if (quote) {
      if (ch === "'" && body[index + 1] === "'") index++;
      else if (ch === "'") quote = false;
      continue;
    }
    if (ch === "'") {
      quote = true;
      continue;
    }
    if (ch === ',' || index === body.length) {
      names.push(unquoteAtomText(body.slice(start, index)));
      start = index + 1;
    }
  }
  return names.filter(Boolean);
}

function operatorDefinitionsFromInput(input) {
  const definitions = [];
  const pattern = /\bop\(\s*(\d+)\s*,\s*(fx|fy|xf|yf|xfx|xfy|yfx)\s*,\s*(\[[^\]]*\]|'(?:''|[^'])*'|[^)\s,]+)\s*\)/g;
  for (const match of String(input ?? '').matchAll(pattern)) {
    for (const name of splitOperatorNames(match[3])) {
      definitions.push([Number(match[1]), match[2], name]);
    }
  }
  return definitions;
}

function termEquivalent(expected, actual, item) {
  try {
    const operatorDefinitions = operatorDefinitionsFromInput(item?.input);
    const options = { isoStrict: true, operatorDefinitions };
    const left = parseTermText(`${presentationText(expected).replace(/\.$/, '')}.`, options);
    const right = parseTermText(`${presentationText(actual).replace(/\.$/, '')}.`, options);
    return variantTerms(left, new Env(), right, new Env());
  } catch (_) {
    return false;
  }
}

function soloTokenQuoteSignature(text) {
  const signature = [];
  let quote = null;
  const source = presentationText(text);
  for (let index = 0; index < source.length; index++) {
    const ch = source[index];
    if (quote != null) {
      if (ch === '\\') {
        index++;
        continue;
      }
      if (ch === quote) {
        if (source[index + 1] === quote) {
          index++;
          continue;
        }
        quote = null;
        continue;
      }
      if (ch === '|' || ch === ';' || ch === ',') signature.push(`${ch}:quoted`);
      continue;
    }
    if (ch === "'") {
      quote = ch;
      continue;
    }
    if (ch === '|' || ch === ';' || ch === ',') signature.push(`${ch}:bare`);
  }
  return signature;
}

function preservesWriterSoloTokenSpelling(expected, actual, item) {
  // For writer conformity cases, semantic term equivalence is deliberately
  // not enough: ISO distinguishes the bare bar operator token from atom '|',
  // and semicolon is itself a valid unquoted name token. This prevents the
  // fallback parser comparison from accepting regressions such as `a'|'b` or
  // canonical `';'(a,b)` when the WG17 expected spelling is `a|b` / `;(a,b)`.
  if (!/\bwrite(?:q|_canonical|_term)?\s*\(/.test(item?.query ?? '')) return true;
  return JSON.stringify(soloTokenQuoteSignature(expected)) ===
    JSON.stringify(soloTokenQuoteSignature(actual));
}

function abbreviatedErrorMatches(expected, actual) {
  if (actual.type !== 'error') return false;
  const formal = actual.formal ?? '';
  const patterns = [
    [/p\._e\./i, 'permission_error'],
    [/d\._e\./i, 'domain_error'],
    [/ex\._e\./i, 'existence_error'],
    [/rep(?:r)?\._e\.|repr\.\s*err\./i, 'representation_error'],
  ];
  return patterns.some(([pattern, prefix]) => pattern.test(expected) && formal.startsWith(prefix));
}

function isWriterCase(item) {
  return /\bwrite(?:q|_canonical|_term)?\s*\(/.test(item?.query ?? '');
}

function textExpectationMatches(expectedText, actual, item, example = false) {
  const candidates = observableCandidates(actual);
  if (candidates.length === 0) return false;
  let expected = presentationText(expectedText);
  if (example) expected = expected.replace(/^e\.g\.\s*/i, '');

  // A concrete WG17 writer expectation describes output syntax, not merely
  // the term denoted by that output. Layout, quoting and parentheses are
  // therefore significant. Only expectations explicitly marked `e.g.` use
  // the controlled semantic/layout fallbacks below.
  const hasBindings = actual.type === 'success' &&
    actual.stages.some(({ variables }) => bindingAnswer(variables).length > 0);
  if (!example && isWriterCase(item) && !hasBindings) {
    return candidates.some((candidate) => presentationText(candidate) === expected);
  }

  for (const candidate of candidates) {
    let left = expected;
    let right = candidate;
    if (example && /(?<![A-Za-z0-9_])_[A-Za-z0-9]+/.test(left)) {
      // ISO 7.10.5 requires the generated spelling to be an anonymous-variable
      // token. Normalise only the choice of suffix/name, not the leading `_`.
      if (!/(?<![A-Za-z0-9_])_[A-Za-z0-9]+/.test(right)) continue;
      left = normalizeExampleVariables(left);
      right = normalizeExampleVariables(right);
    }
    // Some Codex expectations intentionally carry a mandatory lexical
    // boundary, notably Cor.3 prefix-operator cases such as `- (1^2)`. Do not
    // erase that boundary before the semantic/layout-tolerant fallbacks below.
    if (!preservesLeadingOperatorParenLayout(left, right)) continue;
    if (!preservesWriterSoloTokenSpelling(left, right, item)) continue;
    if (stripLayoutOutsideQuotes(left) === stripLayoutOutsideQuotes(right)) return true;
    if (termEquivalent(left, right, item)) return true;
    if (example) {
      const expectedNumber = Number(left);
      const actualNumber = Number(right);
      if (Number.isFinite(expectedNumber) && Number.isFinite(actualNumber) &&
          Object.is(expectedNumber, actualNumber)) return true;
    }
  }
  return false;
}

export function matchesUpstreamExpectation(expectedText, actual, item = {}) {
  const expected = canonicalUpstreamExpected(expectedText);

  if (/^waits$/i.test(expected)) return actual.type === 'waits';
  if (/^succeeds(?:\b|$)/i.test(expected)) return actual.type === 'success';
  if (/^fails(?:\b|$)/i.test(expected)) return actual.type === 'failure';
  if (/^syntax\s*err\.?$/i.test(expected)) {
    return actual.type === 'error' && /^syntax_error\(/.test(actual.formal ?? '');
  }
  if (/^repr\.\s*err\.?$/i.test(expected)) {
    return actual.type === 'error' && /^representation_error\(/.test(actual.formal ?? '');
  }
  if (/^syntax\/repr\.\s*err\.?$/i.test(expected)) {
    return actual.type === 'error' && /^(?:syntax_error|representation_error)\(/.test(actual.formal ?? '');
  }
  if (/^syntax\s*err\.\/waits$/i.test(expected)) {
    return actual.type === 'waits' ||
      (actual.type === 'error' && /^syntax_error\(/.test(actual.formal ?? ''));
  }
  if (abbreviatedErrorMatches(expected, actual)) return true;

  if (/\s+or\s+/i.test(expected)) {
    return expected.split(/\s+or\s+/i)
      .some((alternative) => matchesUpstreamExpectation(alternative, actual, item));
  }
  if (/^e\.g\.\s*/i.test(expected)) return textExpectationMatches(expected, actual, item, true);
  return textExpectationMatches(expected, actual, item, false);
}

function usesWaitMatcher(expectedText) {
  return /^waits$/i.test(canonicalUpstreamExpected(expectedText));
}

function compactTestText(value, maximum) {
  const text = String(value ?? '')
    .replace(/\r/g, '\\r')
    .replace(/\n/g, '\\n')
    .replace(/\t/g, '\\t')
    .replace(/[ ]+/g, ' ')
    .trim();
  if (text.length <= maximum) return text;
  return `${text.slice(0, maximum - 1)}…`;
}

export function wg17TestDescription(item) {
  const query = compactTestText(item.query ?? item.input, 56);
  const expected = compactTestText(item.expected, 28);
  return `#${item.id} ${query} -> ${expected}`;
}

export function executeWg17Item(item, options = {}) {
  const isoStrict = options.isoStrict ?? true;
  return usesWaitMatcher(item.expected) || item.outcome?.type === 'waits'
    ? executeWait(item, isoStrict)
    : executeFinite(item, isoStrict);
}

function assertOutcome(item) {
  const actual = executeWg17Item(item);

  if (!matchesUpstreamExpectation(item.expected, actual, item)) {
    throw new Error(
      `WG17 #${item.id} (${item.expected})\n` +
      `upstream Codex expectation did not match\n` +
      `actual ${JSON.stringify(actual)}`,
    );
  }

  if (item.outcome != null && JSON.stringify(actual) !== JSON.stringify(item.outcome)) {
    throw new Error(
      `WG17 #${item.id} (${item.expected})\n` +
      `reviewed regression outcome changed\n` +
      `expected ${JSON.stringify(item.outcome)}\n` +
      `actual   ${JSON.stringify(actual)}`,
    );
  }
}

export function readWg17SyntaxFixture() {
  const fixture = JSON.parse(fs.readFileSync(fixturePath, 'utf8'));
  if (!Array.isArray(fixture.cases) || fixture.cases.length === 0) {
    throw new Error('WG17 syntax fixture has no cases');
  }
  const ids = new Set();
  for (const item of fixture.cases) {
    if (!Number.isInteger(item.id) || ids.has(item.id)) {
      throw new Error(`invalid or duplicate WG17 syntax id #${item.id}`);
    }
    if (typeof item.query !== 'string' || typeof item.input !== 'string' || typeof item.expected !== 'string') {
      throw new Error(`incomplete WG17 syntax fixture row #${item.id}`);
    }
    if (item.outcome != null && !matchesUpstreamExpectation(item.expected, item.outcome, item)) {
      throw new Error(
        `WG17 #${item.id} reviewed outcome contradicts upstream Codex expectation\n` +
        `upstream ${JSON.stringify(item.expected)}\n` +
        `outcome  ${JSON.stringify(item.outcome)}`,
      );
    }
    ids.add(item.id);
  }
  return fixture;
}

function runWg17Syntax(reporter = new TestReporter()) {
  const fixture = readWg17SyntaxFixture();

  reporter.section('WG17 syntax');
  for (const item of fixture.cases) {
    reporter.test(wg17TestDescription(item), () => assertOutcome(item));
  }
  reporter.sectionTotal('WG17 syntax');
}

export function runWg17(reporter = new TestReporter()) {
  runWg17Syntax(reporter);
}

if (isMainModule(import.meta.url)) {
  await runStandalone(runWg17);
}
