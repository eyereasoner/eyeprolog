% Prolog result format 4
query(1, answer(_0, _1), ['X' = _0, 'Term' = _1]).
result(1, complete, 2).
answer(1, ['X' = member, 'Term' = name(alice, "Alice")]).
answer(1, ['X' = member, 'Term' = knows(alice, bob)]).
