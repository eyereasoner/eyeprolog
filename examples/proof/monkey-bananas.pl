plan(monkeyBananas, [go(loc3), push(loc1), climb_on, grab]).
plan(monkeyBananas, [go(loc1), go(loc3), push(loc1), climb_on, grab]).
plan(monkeyBananas, [go(loc3), push(loc1), climb_on, grab, climb_off]).
plan(monkeyBananas, [go(loc3), push(loc2), push(loc1), climb_on, grab]).
solved(monkeyBananas, true).

clause(1,
       plan(var('Moves')),
       (candidate_plan(var('Moves')),
        initial_state(var('I')),
        goal_state(var('G')),
        reachable_state(var('I'), var('Moves'), var('G')))).
clause(3, candidate_plan([anonymous(1), anonymous(2), anonymous(3), anonymous(4)]), true).
clause(4,
       candidate_plan([anonymous(1), anonymous(2), anonymous(3), anonymous(4), anonymous(5)]),
       true).
clause(5, reachable_state(var('S'), [], var('S')), true).
clause(6,
       reachable_state(var('S1'), [var('M') | var('L')], var('S3')),
       (legal_move(var('S1'), var('M'), var('S2')),
        reachable_state(var('S2'), var('L'), var('S3')))).
clause(7, initial_state([loc1, loc2, loc3|"nn"]), true).
clause(8, goal_state([anonymous(1), anonymous(2), anonymous(3), anonymous(4), y]), true).
clause(9,
       legal_move([var('B'), var('M'), var('M'), n, var('H')], climb_on, [var('B'), var('M'), var('M'), y, var('H')]),
       true).
clause(10,
       legal_move([var('B'), var('M'), var('M'), y, var('H')], climb_off, [var('B'), var('M'), var('M'), n, var('H')]),
       true).
clause(11,
       legal_move([var('B'), var('B'), var('B')|"yn"], grab, [var('B'), var('B'), var('B')|"yy"]),
       true).
clause(12,
       legal_move([var('B'), var('M'), var('M'), n, var('H')], push(var('X')), [var('B'), var('X'), var('X'), n, var('H')]),
       (member(var('X'), [loc1, loc2, loc3]), var('X') \= var('M'))).
clause(13,
       legal_move([var('B'), var('M'), var('L'), n, var('H')], go(var('X')), [var('B'), var('X'), var('L'), n, var('H')]),
       (member(var('X'), [loc1, loc2, loc3]), var('X') \= var('M'))).
clause(14, plan(monkeyBananas, var('Moves')), plan(var('Moves'))).
clause(15, solved(monkeyBananas, true), plan(anonymous(1))).

step(plan(monkeyBananas, [go(loc3), push(loc1), climb_on, grab]),
     rule(14),
     ['Moves' = [go(loc3), push(loc1), climb_on, grab]],
     [plan([go(loc3), push(loc1), climb_on, grab])]).
step(plan([go(loc3), push(loc1), climb_on, grab]),
     rule(1),
     ['Moves' = [go(loc3), push(loc1), climb_on, grab],
      'I' = [loc1, loc2, loc3|"nn"],
      'G' = [loc1, loc1, loc1|"yy"]],
     [candidate_plan([go(loc3), push(loc1), climb_on, grab]),
      initial_state([loc1, loc2, loc3|"nn"]),
      goal_state([loc1, loc1, loc1|"yy"]),
      reachable_state([loc1, loc2, loc3|"nn"], [go(loc3), push(loc1), climb_on, grab], [loc1, loc1, loc1|"yy"])]).
step(candidate_plan([go(loc3), push(loc1), climb_on, grab]), fact(3), [], []).
step(initial_state([loc1, loc2, loc3|"nn"]), fact(7), [], []).
step(goal_state([loc1, loc1, loc1|"yy"]), fact(8), [], []).
step(reachable_state([loc1, loc2, loc3|"nn"], [go(loc3), push(loc1), climb_on, grab], [loc1, loc1, loc1|"yy"]),
     rule(6),
     ['S1' = [loc1, loc2, loc3|"nn"],
      'M' = go(loc3),
      'L' = [push(loc1), climb_on, grab],
      'S3' = [loc1, loc1, loc1|"yy"],
      'S2' = [loc1, loc3, loc3|"nn"]],
     [legal_move([loc1, loc2, loc3|"nn"], go(loc3), [loc1, loc3, loc3|"nn"]),
      reachable_state([loc1, loc3, loc3|"nn"], [push(loc1), climb_on, grab], [loc1, loc1, loc1|"yy"])]).
