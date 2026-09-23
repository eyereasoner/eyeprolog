% Corrigendum 2: call/2 through call/8 append arguments to a closure.
%% ?- corrigenda_call_closure(A, B, C, D, E, F, G).

seven(a, b, c, d, e, f, g).

corrigenda_call_closure(A, B, C, D, E, F, G) :-
    call(seven, A, B, C, D, E, F, G),
    call(=(A), a),
    call(call(atom_concat, pro), log, prolog).
