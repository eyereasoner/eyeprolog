:- use_module(library(clpz)).

% Declarative integer constraints replace mode-sensitive is/2 arithmetic.
% Each recursive step relates the predecessor and product; the constraint
% kernel propagates the single unknown value without an explicit labeling step.

%% ?- factorial(6, X0).

factorial(0, 1).
factorial(N, F) :-
  N #> 0,
  Previous #= N - 1,
  factorial(Previous, PreviousFactorial),
  F #= N * PreviousFactorial.
