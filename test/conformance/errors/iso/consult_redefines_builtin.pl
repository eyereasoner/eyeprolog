% ISO 7.4.3: a clause of a clause-term in a Prolog text must satisfy the same
% constraints as a successful assertz/1, waiving only the static-procedure
% error, and the predicate indicator of its head must not be that of a built-in
% predicate or a control construct. Consulting a definition of clause/2 is
% therefore a permission error, exactly as asserta/1 already reported.
% https://github.com/eyereasoner/eyeprolog/issues/97
%% goal: answer

clause(elk(1), 2).

answer.
