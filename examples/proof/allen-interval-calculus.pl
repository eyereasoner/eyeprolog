start(a, 10).
start(b, 13).
start(c, 12).
start(d, 11).
start(e, 10).
start(f, 10).
start(g, 11).
start(h, 9).
start(i, 16).
start(j, 15).
start(k, 13).
end(a, 12).
end(b, 15).
end(c, 14).
end(d, 13).
end(e, 12).
end(f, 11).
end(g, 12).
end(h, 16).
end(i, 18).
end(j, 16).
end(k, 14).
duration(a, 2).
duration(b, 2).
duration(c, 2).
duration(d, 2).
duration(e, 2).
duration(f, 1).
duration(g, 1).
duration(h, 7).
duration(i, 2).
duration(j, 1).
duration(k, 1).
statement(a, before, b).
statement(a, before, i).
statement(a, before, j).
statement(a, before, k).
statement(b, before, i).
statement(c, before, i).
statement(c, before, j).
statement(d, before, i).
statement(d, before, j).
statement(e, before, b).
statement(e, before, i).
statement(e, before, j).
statement(e, before, k).
statement(f, before, b).
statement(f, before, c).
statement(f, before, i).
statement(f, before, j).
statement(f, before, k).
statement(g, before, b).
statement(g, before, i).
statement(g, before, j).
statement(g, before, k).
statement(k, before, i).
statement(k, before, j).
statement(a, meets, c).
statement(b, meets, j).
statement(d, meets, b).
statement(d, meets, k).
statement(e, meets, c).
statement(f, meets, d).
statement(f, meets, g).
statement(g, meets, c).
statement(h, meets, i).
statement(j, meets, i).
statement(a, overlaps, d).
statement(c, overlaps, b).
statement(d, overlaps, c).
statement(e, overlaps, d).
statement(f, starts, a).
statement(f, starts, e).
statement(g, starts, d).
statement(k, starts, b).
statement(a, during, h).
statement(b, during, h).
statement(c, during, h).
statement(d, during, h).
statement(e, during, h).
statement(f, during, h).
statement(g, during, h).
statement(k, during, h).
statement(g, finishes, a).
statement(g, finishes, e).
statement(j, finishes, h).
statement(k, finishes, c).
statement(a, equals, a).
statement(a, equals, e).
statement(b, equals, b).
statement(c, equals, c).
statement(d, equals, d).
statement(e, equals, a).
statement(e, equals, e).
statement(f, equals, f).
statement(g, equals, g).
statement(h, equals, h).
statement(i, equals, i).
statement(j, equals, j).
statement(k, equals, k).
statement(b, after, a).
statement(i, after, a).
statement(j, after, a).
statement(k, after, a).
statement(i, after, b).
statement(i, after, c).
statement(j, after, c).
statement(i, after, d).
statement(j, after, d).
statement(b, after, e).
statement(i, after, e).
statement(j, after, e).
statement(k, after, e).
statement(b, after, f).
statement(c, after, f).
statement(i, after, f).
statement(j, after, f).
statement(k, after, f).
statement(b, after, g).
statement(i, after, g).
statement(j, after, g).
statement(k, after, g).
statement(i, after, k).
statement(j, after, k).
statement(c, metBy, a).
statement(j, metBy, b).
statement(b, metBy, d).
statement(k, metBy, d).
statement(c, metBy, e).
statement(d, metBy, f).
statement(g, metBy, f).
statement(c, metBy, g).
statement(i, metBy, h).
statement(i, metBy, j).
statement(d, overlappedBy, a).
statement(b, overlappedBy, c).
statement(c, overlappedBy, d).
statement(d, overlappedBy, e).
statement(a, startedBy, f).
statement(e, startedBy, f).
statement(d, startedBy, g).
statement(b, startedBy, k).
statement(h, contains, a).
statement(h, contains, b).
statement(h, contains, c).
statement(h, contains, d).
statement(h, contains, e).
statement(h, contains, f).
statement(h, contains, g).
statement(h, contains, k).
statement(a, finishedBy, g).
statement(e, finishedBy, g).
statement(h, finishedBy, j).
statement(c, finishedBy, k).

clause(1,
       interval_table([interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]),
       true).
clause(3,
       start(var('I'), var('Start')),
       (interval_table(var('Table')),
        member(interval(var('I'), var('Start'), anonymous(1)), var('Table')))).
clause(4,
       end(var('I'), var('End')),
       (interval_table(var('Table')),
        member(interval(var('I'), anonymous(1), var('End')), var('Table')))).
clause(5,
       relation(var('I'), before, var('J')),
       (end(var('I'), var('Ei')), start(var('J'), var('Sj')), var('Ei') < var('Sj'))).
clause(6,
       relation(var('I'), meets, var('J')),
       (end(var('I'), var('E')), start(var('J'), var('E')))).
clause(7,
       relation(var('I'), overlaps, var('J')),
       (start(var('I'), var('Si')),
        end(var('I'), var('Ei')),
        start(var('J'), var('Sj')),
        end(var('J'), var('Ej')),
        var('Si') < var('Sj'),
        var('Sj') < var('Ei'),
        var('Ei') < var('Ej'))).
clause(8,
       relation(var('I'), starts, var('J')),
       (start(var('I'), var('S')),
        start(var('J'), var('S')),
        end(var('I'), var('Ei')),
        end(var('J'), var('Ej')),
        var('Ei') < var('Ej'))).
clause(9,
       relation(var('I'), during, var('J')),
       (start(var('I'), var('Si')),
        end(var('I'), var('Ei')),
        start(var('J'), var('Sj')),
        end(var('J'), var('Ej')),
        var('Sj') < var('Si'),
        var('Ei') < var('Ej'))).
clause(10,
       relation(var('I'), finishes, var('J')),
       (end(var('I'), var('E')),
        end(var('J'), var('E')),
        start(var('I'), var('Si')),
        start(var('J'), var('Sj')),
        var('Sj') < var('Si'))).
clause(11,
       relation(var('I'), equals, var('J')),
       (start(var('I'), var('S')),
        start(var('J'), var('S')),
        end(var('I'), var('E')),
        end(var('J'), var('E')))).
clause(12, relation(var('J'), after, var('I')), relation(var('I'), before, var('J'))).
clause(13, relation(var('J'), metBy, var('I')), relation(var('I'), meets, var('J'))).
clause(14, relation(var('J'), overlappedBy, var('I')), relation(var('I'), overlaps, var('J'))).
clause(15, relation(var('J'), startedBy, var('I')), relation(var('I'), starts, var('J'))).
clause(16, relation(var('J'), contains, var('I')), relation(var('I'), during, var('J'))).
clause(17, relation(var('J'), finishedBy, var('I')), relation(var('I'), finishes, var('J'))).
clause(18,
       duration(var('I'), var('D')),
       (end(var('I'), var('E')), start(var('I'), var('S')), var('D') is var('E') - var('S'))).
