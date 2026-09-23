dcg_expression_example(parsed, add(lit(2), mul(lit(3), sub(lit(4), lit(1))))).
dcg_expression_example(evaluated, 19).
dcg_expression_example(round_trip, [20, -, '(', 5, -, 3, ')']).
dcg_expression_example(remainder, [then, stop]).
dcg_expression_example(rejected, malformed_parentheses).
