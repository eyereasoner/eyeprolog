# Vector similarity

## How alike are two vectors?

Cosine similarity measures the angle between two vectors: 1 means they point
the same way, 0 means they are unrelated, −1 means opposite. It is everywhere
in search and machine learning. This example computes it from scratch with
recursion over lists, so every multiplication shows up in the proof.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=vector-similarity) ·
[Source](../vector-similarity.pl)

---

# The question

What is the cosine similarity of `[1, 2, 3]` and `[4, −5, 6]`?

Cosine similarity is the dot product divided by the product of the two
lengths (norms): `dot(A, B) / (|A| · |B|)`.

---

# The rules

```prolog
dot([], [], 0.0).
dot([A|As], [B|Bs], Dot) :-
  (Product is A * B),
  dot(As, Bs, Rest),
  (Dot is Product + Rest).

norm(Vector, Norm) :-
  sum_squares(Vector, Sumsquares),
  (Norm is Sumsquares ** 0.5).

cosine_similarity(Case, Similarity) :-
  vector(Case, a, A),
  vector(Case, b, B),
  dot(A, B, Dot),
  norm(A, Norma),
  norm(B, Normb),
  (Denominator is Norma * Normb),
  (Similarity is Dot / Denominator).
```

The dot product walks both lists at once, multiplying matching elements and
adding up. The norm is the square root of the sum of squares, computed by the
same kind of recursion.

---

# The answer

```sh
eyeprolog examples/vector-similarity.pl
```

```text
dotProduct(pair1, 12.0).
normA(pair1, 3.7416573867739413).
normB(pair1, 8.774964387392123).
cosineSimilarity(pair1, 0.3654869423239036).
```

The dot product is 1·4 + 2·(−5) + 3·6 = 12. The vectors are about 68.6° apart,
so their similarity is about 0.365.

---

# The reason

```text
step(4.0 is 1.0 * 4.0, builtin, [], []).
step(-10.0 is 2.0 * -5.0, builtin, [], []).
```

Each element-wise product is its own step. The proof of the dot product is the
calculation you would write out by hand, one line per element.

---

# The check

```text
condition('C1', resolution, ok, 20).
condition('C5', re_decision, ok, 22).
condition('C7', relevance, ok, 46).
verdict(checked).
```

The checker replays the 20 rule and fact steps and recomputes all 22
arithmetic steps, so every product, sum, and square root is confirmed
independently.

---

# Try it

- Add a pair whose second vector is twice the first and predict its
  similarity.
- Add a pair of perpendicular vectors, such as `[1, 0]` and `[0, 1]`.
- What happens if one vector is all zeros? Add a guard that reports this case
  instead of dividing by zero.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 6.
