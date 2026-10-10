% From The Art of EyeProlog, Chapter 33.
:- use_module(library(between), [between/3]).

chosen_pair(pair(X, Y), reason(sum_is_ten)) :-
  between(0, 10, X),
  between(X, 10, Y),
  (10 is X + Y).
