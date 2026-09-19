// ISO term-output formatting kept separate from the stable source renderer.
import {
  ATOM, COMPOUND, NUMBER, STRING, VAR,
  Env, deref, isCons, isEmptyList,
} from './term.js';

const graphicAtomCharacters = new Set('!#$&*+-./<=>?@^~\\'.split(''));
const compactInfixOperators = new Set([':', '..']);
const RE_LOWER_WORD = /^[a-z][A-Za-z0-9_]*$/;
const RE_ALNUM_IDENT = /^[A-Za-z0-9_]$/;
const RE_DIGITS_ONLY = /^\d+$/;
const RE_LEGACY_VAR_W = /^\?(?:[A-Za-z_][A-Za-z0-9_]*)?$/;
const RE_UPPER_IDENT_W = /^(?:_|[A-Z_][A-Za-z0-9_]*)$/;
const RE_SANITIZE_W = /[^A-Za-z0-9_]/g;
const RE_UPPER_START_W = /^[A-Z_]/;

function quotedControlEscape(ch) {
  if (ch === '\x00') return '\\0\\';
  if (ch === '\x07') return '\\a';
  if (ch === '\b') return '\\b';
  if (ch === '\r') return '\\r';
  if (ch === '\f') return '\\f';
  if (ch === '\t') return '\\t';
  if (ch === '\n') return '\\n';
  if (ch === '\v') return '\\v';
  const code = ch.codePointAt(0);
  // Other C0 controls and DEL have no ISO symbolic-control escape. Emit an
  // octal escape so quoted output remains valid read-back syntax instead of
  // leaking a raw control character into the output stream.
  if (code < 0x20 || code === 0x7f) return `\\${code.toString(8)}\\`;
  return null;
}

function atomNeedsQuotes(name) {
  if (!name) return true;
  if (name === '[]' || name === '{}') return false;
  // `;` is a solo-character name token in ISO 6.4.2/6.5.3, so unlike most
  // solo characters it is a valid atom without quotes. Keep `|` distinct:
  // Corrigendum 2 makes the bar token equivalent to atom '|' only while it
  // is being used as an operator; as an ordinary atom/functor it is quoted.
  if (name === ';') return false;
  // A lone full stop is the end token, not a graphic atom.  Longer
  // graphic tokens may contain dots and are valid unquoted writeq/1 output
  // (WG17 #371-373: ./*, .*, ...*).  Only a token beginning with /* would
  // be read as a bracketed comment and therefore still requires quoting.
  if (name === '.') return true;
  if (name.startsWith('/*')) return true;
  if (RE_LOWER_WORD.test(name)) return false;
  for (const ch of name) if (!graphicAtomCharacters.has(ch)) return true;
  return false;
}

function quoteAtom(name) {
  let out = "'";
  for (const ch of name) {
    if (ch === "'") out += "''";
    else if (ch === '\\') out += '\\\\';
    else out += quotedControlEscape(ch) ?? ch;
  }
  return out + "'";
}

function writeAtom(name) {
  return atomNeedsQuotes(name) ? quoteAtom(name) : name;
}

function isDottedGraphicAtom(name) {
  return name.includes('.') && [...name].some((ch) => ch !== '.') && !name.startsWith('/*') &&
    [...name].every((ch) => graphicAtomCharacters.has(ch));
}

function compactBoundaryNeedsSpace(left, right) {
  const leftChars = Array.from(left);
  const rightChars = Array.from(right);
  const a = leftChars[leftChars.length - 1] ?? '';
  const b = rightChars[0] ?? '';
  if (!a || !b) return false;
  // Adjacent quoted atoms need layout: `''` is part of quoted-atom syntax,
  // so concatenating two quoted operator/argument tokens would change the
  // tokenization (WG17 #169).
  if (a === "'" && b === "'") return true;
  // Adjacent graphic characters form one maximal graphic token. Keep them
  // apart when an operator boundary would otherwise disappear (`a+ -b`,
  // `a/ *b`, etc.).
  if (graphicAtomCharacters.has(a) && graphicAtomCharacters.has(b)) return true;
  // Alphanumeric operator names similarly need a lexical boundary from a
  // neighbouring identifier/number token.  Most predefined word operators
  // are handled explicitly below; this also protects quoted/custom cases that
  // render without punctuation.
  if (RE_ALNUM_IDENT.test(a) && RE_ALNUM_IDENT.test(b)) return true;
  return false;
}

