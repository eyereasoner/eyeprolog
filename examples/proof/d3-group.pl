subgroups(d3_group, [[identity], [identity, reflection_a], [identity, reflection_a, reflection_b, reflection_c, rotation_120, rotation_240], [identity, reflection_b], [identity, reflection_c], [identity, rotation_120, rotation_240]]).
why(
  subgroups(d3_group, [[identity], [identity, reflection_a], [identity, reflection_a, reflection_b, reflection_c, rotation_120, rotation_240], [identity, reflection_b], [identity, reflection_c], [identity, rotation_120, rotation_240]]),
  step(
    subgroups(d3_group, [[identity], [identity, reflection_a], [identity, reflection_a, reflection_b, reflection_c, rotation_120, rotation_240], [identity, reflection_b], [identity, reflection_c], [identity, rotation_120, rotation_240]]),
    rule("d3-group.pl", clause(57)),
    ['Groups' = [[identity], [identity, reflection_a], [identity, reflection_a, reflection_b, reflection_c, rotation_120, rotation_240], [identity, reflection_b], [identity, reflection_c], [identity, rotation_120, rotation_240]]],
    [
      step(
        all_subgroups([[identity], [identity, reflection_a], [identity, reflection_a, reflection_b, reflection_c, rotation_120, rotation_240], [identity, reflection_b], [identity, reflection_c], [identity, rotation_120, rotation_240]]),
        rule("d3-group.pl", clause(56)),
        ['Groups' = [[identity], [identity, reflection_a], [identity, reflection_a, reflection_b, reflection_c, rotation_120, rotation_240], [identity, reflection_b], [identity, reflection_c], [identity, rotation_120, rotation_240]], 'Raw' = [[identity, reflection_a, reflection_b, reflection_c, rotation_120, rotation_240], [identity, reflection_a], [identity, reflection_b], [identity, reflection_c], [identity, rotation_120, rotation_240], [identity]]],
        [
          step(findall(G, valid_group(G), [[identity, reflection_a, reflection_b, reflection_c, rotation_120, rotation_240], [identity, reflection_a], [identity, reflection_b], [identity, reflection_c], [identity, rotation_120, rotation_240], [identity]]), builtin(findall, 3), [], []),
          step(sort([[identity, reflection_a, reflection_b, reflection_c, rotation_120, rotation_240], [identity, reflection_a], [identity, reflection_b], [identity, reflection_c], [identity, rotation_120, rotation_240], [identity]], [[identity], [identity, reflection_a], [identity, reflection_a, reflection_b, reflection_c, rotation_120, rotation_240], [identity, reflection_b], [identity, reflection_c], [identity, rotation_120, rotation_240]]), builtin(sort, 2), [], [])
        ]
      )
    ]
  )
).

subgroupCount(d3_group, 6).
why(
  subgroupCount(d3_group, 6),
  step(
    subgroupCount(d3_group, 6),
    rule("d3-group.pl", clause(58)),
    ['Count' = 6, 'Groups' = [[identity], [identity, reflection_a], [identity, reflection_a, reflection_b, reflection_c, rotation_120, rotation_240], [identity, reflection_b], [identity, reflection_c], [identity, rotation_120, rotation_240]]],
    [
      step(
        all_subgroups([[identity], [identity, reflection_a], [identity, reflection_a, reflection_b, reflection_c, rotation_120, rotation_240], [identity, reflection_b], [identity, reflection_c], [identity, rotation_120, rotation_240]]),
        rule("d3-group.pl", clause(56)),
        ['Groups' = [[identity], [identity, reflection_a], [identity, reflection_a, reflection_b, reflection_c, rotation_120, rotation_240], [identity, reflection_b], [identity, reflection_c], [identity, rotation_120, rotation_240]], 'Raw' = [[identity, reflection_a, reflection_b, reflection_c, rotation_120, rotation_240], [identity, reflection_a], [identity, reflection_b], [identity, reflection_c], [identity, rotation_120, rotation_240], [identity]]],
        [
          step(findall(G, valid_group(G), [[identity, reflection_a, reflection_b, reflection_c, rotation_120, rotation_240], [identity, reflection_a], [identity, reflection_b], [identity, reflection_c], [identity, rotation_120, rotation_240], [identity]]), builtin(findall, 3), [], []),
          step(sort([[identity, reflection_a, reflection_b, reflection_c, rotation_120, rotation_240], [identity, reflection_a], [identity, reflection_b], [identity, reflection_c], [identity, rotation_120, rotation_240], [identity]], [[identity], [identity, reflection_a], [identity, reflection_a, reflection_b, reflection_c, rotation_120, rotation_240], [identity, reflection_b], [identity, reflection_c], [identity, rotation_120, rotation_240]]), builtin(sort, 2), [], [])
        ]
      ),
      step(length([[identity], [identity, reflection_a], [identity, reflection_a, reflection_b, reflection_c, rotation_120, rotation_240], [identity, reflection_b], [identity, reflection_c], [identity, rotation_120, rotation_240]], 6), library(length, 2), [], [])
    ]
  )
).

