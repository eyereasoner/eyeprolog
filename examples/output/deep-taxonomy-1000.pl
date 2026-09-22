% Prolog result format 4
query(1, holds_result(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = test, 'X1' = true]).
query(2, arc(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 6).
answer(2, ['X0' = check1, 'X1' = "C1 OK - the starting classification n0 is present."]).
answer(2,
       ['X0' = check2,
        'X1' = "C2 OK - the first expansion produced n1 together with side labels i1 and j1."]).
answer(2,
       ['X0' = check3,
        'X1' = "C3 OK - the chain reaches the midpoint n500 and still carries both side-label branches."]).
answer(2,
       ['X0' = check4,
        'X1' = "C4 OK - the final taxonomy step from n999 to n1000 was completed."]).
answer(2,
       ['X0' = check5,
        'X1' = "C5 OK - once n1000 is reached, the terminal class a2 is derived."]).
answer(2,
       ['X0' = check6,
        'X1' = "C6 OK - the success flag is raised only after the terminal class a2 is present."]).
query(3, answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3,
       ['X0' = report,
        'X1' = "The test succeeds: starting from one individual classified as n0, the rules eventually classify it as n1000 and then as a2."]).
query(4, reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4,
       ['X0' = report,
        'X1' = "The adjacent rules mirror the Eyeling N3 deep-taxonomy-1000 chain: each rule advances one taxonomy level and adds the matching side labels."]).
query(5, checkPassed(_0, _1), ['X0' = _0, 'X1' = _1]).
result(5, complete, 6).
answer(5, ['X0' = report, 'X1' = check1]).
answer(5, ['X0' = report, 'X1' = check2]).
answer(5, ['X0' = report, 'X1' = check3]).
answer(5, ['X0' = report, 'X1' = check4]).
answer(5, ['X0' = report, 'X1' = check5]).
answer(5, ['X0' = report, 'X1' = check6]).
query(6, result(_0, _1), ['X0' = _0, 'X1' = _1]).
result(6, complete, 1).
answer(6, ['X0' = report, 'X1' = success]).
