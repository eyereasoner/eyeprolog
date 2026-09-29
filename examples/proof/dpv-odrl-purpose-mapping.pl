result_rdf(iri('https://example.org/result/mapping/data_controller'), iri('https://example.org/sourceRole'), iri('https://example.org/role/data_controller'), default_graph).
result_rdf(iri('https://example.org/result/mapping/recipient'), iri('https://example.org/sourceRole'), iri('https://example.org/role/recipient'), default_graph).
result_rdf(iri('https://example.org/result/mapping/personal_data'), iri('https://example.org/sourceRole'), iri('https://example.org/role/personal_data'), default_graph).
result_rdf(iri('https://example.org/result/mapping/processing'), iri('https://example.org/sourceRole'), iri('https://example.org/role/processing'), default_graph).
result_rdf(iri('https://example.org/result/mapping/purpose'), iri('https://example.org/sourceRole'), iri('https://example.org/role/purpose'), default_graph).
result_rdf(iri('https://example.org/result/mapping/legal_basis'), iri('https://example.org/sourceRole'), iri('https://example.org/role/legal_basis'), default_graph).
result_rdf(iri('https://example.org/result/mapping/data_controller'), iri('https://example.org/value'), iri('https://example.org/hospital_a'), default_graph).
result_rdf(iri('https://example.org/result/mapping/recipient'), iri('https://example.org/value'), iri('https://example.org/research_partner'), default_graph).
result_rdf(iri('https://example.org/result/mapping/personal_data'), iri('https://example.org/value'), iri('https://example.org/lab_result'), default_graph).
result_rdf(iri('https://example.org/result/mapping/processing'), iri('https://example.org/value'), iri('https://w3id.org/dpv#Use'), default_graph).
result_rdf(iri('https://example.org/result/mapping/purpose'), iri('https://example.org/value'), iri('https://w3id.org/dpv#Healthcare'), default_graph).
result_rdf(iri('https://example.org/result/mapping/legal_basis'), iri('https://example.org/value'), iri('https://w3id.org/dpv#Consent'), default_graph).
result_rdf(iri('https://example.org/result/mapping/data_controller'), iri('https://example.org/mappingTarget'), iri('http://www.w3.org/ns/odrl/2/assigner'), default_graph).
result_rdf(iri('https://example.org/result/mapping/recipient'), iri('https://example.org/mappingTarget'), iri('http://www.w3.org/ns/odrl/2/assignee'), default_graph).
result_rdf(iri('https://example.org/result/mapping/personal_data'), iri('https://example.org/mappingTarget'), iri('http://www.w3.org/ns/odrl/2/target'), default_graph).
result_rdf(iri('https://example.org/result/mapping/processing'), iri('https://example.org/mappingTarget'), iri('http://www.w3.org/ns/odrl/2/action'), default_graph).
result_rdf(iri('https://example.org/result/mapping/purpose'), iri('https://example.org/mappingTarget'), iri('https://example.org/alpha_purpose_constraint'), default_graph).
result_rdf(iri('https://example.org/result/mapping/legal_basis'), iri('https://example.org/mappingTarget'), iri('https://example.org/alpha_basis_constraint'), default_graph).

clause(2,
       rdf(iri('https://example.org/alpha_care_process'), iri('https://w3id.org/dpv#hasDataController'), iri('https://example.org/hospital_a'), default_graph),
       true).
clause(3,
       rdf(iri('https://example.org/alpha_care_process'), iri('https://w3id.org/dpv#hasRecipient'), iri('https://example.org/research_partner'), default_graph),
       true).
clause(4,
       rdf(iri('https://example.org/alpha_care_process'), iri('https://w3id.org/dpv#hasPersonalData'), iri('https://example.org/lab_result'), default_graph),
       true).
clause(5,
       rdf(iri('https://example.org/alpha_care_process'), iri('https://w3id.org/dpv#hasProcessing'), iri('https://w3id.org/dpv#Use'), default_graph),
       true).
clause(6,
       rdf(iri('https://example.org/alpha_care_process'), iri('https://w3id.org/dpv#hasPurpose'), iri('https://w3id.org/dpv#Healthcare'), default_graph),
       true).
clause(7,
       rdf(iri('https://example.org/alpha_care_process'), iri('https://w3id.org/dpv#hasLegalBasis'), iri('https://w3id.org/dpv#Consent'), default_graph),
       true).
clause(12,
       rdf(iri('https://example.org/alpha_permission'), iri('http://www.w3.org/ns/odrl/2/assigner'), iri('https://example.org/hospital_a'), default_graph),
       true).
clause(13,
       rdf(iri('https://example.org/alpha_permission'), iri('http://www.w3.org/ns/odrl/2/assignee'), iri('https://example.org/research_partner'), default_graph),
       true).
clause(14,
       rdf(iri('https://example.org/alpha_permission'), iri('http://www.w3.org/ns/odrl/2/target'), iri('https://example.org/lab_result'), default_graph),
       true).
clause(15,
       rdf(iri('https://example.org/alpha_permission'), iri('http://www.w3.org/ns/odrl/2/action'), iri('http://www.w3.org/ns/odrl/2/use'), default_graph),
       true).
clause(16,
       rdf(iri('https://example.org/alpha_permission'), iri('http://www.w3.org/ns/odrl/2/constraint'), iri('https://example.org/alpha_purpose_constraint'), default_graph),
       true).
clause(17,
       rdf(iri('https://example.org/alpha_permission'), iri('http://www.w3.org/ns/odrl/2/constraint'), iri('https://example.org/alpha_basis_constraint'), default_graph),
       true).
clause(19,
       rdf(iri('https://example.org/alpha_purpose_constraint'), iri('http://www.w3.org/ns/odrl/2/leftOperand'), iri('http://www.w3.org/ns/odrl/2/purpose'), default_graph),
       true).
clause(20,
       rdf(iri('https://example.org/alpha_purpose_constraint'), iri('http://www.w3.org/ns/odrl/2/operator'), iri('http://www.w3.org/ns/odrl/2/isA'), default_graph),
       true).
clause(21,
       rdf(iri('https://example.org/alpha_purpose_constraint'), iri('http://www.w3.org/ns/odrl/2/rightOperand'), iri('https://w3id.org/dpv#Healthcare'), default_graph),
       true).
clause(23,
       rdf(iri('https://example.org/alpha_basis_constraint'), iri('http://www.w3.org/ns/odrl/2/leftOperand'), iri('https://example.org/legalBasis'), default_graph),
       true).
clause(24,
       rdf(iri('https://example.org/alpha_basis_constraint'), iri('http://www.w3.org/ns/odrl/2/operator'), iri('http://www.w3.org/ns/odrl/2/isA'), default_graph),
       true).
clause(25,
       rdf(iri('https://example.org/alpha_basis_constraint'), iri('http://www.w3.org/ns/odrl/2/rightOperand'), iri('https://w3id.org/dpv#Consent'), default_graph),
       true).
clause(27,
       mapped_role(data_controller, var('Controller'), assigner),
       (rdf_link(ex(alpha_care_process), dpv(hasDataController), ex(var('Controller'))),
        rdf_link(ex(alpha_permission), odrl(assigner), ex(var('Controller'))))).
clause(28,
       mapped_role(recipient, var('Recipient'), assignee),
       (rdf_link(ex(alpha_care_process), dpv(hasRecipient), ex(var('Recipient'))),
        rdf_link(ex(alpha_permission), odrl(assignee), ex(var('Recipient'))))).
clause(29,
       mapped_role(personal_data, var('Data'), target),
       (rdf_link(ex(alpha_care_process), dpv(hasPersonalData), ex(var('Data'))),
        rdf_link(ex(alpha_permission), odrl(target), ex(var('Data'))))).
clause(30,
       mapped_role(processing, dpv_use, action),
       (rdf_link(ex(alpha_care_process), dpv(hasProcessing), dpv('Use')),
        rdf_link(ex(alpha_permission), odrl(action), odrl(use)))).
clause(31,
       mapped_role(purpose, dpv_healthcare, constraint(alpha_purpose_constraint)),
       (rdf_link(ex(alpha_care_process), dpv(hasPurpose), dpv('Healthcare')),
        odrl_constraint(alpha_purpose_constraint, odrl(purpose), dpv('Healthcare')))).
clause(32,
       mapped_role(legal_basis, dpv_consent, constraint(alpha_basis_constraint)),
       (rdf_link(ex(alpha_care_process), dpv(hasLegalBasis), dpv('Consent')),
        odrl_constraint(alpha_basis_constraint, ex(legalBasis), dpv('Consent')))).
clause(33,
       odrl_constraint(var('Name'), var('LeftOperand'), var('RightOperand')),
       (rdf_link(ex(alpha_permission), odrl(constraint), ex(var('Name'))),
        rdf_link(ex(var('Name')), odrl(leftOperand), var('LeftOperand')),
        rdf_link(ex(var('Name')), odrl(operator), odrl(isA)),
        rdf_link(ex(var('Name')), odrl(rightOperand), var('RightOperand')))).
clause(34,
       rdf_link(var('Subject'), var('Predicate'), var('Object')),
       (iri_term(var('Subject'), var('SubjectIri')),
        iri_term(var('Predicate'), var('PredicateIri')),
        rdf(iri(var('SubjectIri')), iri(var('PredicateIri')), iri(var('ObjectIri')), default_graph),
        iri_term(var('Object'), var('ObjectIri')))).
clause(35,
       iri_term(ex(var('Name')), var('Iri')),
       namespace_iri('https://example.org/', var('Name'), var('Iri'))).
clause(36,
       iri_term(dpv(var('Name')), var('Iri')),
       namespace_iri('https://w3id.org/dpv#', var('Name'), var('Iri'))).
clause(37,
       iri_term(odrl(var('Name')), var('Iri')),
       namespace_iri('http://www.w3.org/ns/odrl/2/', var('Name'), var('Iri'))).
clause(38,
       namespace_iri(var('Prefix'), var('Name'), var('Iri')),
       atom_concat(var('Prefix'), var('Name'), var('Iri'))).
clause(39,
       result_rdf(iri(var('Node')), iri('https://example.org/sourceRole'), iri(var('RoleIri')), default_graph),
       (mapped_role(var('Role'), anonymous(1), anonymous(2)),
        mapping_node(var('Role'), var('Node')),
        mapping_role_iri(var('Role'), var('RoleIri')))).
