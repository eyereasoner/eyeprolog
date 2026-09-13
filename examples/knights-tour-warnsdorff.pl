% Knight's tour via Warnsdorff's rule: at each step, move to the reachable
% unvisited square with the fewest onward moves of its own. Preferring the
% most constrained square first empties the "hard" corners early, while
% plenty of freedom remains to reach them -- so a full tour is usually found
% without ever needing to backtrack. keysort/2 on Degree-Square pairs picks
% the least-constrained-first candidate; the cut in tour_/4's base case
% commits to the tour once every square is visited.
:- use_module(library(lists)).

board_size(5).

knight_move(p(X0, Y0), p(X, Y)) :-
    member(d(DX, DY), [
        d(1, 2), d(2, 1), d(-1, 2), d(-2, 1),
        d(1, -2), d(2, -1), d(-1, -2), d(-2, -1)
    ]),
    X is X0 + DX, Y is Y0 + DY,
    board_size(N),
    X >= 1, X =< N, Y >= 1, Y =< N.

degree(Square, Visited, Degree) :-
    findall(Next, (knight_move(Square, Next), \+ member(Next, Visited)), Nexts),
    length(Nexts, Degree).

tour_(_, Visited, SquareCount, Visited) :- length(Visited, SquareCount), !.
tour_(Current, Visited, SquareCount, Tour) :-
    findall(Degree-Next, (
        knight_move(Current, Next),
        \+ member(Next, Visited),
        degree(Next, Visited, Degree)
    ), Candidates),
    Candidates \= [],
    keysort(Candidates, [_-Best | _]),
    tour_(Best, [Best | Visited], SquareCount, Tour).

knights_tour(Start, Tour) :-
    board_size(N),
    SquareCount is N * N,
    tour_(Start, [Start], SquareCount, ReverseTour),
    reverse(ReverseTour, Tour).

%% goal: answer(X0, X1)

answer(SquareCount, Tour) :-
    knights_tour(p(1, 1), Tour),
    length(Tour, SquareCount).
