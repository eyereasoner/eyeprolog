// A proof, played out as a dialogue.
//
// In the dialogue logic of Lorenzen and Lorenz a proponent defends a claim
// against an opponent who may challenge every assertion that is not common
// ground; the claim holds when the proponent can answer every challenge. A
// checked proof already has that shape (SPEC.md, Section 11): the proponent's
// defence is the proof, and the opponent is the checker. The opponent asks
// `why` of each derived goal, concedes the program's facts, verifies what it
// can decide again, grants what it can only take on trust, and objects to
// whatever the check refuted.
//
// With evidence of its own, the opponent can do more than a checker: it can
// try to show what an absence (`\+ G`) says does not hold. When it can, the
// absence is countered and the proponent's defence of the claim falls. Under
// the formal rule of dialogue logic the proponent may then use the opponent's
// evidence too: it retracts its defence and defends the claim again from the
// program and the evidence together, or gives up.
import { Env, atom, compound, copyResolved, listFromItems, numberTerm, termToString } from './term.js';
import { Solver } from './solver.js';
import { executeGoals, goalsInProgramOrder, normalizeGoals } from './execute.js';
import { checkedProof } from './proof-document.js';
import { proofNodeFor } from './explain.js';
import { formatFact, resultWriteOptions } from './result-format.js';

// The dialogue of each fact a run of `goals` claims, as `move/4`, `outcome/3`
// and `obligation/2` facts. `evidence`, when given, is the program with the
// opponent's evidence added to it.
//
// `evidenceFile` names the source the evidence was read from, so a counter
// can say which evidence it rests on.
export function dialogueText(program, goals, { registry, proofDetail = 'abstract', evidence = null, evidenceFile = null } = {}) {
  const first = provedRun(program, goals, { registry, proofDetail });
  let second = null;
  const counter = evidence == null ? null : counterWith(evidence, registry, evidenceFile);
  const writeOptions = resultWriteOptions(program);
  const lines = [];

  first.claimed.forEach((claim, index) => {
    const dialogue = numberTerm(BigInt(index + 1));
    const moves = [['proponent', compound('claims', [claim])]];
    let defence = defend(claim, first, moves, counter);
    if (defence.countered) {
      moves.push(['proponent', compound('retracts', [claim, first.steps.get(key(claim))?.by ?? atom('unproven')])]);
      second ??= provedRun(evidence, goals, { registry, proofDetail });
      if (second.steps.has(key(claim))) {
        defence = defend(claim, second, moves, null);
      } else {
        moves.push(['proponent', compound('gives_up', [claim])]);
        defence = { won: false, obligations: [] };
      }
    }
    moves.forEach(([speaker, act], at) => {
      lines.push(formatFact(compound('move', [dialogue, numberTerm(BigInt(at + 1)), atom(speaker), act]), writeOptions));
    });
    lines.push(formatFact(compound('outcome', [dialogue, claim, atom(defence.won ? 'won' : 'lost')]), writeOptions));
    // What a win still rests on; a lost defence rests on nothing.
    if (defence.won) {
      for (const goal of defence.obligations) lines.push(formatFact(compound('obligation', [dialogue, goal]), writeOptions));
    }
  });
  return lines.length ? `${lines.join('\n')}\n` : '';
}

// A run of the goals with its checked proof, indexed for the dialogue: each
// step by the goal it concludes, and what the check trusted or refuted.
function provedRun(program, goals, { registry, proofDetail }) {
  const solver = new Solver(program, { registry, ioOptions: { write: () => {}, errorWrite: () => {} } });
  const ordered = goalsInProgramOrder(solver.program, normalizeGoals(goals, solver));
  const claimed = [];
  executeGoals(solver.program, solver, ordered, { onAnswer: (_line, resolved) => claimed.push(resolved) });
  const { steps, report } = checkedProof(solver.program, claimed, { registry, proofDetail, solver, goals: ordered });
  const byGoal = new Map();
  for (const step of steps) if (!byGoal.has(key(step.conclusion))) byGoal.set(key(step.conclusion), step);
  const trusted = new Set(report.trusted.map((item) => item.conclusion));
  const objections = new Map();
  for (const failure of report.failures) {
    if (failure.conclusion == null) continue;
    if (!objections.has(failure.conclusion)) objections.set(failure.conclusion, []);
    objections.get(failure.conclusion).push(failure);
  }
  return { claimed, steps: byGoal, trusted, objections };
}