clause(40,
       result_rdf(iri(var('Node')), iri('https://example.org/value'), iri(var('ValueIri')), default_graph),
       (mapped_role(var('Role'), var('Value'), anonymous(1)),
        mapping_node(var('Role'), var('Node')),
        mapping_value_iri(var('Role'), var('Value'), var('ValueIri')))).
clause(41,
       result_rdf(iri(var('Node')), iri('https://example.org/mappingTarget'), iri(var('TargetIri')), default_graph),
       (mapped_role(var('Role'), anonymous(1), var('Target')),
        mapping_node(var('Role'), var('Node')),
        mapping_target_iri(var('Target'), var('TargetIri')))).
clause(42,
       mapping_node(var('Role'), var('Iri')),
       atom_concat('https://example.org/result/mapping/', var('Role'), var('Iri'))).
clause(43,
       mapping_role_iri(var('Role'), var('Iri')),
       atom_concat('https://example.org/role/', var('Role'), var('Iri'))).
clause(44,
       mapping_value_iri(data_controller, var('Value'), var('Iri')),
       iri_term(ex(var('Value')), var('Iri'))).
clause(45,
       mapping_value_iri(recipient, var('Value'), var('Iri')),
       iri_term(ex(var('Value')), var('Iri'))).
clause(46,
       mapping_value_iri(personal_data, var('Value'), var('Iri')),
       iri_term(ex(var('Value')), var('Iri'))).
clause(47, mapping_value_iri(processing, dpv_use, var('Iri')), iri_term(dpv('Use'), var('Iri'))).
clause(48,
       mapping_value_iri(purpose, dpv_healthcare, var('Iri')),
       iri_term(dpv('Healthcare'), var('Iri'))).
clause(49,
       mapping_value_iri(legal_basis, dpv_consent, var('Iri')),
       iri_term(dpv('Consent'), var('Iri'))).
clause(50, mapping_target_iri(assigner, var('Iri')), iri_term(odrl(assigner), var('Iri'))).
clause(51, mapping_target_iri(assignee, var('Iri')), iri_term(odrl(assignee), var('Iri'))).
clause(52, mapping_target_iri(target, var('Iri')), iri_term(odrl(target), var('Iri'))).
clause(53, mapping_target_iri(action, var('Iri')), iri_term(odrl(action), var('Iri'))).
clause(54,
       mapping_target_iri(constraint(var('Name')), var('Iri')),
       iri_term(ex(var('Name')), var('Iri'))).

step(result_rdf(iri('https://example.org/result/mapping/data_controller'), iri('https://example.org/sourceRole'), iri('https://example.org/role/data_controller'), default_graph),
     rule(39),
     ['Node' = 'https://example.org/result/mapping/data_controller',
      'RoleIri' = 'https://example.org/role/data_controller',
      'Role' = data_controller],
     [mapped_role(data_controller, hospital_a, assigner),
      mapping_node(data_controller, 'https://example.org/result/mapping/data_controller'),
      mapping_role_iri(data_controller, 'https://example.org/role/data_controller')]).
step(mapped_role(data_controller, hospital_a, assigner),
     rule(27),
     ['Controller' = hospital_a],
     [rdf_link(ex(alpha_care_process), dpv(hasDataController), ex(hospital_a)),
      rdf_link(ex(alpha_permission), odrl(assigner), ex(hospital_a))]).
step(rdf_link(ex(alpha_care_process), dpv(hasDataController), ex(hospital_a)),
     rule(34),
     ['Subject' = ex(alpha_care_process),
      'Predicate' = dpv(hasDataController),
      'Object' = ex(hospital_a),
      'SubjectIri' = 'https://example.org/alpha_care_process',
      'PredicateIri' = 'https://w3id.org/dpv#hasDataController',
      'ObjectIri' = 'https://example.org/hospital_a'],
     [iri_term(ex(alpha_care_process), 'https://example.org/alpha_care_process'),
      iri_term(dpv(hasDataController), 'https://w3id.org/dpv#hasDataController'),
      rdf(iri('https://example.org/alpha_care_process'), iri('https://w3id.org/dpv#hasDataController'), iri('https://example.org/hospital_a'), default_graph),
      iri_term(ex(hospital_a), 'https://example.org/hospital_a')]).
step(iri_term(ex(alpha_care_process), 'https://example.org/alpha_care_process'),
     rule(35),
     ['Name' = alpha_care_process, 'Iri' = 'https://example.org/alpha_care_process'],
     [namespace_iri('https://example.org/', alpha_care_process, 'https://example.org/alpha_care_process')]).
step(namespace_iri('https://example.org/', alpha_care_process, 'https://example.org/alpha_care_process'),
     rule(38),
     ['Prefix' = 'https://example.org/',
      'Name' = alpha_care_process,
      'Iri' = 'https://example.org/alpha_care_process'],
     [atom_concat('https://example.org/', alpha_care_process, 'https://example.org/alpha_care_process')]).
step(atom_concat('https://example.org/', alpha_care_process, 'https://example.org/alpha_care_process'),
     builtin,
     [],
     []).
step(iri_term(dpv(hasDataController), 'https://w3id.org/dpv#hasDataController'),
     rule(36),
     ['Name' = hasDataController, 'Iri' = 'https://w3id.org/dpv#hasDataController'],
     [namespace_iri('https://w3id.org/dpv#', hasDataController, 'https://w3id.org/dpv#hasDataController')]).
step(namespace_iri('https://w3id.org/dpv#', hasDataController, 'https://w3id.org/dpv#hasDataController'),
     rule(38),
     ['Prefix' = 'https://w3id.org/dpv#',
      'Name' = hasDataController,
      'Iri' = 'https://w3id.org/dpv#hasDataController'],
     [atom_concat('https://w3id.org/dpv#', hasDataController, 'https://w3id.org/dpv#hasDataController')]).
step(atom_concat('https://w3id.org/dpv#', hasDataController, 'https://w3id.org/dpv#hasDataController'),
     builtin,
     [],
     []).
step(rdf(iri('https://example.org/alpha_care_process'), iri('https://w3id.org/dpv#hasDataController'), iri('https://example.org/hospital_a'), default_graph),
     fact(2),
     [],
     []).
step(iri_term(ex(hospital_a), 'https://example.org/hospital_a'),
     rule(35),
     ['Name' = hospital_a, 'Iri' = 'https://example.org/hospital_a'],
     [namespace_iri('https://example.org/', hospital_a, 'https://example.org/hospital_a')]).
step(namespace_iri('https://example.org/', hospital_a, 'https://example.org/hospital_a'),
     rule(38),
     ['Prefix' = 'https://example.org/',
      'Name' = hospital_a,
      'Iri' = 'https://example.org/hospital_a'],
     [atom_concat('https://example.org/', hospital_a, 'https://example.org/hospital_a')]).
step(atom_concat('https://example.org/', hospital_a, 'https://example.org/hospital_a'),
     builtin,
     [],
     []).
step(rdf_link(ex(alpha_permission), odrl(assigner), ex(hospital_a)),
     rule(34),
     ['Subject' = ex(alpha_permission),
      'Predicate' = odrl(assigner),
      'Object' = ex(hospital_a),
      'SubjectIri' = 'https://example.org/alpha_permission',
      'PredicateIri' = 'http://www.w3.org/ns/odrl/2/assigner',
      'ObjectIri' = 'https://example.org/hospital_a'],
     [iri_term(ex(alpha_permission), 'https://example.org/alpha_permission'),
      iri_term(odrl(assigner), 'http://www.w3.org/ns/odrl/2/assigner'),
      rdf(iri('https://example.org/alpha_permission'), iri('http://www.w3.org/ns/odrl/2/assigner'), iri('https://example.org/hospital_a'), default_graph),
      iri_term(ex(hospital_a), 'https://example.org/hospital_a')]).
step(iri_term(ex(alpha_permission), 'https://example.org/alpha_permission'),
     rule(35),
     ['Name' = alpha_permission, 'Iri' = 'https://example.org/alpha_permission'],
     [namespace_iri('https://example.org/', alpha_permission, 'https://example.org/alpha_permission')]).
step(namespace_iri('https://example.org/', alpha_permission, 'https://example.org/alpha_permission'),
     rule(38),
     ['Prefix' = 'https://example.org/',
      'Name' = alpha_permission,
      'Iri' = 'https://example.org/alpha_permission'],
     [atom_concat('https://example.org/', alpha_permission, 'https://example.org/alpha_permission')]).
step(atom_concat('https://example.org/', alpha_permission, 'https://example.org/alpha_permission'),
     builtin,
     [],
     []).
step(iri_term(odrl(assigner), 'http://www.w3.org/ns/odrl/2/assigner'),
     rule(37),
     ['Name' = assigner, 'Iri' = 'http://www.w3.org/ns/odrl/2/assigner'],
     [namespace_iri('http://www.w3.org/ns/odrl/2/', assigner, 'http://www.w3.org/ns/odrl/2/assigner')]).
step(namespace_iri('http://www.w3.org/ns/odrl/2/', assigner, 'http://www.w3.org/ns/odrl/2/assigner'),
     rule(38),
     ['Prefix' = 'http://www.w3.org/ns/odrl/2/',
      'Name' = assigner,
      'Iri' = 'http://www.w3.org/ns/odrl/2/assigner'],
     [atom_concat('http://www.w3.org/ns/odrl/2/', assigner, 'http://www.w3.org/ns/odrl/2/assigner')]).
step(atom_concat('http://www.w3.org/ns/odrl/2/', assigner, 'http://www.w3.org/ns/odrl/2/assigner'),
     builtin,
     [],
     []).
step(rdf(iri('https://example.org/alpha_permission'), iri('http://www.w3.org/ns/odrl/2/assigner'), iri('https://example.org/hospital_a'), default_graph),
     fact(12),
     [],
     []).
step(mapping_node(data_controller, 'https://example.org/result/mapping/data_controller'),
     rule(42),
     ['Role' = data_controller, 'Iri' = 'https://example.org/result/mapping/data_controller'],
     [atom_concat('https://example.org/result/mapping/', data_controller, 'https://example.org/result/mapping/data_controller')]).
step(atom_concat('https://example.org/result/mapping/', data_controller, 'https://example.org/result/mapping/data_controller'),
     builtin,
     [],
     []).
