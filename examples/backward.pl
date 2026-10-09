% Backward-rule example.
% The interestingness rule is an ordinary Horn rule.  The example is intentionally
% tiny: it demonstrates that a derived fact can be justified by a numeric
% comparison in the rule body.

%% ?- isIndeedMoreInterestingThan(X0, X1).


moreInterestingThan(X, Y) :- (X > Y).

isIndeedMoreInterestingThan(5, 3) :- moreInterestingThan(5, 3).
