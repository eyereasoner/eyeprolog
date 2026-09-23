% Adapted from Scryer Prolog tests-pl/iso-conformity-tests.pl, tests
% 70-72, 99, 158, 237, and 268. See test/conformance/THIRD_PARTY.md.

%% ?- comma_operator_immutable(E1, E2, E3).

comma_operator_immutable(E1, E2, E3) :-
    catch((op(1000,xfy,','), fail), error(E1, _), true),
    catch((op(1001,xfy,','), fail), error(E2, _), true),
    catch((op(0,xfy,','), fail), error(E3, _), true).

%% ?- bar_low_priority_rejected(E).

bar_low_priority_rejected(E) :-
    catch((op(999,xfy,'|'), fail), error(E, _), true).

%% ?- invalid_operator_specifier(E).

invalid_operator_specifier(E) :-
    catch((op(100,yfy,foo), fail), error(E, _), true).

%% ?- curly_braces_operator_rejected(E).

curly_braces_operator_rejected(E) :-
    catch((op(500,xfy,'{}'), fail), error(E, _), true).

%% ?- infix_postfix_clash_rejected(E).

infix_postfix_clash_rejected(E) :-
    catch((op(699,xf,>), fail), error(E, _), true).
