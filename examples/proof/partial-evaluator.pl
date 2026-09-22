% Prolog result format 4
query(1, partialEvalAnswer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 4).
answer(1, ['X0' = residual(poly_y), 'X1' = add(mul(const(10), var(y)), const(13))]).
why(1,
    ['X0' = residual(poly_y), 'X1' = add(mul(const(10), var(y)), const(13))],
    [partialEvalAnswer(residual(poly_y), add(mul(const(10), var(y)), const(13)))]).
answer(1, ['X0' = residual(static_branch), 'X1' = const(11)]).
why(1,
    ['X0' = residual(static_branch), 'X1' = const(11)],
    [partialEvalAnswer(residual(static_branch), const(11))]).
answer(1,
       ['X0' = residual(dynamic_branch), 'X1' = if(var(flag), const(11), mul(var(y), const(2)))]).
why(1,
    ['X0' = residual(dynamic_branch), 'X1' = if(var(flag), const(11), mul(var(y), const(2)))],
    [partialEvalAnswer(residual(dynamic_branch), if(var(flag), const(11), mul(var(y), const(2))))]).
answer(1,
       ['X0' = note,
        'X1' = "static inputs are folded while dynamic variables remain as residual code"]).
why(1,
    ['X0' = note,
     'X1' = "static inputs are folded while dynamic variables remain as residual code"],
    [partialEvalAnswer(note, "static inputs are folded while dynamic variables remain as residual code")]).

clause(1,
       program(poly_y, add(mul(var(x), var(y)), add(var(x), const(3))), [bind(x, const(10))]),
       true).
clause(2,
       program(static_branch, if(bool(true), add(var(x), const(1)), mul(var(y), const(999))), [bind(x, const(10))]),
       true).
clause(3,
       program(dynamic_branch, if(var(flag), add(var(x), const(1)), mul(var(y), const(2))), [bind(x, const(10))]),
       true).
clause(4,
       lookup(var('Name'), [bind(var('Name'), var('Value')) | anonymous(1)], var('Value')),
       true).
clause(6,
       known_var(var('Env'), var('Name'), var('Value')),
       lookup(var('Name'), var('Env'), var('Value'))).
clause(7,
       unknown_var(var('Env'), var('Name')),
       \+ known_var(var('Env'), var('Name'), anonymous(1))).
clause(8, pe(anonymous(1), const(var('N')), const(var('N'))), true).
clause(9, pe(anonymous(1), bool(var('B')), bool(var('B'))), true).
clause(10,
       pe(var('Env'), var(var('Name')), var('Value')),
       known_var(var('Env'), var('Name'), var('Value'))).
clause(11,
       pe(var('Env'), var(var('Name')), var(var('Name'))),
       unknown_var(var('Env'), var('Name'))).
clause(12,
       pe(var('Env'), add(var('Left'), var('Right')), const(var('Sum'))),
       (pe(var('Env'), var('Left'), const(var('A'))),
        pe(var('Env'), var('Right'), const(var('B'))),
        var('Sum') is var('A') + var('B'))).
clause(14,
       pe(var('Env'), add(var('Left'), var('Right')), add(var('Left_residual'), var('Right_residual'))),
       (pe(var('Env'), var('Left'), var('Left_residual')),
        pe(var('Env'), var('Right'), var('Right_residual')),
        \+ (var('Left_residual') = const(anonymous(1)), var('Right_residual') = const(anonymous(2))))).
clause(15,
       pe(var('Env'), mul(var('Left'), var('Right')), mul(var('Left_residual'), var('Right_residual'))),
       (pe(var('Env'), var('Left'), var('Left_residual')),
        pe(var('Env'), var('Right'), var('Right_residual')),
        \+ (var('Left_residual') = const(anonymous(1)), var('Right_residual') = const(anonymous(2))))).
clause(16,
       pe(var('Env'), if(var('Cond'), var('Then'), anonymous(1)), var('Residual')),
       (pe(var('Env'), var('Cond'), bool(true)), pe(var('Env'), var('Then'), var('Residual')))).
clause(18,
       pe(var('Env'), if(var('Cond'), var('Then'), var('Else')), if(var('Cond_residual'), var('Then_residual'), var('Else_residual'))),
       (pe(var('Env'), var('Cond'), var('Cond_residual')),
        \+ var('Cond_residual') = bool(true),
        \+ var('Cond_residual') = bool(false),
        pe(var('Env'), var('Then'), var('Then_residual')),
        pe(var('Env'), var('Else'), var('Else_residual')))).
clause(19,
       residual_program(var('Name'), var('Residual')),
       (program(var('Name'), var('Expr'), var('Env')),
        pe(var('Env'), var('Expr'), var('Residual')))).
clause(20,
       partialEvalAnswer(residual(var('Name')), var('Residual')),
       residual_program(var('Name'), var('Residual'))).