step(legal_move([loc1, loc2, loc3|"nn"], go(loc3), [loc1, loc3, loc3|"nn"]),
     rule(13),
     ['B' = loc1, 'M' = loc2, 'L' = loc3, 'H' = n, 'X' = loc3],
     [member(loc3, [loc1, loc2, loc3]), loc3 \= loc2]).
step(member(loc3, [loc1, loc2, loc3]), builtin, [], []).
step(loc3 \= loc2, builtin, [], []).
step(reachable_state([loc1, loc3, loc3|"nn"], [push(loc1), climb_on, grab], [loc1, loc1, loc1|"yy"]),
     rule(6),
     ['S1' = [loc1, loc3, loc3|"nn"],
      'M' = push(loc1),
      'L' = [climb_on, grab],
      'S3' = [loc1, loc1, loc1|"yy"],
      'S2' = [loc1, loc1, loc1|"nn"]],
     [legal_move([loc1, loc3, loc3|"nn"], push(loc1), [loc1, loc1, loc1|"nn"]),
      reachable_state([loc1, loc1, loc1|"nn"], [climb_on, grab], [loc1, loc1, loc1|"yy"])]).
step(legal_move([loc1, loc3, loc3|"nn"], push(loc1), [loc1, loc1, loc1|"nn"]),
     rule(12),
     ['B' = loc1, 'M' = loc3, 'H' = n, 'X' = loc1],
     [member(loc1, [loc1, loc2, loc3]), loc1 \= loc3]).
step(member(loc1, [loc1, loc2, loc3]), builtin, [], []).
step(loc1 \= loc3, builtin, [], []).
step(reachable_state([loc1, loc1, loc1|"nn"], [climb_on, grab], [loc1, loc1, loc1|"yy"]),
     rule(6),
     ['S1' = [loc1, loc1, loc1|"nn"],
      'M' = climb_on,
      'L' = [grab],
      'S3' = [loc1, loc1, loc1|"yy"],
      'S2' = [loc1, loc1, loc1|"yn"]],
     [legal_move([loc1, loc1, loc1|"nn"], climb_on, [loc1, loc1, loc1|"yn"]),
      reachable_state([loc1, loc1, loc1|"yn"], [grab], [loc1, loc1, loc1|"yy"])]).
step(legal_move([loc1, loc1, loc1|"nn"], climb_on, [loc1, loc1, loc1|"yn"]),
     fact(9),
     ['B' = loc1, 'M' = loc1, 'H' = n],
     []).
step(reachable_state([loc1, loc1, loc1|"yn"], [grab], [loc1, loc1, loc1|"yy"]),
     rule(6),
     ['S1' = [loc1, loc1, loc1|"yn"],
      'M' = grab,
      'L' = [],
      'S3' = [loc1, loc1, loc1|"yy"],
      'S2' = [loc1, loc1, loc1|"yy"]],
     [legal_move([loc1, loc1, loc1|"yn"], grab, [loc1, loc1, loc1|"yy"]),
      reachable_state([loc1, loc1, loc1|"yy"], [], [loc1, loc1, loc1|"yy"])]).
step(legal_move([loc1, loc1, loc1|"yn"], grab, [loc1, loc1, loc1|"yy"]),
     fact(11),
     ['B' = loc1],
     []).
step(reachable_state([loc1, loc1, loc1|"yy"], [], [loc1, loc1, loc1|"yy"]),
     fact(5),
     ['S' = [loc1, loc1, loc1|"yy"]],
     []).
step(plan(monkeyBananas, [go(loc1), go(loc3), push(loc1), climb_on, grab]),
     rule(14),
     ['Moves' = [go(loc1), go(loc3), push(loc1), climb_on, grab]],
     [plan([go(loc1), go(loc3), push(loc1), climb_on, grab])]).
