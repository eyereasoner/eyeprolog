result_rdf(iri('https://example.org/result/research_use'), iri('https://example.org/decision'), iri('https://example.org/permit'), default_graph).
result_rdf(iri('https://example.org/result/commercial_use'), iri('https://example.org/decision'), iri('https://example.org/deny'), default_graph).
result_rdf(iri('https://example.org/result/dataset_transfer'), iri('https://example.org/decision'), iri('https://example.org/deny'), default_graph).
result_rdf(iri('https://example.org/result/research_use'), iri('https://example.org/duty'), iri('https://example.org/deidentify'), default_graph).
result_rdf(iri('https://example.org/result/commercial_use'), iri('https://example.org/reason'), iri('https://example.org/purpose_mismatch'), default_graph).
result_rdf(iri('https://example.org/result/dataset_transfer'), iri('https://example.org/reason'), iri('https://example.org/prohibited'), default_graph).

clause(1,
       rdf(iri('https://example.org/advanced-policy'), iri('http://www.w3.org/ns/odrl/2/permission'), iri('https://example.org/research-permission'), default_graph),
       true).
clause(2,
       rdf(iri('https://example.org/advanced-policy'), iri('http://www.w3.org/ns/odrl/2/prohibition'), iri('https://example.org/transfer-prohibition'), default_graph),
       true).
clause(3,
       rdf(iri('https://example.org/research-permission'), iri('http://www.w3.org/ns/odrl/2/target'), iri('https://example.org/health-dataset'), default_graph),
       true).
clause(4,
       rdf(iri('https://example.org/research-permission'), iri('http://www.w3.org/ns/odrl/2/action'), iri('http://www.w3.org/ns/odrl/2/use'), default_graph),
       true).
clause(5,
       rdf(iri('https://example.org/research-permission'), iri('http://www.w3.org/ns/odrl/2/assignee'), iri('https://example.org/research-hospital'), default_graph),
       true).
clause(6,
       rdf(iri('https://example.org/research-permission'), iri('http://www.w3.org/ns/odrl/2/constraint'), iri('https://example.org/purpose-constraint'), default_graph),
       true).
clause(7,
       rdf(iri('https://example.org/research-permission'), iri('http://www.w3.org/ns/odrl/2/constraint'), iri('https://example.org/region-constraint'), default_graph),
       true).
clause(8,
       rdf(iri('https://example.org/research-permission'), iri('http://www.w3.org/ns/odrl/2/duty'), iri('https://example.org/deidentify-duty'), default_graph),
       true).
clause(9,
       rdf(iri('https://example.org/purpose-constraint'), iri('http://www.w3.org/ns/odrl/2/leftOperand'), iri('http://www.w3.org/ns/odrl/2/purpose'), default_graph),
       true).
clause(10,
       rdf(iri('https://example.org/purpose-constraint'), iri('http://www.w3.org/ns/odrl/2/operator'), iri('http://www.w3.org/ns/odrl/2/eq'), default_graph),
       true).
clause(11,
       rdf(iri('https://example.org/purpose-constraint'), iri('http://www.w3.org/ns/odrl/2/rightOperand'), iri('https://example.org/medical-research'), default_graph),
       true).
clause(12,
       rdf(iri('https://example.org/region-constraint'), iri('http://www.w3.org/ns/odrl/2/leftOperand'), iri('http://www.w3.org/ns/odrl/2/spatial'), default_graph),
       true).
clause(13,
       rdf(iri('https://example.org/region-constraint'), iri('http://www.w3.org/ns/odrl/2/operator'), iri('http://www.w3.org/ns/odrl/2/eq'), default_graph),
       true).
clause(14,
       rdf(iri('https://example.org/region-constraint'), iri('http://www.w3.org/ns/odrl/2/rightOperand'), iri('https://example.org/eu'), default_graph),
       true).
clause(15,
       rdf(iri('https://example.org/deidentify-duty'), iri('http://www.w3.org/ns/odrl/2/action'), iri('https://example.org/deidentify'), default_graph),
       true).
clause(16,
       rdf(iri('https://example.org/transfer-prohibition'), iri('http://www.w3.org/ns/odrl/2/target'), iri('https://example.org/health-dataset'), default_graph),
       true).
clause(17,
       rdf(iri('https://example.org/transfer-prohibition'), iri('http://www.w3.org/ns/odrl/2/action'), iri('http://www.w3.org/ns/odrl/2/transfer'), default_graph),
       true).
clause(18,
       rdf(iri('https://example.org/transfer-prohibition'), iri('http://www.w3.org/ns/odrl/2/assignee'), iri('https://example.org/research-hospital'), default_graph),
       true).
clause(19,
       request(research_use, research_hospital, use, health_dataset, medical_research, eu),
       true).
clause(20,
       request(commercial_use, research_hospital, use, health_dataset, commercial, eu),
       true).
clause(21,
       request(dataset_transfer, research_hospital, transfer, health_dataset, medical_research, eu),
       true).
clause(23,
       policy_decision(var('Request'), decision(var('Request'), permit, [duty(var('DutyAction'))])),
       permitted(var('Request'), var('DutyAction'))).
clause(24,
       policy_decision(var('Request'), decision(var('Request'), deny, [reason(purpose_mismatch)])),
       purpose_mismatch(var('Request'))).
clause(25,
       policy_decision(var('Request'), decision(var('Request'), deny, [reason(prohibited)])),
       prohibited(var('Request'))).
