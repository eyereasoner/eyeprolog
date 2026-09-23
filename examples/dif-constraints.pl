% Delayed disequality constraints with dif/2.
%
% Unlike \=/2, dif/2 records a constraint when its arguments are still
% unifiable and rechecks that constraint after later bindings.

%% ?- allowed_pair(X, Y).
%% ?- specialization(X, Y).

allowed_pair(X, Y) :-
    dif(X, Y),
    X = left,
    Y = right.

% X=Y already proves X-Y and 1-2 different: X-X cannot unify with 1-2,
% so the dif/2 constraint is discharged before the final specialization Y=1.
specialization(X, Y) :-
    dif(X-Y, 1-2),
    X = Y,
    Y = 1.
