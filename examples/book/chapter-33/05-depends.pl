% From The Art of EyeProlog, Chapter 33.
:- table depends/2.

depends(X, Y) :- direct_dependency(X, Y).
depends(X, Z) :- direct_dependency(X, Y), depends(Y, Z).
