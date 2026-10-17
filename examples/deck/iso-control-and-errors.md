# ISO control and errors

## How does standard Prolog choose, commit, and recover?

Pure relations explore every alternative. Real programs sometimes need to
keep only the first answer, make a local if-then-else decision, or turn an
exception into an ordinary result. This example shows the ISO control
constructs for each of those, on a tiny route table.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=iso-control-and-errors) ·
[Source](../iso-control-and-errors.pl)

---

# The question

From Antwerp there are routes to Ghent and Brussels. What is the first
destination? Is there a route to Ghent, and to Paris? And when a caller
insists on a route that does not exist, can the program recover gracefully?

---

# Choosing and committing

```prolog
route(antwerp, ghent).
route(antwerp, brussels).

first_destination(From, To) :-
  once(route(From, To)).

preferred_destination(From, To) :-
  route(From, To),
  !.

travel_status(From, To, Status) :-
  (call(route(From, To)) -> Status = connected ; Status = disconnected).
```

`once/1` keeps the first solution of a goal. The cut `!` discards the
remaining alternatives of the predicate. If-then-else (`-> ;`) commits to the
first solution of its condition and otherwise takes the else branch.
`call/1` runs a goal held as data.

---

# Throwing and catching

```prolog
require_route(From, To) :-
  (route(From, To) -> true ; throw(no_route(From, To))).

checked_route(From, To, Result) :-
  catch(
    (require_route(From, To), Result = accepted),
    no_route(From, To),
    Result = rejected
  ).
```

A missing route that the caller *requires* is not a plain "no": it throws
`no_route(From, To)`. `catch/3` unifies the thrown term with its pattern and
runs the recovery goal instead.

---

# The answer

```sh
eyeprolog examples/iso-control-and-errors.pl
```

```text
report(first_destination, ghent).
report(cut_destination, ghent).
report(existing_route, connected).
report(missing_route, disconnected).
report(recovered_exception, rejected).
```

Both `once/1` and the cut keep Ghent and drop Brussels. The Paris route is
`disconnected`, and the exception for it is turned into `rejected`.

---

# The reason

```sh
eyeprolog --proof examples/iso-control-and-errors.pl
```

```text
step(checked_route(antwerp, paris, rejected),
     rule(7),
     ['From' = antwerp, 'To' = paris, 'Result' = rejected],
     [catch((require_route(antwerp, paris), rejected = accepted), no_route(antwerp, paris), rejected = rejected)]).
```

`rejected` comes from rule 7, whose single use is the whole `catch/3` call
with the bindings that held when it succeeded. The proof records *that* the
catch produced `rejected`, not the thrown exception inside it.

---

# The check

```text
condition('C1', resolution, ok, 11).
condition('C5', re_decision, ok, 7).
obligation(absent, theory_scoped, \+ call(route(antwerp, paris))).
obligation(builtin, theory_scoped, catch((require_route(antwerp, paris), rejected = accepted), no_route(antwerp, paris), rejected = rejected)).
verdict(checked_with_obligations).
```

Eleven steps replay against their clauses. The two if-then-else decisions are
recorded as the branch each took and composed from its goals. The branch taken
when there is no route rests on `\+ call(route(antwerp, paris))`, which depends
on the program's own `route/2` facts, and so does the `catch/3`: the checker
cannot recompute them in isolation. They are recorded as **obligations**:
trusted boundaries named in the report.

---

# Try it

- Add `report(all_destinations, L) :- findall(To, route(antwerp, To), L).`
  It lists both Ghent and Brussels, which `once/1` and the cut drop.
- Change the catcher in `checked_route/3` to `no_route(_, ghent)`. The
  exception no longer matches, and the run ends with an uncaught
  `no_route(antwerp, paris)`.
- Swap the two `route/2` facts and predict the first two reports.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 34.
