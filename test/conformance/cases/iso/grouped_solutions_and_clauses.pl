% clause/2 may only inspect public (dynamic) procedures. Predicates that are
% read back with clause/2 below are declared dynamic; the rest stay static.
:- dynamic(parent/2).
:- dynamic(same/1).

b(2, two).
b(1, one).
b(1, one).
b(3, two).
b(2, one).

parent(alice, bob).
parent(alice, carol).
same(X) :-
    pair(X, X).
missing(_) :-
    fail.

%% ?- grouped(X0, X1).

grouped(Key, Bag) :-
    bagof(Value, b(Value, Key), Bag).

%% ?- grouped_set(X0, X1).

grouped_set(Key, Set) :-
    setof(Value, b(Value, Key), Set).

%% ?- existential(X0, X1).

existential(Bag, Set) :-
    bagof(Value, Key^b(Value, Key), Bag),
    setof(Value, Key^b(Value, Key), Set).

%% ?- no_solutions.

no_solutions :-
    \+(bagof(Value, missing(Value), Bag)).

%% ?- retrieved(X0, X1).

retrieved(Child, Body) :-
    clause(parent(alice, Child), Body).

%% ?- shared_clause(X0).

shared_clause(Body) :-
    clause(same(Value), Body),
    =(Value, ok).

%% ?- shared_set_variables(X0).

% ISO 7.2.1 leaves the order of distinct variables implementation dependent.
% Check that setof/3 constructs one consistent sorted list without baking a
% particular variable order into the conformance golden.
shared_set_variables(ok) :-
    setof(Value, (=(Value, Left); =(Value, Right)), Set),
    =(Left, a),
    =(Right, b),
    (=(Set, [a,b]); =(Set, [b,a])).
