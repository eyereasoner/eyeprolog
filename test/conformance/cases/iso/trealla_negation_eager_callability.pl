% Adapted from Trealla Prolog tests/issues/test1110.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: negation_eager_callability(X0, X1, X2, X3)

negation_eager_callability(DisjSecond, DisjFirst, Conj, Ordinary) :-
    catch((\+ (true ; 1), fail), error(DisjSecond, _), true),
    catch((\+ (1 ; true), fail), error(DisjFirst, _), true),
    catch((\+ (fail, 1), fail), error(Conj, _), true),
    ( \+ fail, \+ \+ true, \+ member(z, [a, b, c]) -> Ordinary = ok ; Ordinary = bad ).
