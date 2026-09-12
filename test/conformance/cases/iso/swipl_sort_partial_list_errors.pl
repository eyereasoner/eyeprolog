% Adapted from SWI-Prolog tests/core_lang/test_sort.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: sort_partial_list_errors(X0, X1)

sort_partial_list_errors(Open, Improper) :-
    catch(sort([a, b, a | _], _), error(Open, _), true),
    L = [a, b | a],
    catch(sort(L, _), error(Improper, _), true).
