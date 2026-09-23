% Issue #54 input-underflow review. EyeProlog's finite-double profile permits
% input underflow to round to zero. This is distinct from STC #75, which asks
% whether the published power-underflow errors should depend on the 9.1.4.2
% resultF choice.
% https://github.com/eyereasoner/eyeprolog/issues/54
%% ?- float_underflow_input.

float_underflow_input :-
  number_chars(Positive, "1.0e-99999"),
  Positive =:= 0.0,
  number_chars(Negative, "-1.0e-99999"),
  Negative =:= 0.0.
