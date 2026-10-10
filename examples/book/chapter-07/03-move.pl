% From The Art of EyeProlog, Chapter 7 — Negation through recursion.
move(a, b).
move(b, a).
win(X) :- move(X, Y), tnot(win(Y)).
