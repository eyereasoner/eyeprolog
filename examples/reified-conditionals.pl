% Reified conditionals: a "reified" predicate turns a condition into an
% ordinary term (true or false) that a caller receives as data, instead of
% committing to one branch itself the way (->)/2 does. if_/3 then dispatches
% on that term. The payoff is that reusable control predicates like
% tfilter/3 and tpartition/4 can be built once, on top of if_/3, and applied
% to any reified condition -- filtering and partitioning are not each
% reimplemented per predicate the way they would be with hand-written
% (->)/2 chains.
:- use_module(library(reif)).

even_t(N, true) :- 0 is N mod 2, !.
even_t(_, false).

%% goal: answer(X0, X1, X2, X3)

answer(Evens, Odds, First, Second) :-
    tfilter(even_t, [1, 2, 3, 4, 5, 6, 7, 8], Evens),
    tpartition(even_t, [1, 2, 3, 4, 5, 6, 7, 8], _, Odds),
    if_(even_t(4), First = even, First = odd),
    if_(even_t(7), Second = even, Second = odd).
