# Age check

## Is this person older than 80?

A birthday, a threshold written as an ISO 8601 duration, and a fixed "today"
are enough to decide an age question. The calendar arithmetic comes from
`library(dates)`, and the proof shows the exact duration it computed.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=age) ·
[Source](../age.pl)

---

# The question

Pat was born on 21 August 1944. Is Pat older than 80 years on 30 May 2026?

Ages are not plain numbers: months have different lengths and years have leap
days. The example therefore works with calendar dates and **ISO 8601
durations** such as `P80Y` (a period of 80 years).

---

# The facts

```prolog
birthDay(patH, '1944-08-21').
duration(check, 'P80Y').
local_time('2026-05-30').
```

"Today" is a fact, not a clock reading. That keeps the answer reproducible: the
same program gives the same answer on any day and any machine.

---

# The rule

```prolog
ageAbove(S, A) :-
  birthDay(S, B),
  duration(check, A),
  local_time(D),
  difference(D, B, F),
  (F @> A).
```

`difference/3` from `library(dates)` computes the calendar difference between
two dates as a duration. The comparison `@>` then orders two durations.

---

# The answer

```sh
eyeprolog examples/age.pl
```

```text
ageAbove(patH, 'P80Y').
holds_result(test, true).
```

Pat is above the 80-year threshold, so the test holds.

---

# The reason

```sh
eyeprolog --proof examples/age.pl
```

```text
step(difference('2026-05-30', '1944-08-21', 'P81Y9M9D'), builtin, [], []).
step('P81Y9M9D' @> 'P80Y', builtin, [], []).
```

The proof records the computed age: 81 years, 9 months, and 9 days. That
duration is greater than 80 years, which is why `ageAbove/2` holds.

---

# The check

```text
condition('C1', resolution, ok, 5).
condition('C5', re_decision, ok, 2).
recomputed(2).
trusted(0).
verdict(checked).
```

Five steps resolve against the program's facts and rules. The two built-in
steps, the date difference and the comparison, are **recomputed** by the
checker, so even the calendar arithmetic is independently confirmed.

---

# Try it

- Change `local_time/1` to `'2024-08-20'`, the day before Pat's 80th birthday.
  What does `difference/3` return, and does the test still hold?
- Add a second person and ask `ageAbove(Who, 'P80Y')`.
- Why is `local_time/1` a fact instead of a call to the system clock?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 39 (`library(dates)`).
