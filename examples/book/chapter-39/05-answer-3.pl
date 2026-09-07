% From The Art of EyeProlog, Chapter 39.
:- use_module(library(strings)).
:- use_module(library(lists)).

answer(words, Words) :-
  trim('  Logic Made Visible  ', Clean),
  lowercase(Clean, Lower),
  split(Lower, ' ', Words).

answer(captures, Context) :-
  matches('Ada Lovelace',
          '^(?<first>[A-Za-z]+) (?<last>[A-Za-z]+)$',
          Context).
