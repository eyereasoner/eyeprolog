% A procedure defined by a Prolog text is static, and therefore private, unless
% a dynamic/1 directive makes it public (ISO 7.5.2, 8.9). clause/2 may only
% inspect a public procedure (ISO 8.8.1.3), so reading a static user procedure
% is a permission error rather than a source of solutions.
% https://github.com/eyereasoner/eyeprolog/issues/96
%% ?- answer.

elk(X) :- moose(X).

moose(bertha).

answer :-
    clause(elk(N), Body).
