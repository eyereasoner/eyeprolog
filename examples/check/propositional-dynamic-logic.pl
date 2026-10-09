condition('C1', resolution, ok, 8).
condition('C2', well_founded, ok, 18).
condition('C3', justification, ok, 18).
condition('C4', coverage, ok, 23).
condition('C5', re_decision, ok, 3).
condition('C6', boundary_consistency, ok, 0).
condition('C7', relevance, ok, 19).
obligation(builtin, theory_scoped, call(diamond(seq(unlock, seq(open_door, walk_to_garden)), at(garden), [at(hall), door(locked)]))).
obligation(absent, theory_scoped, \+ run(open_door, [at(hall), door(locked)], A)).
obligation(builtin, theory_scoped, call(box(open_door, at(garden), [at(hall), door(locked)]))).
obligation(builtin, theory_scoped, call(box(walk_to_garden, at(garden), [at(hall), door(open)]))).
obligation(builtin, theory_scoped, call(diamond(choice(walk_to_garden, wait), at(garden), [at(hall), door(open)]))).
obligation(builtin, theory_scoped, call(diamond(star(wait), at(hall), [at(hall), door(locked)]))).
obligation(builtin, theory_scoped, call(diamond(seq(test(door(open)), walk_to_garden), at(garden), [at(hall), door(open)]))).
steps(18).
verified(8).
recomputed(3).
composed(0).
trusted(7).
claims(1).
verdict(checked_with_obligations).
