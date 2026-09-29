solution(puzzle, [goat, nothing, wolf, goat, cabbage, nothing, goat]).
solution(puzzle, [goat, nothing, cabbage, goat, wolf, nothing, goat]).
solved(puzzle, true).

clause(1,
       solution(var('Moves')),
       (solve("wwww", "eeee", ["wwww"], var('Moves')), length(var('Moves'), 7))).
clause(2, solve(var('Config'), var('Config'), anonymous(1), []), true).
clause(3,
       solve(var('Config'), var('Goal'), var('Visited'), [var('Move') | var('Rest')]),
       (move(var('Config'), var('Move'), var('Nextconfig')),
        safe(var('Nextconfig')),
        \+ member(var('Nextconfig'), var('Visited')),
        solve(var('Nextconfig'), var('Goal'), [var('Nextconfig') | var('Visited')], var('Rest')))).
clause(4,
       move([var('X'), var('X'), var('Goat'), var('Cabbage')], wolf, [var('Y'), var('Y'), var('Goat'), var('Cabbage')]),
       change(var('X'), var('Y'))).
clause(5,
       move([var('X'), var('Wolf'), var('X'), var('Cabbage')], goat, [var('Y'), var('Wolf'), var('Y'), var('Cabbage')]),
       change(var('X'), var('Y'))).
clause(6,
       move([var('X'), var('Wolf'), var('Goat'), var('X')], cabbage, [var('Y'), var('Wolf'), var('Goat'), var('Y')]),
       change(var('X'), var('Y'))).
clause(7,
       move([var('X'), var('Wolf'), var('Goat'), var('Cabbage')], nothing, [var('Y'), var('Wolf'), var('Goat'), var('Cabbage')]),
       change(var('X'), var('Y'))).
clause(8, change(e, w), true).
clause(9, change(w, e), true).
clause(10,
       safe([var('Man'), var('Wolf'), var('Goat'), var('Cabbage')]),
       (one_eq(var('Man'), var('Goat'), var('Wolf')),
        one_eq(var('Man'), var('Goat'), var('Cabbage')))).
clause(11, one_eq(var('X'), var('X'), anonymous(1)), true).
clause(12, one_eq(var('X'), anonymous(1), var('X')), true).
clause(13, solution(puzzle, var('Moves')), solution(var('Moves'))).
clause(14, solved(puzzle, true), solution(anonymous(1))).

step(solution(puzzle, [goat, nothing, wolf, goat, cabbage, nothing, goat]),
     rule(13),
     ['Moves' = [goat, nothing, wolf, goat, cabbage, nothing, goat]],
     [solution([goat, nothing, wolf, goat, cabbage, nothing, goat])]).
step(solution([goat, nothing, wolf, goat, cabbage, nothing, goat]),
     rule(1),
     ['Moves' = [goat, nothing, wolf, goat, cabbage, nothing, goat]],
     [solve("wwww", "eeee", ["wwww"], [goat, nothing, wolf, goat, cabbage, nothing, goat]),
      length([goat, nothing, wolf, goat, cabbage, nothing, goat], 7)]).
step(solve("wwww", "eeee", ["wwww"], [goat, nothing, wolf, goat, cabbage, nothing, goat]),
     rule(3),
     ['Config' = "wwww",
      'Goal' = "eeee",
      'Visited' = ["wwww"],
      'Move' = goat,
      'Rest' = [nothing, wolf, goat, cabbage, nothing, goat],
      'Nextconfig' = "ewew"],
     [move("wwww", goat, "ewew"),
      safe("ewew"),
      \+ member("ewew", ["wwww"]),
      solve("ewew", "eeee", ["ewew", "wwww"], [nothing, wolf, goat, cabbage, nothing, goat])]).
step(move("wwww", goat, "ewew"),
     rule(5),
     ['X' = w, 'Wolf' = w, 'Cabbage' = w, 'Y' = e],
     [change(w, e)]).
step(change(w, e), fact(9), [], []).
step(safe("ewew"),
     rule(10),
     ['Man' = e, 'Wolf' = w, 'Goat' = e, 'Cabbage' = w],
     [one_eq(e, e, w), one_eq(e, e, w)]).
