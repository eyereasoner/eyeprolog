answer(true, true, true, false, true, true, true).
why(
  answer(true, true, true, false, true, true, true),
  proof(
    goal(answer(true, true, true, false, true, true, true)),
    by(rule("propositional-dynamic-logic.pl", clause(17))),
    bindings([binding("FullPathReachesGarden", true), binding("VacuousBoxHolds", true), binding("GenuineBoxHolds", true), binding("ChoiceBoxFails", false), binding("ChoiceDiamondHolds", true), binding("StarPreservesLocation", true), binding("TestGuardedPathWorks", true), binding("Locked", [at(hall), door(locked)]), binding("Open", [at(hall), door(open)])]),
    uses([
      proof(
        goal(=([at(hall), door(locked)], [at(hall), door(locked)])),
        by(builtin(=, 2))
      ),
      proof(
        goal(=([at(hall), door(open)], [at(hall), door(open)])),
        by(builtin(=, 2))
      ),
      proof(
        goal(boolean(diamond(seq(unlock, seq(open_door, walk_to_garden)), at(garden), [at(hall), door(locked)]), true)),
        by(rule("propositional-dynamic-logic.pl", clause(18))),
        bindings([binding("Goal", diamond(seq(unlock, seq(open_door, walk_to_garden)), at(garden), [at(hall), door(locked)]))]),
        uses([
          proof(
            goal(call(diamond(seq(unlock, seq(open_door, walk_to_garden)), at(garden), [at(hall), door(locked)]))),
            by(builtin(call, 1))
          ),
          proof(
            goal(!),
            by(builtin(goal, 0))
          )
        ])
      ),
      proof(
        goal('\\+'(run(open_door, [at(hall), door(locked)], __anon3))),
        by(builtin('\\+', 1))
      ),
      proof(
        goal(boolean(box(open_door, at(garden), [at(hall), door(locked)]), true)),
        by(rule("propositional-dynamic-logic.pl", clause(18))),
        bindings([binding("Goal", box(open_door, at(garden), [at(hall), door(locked)]))]),
        uses([
          proof(
            goal(call(box(open_door, at(garden), [at(hall), door(locked)]))),
            by(builtin(call, 1))
          ),
          proof(
            goal(!),
            by(builtin(goal, 0))
          )
        ])
      ),
      proof(
        goal(boolean(box(walk_to_garden, at(garden), [at(hall), door(open)]), true)),
        by(rule("propositional-dynamic-logic.pl", clause(18))),
        bindings([binding("Goal", box(walk_to_garden, at(garden), [at(hall), door(open)]))]),
        uses([
          proof(
            goal(call(box(walk_to_garden, at(garden), [at(hall), door(open)]))),
            by(builtin(call, 1))
          ),
          proof(
            goal(!),
            by(builtin(goal, 0))
          )
        ])
      ),
      proof(
        goal(boolean(box(choice(walk_to_garden, wait), at(garden), [at(hall), door(open)]), false)),
        by(fact("propositional-dynamic-logic.pl", clause(19))),
        bindings([binding("__anon4", box(choice(walk_to_garden, wait), at(garden), [at(hall), door(open)]))])
      ),
      proof(
        goal(boolean(diamond(choice(walk_to_garden, wait), at(garden), [at(hall), door(open)]), true)),
        by(rule("propositional-dynamic-logic.pl", clause(18))),
        bindings([binding("Goal", diamond(choice(walk_to_garden, wait), at(garden), [at(hall), door(open)]))]),
        uses([
          proof(
            goal(call(diamond(choice(walk_to_garden, wait), at(garden), [at(hall), door(open)]))),
            by(builtin(call, 1))
          ),
          proof(
            goal(!),
            by(builtin(goal, 0))
          )
        ])
      ),
      proof(
        goal(boolean(diamond(star(wait), at(hall), [at(hall), door(locked)]), true)),
        by(rule("propositional-dynamic-logic.pl", clause(18))),
        bindings([binding("Goal", diamond(star(wait), at(hall), [at(hall), door(locked)]))]),
        uses([
          proof(
            goal(call(diamond(star(wait), at(hall), [at(hall), door(locked)]))),
            by(builtin(call, 1))
          ),
          proof(
            goal(!),
            by(builtin(goal, 0))
          )
        ])
      ),
      proof(
        goal(boolean(diamond(seq(test(door(open)), walk_to_garden), at(garden), [at(hall), door(open)]), true)),
        by(rule("propositional-dynamic-logic.pl", clause(18))),
        bindings([binding("Goal", diamond(seq(test(door(open)), walk_to_garden), at(garden), [at(hall), door(open)]))]),
        uses([
          proof(
            goal(call(diamond(seq(test(door(open)), walk_to_garden), at(garden), [at(hall), door(open)]))),
            by(builtin(call, 1))
          ),
          proof(
            goal(!),
            by(builtin(goal, 0))
          )
        ])
      )
    ])
  )
).

