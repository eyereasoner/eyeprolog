% Prolog result format 4
query(1, dcg_chain:answer(_0), ['Tokens' = _0]).
result(1, complete, 1).
answer(1, ['Tokens' = "x"]).
query(2, phrase(dcg_chain:wrapper, _0), ['Tokens' = _0]).
result(2, complete, 1).
answer(2, ['Tokens' = "x"]).
