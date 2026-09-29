branch(dave, b).
branch(eve, b).
branch(frank, c).
branch(grace, c).
branch(heidi, b).
branch(ivan, b).
branch(judy, c).
generation(bob, 1).
generation(carol, 1).
generation(dave, 2).
generation(eve, 2).
generation(frank, 2).
generation(grace, 2).
generation(heidi, 3).
generation(ivan, 3).
generation(judy, 3).
cousin(dave, frank).
cousin(dave, grace).
cousin(eve, frank).
cousin(eve, grace).
cousin(frank, dave).
cousin(frank, eve).
cousin(grace, dave).
cousin(grace, eve).
cousin(heidi, judy).
cousin(ivan, judy).
cousin(judy, heidi).
cousin(judy, ivan).

clause(2,
       family_graph(familyGraph, (parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c))),
       true).
clause(3,
       context_member((var('Left'), anonymous(1)), var('Member')),
       context_member(var('Left'), var('Member'))).
clause(4,
       context_member((anonymous(1), var('Right')), var('Member')),
       context_member(var('Right'), var('Member'))).
clause(5,
       context_member(var('Member'), var('Member')),
       var('Member') \= (anonymous(1), anonymous(2))).
clause(6,
       family_statement(var('S'), var('P'), var('O')),
       (family_graph(familyGraph, var('Context')),
        context_member(var('Context'), var('Statement')),
        var('Statement') =.. [var('P'), var('S'), var('O')])).
clause(7,
       parent(var('Parent'), var('Child')),
       family_statement(var('Parent'), parent, var('Child'))).
clause(8,
       branch(var('Person'), var('Branch')),
       family_statement(var('Person'), seedBranch, var('Branch'))).
clause(9, different(b, c), true).
clause(10, different(c, b), true).
clause(11, generation(adam, 0), true).
clause(12,
       generation(var('Child'), var('Next')),
       (parent(var('Parent'), var('Child')),
        generation(var('Parent'), var('Gen')),
        var('Next') is var('Gen') + 1)).
clause(13,
       branch(var('Child'), var('Branch')),
       (parent(var('Parent'), var('Child')), branch(var('Parent'), var('Branch')))).
clause(15,
       cousin(var('X'), var('Y')),
       (generation(var('X'), var('Gen')),
        generation(var('Y'), var('Gen')),
        branch(var('X'), var('Bx')),
        branch(var('Y'), var('By')),
        different(var('Bx'), var('By')))).

step(branch(dave, b),
     rule(8),
     ['Person' = dave, 'Branch' = b],
     [family_statement(dave, seedBranch, b)]).
