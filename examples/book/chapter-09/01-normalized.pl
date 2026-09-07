% From The Art of EyeProlog, Chapter 9.
:- use_module(library(strings)).
:- use_module(library(lists)).

normalized(Input, Words) :-
  trim(Input, Trimmed),
  lowercase(Trimmed, Lower),
  split(Lower, ' ', Words).
