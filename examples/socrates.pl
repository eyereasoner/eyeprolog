% Socrates is mortal.
%
% A single rule derives mortality from being a man, and the example emits
% relation facts.

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% ?- type(X0, X1).

%% ?- holds_result(X0, X1).


% Program structure: facts set up the scenario, and rules derive the queried conclusions.
type(socrates, man).

% Derivation rules: each rule below contributes one logical step toward the displayed results.
type(X, mortal) :-
  type(X, man).


holds_result(test, true) :-
  type(socrates, mortal).