clause(19, statement(var('I'), var('Rel'), var('J')), relation(var('I'), var('Rel'), var('J'))).

step(start(a, 10),
     rule(3),
     ['I' = a,
      'Start' = 10,
      'Table' = [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]],
     [interval_table([interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]),
      member(interval(a, 10, 12), [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)])]).
step(interval_table([interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]),
     fact(1),
     [],
     []).
step(member(interval(a, 10, 12), [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]),
     builtin,
     [],
     []).
step(start(b, 13),
     rule(3),
     ['I' = b,
      'Start' = 13,
      'Table' = [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]],
     [interval_table([interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]),
      member(interval(b, 13, 15), [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)])]).
step(member(interval(b, 13, 15), [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]),
     builtin,
     [],
     []).
step(start(c, 12),
     rule(3),
     ['I' = c,
      'Start' = 12,
      'Table' = [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]],
     [interval_table([interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]),
      member(interval(c, 12, 14), [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)])]).
step(member(interval(c, 12, 14), [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]),
     builtin,
     [],
     []).
step(start(d, 11),
     rule(3),
     ['I' = d,
      'Start' = 11,
      'Table' = [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]],
     [interval_table([interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]),
      member(interval(d, 11, 13), [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)])]).
step(member(interval(d, 11, 13), [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]),
     builtin,
     [],
     []).
step(start(e, 10),
     rule(3),
     ['I' = e,
      'Start' = 10,
      'Table' = [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]],
     [interval_table([interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]),
      member(interval(e, 10, 12), [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)])]).
step(member(interval(e, 10, 12), [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]),
     builtin,
     [],
     []).
step(start(f, 10),
     rule(3),
     ['I' = f,
      'Start' = 10,
      'Table' = [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]],
     [interval_table([interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]),
      member(interval(f, 10, 11), [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)])]).
step(member(interval(f, 10, 11), [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]),
     builtin,
     [],
     []).
step(start(g, 11),
     rule(3),
     ['I' = g,
      'Start' = 11,
      'Table' = [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]],
     [interval_table([interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]),
      member(interval(g, 11, 12), [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)])]).
step(member(interval(g, 11, 12), [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]),
     builtin,
     [],
     []).
step(start(h, 9),
     rule(3),
     ['I' = h,
      'Start' = 9,
      'Table' = [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]],
     [interval_table([interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]),
      member(interval(h, 9, 16), [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)])]).
step(member(interval(h, 9, 16), [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]),
     builtin,
     [],
     []).
step(start(i, 16),
     rule(3),
     ['I' = i,
      'Start' = 16,
      'Table' = [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]],
     [interval_table([interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]),
      member(interval(i, 16, 18), [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)])]).
step(member(interval(i, 16, 18), [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]),
     builtin,
     [],
     []).
step(start(j, 15),
     rule(3),
     ['I' = j,
      'Start' = 15,
      'Table' = [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]],
     [interval_table([interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]),
      member(interval(j, 15, 16), [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)])]).
step(member(interval(j, 15, 16), [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]),
     builtin,
     [],
     []).
step(start(k, 13),
     rule(3),
     ['I' = k,
      'Start' = 13,
      'Table' = [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]],
     [interval_table([interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]),
      member(interval(k, 13, 14), [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)])]).
step(member(interval(k, 13, 14), [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]),
     builtin,
     [],
     []).
step(end(a, 12),
     rule(4),
     ['I' = a,
      'End' = 12,
      'Table' = [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]],
     [interval_table([interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]),
      member(interval(a, 10, 12), [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)])]).
step(end(b, 15),
     rule(4),
     ['I' = b,
      'End' = 15,
      'Table' = [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]],
     [interval_table([interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]),
      member(interval(b, 13, 15), [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)])]).
step(end(c, 14),
     rule(4),
     ['I' = c,
      'End' = 14,
      'Table' = [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]],
     [interval_table([interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]),
      member(interval(c, 12, 14), [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)])]).
step(end(d, 13),
     rule(4),
     ['I' = d,
      'End' = 13,
      'Table' = [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]],
     [interval_table([interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]),
      member(interval(d, 11, 13), [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)])]).
step(end(e, 12),
     rule(4),
     ['I' = e,
      'End' = 12,
      'Table' = [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]],
     [interval_table([interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]),
      member(interval(e, 10, 12), [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)])]).
step(end(f, 11),
     rule(4),
     ['I' = f,
      'End' = 11,
      'Table' = [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]],
     [interval_table([interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]),
      member(interval(f, 10, 11), [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)])]).
step(end(g, 12),
     rule(4),
     ['I' = g,
      'End' = 12,
      'Table' = [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]],
     [interval_table([interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]),
      member(interval(g, 11, 12), [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)])]).
step(end(h, 16),
     rule(4),
     ['I' = h,
      'End' = 16,
      'Table' = [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]],
     [interval_table([interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]),
      member(interval(h, 9, 16), [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)])]).
step(end(i, 18),
     rule(4),
     ['I' = i,
      'End' = 18,
      'Table' = [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]],
     [interval_table([interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]),
      member(interval(i, 16, 18), [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)])]).
step(end(j, 16),
     rule(4),
     ['I' = j,
      'End' = 16,
      'Table' = [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]],
     [interval_table([interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]),
      member(interval(j, 15, 16), [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)])]).
step(end(k, 14),
     rule(4),
     ['I' = k,
      'End' = 14,
      'Table' = [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]],
     [interval_table([interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)]),
      member(interval(k, 13, 14), [interval(a, 10, 12), interval(b, 13, 15), interval(c, 12, 14), interval(d, 11, 13), interval(e, 10, 12), interval(f, 10, 11), interval(g, 11, 12), interval(h, 9, 16), interval(i, 16, 18), interval(j, 15, 16), interval(k, 13, 14)])]).
step(duration(a, 2),
     rule(18),
     ['I' = a, 'D' = 2, 'E' = 12, 'S' = 10],
     [end(a, 12), start(a, 10), 2 is 12 - 10]).
step(2 is 12 - 10, builtin, [], []).
step(duration(b, 2),
     rule(18),
     ['I' = b, 'D' = 2, 'E' = 15, 'S' = 13],
     [end(b, 15), start(b, 13), 2 is 15 - 13]).
step(2 is 15 - 13, builtin, [], []).
step(duration(c, 2),
     rule(18),
     ['I' = c, 'D' = 2, 'E' = 14, 'S' = 12],
     [end(c, 14), start(c, 12), 2 is 14 - 12]).
step(2 is 14 - 12, builtin, [], []).
step(duration(d, 2),
     rule(18),
     ['I' = d, 'D' = 2, 'E' = 13, 'S' = 11],
     [end(d, 13), start(d, 11), 2 is 13 - 11]).
step(2 is 13 - 11, builtin, [], []).
step(duration(e, 2),
     rule(18),
     ['I' = e, 'D' = 2, 'E' = 12, 'S' = 10],
     [end(e, 12), start(e, 10), 2 is 12 - 10]).
