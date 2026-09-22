io_marker
% Prolog result format 4
query(1,
      text_roundtrip(_0, _1, _2, _3, _4),
      ['Term' = _0, 'Peek' = _1, 'Code' = _2, 'Mode' = _3, 'Alias' = _4]).
result(1, complete, 1).
answer(1,
       ['Term' = sample(42), 'Peek' = ' ', 'Code' = 32, 'Mode' = read, 'Alias' = iso_text_input]).
query(2, binary_roundtrip(_0, _1, _2), ['Peek' = _0, 'Byte' = _1, 'End' = _2]).
result(2, complete, 1).
answer(2, ['Peek' = 65, 'Byte' = 65, 'End' = -1]).
query(3, read_term_metadata(ok), []).
result(3, complete, 1).
answer(3, []).
query(4, default_streams(ok), []).
result(4, complete, 1).
answer(4, []).
query(5, standard_write(ok), []).
result(5, complete, 1).
answer(5, []).
query(6, numeric_escape_term_input(ok), []).
result(6, complete, 1).
answer(6, []).
query(7, malformed_quoted_term_input(ok), []).
result(7, complete, 1).
answer(7, []).