clause(26,
       permitted(var('Request'), var('DutyAction')),
       (request(var('Request'), var('Assignee'), var('Action'), var('Target'), var('Purpose'), var('Region')),
        rdf_link(advanced_policy, permission, var('Permission')),
        rule_scope(var('Permission'), var('Assignee'), var('Action'), var('Target')),
        constraint_eq(var('Permission'), purpose, var('Purpose')),
        constraint_eq(var('Permission'), spatial, var('Region')),
        rdf_link(var('Permission'), duty, var('Duty')),
        rdf_link(var('Duty'), action, var('DutyAction')))).
clause(27,
       purpose_mismatch(var('Request')),
       (request(var('Request'), var('Assignee'), var('Action'), var('Target'), var('Purpose'), var('Region')),
        rdf_link(advanced_policy, permission, var('Permission')),
        rule_scope(var('Permission'), var('Assignee'), var('Action'), var('Target')),
        constraint_eq(var('Permission'), spatial, var('Region')),
        constraint_eq(var('Permission'), purpose, var('RequiredPurpose')),
        var('Purpose') \= var('RequiredPurpose'))).
clause(28,
       prohibited(var('Request')),
       (request(var('Request'), var('Assignee'), var('Action'), var('Target'), anonymous(1), anonymous(2)),
        rdf_link(advanced_policy, prohibition, var('Prohibition')),
        rule_scope(var('Prohibition'), var('Assignee'), var('Action'), var('Target')))).
clause(29,
       rule_scope(var('Rule'), var('Assignee'), var('Action'), var('Target')),
       (rdf_link(var('Rule'), assignee, var('Assignee')),
        rdf_link(var('Rule'), action, var('Action')),
        rdf_link(var('Rule'), target, var('Target')))).
clause(30,
       constraint_eq(var('Rule'), var('LeftOperand'), var('RightOperand')),
       (rdf_link(var('Rule'), constraint, var('Constraint')),
        rdf_link(var('Constraint'), left_operand, var('LeftOperand')),
        rdf_link(var('Constraint'), operator, eq),
        rdf_link(var('Constraint'), right_operand, var('RightOperand')))).
clause(31,
       rdf_link(var('Subject'), var('Predicate'), var('Object')),
       (iri_value(var('Subject'), var('SubjectIri')),
        iri_value(var('Predicate'), var('PredicateIri')),
        iri_value(var('Object'), var('ObjectIri')),
        rdf(iri(var('SubjectIri')), iri(var('PredicateIri')), iri(var('ObjectIri')), default_graph))).
clause(32, iri_value(advanced_policy, 'https://example.org/advanced-policy'), true).
clause(33, iri_value(research_permission, 'https://example.org/research-permission'), true).
clause(34, iri_value(transfer_prohibition, 'https://example.org/transfer-prohibition'), true).
clause(35, iri_value(health_dataset, 'https://example.org/health-dataset'), true).
clause(36, iri_value(research_hospital, 'https://example.org/research-hospital'), true).
clause(37, iri_value(medical_research, 'https://example.org/medical-research'), true).
clause(38, iri_value(eu, 'https://example.org/eu'), true).
clause(39, iri_value(deidentify_duty, 'https://example.org/deidentify-duty'), true).
clause(40, iri_value(deidentify, 'https://example.org/deidentify'), true).
clause(41, iri_value(purpose_constraint, 'https://example.org/purpose-constraint'), true).
clause(42, iri_value(region_constraint, 'https://example.org/region-constraint'), true).
clause(43, iri_value(permission, 'http://www.w3.org/ns/odrl/2/permission'), true).
clause(44, iri_value(prohibition, 'http://www.w3.org/ns/odrl/2/prohibition'), true).
clause(45, iri_value(target, 'http://www.w3.org/ns/odrl/2/target'), true).
clause(46, iri_value(action, 'http://www.w3.org/ns/odrl/2/action'), true).
clause(47, iri_value(assignee, 'http://www.w3.org/ns/odrl/2/assignee'), true).
clause(48, iri_value(constraint, 'http://www.w3.org/ns/odrl/2/constraint'), true).
clause(49, iri_value(duty, 'http://www.w3.org/ns/odrl/2/duty'), true).
clause(50, iri_value(left_operand, 'http://www.w3.org/ns/odrl/2/leftOperand'), true).
clause(51, iri_value(operator, 'http://www.w3.org/ns/odrl/2/operator'), true).
clause(52, iri_value(right_operand, 'http://www.w3.org/ns/odrl/2/rightOperand'), true).
clause(53, iri_value(purpose, 'http://www.w3.org/ns/odrl/2/purpose'), true).
clause(54, iri_value(spatial, 'http://www.w3.org/ns/odrl/2/spatial'), true).
clause(55, iri_value(eq, 'http://www.w3.org/ns/odrl/2/eq'), true).
clause(56, iri_value(use, 'http://www.w3.org/ns/odrl/2/use'), true).
clause(57, iri_value(transfer, 'http://www.w3.org/ns/odrl/2/transfer'), true).
clause(58,
       result_rdf(iri(var('Result')), iri('https://example.org/decision'), iri(var('DecisionIri')), default_graph),
       (policy_decision(var('Request'), decision(var('Request'), var('Decision'), anonymous(1))),
        result_node(var('Request'), var('Result')),
        result_value_iri(var('Decision'), var('DecisionIri')))).
clause(59,
       result_rdf(iri(var('Result')), iri('https://example.org/duty'), iri(var('DutyIri')), default_graph),
       (policy_decision(var('Request'), decision(var('Request'), permit, [duty(var('Duty'))])),
        result_node(var('Request'), var('Result')),
        result_value_iri(var('Duty'), var('DutyIri')))).
