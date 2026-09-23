review_quorum(selection(alice(0), bob(0), carol(1), dan(1))).
review_quorum(selection(alice(0), bob(1), carol(1), dan(0))).
review_quorum_count(2).

step(review_quorum(selection(alice(0), bob(0), carol(1), dan(1))), unproven, [], []).
step(review_quorum(selection(alice(0), bob(1), carol(1), dan(0))), unproven, [], []).
step(review_quorum_count(2), unproven, [], []).