step(one_eq(e, e, w), fact(11), ['X' = e], []).
step(\+ member("ewew", ["wwww"]), absent, [], []).
step(solve("ewew", "eeee", ["ewew", "wwww"], [nothing, wolf, goat, cabbage, nothing, goat]),
     rule(3),
     ['Config' = "ewew",
      'Goal' = "eeee",
      'Visited' = ["ewew", "wwww"],
      'Move' = nothing,
      'Rest' = [wolf, goat, cabbage, nothing, goat],
      'Nextconfig' = "wwew"],
     [move("ewew", nothing, "wwew"),
      safe("wwew"),
      \+ member("wwew", ["ewew", "wwww"]),
      solve("wwew", "eeee", ["wwew", "ewew", "wwww"], [wolf, goat, cabbage, nothing, goat])]).
step(move("ewew", nothing, "wwew"),
     rule(7),
     ['X' = e, 'Wolf' = w, 'Goat' = e, 'Cabbage' = w, 'Y' = w],
     [change(e, w)]).
step(change(e, w), fact(8), [], []).
step(safe("wwew"),
     rule(10),
     ['Man' = w, 'Wolf' = w, 'Goat' = e, 'Cabbage' = w],
     [one_eq(w, e, w), one_eq(w, e, w)]).
step(one_eq(w, e, w), fact(12), ['X' = w], []).
step(\+ member("wwew", ["ewew", "wwww"]), absent, [], []).
step(solve("wwew", "eeee", ["wwew", "ewew", "wwww"], [wolf, goat, cabbage, nothing, goat]),
     rule(3),
     ['Config' = "wwew",
      'Goal' = "eeee",
      'Visited' = ["wwew", "ewew", "wwww"],
      'Move' = wolf,
      'Rest' = [goat, cabbage, nothing, goat],
      'Nextconfig' = "eeew"],
     [move("wwew", wolf, "eeew"),
      safe("eeew"),
      \+ member("eeew", ["wwew", "ewew", "wwww"]),
      solve("eeew", "eeee", ["eeew", "wwew", "ewew", "wwww"], [goat, cabbage, nothing, goat])]).
step(move("wwew", wolf, "eeew"),
     rule(4),
     ['X' = w, 'Goat' = e, 'Cabbage' = w, 'Y' = e],
     [change(w, e)]).
step(safe("eeew"),
     rule(10),
     ['Man' = e, 'Wolf' = e, 'Goat' = e, 'Cabbage' = w],
     [one_eq(e, e, e), one_eq(e, e, w)]).
step(one_eq(e, e, e), fact(11), ['X' = e], []).
step(\+ member("eeew", ["wwew", "ewew", "wwww"]), absent, [], []).
step(solve("eeew", "eeee", ["eeew", "wwew", "ewew", "wwww"], [goat, cabbage, nothing, goat]),
     rule(3),
     ['Config' = "eeew",
      'Goal' = "eeee",
      'Visited' = ["eeew", "wwew", "ewew", "wwww"],
      'Move' = goat,
      'Rest' = [cabbage, nothing, goat],
      'Nextconfig' = "weww"],
     [move("eeew", goat, "weww"),
      safe("weww"),
      \+ member("weww", ["eeew", "wwew", "ewew", "wwww"]),
      solve("weww", "eeee", ["weww", "eeew", "wwew", "ewew", "wwww"], [cabbage, nothing, goat])]).
step(move("eeew", goat, "weww"),
     rule(5),
     ['X' = e, 'Wolf' = e, 'Cabbage' = w, 'Y' = w],
     [change(e, w)]).
step(safe("weww"),
     rule(10),
     ['Man' = w, 'Wolf' = e, 'Goat' = w, 'Cabbage' = w],
     [one_eq(w, w, e), one_eq(w, w, w)]).