clause(60,
       result_rdf(iri(var('Result')), iri('https://example.org/reason'), iri(var('ReasonIri')), default_graph),
       (policy_decision(var('Request'), decision(var('Request'), deny, [reason(var('Reason'))])),
        result_node(var('Request'), var('Result')),
        result_value_iri(var('Reason'), var('ReasonIri')))).
clause(61,
       result_node(var('Request'), var('Result')),
       atom_concat('https://example.org/result/', var('Request'), var('Result'))).
clause(62,
       result_value_iri(var('Value'), var('Iri')),
       atom_concat('https://example.org/', var('Value'), var('Iri'))).

step(result_rdf(iri('https://example.org/result/research_use'), iri('https://example.org/decision'), iri('https://example.org/permit'), default_graph),
     rule(58),
     ['Result' = 'https://example.org/result/research_use',
      'DecisionIri' = 'https://example.org/permit',
      'Request' = research_use,
      'Decision' = permit],
     [policy_decision(research_use, decision(research_use, permit, [duty(deidentify)])),
      result_node(research_use, 'https://example.org/result/research_use'),
      result_value_iri(permit, 'https://example.org/permit')]).
step(policy_decision(research_use, decision(research_use, permit, [duty(deidentify)])),
     rule(23),
     ['Request' = research_use, 'DutyAction' = deidentify],
     [permitted(research_use, deidentify)]).
step(permitted(research_use, deidentify),
     rule(26),
     ['Request' = research_use,
      'DutyAction' = deidentify,
      'Assignee' = research_hospital,
      'Action' = use,
      'Target' = health_dataset,
      'Purpose' = medical_research,
      'Region' = eu,
      'Permission' = research_permission,
      'Duty' = deidentify_duty],
     [request(research_use, research_hospital, use, health_dataset, medical_research, eu),
      rdf_link(advanced_policy, permission, research_permission),
      rule_scope(research_permission, research_hospital, use, health_dataset),
      constraint_eq(research_permission, purpose, medical_research),
      constraint_eq(research_permission, spatial, eu),
      rdf_link(research_permission, duty, deidentify_duty),
      rdf_link(deidentify_duty, action, deidentify)]).
step(request(research_use, research_hospital, use, health_dataset, medical_research, eu),
     fact(19),
     [],
     []).
step(rdf_link(advanced_policy, permission, research_permission),
     rule(31),
     ['Subject' = advanced_policy,
      'Predicate' = permission,
      'Object' = research_permission,
      'SubjectIri' = 'https://example.org/advanced-policy',
      'PredicateIri' = 'http://www.w3.org/ns/odrl/2/permission',
      'ObjectIri' = 'https://example.org/research-permission'],
     [iri_value(advanced_policy, 'https://example.org/advanced-policy'),
      iri_value(permission, 'http://www.w3.org/ns/odrl/2/permission'),
      iri_value(research_permission, 'https://example.org/research-permission'),
      rdf(iri('https://example.org/advanced-policy'), iri('http://www.w3.org/ns/odrl/2/permission'), iri('https://example.org/research-permission'), default_graph)]).
step(iri_value(advanced_policy, 'https://example.org/advanced-policy'), fact(32), [], []).
step(iri_value(permission, 'http://www.w3.org/ns/odrl/2/permission'), fact(43), [], []).
step(iri_value(research_permission, 'https://example.org/research-permission'),
     fact(33),
     [],
     []).
step(rdf(iri('https://example.org/advanced-policy'), iri('http://www.w3.org/ns/odrl/2/permission'), iri('https://example.org/research-permission'), default_graph),
     fact(1),
     [],
     []).
step(rule_scope(research_permission, research_hospital, use, health_dataset),
     rule(29),
     ['Rule' = research_permission,
      'Assignee' = research_hospital,
      'Action' = use,
      'Target' = health_dataset],
     [rdf_link(research_permission, assignee, research_hospital),
      rdf_link(research_permission, action, use),
      rdf_link(research_permission, target, health_dataset)]).
step(rdf_link(research_permission, assignee, research_hospital),
     rule(31),
     ['Subject' = research_permission,
      'Predicate' = assignee,
      'Object' = research_hospital,
      'SubjectIri' = 'https://example.org/research-permission',
      'PredicateIri' = 'http://www.w3.org/ns/odrl/2/assignee',
      'ObjectIri' = 'https://example.org/research-hospital'],
     [iri_value(research_permission, 'https://example.org/research-permission'),
      iri_value(assignee, 'http://www.w3.org/ns/odrl/2/assignee'),
      iri_value(research_hospital, 'https://example.org/research-hospital'),
      rdf(iri('https://example.org/research-permission'), iri('http://www.w3.org/ns/odrl/2/assignee'), iri('https://example.org/research-hospital'), default_graph)]).
step(iri_value(assignee, 'http://www.w3.org/ns/odrl/2/assignee'), fact(47), [], []).
step(iri_value(research_hospital, 'https://example.org/research-hospital'), fact(36), [], []).
step(rdf(iri('https://example.org/research-permission'), iri('http://www.w3.org/ns/odrl/2/assignee'), iri('https://example.org/research-hospital'), default_graph),
     fact(5),
     [],
     []).
step(rdf_link(research_permission, action, use),
     rule(31),
     ['Subject' = research_permission,
      'Predicate' = action,
      'Object' = use,
      'SubjectIri' = 'https://example.org/research-permission',
      'PredicateIri' = 'http://www.w3.org/ns/odrl/2/action',
      'ObjectIri' = 'http://www.w3.org/ns/odrl/2/use'],
     [iri_value(research_permission, 'https://example.org/research-permission'),
      iri_value(action, 'http://www.w3.org/ns/odrl/2/action'),
      iri_value(use, 'http://www.w3.org/ns/odrl/2/use'),
      rdf(iri('https://example.org/research-permission'), iri('http://www.w3.org/ns/odrl/2/action'), iri('http://www.w3.org/ns/odrl/2/use'), default_graph)]).
