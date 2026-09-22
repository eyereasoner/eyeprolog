% Prolog result format 4
query(1, committed_answer(_0), ['X0' = _0]).
result(1, complete, 1).
answer(1, ['X0' = first]).
query(2, left_answer(_0), ['X0' = _0]).
result(2, complete, 1).
answer(2, ['X0' = a]).
query(3, right_answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 2).
answer(3, ['X0' = a, 'X1' = a]).
answer(3, ['X0' = a, 'X1' = b]).
query(4, cut_failure_answer, []).
result(4, complete, 1).
answer(4, []).
query(5, disjunction_answer(_0), ['X0' = _0]).
result(5, complete, 1).
answer(5, ['X0' = a]).
query(6, call_local_answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(6, complete, 1).
answer(6, ['X0' = fallback, 'X1' = ok]).
query(7, if_then_answer(_0), ['X0' = _0]).
result(7, complete, 2).
answer(7, ['X0' = a]).
answer(7, ['X0' = b]).
query(8, callee_cut_disjunction_answer, []).
result(8, complete, 1).
answer(8, []).
query(9, between_disjunction_answer, []).
result(9, complete, 1).
answer(9, []).
