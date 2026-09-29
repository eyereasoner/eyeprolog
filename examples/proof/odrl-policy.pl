result_rdf(iri('https://example.org/result'), iri('https://example.org/decision'), iri('https://example.org/permit'), default_graph).
result_rdf(iri('https://example.org/result'), iri('https://example.org/action'), iri('http://www.w3.org/ns/odrl/2/use'), default_graph).
result_rdf(iri('https://example.org/result'), iri('https://example.org/purpose'), iri('https://example.org/research'), default_graph).
result_rdf(iri('https://example.org/result'), iri('https://example.org/target'), iri('https://example.org/dataset'), default_graph).

clause(1,
       rdf(iri('https://example.org/policy'), iri('http://www.w3.org/ns/odrl/2/permission'), iri('https://example.org/permission'), default_graph),
       true).
clause(2,
       rdf(iri('https://example.org/permission'), iri('http://www.w3.org/ns/odrl/2/target'), iri('https://example.org/dataset'), default_graph),
       true).
clause(3,
       rdf(iri('https://example.org/permission'), iri('http://www.w3.org/ns/odrl/2/action'), iri('http://www.w3.org/ns/odrl/2/use'), default_graph),
       true).
clause(4,
       rdf(iri('https://example.org/permission'), iri('http://www.w3.org/ns/odrl/2/constraint'), iri('https://example.org/purpose-constraint'), default_graph),
       true).
clause(5,
       rdf(iri('https://example.org/purpose-constraint'), iri('http://www.w3.org/ns/odrl/2/leftOperand'), iri('http://www.w3.org/ns/odrl/2/purpose'), default_graph),
       true).
clause(6,
       rdf(iri('https://example.org/purpose-constraint'), iri('http://www.w3.org/ns/odrl/2/operator'), iri('http://www.w3.org/ns/odrl/2/eq'), default_graph),
       true).
clause(7,
       rdf(iri('https://example.org/purpose-constraint'), iri('http://www.w3.org/ns/odrl/2/rightOperand'), iri('https://example.org/research'), default_graph),
       true).
clause(8,
       odrl_policy_decision(permit(use, research, dataset)),
       (rdf(iri('https://example.org/policy'), iri('http://www.w3.org/ns/odrl/2/permission'), var('Permission'), default_graph),
        rdf(var('Permission'), iri('http://www.w3.org/ns/odrl/2/target'), iri('https://example.org/dataset'), default_graph),
        rdf(var('Permission'), iri('http://www.w3.org/ns/odrl/2/action'), iri('http://www.w3.org/ns/odrl/2/use'), default_graph),
        rdf(var('Permission'), iri('http://www.w3.org/ns/odrl/2/constraint'), var('Constraint'), default_graph),
        rdf(var('Constraint'), iri('http://www.w3.org/ns/odrl/2/leftOperand'), iri('http://www.w3.org/ns/odrl/2/purpose'), default_graph),
        rdf(var('Constraint'), iri('http://www.w3.org/ns/odrl/2/operator'), iri('http://www.w3.org/ns/odrl/2/eq'), default_graph),
        rdf(var('Constraint'), iri('http://www.w3.org/ns/odrl/2/rightOperand'), iri('https://example.org/research'), default_graph))).
clause(9,
       result_rdf(iri('https://example.org/result'), iri('https://example.org/decision'), iri('https://example.org/permit'), default_graph),
       odrl_policy_decision(permit(use, research, dataset))).
clause(10,
       result_rdf(iri('https://example.org/result'), iri('https://example.org/action'), iri('http://www.w3.org/ns/odrl/2/use'), default_graph),
       odrl_policy_decision(permit(use, research, dataset))).
clause(11,
       result_rdf(iri('https://example.org/result'), iri('https://example.org/purpose'), iri('https://example.org/research'), default_graph),
       odrl_policy_decision(permit(use, research, dataset))).
clause(12,
       result_rdf(iri('https://example.org/result'), iri('https://example.org/target'), iri('https://example.org/dataset'), default_graph),
       odrl_policy_decision(permit(use, research, dataset))).

