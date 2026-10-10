% From The Art of EyeProlog, Chapter 23 — Specialization.
rail_connection(From, To, Cost) :-
  connection(rail, From, To, Cost).
