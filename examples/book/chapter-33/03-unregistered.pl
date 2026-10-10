% From The Art of EyeProlog, Chapter 33.
unregistered(Person) :-
  person(Person),
  \+ registered(Person).
