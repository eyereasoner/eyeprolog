% Corrigendum 2: retractall/1 preserves the known dynamic procedure.
%% ?- corrigenda_retractall(ok).

:- dynamic(insect/1).
insect(ant).
insect(bee).

corrigenda_retractall(ok) :-
    retractall(insect(bee)),
    \+ insect(bee),
    insect(ant),
    retractall(insect(_)),
    \+ insect(_),
    current_predicate(insect/1).
