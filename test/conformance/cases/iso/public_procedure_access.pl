% ISO 7.5.3 notes that "an additional directive public/1 that specifies some
% user-defined procedures to be public would be an extension". EyeProlog
% provides that directive, plus a default_procedure_access flag that grants
% clause/2 access to every user-defined procedure at once, which a
% meta-interpreter needs without annotating the program it interprets.
%
% Both are read access only. A public procedure is still static, so assert/1
% and retract/1 continue to report permission_error(modify, static_procedure),
% and built-in procedures stay private either way.
% https://github.com/eyereasoner/eyeprolog/issues/96

:- public(elk/1).
elk(X) :- moose(X).

moose(bertha).

%% goal: declared_public(X0)

declared_public(Body) :-
    clause(elk(bertha), Body).

%% goal: undeclared_sibling(X0)

% moose/1 carries no declaration, so it stays private.
undeclared_sibling(Culprit) :-
    catch(clause(moose(_), _), error(Formal, _), true),
    Formal = permission_error(access, private_procedure, Culprit).

%% goal: public_is_not_dynamic(X0)

public_is_not_dynamic(Formal) :-
    catch(assertz(elk(clara)), error(Formal, _), true).

%% goal: flag_default(X0)

flag_default(Access) :-
    current_prolog_flag(default_procedure_access, Access).

%% goal: flag_opens_every_procedure(X0)

flag_opens_every_procedure(Body) :-
    set_prolog_flag(default_procedure_access, public),
    clause(moose(bertha), Body),
    set_prolog_flag(default_procedure_access, private).

%% goal: builtins_stay_private(X0)

builtins_stay_private(Culprit) :-
    set_prolog_flag(default_procedure_access, public),
    catch(clause(atom(_), _), error(Formal, _), true),
    set_prolog_flag(default_procedure_access, private),
    Formal = permission_error(access, private_procedure, Culprit).
