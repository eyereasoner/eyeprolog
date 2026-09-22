answer(true, true, true, false, true, true, true).
why(
  answer(true, true, true, false, true, true, true),
  step(
    answer(true, true, true, false, true, true, true),
    rule("propositional-dynamic-logic.pl", clause(17)),
    ['FullPathReachesGarden' = true, 'VacuousBoxHolds' = true, 'GenuineBoxHolds' = true, 'ChoiceBoxFails' = false, 'ChoiceDiamondHolds' = true, 'StarPreservesLocation' = true, 'TestGuardedPathWorks' = true, 'Locked' = [at(hall), door(locked)], 'Open' = [at(hall), door(open)]],
    [
      step(=([at(hall), door(locked)], [at(hall), door(locked)]), builtin(=, 2), [], []),
      step(=([at(hall), door(open)], [at(hall), door(open)]), builtin(=, 2), [], []),
      step(
        boolean(diamond(seq(unlock, seq(open_door, walk_to_garden)), at(garden), [at(hall), door(locked)]), true),
        rule("propositional-dynamic-logic.pl", clause(18)),
        ['Goal' = diamond(seq(unlock, seq(open_door, walk_to_garden)), at(garden), [at(hall), door(locked)])],
        [
          step(call(diamond(seq(unlock, seq(open_door, walk_to_garden)), at(garden), [at(hall), door(locked)])), builtin(call, 1), [], []),
          step(!, builtin(goal, 0), [], [])
        ]
      ),
      step('\\+'(run(open_door, [at(hall), door(locked)], __anon3)), builtin('\\+', 1), [], []),
      step(
        boolean(box(open_door, at(garden), [at(hall), door(locked)]), true),
        rule("propositional-dynamic-logic.pl", clause(18)),
        ['Goal' = box(open_door, at(garden), [at(hall), door(locked)])],
        [
          step(call(box(open_door, at(garden), [at(hall), door(locked)])), builtin(call, 1), [], []),
          step(!, builtin(goal, 0), [], [])
        ]
      ),
      step(
        boolean(box(walk_to_garden, at(garden), [at(hall), door(open)]), true),
        rule("propositional-dynamic-logic.pl", clause(18)),
        ['Goal' = box(walk_to_garden, at(garden), [at(hall), door(open)])],
        [
          step(call(box(walk_to_garden, at(garden), [at(hall), door(open)])), builtin(call, 1), [], []),
          step(!, builtin(goal, 0), [], [])
        ]
      ),
      step(boolean(box(choice(walk_to_garden, wait), at(garden), [at(hall), door(open)]), false), fact("propositional-dynamic-logic.pl", clause(19)), ['__anon4' = box(choice(walk_to_garden, wait), at(garden), [at(hall), door(open)])], []),
      step(
        boolean(diamond(choice(walk_to_garden, wait), at(garden), [at(hall), door(open)]), true),
        rule("propositional-dynamic-logic.pl", clause(18)),
        ['Goal' = diamond(choice(walk_to_garden, wait), at(garden), [at(hall), door(open)])],
        [
          step(call(diamond(choice(walk_to_garden, wait), at(garden), [at(hall), door(open)])), builtin(call, 1), [], []),
          step(!, builtin(goal, 0), [], [])
        ]
      ),
      step(
        boolean(diamond(star(wait), at(hall), [at(hall), door(locked)]), true),
        rule("propositional-dynamic-logic.pl", clause(18)),
        ['Goal' = diamond(star(wait), at(hall), [at(hall), door(locked)])],
        [
          step(call(diamond(star(wait), at(hall), [at(hall), door(locked)])), builtin(call, 1), [], []),
          step(!, builtin(goal, 0), [], [])
        ]
      ),
      step(
        boolean(diamond(seq(test(door(open)), walk_to_garden), at(garden), [at(hall), door(open)]), true),
        rule("propositional-dynamic-logic.pl", clause(18)),
        ['Goal' = diamond(seq(test(door(open)), walk_to_garden), at(garden), [at(hall), door(open)])],
        [
          step(call(diamond(seq(test(door(open)), walk_to_garden), at(garden), [at(hall), door(open)])), builtin(call, 1), [], []),
          step(!, builtin(goal, 0), [], [])
        ]
      )
    ]
  )
).

