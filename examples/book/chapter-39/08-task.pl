% From The Art of EyeProlog, Chapter 39.
:- use_module(library(iso_ext)).

task(parse).
task(check).
task(report).

extension_answer(all_tasks_are_atoms, true) :-
  forall(task(Task), atom(Task)).

extension_answer(numbered, Pairs) :-
  findall(N-S, (cfor(1, 3, N), succ(N, S)), Pairs).

extension_answer(with_tail, Tasks) :-
  findall(Task, task(Task), Tasks, [done]).

extension_answer(same_shape, true) :-
  variant(node(X, X), node(Y, Y)).
