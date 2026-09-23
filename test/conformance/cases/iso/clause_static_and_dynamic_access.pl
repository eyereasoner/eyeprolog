% Procedures defined by a Prolog text are static unless a dynamic/1 directive
% makes them public. clause/2 inspects public procedures and raises a
% permission error for static ones, in every execution mode.
% https://github.com/eyereasoner/eyeprolog/issues/96

:- dynamic(elk/1).
elk(X) :- moose(X).

moose(bertha).

%% ?- public_clause(X0).

public_clause(Body) :-
    clause(elk(bertha), Body).

%% ?- private_clause(X0).

private_clause(Culprit) :-
    catch(clause(moose(_), _), error(Formal, _), true),
    Formal = permission_error(access, private_procedure, Culprit).

%% ?- asserted_clause(X0).

asserted_clause(Body) :-
    assertz(caribou(rudolf)),
    clause(caribou(_), Body).
