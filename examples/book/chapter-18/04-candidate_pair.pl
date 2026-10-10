% From The Art of EyeProlog, Chapter 18 — Generate, then test.
candidate_pair(A, B) :-
  person(A),
  person(B).

compatible_pair(A, B) :-
  candidate_pair(A, B),
  (A \= B),
  \+ conflict(A, B).
