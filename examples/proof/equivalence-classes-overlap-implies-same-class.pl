sameClassBecauseOfSharedMember(a, b, a).
why(
  sameClassBecauseOfSharedMember(a, b, a),
  step(
    sameClassBecauseOfSharedMember(a, b, a),
    rule("equivalence-classes-overlap-implies-same-class.pl", clause(6)),
    ['X' = a, 'Y' = b, 'Z' = a],
    [
      step(
        inClassOf(a, a),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(4)),
        ['U' = a, 'X' = a, 'Class' = class_abc],
        [
          step(classMember(class_abc, a), fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)), [], []),
          step(classMember(class_abc, a), fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)), [], [])
        ]
      ),
      step(
        inClassOf(a, b),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(4)),
        ['U' = a, 'X' = b, 'Class' = class_abc],
        [
          step(classMember(class_abc, a), fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)), [], []),
          step(classMember(class_abc, b), fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)), [], [])
        ]
      ),
      step(
        sameClass(a, b),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(5)),
        ['X' = a, 'Y' = b, 'Class' = class_abc],
        [
          step(classMember(class_abc, a), fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)), [], []),
          step(classMember(class_abc, b), fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)), [], [])
        ]
      ),
      step(\=(a, b), builtin(\=, 2), [], [])
    ]
  )
).

sameClassBecauseOfSharedMember(a, c, a).
why(
  sameClassBecauseOfSharedMember(a, c, a),
  step(
    sameClassBecauseOfSharedMember(a, c, a),
    rule("equivalence-classes-overlap-implies-same-class.pl", clause(6)),
    ['X' = a, 'Y' = c, 'Z' = a],
    [
      step(
        inClassOf(a, a),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(4)),
        ['U' = a, 'X' = a, 'Class' = class_abc],
        [
          step(classMember(class_abc, a), fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)), [], []),
          step(classMember(class_abc, a), fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)), [], [])
        ]
      ),
      step(
        inClassOf(a, c),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(4)),
        ['U' = a, 'X' = c, 'Class' = class_abc],
        [
          step(classMember(class_abc, a), fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)), [], []),
          step(classMember(class_abc, c), fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)), [], [])
        ]
      ),
      step(
        sameClass(a, c),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(5)),
        ['X' = a, 'Y' = c, 'Class' = class_abc],
        [
          step(classMember(class_abc, a), fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)), [], []),
          step(classMember(class_abc, c), fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)), [], [])
        ]
      ),
      step(\=(a, c), builtin(\=, 2), [], [])
    ]
  )
).

sameClassBecauseOfSharedMember(b, a, a).
why(
  sameClassBecauseOfSharedMember(b, a, a),
  step(
    sameClassBecauseOfSharedMember(b, a, a),
    rule("equivalence-classes-overlap-implies-same-class.pl", clause(6)),
    ['X' = b, 'Y' = a, 'Z' = a],
    [
      step(
        inClassOf(a, b),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(4)),
        ['U' = a, 'X' = b, 'Class' = class_abc],
        [
          step(classMember(class_abc, a), fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)), [], []),
          step(classMember(class_abc, b), fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)), [], [])
        ]
      ),
      step(
        inClassOf(a, a),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(4)),
        ['U' = a, 'X' = a, 'Class' = class_abc],
        [
          step(classMember(class_abc, a), fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)), [], []),
          step(classMember(class_abc, a), fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)), [], [])
        ]
      ),
      step(
        sameClass(b, a),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(5)),
        ['X' = b, 'Y' = a, 'Class' = class_abc],
        [
          step(classMember(class_abc, b), fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)), [], []),
          step(classMember(class_abc, a), fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)), [], [])
        ]
      ),
      step(\=(b, a), builtin(\=, 2), [], [])
    ]
  )
).

sameClassBecauseOfSharedMember(b, c, a).
why(
  sameClassBecauseOfSharedMember(b, c, a),
  step(
    sameClassBecauseOfSharedMember(b, c, a),
    rule("equivalence-classes-overlap-implies-same-class.pl", clause(6)),
    ['X' = b, 'Y' = c, 'Z' = a],
    [
      step(
        inClassOf(a, b),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(4)),
        ['U' = a, 'X' = b, 'Class' = class_abc],
        [
          step(classMember(class_abc, a), fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)), [], []),
          step(classMember(class_abc, b), fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)), [], [])
        ]
      ),
      step(
        inClassOf(a, c),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(4)),
        ['U' = a, 'X' = c, 'Class' = class_abc],
        [
          step(classMember(class_abc, a), fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)), [], []),
          step(classMember(class_abc, c), fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)), [], [])
        ]
      ),
      step(
        sameClass(b, c),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(5)),
        ['X' = b, 'Y' = c, 'Class' = class_abc],
        [
          step(classMember(class_abc, b), fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)), [], []),
          step(classMember(class_abc, c), fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)), [], [])
        ]
      ),
      step(\=(b, c), builtin(\=, 2), [], [])
    ]
  )
).

