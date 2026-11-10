% Derived backward rule example.
%
% The generated backward rule is represented as quoted formula data in
% implied_by/2, then mirrored as an ordinary eyeprolog rule so the generated
% childOf relation can feed the ordinary hasParent rule.

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% ?- implied_by(X0, X1).

%% ?- childOf(X0, X1).

%% ?- hasParent(X0, X1).


% Program structure: facts set up the scenario, and rules derive the queried conclusions.
invOf(parentOf, childOf).
parentOf(alice, bob).

% Derivation rules: each rule below contributes one logical step toward the displayed results.
implied_by(childOf(var(x), var(y)), parentOf(var(y), var(x))) :-
  invOf(parentOf, childOf).

childOf(X, Y) :-
  implied_by(childOf(var(x), var(y)), parentOf(var(y), var(x))),
  parentOf(Y, X).

hasParent(X, Y) :- childOf(X, Y).
