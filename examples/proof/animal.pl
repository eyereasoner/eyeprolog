% Prolog result format 4
query(1, type(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 2).
answer(1, ['X0' = joe, 'X1' = human]).
why(1, ['X0' = joe, 'X1' = human], [type(joe, human)]).
answer(1, ['X0' = joe, 'X1' = animal]).
why(1, ['X0' = joe, 'X1' = animal], [type(joe, animal)]).
query(2, subclassOf(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = human, 'X1' = animal]).
why(2, ['X0' = human, 'X1' = animal], [subclassOf(human, animal)]).
query(3, succeeds(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = animalExample, 'X1' = true]).
why(3, ['X0' = animalExample, 'X1' = true], [succeeds(animalExample, true)]).

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
