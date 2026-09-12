% Adapted from SWI-Prolog tests/library/test_assoc.pl (unbalanced_1/2/3,
% unordered_1/2/3, bad_structure_1/2, bad_structure_keys_not_ground).
% See test/conformance/THIRD_PARTY.md.
:- use_module(library(assoc)).

%% goal: assoc_is_assoc_rejects_unbalanced(ok)

assoc_is_assoc_rejects_unbalanced(ok) :-
    \+ is_assoc(t(5, 1, <, t(3, 1, <, t(2, 1, <, t(1, 1, -, t, t), t), t(4, 1, -, t, t)),
                  t(8, 1, -, t(7, 1, <, t(6, 1, -, t, t), t), t(10, 1, -, t(9, 1, -, t, t), t(11, 1, -, t, t))))),
    \+ is_assoc(t(5, 1, -, t(3, 1, -, t(2, 1, <, t(1, 1, -, t, t), t), t(4, 1, -, t, t)),
                  t(8, 1, -, t(7, 1, <, t(6, 1, -, t, t), t), t(10, 1, -, t(9, 1, -, t, t), t(11, 1, -, t, t))))),
    \+ is_assoc(t(5, 1, -, t(3, 1, <, t(2, 1, <, t(1, 1, -, t, t), t), t(4, 1, -, t, t)),
                  t(8, 1, -, t(7, 1, <, t(6, 1, -, t, t), t), t(10, 1, -, t(9, 1, -, t, t), t(11, 1, >, t, t))))),
    !.

%% goal: assoc_is_assoc_rejects_unordered(ok)

assoc_is_assoc_rejects_unordered(ok) :-
    \+ is_assoc(t(5, 1, -, t(3, 1, <, t(2, 1, >, t, t(1, 1, -, t, t)), t(4, 1, -, t, t)),
                  t(8, 1, -, t(7, 1, <, t(6, 1, -, t, t), t), t(10, 1, -, t(9, 1, -, t, t), t(11, 1, -, t, t))))),
    \+ is_assoc(t(5, 1, -, t(4, 1, <, t(2, 1, <, t(1, 1, -, t, t), t), t(4, 1, -, t, t)),
                  t(8, 1, -, t(7, 1, <, t(6, 1, -, t, t), t), t(10, 1, -, t(9, 1, -, t, t), t(11, 1, -, t, t))))),
    \+ is_assoc(t(5, 1, -, t(3, 1, <, t(2, 1, <, t(1, 1, -, t, t), t), t(6, 1, -, t, t)),
                  t(8, 1, -, t(7, 1, <, t(6, 1, -, t, t), t), t(10, 1, -, t(9, 1, -, t, t), t(11, 1, -, t, t))))),
    !.

%% goal: assoc_is_assoc_rejects_bad_structure(ok)

assoc_is_assoc_rejects_bad_structure(ok) :-
    \+ is_assoc(t(5, 1, =, t(3, 1, <, t(2, 1, <, t(1, 1, -, t, t), t), t(4, 1, -, t, t)),
                  t(8, 1, -, t(7, 1, <, t(6, 1, -, t, t), t), t(10, 1, -, t(9, 1, -, t, t), t(11, 1, -, t, t))))),
    \+ is_assoc(t(5, 1, -, t(3, 1, <, t(2, 1, <, t(1, 1, -, t, t), t), t(4, 1, -, t, t)),
                  t(8, 1, -, t(7, 1, <, t(6, 1, -, t, t), t), t(10, 1, -, t(9, 1, -, t, t), t(11, 1, -, f, t))))),
    \+ is_assoc(t(5, 1, -, t(3-_X, 1, <, t(2, 1, <, t(1, 1, -, t, t), t), t(4, 1, -, t, t)),
                  t(8, 1, -, t(7, 1, <, t(6, 1, -, t, t), t), t(10, 1, -, t(9, 1, -, t, t), t(11, 1, -, t, t))))),
    !.
