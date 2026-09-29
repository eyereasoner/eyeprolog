dcg_expression_example(parsed, add(lit(2), mul(lit(3), sub(lit(4), lit(1))))).
dcg_expression_example(evaluated, 19).
dcg_expression_example(round_trip, [20, -, '(', 5, -, 3, ')']).
dcg_expression_example(remainder, [then, stop]).
dcg_expression_example(rejected, malformed_parentheses).

clause(17, evaluate(lit(var('Number')), anonymous(1), var('Number')), true).
clause(18,
       evaluate(var(var('Name')), var('Environment'), var('Value')),
       lookup(var('Name'), var('Environment'), var('Value'))).
clause(20,
       evaluate(add(var('Left'), var('Right')), var('Environment'), var('Value')),
       (evaluate(var('Left'), var('Environment'), var('L')),
        evaluate(var('Right'), var('Environment'), var('R')),
        var('Value') is var('L') + var('R'))).
clause(21,
       evaluate(sub(var('Left'), var('Right')), var('Environment'), var('Value')),
       (evaluate(var('Left'), var('Environment'), var('L')),
        evaluate(var('Right'), var('Environment'), var('R')),
        var('Value') is var('L') - var('R'))).
clause(22,
       evaluate(mul(var('Left'), var('Right')), var('Environment'), var('Value')),
       (evaluate(var('Left'), var('Environment'), var('L')),
        evaluate(var('Right'), var('Environment'), var('R')),
        var('Value') is var('L') * var('R'))).
clause(24, lookup(var('Name'), [var('Name') - var('Value') | anonymous(1)], var('Value')), true).
clause(25,
       lookup(var('Name'), [anonymous(1) | var('Rest')], var('Value')),
       lookup(var('Name'), var('Rest'), var('Value'))).
clause(46,
       dcg_expression_example(parsed, var('AST')),
       phrase(expression(var('AST')), [2, +, 3, *, '(', 4, -, 1, ')'])).
clause(47,
       dcg_expression_example(evaluated, var('Value')),
       (phrase(expression(var('AST')), [x, *, '(', y, +, 2|")-z"]),
        evaluate(var('AST'), [x - 4, y - 3, z - 1], var('Value')))).
clause(48,
       dcg_expression_example(round_trip, var('Tokens')),
       (var('AST') = sub(lit(20), sub(lit(5), lit(3))),
        phrase(emit_expression(var('AST')), var('Tokens')),
        phrase(expression(var('AST')), var('Tokens')))).
clause(49,
       dcg_expression_example(remainder, var('Rest')),
       phrase(expression(mul(var(x), lit(2))), [x, *, 2, then, stop], var('Rest'))).
clause(50,
       dcg_expression_example(rejected, malformed_parentheses),
       \+ phrase(expression(anonymous(1)), [2, *, '(', 3, +, 4])).

step(dcg_expression_example(parsed, add(lit(2), mul(lit(3), sub(lit(4), lit(1))))),
     rule(46),
     ['AST' = add(lit(2), mul(lit(3), sub(lit(4), lit(1))))],
     [phrase(expression(add(lit(2), mul(lit(3), sub(lit(4), lit(1))))), [2, +, 3, *, '(', 4, -, 1, ')'])]).
step(phrase(expression(add(lit(2), mul(lit(3), sub(lit(4), lit(1))))), [2, +, 3, *, '(', 4, -, 1, ')']),
     builtin,
     [],
     []).
step(dcg_expression_example(evaluated, 19),
     rule(47),
     ['Value' = 19, 'AST' = sub(mul(var(x), add(var(y), lit(2))), var(z))],
     [phrase(expression(sub(mul(var(x), add(var(y), lit(2))), var(z))), [x, *, '(', y, +, 2|")-z"]),
      evaluate(sub(mul(var(x), add(var(y), lit(2))), var(z)), [x - 4, y - 3, z - 1], 19)]).
step(phrase(expression(sub(mul(var(x), add(var(y), lit(2))), var(z))), [x, *, '(', y, +, 2|")-z"]),
     builtin,
     [],
     []).
step(evaluate(sub(mul(var(x), add(var(y), lit(2))), var(z)), [x - 4, y - 3, z - 1], 19),
     rule(21),
     ['Left' = mul(var(x), add(var(y), lit(2))),
      'Right' = var(z),
      'Environment' = [x - 4, y - 3, z - 1],
      'Value' = 19,
      'L' = 20,
      'R' = 1],
     [evaluate(mul(var(x), add(var(y), lit(2))), [x - 4, y - 3, z - 1], 20),
      evaluate(var(z), [x - 4, y - 3, z - 1], 1),
      19 is 20 - 1]).
