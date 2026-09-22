% Prolog result format 4
query(1, status(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = blocks_world, 'X1' = planned]).
query(2, plan(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2,
       ['X0' = blocks_world,
        'X1' = [move(e, d, table), move(d, c, table), move(c, b, table), move(d, table, c), move(e, table, d)]]).
query(3, finalState(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3,
       ['X0' = blocks_world, 'X1' = [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)]]).
query(4, blockCount(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4, ['X0' = blocks_world, 'X1' = 5]).
