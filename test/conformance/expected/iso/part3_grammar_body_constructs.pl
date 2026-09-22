% Prolog result format 4
query(1, answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 13).
answer(1, ['X0' = empty_sequence, 'X1' = "ab"]).
answer(1, ['X0' = concatenation, 'X1' = "c"]).
answer(1, ['X0' = alternative, 'X1' = "c"]).
answer(1, ['X0' = ite_13, 'X1' = yes]).
answer(1, ['X0' = ite_23, 'X1' = yes]).
answer(1, ['X0' = ite_4, 'X1' = yes]).
answer(1, ['X0' = ite_single, 'X1' = no]).
answer(1, ['X0' = grammar_body_goal, 'X1' = "a"]).
answer(1, ['X0' = phrase_nonterminal, 'X1' = "b"]).
answer(1, ['X0' = cut_identity, 'X1' = "ab"]).
answer(1, ['X0' = negation_identity, 'X1' = "bc"]).
answer(1, ['X0' = negation_blocks, 'X1' = no]).
answer(1, ['X0' = terminal_split, 'X1' = b]).
