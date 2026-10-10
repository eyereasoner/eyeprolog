% From The Art of EyeProlog, Chapter 3 — Deeper foundations: the Herbrand world.
ancestor(X, Z) :- parent(X, Y), ancestor(Y, Z).
