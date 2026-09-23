% Corrigendum 2: | may be an infix operator at priority 1001 or greater.
:- op(1105, xfy, '|').

bar_term((a | b)).

%% ?- corrigenda_bar_operator(ok).

corrigenda_bar_operator(ok) :-
    bar_term('|'(a, b)),
    current_op(1105, xfy, '|').
