:- use_module(library(clpz)).
:- use_module(library(lists), [length/2]).

% The list position is a column and its value is a row. Domains, global
% distinctness, and delayed diagonal constraints describe the puzzle before
% labeling searches the remaining finite alternatives.
%
% queens8_witness/1 does NOT search: it unifies Rows with a known witness
% FIRST and only then calls queens/2, so every position is already ground
% before labeling/2 ever runs. It is a fast constraint check against a
% known-good answer, not a demonstration of solving the puzzle -- the name
% says so, so it cannot be mistaken for one. A smaller four-queens query
% below is the routine, honestly-searched default: it exercises actual
% search and multiple-solution enumeration, small enough to stay fast
% without making the default example suite a CLP(Z) benchmark.

%% goal: queens8_witness(X0)
%% goal: queens(4, X0)

queens8_witness(Rows) :-
  Rows = [1, 5, 8, 6, 3, 7, 2, 4],
  queens(8, Rows).

queens(Size, Rows) :-
  length(Rows, Size),
  Rows ins 1..Size,
  all_distinct(Rows),
  safe_diagonals(Rows),
  labeling([ff], Rows).

safe_diagonals([]).
safe_diagonals([Row|Rows]) :-
  safe_from(Row, Rows, 1),
  safe_diagonals(Rows).

safe_from(_, [], _).
safe_from(Row, [Other|Rows], Distance) :-
  Row #\= Other + Distance,
  Row #\= Other - Distance,
  NextDistance is Distance + 1,
  safe_from(Row, Rows, NextDistance).
