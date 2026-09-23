% ISO-style atoms are callable predicates of arity zero.
%% ?- derived_ready.

%% ?- source_ready.


source_ready.
derived_ready :- source_ready.