step(duration(f, 1),
     rule(18),
     ['I' = f, 'D' = 1, 'E' = 11, 'S' = 10],
     [end(f, 11), start(f, 10), 1 is 11 - 10]).
step(1 is 11 - 10, builtin, [], []).
step(duration(g, 1),
     rule(18),
     ['I' = g, 'D' = 1, 'E' = 12, 'S' = 11],
     [end(g, 12), start(g, 11), 1 is 12 - 11]).
step(1 is 12 - 11, builtin, [], []).
step(duration(h, 7),
     rule(18),
     ['I' = h, 'D' = 7, 'E' = 16, 'S' = 9],
     [end(h, 16), start(h, 9), 7 is 16 - 9]).
step(7 is 16 - 9, builtin, [], []).
step(duration(i, 2),
     rule(18),
     ['I' = i, 'D' = 2, 'E' = 18, 'S' = 16],
     [end(i, 18), start(i, 16), 2 is 18 - 16]).
step(2 is 18 - 16, builtin, [], []).
step(duration(j, 1),
     rule(18),
     ['I' = j, 'D' = 1, 'E' = 16, 'S' = 15],
     [end(j, 16), start(j, 15), 1 is 16 - 15]).
step(1 is 16 - 15, builtin, [], []).
step(duration(k, 1),
     rule(18),
     ['I' = k, 'D' = 1, 'E' = 14, 'S' = 13],
     [end(k, 14), start(k, 13), 1 is 14 - 13]).
step(1 is 14 - 13, builtin, [], []).
step(statement(a, before, b),
     rule(19),
     ['I' = a, 'Rel' = before, 'J' = b],
     [relation(a, before, b)]).
step(relation(a, before, b),
     rule(5),
     ['I' = a, 'J' = b, 'Ei' = 12, 'Sj' = 13],
     [end(a, 12), start(b, 13), 12 < 13]).
step(12 < 13, builtin, [], []).
step(statement(a, before, i),
     rule(19),
     ['I' = a, 'Rel' = before, 'J' = i],
     [relation(a, before, i)]).
step(relation(a, before, i),
     rule(5),
     ['I' = a, 'J' = i, 'Ei' = 12, 'Sj' = 16],
     [end(a, 12), start(i, 16), 12 < 16]).
step(12 < 16, builtin, [], []).
step(statement(a, before, j),
     rule(19),
     ['I' = a, 'Rel' = before, 'J' = j],
     [relation(a, before, j)]).
step(relation(a, before, j),
     rule(5),
     ['I' = a, 'J' = j, 'Ei' = 12, 'Sj' = 15],
     [end(a, 12), start(j, 15), 12 < 15]).
step(12 < 15, builtin, [], []).
step(statement(a, before, k),
     rule(19),
     ['I' = a, 'Rel' = before, 'J' = k],
     [relation(a, before, k)]).
step(relation(a, before, k),
     rule(5),
     ['I' = a, 'J' = k, 'Ei' = 12, 'Sj' = 13],
     [end(a, 12), start(k, 13), 12 < 13]).
step(statement(b, before, i),
     rule(19),
     ['I' = b, 'Rel' = before, 'J' = i],
     [relation(b, before, i)]).
step(relation(b, before, i),
     rule(5),
     ['I' = b, 'J' = i, 'Ei' = 15, 'Sj' = 16],
     [end(b, 15), start(i, 16), 15 < 16]).
step(15 < 16, builtin, [], []).
step(statement(c, before, i),
     rule(19),
     ['I' = c, 'Rel' = before, 'J' = i],
     [relation(c, before, i)]).
step(relation(c, before, i),
     rule(5),
     ['I' = c, 'J' = i, 'Ei' = 14, 'Sj' = 16],
     [end(c, 14), start(i, 16), 14 < 16]).
step(14 < 16, builtin, [], []).
step(statement(c, before, j),
     rule(19),
     ['I' = c, 'Rel' = before, 'J' = j],
     [relation(c, before, j)]).
step(relation(c, before, j),
     rule(5),
     ['I' = c, 'J' = j, 'Ei' = 14, 'Sj' = 15],
     [end(c, 14), start(j, 15), 14 < 15]).
step(14 < 15, builtin, [], []).
step(statement(d, before, i),
     rule(19),
     ['I' = d, 'Rel' = before, 'J' = i],
     [relation(d, before, i)]).
step(relation(d, before, i),
     rule(5),
     ['I' = d, 'J' = i, 'Ei' = 13, 'Sj' = 16],
     [end(d, 13), start(i, 16), 13 < 16]).
step(13 < 16, builtin, [], []).
step(statement(d, before, j),
     rule(19),
     ['I' = d, 'Rel' = before, 'J' = j],
     [relation(d, before, j)]).
step(relation(d, before, j),
     rule(5),
     ['I' = d, 'J' = j, 'Ei' = 13, 'Sj' = 15],
     [end(d, 13), start(j, 15), 13 < 15]).
step(13 < 15, builtin, [], []).
step(statement(e, before, b),
     rule(19),
     ['I' = e, 'Rel' = before, 'J' = b],
     [relation(e, before, b)]).
step(relation(e, before, b),
     rule(5),
     ['I' = e, 'J' = b, 'Ei' = 12, 'Sj' = 13],
     [end(e, 12), start(b, 13), 12 < 13]).
step(statement(e, before, i),
     rule(19),
     ['I' = e, 'Rel' = before, 'J' = i],
     [relation(e, before, i)]).
step(relation(e, before, i),
     rule(5),
     ['I' = e, 'J' = i, 'Ei' = 12, 'Sj' = 16],
     [end(e, 12), start(i, 16), 12 < 16]).
step(statement(e, before, j),
     rule(19),
     ['I' = e, 'Rel' = before, 'J' = j],
     [relation(e, before, j)]).
step(relation(e, before, j),
     rule(5),
     ['I' = e, 'J' = j, 'Ei' = 12, 'Sj' = 15],
     [end(e, 12), start(j, 15), 12 < 15]).
step(statement(e, before, k),
     rule(19),
     ['I' = e, 'Rel' = before, 'J' = k],
     [relation(e, before, k)]).
step(relation(e, before, k),
     rule(5),
     ['I' = e, 'J' = k, 'Ei' = 12, 'Sj' = 13],
     [end(e, 12), start(k, 13), 12 < 13]).
step(statement(f, before, b),
     rule(19),
     ['I' = f, 'Rel' = before, 'J' = b],
     [relation(f, before, b)]).
step(relation(f, before, b),
     rule(5),
     ['I' = f, 'J' = b, 'Ei' = 11, 'Sj' = 13],
     [end(f, 11), start(b, 13), 11 < 13]).
step(11 < 13, builtin, [], []).
step(statement(f, before, c),
     rule(19),
     ['I' = f, 'Rel' = before, 'J' = c],
     [relation(f, before, c)]).
