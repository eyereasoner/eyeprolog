collectionLength(numbers, 3).
why(
  collectionLength(numbers, 3),
  step(
    collectionLength(numbers, 3),
    rule("list-collection.pl", clause(3)),
    ['N' = 3, 'List' = [1, 2, 3]],
    [
      step(collection(numbers, [1, 2, 3]), fact("list-collection.pl", clause(1)), [], []),
      step(length([1, 2, 3], 3), library(length, 2), [], [])
    ]
  )
).

collectionMember(numbers, 1).
why(
  collectionMember(numbers, 1),
  step(
    collectionMember(numbers, 1),
    rule("list-collection.pl", clause(4)),
    ['X' = 1, 'List' = [1, 2, 3]],
    [
      step(collection(numbers, [1, 2, 3]), fact("list-collection.pl", clause(1)), [], []),
      step(member(1, [1, 2, 3]), library(member, 2), [], [])
    ]
  )
).

collectionMember(numbers, 2).
why(
  collectionMember(numbers, 2),
  step(
    collectionMember(numbers, 2),
    rule("list-collection.pl", clause(4)),
    ['X' = 2, 'List' = [1, 2, 3]],
    [
      step(collection(numbers, [1, 2, 3]), fact("list-collection.pl", clause(1)), [], []),
      step(member(2, [1, 2, 3]), library(member, 2), [], [])
    ]
  )
).

collectionMember(numbers, 3).
why(
  collectionMember(numbers, 3),
  step(
    collectionMember(numbers, 3),
    rule("list-collection.pl", clause(4)),
    ['X' = 3, 'List' = [1, 2, 3]],
    [
      step(collection(numbers, [1, 2, 3]), fact("list-collection.pl", clause(1)), [], []),
      step(member(3, [1, 2, 3]), library(member, 2), [], [])
    ]
  )
).

collectionAppend(letters, "abc").
why(
  collectionAppend(letters, "abc"),
  step(
    collectionAppend(letters, "abc"),
    rule("list-collection.pl", clause(5)),
    ['Extended' = "abc", 'List' = "ab"],
    [
      step(collection(letters, "ab"), fact("list-collection.pl", clause(2)), [], []),
      step(append("ab", "c", "abc"), library(append, 3), [], [])
    ]
  )
).

head(letters, a).
why(
  head(letters, a),
  step(
    head(letters, a),
    rule("list-collection.pl", clause(6)),
    ['Head' = a, '_tail' = "b"],
    [
      step(collection(letters, "ab"), fact("list-collection.pl", clause(2)), [], [])
    ]
  )
).

tail(letters, "b").
why(
  tail(letters, "b"),
  step(
    tail(letters, "b"),
    rule("list-collection.pl", clause(7)),
    ['Tail' = "b", '_head' = a],
    [
      step(collection(letters, "ab"), fact("list-collection.pl", clause(2)), [], [])
    ]
  )
).