step(mapping_role_iri(data_controller, 'https://example.org/role/data_controller'),
     rule(43),
     ['Role' = data_controller, 'Iri' = 'https://example.org/role/data_controller'],
     [atom_concat('https://example.org/role/', data_controller, 'https://example.org/role/data_controller')]).
step(atom_concat('https://example.org/role/', data_controller, 'https://example.org/role/data_controller'),
     builtin,
     [],
     []).
step(result_rdf(iri('https://example.org/result/mapping/recipient'), iri('https://example.org/sourceRole'), iri('https://example.org/role/recipient'), default_graph),
     rule(39),
     ['Node' = 'https://example.org/result/mapping/recipient',
      'RoleIri' = 'https://example.org/role/recipient',
      'Role' = recipient],
     [mapped_role(recipient, research_partner, assignee),
      mapping_node(recipient, 'https://example.org/result/mapping/recipient'),
      mapping_role_iri(recipient, 'https://example.org/role/recipient')]).
step(mapped_role(recipient, research_partner, assignee),
     rule(28),
     ['Recipient' = research_partner],
     [rdf_link(ex(alpha_care_process), dpv(hasRecipient), ex(research_partner)),
      rdf_link(ex(alpha_permission), odrl(assignee), ex(research_partner))]).
step(rdf_link(ex(alpha_care_process), dpv(hasRecipient), ex(research_partner)),
     rule(34),
     ['Subject' = ex(alpha_care_process),
      'Predicate' = dpv(hasRecipient),
      'Object' = ex(research_partner),
      'SubjectIri' = 'https://example.org/alpha_care_process',
      'PredicateIri' = 'https://w3id.org/dpv#hasRecipient',
      'ObjectIri' = 'https://example.org/research_partner'],
     [iri_term(ex(alpha_care_process), 'https://example.org/alpha_care_process'),
      iri_term(dpv(hasRecipient), 'https://w3id.org/dpv#hasRecipient'),
      rdf(iri('https://example.org/alpha_care_process'), iri('https://w3id.org/dpv#hasRecipient'), iri('https://example.org/research_partner'), default_graph),
      iri_term(ex(research_partner), 'https://example.org/research_partner')]).
step(iri_term(dpv(hasRecipient), 'https://w3id.org/dpv#hasRecipient'),
     rule(36),
     ['Name' = hasRecipient, 'Iri' = 'https://w3id.org/dpv#hasRecipient'],
     [namespace_iri('https://w3id.org/dpv#', hasRecipient, 'https://w3id.org/dpv#hasRecipient')]).
step(namespace_iri('https://w3id.org/dpv#', hasRecipient, 'https://w3id.org/dpv#hasRecipient'),
     rule(38),
     ['Prefix' = 'https://w3id.org/dpv#',
      'Name' = hasRecipient,
      'Iri' = 'https://w3id.org/dpv#hasRecipient'],
     [atom_concat('https://w3id.org/dpv#', hasRecipient, 'https://w3id.org/dpv#hasRecipient')]).
step(atom_concat('https://w3id.org/dpv#', hasRecipient, 'https://w3id.org/dpv#hasRecipient'),
     builtin,
     [],
     []).
step(rdf(iri('https://example.org/alpha_care_process'), iri('https://w3id.org/dpv#hasRecipient'), iri('https://example.org/research_partner'), default_graph),
     fact(3),
     [],
     []).
step(iri_term(ex(research_partner), 'https://example.org/research_partner'),
     rule(35),
     ['Name' = research_partner, 'Iri' = 'https://example.org/research_partner'],
     [namespace_iri('https://example.org/', research_partner, 'https://example.org/research_partner')]).
step(namespace_iri('https://example.org/', research_partner, 'https://example.org/research_partner'),
     rule(38),
     ['Prefix' = 'https://example.org/',
      'Name' = research_partner,
      'Iri' = 'https://example.org/research_partner'],
     [atom_concat('https://example.org/', research_partner, 'https://example.org/research_partner')]).
step(atom_concat('https://example.org/', research_partner, 'https://example.org/research_partner'),
     builtin,
     [],
     []).
step(rdf_link(ex(alpha_permission), odrl(assignee), ex(research_partner)),
     rule(34),
     ['Subject' = ex(alpha_permission),
      'Predicate' = odrl(assignee),
      'Object' = ex(research_partner),
      'SubjectIri' = 'https://example.org/alpha_permission',
      'PredicateIri' = 'http://www.w3.org/ns/odrl/2/assignee',
      'ObjectIri' = 'https://example.org/research_partner'],
     [iri_term(ex(alpha_permission), 'https://example.org/alpha_permission'),
      iri_term(odrl(assignee), 'http://www.w3.org/ns/odrl/2/assignee'),
      rdf(iri('https://example.org/alpha_permission'), iri('http://www.w3.org/ns/odrl/2/assignee'), iri('https://example.org/research_partner'), default_graph),
      iri_term(ex(research_partner), 'https://example.org/research_partner')]).
step(iri_term(odrl(assignee), 'http://www.w3.org/ns/odrl/2/assignee'),
     rule(37),
     ['Name' = assignee, 'Iri' = 'http://www.w3.org/ns/odrl/2/assignee'],
     [namespace_iri('http://www.w3.org/ns/odrl/2/', assignee, 'http://www.w3.org/ns/odrl/2/assignee')]).
step(namespace_iri('http://www.w3.org/ns/odrl/2/', assignee, 'http://www.w3.org/ns/odrl/2/assignee'),
     rule(38),
     ['Prefix' = 'http://www.w3.org/ns/odrl/2/',
      'Name' = assignee,
      'Iri' = 'http://www.w3.org/ns/odrl/2/assignee'],
     [atom_concat('http://www.w3.org/ns/odrl/2/', assignee, 'http://www.w3.org/ns/odrl/2/assignee')]).
step(atom_concat('http://www.w3.org/ns/odrl/2/', assignee, 'http://www.w3.org/ns/odrl/2/assignee'),
     builtin,
     [],
     []).
step(rdf(iri('https://example.org/alpha_permission'), iri('http://www.w3.org/ns/odrl/2/assignee'), iri('https://example.org/research_partner'), default_graph),
     fact(13),
     [],
     []).
step(mapping_node(recipient, 'https://example.org/result/mapping/recipient'),
     rule(42),
     ['Role' = recipient, 'Iri' = 'https://example.org/result/mapping/recipient'],
     [atom_concat('https://example.org/result/mapping/', recipient, 'https://example.org/result/mapping/recipient')]).
step(atom_concat('https://example.org/result/mapping/', recipient, 'https://example.org/result/mapping/recipient'),
     builtin,
     [],
     []).
step(mapping_role_iri(recipient, 'https://example.org/role/recipient'),
     rule(43),
     ['Role' = recipient, 'Iri' = 'https://example.org/role/recipient'],
     [atom_concat('https://example.org/role/', recipient, 'https://example.org/role/recipient')]).
step(atom_concat('https://example.org/role/', recipient, 'https://example.org/role/recipient'),
     builtin,
     [],
     []).
step(result_rdf(iri('https://example.org/result/mapping/personal_data'), iri('https://example.org/sourceRole'), iri('https://example.org/role/personal_data'), default_graph),
     rule(39),
     ['Node' = 'https://example.org/result/mapping/personal_data',
      'RoleIri' = 'https://example.org/role/personal_data',
      'Role' = personal_data],
     [mapped_role(personal_data, lab_result, target),
      mapping_node(personal_data, 'https://example.org/result/mapping/personal_data'),
      mapping_role_iri(personal_data, 'https://example.org/role/personal_data')]).
step(mapped_role(personal_data, lab_result, target),
     rule(29),
     ['Data' = lab_result],
     [rdf_link(ex(alpha_care_process), dpv(hasPersonalData), ex(lab_result)),
      rdf_link(ex(alpha_permission), odrl(target), ex(lab_result))]).
step(rdf_link(ex(alpha_care_process), dpv(hasPersonalData), ex(lab_result)),
     rule(34),
     ['Subject' = ex(alpha_care_process),
      'Predicate' = dpv(hasPersonalData),
      'Object' = ex(lab_result),
      'SubjectIri' = 'https://example.org/alpha_care_process',
      'PredicateIri' = 'https://w3id.org/dpv#hasPersonalData',
      'ObjectIri' = 'https://example.org/lab_result'],
     [iri_term(ex(alpha_care_process), 'https://example.org/alpha_care_process'),
      iri_term(dpv(hasPersonalData), 'https://w3id.org/dpv#hasPersonalData'),
      rdf(iri('https://example.org/alpha_care_process'), iri('https://w3id.org/dpv#hasPersonalData'), iri('https://example.org/lab_result'), default_graph),
      iri_term(ex(lab_result), 'https://example.org/lab_result')]).
step(iri_term(dpv(hasPersonalData), 'https://w3id.org/dpv#hasPersonalData'),
     rule(36),
     ['Name' = hasPersonalData, 'Iri' = 'https://w3id.org/dpv#hasPersonalData'],
     [namespace_iri('https://w3id.org/dpv#', hasPersonalData, 'https://w3id.org/dpv#hasPersonalData')]).
step(namespace_iri('https://w3id.org/dpv#', hasPersonalData, 'https://w3id.org/dpv#hasPersonalData'),
     rule(38),
     ['Prefix' = 'https://w3id.org/dpv#',
      'Name' = hasPersonalData,
      'Iri' = 'https://w3id.org/dpv#hasPersonalData'],
     [atom_concat('https://w3id.org/dpv#', hasPersonalData, 'https://w3id.org/dpv#hasPersonalData')]).
step(atom_concat('https://w3id.org/dpv#', hasPersonalData, 'https://w3id.org/dpv#hasPersonalData'),
     builtin,
     [],
     []).
step(rdf(iri('https://example.org/alpha_care_process'), iri('https://w3id.org/dpv#hasPersonalData'), iri('https://example.org/lab_result'), default_graph),
     fact(4),
     [],
     []).
step(iri_term(ex(lab_result), 'https://example.org/lab_result'),
     rule(35),
     ['Name' = lab_result, 'Iri' = 'https://example.org/lab_result'],
     [namespace_iri('https://example.org/', lab_result, 'https://example.org/lab_result')]).
step(namespace_iri('https://example.org/', lab_result, 'https://example.org/lab_result'),
     rule(38),
     ['Prefix' = 'https://example.org/',
      'Name' = lab_result,
      'Iri' = 'https://example.org/lab_result'],
     [atom_concat('https://example.org/', lab_result, 'https://example.org/lab_result')]).
