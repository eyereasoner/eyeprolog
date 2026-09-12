% Adapted from Trealla Prolog tests/tests/test0032.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: forall_arithmetic_facts(ok)

eq32(3, 1 + 2).
eq32(24, 6 * 4).
eq32(1, 5 mod 2).

forall_arithmetic_facts(ok) :-
    forall(eq32(Left, Right), Left =:= Right).
