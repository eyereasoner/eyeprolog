% Prolog result format 4
query(1, log_nameOf(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 0).
query(2, dataGraph(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = association, 'X1' = skolem_g0]).
query(3, signatureGraph(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = association, 'X1' = skolem_g1]).
query(4, metadataGraph(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4, ['X0' = association, 'X1' = g3]).
