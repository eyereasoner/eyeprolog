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
