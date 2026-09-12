% Adapted from Trealla Prolog tests/tests/test0059.pl (test17).
% See test/conformance/THIRD_PARTY.md.
%% goal: curly_braces_as_predicate(ok)

curly_braces_as_predicate(ok) :-
    assertz({abc, 123}), assertz({xyz, 456}),
    clause({abc, X}, B), X = 123, B = true,
    clause({xyz, Y}, C), Y = 456, C = true,
    {abc, Z}, Z = 123,
    retract({xyz, W}), W = 456.
