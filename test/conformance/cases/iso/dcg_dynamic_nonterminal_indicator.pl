% dynamic/1 accepts Part 3 nonterminal indicators and maps them to arity + 2.
:- dynamic(token//1).

%% ?- dynamic_nonterminal(X0).
dynamic_nonterminal(asserted) :-
    assertz(token(x, [x], [])),
    phrase(token(x), [x]).
