% Prolog result format 4
query(1, stable_marriage_answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 2).
answer(1,
       ['X0' = first_stable_matching,
        'X1' = [pair(adam, bea), pair(brian, dana), pair(cole, amy), pair(drew, cora)]]).
answer(1, ['X0' = stable_matching_count, 'X1' = 1]).