step(family_statement(dave, seedBranch, b),
     rule(6),
     ['S' = dave,
      'P' = seedBranch,
      'O' = b,
      'Context' = (parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Statement' = seedBranch(dave, b)],
     [family_graph(familyGraph, (parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c))),
      context_member((parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(dave, b)),
      seedBranch(dave, b) =.. [seedBranch, dave, b]]).
step(family_graph(familyGraph, (parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c))),
     fact(2),
     [],
     []).
step(context_member((parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(dave, b)),
     rule(4),
     ['Right' = (parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = seedBranch(dave, b)],
     [context_member((parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(dave, b))]).
step(context_member((parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(dave, b)),
     rule(4),
     ['Right' = (parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = seedBranch(dave, b)],
     [context_member((parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(dave, b))]).
step(context_member((parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(dave, b)),
     rule(4),
     ['Right' = (parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = seedBranch(dave, b)],
     [context_member((parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(dave, b))]).
step(context_member((parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(dave, b)),
     rule(4),
     ['Right' = (parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = seedBranch(dave, b)],
     [context_member((parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(dave, b))]).
step(context_member((parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(dave, b)),
     rule(4),
     ['Right' = (parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = seedBranch(dave, b)],
     [context_member((parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(dave, b))]).
step(context_member((parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(dave, b)),
     rule(4),
     ['Right' = (parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = seedBranch(dave, b)],
     [context_member((parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(dave, b))]).
step(context_member((parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(dave, b)),
     rule(4),
     ['Right' = (parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = seedBranch(dave, b)],
     [context_member((parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(dave, b))]).
step(context_member((parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(dave, b)),
     rule(4),
     ['Right' = (parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = seedBranch(dave, b)],
     [context_member((parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(dave, b))]).
step(context_member((parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(dave, b)),
     rule(4),
     ['Right' = (seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = seedBranch(dave, b)],
     [context_member((seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(dave, b))]).
step(context_member((seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(dave, b)),
     rule(3),
     ['Left' = seedBranch(dave, b), 'Member' = seedBranch(dave, b)],
     [context_member(seedBranch(dave, b), seedBranch(dave, b))]).
step(context_member(seedBranch(dave, b), seedBranch(dave, b)),
     rule(5),
     ['Member' = seedBranch(dave, b)],
     [seedBranch(dave, b) \= (_left, _right)]).
step(seedBranch(dave, b) \= (_left, _right), builtin, [], []).
step(seedBranch(dave, b) =.. [seedBranch, dave, b], builtin, [], []).
step(branch(eve, b),
     rule(8),
     ['Person' = eve, 'Branch' = b],
     [family_statement(eve, seedBranch, b)]).
step(family_statement(eve, seedBranch, b),
     rule(6),
     ['S' = eve,
      'P' = seedBranch,
      'O' = b,
      'Context' = (parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Statement' = seedBranch(eve, b)],
     [family_graph(familyGraph, (parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c))),
      context_member((parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(eve, b)),
      seedBranch(eve, b) =.. [seedBranch, eve, b]]).
step(context_member((parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(eve, b)),
     rule(4),
     ['Right' = (parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = seedBranch(eve, b)],
     [context_member((parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(eve, b))]).
step(context_member((parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(eve, b)),
     rule(4),
     ['Right' = (parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = seedBranch(eve, b)],
     [context_member((parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(eve, b))]).
step(context_member((parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(eve, b)),
     rule(4),
     ['Right' = (parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = seedBranch(eve, b)],
     [context_member((parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(eve, b))]).
step(context_member((parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(eve, b)),
     rule(4),
     ['Right' = (parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = seedBranch(eve, b)],
     [context_member((parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(eve, b))]).
step(context_member((parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(eve, b)),
     rule(4),
     ['Right' = (parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = seedBranch(eve, b)],
     [context_member((parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(eve, b))]).
step(context_member((parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(eve, b)),
     rule(4),
     ['Right' = (parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = seedBranch(eve, b)],
     [context_member((parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(eve, b))]).
step(context_member((parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(eve, b)),
     rule(4),
     ['Right' = (parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = seedBranch(eve, b)],
     [context_member((parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(eve, b))]).
step(context_member((parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(eve, b)),
     rule(4),
     ['Right' = (parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = seedBranch(eve, b)],
     [context_member((parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(eve, b))]).
step(context_member((parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(eve, b)),
     rule(4),
     ['Right' = (seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = seedBranch(eve, b)],
     [context_member((seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(eve, b))]).
step(context_member((seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(eve, b)),
     rule(4),
     ['Right' = (seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = seedBranch(eve, b)],
     [context_member((seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(eve, b))]).
step(context_member((seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(eve, b)),
     rule(3),
     ['Left' = seedBranch(eve, b), 'Member' = seedBranch(eve, b)],
     [context_member(seedBranch(eve, b), seedBranch(eve, b))]).
step(context_member(seedBranch(eve, b), seedBranch(eve, b)),
     rule(5),
     ['Member' = seedBranch(eve, b)],
     [seedBranch(eve, b) \= (_left, _right)]).
step(seedBranch(eve, b) \= (_left, _right), builtin, [], []).
step(seedBranch(eve, b) =.. [seedBranch, eve, b], builtin, [], []).
step(branch(frank, c),
     rule(8),
     ['Person' = frank, 'Branch' = c],
     [family_statement(frank, seedBranch, c)]).
step(family_statement(frank, seedBranch, c),
     rule(6),
     ['S' = frank,
      'P' = seedBranch,
      'O' = c,
      'Context' = (parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Statement' = seedBranch(frank, c)],
     [family_graph(familyGraph, (parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c))),
      context_member((parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(frank, c)),
      seedBranch(frank, c) =.. [seedBranch, frank, c]]).
step(context_member((parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(frank, c)),
     rule(4),
     ['Right' = (parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = seedBranch(frank, c)],
     [context_member((parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(frank, c))]).
step(context_member((parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(frank, c)),
     rule(4),
     ['Right' = (parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = seedBranch(frank, c)],
     [context_member((parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(frank, c))]).
step(context_member((parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(frank, c)),
     rule(4),
     ['Right' = (parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = seedBranch(frank, c)],
     [context_member((parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(frank, c))]).
step(context_member((parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(frank, c)),
     rule(4),
     ['Right' = (parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = seedBranch(frank, c)],
     [context_member((parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(frank, c))]).
step(context_member((parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(frank, c)),
     rule(4),
     ['Right' = (parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = seedBranch(frank, c)],
     [context_member((parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(frank, c))]).
step(context_member((parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(frank, c)),
     rule(4),
     ['Right' = (parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = seedBranch(frank, c)],
     [context_member((parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(frank, c))]).
step(context_member((parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(frank, c)),
     rule(4),
     ['Right' = (parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = seedBranch(frank, c)],
     [context_member((parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(frank, c))]).
step(context_member((parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(frank, c)),
     rule(4),
     ['Right' = (parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = seedBranch(frank, c)],
     [context_member((parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(frank, c))]).
step(context_member((parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(frank, c)),
     rule(4),
     ['Right' = (seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = seedBranch(frank, c)],
     [context_member((seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(frank, c))]).
step(context_member((seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(frank, c)),
     rule(4),
     ['Right' = (seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = seedBranch(frank, c)],
     [context_member((seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(frank, c))]).
step(context_member((seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(frank, c)),
     rule(4),
     ['Right' = (seedBranch(frank, c), seedBranch(grace, c)), 'Member' = seedBranch(frank, c)],
     [context_member((seedBranch(frank, c), seedBranch(grace, c)), seedBranch(frank, c))]).
step(context_member((seedBranch(frank, c), seedBranch(grace, c)), seedBranch(frank, c)),
     rule(3),
     ['Left' = seedBranch(frank, c), 'Member' = seedBranch(frank, c)],
     [context_member(seedBranch(frank, c), seedBranch(frank, c))]).
step(context_member(seedBranch(frank, c), seedBranch(frank, c)),
     rule(5),
     ['Member' = seedBranch(frank, c)],
     [seedBranch(frank, c) \= (_left, _right)]).
step(seedBranch(frank, c) \= (_left, _right), builtin, [], []).
step(seedBranch(frank, c) =.. [seedBranch, frank, c], builtin, [], []).
step(branch(grace, c),
     rule(8),
     ['Person' = grace, 'Branch' = c],
     [family_statement(grace, seedBranch, c)]).
step(family_statement(grace, seedBranch, c),
     rule(6),
     ['S' = grace,
      'P' = seedBranch,
      'O' = c,
      'Context' = (parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Statement' = seedBranch(grace, c)],
     [family_graph(familyGraph, (parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c))),
      context_member((parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(grace, c)),
      seedBranch(grace, c) =.. [seedBranch, grace, c]]).
step(context_member((parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(grace, c)),
     rule(4),
     ['Right' = (parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = seedBranch(grace, c)],
     [context_member((parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(grace, c))]).
step(context_member((parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(grace, c)),
     rule(4),
     ['Right' = (parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = seedBranch(grace, c)],
     [context_member((parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(grace, c))]).
step(context_member((parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(grace, c)),
     rule(4),
     ['Right' = (parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = seedBranch(grace, c)],
     [context_member((parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(grace, c))]).
step(context_member((parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(grace, c)),
     rule(4),
     ['Right' = (parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = seedBranch(grace, c)],
     [context_member((parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(grace, c))]).
step(context_member((parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(grace, c)),
     rule(4),
     ['Right' = (parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = seedBranch(grace, c)],
     [context_member((parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(grace, c))]).
step(context_member((parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(grace, c)),
     rule(4),
     ['Right' = (parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = seedBranch(grace, c)],
     [context_member((parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(grace, c))]).
step(context_member((parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(grace, c)),
     rule(4),
     ['Right' = (parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = seedBranch(grace, c)],
     [context_member((parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(grace, c))]).
step(context_member((parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(grace, c)),
     rule(4),
     ['Right' = (parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = seedBranch(grace, c)],
     [context_member((parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(grace, c))]).
step(context_member((parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(grace, c)),
     rule(4),
     ['Right' = (seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = seedBranch(grace, c)],
     [context_member((seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(grace, c))]).
step(context_member((seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(grace, c)),
     rule(4),
     ['Right' = (seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = seedBranch(grace, c)],
     [context_member((seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(grace, c))]).
step(context_member((seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), seedBranch(grace, c)),
     rule(4),
     ['Right' = (seedBranch(frank, c), seedBranch(grace, c)), 'Member' = seedBranch(grace, c)],
     [context_member((seedBranch(frank, c), seedBranch(grace, c)), seedBranch(grace, c))]).
step(context_member((seedBranch(frank, c), seedBranch(grace, c)), seedBranch(grace, c)),
     rule(4),
     ['Right' = seedBranch(grace, c), 'Member' = seedBranch(grace, c)],
     [context_member(seedBranch(grace, c), seedBranch(grace, c))]).
step(context_member(seedBranch(grace, c), seedBranch(grace, c)),
     rule(5),
     ['Member' = seedBranch(grace, c)],
     [seedBranch(grace, c) \= (_left, _right)]).
step(seedBranch(grace, c) \= (_left, _right), builtin, [], []).
step(seedBranch(grace, c) =.. [seedBranch, grace, c], builtin, [], []).
step(branch(heidi, b),
     rule(13),
     ['Child' = heidi, 'Branch' = b, 'Parent' = dave],
     [parent(dave, heidi), branch(dave, b)]).
step(parent(dave, heidi),
     rule(7),
     ['Parent' = dave, 'Child' = heidi],
     [family_statement(dave, parent, heidi)]).
step(family_statement(dave, parent, heidi),
     rule(6),
     ['S' = dave,
      'P' = parent,
      'O' = heidi,
      'Context' = (parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Statement' = parent(dave, heidi)],
     [family_graph(familyGraph, (parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c))),
      context_member((parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(dave, heidi)),
      parent(dave, heidi) =.. [parent, dave, heidi]]).
step(context_member((parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(dave, heidi)),
     rule(4),
     ['Right' = (parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = parent(dave, heidi)],
     [context_member((parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(dave, heidi))]).
step(context_member((parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(dave, heidi)),
     rule(4),
     ['Right' = (parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = parent(dave, heidi)],
     [context_member((parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(dave, heidi))]).
step(context_member((parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(dave, heidi)),
     rule(4),
     ['Right' = (parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = parent(dave, heidi)],
     [context_member((parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(dave, heidi))]).
step(context_member((parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(dave, heidi)),
     rule(4),
     ['Right' = (parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = parent(dave, heidi)],
     [context_member((parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(dave, heidi))]).
step(context_member((parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(dave, heidi)),
     rule(4),
     ['Right' = (parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = parent(dave, heidi)],
     [context_member((parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(dave, heidi))]).
step(context_member((parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(dave, heidi)),
     rule(4),
     ['Right' = (parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = parent(dave, heidi)],
     [context_member((parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(dave, heidi))]).
step(context_member((parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(dave, heidi)),
     rule(3),
     ['Left' = parent(dave, heidi), 'Member' = parent(dave, heidi)],
     [context_member(parent(dave, heidi), parent(dave, heidi))]).
step(context_member(parent(dave, heidi), parent(dave, heidi)),
     rule(5),
     ['Member' = parent(dave, heidi)],
     [parent(dave, heidi) \= (_left, _right)]).
step(parent(dave, heidi) \= (_left, _right), builtin, [], []).
step(parent(dave, heidi) =.. [parent, dave, heidi], builtin, [], []).
step(branch(ivan, b),
     rule(13),
     ['Child' = ivan, 'Branch' = b, 'Parent' = eve],
     [parent(eve, ivan), branch(eve, b)]).
step(parent(eve, ivan),
     rule(7),
     ['Parent' = eve, 'Child' = ivan],
     [family_statement(eve, parent, ivan)]).
step(family_statement(eve, parent, ivan),
     rule(6),
     ['S' = eve,
      'P' = parent,
      'O' = ivan,
      'Context' = (parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Statement' = parent(eve, ivan)],
     [family_graph(familyGraph, (parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c))),
      context_member((parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(eve, ivan)),
      parent(eve, ivan) =.. [parent, eve, ivan]]).
step(context_member((parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(eve, ivan)),
     rule(4),
     ['Right' = (parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = parent(eve, ivan)],
     [context_member((parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(eve, ivan))]).
step(context_member((parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(eve, ivan)),
     rule(4),
     ['Right' = (parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = parent(eve, ivan)],
     [context_member((parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(eve, ivan))]).
step(context_member((parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(eve, ivan)),
     rule(4),
     ['Right' = (parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = parent(eve, ivan)],
     [context_member((parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(eve, ivan))]).
step(context_member((parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(eve, ivan)),
     rule(4),
     ['Right' = (parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = parent(eve, ivan)],
     [context_member((parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(eve, ivan))]).
step(context_member((parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(eve, ivan)),
     rule(4),
     ['Right' = (parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = parent(eve, ivan)],
     [context_member((parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(eve, ivan))]).
step(context_member((parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(eve, ivan)),
     rule(4),
     ['Right' = (parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = parent(eve, ivan)],
     [context_member((parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(eve, ivan))]).
step(context_member((parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(eve, ivan)),
     rule(4),
     ['Right' = (parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = parent(eve, ivan)],
     [context_member((parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(eve, ivan))]).
step(context_member((parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(eve, ivan)),
     rule(3),
     ['Left' = parent(eve, ivan), 'Member' = parent(eve, ivan)],
     [context_member(parent(eve, ivan), parent(eve, ivan))]).
step(context_member(parent(eve, ivan), parent(eve, ivan)),
     rule(5),
     ['Member' = parent(eve, ivan)],
     [parent(eve, ivan) \= (_left, _right)]).
step(parent(eve, ivan) \= (_left, _right), builtin, [], []).
step(parent(eve, ivan) =.. [parent, eve, ivan], builtin, [], []).
step(branch(judy, c),
     rule(13),
     ['Child' = judy, 'Branch' = c, 'Parent' = frank],
     [parent(frank, judy), branch(frank, c)]).
step(parent(frank, judy),
     rule(7),
     ['Parent' = frank, 'Child' = judy],
     [family_statement(frank, parent, judy)]).
step(family_statement(frank, parent, judy),
     rule(6),
     ['S' = frank,
      'P' = parent,
      'O' = judy,
      'Context' = (parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Statement' = parent(frank, judy)],
     [family_graph(familyGraph, (parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c))),
      context_member((parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(frank, judy)),
      parent(frank, judy) =.. [parent, frank, judy]]).
step(context_member((parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(frank, judy)),
     rule(4),
     ['Right' = (parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = parent(frank, judy)],
     [context_member((parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(frank, judy))]).
step(context_member((parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(frank, judy)),
     rule(4),
     ['Right' = (parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = parent(frank, judy)],
     [context_member((parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(frank, judy))]).
step(context_member((parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(frank, judy)),
     rule(4),
     ['Right' = (parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = parent(frank, judy)],
     [context_member((parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(frank, judy))]).
step(context_member((parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(frank, judy)),
     rule(4),
     ['Right' = (parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = parent(frank, judy)],
     [context_member((parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(frank, judy))]).
step(context_member((parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(frank, judy)),
     rule(4),
     ['Right' = (parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = parent(frank, judy)],
     [context_member((parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(frank, judy))]).
step(context_member((parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(frank, judy)),
     rule(4),
     ['Right' = (parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = parent(frank, judy)],
     [context_member((parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(frank, judy))]).
step(context_member((parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(frank, judy)),
     rule(4),
     ['Right' = (parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = parent(frank, judy)],
     [context_member((parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(frank, judy))]).
step(context_member((parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(frank, judy)),
     rule(4),
     ['Right' = (parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = parent(frank, judy)],
     [context_member((parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(frank, judy))]).
step(context_member((parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(frank, judy)),
     rule(3),
     ['Left' = parent(frank, judy), 'Member' = parent(frank, judy)],
     [context_member(parent(frank, judy), parent(frank, judy))]).
step(context_member(parent(frank, judy), parent(frank, judy)),
     rule(5),
     ['Member' = parent(frank, judy)],
     [parent(frank, judy) \= (_left, _right)]).
step(parent(frank, judy) \= (_left, _right), builtin, [], []).
step(parent(frank, judy) =.. [parent, frank, judy], builtin, [], []).
step(generation(bob, 1),
     rule(12),
     ['Child' = bob, 'Next' = 1, 'Parent' = adam, 'Gen' = 0],
     [parent(adam, bob), generation(adam, 0), 1 is 0 + 1]).
step(parent(adam, bob),
     rule(7),
     ['Parent' = adam, 'Child' = bob],
     [family_statement(adam, parent, bob)]).
step(family_statement(adam, parent, bob),
     rule(6),
     ['S' = adam,
      'P' = parent,
      'O' = bob,
      'Context' = (parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Statement' = parent(adam, bob)],
     [family_graph(familyGraph, (parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c))),
      context_member((parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(adam, bob)),
      parent(adam, bob) =.. [parent, adam, bob]]).
step(context_member((parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(adam, bob)),
     rule(3),
     ['Left' = parent(adam, bob), 'Member' = parent(adam, bob)],
     [context_member(parent(adam, bob), parent(adam, bob))]).
step(context_member(parent(adam, bob), parent(adam, bob)),
     rule(5),
     ['Member' = parent(adam, bob)],
     [parent(adam, bob) \= (_left, _right)]).
step(parent(adam, bob) \= (_left, _right), builtin, [], []).
step(parent(adam, bob) =.. [parent, adam, bob], builtin, [], []).
step(generation(adam, 0), fact(11), [], []).
step(1 is 0 + 1, builtin, [], []).
step(generation(carol, 1),
     rule(12),
     ['Child' = carol, 'Next' = 1, 'Parent' = adam, 'Gen' = 0],
     [parent(adam, carol), generation(adam, 0), 1 is 0 + 1]).
step(parent(adam, carol),
     rule(7),
     ['Parent' = adam, 'Child' = carol],
     [family_statement(adam, parent, carol)]).
step(family_statement(adam, parent, carol),
     rule(6),
     ['S' = adam,
      'P' = parent,
      'O' = carol,
      'Context' = (parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Statement' = parent(adam, carol)],
     [family_graph(familyGraph, (parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c))),
      context_member((parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(adam, carol)),
      parent(adam, carol) =.. [parent, adam, carol]]).
step(context_member((parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(adam, carol)),
     rule(4),
     ['Right' = (parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = parent(adam, carol)],
     [context_member((parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(adam, carol))]).
step(context_member((parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(adam, carol)),
     rule(3),
     ['Left' = parent(adam, carol), 'Member' = parent(adam, carol)],
     [context_member(parent(adam, carol), parent(adam, carol))]).
step(context_member(parent(adam, carol), parent(adam, carol)),
     rule(5),
     ['Member' = parent(adam, carol)],
     [parent(adam, carol) \= (_left, _right)]).
step(parent(adam, carol) \= (_left, _right), builtin, [], []).
step(parent(adam, carol) =.. [parent, adam, carol], builtin, [], []).
step(generation(dave, 2),
     rule(12),
     ['Child' = dave, 'Next' = 2, 'Parent' = bob, 'Gen' = 1],
     [parent(bob, dave), generation(bob, 1), 2 is 1 + 1]).
step(parent(bob, dave),
     rule(7),
     ['Parent' = bob, 'Child' = dave],
     [family_statement(bob, parent, dave)]).
step(family_statement(bob, parent, dave),
     rule(6),
     ['S' = bob,
      'P' = parent,
      'O' = dave,
      'Context' = (parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Statement' = parent(bob, dave)],
     [family_graph(familyGraph, (parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c))),
      context_member((parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(bob, dave)),
      parent(bob, dave) =.. [parent, bob, dave]]).
step(context_member((parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(bob, dave)),
     rule(4),
     ['Right' = (parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = parent(bob, dave)],
     [context_member((parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(bob, dave))]).
step(context_member((parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(bob, dave)),
     rule(4),
     ['Right' = (parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = parent(bob, dave)],
     [context_member((parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(bob, dave))]).
step(context_member((parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(bob, dave)),
     rule(3),
     ['Left' = parent(bob, dave), 'Member' = parent(bob, dave)],
     [context_member(parent(bob, dave), parent(bob, dave))]).
step(context_member(parent(bob, dave), parent(bob, dave)),
     rule(5),
     ['Member' = parent(bob, dave)],
     [parent(bob, dave) \= (_left, _right)]).
step(parent(bob, dave) \= (_left, _right), builtin, [], []).
step(parent(bob, dave) =.. [parent, bob, dave], builtin, [], []).
step(2 is 1 + 1, builtin, [], []).
step(generation(eve, 2),
     rule(12),
     ['Child' = eve, 'Next' = 2, 'Parent' = bob, 'Gen' = 1],
     [parent(bob, eve), generation(bob, 1), 2 is 1 + 1]).
step(parent(bob, eve),
     rule(7),
     ['Parent' = bob, 'Child' = eve],
     [family_statement(bob, parent, eve)]).
step(family_statement(bob, parent, eve),
     rule(6),
     ['S' = bob,
      'P' = parent,
      'O' = eve,
      'Context' = (parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Statement' = parent(bob, eve)],
     [family_graph(familyGraph, (parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c))),
      context_member((parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(bob, eve)),
      parent(bob, eve) =.. [parent, bob, eve]]).
step(context_member((parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(bob, eve)),
     rule(4),
     ['Right' = (parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = parent(bob, eve)],
     [context_member((parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(bob, eve))]).
step(context_member((parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(bob, eve)),
     rule(4),
     ['Right' = (parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = parent(bob, eve)],
     [context_member((parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(bob, eve))]).
step(context_member((parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(bob, eve)),
     rule(4),
     ['Right' = (parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = parent(bob, eve)],
     [context_member((parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(bob, eve))]).
step(context_member((parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(bob, eve)),
     rule(3),
     ['Left' = parent(bob, eve), 'Member' = parent(bob, eve)],
     [context_member(parent(bob, eve), parent(bob, eve))]).
step(context_member(parent(bob, eve), parent(bob, eve)),
     rule(5),
     ['Member' = parent(bob, eve)],
     [parent(bob, eve) \= (_left, _right)]).
step(parent(bob, eve) \= (_left, _right), builtin, [], []).
step(parent(bob, eve) =.. [parent, bob, eve], builtin, [], []).
step(generation(frank, 2),
     rule(12),
     ['Child' = frank, 'Next' = 2, 'Parent' = carol, 'Gen' = 1],
     [parent(carol, frank), generation(carol, 1), 2 is 1 + 1]).
step(parent(carol, frank),
     rule(7),
     ['Parent' = carol, 'Child' = frank],
     [family_statement(carol, parent, frank)]).
step(family_statement(carol, parent, frank),
     rule(6),
     ['S' = carol,
      'P' = parent,
      'O' = frank,
      'Context' = (parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Statement' = parent(carol, frank)],
     [family_graph(familyGraph, (parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c))),
      context_member((parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(carol, frank)),
      parent(carol, frank) =.. [parent, carol, frank]]).
step(context_member((parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(carol, frank)),
     rule(4),
     ['Right' = (parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = parent(carol, frank)],
     [context_member((parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(carol, frank))]).
step(context_member((parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(carol, frank)),
     rule(4),
     ['Right' = (parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = parent(carol, frank)],
     [context_member((parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(carol, frank))]).
step(context_member((parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(carol, frank)),
     rule(4),
     ['Right' = (parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = parent(carol, frank)],
     [context_member((parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(carol, frank))]).
step(context_member((parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(carol, frank)),
     rule(4),
     ['Right' = (parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = parent(carol, frank)],
     [context_member((parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(carol, frank))]).
step(context_member((parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(carol, frank)),
     rule(3),
     ['Left' = parent(carol, frank), 'Member' = parent(carol, frank)],
     [context_member(parent(carol, frank), parent(carol, frank))]).
step(context_member(parent(carol, frank), parent(carol, frank)),
     rule(5),
     ['Member' = parent(carol, frank)],
     [parent(carol, frank) \= (_left, _right)]).
step(parent(carol, frank) \= (_left, _right), builtin, [], []).
step(parent(carol, frank) =.. [parent, carol, frank], builtin, [], []).
step(generation(grace, 2),
     rule(12),
     ['Child' = grace, 'Next' = 2, 'Parent' = carol, 'Gen' = 1],
     [parent(carol, grace), generation(carol, 1), 2 is 1 + 1]).
step(parent(carol, grace),
     rule(7),
     ['Parent' = carol, 'Child' = grace],
     [family_statement(carol, parent, grace)]).
step(family_statement(carol, parent, grace),
     rule(6),
     ['S' = carol,
      'P' = parent,
      'O' = grace,
      'Context' = (parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Statement' = parent(carol, grace)],
     [family_graph(familyGraph, (parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c))),
      context_member((parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(carol, grace)),
      parent(carol, grace) =.. [parent, carol, grace]]).
step(context_member((parent(adam, bob), parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(carol, grace)),
     rule(4),
     ['Right' = (parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = parent(carol, grace)],
     [context_member((parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(carol, grace))]).
step(context_member((parent(adam, carol), parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(carol, grace)),
     rule(4),
     ['Right' = (parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = parent(carol, grace)],
     [context_member((parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(carol, grace))]).
step(context_member((parent(bob, dave), parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(carol, grace)),
     rule(4),
     ['Right' = (parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = parent(carol, grace)],
     [context_member((parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(carol, grace))]).
step(context_member((parent(bob, eve), parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(carol, grace)),
     rule(4),
     ['Right' = (parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = parent(carol, grace)],
     [context_member((parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(carol, grace))]).
step(context_member((parent(carol, frank), parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(carol, grace)),
     rule(4),
     ['Right' = (parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)),
      'Member' = parent(carol, grace)],
     [context_member((parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(carol, grace))]).
step(context_member((parent(carol, grace), parent(dave, heidi), parent(eve, ivan), parent(frank, judy), seedBranch(dave, b), seedBranch(eve, b), seedBranch(frank, c), seedBranch(grace, c)), parent(carol, grace)),
     rule(3),
     ['Left' = parent(carol, grace), 'Member' = parent(carol, grace)],
     [context_member(parent(carol, grace), parent(carol, grace))]).
step(context_member(parent(carol, grace), parent(carol, grace)),
     rule(5),
     ['Member' = parent(carol, grace)],
     [parent(carol, grace) \= (_left, _right)]).
step(parent(carol, grace) \= (_left, _right), builtin, [], []).
step(parent(carol, grace) =.. [parent, carol, grace], builtin, [], []).
step(generation(heidi, 3),
     rule(12),
     ['Child' = heidi, 'Next' = 3, 'Parent' = dave, 'Gen' = 2],
     [parent(dave, heidi), generation(dave, 2), 3 is 2 + 1]).
step(3 is 2 + 1, builtin, [], []).
step(generation(ivan, 3),
     rule(12),
     ['Child' = ivan, 'Next' = 3, 'Parent' = eve, 'Gen' = 2],
     [parent(eve, ivan), generation(eve, 2), 3 is 2 + 1]).
step(generation(judy, 3),
     rule(12),
     ['Child' = judy, 'Next' = 3, 'Parent' = frank, 'Gen' = 2],
     [parent(frank, judy), generation(frank, 2), 3 is 2 + 1]).
step(cousin(dave, frank),
     rule(15),
     ['X' = dave, 'Y' = frank, 'Gen' = 2, 'Bx' = b, 'By' = c],
     [generation(dave, 2),
      generation(frank, 2),
      branch(dave, b),
      branch(frank, c),
      different(b, c)]).
step(different(b, c), fact(9), [], []).
step(cousin(dave, grace),
     rule(15),
     ['X' = dave, 'Y' = grace, 'Gen' = 2, 'Bx' = b, 'By' = c],
     [generation(dave, 2),
      generation(grace, 2),
      branch(dave, b),
      branch(grace, c),
      different(b, c)]).
step(cousin(eve, frank),
     rule(15),
     ['X' = eve, 'Y' = frank, 'Gen' = 2, 'Bx' = b, 'By' = c],
     [generation(eve, 2),
      generation(frank, 2),
      branch(eve, b),
      branch(frank, c),
      different(b, c)]).
step(cousin(eve, grace),
     rule(15),
     ['X' = eve, 'Y' = grace, 'Gen' = 2, 'Bx' = b, 'By' = c],
     [generation(eve, 2),
      generation(grace, 2),
      branch(eve, b),
      branch(grace, c),
      different(b, c)]).
step(cousin(frank, dave),
     rule(15),
     ['X' = frank, 'Y' = dave, 'Gen' = 2, 'Bx' = c, 'By' = b],
     [generation(frank, 2),
      generation(dave, 2),
      branch(frank, c),
      branch(dave, b),
      different(c, b)]).
step(different(c, b), fact(10), [], []).
step(cousin(frank, eve),
     rule(15),
     ['X' = frank, 'Y' = eve, 'Gen' = 2, 'Bx' = c, 'By' = b],
     [generation(frank, 2),
      generation(eve, 2),
      branch(frank, c),
      branch(eve, b),
      different(c, b)]).
step(cousin(grace, dave),
     rule(15),
     ['X' = grace, 'Y' = dave, 'Gen' = 2, 'Bx' = c, 'By' = b],
     [generation(grace, 2),
      generation(dave, 2),
      branch(grace, c),
      branch(dave, b),
      different(c, b)]).
step(cousin(grace, eve),
     rule(15),
     ['X' = grace, 'Y' = eve, 'Gen' = 2, 'Bx' = c, 'By' = b],
     [generation(grace, 2),
      generation(eve, 2),
      branch(grace, c),
      branch(eve, b),
      different(c, b)]).
step(cousin(heidi, judy),
     rule(15),
     ['X' = heidi, 'Y' = judy, 'Gen' = 3, 'Bx' = b, 'By' = c],
     [generation(heidi, 3),
      generation(judy, 3),
      branch(heidi, b),
      branch(judy, c),
      different(b, c)]).
step(cousin(ivan, judy),
     rule(15),
     ['X' = ivan, 'Y' = judy, 'Gen' = 3, 'Bx' = b, 'By' = c],
     [generation(ivan, 3),
      generation(judy, 3),
      branch(ivan, b),
      branch(judy, c),
      different(b, c)]).
step(cousin(judy, heidi),
     rule(15),
     ['X' = judy, 'Y' = heidi, 'Gen' = 3, 'Bx' = c, 'By' = b],
     [generation(judy, 3),
      generation(heidi, 3),
      branch(judy, c),
      branch(heidi, b),
      different(c, b)]).
step(cousin(judy, ivan),
     rule(15),
     ['X' = judy, 'Y' = ivan, 'Gen' = 3, 'Bx' = c, 'By' = b],
     [generation(judy, 3),
      generation(ivan, 3),
      branch(judy, c),
      branch(ivan, b),
      different(c, b)]).
