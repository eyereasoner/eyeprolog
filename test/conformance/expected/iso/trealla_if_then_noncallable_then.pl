% Prolog result format 4
query(1, if_then_noncallable_then(_0), ['X0' = _0]).
result(1, complete, 1).
answer(1, ['X0' = type_error(callable, (true -> false, 1))]).