step(plan([go(loc1), go(loc3), push(loc1), climb_on, grab]),
     rule(1),
     ['Moves' = [go(loc1), go(loc3), push(loc1), climb_on, grab],
      'I' = [loc1, loc2, loc3|"nn"],
      'G' = [loc1, loc1, loc1|"yy"]],
     [candidate_plan([go(loc1), go(loc3), push(loc1), climb_on, grab]),
      initial_state([loc1, loc2, loc3|"nn"]),
      goal_state([loc1, loc1, loc1|"yy"]),
      reachable_state([loc1, loc2, loc3|"nn"], [go(loc1), go(loc3), push(loc1), climb_on, grab], [loc1, loc1, loc1|"yy"])]).
step(candidate_plan([go(loc1), go(loc3), push(loc1), climb_on, grab]), fact(4), [], []).
step(reachable_state([loc1, loc2, loc3|"nn"], [go(loc1), go(loc3), push(loc1), climb_on, grab], [loc1, loc1, loc1|"yy"]),
     rule(6),
     ['S1' = [loc1, loc2, loc3|"nn"],
      'M' = go(loc1),
      'L' = [go(loc3), push(loc1), climb_on, grab],
      'S3' = [loc1, loc1, loc1|"yy"],
      'S2' = [loc1, loc1, loc3|"nn"]],
     [legal_move([loc1, loc2, loc3|"nn"], go(loc1), [loc1, loc1, loc3|"nn"]),
      reachable_state([loc1, loc1, loc3|"nn"], [go(loc3), push(loc1), climb_on, grab], [loc1, loc1, loc1|"yy"])]).
step(legal_move([loc1, loc2, loc3|"nn"], go(loc1), [loc1, loc1, loc3|"nn"]),
     rule(13),
     ['B' = loc1, 'M' = loc2, 'L' = loc3, 'H' = n, 'X' = loc1],
     [member(loc1, [loc1, loc2, loc3]), loc1 \= loc2]).
step(loc1 \= loc2, builtin, [], []).
step(reachable_state([loc1, loc1, loc3|"nn"], [go(loc3), push(loc1), climb_on, grab], [loc1, loc1, loc1|"yy"]),
     rule(6),
     ['S1' = [loc1, loc1, loc3|"nn"],
      'M' = go(loc3),
      'L' = [push(loc1), climb_on, grab],
      'S3' = [loc1, loc1, loc1|"yy"],
      'S2' = [loc1, loc3, loc3|"nn"]],
     [legal_move([loc1, loc1, loc3|"nn"], go(loc3), [loc1, loc3, loc3|"nn"]),
      reachable_state([loc1, loc3, loc3|"nn"], [push(loc1), climb_on, grab], [loc1, loc1, loc1|"yy"])]).
step(legal_move([loc1, loc1, loc3|"nn"], go(loc3), [loc1, loc3, loc3|"nn"]),
     rule(13),
     ['B' = loc1, 'M' = loc1, 'L' = loc3, 'H' = n, 'X' = loc3],
     [member(loc3, [loc1, loc2, loc3]), loc3 \= loc1]).
step(loc3 \= loc1, builtin, [], []).
step(plan(monkeyBananas, [go(loc3), push(loc1), climb_on, grab, climb_off]),
     rule(14),
     ['Moves' = [go(loc3), push(loc1), climb_on, grab, climb_off]],
     [plan([go(loc3), push(loc1), climb_on, grab, climb_off])]).
step(plan([go(loc3), push(loc1), climb_on, grab, climb_off]),
     rule(1),
     ['Moves' = [go(loc3), push(loc1), climb_on, grab, climb_off],
      'I' = [loc1, loc2, loc3|"nn"],
      'G' = [loc1, loc1, loc1|"ny"]],
     [candidate_plan([go(loc3), push(loc1), climb_on, grab, climb_off]),
      initial_state([loc1, loc2, loc3|"nn"]),
      goal_state([loc1, loc1, loc1|"ny"]),
      reachable_state([loc1, loc2, loc3|"nn"], [go(loc3), push(loc1), climb_on, grab, climb_off], [loc1, loc1, loc1|"ny"])]).
