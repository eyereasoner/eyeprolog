// The proof a run writes, checked before it is written.
//
// A reasoner checks every proof it generates against the program, under the
// conditions a separate checker would apply (SPEC.md, Section 7.1), and fails
// with an error rather than return a proof that does not pass. A document that
// says it explains an answer is only worth writing if it does.
import { flattenProof, proofNodeFor } from './explain.js';
import { checkProof } from './check-proof.js';
import { clauseRecordTerm, proofBlocks } from './result-format.js';
import { Env, atom, termToString } from './term.js';

export class ProofCheckError extends Error {
  constructor(report) {
    const shown = report.failures.slice(0, 3)
      .map((failure) => `[${failure.condition}] ${failure.detail}`)
      .join('; ');
    const more = report.failures.length > 3 ? `; and ${report.failures.length - 3} more` : '';
    super(`the proof of this run does not check, so it is not written: ${report.failures.length} failure(s): ${shown}${more}`);
    this.name = 'ProofCheckError';
    this.report = report;
  }
}

// The `clause/3` and `step/4` blocks explaining the facts a run claimed, once
// they have been checked. One walk across every claim, so a conclusion several
// of them rest on is explained once.
//
// An answer the solver found but the explanation replay cannot reproduce -- a
// CLP(B) answer decided by propagation rather than by resolution -- is
// recorded as `unproven` rather than quietly left without a step. Such a proof
// does not check, so the run fails with a ProofCheckError instead.
//
// `goals` are the goals the run asked, which its claims answer (C7); a run of
// forward rules asks none.
export function checkedProofBlocks(program, claimed, { registry, proofDetail = 'abstract', solver = null, goals = [] } = {}) {
  const roots = [];
  const unexplained = [];
  const questions = goals.filter((goal) => typeof goal !== 'string');
  for (const fact of claimed) {
    const node = proofNodeFor(program, fact, { registry, proofDetail, solver, questions });
    if (node) roots.push(node);
    else unexplained.push(fact);
  }
  const { clauses, steps } = flattenProof(roots, program);
  const concluded = new Set(steps.map((step) => termToString(step.conclusion, new Env(), true)));
  for (const fact of unexplained) {
    if (concluded.has(termToString(fact, new Env(), true))) continue;
    steps.push({ conclusion: fact, by: atom('unproven'), bindings: [], uses: [] });
  }

  const records = clauses.map(([number, clause]) => clauseRecordTerm(number, clause));
  const report = checkProof(program, { claims: claimed, records, steps }, { goals });
  if (!report.valid) throw new ProofCheckError(report);
  return proofBlocks(program, clauses, steps);
}
