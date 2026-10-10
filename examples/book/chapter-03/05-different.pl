% From The Art of EyeProlog, Chapter 3 — Terms denote themselves.
different(alice, bob) :- (alice \= bob).
different(ticket(alice), ticket(bob)) :-
  (ticket(alice) \= ticket(bob)).