step(result_rdf(iri('https://example.org/result'), iri('https://example.org/decision'), iri('https://example.org/permit'), default_graph),
     rule(9),
     [],
     [odrl_policy_decision(permit(use, research, dataset))]).
step(odrl_policy_decision(permit(use, research, dataset)),
     rule(8),
     ['Permission' = iri('https://example.org/permission'),
      'Constraint' = iri('https://example.org/purpose-constraint')],
     [rdf(iri('https://example.org/policy'), iri('http://www.w3.org/ns/odrl/2/permission'), iri('https://example.org/permission'), default_graph),
      rdf(iri('https://example.org/permission'), iri('http://www.w3.org/ns/odrl/2/target'), iri('https://example.org/dataset'), default_graph),
      rdf(iri('https://example.org/permission'), iri('http://www.w3.org/ns/odrl/2/action'), iri('http://www.w3.org/ns/odrl/2/use'), default_graph),
      rdf(iri('https://example.org/permission'), iri('http://www.w3.org/ns/odrl/2/constraint'), iri('https://example.org/purpose-constraint'), default_graph),
      rdf(iri('https://example.org/purpose-constraint'), iri('http://www.w3.org/ns/odrl/2/leftOperand'), iri('http://www.w3.org/ns/odrl/2/purpose'), default_graph),
      rdf(iri('https://example.org/purpose-constraint'), iri('http://www.w3.org/ns/odrl/2/operator'), iri('http://www.w3.org/ns/odrl/2/eq'), default_graph),
      rdf(iri('https://example.org/purpose-constraint'), iri('http://www.w3.org/ns/odrl/2/rightOperand'), iri('https://example.org/research'), default_graph)]).
step(rdf(iri('https://example.org/policy'), iri('http://www.w3.org/ns/odrl/2/permission'), iri('https://example.org/permission'), default_graph),
     fact(1),
     [],
     []).
step(rdf(iri('https://example.org/permission'), iri('http://www.w3.org/ns/odrl/2/target'), iri('https://example.org/dataset'), default_graph),
     fact(2),
     [],
     []).
step(rdf(iri('https://example.org/permission'), iri('http://www.w3.org/ns/odrl/2/action'), iri('http://www.w3.org/ns/odrl/2/use'), default_graph),
     fact(3),
     [],
     []).
step(rdf(iri('https://example.org/permission'), iri('http://www.w3.org/ns/odrl/2/constraint'), iri('https://example.org/purpose-constraint'), default_graph),
     fact(4),
     [],
     []).
step(rdf(iri('https://example.org/purpose-constraint'), iri('http://www.w3.org/ns/odrl/2/leftOperand'), iri('http://www.w3.org/ns/odrl/2/purpose'), default_graph),
     fact(5),
     [],
     []).
step(rdf(iri('https://example.org/purpose-constraint'), iri('http://www.w3.org/ns/odrl/2/operator'), iri('http://www.w3.org/ns/odrl/2/eq'), default_graph),
     fact(6),
     [],
     []).
step(rdf(iri('https://example.org/purpose-constraint'), iri('http://www.w3.org/ns/odrl/2/rightOperand'), iri('https://example.org/research'), default_graph),
     fact(7),
     [],
     []).
step(result_rdf(iri('https://example.org/result'), iri('https://example.org/action'), iri('http://www.w3.org/ns/odrl/2/use'), default_graph),
     rule(10),
     [],
     [odrl_policy_decision(permit(use, research, dataset))]).
step(result_rdf(iri('https://example.org/result'), iri('https://example.org/purpose'), iri('https://example.org/research'), default_graph),
     rule(11),
     [],
     [odrl_policy_decision(permit(use, research, dataset))]).
step(result_rdf(iri('https://example.org/result'), iri('https://example.org/target'), iri('https://example.org/dataset'), default_graph),
     rule(12),
     [],
     [odrl_policy_decision(permit(use, research, dataset))]).
