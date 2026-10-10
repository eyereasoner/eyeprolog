% From The Art of EyeProlog, Chapter 3 — Witnesses instead of hidden objects.
has_parent(Child, parent_of(Child)) :-
  person(Child).

registration(Student, Course, registration_of(Student, Course)) :-
  takes(Student, Course).
