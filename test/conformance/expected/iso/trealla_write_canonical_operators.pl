plus(1,2)
1 plus 2
% Prolog result format 4
query(1,
      operator_terms_vs_precedence(_0, _1, _2, _3),
      ['X0' = _0, 'X1' = _1, 'X2' = _2, 'X3' = _3]).
result(1, complete, 1).
answer(1, ['X0' = 1 plus 2, 'X1' = (1 + 2) * 3, 'X2' = 1 * (2 + 3), 'X3' = - (-) - (-)]).
query(2, canonical_ignores_custom_operator(ok), []).
result(2, complete, 1).
answer(2, []).
query(3, dot_functor_is_list_notation(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(3, complete, 1).
answer(3, ['X0' = "a", 'X1' = "a", 'X2' = "a"]).
