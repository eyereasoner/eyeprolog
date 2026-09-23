ancestor(pat, jan).
ancestor(jan, lies).
ancestor(lies, emma).
ancestor(pat, lies).
ancestor(pat, emma).
ancestor(jan, emma).

clause(1, parent(pat, jan), true).
clause(2, parent(jan, lies), true).
clause(3, parent(lies, emma), true).
clause(4, ancestor(var('X'), var('Y')), parent(var('X'), var('Y'))).
clause(5,
       ancestor(var('X'), var('Z')),
       (parent(var('X'), var('Y')), ancestor(var('Y'), var('Z')))).

step(ancestor(pat, jan), rule(4), ['X' = pat, 'Y' = jan], [parent(pat, jan)]).
step(parent(pat, jan), fact(1), [], []).
step(ancestor(jan, lies), rule(4), ['X' = jan, 'Y' = lies], [parent(jan, lies)]).
step(parent(jan, lies), fact(2), [], []).
step(ancestor(lies, emma), rule(4), ['X' = lies, 'Y' = emma], [parent(lies, emma)]).
step(parent(lies, emma), fact(3), [], []).
step(ancestor(pat, lies),
     rule(5),
     ['X' = pat, 'Z' = lies, 'Y' = jan],
     [parent(pat, jan), ancestor(jan, lies)]).
step(ancestor(pat, emma),
     rule(5),
     ['X' = pat, 'Z' = emma, 'Y' = jan],
     [parent(pat, jan), ancestor(jan, emma)]).
step(ancestor(jan, emma),
     rule(5),
     ['X' = jan, 'Z' = emma, 'Y' = lies],
     [parent(jan, lies), ancestor(lies, emma)]).
