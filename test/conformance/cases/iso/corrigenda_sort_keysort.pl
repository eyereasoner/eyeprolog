% Corrigendum 2: sort/2 removes identical duplicates; keysort/2 is stable.
%% ?- corrigenda_sort_keysort(ok).

corrigenda_sort_keysort(ok) :-
    sort([1+Y, z, a, V, 1, 2, V, 1, 7.0, 8.0, 1+Y, 1+2, 8.0, -a, -X, a], Sorted),
    Sorted = [V, 7.0, 8.0, 1, 2, a, z, -X, -a, 1+Y, 1+2],
    keysort([2-99, 1-a, 3-f(_), 1-z, 1-a, 2-44], KeySorted),
    KeySorted = [1-a, 1-z, 1-a, 2-99, 2-44, 3-f(_)],
    sort([U, 1], [1, 1]),
    U = 1.
