% Prolog result format 4
query(1, answer(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(1, complete, 1).
answer(1, ['X0' = [[] - "abc", "a" - "bc", "ab" - "c", "abc" - []], 'X1' = 4, 'X2' = true]).
why(1,
    ['X0' = [[] - "abc", "a" - "bc", "ab" - "c", "abc" - []], 'X1' = 4, 'X2' = true],
    [answer([[] - "abc", "a" - "bc", "ab" - "c", "abc" - []], 4, true)]).

clause(1,
       answer(var('AllSplitsOfBoundList'), var('SplitCount'), var('FoundFirstSplitOfUnboundList')),
       (findall(var('X') - var('Y'), append(var('X'), var('Y'), "abc"), var('AllSplitsOfBoundList')),
        length(var('AllSplitsOfBoundList'), var('SplitCount')),
        once((append(var('X2'), anonymous(1), anonymous(2)), var('X2') == [])),
        var('FoundFirstSplitOfUnboundList') = true)).

step(answer([[] - "abc", "a" - "bc", "ab" - "c", "abc" - []], 4, true),
     rule(1),
     ['AllSplitsOfBoundList' = [[] - "abc", "a" - "bc", "ab" - "c", "abc" - []],
      'SplitCount' = 4,
      'FoundFirstSplitOfUnboundList' = true,
      'X2' = []],
     [findall(X - Y, append(X, Y, "abc"), [[] - "abc", "a" - "bc", "ab" - "c", "abc" - []]),
      length([[] - "abc", "a" - "bc", "ab" - "c", "abc" - []], 4),
      once((append([], Ys, Ys), [] == [])),
      true = true]).
step(findall(X - Y, append(X, Y, "abc"), [[] - "abc", "a" - "bc", "ab" - "c", "abc" - []]),
     collected,
     [],
     []).
step(length([[] - "abc", "a" - "bc", "ab" - "c", "abc" - []], 4), builtin, [], []).
step(once((append([], Ys, Ys), [] == [])), builtin, [], [append([], Ys, Ys), [] == []]).
step(append([], Ys, Ys), builtin, [], []).
step([] == [], builtin, [], []).
step(true = true, builtin, [], []).
