% From The Art of EyeProlog, Chapter 18 — Examples before recursion.
prefix([], _).
prefix([X | Xs], [X | Ys]) :- prefix(Xs, Ys).
