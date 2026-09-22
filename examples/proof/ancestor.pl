% Prolog result format 4
query(1, parent(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 0).
query(2, ancestor(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 6).
answer(2, ['X0' = pat, 'X1' = jan]).
why(2, ['X0' = pat, 'X1' = jan], [ancestor(pat, jan)]).
answer(2, ['X0' = jan, 'X1' = lies]).
why(2, ['X0' = jan, 'X1' = lies], [ancestor(jan, lies)]).
answer(2, ['X0' = lies, 'X1' = emma]).
why(2, ['X0' = lies, 'X1' = emma], [ancestor(lies, emma)]).
answer(2, ['X0' = pat, 'X1' = lies]).
why(2, ['X0' = pat, 'X1' = lies], [ancestor(pat, lies)]).
answer(2, ['X0' = pat, 'X1' = emma]).
why(2, ['X0' = pat, 'X1' = emma], [ancestor(pat, emma)]).
answer(2, ['X0' = jan, 'X1' = emma]).
why(2, ['X0' = jan, 'X1' = emma], [ancestor(jan, emma)]).

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
