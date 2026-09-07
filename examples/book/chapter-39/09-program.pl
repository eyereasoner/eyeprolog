% From The Art of EyeProlog, Chapter 39 — Specialized library implementation notes.
?- dif(f(X,A),f(Y,B)), ( true ; A = B ).
   dif(f(X, A), f(Y, B))
;  A = B, dif(X, Y).
