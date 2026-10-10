% From The Art of EyeProlog, Chapter 31 — Properties over finite domains.
:- use_module(library(between), [between/3]).

double_is_even(N) :-
  (0 =:= (N + N) mod 2).

bounded_double_counterexample(N) :-
  between(-100, 100, N),
  \+ double_is_even(N).

bounded_double_law :-
  \+ bounded_double_counterexample(_).
