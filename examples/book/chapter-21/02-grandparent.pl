% From The Art of EyeProlog, Chapter 21 — Bindings flow forward.
grandparent(X, Z) :-
  parent(X, Y),
  parent(Y, Z).