// The opponent's attempt at what an absence denies, from the program and its
// evidence: the instance it can show and the evidence facts its argument
// rests on, or null.
function counterWith(evidence, registry, evidenceFile) {
  const solver = new Solver(evidence, { registry, ioOptions: { write: () => {}, errorWrite: () => {} } });
  return (goal) => {
    let shown = null;
    try {
      for (const env of solver.solve([goal], new Env(), 0)) {
        shown = copyResolved(goal, env);
        break;
      }
    } catch {
      // A goal the evidence cannot even run shows nothing.
    }
    if (shown == null) return null;
    const used = [];
    const seen = new Set();
    const pending = [proofNodeFor(solver.program, shown, { registry, solver })];
    while (pending.length > 0) {
      const node = pending.pop();
      if (node == null) continue;
      if (node.method?.type === 'source' && node.method.filename === evidenceFile && !seen.has(key(node.goal))) {
        seen.add(key(node.goal));
        used.push(node.goal);
      }
      for (let i = (node.children?.length ?? 0) - 1; i >= 0; i--) pending.push(node.children[i]);
    }
    return { shown, used };
  };
}

// The moves defending `claim` with the steps of `run`, left to right and depth
// first. A goal already defended in this dialogue is conceded when it is used
// again. The defence stops at the first move that loses it.
function defend(claim, run, moves, counter) {
  const defended = new Set();
  const obligations = [];
  const stack = [claim];
  const opponent = (name, ...args) => moves.push(['opponent', compound(name, args)]);
  const lost = (countered = false) => ({ won: false, countered, obligations });

  while (stack.length > 0) {
    const goal = stack.pop();
    const id = key(goal);
    const step = run.steps.get(id);
    if (defended.has(id) || step == null) {
      // Established earlier, or a fact of the program used without a step.
      opponent('concedes', goal);
      continue;
    }
    defended.add(id);
    const by = step.by;
    const kind = by.name;

    if (kind === 'rule' || kind === 'control') {
      opponent('why', goal);
      moves.push(['proponent', compound('because', [goal, by, listFromItems(step.uses)])]);
    } else if (kind === 'fact') {
      opponent('concedes', goal);
    } else if (kind === 'absent') {
      const countered = counter == null ? null : counter(goal.args[0]);
      if (countered != null) {
        opponent('counters', goal, countered.shown, listFromItems(countered.used));
        return lost(true);
      }
      if (run.trusted.has(id)) {
        opponent('grants', goal);
        obligations.push(goal);
      } else {
        opponent('verifies', goal);
      }
    } else if (kind === 'builtin') {
      if (run.trusted.has(id)) {
        opponent('grants', goal);
        obligations.push(goal);
      } else {
        opponent('verifies', goal);
      }
    } else if (kind === 'unproven') {
      moves.push(['proponent', compound('gives_up', [goal])]);
      return lost();
    } else {
      // collected, asserted: taken on trust.
      opponent('grants', goal);
      obligations.push(goal);
    }

    const refuted = run.objections.get(id);
    if (refuted) {
      for (const failure of refuted) opponent('objects', goal, atom(failure.condition), atom(failure.detail));
      return lost();
    }
    for (let i = step.uses.length - 1; i >= 0; i--) stack.push(step.uses[i]);
  }
  return { won: true, countered: false, obligations };
}

function key(term) {
  return termToString(term, new Env(), true);
}
