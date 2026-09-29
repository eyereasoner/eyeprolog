absState(input, x, sign(neg)).
absState(input, x, sign(zero)).
absState(input, x, sign(pos)).
absState(negative_branch, x, sign(neg)).
absState(nonnegative_branch, x, sign(zero)).
absState(nonnegative_branch, x, sign(pos)).
absState(negative_branch, y, sign(pos)).
absState(nonnegative_branch, y, sign(zero)).
absState(nonnegative_branch, y, sign(pos)).
absState(join, x, sign(neg)).
absState(join, y, sign(pos)).
absState(join, x, sign(zero)).
absState(join, x, sign(pos)).
absState(join, y, sign(zero)).
absWarning(division_by_zero, join).
absConclusion(case, "abstract interpretation keeps all feasible signs and warns because y may be zero").

clause(1, input_sign(neg), true).
clause(2, input_sign(zero), true).
clause(3, input_sign(pos), true).
clause(4, abs_state(input, x, var('Sign')), input_sign(var('Sign'))).
clause(5, abs_state(negative_branch, x, neg), abs_state(input, x, neg)).
clause(6, abs_state(nonnegative_branch, x, zero), abs_state(input, x, zero)).
clause(7, abs_state(nonnegative_branch, x, pos), abs_state(input, x, pos)).
clause(8, abs_state(negative_branch, y, pos), abs_state(negative_branch, x, neg)).
clause(9,
       abs_state(nonnegative_branch, y, var('Sign')),
       abs_state(nonnegative_branch, x, var('Sign'))).
clause(10,
       abs_state(join, var('Var'), var('Sign')),
       abs_state(negative_branch, var('Var'), var('Sign'))).
clause(11,
       abs_state(join, var('Var'), var('Sign')),
       abs_state(nonnegative_branch, var('Var'), var('Sign'))).
clause(12, possible_division_by_zero(join), abs_state(join, y, zero)).
clause(13,
       absState(var('Point'), var('Var'), sign(var('Sign'))),
       abs_state(var('Point'), var('Var'), var('Sign'))).
clause(14, absWarning(division_by_zero, var('Point')), possible_division_by_zero(var('Point'))).
clause(15,
       absConclusion(case, "abstract interpretation keeps all feasible signs and warns because y may be zero"),
       possible_division_by_zero(join)).

step(absState(input, x, sign(neg)),
     rule(13),
     ['Point' = input, 'Var' = x, 'Sign' = neg],
     [abs_state(input, x, neg)]).
step(abs_state(input, x, neg), rule(4), ['Sign' = neg], [input_sign(neg)]).
step(input_sign(neg), fact(1), [], []).
step(absState(input, x, sign(zero)),
     rule(13),
     ['Point' = input, 'Var' = x, 'Sign' = zero],
     [abs_state(input, x, zero)]).
step(abs_state(input, x, zero), rule(4), ['Sign' = zero], [input_sign(zero)]).
step(input_sign(zero), fact(2), [], []).
step(absState(input, x, sign(pos)),
     rule(13),
     ['Point' = input, 'Var' = x, 'Sign' = pos],
     [abs_state(input, x, pos)]).
step(abs_state(input, x, pos), rule(4), ['Sign' = pos], [input_sign(pos)]).
step(input_sign(pos), fact(3), [], []).
step(absState(negative_branch, x, sign(neg)),
     rule(13),
     ['Point' = negative_branch, 'Var' = x, 'Sign' = neg],
     [abs_state(negative_branch, x, neg)]).
step(abs_state(negative_branch, x, neg), rule(5), [], [abs_state(input, x, neg)]).
step(absState(nonnegative_branch, x, sign(zero)),
     rule(13),
     ['Point' = nonnegative_branch, 'Var' = x, 'Sign' = zero],
     [abs_state(nonnegative_branch, x, zero)]).
step(abs_state(nonnegative_branch, x, zero), rule(6), [], [abs_state(input, x, zero)]).
step(absState(nonnegative_branch, x, sign(pos)),
     rule(13),
     ['Point' = nonnegative_branch, 'Var' = x, 'Sign' = pos],
     [abs_state(nonnegative_branch, x, pos)]).
step(abs_state(nonnegative_branch, x, pos), rule(7), [], [abs_state(input, x, pos)]).
step(absState(negative_branch, y, sign(pos)),
     rule(13),
     ['Point' = negative_branch, 'Var' = y, 'Sign' = pos],
     [abs_state(negative_branch, y, pos)]).
step(abs_state(negative_branch, y, pos), rule(8), [], [abs_state(negative_branch, x, neg)]).
step(absState(nonnegative_branch, y, sign(zero)),
     rule(13),
     ['Point' = nonnegative_branch, 'Var' = y, 'Sign' = zero],
     [abs_state(nonnegative_branch, y, zero)]).
step(abs_state(nonnegative_branch, y, zero),
     rule(9),
     ['Sign' = zero],
     [abs_state(nonnegative_branch, x, zero)]).
step(absState(nonnegative_branch, y, sign(pos)),
     rule(13),
     ['Point' = nonnegative_branch, 'Var' = y, 'Sign' = pos],
     [abs_state(nonnegative_branch, y, pos)]).
step(abs_state(nonnegative_branch, y, pos),
     rule(9),
     ['Sign' = pos],
     [abs_state(nonnegative_branch, x, pos)]).
step(absState(join, x, sign(neg)),
     rule(13),
     ['Point' = join, 'Var' = x, 'Sign' = neg],
     [abs_state(join, x, neg)]).
step(abs_state(join, x, neg),
     rule(10),
     ['Var' = x, 'Sign' = neg],
     [abs_state(negative_branch, x, neg)]).
step(absState(join, y, sign(pos)),
     rule(13),
     ['Point' = join, 'Var' = y, 'Sign' = pos],
     [abs_state(join, y, pos)]).
step(abs_state(join, y, pos),
     rule(10),
     ['Var' = y, 'Sign' = pos],
     [abs_state(negative_branch, y, pos)]).
step(absState(join, x, sign(zero)),
     rule(13),
     ['Point' = join, 'Var' = x, 'Sign' = zero],
     [abs_state(join, x, zero)]).
step(abs_state(join, x, zero),
     rule(11),
     ['Var' = x, 'Sign' = zero],
     [abs_state(nonnegative_branch, x, zero)]).
step(absState(join, x, sign(pos)),
     rule(13),
     ['Point' = join, 'Var' = x, 'Sign' = pos],
     [abs_state(join, x, pos)]).
step(abs_state(join, x, pos),
     rule(11),
     ['Var' = x, 'Sign' = pos],
     [abs_state(nonnegative_branch, x, pos)]).
step(absState(join, y, sign(zero)),
     rule(13),
     ['Point' = join, 'Var' = y, 'Sign' = zero],
     [abs_state(join, y, zero)]).
step(abs_state(join, y, zero),
     rule(11),
     ['Var' = y, 'Sign' = zero],
     [abs_state(nonnegative_branch, y, zero)]).
step(absWarning(division_by_zero, join),
     rule(14),
     ['Point' = join],
     [possible_division_by_zero(join)]).
step(possible_division_by_zero(join), rule(12), [], [abs_state(join, y, zero)]).
step(absConclusion(case, "abstract interpretation keeps all feasible signs and warns because y may be zero"),
     rule(15),
     [],
     [possible_division_by_zero(join)]).
