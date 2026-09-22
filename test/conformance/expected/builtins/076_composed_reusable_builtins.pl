% Prolog result format 4
query(1, answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 5).
answer(1, ['X0' = clean_join, 'X1' = 'red|green|blue']).
answer(1, ['X0' = middle_upper, 'X1' = 'GREEN']).
answer(1, ['X0' = summary, 'X1' = result(red, blue, 3)]).
answer(1, ['X0' = term_report, 'X1' = 'measurement(temperature, 21)']).
answer(1, ['X0' = score_text, 'X1' = 'max=9']).
