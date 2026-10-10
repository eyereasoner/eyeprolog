% From The Art of EyeProlog, Chapter 32 — Follow bindings left to right.
age(alex, 19).

eligible(Person) :-
  (Age >= 18),
  age(Person, Age).
