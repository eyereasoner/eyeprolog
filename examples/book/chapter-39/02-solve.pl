% From The Art of EyeProlog, Chapter 39.
:- set_prolog_flag(default_procedure_access, public).

solve(true) :- !.
solve((A, B)) :- !, solve(A), solve(B).
solve(H) :- clause(H, Body), solve(Body).

elk(X) :- moose(X).
moose(bertha).
grazes(X) :- elk(X).
