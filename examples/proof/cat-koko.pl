% Prolog result format 4
query(1, type(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 2).
answer(1, ['X0' = sk_0, 'X1' = cat]).
why(1, ['X0' = sk_0, 'X1' = cat], [type(sk_0, cat)]).
answer(1, ['X0' = sk_1, 'X1' = british_short_hair]).
why(1, ['X0' = sk_1, 'X1' = british_short_hair], [type(sk_1, british_short_hair)]).
query(2, holds_result(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = test, 'X1' = true]).
why(2, ['X0' = test, 'X1' = true], [holds_result(test, true)]).

clause(1, animal(koko), true).
clause(2, witness(cat, sk_0), true).
clause(3, witness(british_short_hair, sk_1), true).
clause(4, type(var('X'), cat), (animal(koko), witness(cat, var('X')))).
clause(5,
       type(var('X'), british_short_hair),
       (animal(koko), witness(british_short_hair, var('X')))).
clause(6,
       holds_result(test, true),
       (type(var('X'), cat), type(var('Y'), british_short_hair), var('X') \= var('Y'))).

step(type(sk_0, cat), rule(4), ['X' = sk_0], [animal(koko), witness(cat, sk_0)]).
step(animal(koko), fact(1), [], []).
step(witness(cat, sk_0), fact(2), [], []).
step(type(sk_1, british_short_hair),
     rule(5),
     ['X' = sk_1],
     [animal(koko), witness(british_short_hair, sk_1)]).
step(witness(british_short_hair, sk_1), fact(3), [], []).
step(holds_result(test, true),
     rule(6),
     ['X' = sk_0, 'Y' = sk_1],
     [type(sk_0, cat), type(sk_1, british_short_hair), sk_0 \= sk_1]).
step(sk_0 \= sk_1, builtin, [], []).
