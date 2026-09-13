% Propositional Dynamic Logic (PDL) via a pure state-threading
% meta-interpreter: no assert/retract anywhere. A "state" is just a list of
% the propositions currently true, passed as an ordinary argument -- the
% "world" is data, not a mutated database, so every step stays inspectable
% through why/2.
%
% PDL's program (action) combinators translate directly onto Prolog's own
% control constructs:
%   - sequential composition  A;B   ->  conjunction: run(A,S0,S1), run(B,S1,S2)
%   - non-deterministic choice A|B  ->  disjunction: two run/3 clauses
%   - iteration (Kleene star)  A*   ->  a recursive run/3 clause
%   - test                    Phi? ->  holds(Phi, S) without changing S
% and its two modalities read off run/3 directly:
%   - <Program>Phi  ("some run of Program reaches a state where Phi holds")
%     is run/3 succeeding at least once with Phi true afterward: diamond/3.
%   - [Program]Phi  ("every run of Program reaches a state where Phi holds")
%     is the negation of "some run reaches a state where Phi fails": box/3.
% A classical, easy-to-miss subtlety falls out for free: when a program has
% *no* run at all from a state, [Program]Phi is vacuously true there (the
% same reason "every element of the empty set is purple" is true) -- see
% vacuous_box_holds below.
:- use_module(library(lists)).

transition(unlock, S0, S1) :-
    member(door(locked), S0),
    select(door(locked), S0, Rest),
    S1 = [door(unlocked) | Rest].
transition(open_door, S0, S1) :-
    member(door(unlocked), S0),
    select(door(unlocked), S0, Rest),
    S1 = [door(open) | Rest].
transition(walk_to_garden, S0, S1) :-
    member(at(hall), S0),
    member(door(open), S0),
    select(at(hall), S0, Rest),
    S1 = [at(garden) | Rest].
transition(wait, S, S).

run(Action, S0, S1) :-
    atomic(Action), !,
    transition(Action, S0, S1).
run(seq(A, B), S0, S2) :-
    run(A, S0, S1),
    run(B, S1, S2).
run(choice(A, _), S0, S1) :- run(A, S0, S1).
run(choice(_, B), S0, S1) :- run(B, S0, S1).
run(star(_), S, S).
run(star(A), S0, S2) :-
    run(A, S0, S1),
    run(star(A), S1, S2).
run(test(Formula), S, S) :- holds(Formula, S).

holds(and(A, B), S) :- !, holds(A, S), holds(B, S).
holds(not(A), S) :- !, \+ holds(A, S).
holds(Prop, S) :- member(Prop, S).

diamond(Program, Formula, S0) :- run(Program, S0, S1), holds(Formula, S1).
box(Program, Formula, S0) :- \+ (run(Program, S0, S1), \+ holds(Formula, S1)).

%% goal: answer(X0, X1, X2, X3, X4, X5, X6)

answer(FullPathReachesGarden, VacuousBoxHolds, GenuineBoxHolds,
       ChoiceBoxFails, ChoiceDiamondHolds, StarPreservesLocation, TestGuardedPathWorks) :-
    Locked = [at(hall), door(locked)],
    Open = [at(hall), door(open)],

    % <unlock ; open_door ; walk_to_garden> at(garden), starting locked:
    % there IS a way to reach the garden.
    boolean(diamond(seq(unlock, seq(open_door, walk_to_garden)), at(garden), Locked),
            FullPathReachesGarden),

    % [open_door] at(garden), starting locked: open_door has NO transition
    % at all from a locked door, so this is vacuously true -- not because
    % opening a locked door somehow reaches the garden, but because there is
    % no run to falsify the claim against.
    \+ run(open_door, Locked, _),
    boolean(box(open_door, at(garden), Locked), VacuousBoxHolds),

    % [walk_to_garden] at(garden), starting with the door already open:
    % genuinely true this time -- walk_to_garden's only transition lands
    % in the garden.
    boolean(box(walk_to_garden, at(garden), Open), GenuineBoxHolds),

    % [walk_to_garden | wait] at(garden), same open-door state: now false --
    % the "wait" branch is a real alternative that leaves you in the hall,
    % so not every run reaches the garden, even though some do.
    boolean(box(choice(walk_to_garden, wait), at(garden), Open), ChoiceBoxFails),
    % <walk_to_garden | wait> at(garden): still true, since at least one
    % choice (walking) does reach it. Diamond and box genuinely diverge
    % here -- that gap is exactly what the two modalities are for.
    boolean(diamond(choice(walk_to_garden, wait), at(garden), Open), ChoiceDiamondHolds),

    % <wait*> at(hall), starting locked: repeating a no-op any number of
    % times (including zero) never leaves the hall.
    boolean(diamond(star(wait), at(hall), Locked), StarPreservesLocation),

    % <door(open)? ; walk_to_garden> at(garden): the test operator checks a
    % condition against the current state without changing it.
    boolean(diamond(seq(test(door(open)), walk_to_garden), at(garden), Open), TestGuardedPathWorks).

boolean(Goal, true) :- call(Goal), !.
boolean(_, false).
