sameInputByCompositeInjectivity(h, a, b).
sameInputByCompositeInjectivity(h, b, a).

clause(7, inZ(e), true).
clause(10, sameTerm(var('X'), var('X')), inZ(var('X'))).
clause(11, sameTerm(var('Y'), var('X')), (var('Y') @< var('X'), sameTerm(var('X'), var('Y')))).
clause(12, app(f, a, c), true).
clause(13, app(f, b, d), true).
clause(14, app(g, c, e), true).
clause(15, app(g, d, e), true).
clause(16, injective(f), true).
clause(17, injective(g), true).
clause(18, compositeOf(h, g, f), true).
clause(19,
       app(var('H'), var('X'), var('Z')),
       (compositeOf(var('H'), var('G'), var('F')),
        app(var('F'), var('X'), var('Y')),
        app(var('G'), var('Y'), var('Z')))).
clause(20,
       sameTerm(var('X'), var('Y')),
       (injective(var('F')),
        app(var('F'), var('X'), var('U')),
        app(var('F'), var('Y'), var('V')),
        sameTerm(var('U'), var('V')))).
clause(21,
       sameInputByCompositeInjectivity(var('H'), var('X'), var('Y')),
       (compositeOf(var('H'), var('G'), var('F')),
        injective(var('G')),
        injective(var('F')),
        app(var('H'), var('X'), var('Z')),
        app(var('H'), var('Y'), var('Z')),
        sameTerm(var('X'), var('Y')),
        var('X') \= var('Y'))).

step(sameInputByCompositeInjectivity(h, a, b),
     rule(21),
     ['H' = h, 'X' = a, 'Y' = b, 'G' = g, 'F' = f, 'Z' = e],
     [compositeOf(h, g, f),
      injective(g),
      injective(f),
      app(h, a, e),
      app(h, b, e),
      sameTerm(a, b),
      a \= b]).
step(compositeOf(h, g, f), fact(18), [], []).
step(injective(g), fact(17), [], []).
step(injective(f), fact(16), [], []).
step(app(h, a, e),
     rule(19),
     ['H' = h, 'X' = a, 'Z' = e, 'G' = g, 'F' = f, 'Y' = c],
     [compositeOf(h, g, f), app(f, a, c), app(g, c, e)]).
step(app(f, a, c), fact(12), [], []).
step(app(g, c, e), fact(14), [], []).
step(app(h, b, e),
     rule(19),
     ['H' = h, 'X' = b, 'Z' = e, 'G' = g, 'F' = f, 'Y' = d],
     [compositeOf(h, g, f), app(f, b, d), app(g, d, e)]).
step(app(f, b, d), fact(13), [], []).
step(app(g, d, e), fact(15), [], []).
step(sameTerm(a, b), rule(11), ['Y' = a, 'X' = b], [a @< b, sameTerm(b, a)]).
step(a @< b, builtin, [], []).
step(sameTerm(b, a),
     rule(20),
     ['X' = b, 'Y' = a, 'F' = f, 'U' = d, 'V' = c],
     [injective(f), app(f, b, d), app(f, a, c), sameTerm(d, c)]).
step(sameTerm(d, c),
     rule(20),
     ['X' = d, 'Y' = c, 'F' = g, 'U' = e, 'V' = e],
     [injective(g), app(g, d, e), app(g, c, e), sameTerm(e, e)]).
step(sameTerm(e, e), rule(10), ['X' = e], [inZ(e)]).
step(inZ(e), fact(7), [], []).
step(a \= b, builtin, [], []).
step(sameInputByCompositeInjectivity(h, b, a),
     rule(21),
     ['H' = h, 'X' = b, 'Y' = a, 'G' = g, 'F' = f, 'Z' = e],
     [compositeOf(h, g, f),
      injective(g),
      injective(f),
      app(h, b, e),
      app(h, a, e),
      sameTerm(b, a),
      b \= a]).
step(b \= a, builtin, [], []).
