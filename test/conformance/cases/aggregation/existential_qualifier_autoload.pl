% ISO/IEC 13211-1:1995, 7.1.6.3 (iterated-goal term) with 8.10.2/8.10.3.
% The goal argument of bagof/3 and setof/3 is `V1^...^Goal`, so every static
% analysis has to look through the `^` qualifiers to reach the callable term.
% Regression: the library autoloader used to stop at `^/2`, which made
% setof(X, Y^member(X,L), S) raise existence_error(member/2) while the
% unqualified setof(X, member(X,L), S) resolved normally.
answer(plain, S) :- setof(X, member(X, [b,a,b]), S).
answer(qualified, S) :- setof(X, Y^member(X, [b,a,b]), S).
answer(qualified_bag, S) :- bagof(X, Y^member(X, [b,a,b]), S).
answer(nested, S) :- setof(X, Y^Z^member(X-Y-Z, [1-a-p, 2-b-q]), S).
answer(witness_kept, S) :- setof(X-Y, Y^member(X-Y, [2-b, 1-a]), S).
%% ?- answer(X0, X1).