step(evaluate(mul(var(x), add(var(y), lit(2))), [x - 4, y - 3, z - 1], 20),
     rule(22),
     ['Left' = var(x),
      'Right' = add(var(y), lit(2)),
      'Environment' = [x - 4, y - 3, z - 1],
      'Value' = 20,
      'L' = 4,
      'R' = 5],
     [evaluate(var(x), [x - 4, y - 3, z - 1], 4),
      evaluate(add(var(y), lit(2)), [x - 4, y - 3, z - 1], 5),
      20 is 4 * 5]).
step(evaluate(var(x), [x - 4, y - 3, z - 1], 4),
     rule(18),
     ['Name' = x, 'Environment' = [x - 4, y - 3, z - 1], 'Value' = 4],
     [lookup(x, [x - 4, y - 3, z - 1], 4)]).
step(lookup(x, [x - 4, y - 3, z - 1], 4), fact(24), ['Name' = x, 'Value' = 4], []).
step(evaluate(add(var(y), lit(2)), [x - 4, y - 3, z - 1], 5),
     rule(20),
     ['Left' = var(y),
      'Right' = lit(2),
      'Environment' = [x - 4, y - 3, z - 1],
      'Value' = 5,
      'L' = 3,
      'R' = 2],
     [evaluate(var(y), [x - 4, y - 3, z - 1], 3),
      evaluate(lit(2), [x - 4, y - 3, z - 1], 2),
      5 is 3 + 2]).
step(evaluate(var(y), [x - 4, y - 3, z - 1], 3),
     rule(18),
     ['Name' = y, 'Environment' = [x - 4, y - 3, z - 1], 'Value' = 3],
     [lookup(y, [x - 4, y - 3, z - 1], 3)]).
step(lookup(y, [x - 4, y - 3, z - 1], 3),
     rule(25),
     ['Name' = y, 'Rest' = [y - 3, z - 1], 'Value' = 3],
     [lookup(y, [y - 3, z - 1], 3)]).
step(lookup(y, [y - 3, z - 1], 3), fact(24), ['Name' = y, 'Value' = 3], []).
step(evaluate(lit(2), [x - 4, y - 3, z - 1], 2), fact(17), ['Number' = 2], []).
step(5 is 3 + 2, builtin, [], []).
step(20 is 4 * 5, builtin, [], []).
step(evaluate(var(z), [x - 4, y - 3, z - 1], 1),
     rule(18),
     ['Name' = z, 'Environment' = [x - 4, y - 3, z - 1], 'Value' = 1],
     [lookup(z, [x - 4, y - 3, z - 1], 1)]).
step(lookup(z, [x - 4, y - 3, z - 1], 1),
     rule(25),
     ['Name' = z, 'Rest' = [y - 3, z - 1], 'Value' = 1],
     [lookup(z, [y - 3, z - 1], 1)]).
step(lookup(z, [y - 3, z - 1], 1),
     rule(25),
     ['Name' = z, 'Rest' = [z - 1], 'Value' = 1],
     [lookup(z, [z - 1], 1)]).
step(lookup(z, [z - 1], 1), fact(24), ['Name' = z, 'Value' = 1], []).
step(19 is 20 - 1, builtin, [], []).
step(dcg_expression_example(round_trip, [20, -, '(', 5, -, 3, ')']),
     rule(48),
     ['Tokens' = [20, -, '(', 5, -, 3, ')'], 'AST' = sub(lit(20), sub(lit(5), lit(3)))],
     [sub(lit(20), sub(lit(5), lit(3))) = sub(lit(20), sub(lit(5), lit(3))),
      phrase(emit_expression(sub(lit(20), sub(lit(5), lit(3)))), [20, -, '(', 5, -, 3, ')']),
      phrase(expression(sub(lit(20), sub(lit(5), lit(3)))), [20, -, '(', 5, -, 3, ')'])]).
step(sub(lit(20), sub(lit(5), lit(3))) = sub(lit(20), sub(lit(5), lit(3))), builtin, [], []).
step(phrase(emit_expression(sub(lit(20), sub(lit(5), lit(3)))), [20, -, '(', 5, -, 3, ')']),
     builtin,
     [],
     []).
step(phrase(expression(sub(lit(20), sub(lit(5), lit(3)))), [20, -, '(', 5, -, 3, ')']),
     builtin,
     [],
     []).
step(dcg_expression_example(remainder, [then, stop]),
     rule(49),
     ['Rest' = [then, stop]],
     [phrase(expression(mul(var(x), lit(2))), [x, *, 2, then, stop], [then, stop])]).
step(phrase(expression(mul(var(x), lit(2))), [x, *, 2, then, stop], [then, stop]),
     builtin,
     [],
     []).
step(dcg_expression_example(rejected, malformed_parentheses),
     rule(50),
     [],
     [\+ phrase(expression(__anon14), [2, *, '(', 3, +, 4])]).
step(\+ phrase(expression(__anon14), [2, *, '(', 3, +, 4]), absent, [], []).
