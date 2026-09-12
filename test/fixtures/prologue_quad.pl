% p.p.1 member/2

?- member(X, [1,2]).
   X = 1
;  X = 2.

?- member(1, L).
   L = [1|_A]
;  L = [_A,1|_B]
;  L = [_A,_B,1|_C]
;  ..., ad_infinitum.

?- member(X, [Y,Z|nonlist]).
   X = Y
;  X = Z.

?- member(X, nonlist).
   false.

?- member(X, X).
   sto, % occurs-check
   loops
|  sto, % rational trees
   X = [X|_A]
;  X = [_A,X|_B]
;  X = [_A,_B,X|_C]
;  ..., ad_infinitum
|  sto, % literal substitutions
   X = [_A|_B]
;  X = [_A,[_A,[_A|_B]|_C]|_C]
;  X = [_A,_B,[_A,_B,[_A,_B|_C]|_D]|_D]
;  ..., ad_infinitum.

% p.p.2 append/3

?- append([a,b],[c,d], Xs).
   Xs = [a,b,c,d].

?- append([a], nonlist, Xs).
   Xs = [a|nonlist].

?- append([a], Ys, Zs).
   Zs = [a|Ys].

?- append(Xs, Ys, [a,b,c]).
   Xs = [], Ys = [a,b,c]
;  Xs = [a], Ys = [b,c]
;  Xs = [a,b], Ys = [c]
;  Xs = [a,b,c], Ys = [].

% p.p.3 length/2

?- length([a,b,c], Length).
   Length = 3.

?- length(List, 5).
   List = [_,_,_,_,_].

?- length(List, Length).
   List = [], Length = 0
;  List = [_], Length = 1
;  List = [_,_], Length = 2
;  ... . % Ad infinitum.

% p.p.4 between/3

?- between(1, 2, 0).
   false.

?- between(1, 2, I).
   I = 1
;  I = 2.

?- between(2, 1, I).
   false.

?- between(I, I, 0).
   instantiation_error.

?- between(1, I, 0).
   instantiation_error.

?- between(I, -1, 0).
   instantiation_error.

?- between(1, c, 0).
   type_error(integer,c).

?- between(1+1,2,I).
   type_error(integer,1+1).

% p.p.5 select/3

?- select(X, [1,2], Xs).
   X = 1, Xs = [2]
;  X = 2, Xs = [1].

?- select(X, [Y|nonlist], Xs).
   X = Y, Xs = nonlist.

?- select(E, Xs, Xs).
   sto, % occurs-check
   loops
|  sto, % rational trees
   Xs = [E|Xs]
;  Xs = [_A|_B], _B = [E|_B]
;  ..., ad_infinitum
|  sto, % literal substitutions
   Xs = [E,E|_A]
;  Xs = [_A,E,E|_B]
;  ..., ad_infinitum.

% p.p.6 succ/2

?- succ(X, S).
   instantiation_error.

?- succ(X, X).
   instantiation_error.

?- succ(0, S).
   S = 1.

?- succ(1, 1+1).
   type_error(integer, 1+1).

?- succ(X, 0).
   false.

?- succ(-1, S).
   domain_error(not_less_than_zero, -1).

?- current_prolog_flag(max_integer, MI), succ(MI, 0).
   false.

?- current_prolog_flag(max_integer, MI), succ(MI, 1).
   false.

?- current_prolog_flag(max_integer, MI), succ(MI, MI).
   false.

?- current_prolog_flag(max_integer, MI), succ(MI, S).
   false
|  evaluation_error(int_overflow)
|  representation_error(max_integer).

% p.p.7

?- maplist(>(3), [1, 2]).
   true.

?- maplist(>(3), [1, 2, 3]).
   false.

?- maplist(=(X), Xs).
   Xs = []
;  Xs = [X]
;  Xs = [X, X]
;  Xs = [X, X, X]
;  ... . % Ad infinitum.

% p.p.8

?- nth0(1, [a,b,c], E).
   E = b.

?- nth0(N, [a,b,c], E).
   N = 0, E = a
;  N = 1, E = b
;  N = 2, E = c.

?- nth0(0, [A,B|non_list], E).
   A = E.

?- nth0(2, Es, E).
   Es = [_A,_B,E|_C].

?- nth0(N, Es, E).
   N = 0, Es = [E|_A]
;  N = 1, Es = [_A,E|_B]
;  N = 2, Es = [_A,_B,E|_C]
;  N = 3, Es = [_A,_B,_C,E|_D]
;  ..., ad_infinitum.

?- nth0(non_integer, Es, E).
   type_error(integer, non_integer).

?- nth0(-1, Es, E).
   domain_error(not_less_than_zero, -1).

?- nth0(N, [[]|Es], Es).
   N = 0, Es = []
;  sto, % occurs-check
   loops
|  N = 0, Es = []
;  sto, % rational trees
   N = 1, Es = [Es|_A]
;  N = 2, Es = [_A,Es|_B]
;  ..., ad_infinitum.

?- nth1(0, Es, E).
   false.

% p.p.9

?- call_nth(true, Nth).
   Nth = 1.

?- call_nth(false, Nth).
   false.

?- call_nth(repeat, Nth).
   Nth = 1
;  Nth = 2
;  Nth = 3
;  Nth = 4
;  Nth = 5
;  ... .

?- call_nth(( N = 1 ; N = 2 ), Nth).
   N = 1, Nth = 1
;  N = 2, Nth = 2.

?- call_nth(true, non_integer).
   type_error(integer,non_integer).

?- call_nth(true, 1.0).
   type_error(integer,1.0).

?- call_nth(true, 0).
   false.

?- call_nth(repeat, 0).
   false.

?- call_nth(repeat, -1).
   domain_error(not_less_than_zero,-1).

?- call_nth(length(L,N), 3).
   L = [_A,_B], N = 2.

?- call_nth(inex, 0).
   false. % thus not existence_error(procedure,inex/0)

?- call_nth(inex, 0).
   existence_error(procedure,...), unexpected.

?- call_nth(1, 0).
   false.

?- call_nth(V, 0).
   false.

?- call_nth(N = 1, N).
   N = 1.

?- call_nth(N = -1, N).
   false.

?- call_nth(repeat,1+1).
   type_error(integer,1+1).

% p.p.10

?- foldl(append, [[1,2],[3],[4,5]], [],Xs).
   Xs = [4,5,3,1,2].

% p.p.11

?- countall((X=1;X=2), N).
   N = 2.
?- countall((true;true), N).
   N = 2.
?- countall(G_0, N).
   instantiation_error.
?- countall((length(L,5),nth0(_,L,_),nth0(_,L,_)), N).
   N = 25.
?- countall(N = 1, N).
   N = 1.
?- countall(N = non_integer, N).
   N = 1.
?- countall(false, 1).
   false.
?- countall(false, -1).
   domain_error(not_less_than_zero,-1).
?- countall(false, non_integer).
   type_error(integer,non_integer).
