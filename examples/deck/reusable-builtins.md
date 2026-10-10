# Reusable built-ins

## How far do the bundled libraries take you before you write a rule?

A name with stray spaces, a comma-separated tag list with a duplicate, and a
list of scores. Five short rules clean, de-duplicate, join, summarize, and
slice them using only library predicates, and each step still shows up in
the proof.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=reusable-builtins) ·
[Source](../reusable-builtins.pl)

---

# The question

Everyday data needs small, boring transformations: trim this, lowercase that,
drop duplicates, add up a column. Can they stay inside the logic program, as
relations, instead of being done beforehand in another language?

---

# The data

```prolog
:- use_module(library(strings)).
:- use_module(library(lists)).

name_raw('  Ada Lovelace  ').
tag_csv('logic,math,logic,programming').
scores([8, 13, 21]).
```

Text is an ordinary atom; the tag list is one atom with commas in it; the
scores are a list.

---

# The rules

```prolog
report(normalized_name, Name) :-
  name_raw(Raw),
  trim(Raw, Trimmed),
  lowercase(Trimmed, Name).

report(unique_tags, Tags) :-
  tag_csv(Csv),
  split(Csv, ',', Parts),
  list_to_set(Parts, Tags).

report(score_summary, summary(Total, Peak, Roottotal)) :-
  scores(Scores),
  sum_list(Scores, Total),
  max_list(Scores, Peak),
  (Roottotal is sqrt(Total)).
```

Each `report/2` clause is a pipeline read left to right: every goal binds the
input of the next. `trim/2`, `split/3` and `lowercase/2` come from
`library(strings)`; `list_to_set/2`, `sum_list/2` and `max_list/2` from
`library(lists)`.

---

# The answer

```sh
eyeprolog examples/reusable-builtins.pl
```

```text
report(normalized_name, 'ada lovelace').
report(unique_tags, [logic, math, programming]).
report(tag_label, 'logic / math / programming').
report(score_summary, summary(42, 21, 6.48074069840786)).
report(window, [13, 21]).
```

`list_to_set/2` keeps the first `logic` and drops the second, and
`slice(1, 2, Scores, Slice)` takes two scores starting at index 1.

---

# The reason

```text
step(report(normalized_name, 'ada lovelace'),
     rule(4),
     ['Name' = 'ada lovelace', 'Raw' = '  Ada Lovelace  ', 'Trimmed' = 'Ada Lovelace'],
     [name_raw('  Ada Lovelace  '),
      trim('  Ada Lovelace  ', 'Ada Lovelace'),
      lowercase('Ada Lovelace', 'ada lovelace')]).
step(trim('  Ada Lovelace  ', 'Ada Lovelace'), builtin, [], []).
step(lowercase('Ada Lovelace', 'ada lovelace'), builtin, [], []).
```

The normalized name comes from rule 4, and the proof records every
intermediate value: the raw text, the trimmed text, the lowercased result.
Library calls are recorded as `builtin` steps with their exact arguments.

---

# The check

```text
condition('C1', resolution, ok, 8).
condition('C5', re_decision, ok, 9).
verdict(checked).
```

The 8 rule and fact steps are replayed against the program (C1). The 9
`builtin` steps are *re-decided* (C5): the checker runs each library call
again, in isolation, and confirms it gives exactly the recorded result. No
step is taken on trust.

---

# Try it

- Change `tag_csv/1` to `'logic, math'` (with a space) and predict the
  `unique_tags` answer. Where would you add `trim/2`?
- Add `report(lowest, Low) :- scores(S), min_list(S, Low).`
- Replace `slice(1, 2, …)` with `take(2, …)` and `drop(1, …)`.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 39.
