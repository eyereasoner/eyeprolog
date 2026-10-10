% From The Art of EyeProlog, Chapter 29.
:- use_module(library(between), [between/3]).

counterexample_to_odd_square(N) :-
  between(1, 100, N),
  (N mod 2 =:= 1),
  ((N * N) mod 2 =\= 1).
