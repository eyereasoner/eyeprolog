% From The Art of EyeProlog, Chapter 20 — Name invariants with helpers.
within_thermal_limits(Battery) :-
  temperature(Battery, T),
  temperature_limit(Max),
  (T =< Max).