step(candidate_plan([go(loc3), push(loc1), climb_on, grab, climb_off]), fact(4), [], []).
step(goal_state([loc1, loc1, loc1|"ny"]), fact(8), [], []).
step(reachable_state([loc1, loc2, loc3|"nn"], [go(loc3), push(loc1), climb_on, grab, climb_off], [loc1, loc1, loc1|"ny"]),
     rule(6),
     ['S1' = [loc1, loc2, loc3|"nn"],
      'M' = go(loc3),
      'L' = [push(loc1), climb_on, grab, climb_off],
      'S3' = [loc1, loc1, loc1|"ny"],
      'S2' = [loc1, loc3, loc3|"nn"]],
     [legal_move([loc1, loc2, loc3|"nn"], go(loc3), [loc1, loc3, loc3|"nn"]),
      reachable_state([loc1, loc3, loc3|"nn"], [push(loc1), climb_on, grab, climb_off], [loc1, loc1, loc1|"ny"])]).
step(reachable_state([loc1, loc3, loc3|"nn"], [push(loc1), climb_on, grab, climb_off], [loc1, loc1, loc1|"ny"]),
     rule(6),
     ['S1' = [loc1, loc3, loc3|"nn"],
      'M' = push(loc1),
      'L' = [climb_on, grab, climb_off],
      'S3' = [loc1, loc1, loc1|"ny"],
      'S2' = [loc1, loc1, loc1|"nn"]],
     [legal_move([loc1, loc3, loc3|"nn"], push(loc1), [loc1, loc1, loc1|"nn"]),
      reachable_state([loc1, loc1, loc1|"nn"], [climb_on, grab, climb_off], [loc1, loc1, loc1|"ny"])]).
step(reachable_state([loc1, loc1, loc1|"nn"], [climb_on, grab, climb_off], [loc1, loc1, loc1|"ny"]),
     rule(6),
     ['S1' = [loc1, loc1, loc1|"nn"],
      'M' = climb_on,
      'L' = [grab, climb_off],
      'S3' = [loc1, loc1, loc1|"ny"],
      'S2' = [loc1, loc1, loc1|"yn"]],
     [legal_move([loc1, loc1, loc1|"nn"], climb_on, [loc1, loc1, loc1|"yn"]),
      reachable_state([loc1, loc1, loc1|"yn"], [grab, climb_off], [loc1, loc1, loc1|"ny"])]).
step(reachable_state([loc1, loc1, loc1|"yn"], [grab, climb_off], [loc1, loc1, loc1|"ny"]),
     rule(6),
     ['S1' = [loc1, loc1, loc1|"yn"],
      'M' = grab,
      'L' = [climb_off],
      'S3' = [loc1, loc1, loc1|"ny"],
      'S2' = [loc1, loc1, loc1|"yy"]],
     [legal_move([loc1, loc1, loc1|"yn"], grab, [loc1, loc1, loc1|"yy"]),
      reachable_state([loc1, loc1, loc1|"yy"], [climb_off], [loc1, loc1, loc1|"ny"])]).
step(reachable_state([loc1, loc1, loc1|"yy"], [climb_off], [loc1, loc1, loc1|"ny"]),
     rule(6),
     ['S1' = [loc1, loc1, loc1|"yy"],
      'M' = climb_off,
      'L' = [],
      'S3' = [loc1, loc1, loc1|"ny"],
      'S2' = [loc1, loc1, loc1|"ny"]],
     [legal_move([loc1, loc1, loc1|"yy"], climb_off, [loc1, loc1, loc1|"ny"]),
      reachable_state([loc1, loc1, loc1|"ny"], [], [loc1, loc1, loc1|"ny"])]).
step(legal_move([loc1, loc1, loc1|"yy"], climb_off, [loc1, loc1, loc1|"ny"]),
     fact(10),
     ['B' = loc1, 'M' = loc1, 'H' = y],
     []).
step(reachable_state([loc1, loc1, loc1|"ny"], [], [loc1, loc1, loc1|"ny"]),
     fact(5),
     ['S' = [loc1, loc1, loc1|"ny"]],
     []).
