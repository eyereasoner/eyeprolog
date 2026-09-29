holds_result(test, true).
arc(check1, "C1 OK - the starting classification n0 is present.").
arc(check2, "C2 OK - the first expansion produced n1 together with side labels i1 and j1.").
arc(check3, "C3 OK - the chain reaches the midpoint n50000 and still carries both side-label branches.").
arc(check4, "C4 OK - the final taxonomy step from n99999 to n100000 was completed.").
arc(check5, "C5 OK - once n100000 is reached, the terminal class a2 is derived.").
arc(check6, "C6 OK - the success flag is raised only after the terminal class a2 is present.").
answer(report, "The test succeeds: starting from one individual classified as n0, the rules eventually classify it as n100000 and then as a2.").
reason(report, "The adjacent rules mirror the Eyeling N3 deep-taxonomy-100000 chain: each rule advances one taxonomy level and adds the matching side labels.").
checkPassed(report, check1).
checkPassed(report, check2).
checkPassed(report, check3).
checkPassed(report, check4).
checkPassed(report, check5).
checkPassed(report, check6).
result(report, success).

clause(1, a(ind, n0), true).
clause(2, holds_result(test, true), once(a(ind, a2))).
clause(4, a(var('X'), n1), a(var('X'), n0)).
clause(5, a(var('X'), i1), a(var('X'), n0)).
clause(6, a(var('X'), j1), a(var('X'), n0)).
clause(300004,
       arc(check1, "C1 OK - the starting classification n0 is present."),
       once(a(ind, n0))).
clause(300005,
       arc(check2, "C2 OK - the first expansion produced n1 together with side labels i1 and j1."),
       (once(a(ind, n1)), once(a(ind, i1)), once(a(ind, j1)))).
clause(300006,
       arc(check3, "C3 OK - the chain reaches the midpoint n50000 and still carries both side-label branches."),
       (once(a(ind, n50000)), once(a(ind, i50000)), once(a(ind, j50000)))).
clause(300007,
       arc(check4, "C4 OK - the final taxonomy step from n99999 to n100000 was completed."),
       (once(a(ind, n99999)), once(a(ind, n100000)))).
clause(300008,
       arc(check5, "C5 OK - once n100000 is reached, the terminal class a2 is derived."),
       (once(a(ind, n100000)), once(a(ind, a2)))).
clause(300009,
       arc(check6, "C6 OK - the success flag is raised only after the terminal class a2 is present."),
       (once(a(ind, a2)), once(holds_result(test, true)))).
clause(300010,
       answer(report, "The test succeeds: starting from one individual classified as n0, the rules eventually classify it as n100000 and then as a2."),
       once(holds_result(test, true))).
clause(300011,
       reason(report, "The adjacent rules mirror the Eyeling N3 deep-taxonomy-100000 chain: each rule advances one taxonomy level and adds the matching side labels."),
       (once(a(ind, a2)), once(holds_result(test, true)))).
clause(300012, checkPassed(report, var('Check')), arc(var('Check'), anonymous(1))).
clause(300013,
       result(report, success),
       (once(holds_result(test, true)),
        once(arc(check1, anonymous(1))),
        once(arc(check2, anonymous(2))),
        once(arc(check3, anonymous(3))),
        once(arc(check4, anonymous(4))),
        once(arc(check5, anonymous(5))),
        once(arc(check6, anonymous(6))))).

step(holds_result(test, true), rule(2), [], [once(a(ind, a2))]).
step(once(a(ind, a2)), builtin, [], []).
step(arc(check1, "C1 OK - the starting classification n0 is present."),
     rule(300004),
     [],
     [once(a(ind, n0))]).
step(once(a(ind, n0)), builtin, [], [a(ind, n0)]).
step(a(ind, n0), fact(1), [], []).
step(arc(check2, "C2 OK - the first expansion produced n1 together with side labels i1 and j1."),
     rule(300005),
     [],
     [once(a(ind, n1)), once(a(ind, i1)), once(a(ind, j1))]).
step(once(a(ind, n1)), builtin, [], [a(ind, n1)]).
step(a(ind, n1), rule(4), ['X' = ind], [a(ind, n0)]).
step(once(a(ind, i1)), builtin, [], [a(ind, i1)]).
step(a(ind, i1), rule(5), ['X' = ind], [a(ind, n0)]).
step(once(a(ind, j1)), builtin, [], [a(ind, j1)]).
step(a(ind, j1), rule(6), ['X' = ind], [a(ind, n0)]).
step(arc(check3, "C3 OK - the chain reaches the midpoint n50000 and still carries both side-label branches."),
     rule(300006),
     [],
     [once(a(ind, n50000)), once(a(ind, i50000)), once(a(ind, j50000))]).
