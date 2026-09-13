review_quorum(selection(alice(0), bob(0), carol(1), dan(1))).
why(
  review_quorum(selection(alice(0), bob(0), carol(1), dan(1))),
  no_proof
).

review_quorum(selection(alice(0), bob(1), carol(1), dan(0))).
why(
  review_quorum(selection(alice(0), bob(1), carol(1), dan(0))),
  no_proof
).

review_quorum_count(2).
why(
  review_quorum_count(2),
  no_proof
).

