negotiate(agent1, [agent2, data4]).
why(
  negotiate(agent1, [agent2, data4]),
  step(
    negotiate(agent1, [agent2, data4]),
    rule("data-negotiation.pl", clause(10)),
    ['Agenta' = agent1, 'Agentb' = agent2, 'Data' = data4],
    [
      step(want_negotiate(agent1, [agent2, data4]), fact("data-negotiation.pl", clause(3)), [], []),
      step(
        request_data(agent1, agent2, data4),
        rule("data-negotiation.pl", clause(8)),
        ['Agenta' = agent1, 'Agentb' = agent2, 'Data' = data4, 'Datalista' = [data1, data2, data3], 'Datalistb' = [data4, data5, data6]],
        [
          step(hasData(agent1, [data1, data2, data3]), fact("data-negotiation.pl", clause(1)), [], []),
          step(hasData(agent2, [data4, data5, data6]), fact("data-negotiation.pl", clause(2)), [], []),
          step(member(data4, [data4, data5, data6]), library(member, 2), [], []),
          step('\\+'(member(data4, [data1, data2, data3])), builtin('\\+', 1), [], []),
          step(
            policy(agent1, [request, data4]),
            rule("data-negotiation.pl", clause(6)),
            ['Data' = data4],
            [
              step(member(data4, [data4, data6]), library(member, 2), [], [])
            ]
          )
        ]
      ),
      step(
        accept_request(agent2, agent1, data4),
        rule("data-negotiation.pl", clause(9)),
        ['Agentb' = agent2, '_agenta' = agent1, 'Data' = data4, 'Datalistb' = [data4, data5, data6]],
        [
          step(hasData(agent2, [data4, data5, data6]), fact("data-negotiation.pl", clause(2)), [], []),
          step(member(data4, [data4, data5, data6]), library(member, 2), [], []),
          step(
            policy(agent2, [accept, data4]),
            rule("data-negotiation.pl", clause(7)),
            ['Data' = data4],
            [
              step(\=(data4, data5), builtin(\=, 2), [], [])
            ]
          )
        ]
      )
    ]
  )
).

