decodesAs(message(1), 1).
decodesAs(message(3), 3).
decodesAs(message(0), 0).
decodesAs(message(2), 2).
preservesMessage(protocol, true).
cancelsCrossTalk(protocol, true).

clause(1, r(false, false), true).
clause(2, r(true, true), true).
clause(3, identity(false, false), true).
clause(4, identity(true, true), true).
clause(5, g(false, true), true).
clause(8, k(true, false), true).
clause(10, kg(var('X'), var('Y')), (g(var('X'), var('Z')), k(var('Z'), var('Y')))).
clause(11, gk(var('X'), var('Y')), (k(var('X'), var('Z')), g(var('Z'), var('Y')))).
clause(12, alice(0, var('X'), var('Y')), identity(var('X'), var('Y'))).
clause(13, alice(1, var('X'), var('Y')), g(var('X'), var('Y'))).
clause(14, alice(2, var('X'), var('Y')), k(var('X'), var('Y'))).
clause(15, alice(3, var('X'), var('Y')), kg(var('X'), var('Y'))).
clause(16, bob(var('X'), var('Y'), 0), gk(var('X'), var('Y'))).
clause(17, bob(var('X'), var('Y'), 1), k(var('X'), var('Y'))).
clause(18, bob(var('X'), var('Y'), 2), g(var('X'), var('Y'))).
clause(19, bob(var('X'), var('Y'), 3), identity(var('X'), var('Y'))).
clause(20,
       sdc_path(var('N'), var('M'), path(var('X'), var('Y'), var('B'))),
       (r(var('X'), var('Y')),
        alice(var('N'), var('X'), var('B')),
        bob(var('B'), var('Y'), var('M')))).
clause(22,
       sdcoding(var('N'), var('M')),
       (sdc_path(var('N'), var('M'), var('Proof')),
        \+ duplicate_sdc_path(var('N'), var('M'), var('Proof')))).
clause(23, decodesAs(message(var('N')), var('M')), sdcoding(var('N'), var('M'))).
clause(24,
       preservesMessage(protocol, true),
       (sdcoding(0, 0), sdcoding(1, 1), sdcoding(2, 2), sdcoding(3, 3))).
clause(25,
       cancelsCrossTalk(protocol, true),
       (\+ sdcoding(0, 1), \+ sdcoding(1, 0), \+ sdcoding(2, 3), \+ sdcoding(3, 2))).

step(decodesAs(message(1), 1), rule(23), ['N' = 1, 'M' = 1], [sdcoding(1, 1)]).
step(sdcoding(1, 1),
     rule(22),
     ['N' = 1, 'M' = 1, 'Proof' = path(false, false, true)],
     [sdc_path(1, 1, path(false, false, true)),
      \+ duplicate_sdc_path(1, 1, path(false, false, true))]).
step(sdc_path(1, 1, path(false, false, true)),
     rule(20),
     ['N' = 1, 'M' = 1, 'X' = false, 'Y' = false, 'B' = true],
     [r(false, false), alice(1, false, true), bob(true, false, 1)]).
step(r(false, false), fact(1), [], []).
step(alice(1, false, true), rule(13), ['X' = false, 'Y' = true], [g(false, true)]).
step(g(false, true), fact(5), [], []).
step(bob(true, false, 1), rule(17), ['X' = true, 'Y' = false], [k(true, false)]).
step(k(true, false), fact(8), [], []).
step(\+ duplicate_sdc_path(1, 1, path(false, false, true)), absent, [], []).
step(decodesAs(message(3), 3), rule(23), ['N' = 3, 'M' = 3], [sdcoding(3, 3)]).
step(sdcoding(3, 3),
     rule(22),
     ['N' = 3, 'M' = 3, 'Proof' = path(false, false, false)],
     [sdc_path(3, 3, path(false, false, false)),
      \+ duplicate_sdc_path(3, 3, path(false, false, false))]).
step(sdc_path(3, 3, path(false, false, false)),
     rule(20),
     ['N' = 3, 'M' = 3, 'X' = false, 'Y' = false, 'B' = false],
     [r(false, false), alice(3, false, false), bob(false, false, 3)]).
step(alice(3, false, false), rule(15), ['X' = false, 'Y' = false], [kg(false, false)]).
step(kg(false, false),
     rule(10),
     ['X' = false, 'Y' = false, 'Z' = true],
     [g(false, true), k(true, false)]).
step(bob(false, false, 3), rule(19), ['X' = false, 'Y' = false], [identity(false, false)]).
step(identity(false, false), fact(3), [], []).
step(\+ duplicate_sdc_path(3, 3, path(false, false, false)), absent, [], []).
step(decodesAs(message(0), 0), rule(23), ['N' = 0, 'M' = 0], [sdcoding(0, 0)]).
step(sdcoding(0, 0),
     rule(22),
     ['N' = 0, 'M' = 0, 'Proof' = path(true, true, true)],
     [sdc_path(0, 0, path(true, true, true)),
      \+ duplicate_sdc_path(0, 0, path(true, true, true))]).
step(sdc_path(0, 0, path(true, true, true)),
     rule(20),
     ['N' = 0, 'M' = 0, 'X' = true, 'Y' = true, 'B' = true],
     [r(true, true), alice(0, true, true), bob(true, true, 0)]).
step(r(true, true), fact(2), [], []).
step(alice(0, true, true), rule(12), ['X' = true, 'Y' = true], [identity(true, true)]).
step(identity(true, true), fact(4), [], []).
step(bob(true, true, 0), rule(16), ['X' = true, 'Y' = true], [gk(true, true)]).
step(gk(true, true),
     rule(11),
     ['X' = true, 'Y' = true, 'Z' = false],
     [k(true, false), g(false, true)]).
step(\+ duplicate_sdc_path(0, 0, path(true, true, true)), absent, [], []).
step(decodesAs(message(2), 2), rule(23), ['N' = 2, 'M' = 2], [sdcoding(2, 2)]).
step(sdcoding(2, 2),
     rule(22),
     ['N' = 2, 'M' = 2, 'Proof' = path(true, true, false)],
     [sdc_path(2, 2, path(true, true, false)),
      \+ duplicate_sdc_path(2, 2, path(true, true, false))]).
step(sdc_path(2, 2, path(true, true, false)),
     rule(20),
     ['N' = 2, 'M' = 2, 'X' = true, 'Y' = true, 'B' = false],
     [r(true, true), alice(2, true, false), bob(false, true, 2)]).
step(alice(2, true, false), rule(14), ['X' = true, 'Y' = false], [k(true, false)]).
step(bob(false, true, 2), rule(18), ['X' = false, 'Y' = true], [g(false, true)]).
step(\+ duplicate_sdc_path(2, 2, path(true, true, false)), absent, [], []).
step(preservesMessage(protocol, true),
     rule(24),
     [],
     [sdcoding(0, 0), sdcoding(1, 1), sdcoding(2, 2), sdcoding(3, 3)]).
step(cancelsCrossTalk(protocol, true),
     rule(25),
     [],
     [\+ sdcoding(0, 1), \+ sdcoding(1, 0), \+ sdcoding(2, 3), \+ sdcoding(3, 2)]).
step(\+ sdcoding(0, 1), absent, [], []).
step(\+ sdcoding(1, 0), absent, [], []).
step(\+ sdcoding(2, 3), absent, [], []).
step(\+ sdcoding(3, 2), absent, [], []).
