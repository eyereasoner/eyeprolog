% ISO 6.3.3.1: an arg may be an atom which is an operator.

%% ?- operator_atoms(Priority, Specifier, List).

operator_atoms(Priority, Specifier, List) :-
    current_op(Priority, Specifier, :-),
    List = [:-,-].

% ISO 6.3.4.4, Table 7: ?- is a predefined 1200 fx operator.

%% ?- query_prefix_operator(ok).

query_prefix_operator(ok) :-
    current_op(1200, fx, ?-).
