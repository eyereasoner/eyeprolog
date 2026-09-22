% Prolog result format 4
query(1, chart_parser_answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 6).
answer(1, ['X0' = parsed, 'X1' = command]).
answer(1, ['X0' = parsed, 'X1' = ambiguous_pp]).
answer(1, ['X0' = parse_count, 'X1' = count(command, 1)]).
answer(1, ['X0' = parse_count, 'X1' = count(ambiguous_pp, 1)]).
answer(1, ['X0' = noun_phrase_count, 'X1' = count(command, 2)]).
answer(1, ['X0' = noun_phrase_count, 'X1' = count(ambiguous_pp, 4)]).