step(iri_value(action, 'http://www.w3.org/ns/odrl/2/action'), fact(46), [], []).
step(iri_value(use, 'http://www.w3.org/ns/odrl/2/use'), fact(56), [], []).
step(rdf(iri('https://example.org/research-permission'), iri('http://www.w3.org/ns/odrl/2/action'), iri('http://www.w3.org/ns/odrl/2/use'), default_graph),
     fact(4),
     [],
     []).
step(rdf_link(research_permission, target, health_dataset),
     rule(31),
     ['Subject' = research_permission,
      'Predicate' = target,
      'Object' = health_dataset,
      'SubjectIri' = 'https://example.org/research-permission',
      'PredicateIri' = 'http://www.w3.org/ns/odrl/2/target',
      'ObjectIri' = 'https://example.org/health-dataset'],
     [iri_value(research_permission, 'https://example.org/research-permission'),
      iri_value(target, 'http://www.w3.org/ns/odrl/2/target'),
      iri_value(health_dataset, 'https://example.org/health-dataset'),
      rdf(iri('https://example.org/research-permission'), iri('http://www.w3.org/ns/odrl/2/target'), iri('https://example.org/health-dataset'), default_graph)]).
step(iri_value(target, 'http://www.w3.org/ns/odrl/2/target'), fact(45), [], []).
step(iri_value(health_dataset, 'https://example.org/health-dataset'), fact(35), [], []).
step(rdf(iri('https://example.org/research-permission'), iri('http://www.w3.org/ns/odrl/2/target'), iri('https://example.org/health-dataset'), default_graph),
     fact(3),
     [],
     []).
step(constraint_eq(research_permission, purpose, medical_research),
     rule(30),
     ['Rule' = research_permission,
      'LeftOperand' = purpose,
      'RightOperand' = medical_research,
      'Constraint' = purpose_constraint],
     [rdf_link(research_permission, constraint, purpose_constraint),
      rdf_link(purpose_constraint, left_operand, purpose),
      rdf_link(purpose_constraint, operator, eq),
      rdf_link(purpose_constraint, right_operand, medical_research)]).
step(rdf_link(research_permission, constraint, purpose_constraint),
     rule(31),
     ['Subject' = research_permission,
      'Predicate' = constraint,
      'Object' = purpose_constraint,
      'SubjectIri' = 'https://example.org/research-permission',
      'PredicateIri' = 'http://www.w3.org/ns/odrl/2/constraint',
      'ObjectIri' = 'https://example.org/purpose-constraint'],
     [iri_value(research_permission, 'https://example.org/research-permission'),
      iri_value(constraint, 'http://www.w3.org/ns/odrl/2/constraint'),
      iri_value(purpose_constraint, 'https://example.org/purpose-constraint'),
      rdf(iri('https://example.org/research-permission'), iri('http://www.w3.org/ns/odrl/2/constraint'), iri('https://example.org/purpose-constraint'), default_graph)]).
step(iri_value(constraint, 'http://www.w3.org/ns/odrl/2/constraint'), fact(48), [], []).
step(iri_value(purpose_constraint, 'https://example.org/purpose-constraint'), fact(41), [], []).
step(rdf(iri('https://example.org/research-permission'), iri('http://www.w3.org/ns/odrl/2/constraint'), iri('https://example.org/purpose-constraint'), default_graph),
     fact(6),
     [],
     []).
step(rdf_link(purpose_constraint, left_operand, purpose),
     rule(31),
     ['Subject' = purpose_constraint,
      'Predicate' = left_operand,
      'Object' = purpose,
      'SubjectIri' = 'https://example.org/purpose-constraint',
      'PredicateIri' = 'http://www.w3.org/ns/odrl/2/leftOperand',
      'ObjectIri' = 'http://www.w3.org/ns/odrl/2/purpose'],
     [iri_value(purpose_constraint, 'https://example.org/purpose-constraint'),
      iri_value(left_operand, 'http://www.w3.org/ns/odrl/2/leftOperand'),
      iri_value(purpose, 'http://www.w3.org/ns/odrl/2/purpose'),
      rdf(iri('https://example.org/purpose-constraint'), iri('http://www.w3.org/ns/odrl/2/leftOperand'), iri('http://www.w3.org/ns/odrl/2/purpose'), default_graph)]).
step(iri_value(left_operand, 'http://www.w3.org/ns/odrl/2/leftOperand'), fact(50), [], []).
step(iri_value(purpose, 'http://www.w3.org/ns/odrl/2/purpose'), fact(53), [], []).
step(rdf(iri('https://example.org/purpose-constraint'), iri('http://www.w3.org/ns/odrl/2/leftOperand'), iri('http://www.w3.org/ns/odrl/2/purpose'), default_graph),
     fact(9),
     [],
     []).
step(rdf_link(purpose_constraint, operator, eq),
     rule(31),
     ['Subject' = purpose_constraint,
      'Predicate' = operator,
      'Object' = eq,
      'SubjectIri' = 'https://example.org/purpose-constraint',
      'PredicateIri' = 'http://www.w3.org/ns/odrl/2/operator',
      'ObjectIri' = 'http://www.w3.org/ns/odrl/2/eq'],
     [iri_value(purpose_constraint, 'https://example.org/purpose-constraint'),
      iri_value(operator, 'http://www.w3.org/ns/odrl/2/operator'),
      iri_value(eq, 'http://www.w3.org/ns/odrl/2/eq'),
      rdf(iri('https://example.org/purpose-constraint'), iri('http://www.w3.org/ns/odrl/2/operator'), iri('http://www.w3.org/ns/odrl/2/eq'), default_graph)]).
