% Prolog result format 4
query(1, plan(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 4).
answer(1, ['X0' = monkeyBananas, 'X1' = [go(loc3), push(loc1), climb_on, grab]]).
answer(1, ['X0' = monkeyBananas, 'X1' = [go(loc1), go(loc3), push(loc1), climb_on, grab]]).
answer(1, ['X0' = monkeyBananas, 'X1' = [go(loc3), push(loc1), climb_on, grab, climb_off]]).
answer(1, ['X0' = monkeyBananas, 'X1' = [go(loc3), push(loc2), push(loc1), climb_on, grab]]).
query(2, solved(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = monkeyBananas, 'X1' = true]).