step(atom_concat('https://example.org/', lab_result, 'https://example.org/lab_result'),
     builtin,
     [],
     []).
step(rdf_link(ex(alpha_permission), odrl(target), ex(lab_result)),
     rule(34),
     ['Subject' = ex(alpha_permission),
      'Predicate' = odrl(target),
      'Object' = ex(lab_result),
      'SubjectIri' = 'https://example.org/alpha_permission',
      'PredicateIri' = 'http://www.w3.org/ns/odrl/2/target',
      'ObjectIri' = 'https://example.org/lab_result'],
     [iri_term(ex(alpha_permission), 'https://example.org/alpha_permission'),
      iri_term(odrl(target), 'http://www.w3.org/ns/odrl/2/target'),
      rdf(iri('https://example.org/alpha_permission'), iri('http://www.w3.org/ns/odrl/2/target'), iri('https://example.org/lab_result'), default_graph),
      iri_term(ex(lab_result), 'https://example.org/lab_result')]).
step(iri_term(odrl(target), 'http://www.w3.org/ns/odrl/2/target'),
     rule(37),
     ['Name' = target, 'Iri' = 'http://www.w3.org/ns/odrl/2/target'],
     [namespace_iri('http://www.w3.org/ns/odrl/2/', target, 'http://www.w3.org/ns/odrl/2/target')]).
step(namespace_iri('http://www.w3.org/ns/odrl/2/', target, 'http://www.w3.org/ns/odrl/2/target'),
     rule(38),
     ['Prefix' = 'http://www.w3.org/ns/odrl/2/',
      'Name' = target,
      'Iri' = 'http://www.w3.org/ns/odrl/2/target'],
     [atom_concat('http://www.w3.org/ns/odrl/2/', target, 'http://www.w3.org/ns/odrl/2/target')]).
step(atom_concat('http://www.w3.org/ns/odrl/2/', target, 'http://www.w3.org/ns/odrl/2/target'),
     builtin,
     [],
     []).
step(rdf(iri('https://example.org/alpha_permission'), iri('http://www.w3.org/ns/odrl/2/target'), iri('https://example.org/lab_result'), default_graph),
     fact(14),
     [],
     []).
step(mapping_node(personal_data, 'https://example.org/result/mapping/personal_data'),
     rule(42),
     ['Role' = personal_data, 'Iri' = 'https://example.org/result/mapping/personal_data'],
     [atom_concat('https://example.org/result/mapping/', personal_data, 'https://example.org/result/mapping/personal_data')]).
step(atom_concat('https://example.org/result/mapping/', personal_data, 'https://example.org/result/mapping/personal_data'),
     builtin,
     [],
     []).
step(mapping_role_iri(personal_data, 'https://example.org/role/personal_data'),
     rule(43),
     ['Role' = personal_data, 'Iri' = 'https://example.org/role/personal_data'],
     [atom_concat('https://example.org/role/', personal_data, 'https://example.org/role/personal_data')]).
step(atom_concat('https://example.org/role/', personal_data, 'https://example.org/role/personal_data'),
     builtin,
     [],
     []).
step(result_rdf(iri('https://example.org/result/mapping/processing'), iri('https://example.org/sourceRole'), iri('https://example.org/role/processing'), default_graph),
     rule(39),
     ['Node' = 'https://example.org/result/mapping/processing',
      'RoleIri' = 'https://example.org/role/processing',
      'Role' = processing],
     [mapped_role(processing, dpv_use, action),
      mapping_node(processing, 'https://example.org/result/mapping/processing'),
      mapping_role_iri(processing, 'https://example.org/role/processing')]).
step(mapped_role(processing, dpv_use, action),
     rule(30),
     [],
     [rdf_link(ex(alpha_care_process), dpv(hasProcessing), dpv('Use')),
      rdf_link(ex(alpha_permission), odrl(action), odrl(use))]).
step(rdf_link(ex(alpha_care_process), dpv(hasProcessing), dpv('Use')),
     rule(34),
     ['Subject' = ex(alpha_care_process),
      'Predicate' = dpv(hasProcessing),
      'Object' = dpv('Use'),
      'SubjectIri' = 'https://example.org/alpha_care_process',
      'PredicateIri' = 'https://w3id.org/dpv#hasProcessing',
      'ObjectIri' = 'https://w3id.org/dpv#Use'],
     [iri_term(ex(alpha_care_process), 'https://example.org/alpha_care_process'),
      iri_term(dpv(hasProcessing), 'https://w3id.org/dpv#hasProcessing'),
      rdf(iri('https://example.org/alpha_care_process'), iri('https://w3id.org/dpv#hasProcessing'), iri('https://w3id.org/dpv#Use'), default_graph),
      iri_term(dpv('Use'), 'https://w3id.org/dpv#Use')]).
step(iri_term(dpv(hasProcessing), 'https://w3id.org/dpv#hasProcessing'),
     rule(36),
     ['Name' = hasProcessing, 'Iri' = 'https://w3id.org/dpv#hasProcessing'],
     [namespace_iri('https://w3id.org/dpv#', hasProcessing, 'https://w3id.org/dpv#hasProcessing')]).
step(namespace_iri('https://w3id.org/dpv#', hasProcessing, 'https://w3id.org/dpv#hasProcessing'),
     rule(38),
     ['Prefix' = 'https://w3id.org/dpv#',
      'Name' = hasProcessing,
      'Iri' = 'https://w3id.org/dpv#hasProcessing'],
     [atom_concat('https://w3id.org/dpv#', hasProcessing, 'https://w3id.org/dpv#hasProcessing')]).
step(atom_concat('https://w3id.org/dpv#', hasProcessing, 'https://w3id.org/dpv#hasProcessing'),
     builtin,
     [],
     []).
step(rdf(iri('https://example.org/alpha_care_process'), iri('https://w3id.org/dpv#hasProcessing'), iri('https://w3id.org/dpv#Use'), default_graph),
     fact(5),
     [],
     []).
step(iri_term(dpv('Use'), 'https://w3id.org/dpv#Use'),
     rule(36),
     ['Name' = 'Use', 'Iri' = 'https://w3id.org/dpv#Use'],
     [namespace_iri('https://w3id.org/dpv#', 'Use', 'https://w3id.org/dpv#Use')]).
step(namespace_iri('https://w3id.org/dpv#', 'Use', 'https://w3id.org/dpv#Use'),
     rule(38),
     ['Prefix' = 'https://w3id.org/dpv#', 'Name' = 'Use', 'Iri' = 'https://w3id.org/dpv#Use'],
     [atom_concat('https://w3id.org/dpv#', 'Use', 'https://w3id.org/dpv#Use')]).
step(atom_concat('https://w3id.org/dpv#', 'Use', 'https://w3id.org/dpv#Use'), builtin, [], []).
step(rdf_link(ex(alpha_permission), odrl(action), odrl(use)),
     rule(34),
     ['Subject' = ex(alpha_permission),
      'Predicate' = odrl(action),
      'Object' = odrl(use),
      'SubjectIri' = 'https://example.org/alpha_permission',
      'PredicateIri' = 'http://www.w3.org/ns/odrl/2/action',
      'ObjectIri' = 'http://www.w3.org/ns/odrl/2/use'],
     [iri_term(ex(alpha_permission), 'https://example.org/alpha_permission'),
      iri_term(odrl(action), 'http://www.w3.org/ns/odrl/2/action'),
      rdf(iri('https://example.org/alpha_permission'), iri('http://www.w3.org/ns/odrl/2/action'), iri('http://www.w3.org/ns/odrl/2/use'), default_graph),
      iri_term(odrl(use), 'http://www.w3.org/ns/odrl/2/use')]).
step(iri_term(odrl(action), 'http://www.w3.org/ns/odrl/2/action'),
     rule(37),
     ['Name' = action, 'Iri' = 'http://www.w3.org/ns/odrl/2/action'],
     [namespace_iri('http://www.w3.org/ns/odrl/2/', action, 'http://www.w3.org/ns/odrl/2/action')]).
step(namespace_iri('http://www.w3.org/ns/odrl/2/', action, 'http://www.w3.org/ns/odrl/2/action'),
     rule(38),
     ['Prefix' = 'http://www.w3.org/ns/odrl/2/',
      'Name' = action,
      'Iri' = 'http://www.w3.org/ns/odrl/2/action'],
     [atom_concat('http://www.w3.org/ns/odrl/2/', action, 'http://www.w3.org/ns/odrl/2/action')]).
step(atom_concat('http://www.w3.org/ns/odrl/2/', action, 'http://www.w3.org/ns/odrl/2/action'),
     builtin,
     [],
     []).
step(rdf(iri('https://example.org/alpha_permission'), iri('http://www.w3.org/ns/odrl/2/action'), iri('http://www.w3.org/ns/odrl/2/use'), default_graph),
     fact(15),
     [],
     []).
step(iri_term(odrl(use), 'http://www.w3.org/ns/odrl/2/use'),
     rule(37),
     ['Name' = use, 'Iri' = 'http://www.w3.org/ns/odrl/2/use'],
     [namespace_iri('http://www.w3.org/ns/odrl/2/', use, 'http://www.w3.org/ns/odrl/2/use')]).
step(namespace_iri('http://www.w3.org/ns/odrl/2/', use, 'http://www.w3.org/ns/odrl/2/use'),
     rule(38),
     ['Prefix' = 'http://www.w3.org/ns/odrl/2/',
      'Name' = use,
      'Iri' = 'http://www.w3.org/ns/odrl/2/use'],
     [atom_concat('http://www.w3.org/ns/odrl/2/', use, 'http://www.w3.org/ns/odrl/2/use')]).
step(atom_concat('http://www.w3.org/ns/odrl/2/', use, 'http://www.w3.org/ns/odrl/2/use'),
     builtin,
     [],
     []).
step(mapping_node(processing, 'https://example.org/result/mapping/processing'),
     rule(42),
     ['Role' = processing, 'Iri' = 'https://example.org/result/mapping/processing'],
     [atom_concat('https://example.org/result/mapping/', processing, 'https://example.org/result/mapping/processing')]).
step(atom_concat('https://example.org/result/mapping/', processing, 'https://example.org/result/mapping/processing'),
     builtin,
     [],
     []).