step(iri_value(operator, 'http://www.w3.org/ns/odrl/2/operator'), fact(51), [], []).
step(iri_value(eq, 'http://www.w3.org/ns/odrl/2/eq'), fact(55), [], []).
step(rdf(iri('https://example.org/purpose-constraint'), iri('http://www.w3.org/ns/odrl/2/operator'), iri('http://www.w3.org/ns/odrl/2/eq'), default_graph),
     fact(10),
     [],
     []).
step(rdf_link(purpose_constraint, right_operand, medical_research),
     rule(31),
     ['Subject' = purpose_constraint,
      'Predicate' = right_operand,
      'Object' = medical_research,
      'SubjectIri' = 'https://example.org/purpose-constraint',
      'PredicateIri' = 'http://www.w3.org/ns/odrl/2/rightOperand',
      'ObjectIri' = 'https://example.org/medical-research'],
     [iri_value(purpose_constraint, 'https://example.org/purpose-constraint'),
      iri_value(right_operand, 'http://www.w3.org/ns/odrl/2/rightOperand'),
      iri_value(medical_research, 'https://example.org/medical-research'),
      rdf(iri('https://example.org/purpose-constraint'), iri('http://www.w3.org/ns/odrl/2/rightOperand'), iri('https://example.org/medical-research'), default_graph)]).
step(iri_value(right_operand, 'http://www.w3.org/ns/odrl/2/rightOperand'), fact(52), [], []).
step(iri_value(medical_research, 'https://example.org/medical-research'), fact(37), [], []).
step(rdf(iri('https://example.org/purpose-constraint'), iri('http://www.w3.org/ns/odrl/2/rightOperand'), iri('https://example.org/medical-research'), default_graph),
     fact(11),
     [],
     []).
step(constraint_eq(research_permission, spatial, eu),
     rule(30),
     ['Rule' = research_permission,
      'LeftOperand' = spatial,
      'RightOperand' = eu,
      'Constraint' = region_constraint],
     [rdf_link(research_permission, constraint, region_constraint),
      rdf_link(region_constraint, left_operand, spatial),
      rdf_link(region_constraint, operator, eq),
      rdf_link(region_constraint, right_operand, eu)]).
step(rdf_link(research_permission, constraint, region_constraint),
     rule(31),
     ['Subject' = research_permission,
      'Predicate' = constraint,
      'Object' = region_constraint,
      'SubjectIri' = 'https://example.org/research-permission',
      'PredicateIri' = 'http://www.w3.org/ns/odrl/2/constraint',
      'ObjectIri' = 'https://example.org/region-constraint'],
     [iri_value(research_permission, 'https://example.org/research-permission'),
      iri_value(constraint, 'http://www.w3.org/ns/odrl/2/constraint'),
      iri_value(region_constraint, 'https://example.org/region-constraint'),
      rdf(iri('https://example.org/research-permission'), iri('http://www.w3.org/ns/odrl/2/constraint'), iri('https://example.org/region-constraint'), default_graph)]).
step(iri_value(region_constraint, 'https://example.org/region-constraint'), fact(42), [], []).
step(rdf(iri('https://example.org/research-permission'), iri('http://www.w3.org/ns/odrl/2/constraint'), iri('https://example.org/region-constraint'), default_graph),
     fact(7),
     [],
     []).
step(rdf_link(region_constraint, left_operand, spatial),
     rule(31),
     ['Subject' = region_constraint,
      'Predicate' = left_operand,
      'Object' = spatial,
      'SubjectIri' = 'https://example.org/region-constraint',
      'PredicateIri' = 'http://www.w3.org/ns/odrl/2/leftOperand',
      'ObjectIri' = 'http://www.w3.org/ns/odrl/2/spatial'],
     [iri_value(region_constraint, 'https://example.org/region-constraint'),
      iri_value(left_operand, 'http://www.w3.org/ns/odrl/2/leftOperand'),
      iri_value(spatial, 'http://www.w3.org/ns/odrl/2/spatial'),
      rdf(iri('https://example.org/region-constraint'), iri('http://www.w3.org/ns/odrl/2/leftOperand'), iri('http://www.w3.org/ns/odrl/2/spatial'), default_graph)]).
step(iri_value(spatial, 'http://www.w3.org/ns/odrl/2/spatial'), fact(54), [], []).
step(rdf(iri('https://example.org/region-constraint'), iri('http://www.w3.org/ns/odrl/2/leftOperand'), iri('http://www.w3.org/ns/odrl/2/spatial'), default_graph),
     fact(12),
     [],
     []).
step(rdf_link(region_constraint, operator, eq),
     rule(31),
     ['Subject' = region_constraint,
      'Predicate' = operator,
      'Object' = eq,
      'SubjectIri' = 'https://example.org/region-constraint',
      'PredicateIri' = 'http://www.w3.org/ns/odrl/2/operator',
      'ObjectIri' = 'http://www.w3.org/ns/odrl/2/eq'],
     [iri_value(region_constraint, 'https://example.org/region-constraint'),
      iri_value(operator, 'http://www.w3.org/ns/odrl/2/operator'),
      iri_value(eq, 'http://www.w3.org/ns/odrl/2/eq'),
      rdf(iri('https://example.org/region-constraint'), iri('http://www.w3.org/ns/odrl/2/operator'), iri('http://www.w3.org/ns/odrl/2/eq'), default_graph)]).
