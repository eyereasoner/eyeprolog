answer(aggregate_min, 1, a).

clause(3,
       answer(aggregate_min, var('Key'), var('Value')),
       aggregate_min(var('K'), var('V'), score(var('K'), var('V')), var('Key'), var('Value'))).

step(answer(aggregate_min, 1, a),
     rule(3),
     ['Key' = 1, 'Value' = a],
     [aggregate_min(Key, Value, score(Key, Value), 1, a)]).
step(aggregate_min(Key, Value, score(Key, Value), 1, a), builtin, [], []).
