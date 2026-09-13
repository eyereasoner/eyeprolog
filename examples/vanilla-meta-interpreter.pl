% A vanilla meta-interpreter: solve/1 mirrors the ordinary Prolog resolution
% rule at the object level, using clause/2 to fetch a matching clause and
% conjunction to solve its body. It shows that "how Prolog executes a goal"
% is itself expressible as an ordinary Prolog relation, not a hidden
% mechanism -- the classic starting point for building custom reasoners
% (tracers, proof recorders, alternative search strategies) on top of plain
% Prolog. clause/2 only inspects dynamic procedures, hence the declarations.
:- dynamic(parent/2).
:- dynamic(grandparent/2).
:- dynamic(great_grandparent/2).

solve(true) :- !.
solve((A, B)) :- !, solve(A), solve(B).
solve(Goal) :-
    clause(Goal, Body),
    solve(Body).

parent(tom, bob).
parent(bob, ann).
parent(bob, pat).
parent(pat, jim).

grandparent(X, Z) :- parent(X, Y), parent(Y, Z).
great_grandparent(X, Z) :- parent(X, Y), grandparent(Y, Z).

%% goal: answer(X0, X1)

answer(Grandchildren, GreatGrandchildren) :-
    findall(X, solve(grandparent(tom, X)), Grandchildren),
    findall(X, solve(great_grandparent(tom, X)), GreatGrandchildren).
