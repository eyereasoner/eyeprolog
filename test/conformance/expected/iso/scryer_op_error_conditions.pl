% Prolog result format 4
query(1, comma_operator_immutable(_0, _1, _2), ['E1' = _0, 'E2' = _1, 'E3' = _2]).
result(1, complete, 1).
answer(1,
       ['E1' = permission_error(modify, operator, ','),
        'E2' = permission_error(modify, operator, ','),
        'E3' = permission_error(modify, operator, ',')]).
query(2, bar_low_priority_rejected(_0), ['E' = _0]).
result(2, complete, 1).
answer(2, ['E' = permission_error(create, operator, '|')]).
query(3, invalid_operator_specifier(_0), ['E' = _0]).
result(3, complete, 1).
answer(3, ['E' = domain_error(operator_specifier, yfy)]).
query(4, curly_braces_operator_rejected(_0), ['E' = _0]).
result(4, complete, 1).
answer(4, ['E' = permission_error(create, operator, {})]).
query(5, infix_postfix_clash_rejected(_0), ['E' = _0]).
result(5, complete, 1).
answer(5, ['E' = permission_error(create, operator, >)]).
