% From The Art of EyeProlog, Chapter 39.
:- use_module(library(lists)).

answer(split, pair(Prefix, Suffix)) :-
  append(Prefix, Suffix, [a, b]).

answer(second, Item) :-
  nth0(1, [a, b, c], Item).
