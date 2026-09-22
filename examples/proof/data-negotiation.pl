% Prolog result format 4
query(1, negotiate(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = agent1, 'X1' = [agent2, data4]]).
why(1, ['X0' = agent1, 'X1' = [agent2, data4]], [negotiate(agent1, [agent2, data4])]).

clause(1, hasData(agent1, [data1, data2, data3]), true).
clause(2, hasData(agent2, [data4, data5, data6]), true).
clause(3, want_negotiate(agent1, [agent2, data4]), true).
clause(6, policy(agent1, [request, var('Data')]), member(var('Data'), [data4, data6])).
clause(7, policy(agent2, [accept, var('Data')]), var('Data') \= data5).
clause(8,
       request_data(var('Agenta'), var('Agentb'), var('Data')),
       (hasData(var('Agenta'), var('Datalista')),
        hasData(var('Agentb'), var('Datalistb')),
        member(var('Data'), var('Datalistb')),
        \+ member(var('Data'), var('Datalista')),
        policy(var('Agenta'), [request, var('Data')]))).
clause(9,
       accept_request(var('Agentb'), anonymous(1), var('Data')),
       (hasData(var('Agentb'), var('Datalistb')),
        member(var('Data'), var('Datalistb')),
        policy(var('Agentb'), [accept, var('Data')]))).
clause(10,
       negotiate(var('Agenta'), [var('Agentb'), var('Data')]),
       (want_negotiate(var('Agenta'), [var('Agentb'), var('Data')]),
        request_data(var('Agenta'), var('Agentb'), var('Data')),
        accept_request(var('Agentb'), var('Agenta'), var('Data')))).

step(negotiate(agent1, [agent2, data4]),
     rule(10),
     ['Agenta' = agent1, 'Agentb' = agent2, 'Data' = data4],
     [want_negotiate(agent1, [agent2, data4]),
      request_data(agent1, agent2, data4),
      accept_request(agent2, agent1, data4)]).
step(want_negotiate(agent1, [agent2, data4]), fact(3), [], []).
step(request_data(agent1, agent2, data4),
     rule(8),
     ['Agenta' = agent1,
      'Agentb' = agent2,
      'Data' = data4,
      'Datalista' = [data1, data2, data3],
      'Datalistb' = [data4, data5, data6]],
     [hasData(agent1, [data1, data2, data3]),
      hasData(agent2, [data4, data5, data6]),
      member(data4, [data4, data5, data6]),
      \+ member(data4, [data1, data2, data3]),
      policy(agent1, [request, data4])]).
step(hasData(agent1, [data1, data2, data3]), fact(1), [], []).
step(hasData(agent2, [data4, data5, data6]), fact(2), [], []).
step(member(data4, [data4, data5, data6]), builtin, [], []).
step(\+ member(data4, [data1, data2, data3]), absent, [], []).
step(policy(agent1, [request, data4]),
     rule(6),
     ['Data' = data4],
     [member(data4, [data4, data6])]).
step(member(data4, [data4, data6]), builtin, [], []).
step(accept_request(agent2, agent1, data4),
     rule(9),
     ['Agentb' = agent2, 'Data' = data4, 'Datalistb' = [data4, data5, data6]],
     [hasData(agent2, [data4, data5, data6]),
      member(data4, [data4, data5, data6]),
      policy(agent2, [accept, data4])]).
step(policy(agent2, [accept, data4]), rule(7), ['Data' = data4], [data4 \= data5]).
step(data4 \= data5, builtin, [], []).
