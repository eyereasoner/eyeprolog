% Prolog result format 4
query(1, value(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = nativeMath, 'X1' = 1.0]).
why(1, ['X0' = nativeMath, 'X1' = 1.0], [value(nativeMath, 1.0)]).
query(2, ok(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 2).
answer(2, ['X0' = nativeCompare, 'X1' = true]).
why(2, ['X0' = nativeCompare, 'X1' = true], [ok(nativeCompare, true)]).
answer(2, ['X0' = nativeString, 'X1' = true]).
why(2, ['X0' = nativeString, 'X1' = true], [ok(nativeString, true)]).
query(3, tail(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = nativeList, 'X1' = "bc"]).
why(3, ['X0' = nativeList, 'X1' = "bc"], [tail(nativeList, "bc")]).
query(4, label(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4, ['X0' = vocabularyExample, 'X1' = "vocabulary names are ordinary predicate names"]).
why(4,
    ['X0' = vocabularyExample, 'X1' = "vocabulary names are ordinary predicate names"],
    [label(vocabularyExample, "vocabulary names are ordinary predicate names")]).

clause(1, value(nativeMath, var('X')), var('X') is 0.125 + 0.875).
clause(2, ok(nativeCompare, true), 2 < 3).
clause(3, ok(nativeString, true), matches('scoped retail insight', 'retail|medical')).
clause(4, tail(nativeList, var('Tail')), [anonymous(1) | var('Tail')] = "abc").
clause(5,
       example_label(vocabularyExample, "vocabulary names are ordinary predicate names"),
       true).
clause(6, label(vocabularyExample, var('Text')), example_label(vocabularyExample, var('Text'))).

step(value(nativeMath, 1.0), rule(1), ['X' = 1.0], [1.0 is 0.125 + 0.875]).
step(1.0 is 0.125 + 0.875, builtin, [], []).
step(ok(nativeCompare, true), rule(2), [], [2 < 3]).
step(2 < 3, builtin, [], []).
step(ok(nativeString, true), rule(3), [], [matches('scoped retail insight', 'retail|medical')]).
step(matches('scoped retail insight', 'retail|medical'), builtin, [], []).
step(tail(nativeList, "bc"), rule(4), ['Tail' = "bc"], ["abc" = "abc"]).
step("abc" = "abc", builtin, [], []).
step(label(vocabularyExample, "vocabulary names are ordinary predicate names"),
     rule(6),
     ['Text' = "vocabulary names are ordinary predicate names"],
     [example_label(vocabularyExample, "vocabulary names are ordinary predicate names")]).
step(example_label(vocabularyExample, "vocabulary names are ordinary predicate names"),
     fact(5),
     [],
     []).
