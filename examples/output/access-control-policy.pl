% Prolog result format 4
query(1, policy(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 0).
query(2, status(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = test1, 'X1' = policy_passed]).
query(3, reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3,
       ['X0' = test1,
        'X1' = "all required claims are present, one allowed claim is present, and no forbidden claim is present"]).
