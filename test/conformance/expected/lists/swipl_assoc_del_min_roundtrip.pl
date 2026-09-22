% Prolog result format 4
query(1, assoc_del_min_roundtrip(_0), ['X0' = _0]).
result(1, complete, 1).
answer(1,
       ['X0' = [1 - a, 2 - b, 3 - c, 4 - d, 5 - e, 6 - f, 7 - g, 8 - h, 9 - i, 10 - j, 11 - k]]).
query(2, assoc_del_min_empty_fails(ok), []).
result(2, complete, 1).
answer(2, []).
query(3, assoc_del_min_no_member_fails(ok), []).
result(3, complete, 1).
answer(3, []).