step(mapping_role_iri(processing, 'https://example.org/role/processing'),
     rule(43),
     ['Role' = processing, 'Iri' = 'https://example.org/role/processing'],
     [atom_concat('https://example.org/role/', processing, 'https://example.org/role/processing')]).
step(atom_concat('https://example.org/role/', processing, 'https://example.org/role/processing'),
     builtin,
     [],
     []).
step(result_rdf(iri('https://example.org/result/mapping/purpose'), iri('https://example.org/sourceRole'), iri('https://example.org/role/purpose'), default_graph),
     rule(39),
     ['Node' = 'https://example.org/result/mapping/purpose',
      'RoleIri' = 'https://example.org/role/purpose',
      'Role' = purpose],
     [mapped_role(purpose, dpv_healthcare, constraint(alpha_purpose_constraint)),
      mapping_node(purpose, 'https://example.org/result/mapping/purpose'),
      mapping_role_iri(purpose, 'https://example.org/role/purpose')]).
step(mapped_role(purpose, dpv_healthcare, constraint(alpha_purpose_constraint)),
     rule(31),
     [],
     [rdf_link(ex(alpha_care_process), dpv(hasPurpose), dpv('Healthcare')),
      odrl_constraint(alpha_purpose_constraint, odrl(purpose), dpv('Healthcare'))]).
step(rdf_link(ex(alpha_care_process), dpv(hasPurpose), dpv('Healthcare')),
     rule(34),
     ['Subject' = ex(alpha_care_process),
      'Predicate' = dpv(hasPurpose),
      'Object' = dpv('Healthcare'),
      'SubjectIri' = 'https://example.org/alpha_care_process',
      'PredicateIri' = 'https://w3id.org/dpv#hasPurpose',
      'ObjectIri' = 'https://w3id.org/dpv#Healthcare'],
     [iri_term(ex(alpha_care_process), 'https://example.org/alpha_care_process'),
      iri_term(dpv(hasPurpose), 'https://w3id.org/dpv#hasPurpose'),
      rdf(iri('https://example.org/alpha_care_process'), iri('https://w3id.org/dpv#hasPurpose'), iri('https://w3id.org/dpv#Healthcare'), default_graph),
      iri_term(dpv('Healthcare'), 'https://w3id.org/dpv#Healthcare')]).
step(iri_term(dpv(hasPurpose), 'https://w3id.org/dpv#hasPurpose'),
     rule(36),
     ['Name' = hasPurpose, 'Iri' = 'https://w3id.org/dpv#hasPurpose'],
     [namespace_iri('https://w3id.org/dpv#', hasPurpose, 'https://w3id.org/dpv#hasPurpose')]).
step(namespace_iri('https://w3id.org/dpv#', hasPurpose, 'https://w3id.org/dpv#hasPurpose'),
     rule(38),
     ['Prefix' = 'https://w3id.org/dpv#',
      'Name' = hasPurpose,
      'Iri' = 'https://w3id.org/dpv#hasPurpose'],
     [atom_concat('https://w3id.org/dpv#', hasPurpose, 'https://w3id.org/dpv#hasPurpose')]).
step(atom_concat('https://w3id.org/dpv#', hasPurpose, 'https://w3id.org/dpv#hasPurpose'),
     builtin,
     [],
     []).
step(rdf(iri('https://example.org/alpha_care_process'), iri('https://w3id.org/dpv#hasPurpose'), iri('https://w3id.org/dpv#Healthcare'), default_graph),
     fact(6),
     [],
     []).
step(iri_term(dpv('Healthcare'), 'https://w3id.org/dpv#Healthcare'),
     rule(36),
     ['Name' = 'Healthcare', 'Iri' = 'https://w3id.org/dpv#Healthcare'],
     [namespace_iri('https://w3id.org/dpv#', 'Healthcare', 'https://w3id.org/dpv#Healthcare')]).
step(namespace_iri('https://w3id.org/dpv#', 'Healthcare', 'https://w3id.org/dpv#Healthcare'),
     rule(38),
     ['Prefix' = 'https://w3id.org/dpv#',
      'Name' = 'Healthcare',
      'Iri' = 'https://w3id.org/dpv#Healthcare'],
     [atom_concat('https://w3id.org/dpv#', 'Healthcare', 'https://w3id.org/dpv#Healthcare')]).
step(atom_concat('https://w3id.org/dpv#', 'Healthcare', 'https://w3id.org/dpv#Healthcare'),
     builtin,
     [],
     []).
step(odrl_constraint(alpha_purpose_constraint, odrl(purpose), dpv('Healthcare')),
     rule(33),
     ['Name' = alpha_purpose_constraint,
      'LeftOperand' = odrl(purpose),
      'RightOperand' = dpv('Healthcare')],
     [rdf_link(ex(alpha_permission), odrl(constraint), ex(alpha_purpose_constraint)),
      rdf_link(ex(alpha_purpose_constraint), odrl(leftOperand), odrl(purpose)),
      rdf_link(ex(alpha_purpose_constraint), odrl(operator), odrl(isA)),
      rdf_link(ex(alpha_purpose_constraint), odrl(rightOperand), dpv('Healthcare'))]).
step(rdf_link(ex(alpha_permission), odrl(constraint), ex(alpha_purpose_constraint)),
     rule(34),
     ['Subject' = ex(alpha_permission),
      'Predicate' = odrl(constraint),
      'Object' = ex(alpha_purpose_constraint),
      'SubjectIri' = 'https://example.org/alpha_permission',
      'PredicateIri' = 'http://www.w3.org/ns/odrl/2/constraint',
      'ObjectIri' = 'https://example.org/alpha_purpose_constraint'],
     [iri_term(ex(alpha_permission), 'https://example.org/alpha_permission'),
      iri_term(odrl(constraint), 'http://www.w3.org/ns/odrl/2/constraint'),
      rdf(iri('https://example.org/alpha_permission'), iri('http://www.w3.org/ns/odrl/2/constraint'), iri('https://example.org/alpha_purpose_constraint'), default_graph),
      iri_term(ex(alpha_purpose_constraint), 'https://example.org/alpha_purpose_constraint')]).
step(iri_term(odrl(constraint), 'http://www.w3.org/ns/odrl/2/constraint'),
     rule(37),
     ['Name' = constraint, 'Iri' = 'http://www.w3.org/ns/odrl/2/constraint'],
     [namespace_iri('http://www.w3.org/ns/odrl/2/', constraint, 'http://www.w3.org/ns/odrl/2/constraint')]).
step(namespace_iri('http://www.w3.org/ns/odrl/2/', constraint, 'http://www.w3.org/ns/odrl/2/constraint'),
     rule(38),
     ['Prefix' = 'http://www.w3.org/ns/odrl/2/',
      'Name' = constraint,
      'Iri' = 'http://www.w3.org/ns/odrl/2/constraint'],
     [atom_concat('http://www.w3.org/ns/odrl/2/', constraint, 'http://www.w3.org/ns/odrl/2/constraint')]).
step(atom_concat('http://www.w3.org/ns/odrl/2/', constraint, 'http://www.w3.org/ns/odrl/2/constraint'),
     builtin,
     [],
     []).
step(rdf(iri('https://example.org/alpha_permission'), iri('http://www.w3.org/ns/odrl/2/constraint'), iri('https://example.org/alpha_purpose_constraint'), default_graph),
     fact(16),
     [],
     []).
step(iri_term(ex(alpha_purpose_constraint), 'https://example.org/alpha_purpose_constraint'),
     rule(35),
     ['Name' = alpha_purpose_constraint, 'Iri' = 'https://example.org/alpha_purpose_constraint'],
     [namespace_iri('https://example.org/', alpha_purpose_constraint, 'https://example.org/alpha_purpose_constraint')]).
step(namespace_iri('https://example.org/', alpha_purpose_constraint, 'https://example.org/alpha_purpose_constraint'),
     rule(38),
     ['Prefix' = 'https://example.org/',
      'Name' = alpha_purpose_constraint,
      'Iri' = 'https://example.org/alpha_purpose_constraint'],
     [atom_concat('https://example.org/', alpha_purpose_constraint, 'https://example.org/alpha_purpose_constraint')]).
step(atom_concat('https://example.org/', alpha_purpose_constraint, 'https://example.org/alpha_purpose_constraint'),
     builtin,
     [],
     []).
step(rdf_link(ex(alpha_purpose_constraint), odrl(leftOperand), odrl(purpose)),
     rule(34),
     ['Subject' = ex(alpha_purpose_constraint),
      'Predicate' = odrl(leftOperand),
      'Object' = odrl(purpose),
      'SubjectIri' = 'https://example.org/alpha_purpose_constraint',
      'PredicateIri' = 'http://www.w3.org/ns/odrl/2/leftOperand',
      'ObjectIri' = 'http://www.w3.org/ns/odrl/2/purpose'],
     [iri_term(ex(alpha_purpose_constraint), 'https://example.org/alpha_purpose_constraint'),
      iri_term(odrl(leftOperand), 'http://www.w3.org/ns/odrl/2/leftOperand'),
      rdf(iri('https://example.org/alpha_purpose_constraint'), iri('http://www.w3.org/ns/odrl/2/leftOperand'), iri('http://www.w3.org/ns/odrl/2/purpose'), default_graph),
      iri_term(odrl(purpose), 'http://www.w3.org/ns/odrl/2/purpose')]).
step(iri_term(odrl(leftOperand), 'http://www.w3.org/ns/odrl/2/leftOperand'),
     rule(37),
     ['Name' = leftOperand, 'Iri' = 'http://www.w3.org/ns/odrl/2/leftOperand'],
     [namespace_iri('http://www.w3.org/ns/odrl/2/', leftOperand, 'http://www.w3.org/ns/odrl/2/leftOperand')]).
step(namespace_iri('http://www.w3.org/ns/odrl/2/', leftOperand, 'http://www.w3.org/ns/odrl/2/leftOperand'),
     rule(38),
     ['Prefix' = 'http://www.w3.org/ns/odrl/2/',
      'Name' = leftOperand,
      'Iri' = 'http://www.w3.org/ns/odrl/2/leftOperand'],
     [atom_concat('http://www.w3.org/ns/odrl/2/', leftOperand, 'http://www.w3.org/ns/odrl/2/leftOperand')]).
step(atom_concat('http://www.w3.org/ns/odrl/2/', leftOperand, 'http://www.w3.org/ns/odrl/2/leftOperand'),
     builtin,
     [],
     []).
