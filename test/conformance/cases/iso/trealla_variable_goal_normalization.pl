% Adapted from Trealla Prolog tests/tests/test0075.pl.
% See test/conformance/THIRD_PARTY.md.
:- dynamic(legs/2).
legs(A, 7) :- A, call(A).

%% goal: variable_goal_normalized_in_clause_body(ok)

variable_goal_normalized_in_clause_body(ok) :-
    clause(legs(_, 7), Body),
    Body = (call(C), call(D)),
    C == D.
