% Good cobbler.
%
% The result is a quoted assertion saying that joe is a good Cobbler,
% represented as an eyeprolog term.

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% ?- holds_result(X0, X1).


% The asserted fact is kept separate from the output form so the rule can show
% how a quoted assertion maps to an ordinary eyeprolog term.
assertedIs(joe, good(cobbler)).

% The single rule is intentionally simple: it preserves the subject and
% profession while wrapping the conclusion as holds_result(X, good(Y)).
holds_result(test, holds_result(X, good(Y))) :-
  assertedIs(X, good(Y)).
