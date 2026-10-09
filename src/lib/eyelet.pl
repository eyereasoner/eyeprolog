% Forward reasoning for EyeProlog.
%
% The fixed-point driver lives here in Prolog. JavaScript only bootstraps this
% module and adapts the recorded answer/fuse events to the embedding callbacks.

:- module(eyelet, [
    op(1200, xfx, :+),
    stable/1,
    becomes/2
]).

:- use_module(library(iso_ext), [variant/2]).

:- meta_predicate(becomes(0, 0)).

:- dynamic(eyelet_reported/1).
:- dynamic(eyelet_changed/0).
:- dynamic(eyelet_fused/0).
:- dynamic(eyelet_derived/1).

% eyelet_run(-Rounds, -Derived, -Status)
% Run the user module's :+/2 rules to a fixed point. Status is ok or fuse.
% Answer/fuse terms are emitted through a tiny host callback adapter.
eyelet_run(Rounds, Derived, Status) :-
    eyelet_setup,
    (   plain_query_program
    ->  run_plain_queries,
        Rounds = 1
    ;   eyelet_loop(0, Rounds)
    ),
    ( eyelet_fused -> Status = fuse ; Status = ok ),
    eyelet_derived(Derived).

% Preparation is structural: inspect clauses instead of executing their bodies.
% dynify/1 also makes existing user predicates mutable, which is required by
% conclusions and becomes/2, while leaving imported and builtin predicates alone.
eyelet_setup :-
    retractall(eyelet_reported(_)),
    retractall(eyelet_changed),
    retractall(eyelet_fused),
    retractall(eyelet_derived(_)),
    assertz(eyelet_derived(0)),
    user:eyeprolog__dynify((:+)/2),
    user:eyeprolog__dynify(closure/1),
    user:eyeprolog__dynify(limit/1),
    user:retractall(closure(_)),
    user:retractall(limit(_)),
    user:assertz(closure(0)),
    user:assertz(limit(-1)),
    prepare_rules.

prepare_rules :-
    (   user:clause((Conc :+ Prem), Body),
        dynify_goal(Conc),
        dynify_goal(Prem),
        dynify_goal(Body),
        fail
    ;   true
    ).

% Query-only forward-rule files are common. Detect them from clause heads and execute
% their premises once instead of entering the fixed-point loop.
plain_query_program :-
    \+ ( user:clause((Conc :+ _), _), Conc \== true, Conc \== false ).

run_plain_queries :-
    (   user:(Conc :+ Prem),
        user:Prem,
        process_control_conclusion(Conc, Prem, 1),
        ( eyelet_fused -> ! ; fail )
    ;   true
    ).

% Iterate until a round adds no new conclusion. stable/1 can request additional
% closure levels; each requested level advances only after a quiescent round.
eyelet_loop(Round0, Round) :-
    Round1 is Round0 + 1,
    retractall(eyelet_changed),
    run_round(Round1),
    (   eyelet_fused
    ->  Round = Round1
    ;   eyelet_changed
    ->  eyelet_loop(Round1, Round)
    ;   advance_closure
    ->  eyelet_loop(Round1, Round)
    ;   Round = Round1
    ).

run_round(Round) :-
    (   user:(Conc :+ Prem),
        user:Prem,
        process_conclusion(Conc, Prem, Round),
        ( eyelet_fused -> ! ; fail )
    ;   true
    ).

process_conclusion(Conc, Prem, Round) :-
    (   Conc == true
    ->  report_answer(Prem)
    ;   Conc == false
    ->  report_fuse(Prem),
        mark_fused
    ;   prepare_conclusion(Conc, Prepared),
        assert_conj(Prepared)
    ).

process_control_conclusion(Conc, Prem, _) :-
    (   Conc == true
    ->  report_answer(Prem)
    ;   Conc == false
    ->  report_fuse(Prem),
        mark_fused
    ;   true
    ).

report_answer(Prem) :-
    (   already_reported(Prem)
    ->  true
    ;   copy_term(Prem, Copy),
        assertz(eyelet_reported(Copy)),
        user:eyeprolog__eyelet_emit(answer, Prem)
    ).

% Ground answers use the dynamic predicate's ground index. Only residual-variable
% answers need the more expensive variant scan.
already_reported(Prem) :-
    term_variables(Prem, Vars),
    (   Vars == []
    ->  eyelet_reported(Prem)
    ;   eyelet_reported(Seen),
        variant(Prem, Seen)
    ),
    !.

report_fuse(Prem) :-
    user:eyeprolog__eyelet_emit(fuse, Prem).

mark_fused :-
    ( eyelet_fused -> true ; assertz(eyelet_fused) ).

prepare_conclusion(Conc, Conc) :-
    is_forward_rule(Conc),
    !.
