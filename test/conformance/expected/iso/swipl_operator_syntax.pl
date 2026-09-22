% Prolog result format 4
query(1, swipl_standard_plus(_0, _1), ['Priority' = _0, 'Specifier' = _1]).
result(1, complete, 2).
answer(1, ['Priority' = 500, 'Specifier' = yfx]).
answer(1, ['Priority' = 200, 'Specifier' = fy]).
query(2, swipl_operator_syntax(_0, _1, _2), ['A' = _0, 'B' = _1, 'C' = _2]).
result(2, complete, 1).
answer(2, ['A' = xf100 xf200, 'B' = fx100 1 xf200, 'C' = (p, q yf100 xfy900 c)]).
