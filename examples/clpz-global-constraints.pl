:- use_module(library(clpz)).

% Finite global constraints cover compatibility tables, lexicographic and
% non-overlapping schedules, value cardinalities with costs, Hamiltonian
% circuits, distinct-value counting, and three-way integer comparison.

%% ?- advanced_clpz(X0, X1).

advanced_clpz(table, compatible(4, Y, Distinct)) :-
  tuples_in([[X, Y]], [[1, 2], [1, 5], [4, 0], [4, 3]]),
  X = 4,
  nvalue(Distinct, [X, Y]),
  labeling([], [Y]).

advanced_clpz(schedule, starts([A, B, C])) :-
  [A, B, C] ins 0..3,
  lex_chain([[A, B], [B, C]]),
  serialized([A, B, C], [1, 2, 1]),
  A #< B,
  B #< C,
  labeling([ff], [A, B, C]).

advanced_clpz(cardinality, assignment(Values, Cost, Order)) :-
  Values = [_, _, _],
  global_cardinality(Values, [1-2, 3-1],
    [cost(Cost, [[5, 1], [2, 4], [3, 6]])]),
  labeling([ff], Values),
  zcompare(Order, Cost, 10).

advanced_clpz(circuit, successors(Values)) :-
  Values = [A, B, _, _],
  circuit(Values),
  A #= 2,
  B #= 3,
  labeling([ff], Values).
