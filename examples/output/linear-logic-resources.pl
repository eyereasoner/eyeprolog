% Prolog result format 4
query(1, linear_result(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(1, complete, 1).
answer(1, ['X0' = kitchen, 'X1' = [mill, mix, bake], 'X2' = [bread]]).
query(2, linear_check(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = double_spend_rejected, 'X1' = yes]).
