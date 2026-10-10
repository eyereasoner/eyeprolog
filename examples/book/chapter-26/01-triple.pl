% From The Art of EyeProlog, Chapter 26.
:- use_module(library(between), [between/3]).

triple(A, B, C) :-
  between(1, 20, A),
  between(A, 20, B),
  between(B, 20, C),
  (C * C =:= A * A + B * B).
