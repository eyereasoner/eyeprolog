% From The Art of EyeProlog, Chapter 28 — Relations reveal inverse problems.
:- use_module(library(lists)).

rectangle(W, H, Area) :- (Area is W * H).
