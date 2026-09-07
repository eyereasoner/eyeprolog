// Tokenizer and recursive-descent parser for the EyeProlog source language.
// It preserves the compact Prolog-like syntax while producing Term objects for the solver.
import {
  ATOM, COMPOUND, atom, compound, cons, emptyList, numberTerm, numberTextFromDouble, variable,
} from './term.js';
import { continuesGraphicToken, isTerminatingFullStop } from './syntax-scan.js';
import { CharacterRepresentationError, isStrictIsoPcsCodePoint } from './iso-character.js';
import { ISO_MAX_ARITY } from './iso-limits.js';


export class NumberRepresentationError extends Error {
  constructor(formal) {
    super(`error(${formal})`);
    this.name = 'NumberRepresentationError';
    this.formal = formal;
  }
}

export function floatRepresentationErrorFormal(text) {
  return String(text ?? '').startsWith('-')
    ? 'representation_error(min_float)'
    : 'representation_error(max_float)';
}

function finiteFloatTokenText(text) {
  const value = Number(text);
  if (!Number.isFinite(value)) {
    throw new NumberRepresentationError(floatRepresentationErrorFormal(text));
  }
  return numberTextFromDouble(value);
}

const TOK = {
  EOF: 'eof', ATOM: 'atom', VAR: 'var', STRING: 'string', NUMBER: 'number',
  LPAREN: '(', RPAREN: ')', LBRACKET: '[', RBRACKET: ']', LBRACE: '{', RBRACE: '}',
  COMMA: ',', BAR: '|', DOT: '.', IF: ':-'
};

function isWhitespaceCode(code) {
  return (code >= 0 && code <= 32) || code === 127;
}

function isWhitespaceCharacter(character) {
  if (!character) return false;
  const code = character.charCodeAt(0);
  return isWhitespaceCode(code) || /\p{White_Space}/u.test(character);
}

function isUnicodeUpperCharacter(character) {
  return Boolean(character) && /[\p{Lu}\p{Lt}]/u.test(character);
}

function isUnicodeLetterCharacter(character) {
  return Boolean(character) && /\p{L}/u.test(character);
}

function isUnicodeNameContinueCharacter(character) {
  return Boolean(character) && /[\p{L}\p{M}\p{Nd}]/u.test(character);
}

function isDigitCode(code) {
  return code >= 48 && code <= 57;
}

function isAsciiLetterCode(code) {
  return (code >= 65 && code <= 90) || (code >= 97 && code <= 122);
}

function isNameContinueCode(code) {
  return code === 95 || isAsciiLetterCode(code) || isDigitCode(code);
}

function isNameContinueCharacter(character) {
  return Boolean(character) && (isNameContinueCode(character.charCodeAt(0)) ||
    isUnicodeNameContinueCharacter(character));
}

function isVariableStartCharacter(character) {
  if (!character) return false;
  const code = character.charCodeAt(0);
  return code === 95 || (code >= 65 && code <= 90) || isUnicodeUpperCharacter(character);
}

function isPlainAtomStartCharacter(character) {
  if (!character) return false;
  const code = character.charCodeAt(0);
  return (code >= 97 && code <= 122) ||
    (isUnicodeLetterCharacter(character) && !isUnicodeUpperCharacter(character));
}

const graphicAtomChars = '#$&*+-./<=>?@^~\\:';

// ISO operator syntax is lowered to the same ordinary compound terms used by
// canonical notation. Commas remain separators except inside parentheses.
const INFIX_OPERATORS = new Map([
  [':-', { precedence: 1, associativity: 'none' }],
  ['-->', { precedence: 1, associativity: 'none' }],
  [';', { precedence: 101, associativity: 'right' }],
  ['->', { precedence: 151, associativity: 'right' }],
  [',', { precedence: 201, associativity: 'right' }],
  ['=', { precedence: 501, associativity: 'none' }],
  ['=..', { precedence: 501, associativity: 'none' }],
  ['\\=', { precedence: 501, associativity: 'none' }],
  ['==', { precedence: 501, associativity: 'none' }],
  ['\\==', { precedence: 501, associativity: 'none' }],
  ['@<', { precedence: 501, associativity: 'none' }],
  ['@=<', { precedence: 501, associativity: 'none' }],
  ['@>', { precedence: 501, associativity: 'none' }],
  ['@>=', { precedence: 501, associativity: 'none' }],
  ['is', { precedence: 501, associativity: 'none' }],
  ['=:=', { precedence: 501, associativity: 'none' }],
  ['=\\=', { precedence: 501, associativity: 'none' }],
  ['<', { precedence: 501, associativity: 'none' }],
  ['=<', { precedence: 501, associativity: 'none' }],
  ['>', { precedence: 501, associativity: 'none' }],
  ['>=', { precedence: 501, associativity: 'none' }],
  ['+', { precedence: 701, associativity: 'left' }],
  ['-', { precedence: 701, associativity: 'left' }],
  ['/\\', { precedence: 701, associativity: 'left' }],
  ['\\/', { precedence: 701, associativity: 'left' }],
  ['*', { precedence: 801, associativity: 'left' }],
  ['/', { precedence: 801, associativity: 'left' }],
  ['//', { precedence: 801, associativity: 'left' }],
  ['div', { precedence: 801, associativity: 'left' }],
  ['mod', { precedence: 801, associativity: 'left' }],
  ['rem', { precedence: 801, associativity: 'left' }],
  ['<<', { precedence: 801, associativity: 'left' }],
  ['>>', { precedence: 801, associativity: 'left' }],
  ['**', { precedence: 1001, associativity: 'none' }],
  ['^', { precedence: 1001, associativity: 'right' }],
]);
const PREFIX_OPERATORS = new Map([
  ['?-', { precedence: 1, strict: true }],
  ['\\+', { precedence: 301, strict: false }],
  ['+', { precedence: 1001, strict: false }],
  ['-', { precedence: 1001, strict: false }],
  ['\\', { precedence: 1001, strict: false }],
]);

export const ISO_OPERATOR_DEFINITIONS = [
  [1200, 'xfx', ':-'], [1200, 'fx', ':-'], [1200, 'fx', '?-'], [1200, 'xfx', '-->'],
  [1100, 'xfy', ';'], [1050, 'xfy', '->'], [1000, 'xfy', ','],
  [900, 'fy', '\\+'],
  ...['=', '=..', '\\=', '==', '\\==', '@<', '@=<', '@>', '@>=', 'is',
    '=:=', '=\\=', '<', '=<', '>', '>='].map((name) => [700, 'xfx', name]),
  ...['+', '-', '/\\', '\\/'].map((name) => [500, 'yfx', name]),
  ...['*', '/', '//', 'div', 'mod', 'rem', '<<', '>>'].map((name) => [400, 'yfx', name]),
  [200, 'xfx', '**'], [200, 'xfy', '^'],
  [200, 'fy', '+'], [200, 'fy', '-'], [200, 'fy', '\\'],
];

// ISO/IEC 13211-2 adds module qualification to the Part 1 operator table.
// The 2013 amendment also writes meta_predicate/1 in directive operator form,
// so normal module mode accepts that standard spelling while strict Part 1
// keeps both additions out of its initial operator table.
export const PART2_OPERATOR_DEFINITIONS = [
  [600, 'xfy', ':'],
  [1150, 'fx', 'meta_predicate'],
];

// The alternative operator belongs to the Part 3 grammar-rule profile. Part 1
// reserves `|` as list punctuation but permits a program to declare it as an
// infix operator at priority 1001 or greater (Corrigendum 2).
export const PART3_OPERATOR_DEFINITIONS = [
  [1105, 'xfy', '|'],
  // EyeProlog forward-rule extension.  A top-level Conclusion :+ Premise is
  // executed by library(eyelet)'s Prolog closure driver when no explicit CLI goal is given.
  [1200, 'xfx', ':+'],
  // Tabling is explicit in the normal EyeProlog profile. Make the common
  // `:- table p/n.` declaration available without requiring a library import.
  [1150, 'fx', 'table'],
];

// EyeProlog's embedded quad syntax permits an optional label before `?-`.
// That makes `?-` an implementation-specific xfx operator in addition to its
// ISO 1200 fx definition.
export const QUAD_OPERATOR_DEFINITIONS = [
  [1200, 'xfx', '?-'],
  // Quad approximate-answer notation. Keep this visible through current_op/3
  // at the same priority/specifier as the ISO comparison operators. There is
  // deliberately no built-in predicate behind it: ordinary source may define
  // or call ~~ / 2 in the usual way, while quads interpret it specially only
  // inside answer descriptions.
  [700, 'xfx', '~~'],
];

const CLPZ_OPERATOR_DEFINITIONS = [
  [760, 'yfx', '#<==>'], [750, 'xfy', '#==>'], [750, 'yfx', '#<=='],
  [740, 'yfx', '#\\/'], [730, 'yfx', '#\\'], [720, 'yfx', '#/\\'],
  [710, 'fy', '#\\'],
  ...['#>', '#<', '#>=', '#=<', '#=', '#\\=', 'in', 'ins'].map((name) => [700, 'xfx', name]),
  [450, 'xfx', '..'],
];

function operatorStrength(priority) {
  return 1201 - priority;
}

// ISO 6.3.3 arguments have maximum priority 999. Parenthesized terms and
// curly-bracket contents may contain a full priority-1200 term instead.
const ARG_MIN_PRECEDENCE = operatorStrength(999);

function isGraphicAtomCode(code) {
  return graphicAtomChars.includes(String.fromCharCode(code));
}

function isGraphicAtomCharacter(character) {
  if (!character) return false;
  const code = character.charCodeAt(0);
  if (isGraphicAtomCode(code)) return true;
  if (code <= 0x7f || isWhitespaceCharacter(character) ||
      isUnicodeNameContinueCharacter(character)) return false;
  // Non-ASCII symbols/punctuation are EyeProlog extended graphic characters.
  // Surrogate code units are kept together by the maximal-token scan, so a
  // supplementary scalar remains one atom spelling even though source offsets
  // are UTF-16 based.
  return true;
}

function defineParserOperator(state, priority, specifier, name) {
  const strength = operatorStrength(priority);
  if (['xfx', 'xfy', 'yfx'].includes(specifier)) {
    if (priority === 0) state.infixOperators.delete(name);
    else state.infixOperators.set(name, {
      precedence: strength,
      associativity: specifier === 'xfy' ? 'right' : specifier === 'yfx' ? 'left' : 'none',
    });
  } else if (specifier === 'fx' || specifier === 'fy') {
    if (priority === 0) state.prefixOperators.delete(name);
    else state.prefixOperators.set(name, { precedence: strength, strict: specifier === 'fx' });
  } else if (specifier === 'xf' || specifier === 'yf') {
    if (priority === 0) state.postfixOperators.delete(name);
    else state.postfixOperators.set(name, { precedence: strength, strict: specifier === 'xf' });
  }
}