step(rdf(iri('https://example.org/alpha_purpose_constraint'), iri('http://www.w3.org/ns/odrl/2/leftOperand'), iri('http://www.w3.org/ns/odrl/2/purpose'), default_graph),
     fact(19),
     [],
     []).
step(iri_term(odrl(purpose), 'http://www.w3.org/ns/odrl/2/purpose'),
     rule(37),
     ['Name' = purpose, 'Iri' = 'http://www.w3.org/ns/odrl/2/purpose'],
     [namespace_iri('http://www.w3.org/ns/odrl/2/', purpose, 'http://www.w3.org/ns/odrl/2/purpose')]).
step(namespace_iri('http://www.w3.org/ns/odrl/2/', purpose, 'http://www.w3.org/ns/odrl/2/purpose'),
     rule(38),
     ['Prefix' = 'http://www.w3.org/ns/odrl/2/',
      'Name' = purpose,
      'Iri' = 'http://www.w3.org/ns/odrl/2/purpose'],
     [atom_concat('http://www.w3.org/ns/odrl/2/', purpose, 'http://www.w3.org/ns/odrl/2/purpose')]).
step(atom_concat('http://www.w3.org/ns/odrl/2/', purpose, 'http://www.w3.org/ns/odrl/2/purpose'),
     builtin,
     [],
     []).
step(rdf_link(ex(alpha_purpose_constraint), odrl(operator), odrl(isA)),
     rule(34),
     ['Subject' = ex(alpha_purpose_constraint),
      'Predicate' = odrl(operator),
      'Object' = odrl(isA),
      'SubjectIri' = 'https://example.org/alpha_purpose_constraint',
      'PredicateIri' = 'http://www.w3.org/ns/odrl/2/operator',
      'ObjectIri' = 'http://www.w3.org/ns/odrl/2/isA'],
     [iri_term(ex(alpha_purpose_constraint), 'https://example.org/alpha_purpose_constraint'),
      iri_term(odrl(operator), 'http://www.w3.org/ns/odrl/2/operator'),
      rdf(iri('https://example.org/alpha_purpose_constraint'), iri('http://www.w3.org/ns/odrl/2/operator'), iri('http://www.w3.org/ns/odrl/2/isA'), default_graph),
      iri_term(odrl(isA), 'http://www.w3.org/ns/odrl/2/isA')]).
step(iri_term(odrl(operator), 'http://www.w3.org/ns/odrl/2/operator'),
     rule(37),
     ['Name' = operator, 'Iri' = 'http://www.w3.org/ns/odrl/2/operator'],
     [namespace_iri('http://www.w3.org/ns/odrl/2/', operator, 'http://www.w3.org/ns/odrl/2/operator')]).
step(namespace_iri('http://www.w3.org/ns/odrl/2/', operator, 'http://www.w3.org/ns/odrl/2/operator'),
     rule(38),
     ['Prefix' = 'http://www.w3.org/ns/odrl/2/',
      'Name' = operator,
      'Iri' = 'http://www.w3.org/ns/odrl/2/operator'],
     [atom_concat('http://www.w3.org/ns/odrl/2/', operator, 'http://www.w3.org/ns/odrl/2/operator')]).
step(atom_concat('http://www.w3.org/ns/odrl/2/', operator, 'http://www.w3.org/ns/odrl/2/operator'),
     builtin,
     [],
     []).
step(rdf(iri('https://example.org/alpha_purpose_constraint'), iri('http://www.w3.org/ns/odrl/2/operator'), iri('http://www.w3.org/ns/odrl/2/isA'), default_graph),
     fact(20),
     [],
     []).
step(iri_term(odrl(isA), 'http://www.w3.org/ns/odrl/2/isA'),
     rule(37),
     ['Name' = isA, 'Iri' = 'http://www.w3.org/ns/odrl/2/isA'],
     [namespace_iri('http://www.w3.org/ns/odrl/2/', isA, 'http://www.w3.org/ns/odrl/2/isA')]).
step(namespace_iri('http://www.w3.org/ns/odrl/2/', isA, 'http://www.w3.org/ns/odrl/2/isA'),
     rule(38),
     ['Prefix' = 'http://www.w3.org/ns/odrl/2/',
      'Name' = isA,
      'Iri' = 'http://www.w3.org/ns/odrl/2/isA'],
     [atom_concat('http://www.w3.org/ns/odrl/2/', isA, 'http://www.w3.org/ns/odrl/2/isA')]).
step(atom_concat('http://www.w3.org/ns/odrl/2/', isA, 'http://www.w3.org/ns/odrl/2/isA'),
     builtin,
     [],
     []).
step(rdf_link(ex(alpha_purpose_constraint), odrl(rightOperand), dpv('Healthcare')),
     rule(34),
     ['Subject' = ex(alpha_purpose_constraint),
      'Predicate' = odrl(rightOperand),
      'Object' = dpv('Healthcare'),
      'SubjectIri' = 'https://example.org/alpha_purpose_constraint',
      'PredicateIri' = 'http://www.w3.org/ns/odrl/2/rightOperand',
      'ObjectIri' = 'https://w3id.org/dpv#Healthcare'],
     [iri_term(ex(alpha_purpose_constraint), 'https://example.org/alpha_purpose_constraint'),
      iri_term(odrl(rightOperand), 'http://www.w3.org/ns/odrl/2/rightOperand'),
      rdf(iri('https://example.org/alpha_purpose_constraint'), iri('http://www.w3.org/ns/odrl/2/rightOperand'), iri('https://w3id.org/dpv#Healthcare'), default_graph),
      iri_term(dpv('Healthcare'), 'https://w3id.org/dpv#Healthcare')]).
step(iri_term(odrl(rightOperand), 'http://www.w3.org/ns/odrl/2/rightOperand'),
     rule(37),
     ['Name' = rightOperand, 'Iri' = 'http://www.w3.org/ns/odrl/2/rightOperand'],
     [namespace_iri('http://www.w3.org/ns/odrl/2/', rightOperand, 'http://www.w3.org/ns/odrl/2/rightOperand')]).
step(namespace_iri('http://www.w3.org/ns/odrl/2/', rightOperand, 'http://www.w3.org/ns/odrl/2/rightOperand'),
     rule(38),
     ['Prefix' = 'http://www.w3.org/ns/odrl/2/',
      'Name' = rightOperand,
      'Iri' = 'http://www.w3.org/ns/odrl/2/rightOperand'],
     [atom_concat('http://www.w3.org/ns/odrl/2/', rightOperand, 'http://www.w3.org/ns/odrl/2/rightOperand')]).
step(atom_concat('http://www.w3.org/ns/odrl/2/', rightOperand, 'http://www.w3.org/ns/odrl/2/rightOperand'),
     builtin,
     [],
     []).
step(rdf(iri('https://example.org/alpha_purpose_constraint'), iri('http://www.w3.org/ns/odrl/2/rightOperand'), iri('https://w3id.org/dpv#Healthcare'), default_graph),
     fact(21),
     [],
     []).
step(mapping_node(purpose, 'https://example.org/result/mapping/purpose'),
     rule(42),
     ['Role' = purpose, 'Iri' = 'https://example.org/result/mapping/purpose'],
     [atom_concat('https://example.org/result/mapping/', purpose, 'https://example.org/result/mapping/purpose')]).
step(atom_concat('https://example.org/result/mapping/', purpose, 'https://example.org/result/mapping/purpose'),
     builtin,
     [],
     []).
step(mapping_role_iri(purpose, 'https://example.org/role/purpose'),
     rule(43),
     ['Role' = purpose, 'Iri' = 'https://example.org/role/purpose'],
     [atom_concat('https://example.org/role/', purpose, 'https://example.org/role/purpose')]).
step(atom_concat('https://example.org/role/', purpose, 'https://example.org/role/purpose'),
     builtin,
     [],
     []).
step(result_rdf(iri('https://example.org/result/mapping/legal_basis'), iri('https://example.org/sourceRole'), iri('https://example.org/role/legal_basis'), default_graph),
     rule(39),
     ['Node' = 'https://example.org/result/mapping/legal_basis',
      'RoleIri' = 'https://example.org/role/legal_basis',
      'Role' = legal_basis],
     [mapped_role(legal_basis, dpv_consent, constraint(alpha_basis_constraint)),
      mapping_node(legal_basis, 'https://example.org/result/mapping/legal_basis'),
      mapping_role_iri(legal_basis, 'https://example.org/role/legal_basis')]).
step(mapped_role(legal_basis, dpv_consent, constraint(alpha_basis_constraint)),
     rule(32),
     [],
     [rdf_link(ex(alpha_care_process), dpv(hasLegalBasis), dpv('Consent')),
      odrl_constraint(alpha_basis_constraint, ex(legalBasis), dpv('Consent'))]).
step(rdf_link(ex(alpha_care_process), dpv(hasLegalBasis), dpv('Consent')),
     rule(34),
     ['Subject' = ex(alpha_care_process),
      'Predicate' = dpv(hasLegalBasis),
      'Object' = dpv('Consent'),
      'SubjectIri' = 'https://example.org/alpha_care_process',
      'PredicateIri' = 'https://w3id.org/dpv#hasLegalBasis',
      'ObjectIri' = 'https://w3id.org/dpv#Consent'],
     [iri_term(ex(alpha_care_process), 'https://example.org/alpha_care_process'),
      iri_term(dpv(hasLegalBasis), 'https://w3id.org/dpv#hasLegalBasis'),
      rdf(iri('https://example.org/alpha_care_process'), iri('https://w3id.org/dpv#hasLegalBasis'), iri('https://w3id.org/dpv#Consent'), default_graph),
      iri_term(dpv('Consent'), 'https://w3id.org/dpv#Consent')]).
step(iri_term(dpv(hasLegalBasis), 'https://w3id.org/dpv#hasLegalBasis'),
     rule(36),
     ['Name' = hasLegalBasis, 'Iri' = 'https://w3id.org/dpv#hasLegalBasis'],
     [namespace_iri('https://w3id.org/dpv#', hasLegalBasis, 'https://w3id.org/dpv#hasLegalBasis')]).
step(namespace_iri('https://w3id.org/dpv#', hasLegalBasis, 'https://w3id.org/dpv#hasLegalBasis'),
     rule(38),
     ['Prefix' = 'https://w3id.org/dpv#',
      'Name' = hasLegalBasis,
      'Iri' = 'https://w3id.org/dpv#hasLegalBasis'],
     [atom_concat('https://w3id.org/dpv#', hasLegalBasis, 'https://w3id.org/dpv#hasLegalBasis')]).