step(one_eq(w, w, e), fact(11), ['X' = w], []).
step(one_eq(w, w, w), fact(11), ['X' = w], []).
step(\+ member("weww", ["eeew", "wwew", "ewew", "wwww"]), absent, [], []).
step(solve("weww", "eeee", ["weww", "eeew", "wwew", "ewew", "wwww"], [cabbage, nothing, goat]),
     rule(3),
     ['Config' = "weww",
      'Goal' = "eeee",
      'Visited' = ["weww", "eeew", "wwew", "ewew", "wwww"],
      'Move' = cabbage,
      'Rest' = [nothing, goat],
      'Nextconfig' = "eewe"],
     [move("weww", cabbage, "eewe"),
      safe("eewe"),
      \+ member("eewe", ["weww", "eeew", "wwew", "ewew", "wwww"]),
      solve("eewe", "eeee", ["eewe", "weww", "eeew", "wwew", "ewew", "wwww"], [nothing, goat])]).
step(move("weww", cabbage, "eewe"),
     rule(6),
     ['X' = w, 'Wolf' = e, 'Goat' = w, 'Y' = e],
     [change(w, e)]).
step(safe("eewe"),
     rule(10),
     ['Man' = e, 'Wolf' = e, 'Goat' = w, 'Cabbage' = e],
     [one_eq(e, w, e), one_eq(e, w, e)]).
step(one_eq(e, w, e), fact(12), ['X' = e], []).
step(\+ member("eewe", ["weww", "eeew", "wwew", "ewew", "wwww"]), absent, [], []).
step(solve("eewe", "eeee", ["eewe", "weww", "eeew", "wwew", "ewew", "wwww"], [nothing, goat]),
     rule(3),
     ['Config' = "eewe",
      'Goal' = "eeee",
      'Visited' = ["eewe", "weww", "eeew", "wwew", "ewew", "wwww"],
      'Move' = nothing,
      'Rest' = [goat],
      'Nextconfig' = "wewe"],
     [move("eewe", nothing, "wewe"),
      safe("wewe"),
      \+ member("wewe", ["eewe", "weww", "eeew", "wwew", "ewew", "wwww"]),
      solve("wewe", "eeee", ["wewe", "eewe", "weww", "eeew", "wwew", "ewew", "wwww"], [goat])]).
step(move("eewe", nothing, "wewe"),
     rule(7),
     ['X' = e, 'Wolf' = e, 'Goat' = w, 'Cabbage' = e, 'Y' = w],
     [change(e, w)]).
step(safe("wewe"),
     rule(10),
     ['Man' = w, 'Wolf' = e, 'Goat' = w, 'Cabbage' = e],
     [one_eq(w, w, e), one_eq(w, w, e)]).
step(\+ member("wewe", ["eewe", "weww", "eeew", "wwew", "ewew", "wwww"]), absent, [], []).
step(solve("wewe", "eeee", ["wewe", "eewe", "weww", "eeew", "wwew", "ewew", "wwww"], [goat]),
     rule(3),
     ['Config' = "wewe",
      'Goal' = "eeee",
      'Visited' = ["wewe", "eewe", "weww", "eeew", "wwew", "ewew", "wwww"],
      'Move' = goat,
      'Rest' = [],
      'Nextconfig' = "eeee"],
     [move("wewe", goat, "eeee"),
      safe("eeee"),
      \+ member("eeee", ["wewe", "eewe", "weww", "eeew", "wwew", "ewew", "wwww"]),
      solve("eeee", "eeee", ["eeee", "wewe", "eewe", "weww", "eeew", "wwew", "ewew", "wwww"], [])]).
step(move("wewe", goat, "eeee"),
     rule(5),
     ['X' = w, 'Wolf' = e, 'Cabbage' = e, 'Y' = e],
     [change(w, e)]).
step(safe("eeee"),
     rule(10),
     ['Man' = e, 'Wolf' = e, 'Goat' = e, 'Cabbage' = e],
     [one_eq(e, e, e), one_eq(e, e, e)]).
step(\+ member("eeee", ["wewe", "eewe", "weww", "eeew", "wwew", "ewew", "wwww"]),
     absent,
     [],
     []).
