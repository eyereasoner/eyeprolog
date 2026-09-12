% Adapted from SWI-Prolog tests/core_text/test_syntax.pl (op_3): `:-` is xfx
% (non-associative), so a chained `a:-b:-c` is a genuine operator-priority
% clash, not a parse of either association. See test/conformance/THIRD_PARTY.md.
%% goal: answer
answer :- X = (a:-b:-c).
