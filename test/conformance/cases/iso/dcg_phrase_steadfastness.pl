% phrase/3 is steadfast in its third argument.
%% ?- steadfast(X0).

steadfast(bound_before) :-
    Rest = [b],
    phrase([a], [a, b], Rest).
steadfast(bound_after) :-
    phrase([a], [a, b], Rest),
    Rest = [b].
steadfast(selects_matching_alternative) :-
    phrase(([a]; [a, b]), [a, b], [b]).
steadfast(shared_sequence) :-
    phrase([], Sequence, Sequence),
    Sequence = [same].
