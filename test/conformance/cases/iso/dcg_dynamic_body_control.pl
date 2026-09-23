% phrase/2 expands dynamically constructed grammar bodies using static semantics.
%% ?- dynamic_body(X0, X1).

dynamic_body(sequence, Tokens) :-
    Body = ([a], [b]),
    phrase(Body, Tokens).
dynamic_body(choice, Tokens) :-
    Body = ([a]; [b]),
    phrase(Body, Tokens).
dynamic_body(embedded, Tokens) :-
    Body = ({true}, [ok]),
    phrase(Body, Tokens).
dynamic_body(conditional, Tokens) :-
    Body = ([x] -> [yes]; [no]),
    phrase(Body, Tokens).