step(relation(f, before, c),
     rule(5),
     ['I' = f, 'J' = c, 'Ei' = 11, 'Sj' = 12],
     [end(f, 11), start(c, 12), 11 < 12]).
step(11 < 12, builtin, [], []).
step(statement(f, before, i),
     rule(19),
     ['I' = f, 'Rel' = before, 'J' = i],
     [relation(f, before, i)]).
step(relation(f, before, i),
     rule(5),
     ['I' = f, 'J' = i, 'Ei' = 11, 'Sj' = 16],
     [end(f, 11), start(i, 16), 11 < 16]).
step(11 < 16, builtin, [], []).
step(statement(f, before, j),
     rule(19),
     ['I' = f, 'Rel' = before, 'J' = j],
     [relation(f, before, j)]).
step(relation(f, before, j),
     rule(5),
     ['I' = f, 'J' = j, 'Ei' = 11, 'Sj' = 15],
     [end(f, 11), start(j, 15), 11 < 15]).
step(11 < 15, builtin, [], []).
step(statement(f, before, k),
     rule(19),
     ['I' = f, 'Rel' = before, 'J' = k],
     [relation(f, before, k)]).
step(relation(f, before, k),
     rule(5),
     ['I' = f, 'J' = k, 'Ei' = 11, 'Sj' = 13],
     [end(f, 11), start(k, 13), 11 < 13]).
step(statement(g, before, b),
     rule(19),
     ['I' = g, 'Rel' = before, 'J' = b],
     [relation(g, before, b)]).
step(relation(g, before, b),
     rule(5),
     ['I' = g, 'J' = b, 'Ei' = 12, 'Sj' = 13],
     [end(g, 12), start(b, 13), 12 < 13]).
step(statement(g, before, i),
     rule(19),
     ['I' = g, 'Rel' = before, 'J' = i],
     [relation(g, before, i)]).
step(relation(g, before, i),
     rule(5),
     ['I' = g, 'J' = i, 'Ei' = 12, 'Sj' = 16],
     [end(g, 12), start(i, 16), 12 < 16]).
step(statement(g, before, j),
     rule(19),
     ['I' = g, 'Rel' = before, 'J' = j],
     [relation(g, before, j)]).
step(relation(g, before, j),
     rule(5),
     ['I' = g, 'J' = j, 'Ei' = 12, 'Sj' = 15],
     [end(g, 12), start(j, 15), 12 < 15]).
step(statement(g, before, k),
     rule(19),
     ['I' = g, 'Rel' = before, 'J' = k],
     [relation(g, before, k)]).
step(relation(g, before, k),
     rule(5),
     ['I' = g, 'J' = k, 'Ei' = 12, 'Sj' = 13],
     [end(g, 12), start(k, 13), 12 < 13]).
step(statement(k, before, i),
     rule(19),
     ['I' = k, 'Rel' = before, 'J' = i],
     [relation(k, before, i)]).
step(relation(k, before, i),
     rule(5),
     ['I' = k, 'J' = i, 'Ei' = 14, 'Sj' = 16],
     [end(k, 14), start(i, 16), 14 < 16]).
step(statement(k, before, j),
     rule(19),
     ['I' = k, 'Rel' = before, 'J' = j],
     [relation(k, before, j)]).
step(relation(k, before, j),
     rule(5),
     ['I' = k, 'J' = j, 'Ei' = 14, 'Sj' = 15],
     [end(k, 14), start(j, 15), 14 < 15]).
step(statement(a, meets, c),
     rule(19),
     ['I' = a, 'Rel' = meets, 'J' = c],
     [relation(a, meets, c)]).
step(relation(a, meets, c), rule(6), ['I' = a, 'J' = c, 'E' = 12], [end(a, 12), start(c, 12)]).
step(statement(b, meets, j),
     rule(19),
     ['I' = b, 'Rel' = meets, 'J' = j],
     [relation(b, meets, j)]).
step(relation(b, meets, j), rule(6), ['I' = b, 'J' = j, 'E' = 15], [end(b, 15), start(j, 15)]).
step(statement(d, meets, b),
     rule(19),
     ['I' = d, 'Rel' = meets, 'J' = b],
     [relation(d, meets, b)]).
step(relation(d, meets, b), rule(6), ['I' = d, 'J' = b, 'E' = 13], [end(d, 13), start(b, 13)]).
step(statement(d, meets, k),
     rule(19),
     ['I' = d, 'Rel' = meets, 'J' = k],
     [relation(d, meets, k)]).
step(relation(d, meets, k), rule(6), ['I' = d, 'J' = k, 'E' = 13], [end(d, 13), start(k, 13)]).
step(statement(e, meets, c),
     rule(19),
     ['I' = e, 'Rel' = meets, 'J' = c],
     [relation(e, meets, c)]).
step(relation(e, meets, c), rule(6), ['I' = e, 'J' = c, 'E' = 12], [end(e, 12), start(c, 12)]).
step(statement(f, meets, d),
     rule(19),
     ['I' = f, 'Rel' = meets, 'J' = d],
     [relation(f, meets, d)]).
step(relation(f, meets, d), rule(6), ['I' = f, 'J' = d, 'E' = 11], [end(f, 11), start(d, 11)]).
step(statement(f, meets, g),
     rule(19),
     ['I' = f, 'Rel' = meets, 'J' = g],
     [relation(f, meets, g)]).
step(relation(f, meets, g), rule(6), ['I' = f, 'J' = g, 'E' = 11], [end(f, 11), start(g, 11)]).
step(statement(g, meets, c),
     rule(19),
     ['I' = g, 'Rel' = meets, 'J' = c],
     [relation(g, meets, c)]).
step(relation(g, meets, c), rule(6), ['I' = g, 'J' = c, 'E' = 12], [end(g, 12), start(c, 12)]).
step(statement(h, meets, i),
     rule(19),
     ['I' = h, 'Rel' = meets, 'J' = i],
     [relation(h, meets, i)]).
step(relation(h, meets, i), rule(6), ['I' = h, 'J' = i, 'E' = 16], [end(h, 16), start(i, 16)]).
step(statement(j, meets, i),
     rule(19),
     ['I' = j, 'Rel' = meets, 'J' = i],
     [relation(j, meets, i)]).
step(relation(j, meets, i), rule(6), ['I' = j, 'J' = i, 'E' = 16], [end(j, 16), start(i, 16)]).
step(statement(a, overlaps, d),
     rule(19),
     ['I' = a, 'Rel' = overlaps, 'J' = d],
     [relation(a, overlaps, d)]).
step(relation(a, overlaps, d),
     rule(7),
     ['I' = a, 'J' = d, 'Si' = 10, 'Ei' = 12, 'Sj' = 11, 'Ej' = 13],
     [start(a, 10), end(a, 12), start(d, 11), end(d, 13), 10 < 11, 11 < 12, 12 < 13]).
