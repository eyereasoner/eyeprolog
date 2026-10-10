% From The Art of EyeProlog, Chapter 28 — Relations expose inverse problems.
:- use_module(library(between), [between/3]).

integer_rectangle(Area, W, H) :-
  between(1, Area, W),
  between(W, Area, H),
  (Area =:= W * H).
