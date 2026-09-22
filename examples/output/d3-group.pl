% Prolog result format 4
query(1, subgroups(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1,
       ['X0' = d3_group,
        'X1' = [[identity], [identity, reflection_a], [identity, reflection_a, reflection_b, reflection_c, rotation_120, rotation_240], [identity, reflection_b], [identity, reflection_c], [identity, rotation_120, rotation_240]]]).
query(2, subgroupCount(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = d3_group, 'X1' = 6]).
query(3, reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 0).
