# Critical path scheduling

## When can the project finish, and which tasks decide that?

Eleven software tasks depend on each other. EyeProlog computes the earliest
start and finish of every task, the project's finish date, and the chain of
tasks that leaves no slack. That chain is the critical path, and any delay on
it delays the whole project.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=critical-path-schedule) ·
[Source](../critical-path-schedule.pl)

---

# The question

A task can start only when all of its predecessors have finished. So its
earliest start is the *latest* finish among its predecessors, and its finish is
that start plus its own duration.

The project ends when its last task ends. The critical tasks are the ones you
reach by walking back from that last task, each time to the predecessor that
finished last.

---

# The project network

```prolog
task(requirements, 2).
task(architecture, 3).
task(api_design, 2).
task(database, 4).
task(backend, 6).

depends(architecture, requirements).
depends(api_design, requirements).
depends(database, architecture).
depends(backend, api_design).
depends(backend, database).
```

`task(Name, Duration)` gives a duration in project time units, and
`depends(Task, Predecessor)` is one edge of the network. The full file has
eleven tasks and fourteen edges, ending in `launch`.

---

# The rules

```prolog
earliest_start(Task, 0) :-
  task(Task, _duration),
  \+ depends(Task, _pred).
earliest_start(Task, Start) :-
  depends(Task, _pred),
  aggregate_max(Finish, Pred,
    (depends(Task, Pred), finish_time(Pred, Finish)),
    Start, _criticalpred).

finish_time(Task, Finish) :-
  task(Task, Duration),
  earliest_start(Task, Start),
  (Finish is Start + Duration).
```

A task with no predecessors starts at 0. Any other task starts at the maximum
predecessor finish, which `aggregate_max/5` computes. `earliest_start/2` and
`finish_time/2` are declared with `:- table`, so each task's times are computed
once and reused by every query that needs them.

---

# The answer

```sh
eyeprolog examples/critical-path-schedule.pl
```

```text
critical_path_answer(project_finish, 23).
critical_path_answer(critical_task, launch).
critical_path_answer(critical_task, security_review).
critical_path_answer(critical_task, integration).
critical_path_answer(critical_task, backend).
critical_path_answer(critical_task, database).
critical_path_answer(critical_task, architecture).
critical_path_answer(critical_task, requirements).
critical_path_answer(schedule, task(requirements, 0, 2)).
critical_path_answer(schedule, task(architecture, 2, 5)).
```

The project takes 23 units. Seven tasks are critical. The other eleven answers
give each task's start and finish (two are shown here). `frontend`, `auth`,
`api_design`, and `load_test` have slack: they can slip a little without moving
the finish date.

---

# The reason

```text
step(project_finish(23),
     rule(32),
     ['Finish' = 23],
     [aggregate_max(Key, Value, finish_time(Value, Key), 23, launch)]).
step(earliest_start(backend, 9),
     rule(29),
     ['Task' = backend, 'Start' = 9],
     [depends(backend, api_design),
      aggregate_max(Key, Value, (depends(backend, Value), finish_time(Value, Key)), 9, database)]).
```

The project finishes at 23 because the largest finish time belongs to
`launch`. The backend starts at 9 because, of its two predecessors, `database`
finishes last, at 9. That is why `database` lies on the critical path and
`api_design` does not.

---

# The check

```text
condition('C1', resolution, ok, 105).
condition('C5', re_decision, ok, 11).
condition('C6', boundary_consistency, ok, 1).
obligation(builtin, theory_scoped, aggregate_max(A, B, finish_time(B, A), 23, launch)).
obligation(absent, theory_scoped, \+ depends(requirements, A)).
steps(128).
trusted(12).
verdict(checked_with_obligations).
```

The checker replays 105 rule and fact steps and recomputes 11 arithmetic steps.
Twelve steps are *obligations*: the eleven maxima and the claim that
`requirements` has no predecessor. A maximum over the program's own
`finish_time/2` cannot be recomputed without running the program, so the
verdict is `checked_with_obligations`. The proof is valid provided those
twelve conclusions hold, and the file lists every one of them.

---

# Try it

- Make `frontend` take 9 units instead of 5. Does the critical path change,
  and what is the new finish date?
- Add `depends(launch, frontend).` Which answers change, and why not the finish
  date?
- Ask only for the slack-free chain: `--goal 'critical_task(T)'`.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 8 (collecting and choosing answers) and Chapter 13 (tabling).
