% Prolog result format 4
query(1, answer(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(1, complete, 1).
answer(1, ['X0' = aggregate_min, 'X1' = 1, 'X2' = a]).
why(1, ['X0' = aggregate_min, 'X1' = 1, 'X2' = a], [answer(aggregate_min, 1, a)]).

clause(3,
       answer(aggregate_min, var('Key'), var('Value')),
       aggregate_min(var('K'), var('V'), score(var('K'), var('V')), var('Key'), var('Value'))).

step(answer(aggregate_min, 1, a),
     rule(3),
     ['Key' = 1, 'Value' = a],
     [aggregate_min(Key, Value, score(Key, Value), 1, a)]).
step(aggregate_min(Key, Value, score(Key, Value), 1, a), builtin, [], []).
