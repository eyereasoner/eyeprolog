condition('C1', resolution, ok, 15).
condition('C2', well_founded, ok, 19).
condition('C3', justification, ok, 19).
condition('C4', coverage, ok, 20).
condition('C5', re_decision, ok, 0).
obligation(absent, theory_scoped, \+ bad_implication(root, atom(p), or(atom(p), atom(q)))).
obligation(absent, theory_scoped, \+ bad_implication(root, neg(or(atom(p), atom(q))), bottom)).
obligation(absent, theory_scoped, \+ forces(root, or(atom(p), atom(q)))).
obligation(absent, theory_scoped, \+ forces(root, or(atom(p), neg(atom(p))))).
steps(19).
verified(15).
recomputed(0).
composed(0).
trusted(4).
claims(5).
verdict(checked_with_obligations).
