% Prolog result format 4
query(1, answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 8).
answer(1, ['X0' = term, 'X1' = kind(alert)]).
answer(1, ['X0' = term, 'X1' = severity(high)]).
answer(1, ['X0' = term, 'X1' = owner(alice)]).
answer(1, ['X0' = parts, 'X1' = pair(kind, [alert])]).
answer(1, ['X0' = parts, 'X1' = pair(severity, [high])]).
answer(1, ['X0' = parts, 'X1' = pair(owner, [alice])]).
answer(1, ['X0' = filter, 'X1' = alice]).
answer(1, ['X0' = missing_rejected, 'X1' = ok]).
