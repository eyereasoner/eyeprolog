answer(true, true, true, false, true, true, true).

clause(17,
       answer(var('FullPathReachesGarden'), var('VacuousBoxHolds'), var('GenuineBoxHolds'), var('ChoiceBoxFails'), var('ChoiceDiamondHolds'), var('StarPreservesLocation'), var('TestGuardedPathWorks')),
       (var('Locked') = [at(hall), door(locked)],
        var('Open') = [at(hall), door(open)],
        boolean(diamond(seq(unlock, seq(open_door, walk_to_garden)), at(garden), var('Locked')), var('FullPathReachesGarden')),
        \+ run(open_door, var('Locked'), anonymous(1)),
        boolean(box(open_door, at(garden), var('Locked')), var('VacuousBoxHolds')),
        boolean(box(walk_to_garden, at(garden), var('Open')), var('GenuineBoxHolds')),
        boolean(box(choice(walk_to_garden, wait), at(garden), var('Open')), var('ChoiceBoxFails')),
        boolean(diamond(choice(walk_to_garden, wait), at(garden), var('Open')), var('ChoiceDiamondHolds')),
        boolean(diamond(star(wait), at(hall), var('Locked')), var('StarPreservesLocation')),
        boolean(diamond(seq(test(door(open)), walk_to_garden), at(garden), var('Open')), var('TestGuardedPathWorks')))).
clause(18, boolean(var('Goal'), true), (call(var('Goal')), !)).
clause(19, boolean(anonymous(1), false), true).

step(answer(true, true, true, false, true, true, true),
     rule(17),
     ['FullPathReachesGarden' = true,
      'VacuousBoxHolds' = true,
      'GenuineBoxHolds' = true,
      'ChoiceBoxFails' = false,
      'ChoiceDiamondHolds' = true,
      'StarPreservesLocation' = true,
      'TestGuardedPathWorks' = true,
      'Locked' = [at(hall), door(locked)],
      'Open' = [at(hall), door(open)]],
     [[at(hall), door(locked)] = [at(hall), door(locked)],
      [at(hall), door(open)] = [at(hall), door(open)],
      boolean(diamond(seq(unlock, seq(open_door, walk_to_garden)), at(garden), [at(hall), door(locked)]), true),
      \+ run(open_door, [at(hall), door(locked)], __anon3),
      boolean(box(open_door, at(garden), [at(hall), door(locked)]), true),
      boolean(box(walk_to_garden, at(garden), [at(hall), door(open)]), true),
      boolean(box(choice(walk_to_garden, wait), at(garden), [at(hall), door(open)]), false),
      boolean(diamond(choice(walk_to_garden, wait), at(garden), [at(hall), door(open)]), true),
      boolean(diamond(star(wait), at(hall), [at(hall), door(locked)]), true),
      boolean(diamond(seq(test(door(open)), walk_to_garden), at(garden), [at(hall), door(open)]), true)]).
step([at(hall), door(locked)] = [at(hall), door(locked)], builtin, [], []).
step([at(hall), door(open)] = [at(hall), door(open)], builtin, [], []).
step(boolean(diamond(seq(unlock, seq(open_door, walk_to_garden)), at(garden), [at(hall), door(locked)]), true),
     rule(18),
     ['Goal' = diamond(seq(unlock, seq(open_door, walk_to_garden)), at(garden), [at(hall), door(locked)])],
     [call(diamond(seq(unlock, seq(open_door, walk_to_garden)), at(garden), [at(hall), door(locked)])),
      !]).
step(call(diamond(seq(unlock, seq(open_door, walk_to_garden)), at(garden), [at(hall), door(locked)])),
     builtin,
     [],
     []).
step(!, builtin, [], []).
step(\+ run(open_door, [at(hall), door(locked)], __anon3), absent, [], []).
step(boolean(box(open_door, at(garden), [at(hall), door(locked)]), true),
     rule(18),
     ['Goal' = box(open_door, at(garden), [at(hall), door(locked)])],
     [call(box(open_door, at(garden), [at(hall), door(locked)])), !]).
step(call(box(open_door, at(garden), [at(hall), door(locked)])), builtin, [], []).
step(boolean(box(walk_to_garden, at(garden), [at(hall), door(open)]), true),
     rule(18),
     ['Goal' = box(walk_to_garden, at(garden), [at(hall), door(open)])],
     [call(box(walk_to_garden, at(garden), [at(hall), door(open)])), !]).
step(call(box(walk_to_garden, at(garden), [at(hall), door(open)])), builtin, [], []).
step(boolean(box(choice(walk_to_garden, wait), at(garden), [at(hall), door(open)]), false),
     fact(19),
     [],
     []).
step(boolean(diamond(choice(walk_to_garden, wait), at(garden), [at(hall), door(open)]), true),
     rule(18),
     ['Goal' = diamond(choice(walk_to_garden, wait), at(garden), [at(hall), door(open)])],
     [call(diamond(choice(walk_to_garden, wait), at(garden), [at(hall), door(open)])), !]).
step(call(diamond(choice(walk_to_garden, wait), at(garden), [at(hall), door(open)])),
     builtin,
     [],
     []).
step(boolean(diamond(star(wait), at(hall), [at(hall), door(locked)]), true),
     rule(18),
     ['Goal' = diamond(star(wait), at(hall), [at(hall), door(locked)])],
     [call(diamond(star(wait), at(hall), [at(hall), door(locked)])), !]).
step(call(diamond(star(wait), at(hall), [at(hall), door(locked)])), builtin, [], []).
step(boolean(diamond(seq(test(door(open)), walk_to_garden), at(garden), [at(hall), door(open)]), true),
     rule(18),
     ['Goal' = diamond(seq(test(door(open)), walk_to_garden), at(garden), [at(hall), door(open)])],
     [call(diamond(seq(test(door(open)), walk_to_garden), at(garden), [at(hall), door(open)])),
      !]).
step(call(diamond(seq(test(door(open)), walk_to_garden), at(garden), [at(hall), door(open)])),
     builtin,
     [],
     []).