function isWordOperatorToken(token) {
  return RE_LOWER_WORD.test(token);
}

function compactPrefixOperator(token, argument) {
  if (isWordOperatorToken(token)) return `${token} ${argument}`;
  // Without layout, `op(...)` is functional notation rather than prefix-operator
  // notation. ISO 7.10.5 h requires operator-form output and layout whenever
  // ambiguity could otherwise arise, so a parenthesized prefix argument must
  // never be glued directly to the operator token.
  const needsLayout = argument.startsWith('(') || compactBoundaryNeedsSpace(token, argument);
  return `${token}${needsLayout ? ' ' : ''}${argument}`;
}

function quotedOperatorAfterNumericNeedsSpace(left, token) {
  if (!token.startsWith("'") || !RE_DIGITS_ONLY.test(left)) return false;
  const value = Number(left);
  // `0'X` starts character-code notation and bases 2..36 start based-number
  // notation. Base 1 and values above 36 do not, so they need no layout
  // before a quoted operator (WG17 #208, #355).
  return value === 0 || (value >= 2 && value <= 36);
}

function compactPostfixOperator(argument, token) {
  const needsLayout = compactBoundaryNeedsSpace(argument, token) ||
    quotedOperatorAfterNumericNeedsSpace(argument, token);
  return `${argument}${needsLayout ? ' ' : ''}${token}`;
}

function compactInfixOperator(left, token, right) {
  // Solo punctuation operators already delimit themselves.
  if (token === ',' || token === ';') return `${left}${token}${right}`;
  const before = (compactBoundaryNeedsSpace(left, token) ||
    quotedOperatorAfterNumericNeedsSpace(left, token)) ? ' ' : '';
  let after = compactBoundaryNeedsSpace(token, right) ? ' ' : '';
  // A word operator immediately followed by `(` would look like functional
  // notation for that atom rather than operator notation.
  if (isWordOperatorToken(token) && right.startsWith('(')) after = ' ';
  return `${left}${before}${token}${after}${right}`;
}

function legacyVariableToIso(name) {
  if (name === '?') return '_';
  const tail = name.slice(1);
  if (!tail) return '_';
  if (tail[0] === '_') return tail;
  return tail[0].toUpperCase() + tail.slice(1);
}

function writeVariable(name) {
  name = String(name ?? '');
  if (RE_LEGACY_VAR_W.test(name)) return legacyVariableToIso(name);
  if (RE_UPPER_IDENT_W.test(name)) return name;
  const sanitized = name.replace(RE_SANITIZE_W, '_');
  if (!sanitized) return '_';
  return RE_UPPER_START_W.test(sanitized) ? sanitized : `_${sanitized}`;
}

function writeString(value) {
  let out = '"';
  for (const ch of value) {
    if (ch === '"' || ch === '\\') out += `\\${ch}`;
    else out += quotedControlEscape(ch) ?? ch;
  }
  return out + '"';
}

function quotedListCharacter(item, doubleQuotes) {
  if (doubleQuotes === 'chars') {
    if (item.type !== ATOM || Array.from(item.name).length !== 1) return null;
    return item.name;
  }
  if (doubleQuotes === 'codes') {
    if (item.type !== NUMBER || !RE_DIGITS_ONLY.test(item.name)) return null;
    const code = BigInt(item.name);
    if (code < 0n || code > 0x10ffffn || (code >= 0xd800n && code <= 0xdfffn)) return null;
    return String.fromCodePoint(Number(code));
  }
  return null;
}

