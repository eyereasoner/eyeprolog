% STC #42: float evaluable functors such as sin/1 accept integer expressions
% through the specified integer-to-float conversion.
% https://www.complang.tuwien.ac.at/ulrich/iso-prolog/stc#42
%% ?- integer_to_float_evaluable.

integer_to_float_evaluable :-
  X is sin(1),
  float(X).