clause(21,
       partialEvalAnswer(note, "static inputs are folded while dynamic variables remain as residual code"),
       residual_program(poly_y, anonymous(1))).

step(partialEvalAnswer(residual(poly_y), add(mul(const(10), var(y)), const(13))),
     rule(20),
     ['Name' = poly_y, 'Residual' = add(mul(const(10), var(y)), const(13))],
     [residual_program(poly_y, add(mul(const(10), var(y)), const(13)))]).
step(residual_program(poly_y, add(mul(const(10), var(y)), const(13))),
     rule(19),
     ['Name' = poly_y,
      'Residual' = add(mul(const(10), var(y)), const(13)),
      'Expr' = add(mul(var(x), var(y)), add(var(x), const(3))),
      'Env' = [bind(x, const(10))]],
     [program(poly_y, add(mul(var(x), var(y)), add(var(x), const(3))), [bind(x, const(10))]),
      pe([bind(x, const(10))], add(mul(var(x), var(y)), add(var(x), const(3))), add(mul(const(10), var(y)), const(13)))]).
step(program(poly_y, add(mul(var(x), var(y)), add(var(x), const(3))), [bind(x, const(10))]),
     fact(1),
     [],
     []).
step(pe([bind(x, const(10))], add(mul(var(x), var(y)), add(var(x), const(3))), add(mul(const(10), var(y)), const(13))),
     rule(14),
     ['Env' = [bind(x, const(10))],
      'Left' = mul(var(x), var(y)),
      'Right' = add(var(x), const(3)),
      'Left_residual' = mul(const(10), var(y)),
      'Right_residual' = const(13)],
     [pe([bind(x, const(10))], mul(var(x), var(y)), mul(const(10), var(y))),
      pe([bind(x, const(10))], add(var(x), const(3)), const(13)),
      \+ (mul(const(10), var(y)) = const(_A), const(13) = const(_B))]).
step(pe([bind(x, const(10))], mul(var(x), var(y)), mul(const(10), var(y))),
     rule(15),
     ['Env' = [bind(x, const(10))],
      'Left' = var(x),
      'Right' = var(y),
      'Left_residual' = const(10),
      'Right_residual' = var(y)],
     [pe([bind(x, const(10))], var(x), const(10)),
      pe([bind(x, const(10))], var(y), var(y)),
      \+ (const(10) = const(_A), var(y) = const(_B))]).
step(pe([bind(x, const(10))], var(x), const(10)),
     rule(10),
     ['Env' = [bind(x, const(10))], 'Name' = x, 'Value' = const(10)],
     [known_var([bind(x, const(10))], x, const(10))]).
step(known_var([bind(x, const(10))], x, const(10)),
     rule(6),
     ['Env' = [bind(x, const(10))], 'Name' = x, 'Value' = const(10)],
     [lookup(x, [bind(x, const(10))], const(10))]).
step(lookup(x, [bind(x, const(10))], const(10)), fact(4), ['Name' = x, 'Value' = const(10)], []).
step(pe([bind(x, const(10))], var(y), var(y)),
     rule(11),
     ['Env' = [bind(x, const(10))], 'Name' = y],
     [unknown_var([bind(x, const(10))], y)]).
step(unknown_var([bind(x, const(10))], y),
     rule(7),
     ['Env' = [bind(x, const(10))], 'Name' = y],
     [\+ known_var([bind(x, const(10))], y, __anon3)]).
step(\+ known_var([bind(x, const(10))], y, __anon3), absent, [], []).
step(\+ (const(10) = const(_A), var(y) = const(_B)), absent, [], []).
step(pe([bind(x, const(10))], add(var(x), const(3)), const(13)),
     rule(12),
     ['Env' = [bind(x, const(10))],
      'Left' = var(x),
      'Right' = const(3),
      'Sum' = 13,
      'A' = 10,
      'B' = 3],
     [pe([bind(x, const(10))], var(x), const(10)),
      pe([bind(x, const(10))], const(3), const(3)),
      13 is 10 + 3]).
step(pe([bind(x, const(10))], const(3), const(3)), fact(8), ['N' = 3], []).
step(13 is 10 + 3, builtin, [], []).
step(\+ (mul(const(10), var(y)) = const(_A), const(13) = const(_B)), absent, [], []).
step(partialEvalAnswer(residual(static_branch), const(11)),
     rule(20),
     ['Name' = static_branch, 'Residual' = const(11)],
     [residual_program(static_branch, const(11))]).
step(residual_program(static_branch, const(11)),
     rule(19),
     ['Name' = static_branch,
      'Residual' = const(11),
      'Expr' = if(bool(true), add(var(x), const(1)), mul(var(y), const(999))),
      'Env' = [bind(x, const(10))]],
     [program(static_branch, if(bool(true), add(var(x), const(1)), mul(var(y), const(999))), [bind(x, const(10))]),
      pe([bind(x, const(10))], if(bool(true), add(var(x), const(1)), mul(var(y), const(999))), const(11))]).
