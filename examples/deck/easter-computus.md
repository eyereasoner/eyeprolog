# Computing the date of Easter

## On which day does Easter fall in each year from 2026 to 2035?

Western Easter is the first Sunday after the first full moon on or after the
spring equinox, as the church calendar reckons them. The **computus** turns
that rule into integer arithmetic. This example runs the Meeus/Jones/Butcher
method for ten years and checks that every date lies in the legal window.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=easter-computus) ·
[Source](../easter-computus.pl)

---

# The question

For each year from 2026 to 2035, what is the date of Gregorian Easter? And is
every intermediate value, and every final date, within the range the method
guarantees: Easter between 22 March and 25 April?

---

# The method

```prolog
computus(Case, Year, Month, Day, J, K, Q, R, V, Z) :-
  case(Case, Year),
  (J is Year mod 19),
  (K is Year // 100),
  ...
  (R is T4 mod 30),
  ...
  (V is L4 mod 7),
  ...
  (Month is X3 // 31),
  (Z is X3 mod 31),
  (Day is Z + 1).
```

`J` is the year's place in the 19-year lunar cycle (the golden number), `R` is
the **epact**, the age of the moon at the start of the year, and `V` is a
weekday correction. Each step is one `is/2` goal, so each appears separately in
the proof.

---

# The window checks

```prolog
valid_golden(N) :- between(0, 18, N).
valid_epact(N) :- between(0, 29, N).
valid_weekday(N) :- between(0, 6, N).
legal_easter_date(3, D) :- between(22, 31, D).
legal_easter_date(4, D) :- between(1, 25, D).

checks_pass(Case) :-
  computus(Case, _year, Month, Day, J, _k, _q, R, V, _z),
  valid_golden(J),
  valid_epact(R),
  valid_weekday(V),
  month_name(Month, _name),
  legal_easter_date(Month, Day).
```

The checks are separate from the computation: they state what a correct
result must look like, not how to compute it.

---

# The answer

```sh
eyeprolog examples/easter-computus.pl
```

```text
easterDate(y2026, date(2026, april, 5)).
easterDate(y2027, date(2027, march, 28)).
easterDate(y2028, date(2028, april, 16)).
easterDate(y2029, date(2029, april, 1)).
easterDate(y2030, date(2030, april, 21)).
easterDate(y2031, date(2031, april, 13)).
easterDate(y2032, date(2032, march, 28)).
easterDate(y2033, date(2033, april, 17)).
easterDate(y2034, date(2034, april, 9)).
easterDate(y2035, date(2035, march, 25)).
```

The output also gives the remainders for each year and confirms that all ten
dates pass the window checks: 30 answers in all.

---

# The reason

```sh
eyeprolog --proof examples/easter-computus.pl
```

```text
step(easterDate(y2026, date(2026, april, 5)),
     rule(20),
     ['Case' = y2026, 'Year' = 2026, 'Monthname' = april, 'Day' = 5, 'Month' = 4],
     [computus(y2026, 2026, 4, 5, 12, 20, 6, 12, 2, 4), month_name(4, april)]).
step(12 is 2026 mod 19, builtin, [], []).
step(20 is 2026 // 100, builtin, [], []).
```

5 April 2026 rests on the computus for 2026, and that rests on a chain of
integer steps such as `12 is 2026 mod 19`, each recorded with its actual
values.

---

# The check

```sh
eyeprolog --proof examples/easter-computus.pl > easter-computus.why.pl
eyeprolog --check-proof easter-computus.why.pl examples/easter-computus.pl
```

```text
condition('C1', resolution, ok, 95).
condition('C4', coverage, ok, 543).
condition('C7', relevance, ok, 411).
verdict(checked).
```

All 95 rule steps replay and all 286 arithmetic and range steps are
recomputed independently. The 30 claims are covered, and nothing is taken on
trust.

---

# Try it

- Add `case(y2038, 2038).` and compare the result with a calendar.
- Add `case(y1818, 1818).`. Does it still pass the window check?
- Which years in the range have Easter in March, and which intermediate value
  decides that?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 6 (arithmetic and finite generation).
