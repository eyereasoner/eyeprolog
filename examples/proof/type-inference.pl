type_answer(id, fun(t0, t0)).
type_answer(const, fun(t0, fun(t1, t0))).
type_answer(apply_id, int).
type_answer(compose, fun(fun(t1, t2), fun(fun(t0, t1), fun(t0, t2)))).
type_answer(branch, int).
type_answer(first_of_pair, bool).
type_reason(compose, "application unifies f with t1 -> t2 and g with t0 -> t1").
type_reason(apply_id, "the identity function's parameter type is unified with int").

clause(1, program(id, lam(x, t0, var(x))), true).
clause(2, program(const, lam(x, t0, lam(y, t1, var(x)))), true).
clause(3, program(apply_id, app(lam(x, int, var(x)), int_lit(42))), true).
clause(4,
       program(compose, lam(f, fun(t1, t2), lam(g, fun(t0, t1), lam(x, t0, app(var(f), app(var(g), var(x))))))),
       true).
clause(5, program(branch, if(bool_lit(true), add(int_lit(20), int_lit(22)), int_lit(0))), true).
clause(6, program(first_of_pair, fst(pair(bool_lit(true), int_lit(7)))), true).
clause(7, lookup(var('Name'), [[var('Name'), var('Type')] | anonymous(1)], var('Type')), true).
clause(8,
       lookup(var('Name'), [[anonymous(1), anonymous(2)] | var('Rest')], var('Type')),
       lookup(var('Name'), var('Rest'), var('Type'))).
clause(9, type_expr(anonymous(1), int_lit(anonymous(2)), int), true).
clause(10, type_expr(anonymous(1), bool_lit(anonymous(2)), bool), true).
clause(11,
       type_expr(var('Env'), var(var('Name')), var('Type')),
       lookup(var('Name'), var('Env'), var('Type'))).
clause(12,
       type_expr(var('Env'), lam(var('Name'), var('Arg_type'), var('Body')), fun(var('Arg_type'), var('Body_type'))),
       type_expr([[var('Name'), var('Arg_type')] | var('Env')], var('Body'), var('Body_type'))).
clause(13,
       type_expr(var('Env'), app(var('Fn'), var('Arg')), var('Result_type')),
       (type_expr(var('Env'), var('Fn'), fun(var('Arg_type'), var('Result_type'))),
        type_expr(var('Env'), var('Arg'), var('Arg_type')))).
clause(14,
       type_expr(var('Env'), add(var('Left'), var('Right')), int),
       (type_expr(var('Env'), var('Left'), int), type_expr(var('Env'), var('Right'), int))).
clause(15,
       type_expr(var('Env'), if(var('Cond'), var('Then'), var('Else')), var('Type')),
       (type_expr(var('Env'), var('Cond'), bool),
        type_expr(var('Env'), var('Then'), var('Type')),
        type_expr(var('Env'), var('Else'), var('Type')))).
clause(16,
       type_expr(var('Env'), pair(var('Left'), var('Right')), pair(var('Left_type'), var('Right_type'))),
       (type_expr(var('Env'), var('Left'), var('Left_type')),
        type_expr(var('Env'), var('Right'), var('Right_type')))).
clause(17,
       type_expr(var('Env'), fst(var('Pair')), var('Left_type')),
       type_expr(var('Env'), var('Pair'), pair(var('Left_type'), anonymous(1)))).
clause(19,
       type_answer(var('Name'), var('Type')),
       (program(var('Name'), var('Expr')), type_expr([], var('Expr'), var('Type')))).
clause(20,
       type_reason(compose, "application unifies f with t1 -> t2 and g with t0 -> t1"),
       type_answer(compose, anonymous(1))).
clause(21,
       type_reason(apply_id, "the identity function's parameter type is unified with int"),
       type_answer(apply_id, int)).

step(type_answer(id, fun(t0, t0)),
     rule(19),
     ['Name' = id, 'Type' = fun(t0, t0), 'Expr' = lam(x, t0, var(x))],
     [program(id, lam(x, t0, var(x))), type_expr([], lam(x, t0, var(x)), fun(t0, t0))]).
step(program(id, lam(x, t0, var(x))), fact(1), [], []).
step(type_expr([], lam(x, t0, var(x)), fun(t0, t0)),
     rule(12),
     ['Env' = [], 'Name' = x, 'Arg_type' = t0, 'Body' = var(x), 'Body_type' = t0],
     [type_expr([[x, t0]], var(x), t0)]).
step(type_expr([[x, t0]], var(x), t0),
     rule(11),
     ['Env' = [[x, t0]], 'Name' = x, 'Type' = t0],
     [lookup(x, [[x, t0]], t0)]).
