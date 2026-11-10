implication(type(var(y), dog), holds_result(test, true)).
holds_result(test, true).

clause(1, type(minka, cat), true).
clause(2, type(charly, dog), true).
clause(3, implication(type(var(y), dog), holds_result(test, true)), type(anonymous(1), cat)).
clause(4,
       holds_result(test, true),
       (implication(type(var(y), dog), holds_result(test, true)), type(anonymous(1), dog))).

step(implication(type(var(y), dog), holds_result(test, true)), rule(3), [], [type(minka, cat)]).
step(type(minka, cat), fact(1), [], []).
step(holds_result(test, true),
     rule(4),
     [],
     [implication(type(var(y), dog), holds_result(test, true)), type(charly, dog)]).
step(type(charly, dog), fact(2), [], []).
