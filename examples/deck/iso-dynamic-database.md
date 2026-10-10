# ISO dynamic database

## How does a Prolog program keep changing state?

Most of a logic program is static: facts and rules that never change. Some
programs need mutable state, such as a work queue. ISO Prolog provides
dynamic predicates with `asserta/1`, `assertz/1` and `retract/1`. This
example builds a small task queue in one initialization goal and then
queries a stable state.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=iso-dynamic-database) ·
[Source](../iso-dynamic-database.pl)

---

# The question

Starting from one obsolete task, remove it, add three new tasks with the
urgent one at the front, and then ask: what is the next task, what is the
whole queue, and is the old task really gone?

---

# The setup

```prolog
:- dynamic(task/2).
:- initialization(prepare_queue).

task(old_probe, obsolete).

prepare_queue :-
  retract(task(old_probe, obsolete)),
  asserta(task(check_power, urgent)),
  assertz(task(check_network, normal)),
  assertz(task(archive_logs, low)).
```

`dynamic/1` declares that `task/2` may change. `asserta/1` adds a clause at
the front, `assertz/1` at the end, and `retract/1` removes one. Doing every
update inside one initialization goal means all later queries see the same
state.

---

# The reports

```prolog
report(next_task, Task) :-
  once(task(Task, _)).

report(all_tasks, Tasks) :-
  findall(task(Task, Priority), task(Task, Priority), Tasks).

report(old_task_removed, yes) :-
  \+ task(old_probe, obsolete).
```

The next task is simply the first `task/2` clause in the database.

---

# The answer

```sh
eyeprolog examples/iso-dynamic-database.pl
```

```text
report(next_task, check_power).
report(all_tasks, [task(check_power, urgent), task(check_network, normal), task(archive_logs, low)]).
report(old_task_removed, yes).
report(dynamic_predicate, yes).
```

The queue holds three tasks in insertion order, and the obsolete one is gone.

---

# The reason

```sh
eyeprolog --proof examples/iso-dynamic-database.pl
```

```text
step(report(next_task, check_power),
     rule(5),
     ['Task' = check_power],
     [once(task(check_power, urgent))]).
step(task(check_power, urgent), asserted, [], []).
```

The next task rests on `task(check_power, urgent)`, which is marked
`asserted`: it is not in the source file but was added at run time. Proofs
cite source clauses by number, so run-time additions get their own marker.

---

# The check

```text
condition('C1', resolution, ok, 4).
obligation(asserted, theory_scoped, task(check_power, urgent)).
obligation(collected, theory_scoped, findall(task(A, B), task(A, B), [task(check_power, urgent), task(check_network, normal), task(archive_logs, low)])).
obligation(absent, theory_scoped, \+ task(old_probe, obsolete)).
obligation(builtin, reflective, current_predicate(task / 2)).
verdict(checked_with_obligations).
```

Four rule steps replay. The rest depends on run-time state that the checker
cannot see in the source: an asserted fact, a collected list, an absence, and
a reflective look at the program. Each becomes a named **obligation**, so
the verdict says exactly what was trusted.

---

# Try it

- Change `assertz(task(archive_logs, low))` to `asserta(...)`. Now
  `archive_logs` becomes the next task and moves to the front of the queue.
- Remove `:- dynamic(task/2).` The `retract/1` call then raises a
  `permission_error`, because `task/2` is a static procedure.
- Add a `complete_task/1` predicate that retracts the next task, and ask
  for the queue after completing one.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 36.
