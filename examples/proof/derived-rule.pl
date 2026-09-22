% Prolog result format 4
query(1, type(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 0).
query(2, log_implies(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = type(var(y), dog), 'X1' = holds_result(test, true)]).
why(2,
    ['X0' = type(var(y), dog), 'X1' = holds_result(test, true)],
    [log_implies(type(var(y), dog), holds_result(test, true))]).
query(3, holds_result(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = test, 'X1' = true]).
why(3, ['X0' = test, 'X1' = true], [holds_result(test, true)]).

clause(1, type(minka, cat), true).
clause(2, type(charly, dog), true).
clause(3, log_implies(type(var(y), dog), holds_result(test, true)), type(anonymous(1), cat)).
clause(4,
       holds_result(test, true),
       (log_implies(type(var(y), dog), holds_result(test, true)), type(anonymous(1), dog))).

step(log_implies(type(var(y), dog), holds_result(test, true)), rule(3), [], [type(minka, cat)]).
step(type(minka, cat), fact(1), [], []).
step(holds_result(test, true),
     rule(4),
     [],
     [log_implies(type(var(y), dog), holds_result(test, true)), type(charly, dog)]).
step(type(charly, dog), fact(2), [], []).
