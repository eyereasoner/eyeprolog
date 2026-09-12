% Adapted from Trealla Prolog tests/tests/test0059.pl (test18).
% See test/conformance/THIRD_PARTY.md.
%% goal: ground_progressive_backtracking(ok)

t18a2(X) :- X = f(a, b), fail.
t18a2(X) :- X = f(b, c), fail.
t18a2(X) :- X = f(_, world).
t18a(X) :- t18a2(X).

t18b2(X) :- X = f(e, f), fail.
t18b2(X) :- X = f(f, g), fail.
t18b2(X) :- X = f(hello, _).
t18b(X) :- t18b2(X).

ground_progressive_backtracking(ok) :-
    X = f(_, _),
    t18a(X),
    \+ ground(X),
    t18b(X),
    ground(X),
    X = f(hello, world).
