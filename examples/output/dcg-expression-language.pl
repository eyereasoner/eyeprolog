% Prolog result format 4
query(1, dcg_expression_example(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 5).
answer(1, ['X0' = parsed, 'X1' = add(lit(2), mul(lit(3), sub(lit(4), lit(1))))]).
answer(1, ['X0' = evaluated, 'X1' = 19]).
answer(1, ['X0' = round_trip, 'X1' = [20, -, '(', 5, -, 3, ')']]).
answer(1, ['X0' = remainder, 'X1' = [then, stop]]).
answer(1, ['X0' = rejected, 'X1' = malformed_parentheses]).
