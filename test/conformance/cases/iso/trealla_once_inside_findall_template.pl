% Adapted from Trealla Prolog tests/tests/test0059.pl (test16c).
% See test/conformance/THIRD_PARTY.md.
%% goal: once_inside_findall_template(X0)

age_once(peter, 7).
age_once(anne, 5).
age_once(pat, 8).
age_once(tom, 5).

once_inside_findall_template(L) :-
    findall(X, once(age_once(X, _)), L),
    ground(L), L = [peter].
