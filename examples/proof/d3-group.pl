% Prolog result format 4
query(1, subgroups(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1,
       ['X0' = d3_group,
        'X1' = [[identity], [identity, reflection_a], [identity, reflection_a, reflection_b, reflection_c, rotation_120, rotation_240], [identity, reflection_b], [identity, reflection_c], [identity, rotation_120, rotation_240]]]).
why(1,
    ['X0' = d3_group,
     'X1' = [[identity], [identity, reflection_a], [identity, reflection_a, reflection_b, reflection_c, rotation_120, rotation_240], [identity, reflection_b], [identity, reflection_c], [identity, rotation_120, rotation_240]]],
    [subgroups(d3_group, [[identity], [identity, reflection_a], [identity, reflection_a, reflection_b, reflection_c, rotation_120, rotation_240], [identity, reflection_b], [identity, reflection_c], [identity, rotation_120, rotation_240]])]).
query(2, subgroupCount(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = d3_group, 'X1' = 6]).
why(2, ['X0' = d3_group, 'X1' = 6], [subgroupCount(d3_group, 6)]).
query(3, reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 0).

clause(56,
       all_subgroups(var('Groups')),
       (findall(var('G'), valid_group(var('G')), var('Raw')), sort(var('Raw'), var('Groups')))).
clause(57, subgroups(d3_group, var('Groups')), all_subgroups(var('Groups'))).
clause(58,
       subgroupCount(d3_group, var('Count')),
       (all_subgroups(var('Groups')), length(var('Groups'), var('Count')))).

step(subgroups(d3_group, [[identity], [identity, reflection_a], [identity, reflection_a, reflection_b, reflection_c, rotation_120, rotation_240], [identity, reflection_b], [identity, reflection_c], [identity, rotation_120, rotation_240]]),
     rule(57),
     ['Groups' = [[identity], [identity, reflection_a], [identity, reflection_a, reflection_b, reflection_c, rotation_120, rotation_240], [identity, reflection_b], [identity, reflection_c], [identity, rotation_120, rotation_240]]],
     [all_subgroups([[identity], [identity, reflection_a], [identity, reflection_a, reflection_b, reflection_c, rotation_120, rotation_240], [identity, reflection_b], [identity, reflection_c], [identity, rotation_120, rotation_240]])]).
step(all_subgroups([[identity], [identity, reflection_a], [identity, reflection_a, reflection_b, reflection_c, rotation_120, rotation_240], [identity, reflection_b], [identity, reflection_c], [identity, rotation_120, rotation_240]]),
     rule(56),
     ['Groups' = [[identity], [identity, reflection_a], [identity, reflection_a, reflection_b, reflection_c, rotation_120, rotation_240], [identity, reflection_b], [identity, reflection_c], [identity, rotation_120, rotation_240]],
      'Raw' = [[identity, reflection_a, reflection_b, reflection_c, rotation_120, rotation_240], [identity, reflection_a], [identity, reflection_b], [identity, reflection_c], [identity, rotation_120, rotation_240], [identity]]],
     [findall(G, valid_group(G), [[identity, reflection_a, reflection_b, reflection_c, rotation_120, rotation_240], [identity, reflection_a], [identity, reflection_b], [identity, reflection_c], [identity, rotation_120, rotation_240], [identity]]),
      sort([[identity, reflection_a, reflection_b, reflection_c, rotation_120, rotation_240], [identity, reflection_a], [identity, reflection_b], [identity, reflection_c], [identity, rotation_120, rotation_240], [identity]], [[identity], [identity, reflection_a], [identity, reflection_a, reflection_b, reflection_c, rotation_120, rotation_240], [identity, reflection_b], [identity, reflection_c], [identity, rotation_120, rotation_240]])]).
step(findall(G, valid_group(G), [[identity, reflection_a, reflection_b, reflection_c, rotation_120, rotation_240], [identity, reflection_a], [identity, reflection_b], [identity, reflection_c], [identity, rotation_120, rotation_240], [identity]]),
     collected,
     [],
     []).
step(sort([[identity, reflection_a, reflection_b, reflection_c, rotation_120, rotation_240], [identity, reflection_a], [identity, reflection_b], [identity, reflection_c], [identity, rotation_120, rotation_240], [identity]], [[identity], [identity, reflection_a], [identity, reflection_a, reflection_b, reflection_c, rotation_120, rotation_240], [identity, reflection_b], [identity, reflection_c], [identity, rotation_120, rotation_240]]),
     builtin,
     [],
     []).
step(subgroupCount(d3_group, 6),
     rule(58),
     ['Count' = 6,
      'Groups' = [[identity], [identity, reflection_a], [identity, reflection_a, reflection_b, reflection_c, rotation_120, rotation_240], [identity, reflection_b], [identity, reflection_c], [identity, rotation_120, rotation_240]]],
     [all_subgroups([[identity], [identity, reflection_a], [identity, reflection_a, reflection_b, reflection_c, rotation_120, rotation_240], [identity, reflection_b], [identity, reflection_c], [identity, rotation_120, rotation_240]]),
      length([[identity], [identity, reflection_a], [identity, reflection_a, reflection_b, reflection_c, rotation_120, rotation_240], [identity, reflection_b], [identity, reflection_c], [identity, rotation_120, rotation_240]], 6)]).
step(length([[identity], [identity, reflection_a], [identity, reflection_a, reflection_b, reflection_c, rotation_120, rotation_240], [identity, reflection_b], [identity, reflection_c], [identity, rotation_120, rotation_240]], 6),
     builtin,
     [],
     []).
