input(case1, [1, 0, 1, 0, 0, 1]).
input(case2, [1, 0, 1, 1, 1, 1]).
input(case3, [1, 1, 1, 1, 1, 1]).
input(case4, []).
output(case1, [1, 0, 1, 0, 1, 0, #]).
output(case2, [1, 1, 0, 0, 0, 0, #]).
output(case3, [1, 0, 0, 0, 0, 0, 0, #]).
output(case4, [1, #]).
addsOne(case1, true).
addsOne(case2, true).
addsOne(case3, true).
addsOne(case4, true).
