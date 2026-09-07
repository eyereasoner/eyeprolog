% From The Art of EyeProlog, Chapter 28 — Symmetry reduces search.
:- use_module(library(between), [between/3]).
:- use_module(library(lists)).

triangle(A, B, C) :-
  between(1, 20, A),
  between(A, 20, B),
  between(B, 20, C),
  (Sum is A + B),
  (Sum > C).
