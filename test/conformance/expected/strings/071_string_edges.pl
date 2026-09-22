% Prolog result format 4
query(1, answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 8).
answer(1, ['X0' = split_missing_separator, 'X1' = [abc]]).
answer(1, ['X0' = split_empty_separator, 'X1' = "abc"]).
answer(1, ['X0' = join_empty, 'X1' = '']).
answer(1, ['X0' = join_numbers, 'X1' = '1-2-3']).
answer(1, ['X0' = substring_empty, 'X1' = '']).
answer(1, ['X0' = replace_empty_search, 'X1' = abc]).
answer(1, ['X0' = lower_string, 'X1' = hello]).
answer(1, ['X0' = upper_string, 'X1' = 'EYEPROLOG 123']).
