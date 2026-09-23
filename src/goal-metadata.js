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
