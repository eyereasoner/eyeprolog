% Adapted from Trealla Prolog tests/tests/test0064.pl.
% See test/conformance/THIRD_PARTY.md.
:- dynamic(p/2).
:- dynamic(p/3).

p(Z, Z).
clouds(are, nice).
p(Z, h(Z, W), f(W)).

%% goal: fact_unifies_leaving_variable_unbound(ok)

fact_unifies_leaving_variable_unbound(ok) :-
    findall(Z, p(Z, Z), [Z]),
    var(Z).

%% goal: distinct_arguments_reject(ok)

distinct_arguments_reject(ok) :-
    \+ p(z, w).

%% goal: repeated_argument_accepts(ok)

repeated_argument_accepts(ok) :-
    p(w, w).

%% goal: distinct_fact_arguments_reject(ok)

distinct_fact_arguments_reject(ok) :-
    \+ clouds(Z, Z).

%% goal: fact_second_argument(X0)

fact_second_argument(Zs) :-
    findall(Z, clouds(are, Z), Zs).

%% goal: nested_pattern_rejects_conflict(ok)

nested_pattern_rejects_conflict(ok) :-
    \+ p(z, h(z, z), f(w)).

%% goal: nested_pattern_accepts(ok)

nested_pattern_accepts(ok) :-
    p(z, h(z, w), f(w)).

%% goal: nested_shared_variable_binds_consistently(X0)

nested_shared_variable_binds_consistently(Ws) :-
    findall(W, p(z, h(z, W), f(w)), Ws).

%% goal: nested_shared_variable_all_positions(X0)

nested_shared_variable_all_positions(Zs) :-
    findall(Z, p(Z, h(Z, w), f(Z)), Zs).

%% goal: retract_reassert_roundtrip(ok)

retract_reassert_roundtrip(ok) :-
    retract(p(_, _, _)),
    assertz(p(Z, h(Z, W), f(W))),
    p(f(f(a)), h(f(f(a)), f(a)), f(f(a))),
    retract(p(Z, h(Z, W), f(W))),
    \+ clause(p(_, _, _), true).