step(rdf(iri('https://example.org/region-constraint'), iri('http://www.w3.org/ns/odrl/2/operator'), iri('http://www.w3.org/ns/odrl/2/eq'), default_graph),
     fact(13),
     [],
     []).
step(rdf_link(region_constraint, right_operand, eu),
     rule(31),
     ['Subject' = region_constraint,
      'Predicate' = right_operand,
      'Object' = eu,
      'SubjectIri' = 'https://example.org/region-constraint',
      'PredicateIri' = 'http://www.w3.org/ns/odrl/2/rightOperand',
      'ObjectIri' = 'https://example.org/eu'],
     [iri_value(region_constraint, 'https://example.org/region-constraint'),
      iri_value(right_operand, 'http://www.w3.org/ns/odrl/2/rightOperand'),
      iri_value(eu, 'https://example.org/eu'),
      rdf(iri('https://example.org/region-constraint'), iri('http://www.w3.org/ns/odrl/2/rightOperand'), iri('https://example.org/eu'), default_graph)]).
step(iri_value(eu, 'https://example.org/eu'), fact(38), [], []).
step(rdf(iri('https://example.org/region-constraint'), iri('http://www.w3.org/ns/odrl/2/rightOperand'), iri('https://example.org/eu'), default_graph),
     fact(14),
     [],
     []).
step(rdf_link(research_permission, duty, deidentify_duty),
     rule(31),
     ['Subject' = research_permission,
      'Predicate' = duty,
      'Object' = deidentify_duty,
      'SubjectIri' = 'https://example.org/research-permission',
      'PredicateIri' = 'http://www.w3.org/ns/odrl/2/duty',
      'ObjectIri' = 'https://example.org/deidentify-duty'],
     [iri_value(research_permission, 'https://example.org/research-permission'),
      iri_value(duty, 'http://www.w3.org/ns/odrl/2/duty'),
      iri_value(deidentify_duty, 'https://example.org/deidentify-duty'),
      rdf(iri('https://example.org/research-permission'), iri('http://www.w3.org/ns/odrl/2/duty'), iri('https://example.org/deidentify-duty'), default_graph)]).
step(iri_value(duty, 'http://www.w3.org/ns/odrl/2/duty'), fact(49), [], []).
step(iri_value(deidentify_duty, 'https://example.org/deidentify-duty'), fact(39), [], []).
step(rdf(iri('https://example.org/research-permission'), iri('http://www.w3.org/ns/odrl/2/duty'), iri('https://example.org/deidentify-duty'), default_graph),
     fact(8),
     [],
     []).
step(rdf_link(deidentify_duty, action, deidentify),
     rule(31),
     ['Subject' = deidentify_duty,
      'Predicate' = action,
      'Object' = deidentify,
      'SubjectIri' = 'https://example.org/deidentify-duty',
      'PredicateIri' = 'http://www.w3.org/ns/odrl/2/action',
      'ObjectIri' = 'https://example.org/deidentify'],
     [iri_value(deidentify_duty, 'https://example.org/deidentify-duty'),
      iri_value(action, 'http://www.w3.org/ns/odrl/2/action'),
      iri_value(deidentify, 'https://example.org/deidentify'),
      rdf(iri('https://example.org/deidentify-duty'), iri('http://www.w3.org/ns/odrl/2/action'), iri('https://example.org/deidentify'), default_graph)]).
step(iri_value(deidentify, 'https://example.org/deidentify'), fact(40), [], []).
step(rdf(iri('https://example.org/deidentify-duty'), iri('http://www.w3.org/ns/odrl/2/action'), iri('https://example.org/deidentify'), default_graph),
     fact(15),
     [],
     []).
step(result_node(research_use, 'https://example.org/result/research_use'),
     rule(61),
     ['Request' = research_use, 'Result' = 'https://example.org/result/research_use'],
     [atom_concat('https://example.org/result/', research_use, 'https://example.org/result/research_use')]).
step(atom_concat('https://example.org/result/', research_use, 'https://example.org/result/research_use'),
     builtin,
     [],
     []).
step(result_value_iri(permit, 'https://example.org/permit'),
     rule(62),
     ['Value' = permit, 'Iri' = 'https://example.org/permit'],
     [atom_concat('https://example.org/', permit, 'https://example.org/permit')]).
step(atom_concat('https://example.org/', permit, 'https://example.org/permit'), builtin, [], []).
step(result_rdf(iri('https://example.org/result/commercial_use'), iri('https://example.org/decision'), iri('https://example.org/deny'), default_graph),
     rule(58),
     ['Result' = 'https://example.org/result/commercial_use',
      'DecisionIri' = 'https://example.org/deny',
      'Request' = commercial_use,
      'Decision' = deny],
     [policy_decision(commercial_use, decision(commercial_use, deny, [reason(purpose_mismatch)])),
      result_node(commercial_use, 'https://example.org/result/commercial_use'),
      result_value_iri(deny, 'https://example.org/deny')]).
step(policy_decision(commercial_use, decision(commercial_use, deny, [reason(purpose_mismatch)])),
     rule(24),
     ['Request' = commercial_use],
     [purpose_mismatch(commercial_use)]).
step(purpose_mismatch(commercial_use),
     rule(27),
     ['Request' = commercial_use,
      'Assignee' = research_hospital,
      'Action' = use,
      'Target' = health_dataset,
      'Purpose' = commercial,
      'Region' = eu,
      'Permission' = research_permission,
      'RequiredPurpose' = medical_research],
     [request(commercial_use, research_hospital, use, health_dataset, commercial, eu),
      rdf_link(advanced_policy, permission, research_permission),
      rule_scope(research_permission, research_hospital, use, health_dataset),
      constraint_eq(research_permission, spatial, eu),
      constraint_eq(research_permission, purpose, medical_research),
      commercial \= medical_research]).
