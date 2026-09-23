status(blocks_world, planned).
plan(blocks_world, [move(e, d, table), move(d, c, table), move(c, b, table), move(d, table, c), move(e, table, d)]).
finalState(blocks_world, [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)]).
blockCount(blocks_world, 5).
