% Prolog result format 4
query(1, review_quorum(_0), ['X0' = _0]).
result(1, complete, 2).
answer(1, ['X0' = selection(alice(0), bob(0), carol(1), dan(1))]).
why(1,
    ['X0' = selection(alice(0), bob(0), carol(1), dan(1))],
    [review_quorum(selection(alice(0), bob(0), carol(1), dan(1)))]).
answer(1, ['X0' = selection(alice(0), bob(1), carol(1), dan(0))]).
why(1,
    ['X0' = selection(alice(0), bob(1), carol(1), dan(0))],
    [review_quorum(selection(alice(0), bob(1), carol(1), dan(0)))]).
query(2, review_quorum_count(_0), ['X0' = _0]).
result(2, complete, 1).
answer(2, ['X0' = 2]).
why(2, ['X0' = 2], [review_quorum_count(2)]).

step(review_quorum(selection(alice(0), bob(0), carol(1), dan(1))), unproven, [], []).
step(review_quorum(selection(alice(0), bob(1), carol(1), dan(0))), unproven, [], []).
step(review_quorum_count(2), unproven, [], []).
