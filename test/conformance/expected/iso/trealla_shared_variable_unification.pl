% Prolog result format 4
query(1, fact_unifies_leaving_variable_unbound(ok), []).
result(1, complete, 1).
answer(1, []).
query(2, distinct_arguments_reject(ok), []).
result(2, complete, 1).
answer(2, []).
query(3, repeated_argument_accepts(ok), []).
result(3, complete, 1).
answer(3, []).
query(4, distinct_fact_arguments_reject(ok), []).
result(4, complete, 1).
answer(4, []).
query(5, fact_second_argument(_0), ['X0' = _0]).
result(5, complete, 1).
answer(5, ['X0' = [nice]]).
query(6, nested_pattern_rejects_conflict(ok), []).
result(6, complete, 1).
answer(6, []).
query(7, nested_pattern_accepts(ok), []).
result(7, complete, 1).
answer(7, []).
query(8, nested_shared_variable_binds_consistently(_0), ['X0' = _0]).
result(8, complete, 1).
answer(8, ['X0' = "w"]).
query(9, nested_shared_variable_all_positions(_0), ['X0' = _0]).
result(9, complete, 1).
answer(9, ['X0' = "w"]).
query(10, retract_reassert_roundtrip(ok), []).
result(10, complete, 1).
answer(10, []).
