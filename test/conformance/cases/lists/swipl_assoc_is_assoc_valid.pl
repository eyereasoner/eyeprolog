% Adapted from SWI-Prolog tests/library/test_assoc.pl (wirth_85).
% See test/conformance/THIRD_PARTY.md.
:- use_module(library(assoc)).

%% goal: assoc_is_assoc_valid(ok)

assoc_is_assoc_valid(ok) :-
    is_assoc(t(5, 1, -, t(3, 1, <, t(2, 1, <, t(1, 1, -, t, t), t), t(4, 1, -, t, t)),
                t(8, 1, -, t(7, 1, <, t(6, 1, -, t, t), t), t(10, 1, -, t(9, 1, -, t, t), t(11, 1, -, t, t))))),
    !.
