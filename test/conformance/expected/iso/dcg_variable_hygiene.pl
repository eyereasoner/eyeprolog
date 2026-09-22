% Prolog result format 4
query(1,
      phrase(capture_states(_0, _1, _2, _3), [left, right]),
      ['A' = _0, 'B' = _1, 'Input' = _2, 'Output' = _3]).
result(1, complete, 1).
answer(1, ['A' = left, 'B' = right, 'Input' = source_input, 'Output' = source_output]).
query(2, phrase(anonymous_pair, [one, two]), []).
result(2, complete, 1).
answer(2, []).
