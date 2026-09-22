% Prolog result format 4
query(1, directive_state(_0, _1), ['Value' = _0, 'Debug' = _1]).
result(1, complete, 1).
answer(1, ['Value' = initialized, 'Debug' = on]).
query(2, character_conversion(_0, _1, _2), ['Term' = _0, 'From' = _1, 'To' = _2]).
result(2, complete, 1).
answer(2, ['Term' = a, 'From' = &, 'To' = a]).
query(3, remove_conversion(ok), []).
result(3, complete, 1).
answer(3, []).