sameClassBecauseOfSharedMember(c, a, a).
why(
  sameClassBecauseOfSharedMember(c, a, a),
  step(
    sameClassBecauseOfSharedMember(c, a, a),
    rule("equivalence-classes-overlap-implies-same-class.pl", clause(6)),
    ['X' = c, 'Y' = a, 'Z' = a],
    [
      step(
        inClassOf(a, c),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(4)),
        ['U' = a, 'X' = c, 'Class' = class_abc],
        [
          step(classMember(class_abc, a), fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)), [], []),
          step(classMember(class_abc, c), fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)), [], [])
        ]
      ),
      step(
        inClassOf(a, a),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(4)),
        ['U' = a, 'X' = a, 'Class' = class_abc],
        [
          step(classMember(class_abc, a), fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)), [], []),
          step(classMember(class_abc, a), fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)), [], [])
        ]
      ),
      step(
        sameClass(c, a),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(5)),
        ['X' = c, 'Y' = a, 'Class' = class_abc],
        [
          step(classMember(class_abc, c), fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)), [], []),
          step(classMember(class_abc, a), fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)), [], [])
        ]
      ),
      step(\=(c, a), builtin(\=, 2), [], [])
    ]
  )
).

sameClassBecauseOfSharedMember(c, b, a).
why(
  sameClassBecauseOfSharedMember(c, b, a),
  step(
    sameClassBecauseOfSharedMember(c, b, a),
    rule("equivalence-classes-overlap-implies-same-class.pl", clause(6)),
    ['X' = c, 'Y' = b, 'Z' = a],
    [
      step(
        inClassOf(a, c),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(4)),
        ['U' = a, 'X' = c, 'Class' = class_abc],
        [
          step(classMember(class_abc, a), fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)), [], []),
          step(classMember(class_abc, c), fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)), [], [])
        ]
      ),
      step(
        inClassOf(a, b),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(4)),
        ['U' = a, 'X' = b, 'Class' = class_abc],
        [
          step(classMember(class_abc, a), fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)), [], []),
          step(classMember(class_abc, b), fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)), [], [])
        ]
      ),
      step(
        sameClass(c, b),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(5)),
        ['X' = c, 'Y' = b, 'Class' = class_abc],
        [
          step(classMember(class_abc, c), fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)), [], []),
          step(classMember(class_abc, b), fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)), [], [])
        ]
      ),
      step(\=(c, b), builtin(\=, 2), [], [])
    ]
  )
).

sameClassBecauseOfSharedMember(a, b, b).
why(
  sameClassBecauseOfSharedMember(a, b, b),
  step(
    sameClassBecauseOfSharedMember(a, b, b),
    rule("equivalence-classes-overlap-implies-same-class.pl", clause(6)),
    ['X' = a, 'Y' = b, 'Z' = b],
    [
      step(
        inClassOf(b, a),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(4)),
        ['U' = b, 'X' = a, 'Class' = class_abc],
        [
          step(classMember(class_abc, b), fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)), [], []),
          step(classMember(class_abc, a), fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)), [], [])
        ]
      ),
      step(
        inClassOf(b, b),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(4)),
        ['U' = b, 'X' = b, 'Class' = class_abc],
        [
          step(classMember(class_abc, b), fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)), [], []),
          step(classMember(class_abc, b), fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)), [], [])
        ]
      ),
      step(
        sameClass(a, b),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(5)),
        ['X' = a, 'Y' = b, 'Class' = class_abc],
        [
          step(classMember(class_abc, a), fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)), [], []),
          step(classMember(class_abc, b), fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)), [], [])
        ]
      ),
      step(\=(a, b), builtin(\=, 2), [], [])
    ]
  )
).

