% From The Art of EyeProlog, Chapter 4 — Cycles and tabling.
path(X, Y, [X, Y]) :- edge(X, Y).
path(X, Z, [X | Rest]) :-
  edge(X, Y),
  path(Y, Z, Rest).
