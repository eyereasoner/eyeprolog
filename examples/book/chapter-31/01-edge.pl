% From The Art of EyeProlog, Chapter 31 — Positive and negative observers.
edge(a, b).
edge(b, c).

path(X, Y) :- edge(X, Y).
path(X, Z) :- edge(X, Y), path(Y, Z).

no_path_to_d :-
  \+ path(a, d).