step(program(static_branch, if(bool(true), add(var(x), const(1)), mul(var(y), const(999))), [bind(x, const(10))]),
     fact(2),
     [],
     []).
step(pe([bind(x, const(10))], if(bool(true), add(var(x), const(1)), mul(var(y), const(999))), const(11)),
     rule(16),
     ['Env' = [bind(x, const(10))],
      'Cond' = bool(true),
      'Then' = add(var(x), const(1)),
      'Residual' = const(11)],
     [pe([bind(x, const(10))], bool(true), bool(true)),
      pe([bind(x, const(10))], add(var(x), const(1)), const(11))]).
step(pe([bind(x, const(10))], bool(true), bool(true)), fact(9), ['B' = true], []).
step(pe([bind(x, const(10))], add(var(x), const(1)), const(11)),
     rule(12),
     ['Env' = [bind(x, const(10))],
      'Left' = var(x),
      'Right' = const(1),
      'Sum' = 11,
      'A' = 10,
      'B' = 1],
     [pe([bind(x, const(10))], var(x), const(10)),
      pe([bind(x, const(10))], const(1), const(1)),
      11 is 10 + 1]).
step(pe([bind(x, const(10))], const(1), const(1)), fact(8), ['N' = 1], []).
step(11 is 10 + 1, builtin, [], []).
step(partialEvalAnswer(residual(dynamic_branch), if(var(flag), const(11), mul(var(y), const(2)))),
     rule(20),
     ['Name' = dynamic_branch, 'Residual' = if(var(flag), const(11), mul(var(y), const(2)))],
     [residual_program(dynamic_branch, if(var(flag), const(11), mul(var(y), const(2))))]).
step(residual_program(dynamic_branch, if(var(flag), const(11), mul(var(y), const(2)))),
     rule(19),
     ['Name' = dynamic_branch,
      'Residual' = if(var(flag), const(11), mul(var(y), const(2))),
      'Expr' = if(var(flag), add(var(x), const(1)), mul(var(y), const(2))),
      'Env' = [bind(x, const(10))]],
     [program(dynamic_branch, if(var(flag), add(var(x), const(1)), mul(var(y), const(2))), [bind(x, const(10))]),
      pe([bind(x, const(10))], if(var(flag), add(var(x), const(1)), mul(var(y), const(2))), if(var(flag), const(11), mul(var(y), const(2))))]).
step(program(dynamic_branch, if(var(flag), add(var(x), const(1)), mul(var(y), const(2))), [bind(x, const(10))]),
     fact(3),
     [],
     []).
step(pe([bind(x, const(10))], if(var(flag), add(var(x), const(1)), mul(var(y), const(2))), if(var(flag), const(11), mul(var(y), const(2)))),
     rule(18),
     ['Env' = [bind(x, const(10))],
      'Cond' = var(flag),
      'Then' = add(var(x), const(1)),
      'Else' = mul(var(y), const(2)),
      'Cond_residual' = var(flag),
      'Then_residual' = const(11),
      'Else_residual' = mul(var(y), const(2))],
     [pe([bind(x, const(10))], var(flag), var(flag)),
      \+ var(flag) = bool(true),
      \+ var(flag) = bool(false),
      pe([bind(x, const(10))], add(var(x), const(1)), const(11)),
      pe([bind(x, const(10))], mul(var(y), const(2)), mul(var(y), const(2)))]).
step(pe([bind(x, const(10))], var(flag), var(flag)),
     rule(11),
     ['Env' = [bind(x, const(10))], 'Name' = flag],
     [unknown_var([bind(x, const(10))], flag)]).
step(unknown_var([bind(x, const(10))], flag),
     rule(7),
     ['Env' = [bind(x, const(10))], 'Name' = flag],
     [\+ known_var([bind(x, const(10))], flag, __anon3)]).
step(\+ known_var([bind(x, const(10))], flag, __anon3), absent, [], []).
step(\+ var(flag) = bool(true), absent, [], []).
step(\+ var(flag) = bool(false), absent, [], []).
step(pe([bind(x, const(10))], mul(var(y), const(2)), mul(var(y), const(2))),
     rule(15),
     ['Env' = [bind(x, const(10))],
      'Left' = var(y),
      'Right' = const(2),
      'Left_residual' = var(y),
      'Right_residual' = const(2)],
     [pe([bind(x, const(10))], var(y), var(y)),
      pe([bind(x, const(10))], const(2), const(2)),
      \+ (var(y) = const(_A), const(2) = const(_B))]).
step(pe([bind(x, const(10))], const(2), const(2)), fact(8), ['N' = 2], []).
step(\+ (var(y) = const(_A), const(2) = const(_B)), absent, [], []).
step(partialEvalAnswer(note, "static inputs are folded while dynamic variables remain as residual code"),
     rule(21),
     [],
     [residual_program(poly_y, add(mul(const(10), var(y)), const(13)))]).
