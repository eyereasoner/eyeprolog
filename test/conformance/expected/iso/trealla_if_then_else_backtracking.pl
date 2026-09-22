% Prolog result format 4
query(1, then_branch_backtracks(_0), ['X0' = _0]).
result(1, complete, 2).
answer(1, ['X0' = a]).
answer(1, ['X0' = b]).
query(2, else_branch_backtracks(_0), ['X0' = _0]).
result(2, complete, 2).
answer(2, ['X0' = a]).
answer(2, ['X0' = b]).
query(3, cond_commits_to_first_solution(_0), ['X0' = _0]).
result(3, complete, 1).
answer(3, ['X0' = 1]).