step(request(commercial_use, research_hospital, use, health_dataset, commercial, eu),
     fact(20),
     [],
     []).
step(commercial \= medical_research, builtin, [], []).
step(result_node(commercial_use, 'https://example.org/result/commercial_use'),
     rule(61),
     ['Request' = commercial_use, 'Result' = 'https://example.org/result/commercial_use'],
     [atom_concat('https://example.org/result/', commercial_use, 'https://example.org/result/commercial_use')]).
step(atom_concat('https://example.org/result/', commercial_use, 'https://example.org/result/commercial_use'),
     builtin,
     [],
     []).
step(result_value_iri(deny, 'https://example.org/deny'),
     rule(62),
     ['Value' = deny, 'Iri' = 'https://example.org/deny'],
     [atom_concat('https://example.org/', deny, 'https://example.org/deny')]).
step(atom_concat('https://example.org/', deny, 'https://example.org/deny'), builtin, [], []).
step(result_rdf(iri('https://example.org/result/dataset_transfer'), iri('https://example.org/decision'), iri('https://example.org/deny'), default_graph),
     rule(58),
     ['Result' = 'https://example.org/result/dataset_transfer',
      'DecisionIri' = 'https://example.org/deny',
      'Request' = dataset_transfer,
      'Decision' = deny],
     [policy_decision(dataset_transfer, decision(dataset_transfer, deny, [reason(prohibited)])),
      result_node(dataset_transfer, 'https://example.org/result/dataset_transfer'),
      result_value_iri(deny, 'https://example.org/deny')]).
step(policy_decision(dataset_transfer, decision(dataset_transfer, deny, [reason(prohibited)])),
     rule(25),
     ['Request' = dataset_transfer],
     [prohibited(dataset_transfer)]).
step(prohibited(dataset_transfer),
     rule(28),
     ['Request' = dataset_transfer,
      'Assignee' = research_hospital,
      'Action' = transfer,
      'Target' = health_dataset,
      'Prohibition' = transfer_prohibition],
     [request(dataset_transfer, research_hospital, transfer, health_dataset, medical_research, eu),
      rdf_link(advanced_policy, prohibition, transfer_prohibition),
      rule_scope(transfer_prohibition, research_hospital, transfer, health_dataset)]).
step(request(dataset_transfer, research_hospital, transfer, health_dataset, medical_research, eu),
     fact(21),
     [],
     []).
step(rdf_link(advanced_policy, prohibition, transfer_prohibition),
     rule(31),
     ['Subject' = advanced_policy,
      'Predicate' = prohibition,
      'Object' = transfer_prohibition,
      'SubjectIri' = 'https://example.org/advanced-policy',
      'PredicateIri' = 'http://www.w3.org/ns/odrl/2/prohibition',
      'ObjectIri' = 'https://example.org/transfer-prohibition'],
     [iri_value(advanced_policy, 'https://example.org/advanced-policy'),
      iri_value(prohibition, 'http://www.w3.org/ns/odrl/2/prohibition'),
      iri_value(transfer_prohibition, 'https://example.org/transfer-prohibition'),
      rdf(iri('https://example.org/advanced-policy'), iri('http://www.w3.org/ns/odrl/2/prohibition'), iri('https://example.org/transfer-prohibition'), default_graph)]).
step(iri_value(prohibition, 'http://www.w3.org/ns/odrl/2/prohibition'), fact(44), [], []).
step(iri_value(transfer_prohibition, 'https://example.org/transfer-prohibition'),
     fact(34),
     [],
     []).
step(rdf(iri('https://example.org/advanced-policy'), iri('http://www.w3.org/ns/odrl/2/prohibition'), iri('https://example.org/transfer-prohibition'), default_graph),
     fact(2),
     [],
     []).
step(rule_scope(transfer_prohibition, research_hospital, transfer, health_dataset),
     rule(29),
     ['Rule' = transfer_prohibition,
      'Assignee' = research_hospital,
      'Action' = transfer,
      'Target' = health_dataset],
     [rdf_link(transfer_prohibition, assignee, research_hospital),
      rdf_link(transfer_prohibition, action, transfer),
      rdf_link(transfer_prohibition, target, health_dataset)]).
step(rdf_link(transfer_prohibition, assignee, research_hospital),
     rule(31),
     ['Subject' = transfer_prohibition,
      'Predicate' = assignee,
      'Object' = research_hospital,
      'SubjectIri' = 'https://example.org/transfer-prohibition',
      'PredicateIri' = 'http://www.w3.org/ns/odrl/2/assignee',
      'ObjectIri' = 'https://example.org/research-hospital'],
     [iri_value(transfer_prohibition, 'https://example.org/transfer-prohibition'),
      iri_value(assignee, 'http://www.w3.org/ns/odrl/2/assignee'),
      iri_value(research_hospital, 'https://example.org/research-hospital'),
      rdf(iri('https://example.org/transfer-prohibition'), iri('http://www.w3.org/ns/odrl/2/assignee'), iri('https://example.org/research-hospital'), default_graph)]).
step(rdf(iri('https://example.org/transfer-prohibition'), iri('http://www.w3.org/ns/odrl/2/assignee'), iri('https://example.org/research-hospital'), default_graph),
     fact(18),
     [],
     []).