step(atom_concat('https://w3id.org/dpv#', hasLegalBasis, 'https://w3id.org/dpv#hasLegalBasis'),
     builtin,
     [],
     []).
step(rdf(iri('https://example.org/alpha_care_process'), iri('https://w3id.org/dpv#hasLegalBasis'), iri('https://w3id.org/dpv#Consent'), default_graph),
     fact(7),
     [],
     []).
step(iri_term(dpv('Consent'), 'https://w3id.org/dpv#Consent'),
     rule(36),
     ['Name' = 'Consent', 'Iri' = 'https://w3id.org/dpv#Consent'],
     [namespace_iri('https://w3id.org/dpv#', 'Consent', 'https://w3id.org/dpv#Consent')]).
step(namespace_iri('https://w3id.org/dpv#', 'Consent', 'https://w3id.org/dpv#Consent'),
     rule(38),
     ['Prefix' = 'https://w3id.org/dpv#',
      'Name' = 'Consent',
      'Iri' = 'https://w3id.org/dpv#Consent'],
     [atom_concat('https://w3id.org/dpv#', 'Consent', 'https://w3id.org/dpv#Consent')]).
step(atom_concat('https://w3id.org/dpv#', 'Consent', 'https://w3id.org/dpv#Consent'),
     builtin,
     [],
     []).
step(odrl_constraint(alpha_basis_constraint, ex(legalBasis), dpv('Consent')),
     rule(33),
     ['Name' = alpha_basis_constraint,
      'LeftOperand' = ex(legalBasis),
      'RightOperand' = dpv('Consent')],
     [rdf_link(ex(alpha_permission), odrl(constraint), ex(alpha_basis_constraint)),
      rdf_link(ex(alpha_basis_constraint), odrl(leftOperand), ex(legalBasis)),
      rdf_link(ex(alpha_basis_constraint), odrl(operator), odrl(isA)),
      rdf_link(ex(alpha_basis_constraint), odrl(rightOperand), dpv('Consent'))]).
step(rdf_link(ex(alpha_permission), odrl(constraint), ex(alpha_basis_constraint)),
     rule(34),
     ['Subject' = ex(alpha_permission),
      'Predicate' = odrl(constraint),
      'Object' = ex(alpha_basis_constraint),
      'SubjectIri' = 'https://example.org/alpha_permission',
      'PredicateIri' = 'http://www.w3.org/ns/odrl/2/constraint',
      'ObjectIri' = 'https://example.org/alpha_basis_constraint'],
     [iri_term(ex(alpha_permission), 'https://example.org/alpha_permission'),
      iri_term(odrl(constraint), 'http://www.w3.org/ns/odrl/2/constraint'),
      rdf(iri('https://example.org/alpha_permission'), iri('http://www.w3.org/ns/odrl/2/constraint'), iri('https://example.org/alpha_basis_constraint'), default_graph),
      iri_term(ex(alpha_basis_constraint), 'https://example.org/alpha_basis_constraint')]).
step(rdf(iri('https://example.org/alpha_permission'), iri('http://www.w3.org/ns/odrl/2/constraint'), iri('https://example.org/alpha_basis_constraint'), default_graph),
     fact(17),
     [],
     []).
step(iri_term(ex(alpha_basis_constraint), 'https://example.org/alpha_basis_constraint'),
     rule(35),
     ['Name' = alpha_basis_constraint, 'Iri' = 'https://example.org/alpha_basis_constraint'],
     [namespace_iri('https://example.org/', alpha_basis_constraint, 'https://example.org/alpha_basis_constraint')]).
step(namespace_iri('https://example.org/', alpha_basis_constraint, 'https://example.org/alpha_basis_constraint'),
     rule(38),
     ['Prefix' = 'https://example.org/',
      'Name' = alpha_basis_constraint,
      'Iri' = 'https://example.org/alpha_basis_constraint'],
     [atom_concat('https://example.org/', alpha_basis_constraint, 'https://example.org/alpha_basis_constraint')]).
step(atom_concat('https://example.org/', alpha_basis_constraint, 'https://example.org/alpha_basis_constraint'),
     builtin,
     [],
     []).
step(rdf_link(ex(alpha_basis_constraint), odrl(leftOperand), ex(legalBasis)),
     rule(34),
     ['Subject' = ex(alpha_basis_constraint),
      'Predicate' = odrl(leftOperand),
      'Object' = ex(legalBasis),
      'SubjectIri' = 'https://example.org/alpha_basis_constraint',
      'PredicateIri' = 'http://www.w3.org/ns/odrl/2/leftOperand',
      'ObjectIri' = 'https://example.org/legalBasis'],
     [iri_term(ex(alpha_basis_constraint), 'https://example.org/alpha_basis_constraint'),
      iri_term(odrl(leftOperand), 'http://www.w3.org/ns/odrl/2/leftOperand'),
      rdf(iri('https://example.org/alpha_basis_constraint'), iri('http://www.w3.org/ns/odrl/2/leftOperand'), iri('https://example.org/legalBasis'), default_graph),
      iri_term(ex(legalBasis), 'https://example.org/legalBasis')]).
step(rdf(iri('https://example.org/alpha_basis_constraint'), iri('http://www.w3.org/ns/odrl/2/leftOperand'), iri('https://example.org/legalBasis'), default_graph),
     fact(23),
     [],
     []).
step(iri_term(ex(legalBasis), 'https://example.org/legalBasis'),
     rule(35),
     ['Name' = legalBasis, 'Iri' = 'https://example.org/legalBasis'],
     [namespace_iri('https://example.org/', legalBasis, 'https://example.org/legalBasis')]).
step(namespace_iri('https://example.org/', legalBasis, 'https://example.org/legalBasis'),
     rule(38),
     ['Prefix' = 'https://example.org/',
      'Name' = legalBasis,
      'Iri' = 'https://example.org/legalBasis'],
     [atom_concat('https://example.org/', legalBasis, 'https://example.org/legalBasis')]).
step(atom_concat('https://example.org/', legalBasis, 'https://example.org/legalBasis'),
     builtin,
     [],
     []).
step(rdf_link(ex(alpha_basis_constraint), odrl(operator), odrl(isA)),
     rule(34),
     ['Subject' = ex(alpha_basis_constraint),
      'Predicate' = odrl(operator),
      'Object' = odrl(isA),
      'SubjectIri' = 'https://example.org/alpha_basis_constraint',
      'PredicateIri' = 'http://www.w3.org/ns/odrl/2/operator',
      'ObjectIri' = 'http://www.w3.org/ns/odrl/2/isA'],
     [iri_term(ex(alpha_basis_constraint), 'https://example.org/alpha_basis_constraint'),
      iri_term(odrl(operator), 'http://www.w3.org/ns/odrl/2/operator'),
      rdf(iri('https://example.org/alpha_basis_constraint'), iri('http://www.w3.org/ns/odrl/2/operator'), iri('http://www.w3.org/ns/odrl/2/isA'), default_graph),
      iri_term(odrl(isA), 'http://www.w3.org/ns/odrl/2/isA')]).
step(rdf(iri('https://example.org/alpha_basis_constraint'), iri('http://www.w3.org/ns/odrl/2/operator'), iri('http://www.w3.org/ns/odrl/2/isA'), default_graph),
     fact(24),
     [],
     []).
step(rdf_link(ex(alpha_basis_constraint), odrl(rightOperand), dpv('Consent')),
     rule(34),
     ['Subject' = ex(alpha_basis_constraint),
      'Predicate' = odrl(rightOperand),
      'Object' = dpv('Consent'),
      'SubjectIri' = 'https://example.org/alpha_basis_constraint',
      'PredicateIri' = 'http://www.w3.org/ns/odrl/2/rightOperand',
      'ObjectIri' = 'https://w3id.org/dpv#Consent'],
     [iri_term(ex(alpha_basis_constraint), 'https://example.org/alpha_basis_constraint'),
      iri_term(odrl(rightOperand), 'http://www.w3.org/ns/odrl/2/rightOperand'),
      rdf(iri('https://example.org/alpha_basis_constraint'), iri('http://www.w3.org/ns/odrl/2/rightOperand'), iri('https://w3id.org/dpv#Consent'), default_graph),
      iri_term(dpv('Consent'), 'https://w3id.org/dpv#Consent')]).
step(rdf(iri('https://example.org/alpha_basis_constraint'), iri('http://www.w3.org/ns/odrl/2/rightOperand'), iri('https://w3id.org/dpv#Consent'), default_graph),
     fact(25),
     [],
     []).
step(mapping_node(legal_basis, 'https://example.org/result/mapping/legal_basis'),
     rule(42),
     ['Role' = legal_basis, 'Iri' = 'https://example.org/result/mapping/legal_basis'],
     [atom_concat('https://example.org/result/mapping/', legal_basis, 'https://example.org/result/mapping/legal_basis')]).
step(atom_concat('https://example.org/result/mapping/', legal_basis, 'https://example.org/result/mapping/legal_basis'),
     builtin,
     [],
     []).
step(mapping_role_iri(legal_basis, 'https://example.org/role/legal_basis'),
     rule(43),
     ['Role' = legal_basis, 'Iri' = 'https://example.org/role/legal_basis'],
     [atom_concat('https://example.org/role/', legal_basis, 'https://example.org/role/legal_basis')]).
step(atom_concat('https://example.org/role/', legal_basis, 'https://example.org/role/legal_basis'),
     builtin,
     [],
     []).
step(result_rdf(iri('https://example.org/result/mapping/data_controller'), iri('https://example.org/value'), iri('https://example.org/hospital_a'), default_graph),
     rule(40),
     ['Node' = 'https://example.org/result/mapping/data_controller',
      'ValueIri' = 'https://example.org/hospital_a',
      'Role' = data_controller,
      'Value' = hospital_a],
     [mapped_role(data_controller, hospital_a, assigner),
      mapping_node(data_controller, 'https://example.org/result/mapping/data_controller'),
      mapping_value_iri(data_controller, hospital_a, 'https://example.org/hospital_a')]).
step(mapping_value_iri(data_controller, hospital_a, 'https://example.org/hospital_a'),
     rule(44),
     ['Value' = hospital_a, 'Iri' = 'https://example.org/hospital_a'],
     [iri_term(ex(hospital_a), 'https://example.org/hospital_a')]).
