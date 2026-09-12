% Adapted from SWI-Prolog tests/core_lang/test_sort.pl (keysort tests a, b, c;
% the pair-type case (d) is already covered by corrigenda_keysort_pair_type.pl).
% See test/conformance/THIRD_PARTY.md.
%% goal: keysort_remaining_errors(X0, X1, X2)

keysort_remaining_errors(Open, Improper, ElementOpen) :-
    catch(keysort([a-b, b-b, a-b | _], _), error(Open, _), true),
    L = [a-b, b-b | a],
    catch(keysort(L, _), error(Improper, _), true),
    catch(keysort([a-b, _], _), error(ElementOpen, _), true).
