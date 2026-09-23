% Corrigendum 3: variable_names/1 accepts A=T pairs and uses the leftmost match.
%% ?- corrigendum3_write_variable_names.

corrigendum3_write_variable_names :-
    write_term(pair(X, Y), [
        variable_names(['First'=X, 'Ignored'=X, 'Ground'=a, 'Second'=Y])
    ]),
    nl.
