% Prolog result format 4
query(1, collectionLength(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = numbers, 'X1' = 3]).
why(1, ['X0' = numbers, 'X1' = 3], [collectionLength(numbers, 3)]).
query(2, collectionMember(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 3).
answer(2, ['X0' = numbers, 'X1' = 1]).
why(2, ['X0' = numbers, 'X1' = 1], [collectionMember(numbers, 1)]).
answer(2, ['X0' = numbers, 'X1' = 2]).
why(2, ['X0' = numbers, 'X1' = 2], [collectionMember(numbers, 2)]).
answer(2, ['X0' = numbers, 'X1' = 3]).
why(2, ['X0' = numbers, 'X1' = 3], [collectionMember(numbers, 3)]).
query(3, collectionAppend(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = letters, 'X1' = "abc"]).
why(3, ['X0' = letters, 'X1' = "abc"], [collectionAppend(letters, "abc")]).
query(4, head(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4, ['X0' = letters, 'X1' = a]).
why(4, ['X0' = letters, 'X1' = a], [head(letters, a)]).
query(5, tail(_0, _1), ['X0' = _0, 'X1' = _1]).
result(5, complete, 1).
answer(5, ['X0' = letters, 'X1' = "b"]).
why(5, ['X0' = letters, 'X1' = "b"], [tail(letters, "b")]).

clause(1, collection(numbers, [1, 2, 3]), true).
clause(2, collection(letters, "ab"), true).
clause(3,
       collectionLength(numbers, var('N')),
       (collection(numbers, var('List')), length(var('List'), var('N')))).
clause(4,
       collectionMember(numbers, var('X')),
       (collection(numbers, var('List')), member(var('X'), var('List')))).
clause(5,
       collectionAppend(letters, var('Extended')),
       (collection(letters, var('List')), append(var('List'), "c", var('Extended')))).
clause(6, head(letters, var('Head')), collection(letters, [var('Head') | anonymous(1)])).
clause(7, tail(letters, var('Tail')), collection(letters, [anonymous(1) | var('Tail')])).

step(collectionLength(numbers, 3),
     rule(3),
     ['N' = 3, 'List' = [1, 2, 3]],
     [collection(numbers, [1, 2, 3]), length([1, 2, 3], 3)]).
step(collection(numbers, [1, 2, 3]), fact(1), [], []).
step(length([1, 2, 3], 3), builtin, [], []).
step(collectionMember(numbers, 1),
     rule(4),
     ['X' = 1, 'List' = [1, 2, 3]],
     [collection(numbers, [1, 2, 3]), member(1, [1, 2, 3])]).
step(member(1, [1, 2, 3]), builtin, [], []).
step(collectionMember(numbers, 2),
     rule(4),
     ['X' = 2, 'List' = [1, 2, 3]],
     [collection(numbers, [1, 2, 3]), member(2, [1, 2, 3])]).
step(member(2, [1, 2, 3]), builtin, [], []).
step(collectionMember(numbers, 3),
     rule(4),
     ['X' = 3, 'List' = [1, 2, 3]],
     [collection(numbers, [1, 2, 3]), member(3, [1, 2, 3])]).
step(member(3, [1, 2, 3]), builtin, [], []).
step(collectionAppend(letters, "abc"),
     rule(5),
     ['Extended' = "abc", 'List' = "ab"],
     [collection(letters, "ab"), append("ab", "c", "abc")]).
step(collection(letters, "ab"), fact(2), [], []).
step(append("ab", "c", "abc"), builtin, [], []).
step(head(letters, a), rule(6), ['Head' = a], [collection(letters, "ab")]).
step(tail(letters, "b"), rule(7), ['Tail' = "b"], [collection(letters, "ab")]).
