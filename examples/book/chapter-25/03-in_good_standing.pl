% From The Art of EyeProlog, Chapter 25 — The closed-world choice.
in_good_standing(Person) :-
  person(Person),
  \+ suspended(Person).
