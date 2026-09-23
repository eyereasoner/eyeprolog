% Corrigendum 2: subsumes_term/2, callable/1, ground/1, and acyclic_term/1.
%% ?- corrigenda_term_predicates(ok).

corrigenda_term_predicates(ok) :-
    subsumes_term(f(X, Y), f(Z, Z)),
    \+ subsumes_term(f(Z, Z), f(X, Y)),
    \+ subsumes_term(X, f(X)),
    callable((a, b)),
    ground(f(a, 1)),
    \+ ground(f(a, _)),
    acyclic_term(f(_)).
