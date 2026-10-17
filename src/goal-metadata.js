// Host-supplied goal metadata embedded in ordinary Prolog comments.
//
// A declared goal is written as a commented-out ISO query, `%% ?- Goal.`,
// so it reads exactly like the `?- Goal.` a program may write directly. The
// difference is only who runs it: a commented one is inert to every other
// processor, which is what keeps a file portable to the external Prologs
// the conformance harness runs it through.
export function goalsFromSource(source) {
  const goals = [];
  const lines = String(source ?? '').split(/\r?\n/);
  for (let index = 0; index < lines.length; index++) {
    const match = lines[index].match(/^\s*%%\s*\?-\s*(.*)$/);
    if (!match) continue;
    let goal = match[1];
    while (lines[index + 1]?.match(/^\s*%%/) && !lines[index + 1].match(/^\s*%%\s*\?-/)) {
      index++;
      goal += `\n${lines[index].replace(/^\s*%%\s?/, '')}`;
    }
    // The trailing full stop belongs to the query form, not to the goal.
    goals.push(goal.trim().replace(/\.$/, '').trim());
  }
  return goals;
}

// The playground's goal field lists several goals separated by `;`. Only a
// `;` outside brackets, quotes and comments separates two goals; one inside
// brackets is the ISO disjunction operator, so `X = (foo, bar ; baz)` stays
// one goal. A goal may also be typed in query form, `?- Goal.`.
export function goalsFromList(text) {
  const goals = [];
  const source = String(text ?? '');
  let depth = 0;
  let start = 0;
  for (let index = 0; index < source.length; index++) {
    const ch = source[index];
    if (ch === "'" || ch === '"' || ch === '`') {
      if (ch === "'" && source[index - 1] === '0' && !/[\w]/.test(source[index - 2] ?? '')) {
        // 0'c character code: skip the quoted character, which may be `;`.
        index += source[index + 1] === '\\' || (source[index + 1] === "'" && source[index + 2] === "'") ? 2 : 1;
        continue;
      }
      index = endOfQuoted(source, index);
    } else if (ch === '%') {
      const end = source.indexOf('\n', index);
      index = end === -1 ? source.length : end;
    } else if (ch === '/' && source[index + 1] === '*') {
      const end = source.indexOf('*/', index + 2);
      index = end === -1 ? source.length : end + 1;
    } else if (ch === '(' || ch === '[' || ch === '{') {
      depth++;
    } else if (ch === ')' || ch === ']' || ch === '}') {
      depth = Math.max(0, depth - 1);
    } else if (ch === ';' && depth === 0) {
      goals.push(source.slice(start, index));
      start = index + 1;
    }
  }
  goals.push(source.slice(start));
  return goals.map(queryGoal).filter(Boolean);
}

function endOfQuoted(source, open) {
  const quote = source[open];
  for (let index = open + 1; index < source.length; index++) {
    if (source[index] === '\\') index++;
    else if (source[index] === quote) {
      if (source[index + 1] !== quote) return index;
      index++;
    }
  }
  return source.length;
}

function queryGoal(text) {
  // Drop the query prefix and the end token; a `.` after a symbol character
  // is part of an operator such as `=..`, not an end token.
  return text.trim().replace(/^\?-\s*/, '').replace(/(^|[^-+*/\\^<>=~:.?@#&$])\.$/, '$1').trim();
}