step(rdf_link(transfer_prohibition, action, transfer),
     rule(31),
     ['Subject' = transfer_prohibition,
      'Predicate' = action,
      'Object' = transfer,
      'SubjectIri' = 'https://example.org/transfer-prohibition',
      'PredicateIri' = 'http://www.w3.org/ns/odrl/2/action',
      'ObjectIri' = 'http://www.w3.org/ns/odrl/2/transfer'],
     [iri_value(transfer_prohibition, 'https://example.org/transfer-prohibition'),
      iri_value(action, 'http://www.w3.org/ns/odrl/2/action'),
      iri_value(transfer, 'http://www.w3.org/ns/odrl/2/transfer'),
      rdf(iri('https://example.org/transfer-prohibition'), iri('http://www.w3.org/ns/odrl/2/action'), iri('http://www.w3.org/ns/odrl/2/transfer'), default_graph)]).
step(iri_value(transfer, 'http://www.w3.org/ns/odrl/2/transfer'), fact(57), [], []).
step(rdf(iri('https://example.org/transfer-prohibition'), iri('http://www.w3.org/ns/odrl/2/action'), iri('http://www.w3.org/ns/odrl/2/transfer'), default_graph),
     fact(17),
     [],
     []).
step(rdf_link(transfer_prohibition, target, health_dataset),
     rule(31),
     ['Subject' = transfer_prohibition,
      'Predicate' = target,
      'Object' = health_dataset,
      'SubjectIri' = 'https://example.org/transfer-prohibition',
      'PredicateIri' = 'http://www.w3.org/ns/odrl/2/target',
      'ObjectIri' = 'https://example.org/health-dataset'],
     [iri_value(transfer_prohibition, 'https://example.org/transfer-prohibition'),
      iri_value(target, 'http://www.w3.org/ns/odrl/2/target'),
      iri_value(health_dataset, 'https://example.org/health-dataset'),
      rdf(iri('https://example.org/transfer-prohibition'), iri('http://www.w3.org/ns/odrl/2/target'), iri('https://example.org/health-dataset'), default_graph)]).
step(rdf(iri('https://example.org/transfer-prohibition'), iri('http://www.w3.org/ns/odrl/2/target'), iri('https://example.org/health-dataset'), default_graph),
     fact(16),
     [],
     []).
step(result_node(dataset_transfer, 'https://example.org/result/dataset_transfer'),
     rule(61),
     ['Request' = dataset_transfer, 'Result' = 'https://example.org/result/dataset_transfer'],
     [atom_concat('https://example.org/result/', dataset_transfer, 'https://example.org/result/dataset_transfer')]).
step(atom_concat('https://example.org/result/', dataset_transfer, 'https://example.org/result/dataset_transfer'),
     builtin,
     [],
     []).
step(result_rdf(iri('https://example.org/result/research_use'), iri('https://example.org/duty'), iri('https://example.org/deidentify'), default_graph),
     rule(59),
     ['Result' = 'https://example.org/result/research_use',
      'DutyIri' = 'https://example.org/deidentify',
      'Request' = research_use,
      'Duty' = deidentify],
     [policy_decision(research_use, decision(research_use, permit, [duty(deidentify)])),
      result_node(research_use, 'https://example.org/result/research_use'),
      result_value_iri(deidentify, 'https://example.org/deidentify')]).
step(result_value_iri(deidentify, 'https://example.org/deidentify'),
     rule(62),
     ['Value' = deidentify, 'Iri' = 'https://example.org/deidentify'],
     [atom_concat('https://example.org/', deidentify, 'https://example.org/deidentify')]).
step(atom_concat('https://example.org/', deidentify, 'https://example.org/deidentify'),
     builtin,
     [],
     []).
step(result_rdf(iri('https://example.org/result/commercial_use'), iri('https://example.org/reason'), iri('https://example.org/purpose_mismatch'), default_graph),
     rule(60),
     ['Result' = 'https://example.org/result/commercial_use',
      'ReasonIri' = 'https://example.org/purpose_mismatch',
      'Request' = commercial_use,
      'Reason' = purpose_mismatch],
     [policy_decision(commercial_use, decision(commercial_use, deny, [reason(purpose_mismatch)])),
      result_node(commercial_use, 'https://example.org/result/commercial_use'),
      result_value_iri(purpose_mismatch, 'https://example.org/purpose_mismatch')]).
step(result_value_iri(purpose_mismatch, 'https://example.org/purpose_mismatch'),
     rule(62),
     ['Value' = purpose_mismatch, 'Iri' = 'https://example.org/purpose_mismatch'],
     [atom_concat('https://example.org/', purpose_mismatch, 'https://example.org/purpose_mismatch')]).
step(atom_concat('https://example.org/', purpose_mismatch, 'https://example.org/purpose_mismatch'),
     builtin,
     [],
     []).
step(result_rdf(iri('https://example.org/result/dataset_transfer'), iri('https://example.org/reason'), iri('https://example.org/prohibited'), default_graph),
     rule(60),
     ['Result' = 'https://example.org/result/dataset_transfer',
      'ReasonIri' = 'https://example.org/prohibited',
      'Request' = dataset_transfer,
      'Reason' = prohibited],
     [policy_decision(dataset_transfer, decision(dataset_transfer, deny, [reason(prohibited)])),
      result_node(dataset_transfer, 'https://example.org/result/dataset_transfer'),
      result_value_iri(prohibited, 'https://example.org/prohibited')]).
step(result_value_iri(prohibited, 'https://example.org/prohibited'),
     rule(62),
     ['Value' = prohibited, 'Iri' = 'https://example.org/prohibited'],
     [atom_concat('https://example.org/', prohibited, 'https://example.org/prohibited')]).
step(atom_concat('https://example.org/', prohibited, 'https://example.org/prohibited'),
     builtin,
     [],
     []).
