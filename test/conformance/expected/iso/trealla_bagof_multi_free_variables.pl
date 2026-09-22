% Prolog result format 4
query(1, bagof_grouped_by_two_free_variables(_0), ['X0' = _0]).
result(1, complete, 3).
answer(1, ['X0' = [cc, dd]]).
answer(1, ['X0' = [ee, ff]]).
answer(1, ['X0' = [gg]]).
query(2, bagof_two_free_variables_quantified(_0), ['X0' = _0]).
result(2, complete, 1).
answer(2, ['X0' = [cc, dd, ee, ff, gg, gg]]).
query(3, setof_two_free_variables_quantified(_0), ['X0' = _0]).
result(3, complete, 1).
answer(3, ['X0' = [cc, dd, ee, ff, gg]]).
