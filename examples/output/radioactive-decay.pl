% Prolog result format 4
query(1, halfLivesElapsed(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = iodine_sample, 'X1' = 2.0]).
query(2, remainingActivity_Bq(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = iodine_sample, 'X1' = 20.0]).
query(3, decayedActivity_Bq(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = iodine_sample, 'X1' = 60.0]).
query(4, status(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4, ['X0' = iodine_sample, 'X1' = low_activity]).
query(5, reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(5, complete, 1).
answer(5,
       ['X0' = iodine_sample, 'X1' = "two half-lives leave one quarter of the initial activity"]).