step(result_rdf(iri('https://example.org/result/mapping/recipient'), iri('https://example.org/value'), iri('https://example.org/research_partner'), default_graph),
     rule(40),
     ['Node' = 'https://example.org/result/mapping/recipient',
      'ValueIri' = 'https://example.org/research_partner',
      'Role' = recipient,
      'Value' = research_partner],
     [mapped_role(recipient, research_partner, assignee),
      mapping_node(recipient, 'https://example.org/result/mapping/recipient'),
      mapping_value_iri(recipient, research_partner, 'https://example.org/research_partner')]).
step(mapping_value_iri(recipient, research_partner, 'https://example.org/research_partner'),
     rule(45),
     ['Value' = research_partner, 'Iri' = 'https://example.org/research_partner'],
     [iri_term(ex(research_partner), 'https://example.org/research_partner')]).
step(result_rdf(iri('https://example.org/result/mapping/personal_data'), iri('https://example.org/value'), iri('https://example.org/lab_result'), default_graph),
     rule(40),
     ['Node' = 'https://example.org/result/mapping/personal_data',
      'ValueIri' = 'https://example.org/lab_result',
      'Role' = personal_data,
      'Value' = lab_result],
     [mapped_role(personal_data, lab_result, target),
      mapping_node(personal_data, 'https://example.org/result/mapping/personal_data'),
      mapping_value_iri(personal_data, lab_result, 'https://example.org/lab_result')]).
step(mapping_value_iri(personal_data, lab_result, 'https://example.org/lab_result'),
     rule(46),
     ['Value' = lab_result, 'Iri' = 'https://example.org/lab_result'],
     [iri_term(ex(lab_result), 'https://example.org/lab_result')]).
step(result_rdf(iri('https://example.org/result/mapping/processing'), iri('https://example.org/value'), iri('https://w3id.org/dpv#Use'), default_graph),
     rule(40),
     ['Node' = 'https://example.org/result/mapping/processing',
      'ValueIri' = 'https://w3id.org/dpv#Use',
      'Role' = processing,
      'Value' = dpv_use],
     [mapped_role(processing, dpv_use, action),
      mapping_node(processing, 'https://example.org/result/mapping/processing'),
      mapping_value_iri(processing, dpv_use, 'https://w3id.org/dpv#Use')]).
step(mapping_value_iri(processing, dpv_use, 'https://w3id.org/dpv#Use'),
     rule(47),
     ['Iri' = 'https://w3id.org/dpv#Use'],
     [iri_term(dpv('Use'), 'https://w3id.org/dpv#Use')]).
step(result_rdf(iri('https://example.org/result/mapping/purpose'), iri('https://example.org/value'), iri('https://w3id.org/dpv#Healthcare'), default_graph),
     rule(40),
     ['Node' = 'https://example.org/result/mapping/purpose',
      'ValueIri' = 'https://w3id.org/dpv#Healthcare',
      'Role' = purpose,
      'Value' = dpv_healthcare],
     [mapped_role(purpose, dpv_healthcare, constraint(alpha_purpose_constraint)),
      mapping_node(purpose, 'https://example.org/result/mapping/purpose'),
      mapping_value_iri(purpose, dpv_healthcare, 'https://w3id.org/dpv#Healthcare')]).
step(mapping_value_iri(purpose, dpv_healthcare, 'https://w3id.org/dpv#Healthcare'),
     rule(48),
     ['Iri' = 'https://w3id.org/dpv#Healthcare'],
     [iri_term(dpv('Healthcare'), 'https://w3id.org/dpv#Healthcare')]).
step(result_rdf(iri('https://example.org/result/mapping/legal_basis'), iri('https://example.org/value'), iri('https://w3id.org/dpv#Consent'), default_graph),
     rule(40),
     ['Node' = 'https://example.org/result/mapping/legal_basis',
      'ValueIri' = 'https://w3id.org/dpv#Consent',
      'Role' = legal_basis,
      'Value' = dpv_consent],
     [mapped_role(legal_basis, dpv_consent, constraint(alpha_basis_constraint)),
      mapping_node(legal_basis, 'https://example.org/result/mapping/legal_basis'),
      mapping_value_iri(legal_basis, dpv_consent, 'https://w3id.org/dpv#Consent')]).
step(mapping_value_iri(legal_basis, dpv_consent, 'https://w3id.org/dpv#Consent'),
     rule(49),
     ['Iri' = 'https://w3id.org/dpv#Consent'],
     [iri_term(dpv('Consent'), 'https://w3id.org/dpv#Consent')]).
step(result_rdf(iri('https://example.org/result/mapping/data_controller'), iri('https://example.org/mappingTarget'), iri('http://www.w3.org/ns/odrl/2/assigner'), default_graph),
     rule(41),
     ['Node' = 'https://example.org/result/mapping/data_controller',
      'TargetIri' = 'http://www.w3.org/ns/odrl/2/assigner',
      'Role' = data_controller,
      'Target' = assigner],
     [mapped_role(data_controller, hospital_a, assigner),
      mapping_node(data_controller, 'https://example.org/result/mapping/data_controller'),
      mapping_target_iri(assigner, 'http://www.w3.org/ns/odrl/2/assigner')]).
step(mapping_target_iri(assigner, 'http://www.w3.org/ns/odrl/2/assigner'),
     rule(50),
     ['Iri' = 'http://www.w3.org/ns/odrl/2/assigner'],
     [iri_term(odrl(assigner), 'http://www.w3.org/ns/odrl/2/assigner')]).
step(result_rdf(iri('https://example.org/result/mapping/recipient'), iri('https://example.org/mappingTarget'), iri('http://www.w3.org/ns/odrl/2/assignee'), default_graph),
     rule(41),
     ['Node' = 'https://example.org/result/mapping/recipient',
      'TargetIri' = 'http://www.w3.org/ns/odrl/2/assignee',
      'Role' = recipient,
      'Target' = assignee],
     [mapped_role(recipient, research_partner, assignee),
      mapping_node(recipient, 'https://example.org/result/mapping/recipient'),
      mapping_target_iri(assignee, 'http://www.w3.org/ns/odrl/2/assignee')]).
step(mapping_target_iri(assignee, 'http://www.w3.org/ns/odrl/2/assignee'),
     rule(51),
     ['Iri' = 'http://www.w3.org/ns/odrl/2/assignee'],
     [iri_term(odrl(assignee), 'http://www.w3.org/ns/odrl/2/assignee')]).
step(result_rdf(iri('https://example.org/result/mapping/personal_data'), iri('https://example.org/mappingTarget'), iri('http://www.w3.org/ns/odrl/2/target'), default_graph),
     rule(41),
     ['Node' = 'https://example.org/result/mapping/personal_data',
      'TargetIri' = 'http://www.w3.org/ns/odrl/2/target',
      'Role' = personal_data,
      'Target' = target],
     [mapped_role(personal_data, lab_result, target),
      mapping_node(personal_data, 'https://example.org/result/mapping/personal_data'),
      mapping_target_iri(target, 'http://www.w3.org/ns/odrl/2/target')]).
step(mapping_target_iri(target, 'http://www.w3.org/ns/odrl/2/target'),
     rule(52),
     ['Iri' = 'http://www.w3.org/ns/odrl/2/target'],
     [iri_term(odrl(target), 'http://www.w3.org/ns/odrl/2/target')]).
step(result_rdf(iri('https://example.org/result/mapping/processing'), iri('https://example.org/mappingTarget'), iri('http://www.w3.org/ns/odrl/2/action'), default_graph),
     rule(41),
     ['Node' = 'https://example.org/result/mapping/processing',
      'TargetIri' = 'http://www.w3.org/ns/odrl/2/action',
      'Role' = processing,
      'Target' = action],
     [mapped_role(processing, dpv_use, action),
      mapping_node(processing, 'https://example.org/result/mapping/processing'),
      mapping_target_iri(action, 'http://www.w3.org/ns/odrl/2/action')]).
step(mapping_target_iri(action, 'http://www.w3.org/ns/odrl/2/action'),
     rule(53),
     ['Iri' = 'http://www.w3.org/ns/odrl/2/action'],
     [iri_term(odrl(action), 'http://www.w3.org/ns/odrl/2/action')]).
step(result_rdf(iri('https://example.org/result/mapping/purpose'), iri('https://example.org/mappingTarget'), iri('https://example.org/alpha_purpose_constraint'), default_graph),
     rule(41),
     ['Node' = 'https://example.org/result/mapping/purpose',
      'TargetIri' = 'https://example.org/alpha_purpose_constraint',
      'Role' = purpose,
      'Target' = constraint(alpha_purpose_constraint)],
     [mapped_role(purpose, dpv_healthcare, constraint(alpha_purpose_constraint)),
      mapping_node(purpose, 'https://example.org/result/mapping/purpose'),
      mapping_target_iri(constraint(alpha_purpose_constraint), 'https://example.org/alpha_purpose_constraint')]).
step(mapping_target_iri(constraint(alpha_purpose_constraint), 'https://example.org/alpha_purpose_constraint'),
     rule(54),
     ['Name' = alpha_purpose_constraint, 'Iri' = 'https://example.org/alpha_purpose_constraint'],
     [iri_term(ex(alpha_purpose_constraint), 'https://example.org/alpha_purpose_constraint')]).
step(result_rdf(iri('https://example.org/result/mapping/legal_basis'), iri('https://example.org/mappingTarget'), iri('https://example.org/alpha_basis_constraint'), default_graph),
     rule(41),
     ['Node' = 'https://example.org/result/mapping/legal_basis',
      'TargetIri' = 'https://example.org/alpha_basis_constraint',
      'Role' = legal_basis,
      'Target' = constraint(alpha_basis_constraint)],
     [mapped_role(legal_basis, dpv_consent, constraint(alpha_basis_constraint)),
      mapping_node(legal_basis, 'https://example.org/result/mapping/legal_basis'),
      mapping_target_iri(constraint(alpha_basis_constraint), 'https://example.org/alpha_basis_constraint')]).
step(mapping_target_iri(constraint(alpha_basis_constraint), 'https://example.org/alpha_basis_constraint'),
     rule(54),
     ['Name' = alpha_basis_constraint, 'Iri' = 'https://example.org/alpha_basis_constraint'],
     [iri_term(ex(alpha_basis_constraint), 'https://example.org/alpha_basis_constraint')]).
