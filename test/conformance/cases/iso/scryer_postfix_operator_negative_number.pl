% Adapted from Scryer Prolog tests-pl/iso-conformity-tests.pl, test
% 55. See test/conformance/THIRD_PARTY.md.

:- op(1, yf, yf1).

%% goal: postfix_operator_negative_number(T)

postfix_operator_negative_number(T) :-
    T = {-1 yf1},
    T = {yf1(-1)}.
