% Prolog result format 4
query(1, sameClassBecauseOfSharedMember(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(1, complete, 18).
answer(1, ['X0' = a, 'X1' = b, 'X2' = a]).
why(1, ['X0' = a, 'X1' = b, 'X2' = a], [sameClassBecauseOfSharedMember(a, b, a)]).
answer(1, ['X0' = a, 'X1' = c, 'X2' = a]).
why(1, ['X0' = a, 'X1' = c, 'X2' = a], [sameClassBecauseOfSharedMember(a, c, a)]).
answer(1, ['X0' = b, 'X1' = a, 'X2' = a]).
why(1, ['X0' = b, 'X1' = a, 'X2' = a], [sameClassBecauseOfSharedMember(b, a, a)]).
answer(1, ['X0' = b, 'X1' = c, 'X2' = a]).
why(1, ['X0' = b, 'X1' = c, 'X2' = a], [sameClassBecauseOfSharedMember(b, c, a)]).
answer(1, ['X0' = c, 'X1' = a, 'X2' = a]).
why(1, ['X0' = c, 'X1' = a, 'X2' = a], [sameClassBecauseOfSharedMember(c, a, a)]).
answer(1, ['X0' = c, 'X1' = b, 'X2' = a]).
why(1, ['X0' = c, 'X1' = b, 'X2' = a], [sameClassBecauseOfSharedMember(c, b, a)]).
answer(1, ['X0' = a, 'X1' = b, 'X2' = b]).
why(1, ['X0' = a, 'X1' = b, 'X2' = b], [sameClassBecauseOfSharedMember(a, b, b)]).
answer(1, ['X0' = a, 'X1' = c, 'X2' = b]).
why(1, ['X0' = a, 'X1' = c, 'X2' = b], [sameClassBecauseOfSharedMember(a, c, b)]).
answer(1, ['X0' = b, 'X1' = a, 'X2' = b]).
why(1, ['X0' = b, 'X1' = a, 'X2' = b], [sameClassBecauseOfSharedMember(b, a, b)]).
answer(1, ['X0' = b, 'X1' = c, 'X2' = b]).
why(1, ['X0' = b, 'X1' = c, 'X2' = b], [sameClassBecauseOfSharedMember(b, c, b)]).
answer(1, ['X0' = c, 'X1' = a, 'X2' = b]).
why(1, ['X0' = c, 'X1' = a, 'X2' = b], [sameClassBecauseOfSharedMember(c, a, b)]).
answer(1, ['X0' = c, 'X1' = b, 'X2' = b]).
why(1, ['X0' = c, 'X1' = b, 'X2' = b], [sameClassBecauseOfSharedMember(c, b, b)]).
answer(1, ['X0' = a, 'X1' = b, 'X2' = c]).
why(1, ['X0' = a, 'X1' = b, 'X2' = c], [sameClassBecauseOfSharedMember(a, b, c)]).
answer(1, ['X0' = a, 'X1' = c, 'X2' = c]).
why(1, ['X0' = a, 'X1' = c, 'X2' = c], [sameClassBecauseOfSharedMember(a, c, c)]).
answer(1, ['X0' = b, 'X1' = a, 'X2' = c]).
why(1, ['X0' = b, 'X1' = a, 'X2' = c], [sameClassBecauseOfSharedMember(b, a, c)]).
answer(1, ['X0' = b, 'X1' = c, 'X2' = c]).
why(1, ['X0' = b, 'X1' = c, 'X2' = c], [sameClassBecauseOfSharedMember(b, c, c)]).
answer(1, ['X0' = c, 'X1' = a, 'X2' = c]).
why(1, ['X0' = c, 'X1' = a, 'X2' = c], [sameClassBecauseOfSharedMember(c, a, c)]).
answer(1, ['X0' = c, 'X1' = b, 'X2' = c]).
why(1, ['X0' = c, 'X1' = b, 'X2' = c], [sameClassBecauseOfSharedMember(c, b, c)]).

clause(1, classMember(class_abc, a), true).
clause(2, classMember(class_abc, b), true).
clause(3, classMember(class_abc, c), true).
clause(4,
       inClassOf(var('U'), var('X')),
       (classMember(var('Class'), var('U')), classMember(var('Class'), var('X')))).
clause(5,
       sameClass(var('X'), var('Y')),
       (classMember(var('Class'), var('X')), classMember(var('Class'), var('Y')))).
clause(6,
       sameClassBecauseOfSharedMember(var('X'), var('Y'), var('Z')),
       (inClassOf(var('Z'), var('X')),
        inClassOf(var('Z'), var('Y')),
        sameClass(var('X'), var('Y')),
        var('X') \= var('Y'))).

step(sameClassBecauseOfSharedMember(a, b, a),
     rule(6),
     ['X' = a, 'Y' = b, 'Z' = a],
     [inClassOf(a, a), inClassOf(a, b), sameClass(a, b), a \= b]).
step(inClassOf(a, a),
     rule(4),
     ['U' = a, 'X' = a, 'Class' = class_abc],
     [classMember(class_abc, a), classMember(class_abc, a)]).
step(classMember(class_abc, a), fact(1), [], []).
step(inClassOf(a, b),
     rule(4),
     ['U' = a, 'X' = b, 'Class' = class_abc],
     [classMember(class_abc, a), classMember(class_abc, b)]).
step(classMember(class_abc, b), fact(2), [], []).
step(sameClass(a, b),
     rule(5),
     ['X' = a, 'Y' = b, 'Class' = class_abc],
     [classMember(class_abc, a), classMember(class_abc, b)]).
step(a \= b, builtin, [], []).
step(sameClassBecauseOfSharedMember(a, c, a),
     rule(6),
     ['X' = a, 'Y' = c, 'Z' = a],
     [inClassOf(a, a), inClassOf(a, c), sameClass(a, c), a \= c]).
step(inClassOf(a, c),
     rule(4),
     ['U' = a, 'X' = c, 'Class' = class_abc],
     [classMember(class_abc, a), classMember(class_abc, c)]).
step(classMember(class_abc, c), fact(3), [], []).
step(sameClass(a, c),
     rule(5),
     ['X' = a, 'Y' = c, 'Class' = class_abc],
     [classMember(class_abc, a), classMember(class_abc, c)]).
step(a \= c, builtin, [], []).
step(sameClassBecauseOfSharedMember(b, a, a),
     rule(6),
     ['X' = b, 'Y' = a, 'Z' = a],
     [inClassOf(a, b), inClassOf(a, a), sameClass(b, a), b \= a]).
step(sameClass(b, a),
     rule(5),
     ['X' = b, 'Y' = a, 'Class' = class_abc],
     [classMember(class_abc, b), classMember(class_abc, a)]).
step(b \= a, builtin, [], []).
step(sameClassBecauseOfSharedMember(b, c, a),
     rule(6),
     ['X' = b, 'Y' = c, 'Z' = a],
     [inClassOf(a, b), inClassOf(a, c), sameClass(b, c), b \= c]).
step(sameClass(b, c),
     rule(5),
     ['X' = b, 'Y' = c, 'Class' = class_abc],
     [classMember(class_abc, b), classMember(class_abc, c)]).
step(b \= c, builtin, [], []).
step(sameClassBecauseOfSharedMember(c, a, a),
     rule(6),
     ['X' = c, 'Y' = a, 'Z' = a],
     [inClassOf(a, c), inClassOf(a, a), sameClass(c, a), c \= a]).
step(sameClass(c, a),
     rule(5),
     ['X' = c, 'Y' = a, 'Class' = class_abc],
     [classMember(class_abc, c), classMember(class_abc, a)]).
step(c \= a, builtin, [], []).
step(sameClassBecauseOfSharedMember(c, b, a),
     rule(6),
     ['X' = c, 'Y' = b, 'Z' = a],
     [inClassOf(a, c), inClassOf(a, b), sameClass(c, b), c \= b]).
step(sameClass(c, b),
     rule(5),
     ['X' = c, 'Y' = b, 'Class' = class_abc],
     [classMember(class_abc, c), classMember(class_abc, b)]).
step(c \= b, builtin, [], []).
step(sameClassBecauseOfSharedMember(a, b, b),
     rule(6),
     ['X' = a, 'Y' = b, 'Z' = b],
     [inClassOf(b, a), inClassOf(b, b), sameClass(a, b), a \= b]).
step(inClassOf(b, a),
     rule(4),
     ['U' = b, 'X' = a, 'Class' = class_abc],
     [classMember(class_abc, b), classMember(class_abc, a)]).
step(inClassOf(b, b),
     rule(4),
     ['U' = b, 'X' = b, 'Class' = class_abc],
     [classMember(class_abc, b), classMember(class_abc, b)]).
step(sameClassBecauseOfSharedMember(a, c, b),
     rule(6),
     ['X' = a, 'Y' = c, 'Z' = b],
     [inClassOf(b, a), inClassOf(b, c), sameClass(a, c), a \= c]).
step(inClassOf(b, c),
     rule(4),
     ['U' = b, 'X' = c, 'Class' = class_abc],
     [classMember(class_abc, b), classMember(class_abc, c)]).
step(sameClassBecauseOfSharedMember(b, a, b),
     rule(6),
     ['X' = b, 'Y' = a, 'Z' = b],
     [inClassOf(b, b), inClassOf(b, a), sameClass(b, a), b \= a]).
step(sameClassBecauseOfSharedMember(b, c, b),
     rule(6),
     ['X' = b, 'Y' = c, 'Z' = b],
     [inClassOf(b, b), inClassOf(b, c), sameClass(b, c), b \= c]).
step(sameClassBecauseOfSharedMember(c, a, b),
     rule(6),
     ['X' = c, 'Y' = a, 'Z' = b],
     [inClassOf(b, c), inClassOf(b, a), sameClass(c, a), c \= a]).
step(sameClassBecauseOfSharedMember(c, b, b),
     rule(6),
     ['X' = c, 'Y' = b, 'Z' = b],
     [inClassOf(b, c), inClassOf(b, b), sameClass(c, b), c \= b]).
step(sameClassBecauseOfSharedMember(a, b, c),
     rule(6),
     ['X' = a, 'Y' = b, 'Z' = c],
     [inClassOf(c, a), inClassOf(c, b), sameClass(a, b), a \= b]).
step(inClassOf(c, a),
     rule(4),
     ['U' = c, 'X' = a, 'Class' = class_abc],
     [classMember(class_abc, c), classMember(class_abc, a)]).
step(inClassOf(c, b),
     rule(4),
     ['U' = c, 'X' = b, 'Class' = class_abc],
     [classMember(class_abc, c), classMember(class_abc, b)]).
step(sameClassBecauseOfSharedMember(a, c, c),
     rule(6),
     ['X' = a, 'Y' = c, 'Z' = c],
     [inClassOf(c, a), inClassOf(c, c), sameClass(a, c), a \= c]).
step(inClassOf(c, c),
     rule(4),
     ['U' = c, 'X' = c, 'Class' = class_abc],
     [classMember(class_abc, c), classMember(class_abc, c)]).
step(sameClassBecauseOfSharedMember(b, a, c),
     rule(6),
     ['X' = b, 'Y' = a, 'Z' = c],
     [inClassOf(c, b), inClassOf(c, a), sameClass(b, a), b \= a]).
step(sameClassBecauseOfSharedMember(b, c, c),
     rule(6),
     ['X' = b, 'Y' = c, 'Z' = c],
     [inClassOf(c, b), inClassOf(c, c), sameClass(b, c), b \= c]).
step(sameClassBecauseOfSharedMember(c, a, c),
     rule(6),
     ['X' = c, 'Y' = a, 'Z' = c],
     [inClassOf(c, c), inClassOf(c, a), sameClass(c, a), c \= a]).
step(sameClassBecauseOfSharedMember(c, b, c),
     rule(6),
     ['X' = c, 'Y' = b, 'Z' = c],
     [inClassOf(c, c), inClassOf(c, b), sameClass(c, b), c \= b]).
