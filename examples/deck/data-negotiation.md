# Data negotiation

## Which data requests can both sides agree to?

Two agents each hold three datasets and each has a policy. Agent 1 wants three
datasets from agent 2. A negotiation succeeds only when the asking side lacks
the data, the other side has it, and both policies allow the exchange. Of three
requests, exactly one survives.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=data-negotiation) ·
[Source](../data-negotiation.pl)

---

# The question

Data sharing has two gatekeepers. The requester's own policy decides what it
may ask for, and the provider's policy decides what it may hand over. A request
that one side would refuse is not worth sending, so the reasoner checks both
sides before anyone acts.

---

# The agents

```prolog
hasData(agent1, [data1, data2, data3]).
hasData(agent2, [data4, data5, data6]).

want_negotiate(agent1, [agent2, data4]).
want_negotiate(agent1, [agent2, data5]).
want_negotiate(agent1, [agent2, data7]).

policy(agent1, [request, Data]) :-
  member(Data, [data4, data6]).
policy(agent2, [accept, Data]) :-
  (Data \= data5).
```

Agent 1 may request only `data4` and `data6`. Agent 2 will share anything
except `data5`. Nobody holds `data7`.

---

# The rules

```prolog
request_data(Agenta, Agentb, Data) :-
  hasData(Agenta, Datalista),
  hasData(Agentb, Datalistb),
  member(Data, Datalistb),
  \+ member(Data, Datalista),
  policy(Agenta, [request, Data]).

negotiate(Agenta, [Agentb, Data]) :-
  want_negotiate(Agenta, [Agentb, Data]),
  request_data(Agenta, Agentb, Data),
  accept_request(Agentb, Agenta, Data).
```

A request is possible when the provider has the data, the requester does not,
and the requester's policy allows asking. A negotiation needs the wish, the
request, and the provider's acceptance.

---

# The answer

```sh
eyeprolog examples/data-negotiation.pl
```

```text
negotiate(agent1, [agent2, data4]).
```

`data4` goes through. `data5` fails twice: agent 1 may not ask for it, and
agent 2 would refuse it anyway. `data7` fails because agent 2 does not have it.

---

# The reason

```text
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
```

The request is justified by both data inventories, by `data4` being in agent
2's list and not in agent 1's, and by agent 1's request policy. Every premise
the decision rests on is named.

---

# The check

```text
condition('C1', resolution, ok, 8).
condition('C5', re_decision, ok, 3).
condition('C6', boundary_consistency, ok, 1).
obligation(absent, theory_scoped, \+ member(data4, [data1, data2, data3])).
steps(12).
trusted(1).
verdict(checked_with_obligations).
```

Eight steps are replayed and three `member/2` calls recomputed. The one
obligation is a negation: "agent 1 does not already have `data4`". A proof
records that a search for something failed; it cannot replay a failure as a
derivation. The checker did test that negation against the evidence it has (C6)
and found nothing that contradicts it, but it remains a stated assumption.

---

# Try it

- Add `want_negotiate(agent1, [agent2, data6]).` A second negotiation
  succeeds, because both policies allow `data6`.
- Change agent 2's policy to refuse `data4`. What is left?
- Give agent 2 a request policy too and let it ask agent 1 for `data1`.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 7 (failure and negation) and Chapter 25 (an auditable decision service).
