# Hamming(7,4) error correction

## Which bit of this received packet was flipped, and what was sent?

A Hamming(7,4) code protects four data bits with three parity bits, so a single
flipped bit can be located and repaired. EyeProlog computes the syndrome,
corrects the codeword, and proves each step from the received bits.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=hamming-code) ·
[Source](../hamming-code.pl)

---

# The question

Seven bits arrive: `1 0 1 1 1 1 0`. One of them was flipped by noise. Which
one, what was the original codeword, and what are the four data bits?

---

# The received word

```prolog
received_bit(packet1, 1, 1).
received_bit(packet1, 2, 0).
received_bit(packet1, 3, 1).
received_bit(packet1, 4, 1).
received_bit(packet1, 5, 1).
received_bit(packet1, 6, 1).
received_bit(packet1, 7, 0).
```

Positions 1, 2 and 4 hold parity bits; positions 3, 5, 6 and 7 hold data.

---

# The syndrome

```prolog
syndrome_bit1(Code, S1) :-
  received_bit(Code, 1, B1),
  received_bit(Code, 3, B3),
  received_bit(Code, 5, B5),
  received_bit(Code, 7, B7),
  parity4(B1, B3, B5, B7, S1).

syndrome(Code, Syndrome) :-
  syndrome_bit1(Code, S1),
  syndrome_bit2(Code, S2),
  syndrome_bit4(Code, S4),
  (Weighteds2 is S2 * 2),
  (Weighteds4 is S4 * 4),
  (Partial is S1 + Weighteds2),
  (Syndrome is Partial + Weighteds4).
```

Each parity check covers the positions whose binary index has a given bit set.
Read as a binary number, the three failed checks spell out the position of the
error.

---

# Correction

```prolog
corrected_bit(Code, Position, Corrected) :-
  syndrome(Code, Position),
  received_bit(Code, Position, Bit),
  flip(Bit, Corrected).

corrected_bit(Code, Position, Bit) :-
  syndrome(Code, Errorposition),
  (Position \= Errorposition),
  received_bit(Code, Position, Bit).
```

Flip the bit the syndrome points at; keep every other bit.

---

# The answer

```sh
eyeprolog examples/hamming-code.pl
```

```text
syndrome(packet1, 5).
errorBit(packet1, 5).
correctedCodeword(packet1, [1, 0, 1, 1, 0, 1, 0]).
decodedPayload(packet1, [1, 0, 1, 0]).
status(packet1, single_bit_corrected).
reason(packet1, "Hamming syndrome identifies the flipped bit position").
```

Checks 1 and 4 fail and check 2 passes, so the syndrome is `1 + 4 = 5`. Bit 5
is flipped back, and the data bits are `1 0 1 0`.

---

# The reason

```sh
eyeprolog --proof examples/hamming-code.pl
```

```text
step(corrected_bit(packet1, 5, 0),
     rule(15),
     ['Code' = packet1, 'Position' = 5, 'Corrected' = 0, 'Bit' = 1],
     [syndrome(packet1, 5), received_bit(packet1, 5, 1), flip(1, 0)]).
```

Bit 5 becomes 0 because the syndrome is 5, the received bit 5 is 1, and
flipping 1 gives 0. The syndrome has its own step, built from the three parity
checks over the received bits.

---

# The check

```text
condition('C1', resolution, ok, 28).
condition('C5', re_decision, ok, 18).
steps(46).
verified(28).
recomputed(18).
trusted(0).
claims(6).
verdict(checked).
```

28 steps replay against the program, and the checker recomputes all 18
parity and arithmetic steps itself. The correction is fully certified.

---

# Try it

- Make bit 5 correct (`0`) and flip bit 3 instead. The syndrome becomes 3, and
  the same codeword `[1, 0, 1, 1, 0, 1, 0]` is recovered.
- Fix bit 5 and change nothing else. The syndrome is 0: the codeword and
  payload are still derived, but `errorBit/2` and `status/2` give no answer.
- Flip two bits at once. What does the syndrome point at now, and why can
  Hamming(7,4) not correct two errors?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 14.
