review_quorum(selection(alice(0), bob(0), carol(1), dan(1))).
review_quorum(selection(alice(0), bob(1), carol(1), dan(0))).
review_quorum_count(2).

clause(1,
       review_constraints(var('Alice'), var('Bob'), var('Carol'), var('Dan')),
       sat(card([2], [var('Alice'), var('Bob'), var('Carol'), var('Dan')]) * (var('Alice') =< var('Carol')) * (var('Bob') # var('Dan')))).
clause(2,
       review_quorum(selection(alice(var('Alice')), bob(var('Bob')), carol(var('Carol')), dan(var('Dan')))),
       (review_constraints(var('Alice'), var('Bob'), var('Carol'), var('Dan')),
        labeling([var('Alice'), var('Bob'), var('Carol'), var('Dan')]))).
clause(3,
       review_quorum_count(var('Count')),
       sat_count(card([2], [var('Alice'), var('Bob'), var('Carol'), var('Dan')]) * (var('Alice') =< var('Carol')) * (var('Bob') # var('Dan')), var('Count'))).

step(review_quorum(selection(alice(0), bob(0), carol(1), dan(1))),
     rule(2),
     ['Alice' = 0, 'Bob' = 0, 'Carol' = 1, 'Dan' = 1],
     [review_constraints(0, 0, 1, 1), labeling([0, 0, 1, 1])]).
step(review_constraints(0, 0, 1, 1),
     rule(1),
     ['Alice' = 0, 'Bob' = 0, 'Carol' = 1, 'Dan' = 1],
     [sat(card([2], [0, 0, 1, 1]) * (0 =< 1) * (0 # 1))]).
step(sat(card([2], [0, 0, 1, 1]) * (0 =< 1) * (0 # 1)), builtin, [], []).
step(labeling([0, 0, 1, 1]), builtin, [], []).
step(review_quorum(selection(alice(0), bob(1), carol(1), dan(0))),
     rule(2),
     ['Alice' = 0, 'Bob' = 1, 'Carol' = 1, 'Dan' = 0],
     [review_constraints(0, 1, 1, 0), labeling([0, 1, 1, 0])]).
step(review_constraints(0, 1, 1, 0),
     rule(1),
     ['Alice' = 0, 'Bob' = 1, 'Carol' = 1, 'Dan' = 0],
     [sat(card([2], [0, 1, 1, 0]) * (0 =< 1) * (1 # 0))]).
step(sat(card([2], [0, 1, 1, 0]) * (0 =< 1) * (1 # 0)), builtin, [], []).
step(labeling([0, 1, 1, 0]), builtin, [], []).
step(review_quorum_count(2),
     rule(3),
     ['Count' = 2],
     [sat_count(card([2], [Alice, Bob, Carol, Dan]) * (Alice =< Carol) * (Bob # Dan), 2)]).
step(sat_count(card([2], [Alice, Bob, Carol, Dan]) * (Alice =< Carol) * (Bob # Dan), 2),
     builtin,
     [],
     []).
