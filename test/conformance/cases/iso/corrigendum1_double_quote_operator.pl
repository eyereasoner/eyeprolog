% Corrigendum 1: a double-quoted atom has operator priority when applicable.
:- op(500, xfy, likes).
:- set_prolog_flag(double_quotes, atom).

%% ?- corrigendum1_double_quote_operator(ok).

corrigendum1_double_quote_operator(ok) :-
    (alice "likes" bob) = likes(alice, bob),
    "+"(1, 2) = +(1, 2).