export function createParserOperatorState(definitions = [], includeDefaults = true, options = {}) {
  const state = {
    infixOperators: includeDefaults ? new Map(INFIX_OPERATORS) : new Map(),
    prefixOperators: includeDefaults ? new Map(PREFIX_OPERATORS) : new Map(),
    postfixOperators: new Map(),
  };
  if (includeDefaults && options.isoStrict !== true) {
    for (const [priority, specifier, name] of [...PART2_OPERATOR_DEFINITIONS, ...PART3_OPERATOR_DEFINITIONS, ...QUAD_OPERATOR_DEFINITIONS]) {
      defineParserOperator(state, priority, specifier, name);
    }
  }
  for (const definition of definitions) {
    const [priority, specifier, name] = Array.isArray(definition)
      ? definition
      : [definition.priority, definition.specifier, definition.name];
    defineParserOperator(state, Number(priority), specifier, name);
  }
  return state;
}
// Pre-compiled character-class regexes used in the lexer hot path.
const RE_OCTAL_DIGIT = /^[0-7]$/;
const RE_HEX_DIGIT = /^[0-9A-Fa-f]$/;
const RE_DECIMAL_DIGIT = /^[0-9]$/;
const RE_BINARY_DIGIT = /^[01]$/;


class Parser {
  constructor(source, options = {}) {
    this.source = String(source ?? '');
    this.filename = options.filename ?? '<input>';
    this.pos = 0;
    this.line = 1;
    this.anonymous = 0;
    this.variables = new Map();
    this.sourceMetadata = options.sourceMetadata !== false;
    this.onWarning = typeof options.onWarning === 'function' ? options.onWarning : null;
    this.currentSourceTermLine = 1;
    this.strictIso = options.isoStrict === true;
    this.parserFlagState = options.parserFlagState ?? {
      doubleQuotes: options.doubleQuotes ?? 'chars',
      charConversion: 'on',
      charConversions: new Map(),
    };
    this.parserFlagState.charConversion ??= 'on';
    this.parserFlagState.charConversions ??= new Map();
    if (!['chars', 'codes', 'atom'].includes(this.parserFlagState.doubleQuotes)) {
      throw new Error(`invalid double_quotes parser flag: ${this.parserFlagState.doubleQuotes}`);
    }
    const operatorState = options.operatorState ?? createParserOperatorState(
      options.operatorDefinitions ?? [],
      options.includeDefaultOperators !== false,
      { isoStrict: this.strictIso },
    );
    this.infixOperators = operatorState.infixOperators;
    this.prefixOperators = operatorState.prefixOperators;
    this.postfixOperators = operatorState.postfixOperators;
    this.readTermEnd = Number.isInteger(options.readTermEnd) ? options.readTermEnd : null;
    this.previousToken = null;
    this.token = this.nextToken();
  }
  convertCharacter(character) {
    if (this.parserFlagState.charConversion !== 'on' || !character) return character;
    return this.parserFlagState.charConversions.get(character) ?? character;
  }
  rawPeek(offset = 0) {
    // The processor character set is an implementation-defined processor
    // choice, shared by normal and strict profiles. Do not narrow it merely
    // because ISO conformance checking is enabled (issue #67).
    return this.source[this.pos + offset] ?? '';
  }
  rawTake() {
    const ch = this.rawPeek();
    if (ch) {
      this.pos++;
      if (ch === '\n') this.line++;
    }
    return ch;
  }
  convertedSlice(start, end) {
    let out = '';
    for (const ch of this.source.slice(start, end)) out += this.convertCharacter(ch);
    return out;
  }
  terminatingFullStop(index = this.pos) {
    // read/1 tries each possible full stop in turn.  While parsing a later
    // candidate, a preceding dot after a graphic character belongs to that
    // maximal graphic token; the candidate's final dot is the end char.  Keep
    // ordinary program parsing context-free by enabling this only for a
    // designated read-term candidate.
    if (this.readTermEnd != null) {
      if (index === this.readTermEnd) return true;
      if (index < this.readTermEnd && continuesGraphicToken(this.source, index, (ch) => this.convertCharacter(ch))) {
        const next = this.convertCharacter(this.source[index + 1] ?? '');
        if (next === '%' || /^[\u0009-\u000d\u0020]$/.test(next)) return false;
      }
    }
    return isTerminatingFullStop(this.source, index, (ch) => this.convertCharacter(ch));
  }
  defineOperator(priority, specifier, name) {
    defineParserOperator(this, priority, specifier, name);
  }
  applyOperatorDirective(directive, line) {
    if (directive.type !== 'compound' || directive.name !== 'op' || directive.arity !== 3) return false;
    const [priorityTerm, specifierTerm, nameTerm] = directive.args;
    if (priorityTerm.type !== 'number' || !/^\d+$/.test(priorityTerm.name)) {
      throw new Error(`parse line ${line}: op priority must be an integer`);
    }
    const priority = Number(priorityTerm.name);
    if (priority < 0 || priority > 1200) throw new Error(`parse line ${line}: op priority out of range`);
    if (specifierTerm.type !== 'atom' || !['fx', 'fy', 'xf', 'yf', 'xfx', 'xfy', 'yfx'].includes(specifierTerm.name)) {
      throw new Error(`parse line ${line}: invalid operator specifier`);
    }
    const names = nameTerm.type === 'atom'
      ? [nameTerm.name]
      : listAtomNames(nameTerm);
    if (names == null) throw new Error(`parse line ${line}: operator name must be an atom or list of atoms`);
    for (const name of names) {
      if (name === ',' || name === '[]' || name === '{}') {
        throw new Error(`parse line ${line}: operator ${name} cannot be modified`);
      }
      if (name === '|' && priority !== 0 &&
          (!(specifierTerm.name === 'xfx' || specifierTerm.name === 'xfy' || specifierTerm.name === 'yfx') || priority < 1001)) {
        throw new Error(`parse line ${line}: invalid bar operator`);
      }
      const infix = ['xfx', 'xfy', 'yfx'].includes(specifierTerm.name);
      const postfix = ['xf', 'yf'].includes(specifierTerm.name);
      if (priority !== 0 && ((infix && this.postfixOperators.has(name)) || (postfix && this.infixOperators.has(name)))) {
        throw new Error(`parse line ${line}: invalid operator class combination for ${name}`);
      }
    }
    for (const name of names) this.defineOperator(priority, specifierTerm.name, name);
    return true;
  }
  applyParserFlagDirective(directive, line = this.line) {
    if (directive.type !== 'compound' || directive.arity !== 2) return;
    if (directive.name === 'set_prolog_flag') {
      const [flag, value] = directive.args;
      if (flag.type === 'atom' && flag.name === 'double_quotes' &&
          value.type === 'atom' && ['chars', 'codes', 'atom'].includes(value.name)) {
        this.parserFlagState.doubleQuotes = value.name;
      } else if (flag.type === 'atom' && flag.name === 'char_conversion' &&
                 value.type === 'atom' && ['on', 'off'].includes(value.name)) {
        this.parserFlagState.charConversion = value.name;
      }
      return;
    }
    if (directive.name === 'char_conversion') {
      const [input, output] = directive.args;
      const validCharacter = (term) => term.type === 'atom' && Array.from(term.name).length === 1;
      if (input.type === 'var' || output.type === 'var') {
        throw new Error(`parse line ${line}: char_conversion/2 arguments must be instantiated characters`);
      }
      if (!validCharacter(input) || !validCharacter(output)) {
        throw new Error(`parse line ${line}: char_conversion/2 requires one-character atoms`);
      }
      if (input.name === output.name) this.parserFlagState.charConversions.delete(input.name);
      else this.parserFlagState.charConversions.set(input.name, output.name);
    }
  }
  applyImportedLibraryOperators(directive) {
    if (directive.type !== COMPOUND || directive.name !== 'use_module' || ![1, 2].includes(directive.arity)) return;
    const designation = directive.args[0];
    if (designation?.type !== COMPOUND || designation.name !== 'library' || designation.arity !== 1 ||
        designation.args[0]?.type !== ATOM) return;
    if (designation.args[0].name === 'clpz') {
      for (const [priority, specifier, name] of CLPZ_OPERATOR_DEFINITIONS) {
        this.defineOperator(priority, specifier, name);
      }
    } else if (designation.args[0].name === 'atts') {
      // Scryer library(atts) exports this declaration operator. EyeProlog
      // handles the directive directly instead of relying on term expansion.
      this.defineOperator(1199, 'fx', 'attribute');
    } else if (designation.args[0].name === 'tabling') {
      this.defineOperator(1150, 'fx', 'table');
    } else if (designation.args[0].name === 'debug') {
      this.defineOperator(900, 'fx', '$');
      this.defineOperator(900, 'fx', '$-');
      this.defineOperator(950, 'fy', '*');
    }
  }
  operatorTokenName(token = this.token) {
    if (token.type === TOK.ATOM) return token.text;
    // `:-` has its own token because it also introduces clauses/directives,
    // but ISO 6.3.3.1 still permits an operator atom as an argument. Treat the
    // token as the ordinary operator name while parsing terms; the surrounding
    // grammar decides whether it is operator notation or atom data.
    if (token.type === TOK.IF) return ':-';
    if (token.type === TOK.STRING && this.parserFlagState.doubleQuotes === 'atom') return token.text;
    return null;
  }
  peek(offset = 0) {
    return this.convertCharacter(this.rawPeek(offset));
  }
  take() {
    const raw = this.rawPeek();
    const ch = this.convertCharacter(raw);
    if (raw) {
      this.pos++;
      if (raw === '\n') this.line++;
    }
    return ch;
  }
  skipWhitespaceAndComments() {
    while (true) {
      while (this.rawPeek()) {
        const ch = this.peek();
        if (!isWhitespaceCharacter(ch)) break;
        this.take();
      }
      if (this.peek() === '%') {
        while (this.rawPeek() && this.peek() !== '\n') this.take();
        continue;
      }
      if (this.peek() === '/' && this.peek(1) === '*') {
        const line = this.line;
        this.take();
        this.take();
        while (this.rawPeek() && !(this.peek() === '*' && this.peek(1) === '/')) this.take();
        if (!this.rawPeek()) throw new Error(`parse line ${line}: unterminated block comment`);
        this.take();
        this.take();
        continue;
      }
      break;
    }
  }
  integerDigits(digitPattern, line) {
    let digits = '';
    let separated = false;
    while (digitPattern.test(this.peek())) {
      digits += this.take();
      if (this.strictIso || this.peek() !== '_') continue;
      separated = true;
      this.take();
      this.skipWhitespaceAndComments();
      if (!digitPattern.test(this.peek())) {
        throw new Error(`parse line ${line}: bad digit separator`);
      }
    }
    return { digits, separated };
  }
  readEscape(line, options = {}) {
    const takeChar = () => options.raw ? this.rawTake() : this.take();
    const peekChar = () => options.raw ? this.rawPeek() : this.peek();
    const escaped = takeChar();
    if (!escaped) throw new Error(`parse line ${line}: unterminated escape sequence`);

    // ISO 6.4.2 permits a continuation escape only inside quoted tokens: a
    // backslash immediately followed by a newline. Character-code constants
    // use a single quoted character and therefore cannot use continuation.
    if (escaped === '\n') {
      if (options.allowContinuation !== false) return '';
      throw new Error(`parse line ${line}: bad escape sequence`);
    }
    if (escaped === '\r' && peekChar() === '\n') {
      if (options.allowContinuation !== false) {
        takeChar();
        return '';
      }
      throw new Error(`parse line ${line}: bad escape sequence`);
    }

    const controls = { a: '\x07', b: '\b', r: '\r', f: '\f', t: '\t', n: '\n', v: '\v' };
    if (controls[escaped] != null) return controls[escaped];

    if (escaped === 'x') {
      let digits = '';
      while (RE_HEX_DIGIT.test(peekChar())) digits += takeChar();
      if (!digits || takeChar() !== '\\') throw new Error(`parse line ${line}: bad hexadecimal escape`);
      const code = Number.parseInt(digits, 16);
      if (code > 0x10ffff || (code >= 0xd800 && code <= 0xdfff)) {
        throw new Error(`parse line ${line}: character escape out of range`);
      }
      if (this.strictIso && !isStrictIsoPcsCodePoint(code)) throw new CharacterRepresentationError();
      return String.fromCodePoint(code);
    }
    if (RE_OCTAL_DIGIT.test(escaped)) {
      let digits = escaped;
      while (RE_OCTAL_DIGIT.test(peekChar())) digits += takeChar();
      if (takeChar() !== '\\') throw new Error(`parse line ${line}: bad octal escape`);
      const code = Number.parseInt(digits, 8);
      if (code > 0x10ffff || (code >= 0xd800 && code <= 0xdfff)) {
        throw new Error(`parse line ${line}: character escape out of range`);
      }
      if (this.strictIso && !isStrictIsoPcsCodePoint(code)) throw new CharacterRepresentationError();
      return String.fromCodePoint(code);
    }
    // A backslash followed by a decimal digit is numeric-escape syntax, but
    // ISO octal digits are limited to 0..7.  Do not reinterpret \8 or \9 as
    // implementation-specific one-character escapes.
    if (RE_DECIMAL_DIGIT.test(escaped)) throw new Error(`parse line ${line}: bad octal escape`);

    // The only remaining ISO meta escapes are the four meta characters from
    // 6.5.5.  Forms such as \c, \d, \e, \u or \. are not quoted
    // characters in ISO syntax and must not be silently accepted.
    if (escaped === '\\' || escaped === "'" || escaped === '"' || escaped === '`') return escaped;
    throw new Error(`parse line ${line}: bad escape sequence`);
  }
  nextToken() {
    // The tokenizer keeps just enough state for useful parse-line errors and
    // treats quoted atoms and quoted strings differently, as Prolog syntax does.
    const beforeLayout = this.pos;
    this.skipWhitespaceAndComments();
    const precededByLayout = this.pos !== beforeLayout;
    const line = this.line;
    const ch = this.peek();
    if (!ch) return { type: TOK.EOF, text: '', line };
    if (ch === '?' && this.peek(1) === '-' &&
        !(isGraphicAtomCode(this.peek(2).charCodeAt(0)) && !this.terminatingFullStop(this.pos + 2))) {
      this.pos += 2;
      return { type: TOK.ATOM, text: '?-', line };
    }
    if (ch === '.' && !this.terminatingFullStop()) {
      const start = this.pos;
      this.take();
      while (isGraphicAtomCharacter(this.peek()) &&
             !this.terminatingFullStop()) this.take();
      return { type: TOK.ATOM, text: this.convertedSlice(start, this.pos), line };
    }
    if (ch === '!') {
      this.take();
      return { type: TOK.ATOM, text: '!', line };
    }
    if (ch === ';') {
      this.take();
      return { type: TOK.ATOM, text: ';', line };
    }

    const punct = {
      '(': TOK.LPAREN, ')': TOK.RPAREN, '[': TOK.LBRACKET, ']': TOK.RBRACKET,
      '{': TOK.LBRACE, '}': TOK.RBRACE, ',': TOK.COMMA, '|': TOK.BAR, '.': TOK.DOT,
    };
    if (punct[ch]) {
      this.take();
      return { type: punct[ch], text: ch, line, precededByLayout };
    }
    if (ch === ':' && this.peek(1) === '-' &&
        !(isGraphicAtomCode(this.peek(2).charCodeAt(0)) && !this.terminatingFullStop(this.pos + 2))) {
      this.pos += 2;
      return { type: TOK.IF, text: ':-', line };
    }
    if (ch === ':' &&
        !(isGraphicAtomCode(this.peek(1).charCodeAt(0)) && !this.terminatingFullStop(this.pos + 1))) {
      this.take();
      return { type: TOK.ATOM, text: ':', line };
    }

    if (ch === '"' || ch === "'") {
      // Whether an input character is quoted is determined from the target
      // source before character conversion (ISO 8.14.1 note 1). A literal
      // quote therefore protects its contents from Convc; if a conversion
      // itself produces a quote token, the following raw characters remain
      // subject to conversion while that resulting token is parsed.
      const rawOpening = this.rawPeek();
      const quote = this.take();
      const literalQuote = rawOpening === quote;
      const peekQuoted = () => literalQuote ? this.rawPeek() : this.peek();
      const takeQuoted = () => literalQuote ? this.rawTake() : this.take();
      let text = '';
      while (true) {
        if (!peekQuoted()) throw new Error(`parse line ${line}: unterminated quoted term`);
        let value = takeQuoted();
        if (value === quote) {
          if (peekQuoted() === quote) {
            takeQuoted();
            value = quote;
          } else {
            break;
          }
        } else if (value === '\\' && peekQuoted()) {
          value = this.readEscape(line, { raw: literalQuote });
        } else if (value !== ' ' && isWhitespaceCode(value.charCodeAt(0))) {
          // ISO 6.4.2.1 allows an ordinary space in a quoted character, but
          // not literal layout characters such as tab or newline. Newlines
          // are permitted only through the continuation escape handled above.
          throw new Error(`parse line ${line}: layout character in quoted term`);
        }
        text += value;
      }
      return { type: quote === '"' ? TOK.STRING : TOK.ATOM, text, line, quoted: true };
    }

    // A signed numeric literal is only recognized where a term may start.
    // Otherwise the minus is the standard infix operator, so compact ISO
    // syntax such as `X-1` must not be read as `X` followed by `-1`.
    const previousEndsTerm = this.previousToken && (
      [TOK.VAR, TOK.NUMBER, TOK.STRING, TOK.RPAREN, TOK.RBRACKET, TOK.RBRACE].includes(this.previousToken.type) ||
      (this.previousToken.type === TOK.ATOM &&
       (this.postfixOperators.has(this.previousToken.text) ||
        (!this.infixOperators.has(this.previousToken.text) &&
         !this.prefixOperators.has(this.previousToken.text))))
    );
    if (isDigitCode(ch.charCodeAt(0)) ||
        (ch === '-' && isDigitCode(this.peek(1).charCodeAt(0)) && !previousEndsTerm)) {
      const start = this.pos;
      const negative = this.peek() === '-';
      if (negative) this.take();
      const startsQuotedCharacter = this.peek() === '0' && this.peek(1) === "'" &&
        // `0''` is the integer 0 followed by the empty atom, whereas `0'''`
        // is the character-code constant for an apostrophe. A continuation
        // after the integer likewise belongs to the following quoted atom.
        (this.peek(2) !== "'" || this.peek(3) === "'") &&
        !(this.peek(2) === '\\' && this.peek(3) === '\n');
      if (startsQuotedCharacter) {
        const rawQuotedCharacter = this.rawPeek() === '0' && this.rawPeek(1) === "'";
        this.take();
        this.take();
        const takeCharacter = () => rawQuotedCharacter ? this.rawTake() : this.take();
        const peekCharacter = () => rawQuotedCharacter ? this.rawPeek() : this.peek();
        let value = takeCharacter();
        if (value) {
          const firstCode = value.charCodeAt(0);
          if (firstCode >= 0xd800 && firstCode <= 0xdbff) {
            const secondCode = peekCharacter().charCodeAt(0);
            if (secondCode < 0xdc00 || secondCode > 0xdfff) {
              throw new Error(`parse line ${line}: bad character code constant`);
            }
            value += takeCharacter();
          } else if (firstCode >= 0xdc00 && firstCode <= 0xdfff) {
            throw new Error(`parse line ${line}: bad character code constant`);
          }
        }
        if (!value || (value !== ' ' && isWhitespaceCode(value.charCodeAt(0)))) {
          throw new Error(`parse line ${line}: bad character code constant`);
        }
        if (value === "'") {
          // In the single-quoted-character notation used after 0', an
          // apostrophe is doubled just as it is inside a quoted atom. Thus
          // 0''' is one numeric token denoting character code 39, while the
          // undoubled 0'' is not a complete single quoted character.
          if (peekCharacter() !== "'") throw new Error(`parse line ${line}: bad character code constant`);
          takeCharacter();
        } else if (value === '\\') {
          value = this.readEscape(line, { allowContinuation: false, raw: rawQuotedCharacter });
        }
        const code = value.codePointAt(0);
        return { type: TOK.NUMBER, text: String(negative ? -code : code), line };
      }
      const radixKind = this.peek() === '0' ? this.peek(1) : '';
      const radixHasDigit = radixKind === 'b' ? RE_BINARY_DIGIT.test(this.peek(2))
        : radixKind === 'o' ? RE_OCTAL_DIGIT.test(this.peek(2))
        : radixKind === 'x' ? RE_HEX_DIGIT.test(this.peek(2))
        : false;
      if (radixHasDigit) {
        this.take();
        const kind = this.take();
        const radix = kind === 'b' ? 2 : kind === 'o' ? 8 : 16;
        const digitPattern = radix === 2 ? /^[01]$/ : radix === 8 ? /^[0-7]$/ : /^[0-9A-Fa-f]$/;
        const { digits } = this.integerDigits(digitPattern, line);
        if (!digits) throw new Error(`parse line ${line}: bad radix integer`);
        let integer = 0n;
        for (const digit of digits) integer = integer * BigInt(radix) + BigInt(Number.parseInt(digit, radix));
        if (negative) integer = -integer;
        return { type: TOK.NUMBER, text: integer.toString(), line };
      }
      const { digits, separated } = this.integerDigits(/^[0-9]$/, line);
      let hasFraction = false;
      if (!separated && this.peek() === '.' && isDigitCode(this.peek(1).charCodeAt(0))) {
        hasFraction = true;
        this.take();
        while (isDigitCode(this.peek().charCodeAt(0))) this.take();
      }
      // ISO floating-point syntax requires a fractional part before an
      // exponent. Thus 1.0e9 is one number token, while 1E9 is the integer 1
      // followed by the name E9 and is not a valid term without an operator.
      if (hasFraction && (this.peek() === 'e' || this.peek() === 'E')) {
        let idx = this.pos + 1;
        if (['+', '-'].includes(this.convertCharacter(this.source[idx] ?? ''))) idx++;
        if (isDigitCode(this.convertCharacter(this.source[idx] ?? '').charCodeAt(0))) {
          this.take();
          if (this.peek() === '+' || this.peek() === '-') this.take();
          while (isDigitCode(this.peek().charCodeAt(0))) this.take();
        }
      }
      let text = this.convertedSlice(start, this.pos);
      if (!hasFraction) text = BigInt(`${negative ? '-' : ''}${digits}`).toString();
      else text = finiteFloatTokenText(text);
      return { type: TOK.NUMBER, text, line };
    }

    if (isVariableStartCharacter(ch)) {
      const start = this.pos;
      this.take();
      while (isNameContinueCharacter(this.peek())) this.take();
      const text = this.convertedSlice(start, this.pos);
      return { type: TOK.VAR, text, line };
    }

    if (isPlainAtomStartCharacter(ch)) {
      const start = this.pos;
      this.take();
      while (isNameContinueCharacter(this.peek())) this.take();
      return { type: TOK.ATOM, text: this.convertedSlice(start, this.pos), line };
    }

    if (isGraphicAtomCharacter(ch)) {
      const start = this.pos;
      this.take();
      while (isGraphicAtomCharacter(this.peek()) &&
             !this.terminatingFullStop()) this.take();
      return { type: TOK.ATOM, text: this.convertedSlice(start, this.pos), line };
    }

    throw new Error(`parse line ${line}: bad character ${JSON.stringify(ch)}`);
  }
  advance() {
    this.previousToken = this.token;
    this.token = this.nextToken();
  }
  expect(type, desc = type) {
    if (this.token.type !== type) throw new Error(`parse line ${this.token.line}: expected ${desc}, got ${this.token.text}`);
  }
  parseParenthesizedTerm() {
    this.expect(TOK.LPAREN, '(');
    this.advance();
    // A current operator atom may be the complete parenthesized term, e.g.
    // (+), but it cannot silently become an operand in a larger expression.
    const term = this.parseTerm(0, true, true, true);
    this.expect(TOK.RPAREN, ')');
    this.advance();
    return term;
  }
  parseList() {
    // Lists are lowered to './2' cons cells and [] so list predicates can work
    // on a single canonical representation.
    this.expect(TOK.LBRACKET, '[');
    this.advance();
    if (this.token.type === TOK.RBRACKET) {
      this.advance();
      return emptyList();
    }
    const items = [];
    let tail = null;
    while (true) {
      items.push(this.parseTerm(ARG_MIN_PRECEDENCE, false, false, true));
      if (this.token.type === TOK.COMMA) {
        this.advance();
        continue;
      }
      if (this.token.type === TOK.BAR) {
        this.advance();
        tail = this.parseTerm(ARG_MIN_PRECEDENCE, false, false, true);
        this.expect(TOK.RBRACKET, ']');
        this.advance();
        break;
      }
      this.expect(TOK.RBRACKET, ']');
      this.advance();
      tail = emptyList();
      break;
    }
    for (let i = items.length - 1; i >= 0; i--) tail = cons(items[i], tail);
    return tail;
  }
  parseCurly() {
    this.expect(TOK.LBRACE, '{');
    this.advance();
    if (this.token.type === TOK.RBRACE) {
      this.advance();
      return atom('{}');
    }
    // As with a parenthesized term, a current operator atom may be the entire
    // curly-bracket content: `{*}` denotes {}(*), not an incomplete infix use.
    const term = this.parseTerm(0, true, true, true);
    this.expect(TOK.RBRACE, '}');
    this.advance();
    return compound('{}', [term]);
  }
  parseFunctionalNotation(name) {
    this.expect(TOK.LPAREN, '(');
    this.advance();
    const args = [];
    if (this.token.type === TOK.RPAREN) {
      throw new Error(`parse line ${this.token.line}: zero-arity compound syntax is not supported; use atom ${JSON.stringify(name)} for arity zero data`);
    }
    while (true) {
      args.push(this.parseTerm(ARG_MIN_PRECEDENCE, false, false, true));
      if (ISO_MAX_ARITY != null && args.length > ISO_MAX_ARITY) {
        throw new NumberRepresentationError('representation_error(max_arity)');
      }
      if (this.token.type !== TOK.COMMA) break;
      this.advance();
    }
    this.expect(TOK.RPAREN, ')');
    this.advance();
    return compound(name, args);
  }
  parseTerm(minPrecedence = 0, allowComma = false, allowBar = true, allowOperatorAtom = false) {
    const initialOperatorName = this.operatorTokenName();
    // An atom whose only operator declaration is postfix can still seed a
    // postfix expression: after `op(100,xf,a), op(200,xf,b)`, `a b` denotes
    // b(a).  Prefix and infix operator atoms cannot be bare operands.
    const initialWasCurrentOperator = initialOperatorName != null &&
      (this.infixOperators.has(initialOperatorName) ||
       this.prefixOperators.has(initialOperatorName));
    let left = this.parsePrefixTerm(minPrecedence, allowBar, allowOperatorAtom);
    const leftIsBareOperatorAtom = initialWasCurrentOperator &&
      left.type === ATOM && left.name === initialOperatorName;
    // Neumerkel syntax #379: the DCG rule operator `-->` is processor-defined
    // and not an ISO predicate-indicator name.  A bare `-->` (not parenthesized)
    // followed by `/` would be an invalid strict-ISO predicate indicator.
    // However, `(-->)/2` is valid: the parentheses make `-->` an ordinary atom
    // argument, and ISO 7.10.3 does not restrict which atoms may appear as the
    // name in a Name/Arity indicator — only the write-term rules govern spelling.
    // Only reject the bare-operator form so (-->)/2 succeeds per #379.
    if (this.strictIso && leftIsBareOperatorAtom && left.name === '-->' &&
        this.operatorTokenName() === '/') {
      throw new Error(`parse line ${this.token.line}: operator atom --> is not permitted in a strict ISO predicate indicator`);
    }
    let strictPostfixPrecedence = null;
    while (true) {
      const op = this.token.type === TOK.COMMA && allowComma
        ? ','
        : this.token.type === TOK.BAR && allowBar ? '|'
        : this.token.type === TOK.IF ? ':-'
        : this.operatorTokenName();
      const info = op == null ? null : this.infixOperators.get(op);
      if (!info || info.precedence < minPrecedence) {
        const postfixName = this.operatorTokenName();
        const postfix = postfixName == null ? null : this.postfixOperators.get(postfixName);
        if (!postfix || postfix.precedence < minPrecedence ||
            (strictPostfixPrecedence === postfix.precedence)) break;
        if (leftIsBareOperatorAtom) {
          throw new Error(`parse line ${this.token.line}: operator atom ${left.name} requires parentheses as an operand`);
        }
        const name = postfixName;
        this.advance();
        left = compound(name, [left]);
        strictPostfixPrecedence = postfix.strict ? postfix.precedence : null;
        continue;
      }
      if (leftIsBareOperatorAtom) {
        throw new Error(`parse line ${this.token.line}: operator atom ${left.name} requires parentheses as an operand`);
      }
      strictPostfixPrecedence = null;
      this.advance();
      const right = this.parseTerm(
        info.associativity === 'right' ? info.precedence : info.precedence + 1,
        allowComma,
        allowBar,
        false,
      );
      left = compound(op, [left, right]);
      if (info.associativity === 'none') {
        const nextOp = this.token.type === TOK.COMMA && allowComma
          ? ','
          : this.token.type === TOK.BAR && allowBar ? '|'
          : this.token.type === TOK.IF ? ':-'
          : this.operatorTokenName();
        if (this.infixOperators.get(nextOp)?.precedence === info.precedence) {
          throw new Error(`parse line ${this.token.line}: non-associative operator ${op} requires parentheses`);
        }
      }
    }
    if (leftIsBareOperatorAtom && left.type === ATOM && !allowOperatorAtom) {
      throw new Error(`parse line ${this.token.line}: operator atom ${left.name} requires parentheses as an operand`);
    }
    return left;
  }
  parsePrefixTerm(minPrecedence = 0, allowBar = true, allowOperatorAtom = false) {
    // `:-` is tokenized specially so the program grammar can recognize clause
    // and directive markers. In term argument position, however, ISO 6.3.3.1
    // permits an operator atom directly as an `arg`; a leading `:-` cannot be
    // prefix operator notation at argument priority, so it denotes the atom.
    if (this.token.type === TOK.IF) {
      if (!allowOperatorAtom) {
        throw new Error(`parse line ${this.token.line}: operator atom :- requires argument context or parentheses`);
      }
      this.advance();
      return atom(':-');
    }
    const operatorName = this.operatorTokenName();
    // A negative number consists of a minus name token followed by a numeric
    // token, with layout permitted between them. It is lexical number syntax,
    // not an application of the current prefix `-` operator, and therefore
    // remains valid even after op(0, fy, -).
    if (operatorName === '-' && this.token.type === TOK.ATOM) {
      const state = {
        pos: this.pos,
        line: this.line,
        previousToken: this.previousToken,
        token: this.token,
      };
      this.advance();
      if (this.token.type === TOK.NUMBER && !this.token.text.startsWith('-')) {
        const value = this.token.text;
        this.advance();
        return numberTerm(`-${value}`);
      }
      this.pos = state.pos;
      this.line = state.line;
      this.previousToken = state.previousToken;
      this.token = state.token;
    }
    if (operatorName != null && this.prefixOperators.get(operatorName)?.precedence >= minPrecedence) {
      const op = operatorName;
      const info = this.prefixOperators.get(op);
      this.advance();
      // Graphic operators can also be ordinary atom data in a term, as in
      // `op(+, Left, Right)`.  When the operator is immediately followed by
      // an argument delimiter there is no operand for prefix syntax, so keep
      // the operator as an atom instead of reporting a misleading bad-term
      // error.
      if ([TOK.COMMA, TOK.RPAREN, TOK.RBRACKET, TOK.RBRACE, TOK.BAR, TOK.DOT].includes(this.token.type)) {
        if (!allowOperatorAtom && this.token.type !== TOK.DOT) {
          throw new Error(`parse line ${this.token.line}: operator atom ${op} requires argument context or parentheses`);
        }
        return atom(op);
      }
      if (this.token.type === TOK.LPAREN && this.token.precededByLayout !== true) {
        return this.parseFunctionalNotation(op);
      }
      return compound(op, [this.parseTerm(info.precedence + (info.strict ? 1 : 0), false, allowBar, false)]);
    }
    if (this.token.type === TOK.LPAREN) return this.parseParenthesizedTerm();
    if (this.token.type === TOK.LBRACKET) {
      const list = this.parseList();
      if (list.type === ATOM && list.name === '[]' && this.token.type === TOK.LPAREN &&
          this.token.precededByLayout !== true) return this.parseFunctionalNotation('[]');
      return list;
    }
    if (this.token.type === TOK.LBRACE) {
      const curly = this.parseCurly();
      if (curly.type === ATOM && curly.name === '{}' && this.token.type === TOK.LPAREN &&
          this.token.precededByLayout !== true) return this.parseFunctionalNotation('{}');
      return curly;
    }
    if (this.token.type === TOK.VAR) {
      const name = this.token.text;
      this.advance();
      if (name === '_') return variable(`__anon${this.anonymous++}`);
      let term = this.variables.get(name);
      if (term == null) {
        term = variable(name);
        this.variables.set(name, term);
      }
      return term;
    }
    if (this.token.type === TOK.STRING) {
      const value = this.token.text;
      this.advance();
      if (this.parserFlagState.doubleQuotes === 'atom') {
        if (this.token.type === TOK.LPAREN && this.token.precededByLayout !== true) return this.parseFunctionalNotation(value);
        return atom(value);
      }
      const items = Array.from(value, (character) =>
        this.parserFlagState.doubleQuotes === 'chars'
          ? atom(character)
          : numberTerm(character.codePointAt(0)));
      let tail = emptyList();

      // Trealla-compatible double-bar right splice (issue #88): in normal
      // mode, a double-quoted chars/codes prefix may be followed by `||Tail`.
      // It is equivalent to the corresponding list prefix with Tail as its
      // final list tail, e.g. "ab"||T is [a,b|T] with double_quotes(chars).
      // The extension binds at priority 1 (tighter than ordinary operators)
      // and is deliberately absent from the strict ISO profile.
      if (!this.strictIso && this.token.type === TOK.BAR) {
        const state = {
          pos: this.pos,
          line: this.line,
          previousToken: this.previousToken,
          token: this.token,
        };
        this.advance();
        if (this.token.type === TOK.BAR) {
          this.advance();
          tail = this.parseTerm(operatorStrength(1), false, allowBar, false);
        } else {
          // A single bar remains ordinary bar syntax. We had to advance once
          // to distinguish it from `||`, so restore the tokenizer state.
          this.pos = state.pos;
          this.line = state.line;
          this.previousToken = state.previousToken;
          this.token = state.token;
        }
      }

      for (let i = items.length - 1; i >= 0; i--) tail = cons(items[i], tail);
      return tail;
    }
    if (this.token.type === TOK.NUMBER) {
      const value = this.token.text;
      this.advance();
      return numberTerm(value);
    }
    if (this.token.type === TOK.ATOM) {
      const name = this.token.text;
      const quoted = this.token.quoted === true;
      this.advance();
      if (this.token.type === TOK.LPAREN && this.token.precededByLayout !== true) {
        return this.parseFunctionalNotation(name);
      }
      if (!quoted && !allowOperatorAtom &&
          (this.infixOperators.has(name) || this.prefixOperators.has(name) || this.postfixOperators.has(name))) {
        throw new Error(`parse line ${this.token.line}: operator atom ${name} requires argument context or parentheses`);
      }
      return atom(name);
    }
    throw new Error(`parse line ${this.token.line}: bad term`);
  }
  parseStandaloneTerm() {
    // read/1 and read_term/* consume one ordinary Prolog term, not a program
    // clause. In particular, commas and operators such as :- and ?- belong to
    // the term itself and must not be reinterpreted by parseProgram().
    const term = this.parseTerm(0, true, true, true);
    this.expect(TOK.DOT, '.');
    this.advance();
    this.expect(TOK.EOF, 'end of input');
    return term;
  }
  sourceLineIsIndented(line) {
    let start = 0;
    for (let current = 1; current < line; current++) {
      const newline = this.source.indexOf('\n', start);
      if (newline < 0) return false;
      start = newline + 1;
    }
    return this.source[start] === ' ' || this.source[start] === '\t';
  }
  parseQuadAnswers(id, query, line, accept) {
    this.expect(TOK.DOT, '.');
    this.advance();

    const answers = [];
    while (this.token.type !== TOK.EOF && this.sourceLineIsIndented(this.token.line)) {
      answers.push(this.parseTerm(0, true));
      this.expect(TOK.DOT, '.');
      this.advance();
    }
    if (answers.length === 0) throw new Error(`parse line ${line}: quad requires an indented answer description`);

    accept({
      kind: 'quad',
      id,
      query,
      answers,
      source: { filename: this.filename, line },
    });
  }
  parseQuad(id, line, accept) {
    const query = this.parseTerm(0, true);
    this.parseQuadAnswers(id, query, line, accept);
  }
  parseQuadTerm(term, line, accept) {
    if (term.type !== COMPOUND || term.name !== '?-' || ![1, 2].includes(term.arity)) return false;
    const id = term.arity === 2 ? term.args[0] : null;
    const query = term.args[term.arity - 1];
    this.parseQuadAnswers(id, query, line, accept);
    return true;
  }
  parseProgram(emit = null) {
    const clauses = emit ? null : [];
    let clauseNumber = 0;
    const rawAccept = emit ?? ((clause) => clauses.push(clause));
    const accept = (item) => {
      reportClauseSingletonWarnings(item, this.onWarning, this.filename, this.currentSourceTermLine);
      rawAccept(item);
    };
    while (this.token.type !== TOK.EOF) {
      const line = this.token.line;
      this.currentSourceTermLine = line;
      // Prefix operator notation needs one program-level distinction so
      // a comma in `?- A, B.` remains inside the query rather than outside the
      // prefix term. Ordinary functional notation is parsed as a term and then
      // recognized structurally by parseQuadTerm; further equivalent spellings
      // are recognized after the general head parser below.
      if (this.operatorTokenName() === '?-' && !this.strictIso) {
        if (this.peek() === '(') {
          const quadTerm = this.parseTerm(0, true);
          if (!this.parseQuadTerm(quadTerm, line, accept)) {
            throw new Error(`parse line ${line}: bad quad term`);
          }
        } else {
          this.advance();
          this.parseQuad(null, line, accept);
        }
        continue;
      }
      if (this.token.type === TOK.IF) {
        this.advance();
        const attributeSequence = !this.strictIso && this.operatorTokenName() === 'attribute';
        let directive = this.parseTerm(0, attributeSequence);
        // Scryer's library(atts) convention permits declarations such as
        // `:- attribute a/1, b/0.` without parentheses. At program level the
        // comma would otherwise sit outside the prefix term; fold it back into
        // the single attribute/1 directive before directive classification.
        if (attributeSequence && directive.type === COMPOUND && directive.name === ',' && directive.arity === 2 &&
            directive.args[0].type === COMPOUND && directive.args[0].name === 'attribute' && directive.args[0].arity === 1) {
          directive = compound('attribute', [compound(',', [directive.args[0].args[0], directive.args[1]])]);
        }
        const coreDirective = directive.type === 'compound' && (
          (['dynamic', 'multifile', 'discontiguous', 'initialization', 'include', 'ensure_loaded'].includes(directive.name) && directive.arity === 1) ||
          (['char_conversion', 'set_prolog_flag'].includes(directive.name) && directive.arity === 2)
        );
        const extensionDirective = directive.type === 'compound' && (
          (['use_module', 'meta_predicate', 'attribute', 'table', 'public'].includes(directive.name) && directive.arity === 1) ||
          (['module', 'use_module'].includes(directive.name) && directive.arity === 2)
        );
        if (this.strictIso && extensionDirective) {
          throw new Error(`parse line ${line}: implementation-specific directive ${directive.name}/${directive.arity} is not available in strict ISO core mode`);
        }
        const operator = this.applyOperatorDirective(directive, line);
        if (!coreDirective && !extensionDirective && !operator) {
          throw new Error(`parse line ${line}: bad term`);
        }
        this.expect(TOK.DOT, '.');
        this.applyParserFlagDirective(directive, line);
        this.applyImportedLibraryOperators(directive);
        this.advance();
        const clause = { head: compound(':-', [directive]), body: [] };
        // Module loading declarations describe the compilation unit rather
        // than an executable source clause, so they do not shift proof clause
        // numbers in the importing file.
        if (!['module', 'use_module', 'meta_predicate', 'attribute'].includes(directive.name)) clauseNumber++;
        if (this.sourceMetadata) clause.source = { filename: this.filename, line, clause: clauseNumber };
        accept(clause);
        continue;
      }
      // Program clauses historically parse comma separately from the head, so
      // keep that grammar unchanged.  A quad id, however, is simply the first
      // argument of the ordinary ?-/2 term.  If the initial head parse stops at
      // a comma, tentatively reparse that left operand with the normal term
      // grammar (where comma is the predefined priority-1000 xfy operator).
      // Only when the resulting term is actually followed by ?- do we keep the
      // tentative parse; otherwise restore the parser and retain the existing
      // clause/DCG handling below.
      const headState = {
        pos: this.pos,
        line: this.line,
        anonymous: this.anonymous,
        variables: new Map(this.variables),
        previousToken: this.previousToken,
        token: this.token,
      };
      const restoreHeadState = () => {
        this.pos = headState.pos;
        this.line = headState.line;
        this.anonymous = headState.anonymous;
        this.variables = new Map(headState.variables);
        this.previousToken = headState.previousToken;
        this.token = headState.token;
      };

      let head = this.parseTerm(3, false, true, true);
      if (this.token.type === TOK.COMMA && !this.strictIso) {
        restoreHeadState();
        const quadId = this.parseTerm(3, true);
        if (this.operatorTokenName() === '?-') {
          this.advance();
          this.parseQuad(quadId, line, accept);
          continue;
        }
        restoreHeadState();
        head = this.parseTerm(3, false, true, true);
      }

      // Outside quad syntax, preserve the existing program-level comma rule,
      // including the TS 13211-3 semicontext boundary.  This is deliberately
      // not a grammar for quad ids.
      if (this.token.type === TOK.COMMA) {
        const items = [head];
        let extraCommaLine = null;
        while (this.token.type === TOK.COMMA) {
          if (items.length >= 2 && extraCommaLine == null) extraCommaLine = this.token.line;
          this.advance();
          items.push(this.parseTerm(3));
        }
        if (extraCommaLine != null && this.operatorTokenName() !== '?-') {
          throw new Error(`parse line ${extraCommaLine}: expected ., got ,`);
        }
        head = items.pop();
        while (items.length > 0) head = compound(',', [items.pop(), head]);
      }
      // The clause grammar keeps priority-1200 neck/DCG tokens outside the
      // initial head parse. A user-defined operator at priority 1199 or 1200,
      // however, can itself be the outermost source term. Scryer's CLP(Z) uses
      // exactly this shape for its private `++>` Duo-DCG rules. Fold such a
      // custom low-strength infix operator back into the source term while
      // leaving the processor-defined :-, -->, and ?- dispatch below intact.
      const topLevelOperator = this.operatorTokenName();
      const topLevelInfo = topLevelOperator == null ? null : this.infixOperators.get(topLevelOperator);
      if (topLevelInfo && topLevelInfo.precedence < 3 &&
          ![':-', '-->', '?-'].includes(topLevelOperator)) {
        this.advance();
        const right = this.parseTerm(
          topLevelInfo.associativity === 'right' ? topLevelInfo.precedence : topLevelInfo.precedence + 1,
          true,
          true,
          false,
        );
        head = compound(topLevelOperator, [head, right]);
        if (topLevelInfo.associativity === 'none') {
          const nextOperator = this.operatorTokenName();
          if (this.infixOperators.get(nextOperator)?.precedence === topLevelInfo.precedence) {
            throw new Error(`parse line ${this.token.line}: non-associative operator ${topLevelOperator} requires parentheses`);
          }
        }
      }

      // Parentheses and other ordinary term syntax may hide the surface ?-
      // token from the program-level dispatch above.  Once the complete head
      // term has been parsed, recognize the same ?-/1 or ?-/2 structure here.
      // Requiring the following dot prevents an ordinary rule whose head just
      // happens to be ?-/1 or ?-/2 from being consumed as a quad mid-clause.
      if (!this.strictIso && this.token.type === TOK.DOT && this.parseQuadTerm(head, line, accept)) {
        continue;
      }
      if (this.operatorTokenName() === '?-') {
        if (this.strictIso) {
          // There is no predefined infix ?-/2 in strict core mode.  If a
          // conforming source explicitly introduced one with op/3, read it as
          // an ordinary operator term rather than as a quad label.
          const info = this.infixOperators.get('?-');
          if (!info) throw new Error(`parse line ${line}: expected ., got ?-`);
          this.advance();
          const right = this.parseTerm(info.associativity === 'right' ? info.precedence : info.precedence + 1, true);
          const clause = { head: compound('?-', [head, right]), body: [] };
          this.expect(TOK.DOT, '.');
          this.advance();
          clauseNumber++;
          if (this.sourceMetadata) clause.source = { filename: this.filename, line, clause: clauseNumber };
          accept(clause);
          continue;
        }
        this.advance();
        this.parseQuad(head, line, accept);
        continue;
      }
      if (this.operatorTokenName() === '-->') {
        this.advance();
        const grammarBody = this.parseTerm(0, true);
        this.expect(TOK.DOT, '.');
        this.advance();
        const clause = { head: compound('-->', [head, grammarBody]), body: [] };
        clauseNumber++;
        if (this.sourceMetadata) clause.source = { filename: this.filename, line, clause: clauseNumber };
        accept(clause);
        continue;
      }
      const body = [];
      if (this.token.type === TOK.IF) {
        this.advance();
        while (true) {
          body.push(this.parseTerm());
          if (this.token.type === TOK.COMMA) {
            this.advance();
            continue;
          }
          break;
        }
      }
      this.expect(TOK.DOT, '.');
      this.advance();
      const clause = { head, body };
      clauseNumber++;
      if (this.sourceMetadata) clause.source = { filename: this.filename, line, clause: clauseNumber };
      accept(clause);
    }
    return clauses;
  }
}

