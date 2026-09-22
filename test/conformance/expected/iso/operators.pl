% Prolog result format 4
query(1, operator_terms(_0, _1, _2, _3), ['A' = _0, 'B' = _1, 'C' = _2, 'D' = _3]).
result(1, complete, 1).
answer(1,
       ['A' = alice likes bob likes carol,
        'B' = alice then bob then carol,
        'C' = maybe maybe alice,
        'D' = alice done done]).
query(2, declared_operator(_0, _1), ['P' = _0, 'S' = _1]).
result(2, complete, 1).
answer(2, ['P' = 500, 'S' = xfy]).
query(3, operator_list_declaration(_0, _1), ['A' = _0, 'B' = _1]).
result(3, complete, 1).
answer(3, ['A' = alice links bob, 'B' = alice relates bob]).
query(4, runtime_operator(_0, _1), ['P' = _0, 'S' = _1]).
result(4, complete, 1).
answer(4, ['P' = 675, 'S' = xfx]).
query(5, removed_operator(ok), []).
result(5, complete, 1).
answer(5, []).