step(lookup(x, [[x, t0]], t0), fact(7), ['Name' = x, 'Type' = t0], []).
step(type_answer(const, fun(t0, fun(t1, t0))),
     rule(19),
     ['Name' = const, 'Type' = fun(t0, fun(t1, t0)), 'Expr' = lam(x, t0, lam(y, t1, var(x)))],
     [program(const, lam(x, t0, lam(y, t1, var(x)))),
      type_expr([], lam(x, t0, lam(y, t1, var(x))), fun(t0, fun(t1, t0)))]).
step(program(const, lam(x, t0, lam(y, t1, var(x)))), fact(2), [], []).
step(type_expr([], lam(x, t0, lam(y, t1, var(x))), fun(t0, fun(t1, t0))),
     rule(12),
     ['Env' = [],
      'Name' = x,
      'Arg_type' = t0,
      'Body' = lam(y, t1, var(x)),
      'Body_type' = fun(t1, t0)],
     [type_expr([[x, t0]], lam(y, t1, var(x)), fun(t1, t0))]).
step(type_expr([[x, t0]], lam(y, t1, var(x)), fun(t1, t0)),
     rule(12),
     ['Env' = [[x, t0]], 'Name' = y, 'Arg_type' = t1, 'Body' = var(x), 'Body_type' = t0],
     [type_expr([[y, t1], [x, t0]], var(x), t0)]).
step(type_expr([[y, t1], [x, t0]], var(x), t0),
     rule(11),
     ['Env' = [[y, t1], [x, t0]], 'Name' = x, 'Type' = t0],
     [lookup(x, [[y, t1], [x, t0]], t0)]).
step(lookup(x, [[y, t1], [x, t0]], t0),
     rule(8),
     ['Name' = x, 'Rest' = [[x, t0]], 'Type' = t0],
     [lookup(x, [[x, t0]], t0)]).
step(type_answer(apply_id, int),
     rule(19),
     ['Name' = apply_id, 'Type' = int, 'Expr' = app(lam(x, int, var(x)), int_lit(42))],
     [program(apply_id, app(lam(x, int, var(x)), int_lit(42))),
      type_expr([], app(lam(x, int, var(x)), int_lit(42)), int)]).
step(program(apply_id, app(lam(x, int, var(x)), int_lit(42))), fact(3), [], []).
step(type_expr([], app(lam(x, int, var(x)), int_lit(42)), int),
     rule(13),
     ['Env' = [],
      'Fn' = lam(x, int, var(x)),
      'Arg' = int_lit(42),
      'Result_type' = int,
      'Arg_type' = int],
     [type_expr([], lam(x, int, var(x)), fun(int, int)), type_expr([], int_lit(42), int)]).
step(type_expr([], lam(x, int, var(x)), fun(int, int)),
     rule(12),
     ['Env' = [], 'Name' = x, 'Arg_type' = int, 'Body' = var(x), 'Body_type' = int],
     [type_expr([[x, int]], var(x), int)]).
step(type_expr([[x, int]], var(x), int),
     rule(11),
     ['Env' = [[x, int]], 'Name' = x, 'Type' = int],
     [lookup(x, [[x, int]], int)]).
step(lookup(x, [[x, int]], int), fact(7), ['Name' = x, 'Type' = int], []).
step(type_expr([], int_lit(42), int), fact(9), [], []).
step(type_answer(compose, fun(fun(t1, t2), fun(fun(t0, t1), fun(t0, t2)))),
     rule(19),
     ['Name' = compose,
      'Type' = fun(fun(t1, t2), fun(fun(t0, t1), fun(t0, t2))),
      'Expr' = lam(f, fun(t1, t2), lam(g, fun(t0, t1), lam(x, t0, app(var(f), app(var(g), var(x))))))],
     [program(compose, lam(f, fun(t1, t2), lam(g, fun(t0, t1), lam(x, t0, app(var(f), app(var(g), var(x))))))),
      type_expr([], lam(f, fun(t1, t2), lam(g, fun(t0, t1), lam(x, t0, app(var(f), app(var(g), var(x)))))), fun(fun(t1, t2), fun(fun(t0, t1), fun(t0, t2))))]).
step(program(compose, lam(f, fun(t1, t2), lam(g, fun(t0, t1), lam(x, t0, app(var(f), app(var(g), var(x))))))),
     fact(4),
     [],
     []).
