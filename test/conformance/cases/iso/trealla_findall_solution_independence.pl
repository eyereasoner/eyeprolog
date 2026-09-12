% Adapted from Trealla Prolog tests/tests/test0071.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: findall_solutions_are_independent_copies(ok)

findall_solutions_are_independent_copies(ok) :-
    findall(I, member(I, [A,B,B,A]), [A1,B1,B2,A2]),
    A1 \== A2,
    B1 \== B2,
    A1 \== B1.
