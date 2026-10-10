% From The Art of EyeProlog, Chapter 33.
within_limit(Device) :-
  reading(Device, Value),
  maximum(Max),
  (Value =< Max).

status(Device, safe) :-
  within_limit(Device).
