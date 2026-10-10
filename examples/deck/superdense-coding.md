# Superdense coding

## Can one shared qubit carry two classical bits?

Superdense coding is a quantum protocol: Alice and Bob share an entangled pair,
Alice applies one of four operations to her half, and Bob recovers which of
four messages she meant. This example models the protocol in a discrete
setting where answers that arise an even number of times cancel, and lets
EyeProlog confirm that every message arrives intact and no message turns into
another.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=superdense-coding) ·
[Source](../superdense-coding.pl)

---

# The question

Alice wants to send one of four messages, `0` to `3`. She owns half of an
entangled pair, applies one of four transformations to it, and sends it to Bob.
Bob applies a matching measurement. Does Bob always decode the message Alice
chose, and only that message?

In quantum mechanics the different ways of reaching an outcome can interfere.
Here interference is modelled simply: if two different paths lead to the same
(message, decoding) pair, they cancel out. A decoding survives only when it has
exactly one supporting path.

---

# The model

```prolog
% |R) = |0, 0) + |1, 1)
r(false, false).
r(true, true).

% K |0) = |0), K |1) = |0) + |1)
k(false, false).
k(true, false).
k(true, true).
```

`r/2` is the entangled pair: both halves are equal. The other relations are
the transformations: `identity/2`, `g/2` (a bit flip), `k/2`, and their
compositions `kg/2` and `gk/2`. Alice picks one per message; Bob uses a
matching basis to decode.

```prolog
alice(0, X, Y) :- identity(X, Y).
alice(1, X, Y) :- g(X, Y).
alice(2, X, Y) :- k(X, Y).
alice(3, X, Y) :- kg(X, Y).
```

---

# Interference as negation

```prolog
sdc_path(N, M, path(X, Y, B)) :-
  r(X, Y),
  alice(N, X, B),
  bob(B, Y, M).

duplicate_sdc_path(N, M, Proof) :-
  sdc_path(N, M, Proof),
  sdc_path(N, M, Other),
  (Proof \= Other).

sdcoding(N, M) :-
  sdc_path(N, M, Proof),
  \+ duplicate_sdc_path(N, M, Proof).
```

A path is one way through the pair, Alice's transform, and Bob's measurement.
`sdcoding(N, M)` holds when message `N` decodes as `M` along a path that no
other path duplicates: the paths that cancel in pairs are filtered out with
negation as failure.

---

# The answer

```sh
eyeprolog examples/superdense-coding.pl
```

```text
decodesAs(message(1), 1).
decodesAs(message(3), 3).
decodesAs(message(0), 0).
decodesAs(message(2), 2).
preservesMessage(protocol, true).
cancelsCrossTalk(protocol, true).
```

Every message decodes as itself. `cancelsCrossTalk/2` confirms that the
mixed-up decodings such as message 0 read as 1 do not survive: their paths
cancel.

---

# The reason

```text
step(sdc_path(1, 1, path(false, false, true)),
     rule(20),
     ['N' = 1, 'M' = 1, 'X' = false, 'Y' = false, 'B' = true],
     [r(false, false), alice(1, false, true), bob(true, false, 1)]).
step(\+ duplicate_sdc_path(1, 1, path(false, false, true)), absent, [], []).
```

Message 1 travels from the pair state `(false, false)`: Alice's bit flip turns
her half into `true`, and Bob's measurement reads `1`. The second step records
that no other path reaches the same result, so nothing cancels it.

---

# The check

```text
condition('C1', resolution, ok, 30).
condition('C4', coverage, ok, 50).
condition('C6', boundary_consistency, ok, 0).
obligation(absent, theory_scoped, \+ sdcoding(0, 1)).
trusted(8).
verdict(checked_with_obligations).
```

The checker replays the 30 rule and fact steps against the program. Eight
steps are absences (`\+ ...`): a proof cannot list everything that failed to
happen, so the checker reports them as **obligations**, conclusions the proof
rests on rather than establishes. The verdict is valid, conditional on those
absences.

---

# Try it

- Remove the fact `k(true, true).` and predict which messages still decode
  correctly.
- Replace `\+ duplicate_sdc_path(N, M, Proof)` with `true`. Which cross-talk
  decodings appear once nothing cancels?
- Ask for every support path of message 2:
  `--goal 'sdc_path(2, M, P)'`.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 7.