sameClassBecauseOfSharedMember(a, c, b).
why(
  sameClassBecauseOfSharedMember(a, c, b),
  step(
    sameClassBecauseOfSharedMember(a, c, b),
    rule("equivalence-classes-overlap-implies-same-class.pl", clause(6)),
    ['X' = a, 'Y' = c, 'Z' = b],
    [
      step(
        inClassOf(b, a),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(4)),
        ['U' = b, 'X' = a, 'Class' = class_abc],
        [
          step(classMember(class_abc, b), fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)), [], []),
          step(classMember(class_abc, a), fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)), [], [])
        ]
      ),
      step(
        inClassOf(b, c),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(4)),
        ['U' = b, 'X' = c, 'Class' = class_abc],
        [
          step(classMember(class_abc, b), fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)), [], []),
          step(classMember(class_abc, c), fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)), [], [])
        ]
      ),
      step(
        sameClass(a, c),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(5)),
        ['X' = a, 'Y' = c, 'Class' = class_abc],
        [
          step(classMember(class_abc, a), fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)), [], []),
          step(classMember(class_abc, c), fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)), [], [])
        ]
      ),
      step(\=(a, c), builtin(\=, 2), [], [])
    ]
  )
).

sameClassBecauseOfSharedMember(b, a, b).
why(
  sameClassBecauseOfSharedMember(b, a, b),
  step(
    sameClassBecauseOfSharedMember(b, a, b),
    rule("equivalence-classes-overlap-implies-same-class.pl", clause(6)),
    ['X' = b, 'Y' = a, 'Z' = b],
    [
      step(
        inClassOf(b, b),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(4)),
        ['U' = b, 'X' = b, 'Class' = class_abc],
        [
          step(classMember(class_abc, b), fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)), [], []),
          step(classMember(class_abc, b), fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)), [], [])
        ]
      ),
      step(
        inClassOf(b, a),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(4)),
        ['U' = b, 'X' = a, 'Class' = class_abc],
        [
          step(classMember(class_abc, b), fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)), [], []),
          step(classMember(class_abc, a), fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)), [], [])
        ]
      ),
      step(
        sameClass(b, a),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(5)),
        ['X' = b, 'Y' = a, 'Class' = class_abc],
        [
          step(classMember(class_abc, b), fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)), [], []),
          step(classMember(class_abc, a), fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)), [], [])
        ]
      ),
      step(\=(b, a), builtin(\=, 2), [], [])
    ]
  )
).

sameClassBecauseOfSharedMember(b, c, b).
why(
  sameClassBecauseOfSharedMember(b, c, b),
  step(
    sameClassBecauseOfSharedMember(b, c, b),
    rule("equivalence-classes-overlap-implies-same-class.pl", clause(6)),
    ['X' = b, 'Y' = c, 'Z' = b],
    [
      step(
        inClassOf(b, b),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(4)),
        ['U' = b, 'X' = b, 'Class' = class_abc],
        [
          step(classMember(class_abc, b), fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)), [], []),
          step(classMember(class_abc, b), fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)), [], [])
        ]
      ),
      step(
        inClassOf(b, c),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(4)),
        ['U' = b, 'X' = c, 'Class' = class_abc],
        [
          step(classMember(class_abc, b), fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)), [], []),
          step(classMember(class_abc, c), fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)), [], [])
        ]
      ),
      step(
        sameClass(b, c),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(5)),
        ['X' = b, 'Y' = c, 'Class' = class_abc],
        [
          step(classMember(class_abc, b), fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)), [], []),
          step(classMember(class_abc, c), fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)), [], [])
        ]
      ),
      step(\=(b, c), builtin(\=, 2), [], [])
    ]
  )
).

sameClassBecauseOfSharedMember(c, a, b).
why(
  sameClassBecauseOfSharedMember(c, a, b),
  step(
    sameClassBecauseOfSharedMember(c, a, b),
    rule("equivalence-classes-overlap-implies-same-class.pl", clause(6)),
    ['X' = c, 'Y' = a, 'Z' = b],
    [
      step(
        inClassOf(b, c),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(4)),
        ['U' = b, 'X' = c, 'Class' = class_abc],
        [
          step(classMember(class_abc, b), fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)), [], []),
          step(classMember(class_abc, c), fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)), [], [])
        ]
      ),
      step(
        inClassOf(b, a),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(4)),
        ['U' = b, 'X' = a, 'Class' = class_abc],
        [
          step(classMember(class_abc, b), fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)), [], []),
          step(classMember(class_abc, a), fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)), [], [])
        ]
      ),
      step(
        sameClass(c, a),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(5)),
        ['X' = c, 'Y' = a, 'Class' = class_abc],
        [
          step(classMember(class_abc, c), fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)), [], []),
          step(classMember(class_abc, a), fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)), [], [])
        ]
      ),
      step(\=(c, a), builtin(\=, 2), [], [])
    ]
  )
).