step(solve("eeee", "eeee", ["eeee", "wewe", "eewe", "weww", "eeew", "wwew", "ewew", "wwww"], []),
     fact(2),
     ['Config' = "eeee"],
     []).
step(length([goat, nothing, wolf, goat, cabbage, nothing, goat], 7), builtin, [], []).
step(solution(puzzle, [goat, nothing, cabbage, goat, wolf, nothing, goat]),
     rule(13),
     ['Moves' = [goat, nothing, cabbage, goat, wolf, nothing, goat]],
     [solution([goat, nothing, cabbage, goat, wolf, nothing, goat])]).
step(solution([goat, nothing, cabbage, goat, wolf, nothing, goat]),
     rule(1),
     ['Moves' = [goat, nothing, cabbage, goat, wolf, nothing, goat]],
     [solve("wwww", "eeee", ["wwww"], [goat, nothing, cabbage, goat, wolf, nothing, goat]),
      length([goat, nothing, cabbage, goat, wolf, nothing, goat], 7)]).
step(solve("wwww", "eeee", ["wwww"], [goat, nothing, cabbage, goat, wolf, nothing, goat]),
     rule(3),
     ['Config' = "wwww",
      'Goal' = "eeee",
      'Visited' = ["wwww"],
      'Move' = goat,
      'Rest' = [nothing, cabbage, goat, wolf, nothing, goat],
      'Nextconfig' = "ewew"],
     [move("wwww", goat, "ewew"),
      safe("ewew"),
      \+ member("ewew", ["wwww"]),
      solve("ewew", "eeee", ["ewew", "wwww"], [nothing, cabbage, goat, wolf, nothing, goat])]).
step(solve("ewew", "eeee", ["ewew", "wwww"], [nothing, cabbage, goat, wolf, nothing, goat]),
     rule(3),
     ['Config' = "ewew",
      'Goal' = "eeee",
      'Visited' = ["ewew", "wwww"],
      'Move' = nothing,
      'Rest' = [cabbage, goat, wolf, nothing, goat],
      'Nextconfig' = "wwew"],
     [move("ewew", nothing, "wwew"),
      safe("wwew"),
      \+ member("wwew", ["ewew", "wwww"]),
      solve("wwew", "eeee", ["wwew", "ewew", "wwww"], [cabbage, goat, wolf, nothing, goat])]).
step(solve("wwew", "eeee", ["wwew", "ewew", "wwww"], [cabbage, goat, wolf, nothing, goat]),
     rule(3),
     ['Config' = "wwew",
      'Goal' = "eeee",
      'Visited' = ["wwew", "ewew", "wwww"],
      'Move' = cabbage,
      'Rest' = [goat, wolf, nothing, goat],
      'Nextconfig' = "ewee"],
     [move("wwew", cabbage, "ewee"),
      safe("ewee"),
      \+ member("ewee", ["wwew", "ewew", "wwww"]),
      solve("ewee", "eeee", ["ewee", "wwew", "ewew", "wwww"], [goat, wolf, nothing, goat])]).
step(move("wwew", cabbage, "ewee"),
     rule(6),
     ['X' = w, 'Wolf' = w, 'Goat' = e, 'Y' = e],
     [change(w, e)]).
step(safe("ewee"),
     rule(10),
     ['Man' = e, 'Wolf' = w, 'Goat' = e, 'Cabbage' = e],
     [one_eq(e, e, w), one_eq(e, e, e)]).
step(\+ member("ewee", ["wwew", "ewew", "wwww"]), absent, [], []).
step(solve("ewee", "eeee", ["ewee", "wwew", "ewew", "wwww"], [goat, wolf, nothing, goat]),
     rule(3),
     ['Config' = "ewee",
      'Goal' = "eeee",
      'Visited' = ["ewee", "wwew", "ewew", "wwww"],
      'Move' = goat,
      'Rest' = [wolf, nothing, goat],
      'Nextconfig' = "wwwe"],
     [move("ewee", goat, "wwwe"),
      safe("wwwe"),
      \+ member("wwwe", ["ewee", "wwew", "ewew", "wwww"]),
      solve("wwwe", "eeee", ["wwwe", "ewee", "wwew", "ewew", "wwww"], [wolf, nothing, goat])]).
