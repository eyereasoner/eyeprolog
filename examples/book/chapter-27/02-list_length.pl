% From The Art of EyeProlog, Chapter 27 — Data shapes give you the induction.
list_length([], 0).
list_length([_ | Tail], N) :-
  list_length(Tail, M),
  (N is M + 1).