step(10 < 11, builtin, [], []).
step(statement(c, overlaps, b),
     rule(19),
     ['I' = c, 'Rel' = overlaps, 'J' = b],
     [relation(c, overlaps, b)]).
step(relation(c, overlaps, b),
     rule(7),
     ['I' = c, 'J' = b, 'Si' = 12, 'Ei' = 14, 'Sj' = 13, 'Ej' = 15],
     [start(c, 12), end(c, 14), start(b, 13), end(b, 15), 12 < 13, 13 < 14, 14 < 15]).
step(13 < 14, builtin, [], []).
step(statement(d, overlaps, c),
     rule(19),
     ['I' = d, 'Rel' = overlaps, 'J' = c],
     [relation(d, overlaps, c)]).
step(relation(d, overlaps, c),
     rule(7),
     ['I' = d, 'J' = c, 'Si' = 11, 'Ei' = 13, 'Sj' = 12, 'Ej' = 14],
     [start(d, 11), end(d, 13), start(c, 12), end(c, 14), 11 < 12, 12 < 13, 13 < 14]).
step(statement(e, overlaps, d),
     rule(19),
     ['I' = e, 'Rel' = overlaps, 'J' = d],
     [relation(e, overlaps, d)]).
step(relation(e, overlaps, d),
     rule(7),
     ['I' = e, 'J' = d, 'Si' = 10, 'Ei' = 12, 'Sj' = 11, 'Ej' = 13],
     [start(e, 10), end(e, 12), start(d, 11), end(d, 13), 10 < 11, 11 < 12, 12 < 13]).
step(statement(f, starts, a),
     rule(19),
     ['I' = f, 'Rel' = starts, 'J' = a],
     [relation(f, starts, a)]).
step(relation(f, starts, a),
     rule(8),
     ['I' = f, 'J' = a, 'S' = 10, 'Ei' = 11, 'Ej' = 12],
     [start(f, 10), start(a, 10), end(f, 11), end(a, 12), 11 < 12]).
step(statement(f, starts, e),
     rule(19),
     ['I' = f, 'Rel' = starts, 'J' = e],
     [relation(f, starts, e)]).
step(relation(f, starts, e),
     rule(8),
     ['I' = f, 'J' = e, 'S' = 10, 'Ei' = 11, 'Ej' = 12],
     [start(f, 10), start(e, 10), end(f, 11), end(e, 12), 11 < 12]).
step(statement(g, starts, d),
     rule(19),
     ['I' = g, 'Rel' = starts, 'J' = d],
     [relation(g, starts, d)]).
step(relation(g, starts, d),
     rule(8),
     ['I' = g, 'J' = d, 'S' = 11, 'Ei' = 12, 'Ej' = 13],
     [start(g, 11), start(d, 11), end(g, 12), end(d, 13), 12 < 13]).
step(statement(k, starts, b),
     rule(19),
     ['I' = k, 'Rel' = starts, 'J' = b],
     [relation(k, starts, b)]).
step(relation(k, starts, b),
     rule(8),
     ['I' = k, 'J' = b, 'S' = 13, 'Ei' = 14, 'Ej' = 15],
     [start(k, 13), start(b, 13), end(k, 14), end(b, 15), 14 < 15]).
step(statement(a, during, h),
     rule(19),
     ['I' = a, 'Rel' = during, 'J' = h],
     [relation(a, during, h)]).
step(relation(a, during, h),
     rule(9),
     ['I' = a, 'J' = h, 'Si' = 10, 'Ei' = 12, 'Sj' = 9, 'Ej' = 16],
     [start(a, 10), end(a, 12), start(h, 9), end(h, 16), 9 < 10, 12 < 16]).
step(9 < 10, builtin, [], []).
step(statement(b, during, h),
     rule(19),
     ['I' = b, 'Rel' = during, 'J' = h],
     [relation(b, during, h)]).
step(relation(b, during, h),
     rule(9),
     ['I' = b, 'J' = h, 'Si' = 13, 'Ei' = 15, 'Sj' = 9, 'Ej' = 16],
     [start(b, 13), end(b, 15), start(h, 9), end(h, 16), 9 < 13, 15 < 16]).
step(9 < 13, builtin, [], []).
step(statement(c, during, h),
     rule(19),
     ['I' = c, 'Rel' = during, 'J' = h],
     [relation(c, during, h)]).
step(relation(c, during, h),
     rule(9),
     ['I' = c, 'J' = h, 'Si' = 12, 'Ei' = 14, 'Sj' = 9, 'Ej' = 16],
     [start(c, 12), end(c, 14), start(h, 9), end(h, 16), 9 < 12, 14 < 16]).
step(9 < 12, builtin, [], []).
step(statement(d, during, h),
     rule(19),
     ['I' = d, 'Rel' = during, 'J' = h],
     [relation(d, during, h)]).
step(relation(d, during, h),
     rule(9),
     ['I' = d, 'J' = h, 'Si' = 11, 'Ei' = 13, 'Sj' = 9, 'Ej' = 16],
     [start(d, 11), end(d, 13), start(h, 9), end(h, 16), 9 < 11, 13 < 16]).
step(9 < 11, builtin, [], []).
step(statement(e, during, h),
     rule(19),
     ['I' = e, 'Rel' = during, 'J' = h],
     [relation(e, during, h)]).
step(relation(e, during, h),
     rule(9),
     ['I' = e, 'J' = h, 'Si' = 10, 'Ei' = 12, 'Sj' = 9, 'Ej' = 16],
     [start(e, 10), end(e, 12), start(h, 9), end(h, 16), 9 < 10, 12 < 16]).
step(statement(f, during, h),
     rule(19),
     ['I' = f, 'Rel' = during, 'J' = h],
     [relation(f, during, h)]).
step(relation(f, during, h),
     rule(9),
     ['I' = f, 'J' = h, 'Si' = 10, 'Ei' = 11, 'Sj' = 9, 'Ej' = 16],
     [start(f, 10), end(f, 11), start(h, 9), end(h, 16), 9 < 10, 11 < 16]).
step(statement(g, during, h),
     rule(19),
     ['I' = g, 'Rel' = during, 'J' = h],
     [relation(g, during, h)]).
step(relation(g, during, h),
     rule(9),
     ['I' = g, 'J' = h, 'Si' = 11, 'Ei' = 12, 'Sj' = 9, 'Ej' = 16],
     [start(g, 11), end(g, 12), start(h, 9), end(h, 16), 9 < 11, 12 < 16]).
step(statement(k, during, h),
     rule(19),
     ['I' = k, 'Rel' = during, 'J' = h],
     [relation(k, during, h)]).
step(relation(k, during, h),
     rule(9),
     ['I' = k, 'J' = h, 'Si' = 13, 'Ei' = 14, 'Sj' = 9, 'Ej' = 16],
     [start(k, 13), end(k, 14), start(h, 9), end(h, 16), 9 < 13, 14 < 16]).
step(statement(g, finishes, a),
     rule(19),
     ['I' = g, 'Rel' = finishes, 'J' = a],
     [relation(g, finishes, a)]).