step(type_expr([], lam(f, fun(t1, t2), lam(g, fun(t0, t1), lam(x, t0, app(var(f), app(var(g), var(x)))))), fun(fun(t1, t2), fun(fun(t0, t1), fun(t0, t2)))),
     rule(12),
     ['Env' = [],
      'Name' = f,
      'Arg_type' = fun(t1, t2),
      'Body' = lam(g, fun(t0, t1), lam(x, t0, app(var(f), app(var(g), var(x))))),
      'Body_type' = fun(fun(t0, t1), fun(t0, t2))],
     [type_expr([[f, fun(t1, t2)]], lam(g, fun(t0, t1), lam(x, t0, app(var(f), app(var(g), var(x))))), fun(fun(t0, t1), fun(t0, t2)))]).
step(type_expr([[f, fun(t1, t2)]], lam(g, fun(t0, t1), lam(x, t0, app(var(f), app(var(g), var(x))))), fun(fun(t0, t1), fun(t0, t2))),
     rule(12),
     ['Env' = [[f, fun(t1, t2)]],
      'Name' = g,
      'Arg_type' = fun(t0, t1),
      'Body' = lam(x, t0, app(var(f), app(var(g), var(x)))),
      'Body_type' = fun(t0, t2)],
     [type_expr([[g, fun(t0, t1)], [f, fun(t1, t2)]], lam(x, t0, app(var(f), app(var(g), var(x)))), fun(t0, t2))]).
step(type_expr([[g, fun(t0, t1)], [f, fun(t1, t2)]], lam(x, t0, app(var(f), app(var(g), var(x)))), fun(t0, t2)),
     rule(12),
     ['Env' = [[g, fun(t0, t1)], [f, fun(t1, t2)]],
      'Name' = x,
      'Arg_type' = t0,
      'Body' = app(var(f), app(var(g), var(x))),
      'Body_type' = t2],
     [type_expr([[x, t0], [g, fun(t0, t1)], [f, fun(t1, t2)]], app(var(f), app(var(g), var(x))), t2)]).
step(type_expr([[x, t0], [g, fun(t0, t1)], [f, fun(t1, t2)]], app(var(f), app(var(g), var(x))), t2),
     rule(13),
     ['Env' = [[x, t0], [g, fun(t0, t1)], [f, fun(t1, t2)]],
      'Fn' = var(f),
      'Arg' = app(var(g), var(x)),
      'Result_type' = t2,
      'Arg_type' = t1],
     [type_expr([[x, t0], [g, fun(t0, t1)], [f, fun(t1, t2)]], var(f), fun(t1, t2)),
      type_expr([[x, t0], [g, fun(t0, t1)], [f, fun(t1, t2)]], app(var(g), var(x)), t1)]).
step(type_expr([[x, t0], [g, fun(t0, t1)], [f, fun(t1, t2)]], var(f), fun(t1, t2)),
     rule(11),
     ['Env' = [[x, t0], [g, fun(t0, t1)], [f, fun(t1, t2)]], 'Name' = f, 'Type' = fun(t1, t2)],
     [lookup(f, [[x, t0], [g, fun(t0, t1)], [f, fun(t1, t2)]], fun(t1, t2))]).
step(lookup(f, [[x, t0], [g, fun(t0, t1)], [f, fun(t1, t2)]], fun(t1, t2)),
     rule(8),
     ['Name' = f, 'Rest' = [[g, fun(t0, t1)], [f, fun(t1, t2)]], 'Type' = fun(t1, t2)],
     [lookup(f, [[g, fun(t0, t1)], [f, fun(t1, t2)]], fun(t1, t2))]).
step(lookup(f, [[g, fun(t0, t1)], [f, fun(t1, t2)]], fun(t1, t2)),
     rule(8),
     ['Name' = f, 'Rest' = [[f, fun(t1, t2)]], 'Type' = fun(t1, t2)],
     [lookup(f, [[f, fun(t1, t2)]], fun(t1, t2))]).
step(lookup(f, [[f, fun(t1, t2)]], fun(t1, t2)),
     fact(7),
     ['Name' = f, 'Type' = fun(t1, t2)],
     []).
step(type_expr([[x, t0], [g, fun(t0, t1)], [f, fun(t1, t2)]], app(var(g), var(x)), t1),
     rule(13),
     ['Env' = [[x, t0], [g, fun(t0, t1)], [f, fun(t1, t2)]],
      'Fn' = var(g),
      'Arg' = var(x),
      'Result_type' = t1,
      'Arg_type' = t0],
     [type_expr([[x, t0], [g, fun(t0, t1)], [f, fun(t1, t2)]], var(g), fun(t0, t1)),
      type_expr([[x, t0], [g, fun(t0, t1)], [f, fun(t1, t2)]], var(x), t0)]).
step(type_expr([[x, t0], [g, fun(t0, t1)], [f, fun(t1, t2)]], var(g), fun(t0, t1)),
     rule(11),
     ['Env' = [[x, t0], [g, fun(t0, t1)], [f, fun(t1, t2)]], 'Name' = g, 'Type' = fun(t0, t1)],
     [lookup(g, [[x, t0], [g, fun(t0, t1)], [f, fun(t1, t2)]], fun(t0, t1))]).
