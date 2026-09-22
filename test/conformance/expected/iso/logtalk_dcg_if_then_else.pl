% Prolog result format 4
query(1, phrase(select, [x, then]), []).
result(1, complete, 1).
answer(1, []).
query(2, phrase(select, [else]), []).
result(2, complete, 1).
answer(2, []).
query(3, phrase(after_prefix, [start, x, yes]), []).
result(3, complete, 1).
answer(3, []).
query(4, phrase(after_prefix, [start, no]), []).
result(4, complete, 1).
answer(4, []).
query(5, phrase(condition_sequence, "abc"), []).
result(5, complete, 1).
answer(5, []).
query(6, phrase(condition_sequence, "d"), []).
result(6, complete, 1).
answer(6, []).
query(7, phrase(embedded_condition, _0), ['X' = _0]).
result(7, complete, 1).
answer(7, ['X' = [yes]]).