prepare_conclusion(Conc, Conc) :-
    skolemize(Conc, 0, _).

is_forward_rule(Term) :-
    nonvar(Term),
    Term = (_ :+ _).

% Assert each new conjunct. Ordinary conclusions are considered already known
% when they are provable; a derived :+/2 rule is considered known only when an
% identical fact-clause already exists, so guarded source rules are not confused
% with a newly derived unconditional rule.
assert_conj(true) :- !.
assert_conj(false) :- !.
assert_conj((A, B)) :-
    !,
    assert_conj(A),
    assert_conj(B).
assert_conj(Goal) :-
    dynify_goal(Goal),
    (   known_conclusion(Goal)
    ->  true
    ;   user:assertz(Goal),
        mark_changed
    ).

known_conclusion(Goal) :-
    is_forward_rule(Goal),
    !,
    user:clause(Goal, true).
known_conclusion(Goal) :-
    user:Goal.

mark_changed :-
    ( eyelet_changed -> true ; assertz(eyelet_changed) ),
    retract(eyelet_derived(N)),
    N1 is N + 1,
    assertz(eyelet_derived(N1)).

advance_closure :-
    user:closure(Closure),
    user:limit(Limit),
    Closure < Limit,
    NewClosure is Closure + 1,
    user:retract(closure(Closure)),
    user:assertz(closure(NewClosure)).

% skolemize(+Term, +N0, -N)
% Replace remaining conclusion variables with sk_0, sk_1, ... . Derived :+/2
% rules skip this step so their variables remain universally quantified.
skolemize(Term, N0, N) :-
    term_variables(Term, Vars),
    skolemize_vars(Vars, N0, N).

skolemize_vars([], N, N).
skolemize_vars([Sk|Vars], N0, N) :-
    number_chars(N0, Digits),
    atom_chars(Number, Digits),
    atom_concat(sk_, Number, Sk),
    N1 is N0 + 1,
    skolemize_vars(Vars, N1, N).

% stable(+Level)
% Fail until the requested closure level has been reached. Asking for a higher
% level raises the target; the driver advances it only at a quiescent round.
stable(Level) :-
    user:limit(Limit),
    (   Limit < Level
    ->  user:retract(limit(Limit)),
        user:assertz(limit(Level))
    ;   true
    ),
    user:closure(Closure),
    Level =< Closure.

% becomes(:From, :To)
% Linear implication over dynamic state. dynify/1 first makes existing source
% predicates mutable, so callers no longer need a separate dynamic/1 directive.
becomes(From, To) :-
    dynify_goal(From),
    dynify_goal(To),
    catch(user:From, _, fail),
    conj_list(From, Old),
    retract_conj(Old),
    conj_list(To, New),
    assert_conj_list(New).

retract_conj([]).
retract_conj([Clause|Clauses]) :-
    user:retract(Clause),
    retract_conj(Clauses).

assert_conj_list([]).
assert_conj_list([Clause|Clauses]) :-
    user:assertz(Clause),
    assert_conj_list(Clauses).

% Flatten conjunctions in either association direction without append/3.
conj_list(Goal, List) :-
    conj_list(Goal, List, []).

conj_list(true, Tail, Tail) :- !.
conj_list(false, _, _) :- !, fail.
conj_list((A, B), List, Tail) :-
    !,
    conj_list(A, List, Rest),
    conj_list(B, Rest, Tail).
conj_list(Goal, [Goal|Tail], Tail).

% Prepare a callable goal and recursively inspect compound arguments. Atomic
% arguments are data, but an atom in callable position denotes a 0-arity
% predicate and therefore needs an empty dynamic procedure when it is unknown.
dynify_goal(Term) :-
    var(Term),
    !.
dynify_goal(Term) :-
    atom(Term),
    !,
    user:eyeprolog__dynify(Term/0).
dynify_goal(Term) :-
    atomic(Term),
    !.
dynify_goal(Term) :-
    dynify_term(Term).

% Recursively prepare callable shapes embedded in compound arguments. The
% private host primitive only mutates direct user procedures; imports, builtins,
% and control constructs are left untouched.
dynify_term(Term) :-
    var(Term),
    !.
dynify_term(Term) :-
    atomic(Term),
    !.
dynify_term([]) :-
    !.
dynify_term([Head|Tail]) :-
    !,
    dynify_term(Head),
    dynify_term(Tail).
dynify_term(Term) :-
    functor(Term, Name, Arity),
    user:eyeprolog__dynify(Name/Arity),
    Term =.. [_|Args],
    dynify_list(Args).

dynify_list([]).
dynify_list([Term|Terms]) :-
    dynify_term(Term),
    dynify_list(Terms).
