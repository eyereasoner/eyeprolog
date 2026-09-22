% Prolog result format 4
query(1, dcg_vocab:answer(_0), ['X' = _0]).
result(1, complete, 1).
answer(1, ['X' = hello]).
query(2, phrase(dcg_vocab:word(hello), [hello]), []).
result(2, complete, 1).
answer(2, []).