function listAtomNames(term) {
  const names = [];
  let cursor = term;
  while (cursor.type === 'compound' && cursor.name === '.' && cursor.arity === 2) {
    if (cursor.args[0].type !== 'atom') return null;
    names.push(cursor.args[0].name);
    cursor = cursor.args[1];
  }
  return cursor.type === 'atom' && cursor.name === '[]' ? names : null;
}


function collectClauseVariableOccurrences(term, counts) {
  if (term == null) return;
  if (term.type === 'var') {
    counts.set(term.name, (counts.get(term.name) ?? 0) + 1);
    return;
  }
  if (term.type === COMPOUND) {
    for (const arg of term.args) collectClauseVariableOccurrences(arg, counts);
  }
}

function reportClauseSingletonWarnings(clause, onWarning, filename, line) {
  if (typeof onWarning !== 'function' || clause?.kind === 'quad') return;
  const counts = new Map();
  collectClauseVariableOccurrences(clause.head, counts);
  for (const goal of clause.body ?? []) collectClauseVariableOccurrences(goal, counts);
  for (const [name, count] of counts) {
    if (count !== 1 || String(name).startsWith('_')) continue;
    onWarning({ kind: 'singleton', name, filename: filename ?? '<input>', line });
  }
}


export function parseClauses(source, options = {}) {
  const ownsParserFlagState = options.parserFlagState == null;
  const initialDoubleQuotes = options.doubleQuotes ?? 'chars';
  const parserOptions = ownsParserFlagState
    ? { ...options, parserFlagState: { doubleQuotes: initialDoubleQuotes, charConversion: 'on', charConversions: new Map() } }
    : options;
  if (options.sourceMetadata === false && options.readTermEnd == null) {
    const clauses = parseClausesFastNoSource(source, null, null, parserOptions);
    if (clauses) return clauses;
    if (ownsParserFlagState) {
      parserOptions.parserFlagState.doubleQuotes = initialDoubleQuotes;
      parserOptions.parserFlagState.charConversion = 'on';
      parserOptions.parserFlagState.charConversions.clear();
    }
  }
  return new Parser(source, parserOptions).parseProgram();
}

