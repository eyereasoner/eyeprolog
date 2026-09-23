% call//1 requires an instantiated callable closure at execution time.
invoke(Goal) --> call(Goal).
%% ?- phrase(invoke(Goal), []).