sameClassBecauseOfSharedMember(c, b, b).
why(
  sameClassBecauseOfSharedMember(c, b, b),
  step(
    sameClassBecauseOfSharedMember(c, b, b),
    rule("equivalence-classes-overlap-implies-same-class.pl", clause(6)),
    ['X' = c, 'Y' = b, 'Z' = b],
    [
      step(
        inClassOf(b, c),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(4)),
        ['U' = b, 'X' = c, 'Class' = class_abc],
        [
          step(classMember(class_abc, b), fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)), [], []),
          step(classMember(class_abc, c), fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)), [], [])
        ]
      ),
      step(
        inClassOf(b, b),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(4)),
        ['U' = b, 'X' = b, 'Class' = class_abc],
        [
          step(classMember(class_abc, b), fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)), [], []),
          step(classMember(class_abc, b), fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)), [], [])
        ]
      ),
      step(
        sameClass(c, b),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(5)),
        ['X' = c, 'Y' = b, 'Class' = class_abc],
        [
          step(classMember(class_abc, c), fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)), [], []),
          step(classMember(class_abc, b), fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)), [], [])
        ]
      ),
      step(\=(c, b), builtin(\=, 2), [], [])
    ]
  )
).

sameClassBecauseOfSharedMember(a, b, c).
why(
  sameClassBecauseOfSharedMember(a, b, c),
  step(
    sameClassBecauseOfSharedMember(a, b, c),
    rule("equivalence-classes-overlap-implies-same-class.pl", clause(6)),
    ['X' = a, 'Y' = b, 'Z' = c],
    [
      step(
        inClassOf(c, a),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(4)),
        ['U' = c, 'X' = a, 'Class' = class_abc],
        [
          step(classMember(class_abc, c), fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)), [], []),
          step(classMember(class_abc, a), fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)), [], [])
        ]
      ),
      step(
        inClassOf(c, b),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(4)),
        ['U' = c, 'X' = b, 'Class' = class_abc],
        [
          step(classMember(class_abc, c), fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)), [], []),
          step(classMember(class_abc, b), fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)), [], [])
        ]
      ),
      step(
        sameClass(a, b),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(5)),
        ['X' = a, 'Y' = b, 'Class' = class_abc],
        [
          step(classMember(class_abc, a), fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)), [], []),
          step(classMember(class_abc, b), fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)), [], [])
        ]
      ),
      step(\=(a, b), builtin(\=, 2), [], [])
    ]
  )
).

sameClassBecauseOfSharedMember(a, c, c).
why(
  sameClassBecauseOfSharedMember(a, c, c),
  step(
    sameClassBecauseOfSharedMember(a, c, c),
    rule("equivalence-classes-overlap-implies-same-class.pl", clause(6)),
    ['X' = a, 'Y' = c, 'Z' = c],
    [
      step(
        inClassOf(c, a),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(4)),
        ['U' = c, 'X' = a, 'Class' = class_abc],
        [
          step(classMember(class_abc, c), fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)), [], []),
          step(classMember(class_abc, a), fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)), [], [])
        ]
      ),
      step(
        inClassOf(c, c),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(4)),
        ['U' = c, 'X' = c, 'Class' = class_abc],
        [
          step(classMember(class_abc, c), fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)), [], []),
          step(classMember(class_abc, c), fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)), [], [])
        ]
      ),
      step(
        sameClass(a, c),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(5)),
        ['X' = a, 'Y' = c, 'Class' = class_abc],
        [
          step(classMember(class_abc, a), fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)), [], []),
          step(classMember(class_abc, c), fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)), [], [])
        ]
      ),
      step(\=(a, c), builtin(\=, 2), [], [])
    ]
  )
).

sameClassBecauseOfSharedMember(b, a, c).
why(
  sameClassBecauseOfSharedMember(b, a, c),
  step(
    sameClassBecauseOfSharedMember(b, a, c),
    rule("equivalence-classes-overlap-implies-same-class.pl", clause(6)),
    ['X' = b, 'Y' = a, 'Z' = c],
    [
      step(
        inClassOf(c, b),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(4)),
        ['U' = c, 'X' = b, 'Class' = class_abc],
        [
          step(classMember(class_abc, c), fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)), [], []),
          step(classMember(class_abc, b), fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)), [], [])
        ]
      ),
      step(
        inClassOf(c, a),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(4)),
        ['U' = c, 'X' = a, 'Class' = class_abc],
        [
          step(classMember(class_abc, c), fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)), [], []),
          step(classMember(class_abc, a), fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)), [], [])
        ]
      ),
      step(
        sameClass(b, a),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(5)),
        ['X' = b, 'Y' = a, 'Class' = class_abc],
        [
          step(classMember(class_abc, b), fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)), [], []),
          step(classMember(class_abc, a), fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)), [], [])
        ]
      ),
      step(\=(b, a), builtin(\=, 2), [], [])
    ]
  )
).

