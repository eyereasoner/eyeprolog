cdclAnswer(conflict_clause, c2).
cdclAnswer(learned_clause, [neg(a)]).
cdclAnswer(learned_from, resolve(c2, c1, pivot(c))).
cdclAnswer(final_value(a), false).
cdclAnswer(final_value(c), false).
cdclAnswer(final_value(b), true).
cdclAnswer(note, "one learned clause makes the final model satisfy all original clauses").
