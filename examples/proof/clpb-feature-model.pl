% Prolog result format 4
query(1, feature_plan(_0), ['X0' = _0]).
result(1, complete, 4).
answer(1, ['X0' = features(cloud(0), edge(1), audit(1), encryption(1))]).
why(1,
    ['X0' = features(cloud(0), edge(1), audit(1), encryption(1))],
    [feature_plan(features(cloud(0), edge(1), audit(1), encryption(1)))]).
answer(1, ['X0' = features(cloud(1), edge(0), audit(0), encryption(0))]).
why(1,
    ['X0' = features(cloud(1), edge(0), audit(0), encryption(0))],
    [feature_plan(features(cloud(1), edge(0), audit(0), encryption(0)))]).
answer(1, ['X0' = features(cloud(1), edge(0), audit(0), encryption(1))]).
why(1,
    ['X0' = features(cloud(1), edge(0), audit(0), encryption(1))],
    [feature_plan(features(cloud(1), edge(0), audit(0), encryption(1)))]).
answer(1, ['X0' = features(cloud(1), edge(0), audit(1), encryption(1))]).
why(1,
    ['X0' = features(cloud(1), edge(0), audit(1), encryption(1))],
    [feature_plan(features(cloud(1), edge(0), audit(1), encryption(1)))]).
query(2, feature_plan_count(_0), ['X0' = _0]).
result(2, complete, 1).
answer(2, ['X0' = 4]).
why(2, ['X0' = 4], [feature_plan_count(4)]).

clause(1,
       feature_constraints(var('Cloud'), var('Edge'), var('Audit'), var('Encryption')),
       sat((var('Cloud') # var('Edge')) * (var('Audit') =< var('Encryption')) * (var('Edge') =< var('Audit')))).
clause(2,
       feature_plan(features(cloud(var('Cloud')), edge(var('Edge')), audit(var('Audit')), encryption(var('Encryption')))),
       (feature_constraints(var('Cloud'), var('Edge'), var('Audit'), var('Encryption')),
        labeling([var('Cloud'), var('Edge'), var('Audit'), var('Encryption')]))).

step(feature_plan(features(cloud(0), edge(1), audit(1), encryption(1))),
     rule(2),
     ['Cloud' = 0, 'Edge' = 1, 'Audit' = 1, 'Encryption' = 1],
     [feature_constraints(0, 1, 1, 1), labeling([0, 1, 1, 1])]).
step(feature_constraints(0, 1, 1, 1),
     rule(1),
     ['Cloud' = 0, 'Edge' = 1, 'Audit' = 1, 'Encryption' = 1],
     [sat((0 # 1) * (1 =< 1) * (1 =< 1))]).
step(sat((0 # 1) * (1 =< 1) * (1 =< 1)), builtin, [], []).
step(labeling([0, 1, 1, 1]), builtin, [], []).
step(feature_plan(features(cloud(1), edge(0), audit(0), encryption(0))),
     rule(2),
     ['Cloud' = 1, 'Edge' = 0, 'Audit' = 0, 'Encryption' = 0],
     [feature_constraints(1, 0, 0, 0), labeling([1, 0, 0, 0])]).
step(feature_constraints(1, 0, 0, 0),
     rule(1),
     ['Cloud' = 1, 'Edge' = 0, 'Audit' = 0, 'Encryption' = 0],
     [sat((1 # 0) * (0 =< 0) * (0 =< 0))]).
step(sat((1 # 0) * (0 =< 0) * (0 =< 0)), builtin, [], []).
step(labeling([1, 0, 0, 0]), builtin, [], []).
step(feature_plan(features(cloud(1), edge(0), audit(0), encryption(1))),
     rule(2),
     ['Cloud' = 1, 'Edge' = 0, 'Audit' = 0, 'Encryption' = 1],
     [feature_constraints(1, 0, 0, 1), labeling([1, 0, 0, 1])]).
step(feature_constraints(1, 0, 0, 1),
     rule(1),
     ['Cloud' = 1, 'Edge' = 0, 'Audit' = 0, 'Encryption' = 1],
     [sat((1 # 0) * (0 =< 1) * (0 =< 0))]).
step(sat((1 # 0) * (0 =< 1) * (0 =< 0)), builtin, [], []).
step(labeling([1, 0, 0, 1]), builtin, [], []).
step(feature_plan(features(cloud(1), edge(0), audit(1), encryption(1))),
     rule(2),
     ['Cloud' = 1, 'Edge' = 0, 'Audit' = 1, 'Encryption' = 1],
     [feature_constraints(1, 0, 1, 1), labeling([1, 0, 1, 1])]).
step(feature_constraints(1, 0, 1, 1),
     rule(1),
     ['Cloud' = 1, 'Edge' = 0, 'Audit' = 1, 'Encryption' = 1],
     [sat((1 # 0) * (1 =< 1) * (0 =< 1))]).
step(sat((1 # 0) * (1 =< 1) * (0 =< 1)), builtin, [], []).
step(labeling([1, 0, 1, 1]), builtin, [], []).
step(feature_plan_count(4), unproven, [], []).
