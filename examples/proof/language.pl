path('<urn:example:a>', '<urn:example:b>').
path('<urn:example:b>', '<urn:example:c>').
path('<urn:example:c>', '<urn:example:d>').
path('<urn:example:a>', '<urn:example:c>').
path('<urn:example:a>', '<urn:example:d>').
path('<urn:example:b>', '<urn:example:d>').

clause(2, edge('<urn:example:a>', '<urn:example:b>'), true).
clause(3, edge('<urn:example:b>', '<urn:example:c>'), true).
clause(4, edge('<urn:example:c>', '<urn:example:d>'), true).
clause(5, path(var('X'), var('Y')), edge(var('X'), var('Y'))).
clause(6, path(var('X'), var('Z')), (edge(var('X'), var('Y')), path(var('Y'), var('Z')))).

step(path('<urn:example:a>', '<urn:example:b>'),
     rule(5),
     ['X' = '<urn:example:a>', 'Y' = '<urn:example:b>'],
     [edge('<urn:example:a>', '<urn:example:b>')]).
step(edge('<urn:example:a>', '<urn:example:b>'), fact(2), [], []).
step(path('<urn:example:b>', '<urn:example:c>'),
     rule(5),
     ['X' = '<urn:example:b>', 'Y' = '<urn:example:c>'],
     [edge('<urn:example:b>', '<urn:example:c>')]).
step(edge('<urn:example:b>', '<urn:example:c>'), fact(3), [], []).
step(path('<urn:example:c>', '<urn:example:d>'),
     rule(5),
     ['X' = '<urn:example:c>', 'Y' = '<urn:example:d>'],
     [edge('<urn:example:c>', '<urn:example:d>')]).
step(edge('<urn:example:c>', '<urn:example:d>'), fact(4), [], []).
step(path('<urn:example:a>', '<urn:example:c>'),
     rule(6),
     ['X' = '<urn:example:a>', 'Z' = '<urn:example:c>', 'Y' = '<urn:example:b>'],
     [edge('<urn:example:a>', '<urn:example:b>'), path('<urn:example:b>', '<urn:example:c>')]).
step(path('<urn:example:a>', '<urn:example:d>'),
     rule(6),
     ['X' = '<urn:example:a>', 'Z' = '<urn:example:d>', 'Y' = '<urn:example:b>'],
     [edge('<urn:example:a>', '<urn:example:b>'), path('<urn:example:b>', '<urn:example:d>')]).
step(path('<urn:example:b>', '<urn:example:d>'),
     rule(6),
     ['X' = '<urn:example:b>', 'Z' = '<urn:example:d>', 'Y' = '<urn:example:c>'],
     [edge('<urn:example:b>', '<urn:example:c>'), path('<urn:example:c>', '<urn:example:d>')]).
