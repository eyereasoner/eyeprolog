% Prolog result format 4
query(1, text_body(_0), ['X0' = _0]).
result(1, complete, 1).
answer(1, ['X0' = call(true)]).
query(2, nested_body(_0), ['X0' = _0]).
result(2, complete, 1).
answer(2, ['X0' = ((call(a) ; call(b)), (call(c) -> true ; true))]).
query(3, assert_agrees_with_text(_0), ['X0' = _0]).
result(3, complete, 1).
answer(3, ['X0' = agree]).
query(4, cut_is_local(_0), ['X0' = _0]).
result(4, complete, 1).
answer(4, ['X0' = [taken, taken]]).