function quotedListSplice(term, env, doubleQuotes) {
  if (doubleQuotes !== 'chars' && doubleQuotes !== 'codes') return null;
  const characters = [];
  let cursor = term;
  while (true) {
    cursor = deref(cursor, env);
    if (isEmptyList(cursor)) {
      return characters.length === 0 ? null : { text: characters.join(''), tail: null };
    }
    if (!isCons(cursor)) {
      return characters.length === 0 ? null : { text: characters.join(''), tail: cursor };
    }
    const character = quotedListCharacter(deref(cursor.args[0], env), doubleQuotes);
    if (character == null) return null;
    characters.push(character);
    cursor = cursor.args[1];
  }
}

function writeNumberedVariable(index) {
  if (!Number.isSafeInteger(index) || index < 0) return null;
  const letter = String.fromCharCode(65 + (index % 26));
  const suffix = Math.floor(index / 26);
  return suffix === 0 ? letter : `${letter}${suffix}`;
}

function operatorName(name) {
  // Corrigendum 2 adds a dedicated bar token to operator syntax. The atom
  // itself still needs quoting in functional notation, but operator-form
  // output must use the unquoted `|` token (WG17 #181/#290).
  if (name === '|') return '|';
  if (name === '.' || name.startsWith('/*')) return quoteAtom(name);
  if (RE_LOWER_WORD.test(name)) return name;
  if (/^[!#$&*+\-./<=>?@^~\\;:]+$/.test(name)) return name;
  return quoteAtom(name);
}

function operatorTable(definitions) {
  const table = new Map();
  for (const definition of definitions ?? []) {
    if (!definition || definition.priority === 0) continue;
    const entries = table.get(definition.name) ?? [];
    entries.push(definition);
    table.set(definition.name, entries);
  }
  return table;
}

function chooseOperator(term, table) {
  const definitions = table.get(term.name) ?? [];
  if (term.arity === 1) {
    return definitions.find((definition) => definition.specifier === 'fx' || definition.specifier === 'fy') ??
      definitions.find((definition) => definition.specifier === 'xf' || definition.specifier === 'yf') ?? null;
  }
  if (term.arity === 2) {
    return definitions.find((definition) => ['xfx', 'xfy', 'yfx'].includes(definition.specifier)) ?? null;
  }
  return null;
}

function printableReadVariableNames(term, env, explicit) {
  const names = new Map(explicit);
  const used = new Set(names.values());
  const suffixes = new Map();
  const seenVariables = new Set();
  const seenTerms = new Set();
  const stack = [term];

  while (stack.length) {
    const current = deref(stack.pop(), env);
    if (current.type === VAR) {
      if (seenVariables.has(current.name)) continue;
      seenVariables.add(current.name);
      if (names.has(current.name) || current.displayName == null) continue;
      const base = writeVariable(current.displayName);
      let candidate = base;
      let suffix = suffixes.get(base) ?? 1;
      while (used.has(candidate)) candidate = `${base}_${suffix++}`;
      suffixes.set(base, suffix);
      names.set(current.name, candidate);
      used.add(candidate);
      continue;
    }
    if (current.type !== COMPOUND || seenTerms.has(current)) continue;
    seenTerms.add(current);
    for (let i = current.arity - 1; i >= 0; i--) stack.push(current.args[i]);
  }

  return names;
}

function generatedVariableName(index) {
  const letter = String.fromCharCode(65 + (index % 26));
  const suffix = Math.floor(index / 26);
  return suffix === 0 ? `_${letter}` : `_${letter}${suffix}`;
}

function printableGeneratedVariableNames(term, env, explicit, state = null) {
  const names = new Map(explicit);
  const sharedNames = state?.names instanceof Map ? state.names : new Map();
  const used = new Set([...sharedNames.values(), ...names.values()]);
  const seenVariables = new Set();
  const seenTerms = new Set();
  const stack = [term];
  let generated = Number.isSafeInteger(state?.next) ? state.next : 0;

  while (stack.length) {
    const current = deref(stack.pop(), env);
    if (current.type === VAR) {
      if (seenVariables.has(current.name)) continue;
      seenVariables.add(current.name);
      if (names.has(current.name)) continue;
      const shared = sharedNames.get(current.name);
      if (shared != null) {
        names.set(current.name, shared);
        continue;
      }
      let candidate;
      do candidate = generatedVariableName(generated++); while (used.has(candidate));
      sharedNames.set(current.name, candidate);
      names.set(current.name, candidate);
      used.add(candidate);
      continue;
    }
    if (current.type !== COMPOUND || seenTerms.has(current)) continue;
    seenTerms.add(current);
    for (let i = current.arity - 1; i >= 0; i--) stack.push(current.args[i]);
  }

  if (state != null) state.next = generated;
  return names;
}

function format(term, env, options, table, maxPriority = 1200, context = 'term') {
  const resolved = deref(term, env);
  if (resolved.type === VAR) {
    return options.variableNames.get(resolved.name) ?? writeVariable(resolved.displayName ?? resolved.name);
  }
  if (resolved.type === STRING) return writeString(resolved.name);
  if (resolved.type === ATOM) {
    if (!options.quoted) return resolved.name;
    // Corrigendum 2's bare bar token exists only in operator syntax. It is
    // not an atom token, so an ordinary atom `|` must remain quoted even when
    // `|` is currently declared as an operator (for example as f('|')).
    if (resolved.name === '|') return quoteAtom(resolved.name);
    // Top-level bindings are already delimited by their answer punctuation.
    // Keep valid dotted graphic tokens readable there without weakening the
    // ISO writeq/1 policy tested by WG17 #308.
    if (options.dottedGraphicAtoms && isDottedGraphicAtom(resolved.name)) return resolved.name;
    // ISO 6.3.3.1 gives functional arguments and list elements a special
    // `arg` production: an atom that is a current operator is valid there
    // without quoting. Keep lexical exceptions such as `|` quoted.
    if (options.operatorAtomsAsArgs && context === 'argument' && table.has(resolved.name)) return operatorName(resolved.name);
    if (!options.ignoreOps && context !== 'argument' && table.has(resolved.name)) {
      // The predefined ?- atom is safe at the end of a written term and is a
      // graphic atom in ISO syntax. Do not add the legacy parentheses that
      // issue #35 reports for writeq(?-).
      if (resolved.name === '?-') return operatorName(resolved.name);
      const definitions = table.get(resolved.name);
      const requiresParentheses = definitions.some(({ specifier }) =>
        ['fx', 'fy', 'xfx', 'xfy', 'yfx'].includes(specifier));
      if (requiresParentheses) return `(${operatorName(resolved.name)})`;
    }
    return writeAtom(resolved.name);
  }
  if (resolved.type === NUMBER) return resolved.name;

  if (options.numbervars && resolved.type === COMPOUND && resolved.name === '$VAR' && resolved.arity === 1) {
    const index = deref(resolved.args[0], env);
    if (index.type === NUMBER && RE_DIGITS_ONLY.test(index.name)) {
      const name = writeNumberedVariable(Number(index.name));
      if (name != null) return name;
    }
  }

  if (isCons(resolved)) {
    // double_quotes/1 selects a character-list representation independently
    // of operator notation. In normal mode, `||` is fixed list-splice syntax
    // rather than an op/3 declaration, so ignore_ops(true) does not suppress
    // an explicitly requested double-quoted proper or partial character list.
    const quotedSplice = quotedListSplice(resolved, env, options.doubleQuotes);
    if (quotedSplice != null && (quotedSplice.tail == null || options.doubleBar)) {
      const prefix = writeString(quotedSplice.text);
      if (quotedSplice.tail == null) return prefix;
      // `||` is a normal-profile syntax extension whose tail has priority 0
      // (issue #116; see
      // https://www.complang.tuwien.ac.at/ulrich/iso-prolog/double_bar), so
      // any operator term in the right operand must be parenthesized to
      // keep the emitted text readable back as the same term — including
      // one whose own declared priority is as low as 1, since the parser
      // accepts nothing but a bare primary term after `||` unparenthesized.
      return `${prefix}||${format(quotedSplice.tail, env, options, table, 0, 'term')}`;
    }

    if (!options.ignoreOps) {
      const parts = [];
      let quotedSuffix = [];
      let cursor = resolved;
      while (true) {
        cursor = deref(cursor, env);
        const separator = options.compact ? ',' : ', ';
        if (isEmptyList(cursor)) {
          if (quotedSuffix.length > 1 && quotedSuffix.length < parts.length) {
            const prefix = parts.slice(0, parts.length - quotedSuffix.length);
            return `[${prefix.join(separator)}|${writeString(quotedSuffix.join(''))}]`;
          }
          return `[${parts.join(separator)}]`;
        }
        if (!isCons(cursor)) {
          const tailSeparator = options.compact ? '|' : ' | ';
          return `[${parts.join(separator)}${tailSeparator}${format(cursor, env, options, table, 999, 'argument')}]`;
        }
        const item = deref(cursor.args[0], env);
        const character = quotedListCharacter(item, options.doubleQuotes);
        if (character == null) quotedSuffix = [];
        else quotedSuffix.push(character);
        parts.push(format(cursor.args[0], env, options, table, 999, 'argument'));
        cursor = cursor.args[1];
      }
    }
  }

  if (!options.ignoreOps && resolved.name === '{}' && resolved.arity === 1) {
    // A current operator atom is valid as the complete curly-bracket content,
    // just as it is in a functional argument or list element.
    return `{${format(resolved.args[0], env, options, table, 1200, 'argument')}}`;
  }

  if (!options.ignoreOps) {
    const definition = chooseOperator(resolved, table);
    if (definition) {
      const { priority, specifier } = definition;
      const token = operatorName(resolved.name);
      let text;
      if (specifier === 'fx' || specifier === 'fy') {
        const argumentPriority = specifier === 'fx' ? priority - 1 : priority;
        // Corrigendum 3 adds mandatory parentheses for prefix - when its
        // argument is a non-negative number or is written in infix/postfix
        // operator form (ISO 7.10.5 h 2(iii-iv)).
        const child = deref(resolved.args[0], env);
        const childNumbervar = options.numbervars && child.type === COMPOUND &&
          child.name === '$VAR' && child.arity === 1 && (() => {
            const index = deref(child.args[0], env);
            return index.type === NUMBER && RE_DIGITS_ONLY.test(index.name) &&
              writeNumberedVariable(Number(index.name)) != null;
          })();
        const childUsesSpecialNotation = isCons(child) ||
          (child.type === COMPOUND && child.name === '{}' && child.arity === 1) || childNumbervar;
        const childDefinition = childUsesSpecialNotation ? null : chooseOperator(child, table);
        const negativeNeedsParentheses = resolved.name === '-' && (
          (child.type === NUMBER && !child.name.startsWith('-')) ||
          ['xf', 'yf', 'xfx', 'xfy', 'yfx'].includes(childDefinition?.specifier)
        );
        if (negativeNeedsParentheses) {
          // ISO 7.10.5 h 2(iii-iv): prefix - requires parentheses around a
          // non-negative number and around an argument written in infix or
          // postfix operator form. Keep layout before `(` so the result is
          // operator notation, not functional notation such as `-(...)`.
          const argument = format(resolved.args[0], env, options, table, 1200);
          text = `${token} (${argument})`;
        } else {
          const argument = format(resolved.args[0], env, options, table, argumentPriority);
          text = options.minimalOperatorSpacing ? compactPrefixOperator(token, argument) : `${token} ${argument}`;
        }
      } else if (specifier === 'xf' || specifier === 'yf') {
        let argumentPriority = specifier === 'xf' ? priority - 1 : priority;
        const childDefinition = chooseOperator(deref(resolved.args[0], env), table);
        if (childDefinition?.priority === priority &&
            ['fx', 'fy', 'xfx', 'xfy', 'yfx'].includes(childDefinition.specifier)) {
          argumentPriority = priority - 1;
        }
        const child = deref(resolved.args[0], env);
        let argument = format(resolved.args[0], env, options, table, argumentPriority);
        // If both the operand atom and postfix operator require quoted names,
        // plain adjacency would form quoted-atom escape syntax and layout would
        // not match the ISO writer form. Parenthesize the operator atom instead
        // (WG17 #169). Do not apply this to ordinary word postfix operators.
        if (options.minimalOperatorSpacing && child.type === ATOM && table.has(child.name) &&
            writeAtom(child.name).startsWith("'") && token.startsWith("'") &&
            compactBoundaryNeedsSpace(argument, token)) {
          argument = `(${argument})`;
        }
        text = options.minimalOperatorSpacing ? compactPostfixOperator(argument, token) : `${argument} ${token}`;
      } else {
        let leftPriority = specifier === 'yfx' ? priority : priority - 1;
        const rightPriority = specifier === 'xfy' ? priority : priority - 1;
        const leftDefinition = chooseOperator(deref(resolved.args[0], env), table);
        if (leftDefinition?.priority === priority && ['fx', 'fy'].includes(leftDefinition.specifier)) {
          leftPriority = priority - 1;
        }
        const left = format(resolved.args[0], env, options, table, leftPriority);
        const right = format(resolved.args[1], env, options, table, rightPriority);
        if (options.minimalOperatorSpacing) {
          text = resolved.name === ',' ? `${left},${right}` : compactInfixOperator(left, token, right);
        } else if (resolved.name === ',') {
          text = `${left}, ${right}`;
        } else {
          text = compactInfixOperators.has(resolved.name) ? `${left}${token}${right}` : `${left} ${token} ${right}`;
        }
      }
      return priority > maxPriority ? `(${text})` : text;
    }
  }

  const name = options.quoted ? writeAtom(resolved.name) : resolved.name;
  const args = resolved.args.map((arg) => format(arg, env, options, table, 999, 'argument'));
  return `${name}(${args.join(options.compact ? ',' : ', ')})`;
}

export function formatTermForWrite(term, env = new Env(), options = {}) {
  const explicitVariableNames = options.variableNames instanceof Map ? options.variableNames : new Map();
  const normalized = {
    quoted: options.quoted === true,
    ignoreOps: options.ignoreOps === true,
    numbervars: options.numbervars !== false,
    doubleQuotes: options.doubleQuotes,
    // `||` is a normal-profile syntax extension. Public normal-mode writers
    // enable it by default; strict callers explicitly turn it off.
    doubleBar: options.doubleBar !== false,
    variableNames: options.generateVariableNames === true
      ? printableGeneratedVariableNames(term, env, explicitVariableNames, options.variableNameState)
      : printableReadVariableNames(term, env, explicitVariableNames),
    compact: options.compact === true,
    minimalOperatorSpacing: options.minimalOperatorSpacing === true,
    operatorAtomsAsArgs: options.operatorAtomsAsArgs === true,
    dottedGraphicAtoms: options.dottedGraphicAtoms === true,
  };
  const maxPriority = Number.isInteger(options.maxPriority)
    ? Math.max(0, Math.min(1200, options.maxPriority))
    : 1200;
  return format(term, env, normalized, operatorTable(options.operators), maxPriority);
}