step(relation(g, finishes, a),
     rule(10),
     ['I' = g, 'J' = a, 'E' = 12, 'Si' = 11, 'Sj' = 10],
     [end(g, 12), end(a, 12), start(g, 11), start(a, 10), 10 < 11]).
step(statement(g, finishes, e),
     rule(19),
     ['I' = g, 'Rel' = finishes, 'J' = e],
     [relation(g, finishes, e)]).
step(relation(g, finishes, e),
     rule(10),
     ['I' = g, 'J' = e, 'E' = 12, 'Si' = 11, 'Sj' = 10],
     [end(g, 12), end(e, 12), start(g, 11), start(e, 10), 10 < 11]).
step(statement(j, finishes, h),
     rule(19),
     ['I' = j, 'Rel' = finishes, 'J' = h],
     [relation(j, finishes, h)]).
step(relation(j, finishes, h),
     rule(10),
     ['I' = j, 'J' = h, 'E' = 16, 'Si' = 15, 'Sj' = 9],
     [end(j, 16), end(h, 16), start(j, 15), start(h, 9), 9 < 15]).
step(9 < 15, builtin, [], []).
step(statement(k, finishes, c),
     rule(19),
     ['I' = k, 'Rel' = finishes, 'J' = c],
     [relation(k, finishes, c)]).
step(relation(k, finishes, c),
     rule(10),
     ['I' = k, 'J' = c, 'E' = 14, 'Si' = 13, 'Sj' = 12],
     [end(k, 14), end(c, 14), start(k, 13), start(c, 12), 12 < 13]).
step(statement(a, equals, a),
     rule(19),
     ['I' = a, 'Rel' = equals, 'J' = a],
     [relation(a, equals, a)]).
step(relation(a, equals, a),
     rule(11),
     ['I' = a, 'J' = a, 'S' = 10, 'E' = 12],
     [start(a, 10), start(a, 10), end(a, 12), end(a, 12)]).
step(statement(a, equals, e),
     rule(19),
     ['I' = a, 'Rel' = equals, 'J' = e],
     [relation(a, equals, e)]).
step(relation(a, equals, e),
     rule(11),
     ['I' = a, 'J' = e, 'S' = 10, 'E' = 12],
     [start(a, 10), start(e, 10), end(a, 12), end(e, 12)]).
step(statement(b, equals, b),
     rule(19),
     ['I' = b, 'Rel' = equals, 'J' = b],
     [relation(b, equals, b)]).
step(relation(b, equals, b),
     rule(11),
     ['I' = b, 'J' = b, 'S' = 13, 'E' = 15],
     [start(b, 13), start(b, 13), end(b, 15), end(b, 15)]).
step(statement(c, equals, c),
     rule(19),
     ['I' = c, 'Rel' = equals, 'J' = c],
     [relation(c, equals, c)]).
step(relation(c, equals, c),
     rule(11),
     ['I' = c, 'J' = c, 'S' = 12, 'E' = 14],
     [start(c, 12), start(c, 12), end(c, 14), end(c, 14)]).
step(statement(d, equals, d),
     rule(19),
     ['I' = d, 'Rel' = equals, 'J' = d],
     [relation(d, equals, d)]).
step(relation(d, equals, d),
     rule(11),
     ['I' = d, 'J' = d, 'S' = 11, 'E' = 13],
     [start(d, 11), start(d, 11), end(d, 13), end(d, 13)]).
step(statement(e, equals, a),
     rule(19),
     ['I' = e, 'Rel' = equals, 'J' = a],
     [relation(e, equals, a)]).
step(relation(e, equals, a),
     rule(11),
     ['I' = e, 'J' = a, 'S' = 10, 'E' = 12],
     [start(e, 10), start(a, 10), end(e, 12), end(a, 12)]).
step(statement(e, equals, e),
     rule(19),
     ['I' = e, 'Rel' = equals, 'J' = e],
     [relation(e, equals, e)]).
step(relation(e, equals, e),
     rule(11),
     ['I' = e, 'J' = e, 'S' = 10, 'E' = 12],
     [start(e, 10), start(e, 10), end(e, 12), end(e, 12)]).
step(statement(f, equals, f),
     rule(19),
     ['I' = f, 'Rel' = equals, 'J' = f],
     [relation(f, equals, f)]).
step(relation(f, equals, f),
     rule(11),
     ['I' = f, 'J' = f, 'S' = 10, 'E' = 11],
     [start(f, 10), start(f, 10), end(f, 11), end(f, 11)]).
step(statement(g, equals, g),
     rule(19),
     ['I' = g, 'Rel' = equals, 'J' = g],
     [relation(g, equals, g)]).
step(relation(g, equals, g),
     rule(11),
     ['I' = g, 'J' = g, 'S' = 11, 'E' = 12],
     [start(g, 11), start(g, 11), end(g, 12), end(g, 12)]).
step(statement(h, equals, h),
     rule(19),
     ['I' = h, 'Rel' = equals, 'J' = h],
     [relation(h, equals, h)]).
step(relation(h, equals, h),
     rule(11),
     ['I' = h, 'J' = h, 'S' = 9, 'E' = 16],
     [start(h, 9), start(h, 9), end(h, 16), end(h, 16)]).
step(statement(i, equals, i),
     rule(19),
     ['I' = i, 'Rel' = equals, 'J' = i],
     [relation(i, equals, i)]).
step(relation(i, equals, i),
     rule(11),
     ['I' = i, 'J' = i, 'S' = 16, 'E' = 18],
     [start(i, 16), start(i, 16), end(i, 18), end(i, 18)]).
step(statement(j, equals, j),
     rule(19),
     ['I' = j, 'Rel' = equals, 'J' = j],
     [relation(j, equals, j)]).
step(relation(j, equals, j),
     rule(11),
     ['I' = j, 'J' = j, 'S' = 15, 'E' = 16],
     [start(j, 15), start(j, 15), end(j, 16), end(j, 16)]).
step(statement(k, equals, k),
     rule(19),
     ['I' = k, 'Rel' = equals, 'J' = k],
     [relation(k, equals, k)]).
step(relation(k, equals, k),
     rule(11),
     ['I' = k, 'J' = k, 'S' = 13, 'E' = 14],
     [start(k, 13), start(k, 13), end(k, 14), end(k, 14)]).
step(statement(b, after, a),
     rule(19),
     ['I' = b, 'Rel' = after, 'J' = a],
     [relation(b, after, a)]).
step(relation(b, after, a), rule(12), ['J' = b, 'I' = a], [relation(a, before, b)]).
step(statement(i, after, a),
     rule(19),
     ['I' = i, 'Rel' = after, 'J' = a],
     [relation(i, after, a)]).
step(relation(i, after, a), rule(12), ['J' = i, 'I' = a], [relation(a, before, i)]).
step(statement(j, after, a),
     rule(19),
     ['I' = j, 'Rel' = after, 'J' = a],
     [relation(j, after, a)]).
