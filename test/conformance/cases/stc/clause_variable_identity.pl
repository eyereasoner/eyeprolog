% STC #37: clause/2 must preserve sharing between variables in head and body.
% https://www.complang.tuwien.ac.at/ulrich/iso-prolog/stc#37
%% ?- clause_variable_identity.

% clause/2 may only inspect a public procedure, so a/1 is declared dynamic.
:- dynamic(a/1).
a(X) :- b(X).

clause_variable_identity :-
  clause(a(A), b(B)),
  A == B.
