% From The Art of EyeProlog, Chapter 28.
:- use_module(library(between), [between/3]).
:- use_module(library(lists)).

integer_rectangle(Area, W, H) :-
  between(1, Area, W),
  between(W, Area, H),
  (Area is W * H).
