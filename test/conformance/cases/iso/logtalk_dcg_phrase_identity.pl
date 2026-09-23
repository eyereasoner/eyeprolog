% Adapted from Logtalk phrase_3_15 through 21. Modified for EyeProlog's harness.
% See test/conformance/THIRD_PARTY.md.
%% ?- phrase_identity(X0, X1).

phrase_identity(empty_braces, Rest) :- phrase({}, [tail], Rest).
phrase_identity(true_goal, Rest) :- phrase({true}, [tail], Rest).
phrase_identity(cut, Rest) :- phrase(!, [tail], Rest).
phrase_identity(terminals, Input) :- phrase([a, b], Input, []).
phrase_identity(suffix, Input) :- phrase([a, b], Input, [b]).
phrase_identity(committed_failures, preserved) :-
    \+ phrase({!, fail}, [], []),
    \+ phrase(({!, fail}; {true}), [], []).