sameClassBecauseOfSharedMember(b, c, c).
why(
  sameClassBecauseOfSharedMember(b, c, c),
  step(
    sameClassBecauseOfSharedMember(b, c, c),
    rule("equivalence-classes-overlap-implies-same-class.pl", clause(6)),
    ['X' = b, 'Y' = c, 'Z' = c],
    [
      step(
        inClassOf(c, b),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(4)),
        ['U' = c, 'X' = b, 'Class' = class_abc],
        [
          step(classMember(class_abc, c), fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)), [], []),
          step(classMember(class_abc, b), fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)), [], [])
        ]
      ),
      step(
        inClassOf(c, c),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(4)),
        ['U' = c, 'X' = c, 'Class' = class_abc],
        [
          step(classMember(class_abc, c), fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)), [], []),
          step(classMember(class_abc, c), fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)), [], [])
        ]
      ),
      step(
        sameClass(b, c),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(5)),
        ['X' = b, 'Y' = c, 'Class' = class_abc],
        [
          step(classMember(class_abc, b), fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)), [], []),
          step(classMember(class_abc, c), fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)), [], [])
        ]
      ),
      step(\=(b, c), builtin(\=, 2), [], [])
    ]
  )
).

sameClassBecauseOfSharedMember(c, a, c).
why(
  sameClassBecauseOfSharedMember(c, a, c),
  step(
    sameClassBecauseOfSharedMember(c, a, c),
    rule("equivalence-classes-overlap-implies-same-class.pl", clause(6)),
    ['X' = c, 'Y' = a, 'Z' = c],
    [
      step(
        inClassOf(c, c),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(4)),
        ['U' = c, 'X' = c, 'Class' = class_abc],
        [
          step(classMember(class_abc, c), fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)), [], []),
          step(classMember(class_abc, c), fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)), [], [])
        ]
      ),
      step(
        inClassOf(c, a),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(4)),
        ['U' = c, 'X' = a, 'Class' = class_abc],
        [
          step(classMember(class_abc, c), fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)), [], []),
          step(classMember(class_abc, a), fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)), [], [])
        ]
      ),
      step(
        sameClass(c, a),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(5)),
        ['X' = c, 'Y' = a, 'Class' = class_abc],
        [
          step(classMember(class_abc, c), fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)), [], []),
          step(classMember(class_abc, a), fact("equivalence-classes-overlap-implies-same-class.pl", clause(1)), [], [])
        ]
      ),
      step(\=(c, a), builtin(\=, 2), [], [])
    ]
  )
).

sameClassBecauseOfSharedMember(c, b, c).
why(
  sameClassBecauseOfSharedMember(c, b, c),
  step(
    sameClassBecauseOfSharedMember(c, b, c),
    rule("equivalence-classes-overlap-implies-same-class.pl", clause(6)),
    ['X' = c, 'Y' = b, 'Z' = c],
    [
      step(
        inClassOf(c, c),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(4)),
        ['U' = c, 'X' = c, 'Class' = class_abc],
        [
          step(classMember(class_abc, c), fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)), [], []),
          step(classMember(class_abc, c), fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)), [], [])
        ]
      ),
      step(
        inClassOf(c, b),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(4)),
        ['U' = c, 'X' = b, 'Class' = class_abc],
        [
          step(classMember(class_abc, c), fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)), [], []),
          step(classMember(class_abc, b), fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)), [], [])
        ]
      ),
      step(
        sameClass(c, b),
        rule("equivalence-classes-overlap-implies-same-class.pl", clause(5)),
        ['X' = c, 'Y' = b, 'Class' = class_abc],
        [
          step(classMember(class_abc, c), fact("equivalence-classes-overlap-implies-same-class.pl", clause(3)), [], []),
          step(classMember(class_abc, b), fact("equivalence-classes-overlap-implies-same-class.pl", clause(2)), [], [])
        ]
      ),
      step(\=(c, b), builtin(\=, 2), [], [])
    ]
  )
).