step(relation(j, after, a), rule(12), ['J' = j, 'I' = a], [relation(a, before, j)]).
step(statement(k, after, a),
     rule(19),
     ['I' = k, 'Rel' = after, 'J' = a],
     [relation(k, after, a)]).
step(relation(k, after, a), rule(12), ['J' = k, 'I' = a], [relation(a, before, k)]).
step(statement(i, after, b),
     rule(19),
     ['I' = i, 'Rel' = after, 'J' = b],
     [relation(i, after, b)]).
step(relation(i, after, b), rule(12), ['J' = i, 'I' = b], [relation(b, before, i)]).
step(statement(i, after, c),
     rule(19),
     ['I' = i, 'Rel' = after, 'J' = c],
     [relation(i, after, c)]).
step(relation(i, after, c), rule(12), ['J' = i, 'I' = c], [relation(c, before, i)]).
step(statement(j, after, c),
     rule(19),
     ['I' = j, 'Rel' = after, 'J' = c],
     [relation(j, after, c)]).
step(relation(j, after, c), rule(12), ['J' = j, 'I' = c], [relation(c, before, j)]).
step(statement(i, after, d),
     rule(19),
     ['I' = i, 'Rel' = after, 'J' = d],
     [relation(i, after, d)]).
step(relation(i, after, d), rule(12), ['J' = i, 'I' = d], [relation(d, before, i)]).
step(statement(j, after, d),
     rule(19),
     ['I' = j, 'Rel' = after, 'J' = d],
     [relation(j, after, d)]).
step(relation(j, after, d), rule(12), ['J' = j, 'I' = d], [relation(d, before, j)]).
step(statement(b, after, e),
     rule(19),
     ['I' = b, 'Rel' = after, 'J' = e],
     [relation(b, after, e)]).
step(relation(b, after, e), rule(12), ['J' = b, 'I' = e], [relation(e, before, b)]).
step(statement(i, after, e),
     rule(19),
     ['I' = i, 'Rel' = after, 'J' = e],
     [relation(i, after, e)]).
step(relation(i, after, e), rule(12), ['J' = i, 'I' = e], [relation(e, before, i)]).
step(statement(j, after, e),
     rule(19),
     ['I' = j, 'Rel' = after, 'J' = e],
     [relation(j, after, e)]).
step(relation(j, after, e), rule(12), ['J' = j, 'I' = e], [relation(e, before, j)]).
step(statement(k, after, e),
     rule(19),
     ['I' = k, 'Rel' = after, 'J' = e],
     [relation(k, after, e)]).
step(relation(k, after, e), rule(12), ['J' = k, 'I' = e], [relation(e, before, k)]).
step(statement(b, after, f),
     rule(19),
     ['I' = b, 'Rel' = after, 'J' = f],
     [relation(b, after, f)]).
step(relation(b, after, f), rule(12), ['J' = b, 'I' = f], [relation(f, before, b)]).
step(statement(c, after, f),
     rule(19),
     ['I' = c, 'Rel' = after, 'J' = f],
     [relation(c, after, f)]).
step(relation(c, after, f), rule(12), ['J' = c, 'I' = f], [relation(f, before, c)]).
step(statement(i, after, f),
     rule(19),
     ['I' = i, 'Rel' = after, 'J' = f],
     [relation(i, after, f)]).
step(relation(i, after, f), rule(12), ['J' = i, 'I' = f], [relation(f, before, i)]).
step(statement(j, after, f),
     rule(19),
     ['I' = j, 'Rel' = after, 'J' = f],
     [relation(j, after, f)]).
step(relation(j, after, f), rule(12), ['J' = j, 'I' = f], [relation(f, before, j)]).
step(statement(k, after, f),
     rule(19),
     ['I' = k, 'Rel' = after, 'J' = f],
     [relation(k, after, f)]).
step(relation(k, after, f), rule(12), ['J' = k, 'I' = f], [relation(f, before, k)]).
step(statement(b, after, g),
     rule(19),
     ['I' = b, 'Rel' = after, 'J' = g],
     [relation(b, after, g)]).
step(relation(b, after, g), rule(12), ['J' = b, 'I' = g], [relation(g, before, b)]).
step(statement(i, after, g),
     rule(19),
     ['I' = i, 'Rel' = after, 'J' = g],
     [relation(i, after, g)]).
step(relation(i, after, g), rule(12), ['J' = i, 'I' = g], [relation(g, before, i)]).
step(statement(j, after, g),
     rule(19),
     ['I' = j, 'Rel' = after, 'J' = g],
     [relation(j, after, g)]).
step(relation(j, after, g), rule(12), ['J' = j, 'I' = g], [relation(g, before, j)]).
step(statement(k, after, g),
     rule(19),
     ['I' = k, 'Rel' = after, 'J' = g],
     [relation(k, after, g)]).
step(relation(k, after, g), rule(12), ['J' = k, 'I' = g], [relation(g, before, k)]).
step(statement(i, after, k),
     rule(19),
     ['I' = i, 'Rel' = after, 'J' = k],
     [relation(i, after, k)]).
step(relation(i, after, k), rule(12), ['J' = i, 'I' = k], [relation(k, before, i)]).
step(statement(j, after, k),
     rule(19),
     ['I' = j, 'Rel' = after, 'J' = k],
     [relation(j, after, k)]).
step(relation(j, after, k), rule(12), ['J' = j, 'I' = k], [relation(k, before, j)]).
step(statement(c, metBy, a),
     rule(19),
     ['I' = c, 'Rel' = metBy, 'J' = a],
     [relation(c, metBy, a)]).
step(relation(c, metBy, a), rule(13), ['J' = c, 'I' = a], [relation(a, meets, c)]).
step(statement(j, metBy, b),
     rule(19),
     ['I' = j, 'Rel' = metBy, 'J' = b],
     [relation(j, metBy, b)]).
step(relation(j, metBy, b), rule(13), ['J' = j, 'I' = b], [relation(b, meets, j)]).
step(statement(b, metBy, d),
     rule(19),
     ['I' = b, 'Rel' = metBy, 'J' = d],
     [relation(b, metBy, d)]).
step(relation(b, metBy, d), rule(13), ['J' = b, 'I' = d], [relation(d, meets, b)]).
step(statement(k, metBy, d),
     rule(19),
     ['I' = k, 'Rel' = metBy, 'J' = d],
     [relation(k, metBy, d)]).
step(relation(k, metBy, d), rule(13), ['J' = k, 'I' = d], [relation(d, meets, k)]).
step(statement(c, metBy, e),
     rule(19),
     ['I' = c, 'Rel' = metBy, 'J' = e],
     [relation(c, metBy, e)]).
step(relation(c, metBy, e), rule(13), ['J' = c, 'I' = e], [relation(e, meets, c)]).
step(statement(d, metBy, f),
     rule(19),
     ['I' = d, 'Rel' = metBy, 'J' = f],
     [relation(d, metBy, f)]).
