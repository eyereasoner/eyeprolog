% From The Art of EyeProlog, Chapter 13.
reach(X, Y) :- edge(X, Y).
reach(X, Z) :- edge(X, Y), reach(Y, Z).
