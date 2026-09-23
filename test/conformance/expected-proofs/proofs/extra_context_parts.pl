answer(context_parts, alpha, []).
answer(context_parts, beta, [2]).

clause(1, context_statement(alpha), true).
clause(2, context_statement(beta(2)), true).
clause(3,
       context_parts(var('Name'), var('Args')),
       (context_statement(var('Statement')),
        var('Statement') =.. [var('Name') | var('Args')],
        atom(var('Name')))).
clause(4,
       answer(context_parts, var('Name'), var('Args')),
       context_parts(var('Name'), var('Args'))).

step(answer(context_parts, alpha, []),
     rule(4),
     ['Name' = alpha, 'Args' = []],
     [context_parts(alpha, [])]).
step(context_parts(alpha, []),
     rule(3),
     ['Name' = alpha, 'Args' = [], 'Statement' = alpha],
     [context_statement(alpha), alpha =.. [alpha], atom(alpha)]).
step(context_statement(alpha), fact(1), [], []).
step(alpha =.. [alpha], builtin, [], []).
step(atom(alpha), builtin, [], []).
step(answer(context_parts, beta, [2]),
     rule(4),
     ['Name' = beta, 'Args' = [2]],
     [context_parts(beta, [2])]).
step(context_parts(beta, [2]),
     rule(3),
     ['Name' = beta, 'Args' = [2], 'Statement' = beta(2)],
     [context_statement(beta(2)), beta(2) =.. [beta, 2], atom(beta)]).
step(context_statement(beta(2)), fact(2), [], []).
step(beta(2) =.. [beta, 2], builtin, [], []).
step(atom(beta), builtin, [], []).