step(relation(d, metBy, f), rule(13), ['J' = d, 'I' = f], [relation(f, meets, d)]).
step(statement(g, metBy, f),
     rule(19),
     ['I' = g, 'Rel' = metBy, 'J' = f],
     [relation(g, metBy, f)]).
step(relation(g, metBy, f), rule(13), ['J' = g, 'I' = f], [relation(f, meets, g)]).
step(statement(c, metBy, g),
     rule(19),
     ['I' = c, 'Rel' = metBy, 'J' = g],
     [relation(c, metBy, g)]).
step(relation(c, metBy, g), rule(13), ['J' = c, 'I' = g], [relation(g, meets, c)]).
step(statement(i, metBy, h),
     rule(19),
     ['I' = i, 'Rel' = metBy, 'J' = h],
     [relation(i, metBy, h)]).
step(relation(i, metBy, h), rule(13), ['J' = i, 'I' = h], [relation(h, meets, i)]).
step(statement(i, metBy, j),
     rule(19),
     ['I' = i, 'Rel' = metBy, 'J' = j],
     [relation(i, metBy, j)]).
step(relation(i, metBy, j), rule(13), ['J' = i, 'I' = j], [relation(j, meets, i)]).
step(statement(d, overlappedBy, a),
     rule(19),
     ['I' = d, 'Rel' = overlappedBy, 'J' = a],
     [relation(d, overlappedBy, a)]).
step(relation(d, overlappedBy, a), rule(14), ['J' = d, 'I' = a], [relation(a, overlaps, d)]).
step(statement(b, overlappedBy, c),
     rule(19),
     ['I' = b, 'Rel' = overlappedBy, 'J' = c],
     [relation(b, overlappedBy, c)]).
step(relation(b, overlappedBy, c), rule(14), ['J' = b, 'I' = c], [relation(c, overlaps, b)]).
step(statement(c, overlappedBy, d),
     rule(19),
     ['I' = c, 'Rel' = overlappedBy, 'J' = d],
     [relation(c, overlappedBy, d)]).
step(relation(c, overlappedBy, d), rule(14), ['J' = c, 'I' = d], [relation(d, overlaps, c)]).
step(statement(d, overlappedBy, e),
     rule(19),
     ['I' = d, 'Rel' = overlappedBy, 'J' = e],
     [relation(d, overlappedBy, e)]).
step(relation(d, overlappedBy, e), rule(14), ['J' = d, 'I' = e], [relation(e, overlaps, d)]).
step(statement(a, startedBy, f),
     rule(19),
     ['I' = a, 'Rel' = startedBy, 'J' = f],
     [relation(a, startedBy, f)]).
step(relation(a, startedBy, f), rule(15), ['J' = a, 'I' = f], [relation(f, starts, a)]).
step(statement(e, startedBy, f),
     rule(19),
     ['I' = e, 'Rel' = startedBy, 'J' = f],
     [relation(e, startedBy, f)]).
step(relation(e, startedBy, f), rule(15), ['J' = e, 'I' = f], [relation(f, starts, e)]).
step(statement(d, startedBy, g),
     rule(19),
     ['I' = d, 'Rel' = startedBy, 'J' = g],
     [relation(d, startedBy, g)]).
step(relation(d, startedBy, g), rule(15), ['J' = d, 'I' = g], [relation(g, starts, d)]).
step(statement(b, startedBy, k),
     rule(19),
     ['I' = b, 'Rel' = startedBy, 'J' = k],
     [relation(b, startedBy, k)]).
step(relation(b, startedBy, k), rule(15), ['J' = b, 'I' = k], [relation(k, starts, b)]).
step(statement(h, contains, a),
     rule(19),
     ['I' = h, 'Rel' = contains, 'J' = a],
     [relation(h, contains, a)]).
step(relation(h, contains, a), rule(16), ['J' = h, 'I' = a], [relation(a, during, h)]).
step(statement(h, contains, b),
     rule(19),
     ['I' = h, 'Rel' = contains, 'J' = b],
     [relation(h, contains, b)]).
step(relation(h, contains, b), rule(16), ['J' = h, 'I' = b], [relation(b, during, h)]).
step(statement(h, contains, c),
     rule(19),
     ['I' = h, 'Rel' = contains, 'J' = c],
     [relation(h, contains, c)]).
step(relation(h, contains, c), rule(16), ['J' = h, 'I' = c], [relation(c, during, h)]).
step(statement(h, contains, d),
     rule(19),
     ['I' = h, 'Rel' = contains, 'J' = d],
     [relation(h, contains, d)]).
step(relation(h, contains, d), rule(16), ['J' = h, 'I' = d], [relation(d, during, h)]).
step(statement(h, contains, e),
     rule(19),
     ['I' = h, 'Rel' = contains, 'J' = e],
     [relation(h, contains, e)]).
step(relation(h, contains, e), rule(16), ['J' = h, 'I' = e], [relation(e, during, h)]).
step(statement(h, contains, f),
     rule(19),
     ['I' = h, 'Rel' = contains, 'J' = f],
     [relation(h, contains, f)]).
step(relation(h, contains, f), rule(16), ['J' = h, 'I' = f], [relation(f, during, h)]).
step(statement(h, contains, g),
     rule(19),
     ['I' = h, 'Rel' = contains, 'J' = g],
     [relation(h, contains, g)]).
step(relation(h, contains, g), rule(16), ['J' = h, 'I' = g], [relation(g, during, h)]).
step(statement(h, contains, k),
     rule(19),
     ['I' = h, 'Rel' = contains, 'J' = k],
     [relation(h, contains, k)]).
step(relation(h, contains, k), rule(16), ['J' = h, 'I' = k], [relation(k, during, h)]).
step(statement(a, finishedBy, g),
     rule(19),
     ['I' = a, 'Rel' = finishedBy, 'J' = g],
     [relation(a, finishedBy, g)]).
step(relation(a, finishedBy, g), rule(17), ['J' = a, 'I' = g], [relation(g, finishes, a)]).
step(statement(e, finishedBy, g),
     rule(19),
     ['I' = e, 'Rel' = finishedBy, 'J' = g],
     [relation(e, finishedBy, g)]).
step(relation(e, finishedBy, g), rule(17), ['J' = e, 'I' = g], [relation(g, finishes, e)]).
step(statement(h, finishedBy, j),
     rule(19),
     ['I' = h, 'Rel' = finishedBy, 'J' = j],
     [relation(h, finishedBy, j)]).
step(relation(h, finishedBy, j), rule(17), ['J' = h, 'I' = j], [relation(j, finishes, h)]).
step(statement(c, finishedBy, k),
     rule(19),
     ['I' = c, 'Rel' = finishedBy, 'J' = k],
     [relation(c, finishedBy, k)]).
step(relation(c, finishedBy, k), rule(17), ['J' = c, 'I' = k], [relation(k, finishes, c)]).
