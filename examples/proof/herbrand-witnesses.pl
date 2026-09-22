has_parent(alice, parent_of(alice)).
why(
  has_parent(alice, parent_of(alice)),
  step(
    has_parent(alice, parent_of(alice)),
    rule("herbrand-witnesses.pl", clause(6)),
    ['Child' = alice],
    [
      step(person(alice), fact("herbrand-witnesses.pl", clause(1)), [], [])
    ]
  )
).

has_parent(bob, parent_of(bob)).
why(
  has_parent(bob, parent_of(bob)),
  step(
    has_parent(bob, parent_of(bob)),
    rule("herbrand-witnesses.pl", clause(6)),
    ['Child' = bob],
    [
      step(person(bob), fact("herbrand-witnesses.pl", clause(2)), [], [])
    ]
  )
).

registration(alice, logic, registration_of(alice, logic)).
why(
  registration(alice, logic, registration_of(alice, logic)),
  step(
    registration(alice, logic, registration_of(alice, logic)),
    rule("herbrand-witnesses.pl", clause(7)),
    ['Student' = alice, 'Course' = logic],
    [
      step(takes(alice, logic), fact("herbrand-witnesses.pl", clause(3)), [], [])
    ]
  )
).

registration(alice, math, registration_of(alice, math)).
why(
  registration(alice, math, registration_of(alice, math)),
  step(
    registration(alice, math, registration_of(alice, math)),
    rule("herbrand-witnesses.pl", clause(7)),
    ['Student' = alice, 'Course' = math],
    [
      step(takes(alice, math), fact("herbrand-witnesses.pl", clause(4)), [], [])
    ]
  )
).

registration(bob, logic, registration_of(bob, logic)).
why(
  registration(bob, logic, registration_of(bob, logic)),
  step(
    registration(bob, logic, registration_of(bob, logic)),
    rule("herbrand-witnesses.pl", clause(7)),
    ['Student' = bob, 'Course' = logic],
    [
      step(takes(bob, logic), fact("herbrand-witnesses.pl", clause(5)), [], [])
    ]
  )
).

same_witness(parent_of_alice, true).
why(
  same_witness(parent_of_alice, true),
  step(
    same_witness(parent_of_alice, true),
    rule("herbrand-witnesses.pl", clause(8)),
    [],
    [
      step(=(parent_of(alice), parent_of(alice)), builtin(=, 2), [], [])
    ]
  )
).

distinct_witnesses(alice_logic_vs_alice_math, true).
why(
  distinct_witnesses(alice_logic_vs_alice_math, true),
  step(
    distinct_witnesses(alice_logic_vs_alice_math, true),
    rule("herbrand-witnesses.pl", clause(9)),
    [],
    [
      step(\=(registration_of(alice, logic), registration_of(alice, math)), builtin(\=, 2), [], [])
    ]
  )
).

