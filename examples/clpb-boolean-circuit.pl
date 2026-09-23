:- use_module(library(clpb)).

% A small XOR circuit uses NOT, AND, and OR. The first goal enumerates the
% complete truth table; the second uses universally quantified Boolean atoms
% and taut/2 to verify equivalence to the XOR (#) specification.

%% ?- xor_row(X0).
%% ?- xor_circuit_verified(X0).

xor_circuit(X, Y, Z) :-
  sat(Z =:= ((X * ~Y) + (~X * Y))).

xor_row(row(X, Y, Z)) :-
  xor_circuit(X, Y, Z),
  labeling([X, Y, Z]).

xor_circuit_verified(T) :-
  taut((x#y) =:= ((x * ~y) + (~x * y)), T).
