% Part 3 installs the grammar-rule and alternative operators.
%% ?- dcg_operator(X0, X1, X2).

dcg_operator('-->', 1200, xfx) :- current_op(1200, xfx, '-->').
dcg_operator('|', 1105, xfy) :- current_op(1105, xfy, '|').
