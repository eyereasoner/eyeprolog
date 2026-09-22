% Prolog result format 4
query(1, stable_marriage_answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 2).
answer(1,
       ['X0' = first_stable_matching,
        'X1' = [pair(adam, bea), pair(brian, dana), pair(cole, amy), pair(drew, cora)]]).
why(1,
    ['X0' = first_stable_matching,
     'X1' = [pair(adam, bea), pair(brian, dana), pair(cole, amy), pair(drew, cora)]],
    [stable_marriage_answer(first_stable_matching, [pair(adam, bea), pair(brian, dana), pair(cole, amy), pair(drew, cora)])]).
answer(1, ['X0' = stable_matching_count, 'X1' = 1]).
why(1,
    ['X0' = stable_matching_count, 'X1' = 1],
    [stable_marriage_answer(stable_matching_count, 1)]).

clause(41, perm([], []), true).
clause(42,
       perm(var('Items'), [var('X') | var('Rest')]),
       (select(var('X'), var('Items'), var('Remaining')), perm(var('Remaining'), var('Rest')))).
clause(43,
       matching([pair(adam, var('W1')), pair(brian, var('W2')), pair(cole, var('W3')), pair(drew, var('W4'))]),
       perm([amy, bea, cora, dana], [var('W1'), var('W2'), var('W3'), var('W4')])).
clause(48,
       stable_matching(var('Matching')),
       (matching(var('Matching')),
        \+ blocking_pair(var('Matching'), anonymous(1), anonymous(2)))).
clause(49,
       stable_marriage_answer(first_stable_matching, var('Matching')),
       once(stable_matching(var('Matching')))).
clause(50,
       stable_marriage_answer(stable_matching_count, var('Count')),
       countall(stable_matching(anonymous(1)), var('Count'))).

step(stable_marriage_answer(first_stable_matching, [pair(adam, bea), pair(brian, dana), pair(cole, amy), pair(drew, cora)]),
     rule(49),
     ['Matching' = [pair(adam, bea), pair(brian, dana), pair(cole, amy), pair(drew, cora)]],
     [once(stable_matching([pair(adam, bea), pair(brian, dana), pair(cole, amy), pair(drew, cora)]))]).
step(once(stable_matching([pair(adam, bea), pair(brian, dana), pair(cole, amy), pair(drew, cora)])),
     builtin,
     [],
     [stable_matching([pair(adam, bea), pair(brian, dana), pair(cole, amy), pair(drew, cora)])]).
step(stable_matching([pair(adam, bea), pair(brian, dana), pair(cole, amy), pair(drew, cora)]),
     rule(48),
     ['Matching' = [pair(adam, bea), pair(brian, dana), pair(cole, amy), pair(drew, cora)]],
     [matching([pair(adam, bea), pair(brian, dana), pair(cole, amy), pair(drew, cora)]),
      \+ blocking_pair([pair(adam, bea), pair(brian, dana), pair(cole, amy), pair(drew, cora)], _man, _woman)]).
step(matching([pair(adam, bea), pair(brian, dana), pair(cole, amy), pair(drew, cora)]),
     rule(43),
     ['W1' = bea, 'W2' = dana, 'W3' = amy, 'W4' = cora],
     [perm([amy, bea, cora, dana], [bea, dana, amy, cora])]).
step(perm([amy, bea, cora, dana], [bea, dana, amy, cora]),
     rule(42),
     ['Items' = [amy, bea, cora, dana],
      'X' = bea,
      'Rest' = [dana, amy, cora],
      'Remaining' = [amy, cora, dana]],
     [select(bea, [amy, bea, cora, dana], [amy, cora, dana]),
      perm([amy, cora, dana], [dana, amy, cora])]).
step(select(bea, [amy, bea, cora, dana], [amy, cora, dana]), builtin, [], []).
step(perm([amy, cora, dana], [dana, amy, cora]),
     rule(42),
     ['Items' = [amy, cora, dana], 'X' = dana, 'Rest' = [amy, cora], 'Remaining' = [amy, cora]],
     [select(dana, [amy, cora, dana], [amy, cora]), perm([amy, cora], [amy, cora])]).
step(select(dana, [amy, cora, dana], [amy, cora]), builtin, [], []).
step(perm([amy, cora], [amy, cora]),
     rule(42),
     ['Items' = [amy, cora], 'X' = amy, 'Rest' = [cora], 'Remaining' = [cora]],
     [select(amy, [amy, cora], [cora]), perm([cora], [cora])]).
step(select(amy, [amy, cora], [cora]), builtin, [], []).
step(perm([cora], [cora]),
     rule(42),
     ['Items' = [cora], 'X' = cora, 'Rest' = [], 'Remaining' = []],
     [select(cora, [cora], []), perm([], [])]).
step(select(cora, [cora], []), builtin, [], []).
step(perm([], []), fact(41), [], []).
step(\+ blocking_pair([pair(adam, bea), pair(brian, dana), pair(cole, amy), pair(drew, cora)], _man, _woman),
     absent,
     [],
     []).
step(stable_marriage_answer(stable_matching_count, 1),
     rule(50),
     ['Count' = 1],
     [countall(stable_matching(_matching), 1)]).
step(countall(stable_matching(_matching), 1), builtin, [], []).
