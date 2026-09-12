% Adapted from SWI-Prolog tests/core_lang/test_bips.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: length_errors(X0, X1, X2)

length_errors(NegLen, NonIntAtom, NonIntFloat) :-
    catch(length(_, -2), error(NegLen, _), true),
    catch(length(_, a), error(NonIntAtom, _), true),
    catch(length(_, 0.1), error(NonIntFloat, _), true).