step(move("ewee", goat, "wwwe"),
     rule(5),
     ['X' = e, 'Wolf' = w, 'Cabbage' = e, 'Y' = w],
     [change(e, w)]).
step(safe("wwwe"),
     rule(10),
     ['Man' = w, 'Wolf' = w, 'Goat' = w, 'Cabbage' = e],
     [one_eq(w, w, w), one_eq(w, w, e)]).
step(\+ member("wwwe", ["ewee", "wwew", "ewew", "wwww"]), absent, [], []).
step(solve("wwwe", "eeee", ["wwwe", "ewee", "wwew", "ewew", "wwww"], [wolf, nothing, goat]),
     rule(3),
     ['Config' = "wwwe",
      'Goal' = "eeee",
      'Visited' = ["wwwe", "ewee", "wwew", "ewew", "wwww"],
      'Move' = wolf,
      'Rest' = [nothing, goat],
      'Nextconfig' = "eewe"],
     [move("wwwe", wolf, "eewe"),
      safe("eewe"),
      \+ member("eewe", ["wwwe", "ewee", "wwew", "ewew", "wwww"]),
      solve("eewe", "eeee", ["eewe", "wwwe", "ewee", "wwew", "ewew", "wwww"], [nothing, goat])]).
step(move("wwwe", wolf, "eewe"),
     rule(4),
     ['X' = w, 'Goat' = w, 'Cabbage' = e, 'Y' = e],
     [change(w, e)]).
step(\+ member("eewe", ["wwwe", "ewee", "wwew", "ewew", "wwww"]), absent, [], []).
step(solve("eewe", "eeee", ["eewe", "wwwe", "ewee", "wwew", "ewew", "wwww"], [nothing, goat]),
     rule(3),
     ['Config' = "eewe",
      'Goal' = "eeee",
      'Visited' = ["eewe", "wwwe", "ewee", "wwew", "ewew", "wwww"],
      'Move' = nothing,
      'Rest' = [goat],
      'Nextconfig' = "wewe"],
     [move("eewe", nothing, "wewe"),
      safe("wewe"),
      \+ member("wewe", ["eewe", "wwwe", "ewee", "wwew", "ewew", "wwww"]),
      solve("wewe", "eeee", ["wewe", "eewe", "wwwe", "ewee", "wwew", "ewew", "wwww"], [goat])]).
step(\+ member("wewe", ["eewe", "wwwe", "ewee", "wwew", "ewew", "wwww"]), absent, [], []).
step(solve("wewe", "eeee", ["wewe", "eewe", "wwwe", "ewee", "wwew", "ewew", "wwww"], [goat]),
     rule(3),
     ['Config' = "wewe",
      'Goal' = "eeee",
      'Visited' = ["wewe", "eewe", "wwwe", "ewee", "wwew", "ewew", "wwww"],
      'Move' = goat,
      'Rest' = [],
      'Nextconfig' = "eeee"],
     [move("wewe", goat, "eeee"),
      safe("eeee"),
      \+ member("eeee", ["wewe", "eewe", "wwwe", "ewee", "wwew", "ewew", "wwww"]),
      solve("eeee", "eeee", ["eeee", "wewe", "eewe", "wwwe", "ewee", "wwew", "ewew", "wwww"], [])]).
step(\+ member("eeee", ["wewe", "eewe", "wwwe", "ewee", "wwew", "ewew", "wwww"]),
     absent,
     [],
     []).
step(solve("eeee", "eeee", ["eeee", "wewe", "eewe", "wwwe", "ewee", "wwew", "ewew", "wwww"], []),
     fact(2),
     ['Config' = "eeee"],
     []).
step(length([goat, nothing, cabbage, goat, wolf, nothing, goat], 7), builtin, [], []).
step(solved(puzzle, true),
     rule(14),
     [],
     [solution([goat, nothing, wolf, goat, cabbage, nothing, goat])]).
