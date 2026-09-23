% STC #50: mixed arithmetic comparisons must not become incorrect by rounding
% an integer through the float representation before comparing it.
% https://www.complang.tuwien.ac.at/ulrich/iso-prolog/stc#50
%% ?- mixed_integer_float_comparison.

mixed_integer_float_comparison :-
  9007199254740993 > 9007199254740992.0,
  9007199254740992.0 < 9007199254740993,
  9007199254740993 =\= 9007199254740992.0,
  -9007199254740993 < -9007199254740992.0,
  Max is max(9007199254740993, 9007199254740992.0),
  integer(Max),
  Max =:= 9007199254740993,
  Min is min(9007199254740993, 9007199254740992.0),
  float(Min),
  Min =:= 9007199254740992.0.
