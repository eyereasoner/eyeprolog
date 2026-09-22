% Prolog result format 4
query(1, absState(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(1, complete, 14).
answer(1, ['X0' = input, 'X1' = x, 'X2' = sign(neg)]).
answer(1, ['X0' = input, 'X1' = x, 'X2' = sign(zero)]).
answer(1, ['X0' = input, 'X1' = x, 'X2' = sign(pos)]).
answer(1, ['X0' = negative_branch, 'X1' = x, 'X2' = sign(neg)]).
answer(1, ['X0' = nonnegative_branch, 'X1' = x, 'X2' = sign(zero)]).
answer(1, ['X0' = nonnegative_branch, 'X1' = x, 'X2' = sign(pos)]).
answer(1, ['X0' = negative_branch, 'X1' = y, 'X2' = sign(pos)]).
answer(1, ['X0' = nonnegative_branch, 'X1' = y, 'X2' = sign(zero)]).
answer(1, ['X0' = nonnegative_branch, 'X1' = y, 'X2' = sign(pos)]).
answer(1, ['X0' = join, 'X1' = x, 'X2' = sign(neg)]).
answer(1, ['X0' = join, 'X1' = y, 'X2' = sign(pos)]).
answer(1, ['X0' = join, 'X1' = x, 'X2' = sign(zero)]).
answer(1, ['X0' = join, 'X1' = x, 'X2' = sign(pos)]).
answer(1, ['X0' = join, 'X1' = y, 'X2' = sign(zero)]).
query(2, absWarning(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = division_by_zero, 'X1' = join]).
query(3, absConclusion(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3,
       ['X0' = case,
        'X1' = "abstract interpretation keeps all feasible signs and warns because y may be zero"]).
