% Prolog result format 4
query(1, name(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = a, 'X1' = "Alice"]).
why(1, ['X0' = a, 'X1' = "Alice"], [name(a, "Alice")]).
query(2, log_nameOf(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = t, 'X1' = name(a, "Alice")]).
why(2, ['X0' = t, 'X1' = name(a, "Alice")], [log_nameOf(t, name(a, "Alice"))]).
query(3, statedBy(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = t, 'X1' = bob]).
why(3, ['X0' = t, 'X1' = bob], [statedBy(t, bob)]).
query(4, recorded(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4, ['X0' = t, 'X1' = "2021-07-07"]).
why(4, ['X0' = t, 'X1' = "2021-07-07"], [recorded(t, "2021-07-07")]).

clause(1, annotation(t, (name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07"))), true).
clause(2,
       context_member((var('Left'), anonymous(1)), var('Member')),
       context_member(var('Left'), var('Member'))).
clause(3,
       context_member((anonymous(1), var('Right')), var('Member')),
       context_member(var('Right'), var('Member'))).
clause(4,
       context_member(var('Member'), var('Member')),
       var('Member') \= (anonymous(1), anonymous(2))).
clause(5,
       name(var('S'), var('O')),
       (annotation(anonymous(1), var('Context')),
        context_member(var('Context'), name(var('S'), var('O'))))).
clause(6,
       log_nameOf(var('T'), name(var('S'), var('O'))),
       (annotation(var('T'), var('Context')),
        context_member(var('Context'), name(var('S'), var('O'))))).
clause(7,
       statedBy(var('S'), var('O')),
       (annotation(anonymous(1), var('Context')),
        context_member(var('Context'), statedBy(var('S'), var('O'))))).
clause(8,
       recorded(var('S'), var('O')),
       (annotation(anonymous(1), var('Context')),
        context_member(var('Context'), recorded(var('S'), var('O'))))).

step(name(a, "Alice"),
     rule(5),
     ['S' = a,
      'O' = "Alice",
      'Context' = (name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07"))],
     [annotation(t, (name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07"))),
      context_member((name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07")), name(a, "Alice"))]).
step(annotation(t, (name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07"))),
     fact(1),
     [],
     []).
step(context_member((name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07")), name(a, "Alice")),
     rule(2),
     ['Left' = name(a, "Alice"), 'Member' = name(a, "Alice")],
     [context_member(name(a, "Alice"), name(a, "Alice"))]).
step(context_member(name(a, "Alice"), name(a, "Alice")),
     rule(4),
     ['Member' = name(a, "Alice")],
     [name(a, "Alice") \= (_left, _right)]).
step(name(a, "Alice") \= (_left, _right), builtin, [], []).
step(log_nameOf(t, name(a, "Alice")),
     rule(6),
     ['T' = t,
      'S' = a,
      'O' = "Alice",
      'Context' = (name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07"))],
     [annotation(t, (name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07"))),
      context_member((name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07")), name(a, "Alice"))]).
step(statedBy(t, bob),
     rule(7),
     ['S' = t,
      'O' = bob,
      'Context' = (name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07"))],
     [annotation(t, (name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07"))),
      context_member((name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07")), statedBy(t, bob))]).
step(context_member((name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07")), statedBy(t, bob)),
     rule(3),
     ['Right' = (statedBy(t, bob), recorded(t, "2021-07-07")), 'Member' = statedBy(t, bob)],
     [context_member((statedBy(t, bob), recorded(t, "2021-07-07")), statedBy(t, bob))]).
step(context_member((statedBy(t, bob), recorded(t, "2021-07-07")), statedBy(t, bob)),
     rule(2),
     ['Left' = statedBy(t, bob), 'Member' = statedBy(t, bob)],
     [context_member(statedBy(t, bob), statedBy(t, bob))]).
step(context_member(statedBy(t, bob), statedBy(t, bob)),
     rule(4),
     ['Member' = statedBy(t, bob)],
     [statedBy(t, bob) \= (_left, _right)]).
step(statedBy(t, bob) \= (_left, _right), builtin, [], []).
step(recorded(t, "2021-07-07"),
     rule(8),
     ['S' = t,
      'O' = "2021-07-07",
      'Context' = (name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07"))],
     [annotation(t, (name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07"))),
      context_member((name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07")), recorded(t, "2021-07-07"))]).
step(context_member((name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07")), recorded(t, "2021-07-07")),
     rule(3),
     ['Right' = (statedBy(t, bob), recorded(t, "2021-07-07")),
      'Member' = recorded(t, "2021-07-07")],
     [context_member((statedBy(t, bob), recorded(t, "2021-07-07")), recorded(t, "2021-07-07"))]).
step(context_member((statedBy(t, bob), recorded(t, "2021-07-07")), recorded(t, "2021-07-07")),
     rule(3),
     ['Right' = recorded(t, "2021-07-07"), 'Member' = recorded(t, "2021-07-07")],
     [context_member(recorded(t, "2021-07-07"), recorded(t, "2021-07-07"))]).
step(context_member(recorded(t, "2021-07-07"), recorded(t, "2021-07-07")),
     rule(4),
     ['Member' = recorded(t, "2021-07-07")],
     [recorded(t, "2021-07-07") \= (_left, _right)]).
step(recorded(t, "2021-07-07") \= (_left, _right), builtin, [], []).