step(lookup(g, [[x, t0], [g, fun(t0, t1)], [f, fun(t1, t2)]], fun(t0, t1)),
     rule(8),
     ['Name' = g, 'Rest' = [[g, fun(t0, t1)], [f, fun(t1, t2)]], 'Type' = fun(t0, t1)],
     [lookup(g, [[g, fun(t0, t1)], [f, fun(t1, t2)]], fun(t0, t1))]).
step(lookup(g, [[g, fun(t0, t1)], [f, fun(t1, t2)]], fun(t0, t1)),
     fact(7),
     ['Name' = g, 'Type' = fun(t0, t1)],
     []).
step(type_expr([[x, t0], [g, fun(t0, t1)], [f, fun(t1, t2)]], var(x), t0),
     rule(11),
     ['Env' = [[x, t0], [g, fun(t0, t1)], [f, fun(t1, t2)]], 'Name' = x, 'Type' = t0],
     [lookup(x, [[x, t0], [g, fun(t0, t1)], [f, fun(t1, t2)]], t0)]).
step(lookup(x, [[x, t0], [g, fun(t0, t1)], [f, fun(t1, t2)]], t0),
     fact(7),
     ['Name' = x, 'Type' = t0],
     []).
step(type_answer(branch, int),
     rule(19),
     ['Name' = branch,
      'Type' = int,
      'Expr' = if(bool_lit(true), add(int_lit(20), int_lit(22)), int_lit(0))],
     [program(branch, if(bool_lit(true), add(int_lit(20), int_lit(22)), int_lit(0))),
      type_expr([], if(bool_lit(true), add(int_lit(20), int_lit(22)), int_lit(0)), int)]).
step(program(branch, if(bool_lit(true), add(int_lit(20), int_lit(22)), int_lit(0))),
     fact(5),
     [],
     []).
step(type_expr([], if(bool_lit(true), add(int_lit(20), int_lit(22)), int_lit(0)), int),
     rule(15),
     ['Env' = [],
      'Cond' = bool_lit(true),
      'Then' = add(int_lit(20), int_lit(22)),
      'Else' = int_lit(0),
      'Type' = int],
     [type_expr([], bool_lit(true), bool),
      type_expr([], add(int_lit(20), int_lit(22)), int),
      type_expr([], int_lit(0), int)]).
step(type_expr([], bool_lit(true), bool), fact(10), [], []).
step(type_expr([], add(int_lit(20), int_lit(22)), int),
     rule(14),
     ['Env' = [], 'Left' = int_lit(20), 'Right' = int_lit(22)],
     [type_expr([], int_lit(20), int), type_expr([], int_lit(22), int)]).
step(type_expr([], int_lit(20), int), fact(9), [], []).
step(type_expr([], int_lit(22), int), fact(9), [], []).
step(type_expr([], int_lit(0), int), fact(9), [], []).
step(type_answer(first_of_pair, bool),
     rule(19),
     ['Name' = first_of_pair, 'Type' = bool, 'Expr' = fst(pair(bool_lit(true), int_lit(7)))],
     [program(first_of_pair, fst(pair(bool_lit(true), int_lit(7)))),
      type_expr([], fst(pair(bool_lit(true), int_lit(7))), bool)]).
step(program(first_of_pair, fst(pair(bool_lit(true), int_lit(7)))), fact(6), [], []).
step(type_expr([], fst(pair(bool_lit(true), int_lit(7))), bool),
     rule(17),
     ['Env' = [], 'Pair' = pair(bool_lit(true), int_lit(7)), 'Left_type' = bool],
     [type_expr([], pair(bool_lit(true), int_lit(7)), pair(bool, int))]).
step(type_expr([], pair(bool_lit(true), int_lit(7)), pair(bool, int)),
     rule(16),
     ['Env' = [],
      'Left' = bool_lit(true),
      'Right' = int_lit(7),
      'Left_type' = bool,
      'Right_type' = int],
     [type_expr([], bool_lit(true), bool), type_expr([], int_lit(7), int)]).
step(type_expr([], int_lit(7), int), fact(9), [], []).
step(type_reason(compose, "application unifies f with t1 -> t2 and g with t0 -> t1"),
     rule(20),
     [],
     [type_answer(compose, fun(fun(t1, t2), fun(fun(t0, t1), fun(t0, t2))))]).
step(type_reason(apply_id, "the identity function's parameter type is unified with int"),
     rule(21),
     [],
     [type_answer(apply_id, int)]).
