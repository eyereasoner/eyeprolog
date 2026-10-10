% From The Art of EyeProlog, Chapter 33.
:- use_module(library(strings)).

source_role(person_7, 'Doctor').

canonical_role(Person, clinician) :-
  source_role(Person, Text),
  lowercase(Text, doctor).