step(once(a(ind, n50000)), builtin, [], []).
step(once(a(ind, i50000)), builtin, [], []).
step(once(a(ind, j50000)), builtin, [], []).
step(arc(check4, "C4 OK - the final taxonomy step from n99999 to n100000 was completed."),
     rule(300007),
     [],
     [once(a(ind, n99999)), once(a(ind, n100000))]).
step(once(a(ind, n99999)), builtin, [], []).
step(once(a(ind, n100000)), builtin, [], []).
step(arc(check5, "C5 OK - once n100000 is reached, the terminal class a2 is derived."),
     rule(300008),
     [],
     [once(a(ind, n100000)), once(a(ind, a2))]).
step(arc(check6, "C6 OK - the success flag is raised only after the terminal class a2 is present."),
     rule(300009),
     [],
     [once(a(ind, a2)), once(holds_result(test, true))]).
step(once(holds_result(test, true)), builtin, [], [holds_result(test, true)]).
step(answer(report, "The test succeeds: starting from one individual classified as n0, the rules eventually classify it as n100000 and then as a2."),
     rule(300010),
     [],
     [once(holds_result(test, true))]).
step(reason(report, "The adjacent rules mirror the Eyeling N3 deep-taxonomy-100000 chain: each rule advances one taxonomy level and adds the matching side labels."),
     rule(300011),
     [],
     [once(a(ind, a2)), once(holds_result(test, true))]).
step(checkPassed(report, check1),
     rule(300012),
     ['Check' = check1],
     [arc(check1, "C1 OK - the starting classification n0 is present.")]).
step(checkPassed(report, check2),
     rule(300012),
     ['Check' = check2],
     [arc(check2, "C2 OK - the first expansion produced n1 together with side labels i1 and j1.")]).
step(checkPassed(report, check3),
     rule(300012),
     ['Check' = check3],
     [arc(check3, "C3 OK - the chain reaches the midpoint n50000 and still carries both side-label branches.")]).
step(checkPassed(report, check4),
     rule(300012),
     ['Check' = check4],
     [arc(check4, "C4 OK - the final taxonomy step from n99999 to n100000 was completed.")]).
step(checkPassed(report, check5),
     rule(300012),
     ['Check' = check5],
     [arc(check5, "C5 OK - once n100000 is reached, the terminal class a2 is derived.")]).
step(checkPassed(report, check6),
     rule(300012),
     ['Check' = check6],
     [arc(check6, "C6 OK - the success flag is raised only after the terminal class a2 is present.")]).
step(result(report, success),
     rule(300013),
     [],
     [once(holds_result(test, true)),
      once(arc(check1, "C1 OK - the starting classification n0 is present.")),
      once(arc(check2, "C2 OK - the first expansion produced n1 together with side labels i1 and j1.")),
      once(arc(check3, "C3 OK - the chain reaches the midpoint n50000 and still carries both side-label branches.")),
      once(arc(check4, "C4 OK - the final taxonomy step from n99999 to n100000 was completed.")),
      once(arc(check5, "C5 OK - once n100000 is reached, the terminal class a2 is derived.")),
      once(arc(check6, "C6 OK - the success flag is raised only after the terminal class a2 is present."))]).
step(once(arc(check1, "C1 OK - the starting classification n0 is present.")),
     builtin,
     [],
     [arc(check1, "C1 OK - the starting classification n0 is present.")]).
step(once(arc(check2, "C2 OK - the first expansion produced n1 together with side labels i1 and j1.")),
     builtin,
     [],
     [arc(check2, "C2 OK - the first expansion produced n1 together with side labels i1 and j1.")]).
step(once(arc(check3, "C3 OK - the chain reaches the midpoint n50000 and still carries both side-label branches.")),
     builtin,
     [],
     [arc(check3, "C3 OK - the chain reaches the midpoint n50000 and still carries both side-label branches.")]).
step(once(arc(check4, "C4 OK - the final taxonomy step from n99999 to n100000 was completed.")),
     builtin,
     [],
     [arc(check4, "C4 OK - the final taxonomy step from n99999 to n100000 was completed.")]).
step(once(arc(check5, "C5 OK - once n100000 is reached, the terminal class a2 is derived.")),
     builtin,
     [],
     [arc(check5, "C5 OK - once n100000 is reached, the terminal class a2 is derived.")]).
step(once(arc(check6, "C6 OK - the success flag is raised only after the terminal class a2 is present.")),
     builtin,
     [],
     [arc(check6, "C6 OK - the success flag is raised only after the terminal class a2 is present.")]).