// Streaming parser entry points used by ProgramBuilder.  The ordinary public
// parseClauses API still returns an array; these avoid a second, temporary
// clause array when a Program is being built directly from source text.
export function parseClausesInto(source, options = {}, emit) {
  new Parser(source, options).parseProgram(emit);
}

export function tryParseClausesFastInto(source, emit, emitBinary = null, options = {}) {
  return parseClausesFastNoSource(source, emit, emitBinary, options) !== null;
}

function isSimpleName(text) {
  if (!text) return false;
  const first = text.charCodeAt(0);
  if (!(first >= 97 && first <= 122)) return false;
  for (let i = 1; i < text.length; i++) {
    const code = text.charCodeAt(i);
    if (!(code === 95 || (code >= 48 && code <= 57) || (code >= 65 && code <= 90) || (code >= 97 && code <= 122))) return false;
  }
  return true;
}

const SIMPLE_NUMBER = /^-?\d+(?:\.\d+)?(?:[eE][+-]?\d+)?$/;
const FAST_BINARY_FACT = /^([a-z][A-Za-z0-9_]*)\(\s*([^,\s()[\]|"']+)\s*,\s*([^,\s()[\]|"']+)\s*\)\.$/;
const FAST_BINARY_RULE = /^([a-z][A-Za-z0-9_]*)\(\s*([^,\s()[\]|"']+)\s*,\s*([^,\s()[\]|"']+)\s*\)\s*:-\s*([a-z][A-Za-z0-9_]*)\(\s*([^,\s()[\]|"']+)\s*,\s*([^,\s()[\]|"']+)\s*\)\.$/;
const SIMPLE_VARIABLE = /^(?:_|[A-Z_][A-Za-z0-9_]*)$/;
const SIMPLE_ATOM = /^[a-z][A-Za-z0-9_]*$/;
const GRAPHIC_ATOM = /^[#$&*+\-\/<=>@^~\\]+$/;

function parseClausesFastNoSource(source, emit = null, emitBinary = null, options = {}) {
  source = String(source ?? '');
  const numberCache = new Map();
  const stringCache = new Map();
  const variableCache = new Map();
  const clauses = emit ? null : [];
  const accept = emit ?? ((clause) => clauses.push(clause));
  let anonymous = 0;
  let chunk = '';
  let chunkStartLine = 1;

  const cached = (cache, key, create) => {
    const existing = cache.get(key);
    if (existing) return existing;
    const value = create(key);
    cache.set(key, value);
    return value;
  };

  const isFastScalarToken = (text) => SIMPLE_VARIABLE.test(text) || SIMPLE_ATOM.test(text) || GRAPHIC_ATOM.test(text) || SIMPLE_NUMBER.test(text);
  const scalarOrVariableFast = (text) => {
    if (!text || !isFastScalarToken(text)) throw new Error('bad simple term');
    const first = text.charCodeAt(0);
    if (text === '_') return variable(`__anon${anonymous++}`);
    if (SIMPLE_VARIABLE.test(text)) {
      const existing = variableCache.get(text);
      if (existing) return existing;
      const value = variable(text);
      variableCache.set(text, value);
      return value;
    }
    if ((first === 45 || isDigitCode(first)) && SIMPLE_NUMBER.test(text)) return cached(numberCache, text, numberTerm);
    return atom(text);
  };

  const trimRangeStart = (text, start, end) => {
    while (start < end && isWhitespaceCode(text.charCodeAt(start))) start++;
    return start;
  };

  const trimRangeEnd = (text, start, end) => {
    while (end > start && isWhitespaceCode(text.charCodeAt(end - 1))) end--;
    return end;
  };

  const tokenKindInRange = (text, start, end) => {
    if (start >= end) return null;
    const first = text.charCodeAt(start);
    if (first === 95 || (first >= 65 && first <= 90)) {
      for (let i = start + 1; i < end; i++) if (!isNameContinueCode(text.charCodeAt(i))) return null;
      return 'var';
    }
    if (first >= 97 && first <= 122) {
      for (let i = start + 1; i < end; i++) if (!isNameContinueCode(text.charCodeAt(i))) return null;
      return 'atom';
    }
    let allGraphic = true;
    for (let i = start; i < end; i++) {
      if (!isGraphicAtomCode(text.charCodeAt(i))) { allGraphic = false; break; }
    }
    if (allGraphic) return 'atom';
    return null;
  };

  const simpleNumberInRange = (text, start, end) => {
    let i = start;
    if (text.charCodeAt(i) === 45) i++;
    if (i >= end || !isDigitCode(text.charCodeAt(i))) return false;
    while (i < end && isDigitCode(text.charCodeAt(i))) i++;
    if (i < end && text.charCodeAt(i) === 46) {
      i++;
      if (i >= end || !isDigitCode(text.charCodeAt(i))) return false;
      while (i < end && isDigitCode(text.charCodeAt(i))) i++;
    }
    if (i < end && (text.charCodeAt(i) === 101 || text.charCodeAt(i) === 69)) {
      i++;
      if (i < end && (text.charCodeAt(i) === 43 || text.charCodeAt(i) === 45)) i++;
      if (i >= end || !isDigitCode(text.charCodeAt(i))) return false;
      while (i < end && isDigitCode(text.charCodeAt(i))) i++;
    }
    return i === end;
  };

  const scalarOrVariableRange = (text, start, end) => {
    start = trimRangeStart(text, start, end);
    end = trimRangeEnd(text, start, end);
    const kind = tokenKindInRange(text, start, end);
    const value = text.slice(start, end);
    if (kind === 'var') {
      if (value === '_') return variable(`__anon${anonymous++}`);
      const existing = variableCache.get(value);
      if (existing) return existing;
      const term = variable(value);
      variableCache.set(value, term);
      return term;
    }
    if (kind === 'atom') return atom(value);
    if (simpleNumberInRange(text, start, end)) return cached(numberCache, value, numberTerm);
    return null;
  };

  const rawHead = {};
  const rawBody = {};

  const scalarTokenRange = (text, start, end, out, slot) => {
    start = trimRangeStart(text, start, end);
    end = trimRangeEnd(text, start, end);
    const kind = tokenKindInRange(text, start, end);
    let type = kind;
    if (kind == null && simpleNumberInRange(text, start, end)) type = 'number';
    if (type == null) return false;
    let name = text.slice(start, end);
    if (type === 'var' && name === '_') name = `__anon${anonymous++}`;
    if (slot === 0) {
      out.arg0Type = type;
      out.arg0Name = name;
    } else {
      out.arg1Type = type;
      out.arg1Name = name;
    }
    return true;
  };

  const parseBinaryRawRange = (text, start, end, out) => {
    start = trimRangeStart(text, start, end);
    end = trimRangeEnd(text, start, end);
    let i = start;
    const first = text.charCodeAt(i);
    if (!(first >= 97 && first <= 122)) return false;
    i++;
    while (i < end && isNameContinueCode(text.charCodeAt(i))) i++;
    const nameEnd = i;
    while (i < end && isWhitespaceCode(text.charCodeAt(i))) i++;
    if (text.charCodeAt(i) !== 40) return false;
    i++;
    const arg0Start = i;
    while (i < end && text.charCodeAt(i) !== 44 && text.charCodeAt(i) !== 40 && text.charCodeAt(i) !== 41 && text.charCodeAt(i) !== 91 && text.charCodeAt(i) !== 93 && text.charCodeAt(i) !== 124 && text.charCodeAt(i) !== 34 && text.charCodeAt(i) !== 39) i++;
    if (i >= end || text.charCodeAt(i) !== 44) return false;
    const arg0End = i++;
    const arg1Start = i;
    while (i < end && text.charCodeAt(i) !== 41 && text.charCodeAt(i) !== 40 && text.charCodeAt(i) !== 44 && text.charCodeAt(i) !== 91 && text.charCodeAt(i) !== 93 && text.charCodeAt(i) !== 124 && text.charCodeAt(i) !== 34 && text.charCodeAt(i) !== 39) i++;
    if (i >= end || text.charCodeAt(i) !== 41) return false;
    const arg1End = i++;
    while (i < end && isWhitespaceCode(text.charCodeAt(i))) i++;
    if (i !== end) return false;
    if (!scalarTokenRange(text, arg0Start, arg0End, out, 0) ||
        !scalarTokenRange(text, arg1Start, arg1End, out, 1)) return false;
    out.name = text.slice(start, nameEnd);
    return true;
  };

  const parseBinaryCompoundRange = (text, start = 0, end = text.length) => {
    start = trimRangeStart(text, start, end);
    end = trimRangeEnd(text, start, end);
    let i = start;
    const first = text.charCodeAt(i);
    if (!(first >= 97 && first <= 122)) return null;
    i++;
    while (i < end && isNameContinueCode(text.charCodeAt(i))) i++;
    const nameEnd = i;
    while (i < end && isWhitespaceCode(text.charCodeAt(i))) i++;
    if (text.charCodeAt(i) !== 40) return null;
    i++;
    const arg1Start = i;
    while (i < end && text.charCodeAt(i) !== 44 && text.charCodeAt(i) !== 40 && text.charCodeAt(i) !== 41 && text.charCodeAt(i) !== 91 && text.charCodeAt(i) !== 93 && text.charCodeAt(i) !== 124 && text.charCodeAt(i) !== 34 && text.charCodeAt(i) !== 39) i++;
    if (i >= end || text.charCodeAt(i) !== 44) return null;
    const arg1End = i;
    i++;
    const arg2Start = i;
    while (i < end && text.charCodeAt(i) !== 41 && text.charCodeAt(i) !== 40 && text.charCodeAt(i) !== 44 && text.charCodeAt(i) !== 91 && text.charCodeAt(i) !== 93 && text.charCodeAt(i) !== 124 && text.charCodeAt(i) !== 34 && text.charCodeAt(i) !== 39) i++;
    if (i >= end || text.charCodeAt(i) !== 41) return null;
    const arg2End = i;
    i++;
    while (i < end && isWhitespaceCode(text.charCodeAt(i))) i++;
    if (i !== end) return null;
    const left = scalarOrVariableRange(text, arg1Start, arg1End);
    if (!left) return null;
    const right = scalarOrVariableRange(text, arg2Start, arg2End);
    if (!right) return null;
    return compound(text.slice(start, nameEnd), [left, right]);
  };

  const parseFastLine = (text) => {
    if (!text.endsWith('.')) return null;
    const end = text.length - 1;
    const rule = text.indexOf(':-');
    if (rule < 0) {
      const head = parseBinaryCompoundRange(text, 0, end);
      return head ? { head, body: [] } : null;
    }
    if (text.indexOf(':-', rule + 2) >= 0) return null;
    const head = parseBinaryCompoundRange(text, 0, rule);
    if (!head) return null;
    const bodyGoal = parseBinaryCompoundRange(text, rule + 2, end);
    return bodyGoal ? { head, body: [bodyGoal] } : null;
  };

  const findRuleInRange = (text, start, end) => {
    // String#indexOf has no end bound. Using it here used to scan the rest of
    // the complete source for every fact line, making large fact files
    // quadratic when their rules appeared before the facts.
    for (let i = start; i + 1 < end; i++) {
      if (text.charCodeAt(i) === 58 && text.charCodeAt(i + 1) === 45) return i;
    }
    return -1;
  };

  const reportFastBinarySingletonWarnings = (head, body, line) => {
    if (typeof options.onWarning !== 'function') return;
    const variables = [];
    const add = (type, name) => {
      if (type !== 'var' || String(name).startsWith('_')) return;
      variables.push(name);
    };
    add(head.arg0Type, head.arg0Name);
    add(head.arg1Type, head.arg1Name);
    if (body != null) {
      add(body.arg0Type, body.arg0Name);
      add(body.arg1Type, body.arg1Name);
    }
    for (let i = 0; i < variables.length; i++) {
      let count = 0;
      for (let j = 0; j < variables.length; j++) {
        if (variables[i] === variables[j]) count++;
      }
      if (count === 1) {
        options.onWarning({
          kind: 'singleton',
          name: variables[i],
          filename: options.filename ?? '<input>',
          line,
        });
      }
    }
  };

  const emitFastBinaryRange = (text, start, end, line) => {
    if (!emitBinary || start >= end || text.charCodeAt(end - 1) !== 46) return false;
    const termEnd = end - 1;
    const rule = findRuleInRange(text, start, termEnd);
    if (rule < 0) {
      if (!parseBinaryRawRange(text, start, termEnd, rawHead)) return false;
      reportFastBinarySingletonWarnings(rawHead, null, line);
      emitBinary(rawHead.name,
        rawHead.arg0Type, rawHead.arg0Name, rawHead.arg1Type, rawHead.arg1Name,
        null, null, null, null, null);
      return true;
    }
    if (findRuleInRange(text, rule + 2, termEnd) >= 0 ||
        !parseBinaryRawRange(text, start, rule, rawHead) ||
        !parseBinaryRawRange(text, rule + 2, termEnd, rawBody)) return false;
    reportFastBinarySingletonWarnings(rawHead, rawBody, line);
    emitBinary(rawHead.name,
      rawHead.arg0Type, rawHead.arg0Name, rawHead.arg1Type, rawHead.arg1Name,
      rawBody.name, rawBody.arg0Type, rawBody.arg0Name, rawBody.arg1Type, rawBody.arg1Name);
    return true;
  };

  const parseFastRange = (text, start, end) => {
    if (start >= end || text.charCodeAt(end - 1) !== 46) return null;
    const termEnd = end - 1;
    const rule = findRuleInRange(text, start, termEnd);
    if (rule < 0) {
      const head = parseBinaryCompoundRange(text, start, termEnd);
      return head ? { head, body: [] } : null;
    }
    if (findRuleInRange(text, rule + 2, termEnd) >= 0) return null;
    const head = parseBinaryCompoundRange(text, start, rule);
    if (!head) return null;
    const bodyGoal = parseBinaryCompoundRange(text, rule + 2, termEnd);
    return bodyGoal ? { head, body: [bodyGoal] } : null;
  };

  const scalarOrVariable = (text) => scalarOrVariableFast(text.trim());
  const parseBinaryCompound = (text) => {
    const parsed = parseBinaryCompoundRange(text, 0, text.length);
    if (parsed) return parsed;
    text = text.trim();
    const open = text.indexOf('(');
    if (open <= 0 || text[text.length - 1] !== ')') return null;
    const name = text.slice(0, open).trim();
    if (!isSimpleName(name)) return null;
    const inner = text.slice(open + 1, -1);
    if (inner.includes('(') || inner.includes(')') || inner.includes('[') || inner.includes(']') || inner.includes('|') || inner.includes('"') || inner.includes("'")) return null;
    const comma = inner.indexOf(',');
    if (comma < 0 || inner.indexOf(',', comma + 1) >= 0) return null;
    const left = inner.slice(0, comma).trim();
    const right = inner.slice(comma + 1).trim();
    if (!isFastScalarToken(left) || !isFastScalarToken(right)) return null;
    return compound(name, [scalarOrVariable(left), scalarOrVariable(right)]);
  };

  const parseSimple = (text) => {
    const fast = parseFastLine(text);
    if (fast) return fast;
    if (!text.endsWith('.') || text.includes('\n')) return null;
    text = text.slice(0, -1);
    const rule = text.indexOf(':-');
    if (rule < 0) {
      const head = parseBinaryCompound(text);
      return head ? { head, body: [] } : null;
    }
    const head = parseBinaryCompound(text.slice(0, rule));
    const bodyGoal = parseBinaryCompound(text.slice(rule + 2));
    return head && bodyGoal ? { head, body: [bodyGoal] } : null;
  };

  const preparationConversionActive = () =>
    options.parserFlagState?.charConversion === 'on' &&
    (options.parserFlagState?.charConversions?.size ?? 0) > 0;

  const flush = () => {
    const text = chunk.trim();
    const sourceLine = chunkStartLine;
    chunk = '';
    if (!text) return true;
    // Once a preparation-time char_conversion/2 mapping is active, every
    // subsequent source character must pass through the full tokenizer. The
    // compact parser deliberately operates on raw source ranges, so using it
    // here would silently bypass Convc for otherwise simple clauses.
    const simple = preparationConversionActive() ? null : parseSimple(text);
    if (simple) {
      reportClauseSingletonWarnings(simple, options.onWarning, options.filename ?? '<input>', sourceLine);
      accept(simple);
      return true;
    }
    try {
      const nestedWarning = typeof options.onWarning === 'function'
        ? (warning) => options.onWarning({ ...warning, line: warning.line + sourceLine - 1 })
        : null;
      const parsed = new Parser(text, { ...options, sourceMetadata: false, onWarning: nestedWarning }).parseProgram();
      for (const clause of parsed) accept(clause);
      return true;
    } catch (_) {
      return false;
    }
  };

  let lineStart = 0;
  let lineNumber = 1;
  while (lineStart <= source.length) {
    let lineEnd = source.indexOf('\n', lineStart);
    if (lineEnd < 0) lineEnd = source.length;
    let contentStart = lineStart;
    let contentEnd = lineEnd;
    if (contentEnd > contentStart && source.charCodeAt(contentEnd - 1) === 13) contentEnd--;
    contentStart = trimRangeStart(source, contentStart, contentEnd);
    contentEnd = trimRangeEnd(source, contentStart, contentEnd);
    if (contentStart < contentEnd && source.charCodeAt(contentStart) !== 37) {
      if (!chunk && source.charCodeAt(contentEnd - 1) === 46 && !preparationConversionActive()) {
        if (emitFastBinaryRange(source, contentStart, contentEnd, lineNumber)) {
          // The program builder accepted a compact binary clause directly.
        } else {
          const simple = parseFastRange(source, contentStart, contentEnd);
          if (simple) {
            reportClauseSingletonWarnings(simple, options.onWarning, options.filename ?? '<input>', lineNumber);
            accept(simple);
          } else {
            chunkStartLine = lineNumber;
            chunk = source.slice(lineStart, lineEnd) + '\n';
            if (!flush()) return null;
          }
        }
      } else {
        if (!chunk) chunkStartLine = lineNumber;
        chunk += source.slice(lineStart, lineEnd) + '\n';
        if (source.charCodeAt(contentEnd - 1) === 46) {
          if (!flush()) return null;
        }
      }
    }
    if (lineEnd === source.length) break;
    lineStart = lineEnd + 1;
    lineNumber++;
  }
  if (chunk.trim() && !flush()) return null;
  return clauses ?? true;
}

export function parseProgramText(source, options = {}) {
  return parseClauses(source, options);
}

const invalidNumberTokenError = new Error('not exactly one number token');

function skipDigitSeparatorLayout(source, start) {
  let position = start;
  while (true) {
    while (isWhitespaceCharacter(source[position] ?? '')) position++;
    if (source[position] === '%') {
      const newline = source.indexOf('\n', position + 1);
      if (newline < 0) return source.length;
      position = newline + 1;
      continue;
    }
    if (source.startsWith('/*', position)) {
      const end = source.indexOf('*/', position + 2);
      if (end < 0) return source.length;
      position = end + 2;
      continue;
    }
    return position;
  }
}

function separatedIntegerDigits(source, start, digitPattern, enabled) {
  let position = start;
  let digits = '';
  let separated = false;
  while (digitPattern.test(source[position] ?? '')) {
    digits += source[position++];
    if (!enabled || source[position] !== '_') continue;
    separated = true;
    position = skipDigitSeparatorLayout(source, position + 1);
    if (!digitPattern.test(source[position] ?? '')) throw invalidNumberTokenError;
  }
  return { digits, position, separated };
}

export function parseNumberTokenText(text, options = {}) {
  const source = String(text ?? '');
  const digitSeparators = options.isoStrict !== true;
  let position = 0;
  let negative = false;
  if (source[position] === '-') {
    negative = true;
    position++;
  }

  // number_chars/2 and number_codes/2 need the lexical number production,
  // not a general term reader. Keeping this scanner number-only avoids
  // allocating a Parser and three operator tables for every conversion.
  if (source.startsWith("0'", position)) {
    position += 2;
    let value = source[position] ?? '';
    if (!value || (value !== ' ' && isWhitespaceCode(value.charCodeAt(0)))) {
      throw invalidNumberTokenError;
    }
    position++;
    const firstCode = value.charCodeAt(0);
    if (firstCode >= 0xd800 && firstCode <= 0xdbff) {
      const secondCode = source.charCodeAt(position);
      if (secondCode < 0xdc00 || secondCode > 0xdfff) throw invalidNumberTokenError;
      value += source[position++];
    } else if (firstCode >= 0xdc00 && firstCode <= 0xdfff) {
      throw invalidNumberTokenError;
    }

    if (value === "'") {
      if (source[position] !== "'") throw invalidNumberTokenError;
      position++;
    } else if (value === '\\') {
      const escaped = source[position++] ?? '';
      const controls = { a: '\x07', b: '\b', r: '\r', f: '\f', t: '\t', n: '\n', v: '\v' };
      if (controls[escaped] != null) {
        value = controls[escaped];
      } else if (escaped === 'x') {
        let digits = '';
        while (RE_HEX_DIGIT.test(source[position] ?? '')) digits += source[position++];
        if (!digits || source[position++] !== '\\') throw invalidNumberTokenError;
        const code = Number.parseInt(digits, 16);
        if (code > 0x10ffff || (code >= 0xd800 && code <= 0xdfff)) throw invalidNumberTokenError;
        value = String.fromCodePoint(code);
      } else if (RE_OCTAL_DIGIT.test(escaped)) {
        let digits = escaped;
        while (RE_OCTAL_DIGIT.test(source[position] ?? '')) digits += source[position++];
        if (source[position++] !== '\\') throw invalidNumberTokenError;
        const code = Number.parseInt(digits, 8);
        if (code > 0x10ffff || (code >= 0xd800 && code <= 0xdfff)) throw invalidNumberTokenError;
        value = String.fromCodePoint(code);
      } else if (escaped === '\\' || escaped === "'" || escaped === '"' || escaped === '`') {
        value = escaped;
      } else {
        throw invalidNumberTokenError;
      }
    }

    if (position !== source.length) throw invalidNumberTokenError;
    const code = value.codePointAt(0);
    return numberTerm(String(negative ? -code : code));
  }

  if (source[position] === '0' && ['b', 'o', 'x'].includes(source[position + 1])) {
    const kind = source[position + 1];
    const radix = kind === 'b' ? 2 : kind === 'o' ? 8 : 16;
    const digitPattern = radix === 2 ? /^[01]$/ : radix === 8 ? /^[0-7]$/ : /^[0-9A-Fa-f]$/;
    position += 2;
    const scanned = separatedIntegerDigits(source, position, digitPattern, digitSeparators);
    const { digits } = scanned;
    position = scanned.position;
    if (!digits || position !== source.length) throw invalidNumberTokenError;
    let integer = 0n;
    for (const digit of digits) integer = integer * BigInt(radix) + BigInt(Number.parseInt(digit, radix));
    if (negative) integer = -integer;
    return numberTerm(integer.toString());
  }

  const scanned = separatedIntegerDigits(source, position, /^[0-9]$/, digitSeparators);
  const { digits, separated } = scanned;
  position = scanned.position;
  if (!digits) throw invalidNumberTokenError;
  let hasFraction = false;
  if (!separated && source[position] === '.' && isDigitCode(source.charCodeAt(position + 1))) {
    hasFraction = true;
    position++;
    while (isDigitCode(source.charCodeAt(position))) position++;
  }
  if (hasFraction && (source[position] === 'e' || source[position] === 'E')) {
    position++;
    if (source[position] === '+' || source[position] === '-') position++;
    const exponentStart = position;
    while (isDigitCode(source.charCodeAt(position))) position++;
    if (position === exponentStart) throw invalidNumberTokenError;
  }
  if (position !== source.length) throw invalidNumberTokenError;
  if (!hasFraction) return numberTerm(BigInt(`${negative ? '-' : ''}${digits}`).toString());
  return numberTerm(finiteFloatTokenText(source));
}

export function parseTermText(text, options = {}) {
  return new Parser(text, options).parseStandaloneTerm();
}

export function parseGoalText(text, options = {}) {
  const clauses = parseClauses(`zz_goal((${text})).`, options);
  const head = clauses[0]?.head;
  if (clauses.length !== 1 || head?.type !== 'compound' ||
      head.name !== 'zz_goal' || head.arity !== 1 || clauses[0].body.length !== 0) {
    throw new Error('bad goal');
  }
  return head.args[0];
}
