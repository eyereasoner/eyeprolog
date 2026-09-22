% From The Art of EyeProlog, Chapter 11.
:- use_module(library(lists)).

why(
  type(socrates, mortal),
  step(
    type(socrates, mortal),
    rule("socrates.pl", clause(4)),
    ['X' = socrates],
    [
      step(type(socrates, man), fact("socrates.pl", clause(3)), [], [])
    ]
  )
).