step(plan(monkeyBananas, [go(loc3), push(loc2), push(loc1), climb_on, grab]),
     rule(14),
     ['Moves' = [go(loc3), push(loc2), push(loc1), climb_on, grab]],
     [plan([go(loc3), push(loc2), push(loc1), climb_on, grab])]).
step(plan([go(loc3), push(loc2), push(loc1), climb_on, grab]),
     rule(1),
     ['Moves' = [go(loc3), push(loc2), push(loc1), climb_on, grab],
      'I' = [loc1, loc2, loc3|"nn"],
      'G' = [loc1, loc1, loc1|"yy"]],
     [candidate_plan([go(loc3), push(loc2), push(loc1), climb_on, grab]),
      initial_state([loc1, loc2, loc3|"nn"]),
      goal_state([loc1, loc1, loc1|"yy"]),
      reachable_state([loc1, loc2, loc3|"nn"], [go(loc3), push(loc2), push(loc1), climb_on, grab], [loc1, loc1, loc1|"yy"])]).
step(candidate_plan([go(loc3), push(loc2), push(loc1), climb_on, grab]), fact(4), [], []).
step(reachable_state([loc1, loc2, loc3|"nn"], [go(loc3), push(loc2), push(loc1), climb_on, grab], [loc1, loc1, loc1|"yy"]),
     rule(6),
     ['S1' = [loc1, loc2, loc3|"nn"],
      'M' = go(loc3),
      'L' = [push(loc2), push(loc1), climb_on, grab],
      'S3' = [loc1, loc1, loc1|"yy"],
      'S2' = [loc1, loc3, loc3|"nn"]],
     [legal_move([loc1, loc2, loc3|"nn"], go(loc3), [loc1, loc3, loc3|"nn"]),
      reachable_state([loc1, loc3, loc3|"nn"], [push(loc2), push(loc1), climb_on, grab], [loc1, loc1, loc1|"yy"])]).
step(reachable_state([loc1, loc3, loc3|"nn"], [push(loc2), push(loc1), climb_on, grab], [loc1, loc1, loc1|"yy"]),
     rule(6),
     ['S1' = [loc1, loc3, loc3|"nn"],
      'M' = push(loc2),
      'L' = [push(loc1), climb_on, grab],
      'S3' = [loc1, loc1, loc1|"yy"],
      'S2' = [loc1, loc2, loc2|"nn"]],
     [legal_move([loc1, loc3, loc3|"nn"], push(loc2), [loc1, loc2, loc2|"nn"]),
      reachable_state([loc1, loc2, loc2|"nn"], [push(loc1), climb_on, grab], [loc1, loc1, loc1|"yy"])]).
step(legal_move([loc1, loc3, loc3|"nn"], push(loc2), [loc1, loc2, loc2|"nn"]),
     rule(12),
     ['B' = loc1, 'M' = loc3, 'H' = n, 'X' = loc2],
     [member(loc2, [loc1, loc2, loc3]), loc2 \= loc3]).
step(member(loc2, [loc1, loc2, loc3]), builtin, [], []).
step(loc2 \= loc3, builtin, [], []).
step(reachable_state([loc1, loc2, loc2|"nn"], [push(loc1), climb_on, grab], [loc1, loc1, loc1|"yy"]),
     rule(6),
     ['S1' = [loc1, loc2, loc2|"nn"],
      'M' = push(loc1),
      'L' = [climb_on, grab],
      'S3' = [loc1, loc1, loc1|"yy"],
      'S2' = [loc1, loc1, loc1|"nn"]],
     [legal_move([loc1, loc2, loc2|"nn"], push(loc1), [loc1, loc1, loc1|"nn"]),
      reachable_state([loc1, loc1, loc1|"nn"], [climb_on, grab], [loc1, loc1, loc1|"yy"])]).
step(legal_move([loc1, loc2, loc2|"nn"], push(loc1), [loc1, loc1, loc1|"nn"]),
     rule(12),
     ['B' = loc1, 'M' = loc2, 'H' = n, 'X' = loc1],
     [member(loc1, [loc1, loc2, loc3]), loc1 \= loc2]).
step(solved(monkeyBananas, true), rule(15), [], [plan([go(loc3), push(loc1), climb_on, grab])]).
