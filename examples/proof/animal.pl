type(joe, human).
type(joe, animal).
subclassOf(human, animal).
succeeds(animalExample, true).

clause(1, human(joe), true).
clause(2, animal(human), true).
clause(3, animal(var('X')), human(var('X'))).
clause(4, type(joe, human), human(joe)).
clause(5, type(joe, animal), animal(joe)).
clause(6, subclassOf(human, animal), animal(human)).
clause(7, succeeds(animalExample, true), animal(anonymous(1))).

step(type(joe, human), rule(4), [], [human(joe)]).
step(human(joe), fact(1), [], []).
step(type(joe, animal), rule(5), [], [animal(joe)]).
step(animal(joe), rule(3), ['X' = joe], [human(joe)]).
step(subclassOf(human, animal), rule(6), [], [animal(human)]).
step(animal(human), fact(2), [], []).
step(succeeds(animalExample, true), rule(7), [], [animal(human)]).
