collision(g2, c, d).
collision(g2, d, c).
collision(h2, a, b).
collision(h2, b, a).
compositeInjective(h, g, f).

clause(2, function(f), true).
clause(3, function(g), true).
clause(5, function(h), true).
clause(7, app(f, a, c), true).
clause(8, app(f, b, d), true).
clause(11, app(g2, c, e), true).
clause(12, app(g2, d, e), true).
clause(13, compositeOf(h, g, f), true).
clause(14, compositeOf(h2, g2, f), true).
clause(15,
       app(var('H'), var('X'), var('Z')),
       (compositeOf(var('H'), var('G'), var('F')),
        app(var('F'), var('X'), var('Y')),
        app(var('G'), var('Y'), var('Z')))).
clause(16,
       collision(var('F'), var('X'), var('Y')),
       (app(var('F'), var('X'), var('Z')),
        app(var('F'), var('Y'), var('Z')),
        var('X') \= var('Y'))).
clause(17,
       injective(var('F')),
       (function(var('F')), \+ collision(var('F'), anonymous(1), anonymous(2)))).
clause(18,
       compositeInjective(var('H'), var('G'), var('F')),
       (compositeOf(var('H'), var('G'), var('F')),
        injective(var('G')),
        injective(var('F')),
        injective(var('H')))).

step(collision(g2, c, d),
     rule(16),
     ['F' = g2, 'X' = c, 'Y' = d, 'Z' = e],
     [app(g2, c, e), app(g2, d, e), c \= d]).
step(app(g2, c, e), fact(11), [], []).
step(app(g2, d, e), fact(12), [], []).
step(c \= d, builtin, [], []).
step(collision(g2, d, c),
     rule(16),
     ['F' = g2, 'X' = d, 'Y' = c, 'Z' = e],
     [app(g2, d, e), app(g2, c, e), d \= c]).
step(d \= c, builtin, [], []).
step(collision(h2, a, b),
     rule(16),
     ['F' = h2, 'X' = a, 'Y' = b, 'Z' = e],
     [app(h2, a, e), app(h2, b, e), a \= b]).
step(app(h2, a, e),
     rule(15),
     ['H' = h2, 'X' = a, 'Z' = e, 'G' = g2, 'F' = f, 'Y' = c],
     [compositeOf(h2, g2, f), app(f, a, c), app(g2, c, e)]).
step(compositeOf(h2, g2, f), fact(14), [], []).
step(app(f, a, c), fact(7), [], []).
step(app(h2, b, e),
     rule(15),
     ['H' = h2, 'X' = b, 'Z' = e, 'G' = g2, 'F' = f, 'Y' = d],
     [compositeOf(h2, g2, f), app(f, b, d), app(g2, d, e)]).
step(app(f, b, d), fact(8), [], []).
step(a \= b, builtin, [], []).
step(collision(h2, b, a),
     rule(16),
     ['F' = h2, 'X' = b, 'Y' = a, 'Z' = e],
     [app(h2, b, e), app(h2, a, e), b \= a]).
step(b \= a, builtin, [], []).
step(compositeInjective(h, g, f),
     rule(18),
     ['H' = h, 'G' = g, 'F' = f],
     [compositeOf(h, g, f), injective(g), injective(f), injective(h)]).
step(compositeOf(h, g, f), fact(13), [], []).
step(injective(g), rule(17), ['F' = g], [function(g), \+ collision(g, __anon0, __anon1)]).
step(function(g), fact(3), [], []).
step(\+ collision(g, __anon0, __anon1), absent, [], []).
step(injective(f), rule(17), ['F' = f], [function(f), \+ collision(f, __anon0, __anon1)]).
step(function(f), fact(2), [], []).
step(\+ collision(f, __anon0, __anon1), absent, [], []).
step(injective(h), rule(17), ['F' = h], [function(h), \+ collision(h, __anon0, __anon1)]).
step(function(h), fact(5), [], []).
step(\+ collision(h, __anon0, __anon1), absent, [], []).
