% Prolog result format 4
query(1, status(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 4).
answer(1, ['X0' = bob, 'X1' = compliant]).
why(1, ['X0' = bob, 'X1' = compliant], [status(bob, compliant)]).
answer(1, ['X0' = alice, 'X1' = compliant]).
why(1, ['X0' = alice, 'X1' = compliant], [status(alice, compliant)]).
answer(1, ['X0' = dave, 'X1' = non_compliant]).
why(1, ['X0' = dave, 'X1' = non_compliant], [status(dave, non_compliant)]).
answer(1, ['X0' = carol, 'X1' = non_compliant]).
why(1, ['X0' = carol, 'X1' = non_compliant], [status(carol, non_compliant)]).

clause(1, employee(alice), true).
clause(2, employee(bob), true).
clause(3, employee(carol), true).
clause(4, employee(dave), true).
clause(5, does(alice, log_off_at_end_of_shift), true).
clause(6, does(bob, work_related_task), true).
clause(7, does(bob, log_off_at_end_of_shift), true).
clause(8, does(carol, access_social_media), true).
clause(9, does(dave, work_related_task), true).
clause(10,
       status(var('Person'), compliant),
       (employee(var('Person')),
        does(var('Person'), work_related_task),
        does(var('Person'), log_off_at_end_of_shift))).
clause(11,
       status(var('Person'), compliant),
       (employee(var('Person')),
        does(var('Person'), log_off_at_end_of_shift),
        \+ does(var('Person'), work_related_task))).
clause(12,
       status(var('Person'), non_compliant),
       (employee(var('Person')),
        does(var('Person'), work_related_task),
        \+ does(var('Person'), log_off_at_end_of_shift))).
clause(13,
       status(var('Person'), non_compliant),
       (employee(var('Person')), does(var('Person'), access_social_media))).

step(status(bob, compliant),
     rule(10),
     ['Person' = bob],
     [employee(bob), does(bob, work_related_task), does(bob, log_off_at_end_of_shift)]).
step(employee(bob), fact(2), [], []).
step(does(bob, work_related_task), fact(6), [], []).
step(does(bob, log_off_at_end_of_shift), fact(7), [], []).
step(status(alice, compliant),
     rule(11),
     ['Person' = alice],
     [employee(alice), does(alice, log_off_at_end_of_shift), \+ does(alice, work_related_task)]).
step(employee(alice), fact(1), [], []).
step(does(alice, log_off_at_end_of_shift), fact(5), [], []).
step(\+ does(alice, work_related_task), absent, [], []).
step(status(dave, non_compliant),
     rule(12),
     ['Person' = dave],
     [employee(dave), does(dave, work_related_task), \+ does(dave, log_off_at_end_of_shift)]).
step(employee(dave), fact(4), [], []).
step(does(dave, work_related_task), fact(9), [], []).
step(\+ does(dave, log_off_at_end_of_shift), absent, [], []).
step(status(carol, non_compliant),
     rule(13),
     ['Person' = carol],
     [employee(carol), does(carol, access_social_media)]).
step(employee(carol), fact(3), [], []).
step(does(carol, access_social_media), fact(8), [], []).
