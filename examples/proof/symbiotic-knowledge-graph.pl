proposal_state(p1, auto_accepted).
proposal_state(p2, human_accepted).
proposal_state(p3, human_rejected).
proposal_state(p4, needs_review).
conflict(p1, route_7, status, running).
conflict(p3, central_hall, status, open).
knowledge_gain(riverside_school, emergency_designation, cooling_center).
recommended_action(after_review, riverside, open_local_center(riverside_school)).
recommended_action(before_review, riverside, deploy_mobile_unit).
decision_reason(before_review, riverside, "Route 7 is suspended, Central Hall has unstable power, and Riverside School is not yet an approved cooling centre; deploy the mobile unit.").
decision_reason(after_review, riverside, "Human review confirms Riverside School as an emergency cooling centre; its verified capacity and accessibility satisfy Riverside demand locally.").
audit(p1, language_agent, transit_api_20260827, auto_accepted, automatic).
audit(p2, language_agent, facilities_bulletin_20260827, human_accepted, human(emergency_coordinator, accept)).
audit(p3, language_agent, community_post_4812, human_rejected, human(operations_officer, reject)).
audit(p4, language_agent, volunteer_message_112, needs_review, pending).
feedback_signal(language_agent, p2, accepted_by_human).
feedback_signal(language_agent, p3, rejected_by_human).
feedback_signal(language_agent, p4, unresolved).
symbiosis_gain(graph, accepted_machine_knowledge).
symbiosis_gain(agent, better_operational_answer).
symbiosis_gain(human, inspectable_reason).
symbiosis_gain(governance, rejected_claim_remains_outside_operational_graph).
symbiosis_gain(rdf, accepted_and_derived_knowledge_can_be_published_back).
knowledge_exchange(machine_to_graph, candidate(p2, riverside_school, emergency_designation, cooling_center)).
knowledge_exchange(graph_to_machine, constraint(central_hall, power, unstable)).
knowledge_exchange(human_to_machine, review(p2, accept)).
knowledge_exchange(human_to_machine, review(p3, reject)).
knowledge_exchange(machine_to_human, recommendation(after_review, riverside, open_local_center(riverside_school))).
knowledge_exchange(rdf_to_prolog, ordinary_rdf4_facts).
knowledge_exchange(prolog_to_rdf, materialized_ground_rdf4).
pipeline_step(1, 'RDF 1.2 N-Quads: named graphs keep source and governance boundaries explicit').
pipeline_step(2, 'rdf-prolog-interchange: RDF becomes ordinary rdf/4 Prolog facts without a solver').
pipeline_step(3, 'EyeProlog: ISO Prolog rules validate candidates, apply review policy, and derive actions').
pipeline_step(4, 'EyeProlog: result_rdf/4 materializes accepted knowledge and decisions as ground RDF-shaped facts').
pipeline_step(5, 'rdf-prolog-interchange: ground rdf/4 facts become RDF again for publication or federation').
cognitive_parallel(fact, remembered_assertion).
cognitive_parallel(rule, reusable_generalization).
cognitive_parallel(query, explicit_question).
cognitive_parallel(variable_binding, filling_in_an_answer).
cognitive_parallel(backtracking, considering_alternatives).
cognitive_parallel(proof, giving_reasons).
cognitive_parallel(review, correcting_shared_knowledge).

clause(3,
       rdf(iri('https://example.org/city/facility/central-hall'), iri('https://example.org/vocab/status'), iri('https://example.org/city/state/open'), iri('https://example.org/graph/city-facilities')),
       true).
clause(14,
       rdf(iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/neighbourhood'), iri('https://example.org/city/neighbourhood/riverside'), iri('https://example.org/graph/city-facilities')),
       true).
clause(15,
       rdf(iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/status'), iri('https://example.org/city/state/open'), iri('https://example.org/graph/city-facilities')),
       true).
clause(16,
       rdf(iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/cooling'), iri('https://example.org/city/state/available'), iri('https://example.org/graph/city-facilities')),
       true).
clause(17,
       rdf(iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/capacity'), literal('90', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/graph/city-facilities')),
       true).
clause(18,
       rdf(iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/wheelchairAccess'), iri('https://example.org/city/value/yes'), iri('https://example.org/graph/city-facilities')),
       true).
clause(19,
       rdf(iri('https://example.org/city/neighbourhood/riverside'), iri('https://example.org/vocab/expectedDemand'), literal('70', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/graph/emergency-plan')),
       true).
clause(20,
       rdf(iri('https://example.org/city/neighbourhood/riverside'), iri('https://example.org/vocab/mobileUnitAvailable'), iri('https://example.org/city/value/yes'), iri('https://example.org/graph/emergency-plan')),
       true).
clause(23,
       rdf(iri('https://example.org/city/route/7'), iri('https://example.org/vocab/status'), iri('https://example.org/city/state/running'), iri('https://example.org/graph/transit-plan')),
       true).
clause(26,
       rdf(iri('https://example.org/city/evidence/transit-api-20260827'), iri('https://example.org/vocab/evidenceKind'), iri('https://example.org/city/evidence-kind/official-feed'), iri('https://example.org/graph/evidence-registry')),
       true).
clause(34,
       rdf(iri('https://example.org/city/proposal/p1'), iri('https://example.org/vocab/statement'), triple(iri('https://example.org/city/route/7'), iri('https://example.org/vocab/status'), iri('https://example.org/city/state/suspended')), iri('https://example.org/graph/ai-proposals')),
       true).
clause(35,
       rdf(iri('https://example.org/city/proposal/p1'), iri('https://example.org/vocab/agent'), iri('https://example.org/city/agent/language-agent'), iri('https://example.org/graph/ai-proposals')),
       true).
clause(36,
       rdf(iri('https://example.org/city/proposal/p1'), iri('https://example.org/vocab/evidence'), iri('https://example.org/city/evidence/transit-api-20260827'), iri('https://example.org/graph/ai-proposals')),
       true).
clause(37,
       rdf(iri('https://example.org/city/proposal/p1'), iri('https://example.org/vocab/confidencePercent'), literal('99', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/graph/ai-proposals')),
       true).
clause(38,
       rdf(iri('https://example.org/city/proposal/p2'), iri('https://example.org/vocab/statement'), triple(iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/emergencyDesignation'), iri('https://example.org/city/class/cooling-center')), iri('https://example.org/graph/ai-proposals')),
       true).
clause(39,
       rdf(iri('https://example.org/city/proposal/p2'), iri('https://example.org/vocab/agent'), iri('https://example.org/city/agent/language-agent'), iri('https://example.org/graph/ai-proposals')),
       true).
clause(40,
       rdf(iri('https://example.org/city/proposal/p2'), iri('https://example.org/vocab/evidence'), iri('https://example.org/city/evidence/facilities-bulletin-20260827'), iri('https://example.org/graph/ai-proposals')),
       true).
clause(41,
       rdf(iri('https://example.org/city/proposal/p2'), iri('https://example.org/vocab/confidencePercent'), literal('93', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/graph/ai-proposals')),
       true).
clause(42,
       rdf(iri('https://example.org/city/proposal/p3'), iri('https://example.org/vocab/statement'), triple(iri('https://example.org/city/facility/central-hall'), iri('https://example.org/vocab/status'), iri('https://example.org/city/state/closed')), iri('https://example.org/graph/ai-proposals')),
       true).
clause(43,
       rdf(iri('https://example.org/city/proposal/p3'), iri('https://example.org/vocab/agent'), iri('https://example.org/city/agent/language-agent'), iri('https://example.org/graph/ai-proposals')),
       true).
clause(44,
       rdf(iri('https://example.org/city/proposal/p3'), iri('https://example.org/vocab/evidence'), iri('https://example.org/city/evidence/community-post-4812'), iri('https://example.org/graph/ai-proposals')),
       true).
clause(45,
       rdf(iri('https://example.org/city/proposal/p3'), iri('https://example.org/vocab/confidencePercent'), literal('78', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/graph/ai-proposals')),
       true).
clause(46,
       rdf(iri('https://example.org/city/proposal/p4'), iri('https://example.org/vocab/statement'), triple(iri('https://example.org/city/facility/north-library'), iri('https://example.org/vocab/capacity'), literal('40', datatype('http://www.w3.org/2001/XMLSchema#integer'))), iri('https://example.org/graph/ai-proposals')),
       true).
clause(47,
       rdf(iri('https://example.org/city/proposal/p4'), iri('https://example.org/vocab/agent'), iri('https://example.org/city/agent/language-agent'), iri('https://example.org/graph/ai-proposals')),
       true).
clause(48,
       rdf(iri('https://example.org/city/proposal/p4'), iri('https://example.org/vocab/evidence'), iri('https://example.org/city/evidence/volunteer-message-112'), iri('https://example.org/graph/ai-proposals')),
       true).
clause(49,
       rdf(iri('https://example.org/city/proposal/p4'), iri('https://example.org/vocab/confidencePercent'), literal('66', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/graph/ai-proposals')),
       true).
clause(50,
       rdf(iri('https://example.org/city/review/r2'), iri('https://example.org/vocab/aboutProposal'), iri('https://example.org/city/proposal/p2'), iri('https://example.org/graph/human-review')),
       true).
clause(51,
       rdf(iri('https://example.org/city/review/r2'), iri('https://example.org/vocab/reviewer'), iri('https://example.org/city/actor/emergency-coordinator'), iri('https://example.org/graph/human-review')),
       true).
clause(52,
       rdf(iri('https://example.org/city/review/r2'), iri('https://example.org/vocab/decision'), iri('https://example.org/city/decision/accept'), iri('https://example.org/graph/human-review')),
       true).
clause(53,
       rdf(iri('https://example.org/city/review/r2'), iri('https://example.org/vocab/note'), literal('facility bulletin verified by phone', datatype('http://www.w3.org/2001/XMLSchema#string')), iri('https://example.org/graph/human-review')),
       true).
clause(54,
       rdf(iri('https://example.org/city/review/r3'), iri('https://example.org/vocab/aboutProposal'), iri('https://example.org/city/proposal/p3'), iri('https://example.org/graph/human-review')),
       true).
clause(55,
       rdf(iri('https://example.org/city/review/r3'), iri('https://example.org/vocab/reviewer'), iri('https://example.org/city/actor/operations-officer'), iri('https://example.org/graph/human-review')),
       true).
clause(56,
       rdf(iri('https://example.org/city/review/r3'), iri('https://example.org/vocab/decision'), iri('https://example.org/city/decision/reject'), iri('https://example.org/graph/human-review')),
       true).
clause(57,
       rdf(iri('https://example.org/city/review/r3'), iri('https://example.org/vocab/note'), literal('official operations desk confirms Central Hall is open', datatype('http://www.w3.org/2001/XMLSchema#string')), iri('https://example.org/graph/human-review')),
       true).
clause(58, v(statement, iri('https://example.org/vocab/statement')), true).
clause(59, v(agent, iri('https://example.org/vocab/agent')), true).
clause(60, v(evidence, iri('https://example.org/vocab/evidence')), true).
clause(61, v(confidence_percent, iri('https://example.org/vocab/confidencePercent')), true).
clause(62, v(evidence_kind, iri('https://example.org/vocab/evidenceKind')), true).
clause(63, v(about_proposal, iri('https://example.org/vocab/aboutProposal')), true).
clause(64, v(reviewer, iri('https://example.org/vocab/reviewer')), true).
clause(65, v(decision, iri('https://example.org/vocab/decision')), true).
clause(66, v(note, iri('https://example.org/vocab/note')), true).
clause(68, v(neighbourhood, iri('https://example.org/vocab/neighbourhood')), true).
clause(69, v(status, iri('https://example.org/vocab/status')), true).
clause(70, v(cooling, iri('https://example.org/vocab/cooling')), true).
clause(71, v(capacity, iri('https://example.org/vocab/capacity')), true).
clause(72, v(wheelchair_access, iri('https://example.org/vocab/wheelchairAccess')), true).
clause(73, v(expected_demand, iri('https://example.org/vocab/expectedDemand')), true).
clause(74, v(mobile_unit_available, iri('https://example.org/vocab/mobileUnitAvailable')), true).
clause(76, v(power, iri('https://example.org/vocab/power')), true).
clause(77,
       v(emergency_designation, iri('https://example.org/vocab/emergencyDesignation')),
       true).
clause(78, graph(ai_proposals, iri('https://example.org/graph/ai-proposals')), true).
clause(79, graph(human_review, iri('https://example.org/graph/human-review')), true).
clause(80, graph(evidence_registry, iri('https://example.org/graph/evidence-registry')), true).
clause(83, curated_graph(iri('https://example.org/graph/city-facilities')), true).
clause(84, curated_graph(iri('https://example.org/graph/emergency-plan')), true).
clause(85, curated_graph(iri('https://example.org/graph/transit-plan')), true).
clause(87,
       curated(var('S'), var('P'), var('O')),
       (rdf(var('S'), var('P'), var('O'), var('G')), curated_graph(var('G')))).
clause(88,
       integer_literal(literal(var('Text'), datatype('http://www.w3.org/2001/XMLSchema#integer')), var('Number')),
       (atom_chars(var('Text'), var('Chars')), number_chars(var('Number'), var('Chars')))).
clause(89,
       proposal(var('Id'), var('Agent'), var('Evidence'), var('S'), var('P'), var('O'), var('Confidence')),
       (graph(ai_proposals, var('G')),
        v(statement, var('StatementP')),
        v(agent, var('AgentP')),
        v(evidence, var('EvidenceP')),
        v(confidence_percent, var('ConfidenceP')),
        rdf(var('Id'), var('StatementP'), triple(var('S'), var('P'), var('O')), var('G')),
        rdf(var('Id'), var('AgentP'), var('Agent'), var('G')),
        rdf(var('Id'), var('EvidenceP'), var('Evidence'), var('G')),
        rdf(var('Id'), var('ConfidenceP'), var('ConfidenceLiteral'), var('G')),
        integer_literal(var('ConfidenceLiteral'), var('Confidence')))).
clause(90,
       evidence_kind(var('Evidence'), var('Kind')),
       (graph(evidence_registry, var('G')),
        v(evidence_kind, var('Predicate')),
        rdf(var('Evidence'), var('Predicate'), var('Kind'), var('G')))).
clause(91,
       human_review(var('Id'), var('Reviewer'), var('Decision'), var('Note')),
       (graph(human_review, var('G')),
        v(about_proposal, var('AboutP')),
        v(reviewer, var('ReviewerP')),
        v(decision, var('DecisionP')),
        v(note, var('NoteP')),
        rdf(var('Review'), var('AboutP'), var('Id'), var('G')),
        rdf(var('Review'), var('ReviewerP'), var('Reviewer'), var('G')),
        rdf(var('Review'), var('DecisionP'), var('DecisionIri'), var('G')),
        rdf(var('Review'), var('NoteP'), literal(var('Note'), datatype('http://www.w3.org/2001/XMLSchema#string')), var('G')),
        decision_atom(var('DecisionIri'), var('Decision')))).
clause(92, decision_atom(iri('https://example.org/city/decision/accept'), accept), true).
clause(93, decision_atom(iri('https://example.org/city/decision/reject'), reject), true).
clause(94, auto_eligible(iri('https://example.org/city/evidence-kind/official-feed')), true).
clause(98,
       opposite(iri('https://example.org/city/state/closed'), iri('https://example.org/city/state/open')),
       true).
clause(100,
       opposite(iri('https://example.org/city/state/suspended'), iri('https://example.org/city/state/running')),
       true).
clause(101,
       conflict_iri(var('Id'), var('Subject'), var('Predicate'), var('Existing')),
       (proposal(var('Id'), anonymous(1), anonymous(2), var('Subject'), var('Predicate'), var('Proposed'), anonymous(3)),
        curated(var('Subject'), var('Predicate'), var('Existing')),
        opposite(var('Proposed'), var('Existing')))).
clause(102,
       proposal_state_iri(var('Id'), auto_accepted),
       (proposal(var('Id'), anonymous(1), var('Evidence'), var('Subject'), var('Predicate'), anonymous(2), var('Confidence')),
        evidence_kind(var('Evidence'), var('Kind')),
        auto_eligible(var('Kind')),
        var('Confidence') >= 95,
        (\+ conflict_iri(var('Id'), var('Subject'), var('Predicate'), anonymous(3)) ; authoritative_override(var('Evidence'), var('Predicate'))))).
clause(103,
       proposal_state_iri(var('Id'), human_accepted),
       (proposal(var('Id'), anonymous(1), anonymous(2), anonymous(3), anonymous(4), anonymous(5), anonymous(6)),
        human_review(var('Id'), anonymous(7), accept, anonymous(8)))).
clause(104,
       proposal_state_iri(var('Id'), human_rejected),
       (proposal(var('Id'), anonymous(1), anonymous(2), anonymous(3), anonymous(4), anonymous(5), anonymous(6)),
        human_review(var('Id'), anonymous(7), reject, anonymous(8)))).
clause(105,
       proposal_state_iri(var('Id'), needs_review),
       (proposal(var('Id'), anonymous(1), anonymous(2), anonymous(3), anonymous(4), anonymous(5), anonymous(6)),
        \+ proposal_state_iri(var('Id'), auto_accepted),
        \+ human_review(var('Id'), anonymous(7), anonymous(8), anonymous(9)))).
clause(106, stage(before_review), true).
clause(107, stage(after_review), true).
clause(110, accepted(after_review, var('Id')), proposal_state_iri(var('Id'), human_accepted)).
clause(112,
       known(var('Stage'), var('S'), var('P'), var('O')),
       (curated(var('S'), var('P'), var('O')),
        \+ has_accepted_override(var('Stage'), var('S'), var('P')))).
clause(113,
       known(var('Stage'), var('S'), var('P'), var('O')),
       (proposal(var('Id'), anonymous(1), anonymous(2), var('S'), var('P'), var('O'), anonymous(3)),
        accepted(var('Stage'), var('Id')))).
clause(114,
       knowledge_gain_iri(var('S'), var('P'), var('O')),
       (known(after_review, var('S'), var('P'), var('O')),
        \+ known(before_review, var('S'), var('P'), var('O')))).
clause(116,
       cooling_center(var('Stage'), var('Center')),
       (v(emergency_designation, var('P')),
        known(var('Stage'), var('Center'), var('P'), iri('https://example.org/city/class/cooling-center')))).
clause(117,
       numeric_value(var('Stage'), var('S'), var('Predicate'), var('Number')),
       (known(var('Stage'), var('S'), var('Predicate'), var('Literal')),
        integer_literal(var('Literal'), var('Number')))).
clause(118,
       sufficient_capacity(var('Stage'), var('Center'), var('Neighbourhood')),
       (v(capacity, var('CapacityP')),
        v(expected_demand, var('DemandP')),
        numeric_value(var('Stage'), var('Center'), var('CapacityP'), var('Capacity')),
        numeric_value(var('Stage'), var('Neighbourhood'), var('DemandP'), var('Demand')),
        var('Capacity') >= var('Demand'))).
clause(119,
       operational_center(var('Stage'), var('Center'), var('Neighbourhood')),
       (cooling_center(var('Stage'), var('Center')),
        v(status, var('StatusP')),
        v(cooling, var('CoolingP')),
        v(wheelchair_access, var('AccessP')),
        v(power, var('PowerP')),
        known(var('Stage'), var('Center'), var('StatusP'), iri('https://example.org/city/state/open')),
        known(var('Stage'), var('Center'), var('CoolingP'), iri('https://example.org/city/state/available')),
        known(var('Stage'), var('Center'), var('AccessP'), iri('https://example.org/city/value/yes')),
        sufficient_capacity(var('Stage'), var('Center'), var('Neighbourhood')),
        \+ known(var('Stage'), var('Center'), var('PowerP'), iri('https://example.org/city/state/unstable')))).
clause(120,
       local_center(var('Stage'), var('Neighbourhood'), var('Center')),
       (operational_center(var('Stage'), var('Center'), var('Neighbourhood')),
        v(neighbourhood, var('NeighbourhoodP')),
        known(var('Stage'), var('Center'), var('NeighbourhoodP'), var('Neighbourhood')))).
clause(122,
       recommended_action_iri(var('Stage'), var('Neighbourhood'), open_local_center(var('Center'))),
       (stage(var('Stage')), local_center(var('Stage'), var('Neighbourhood'), var('Center')))).
clause(124,
       recommended_action_iri(var('Stage'), var('Neighbourhood'), deploy_mobile_unit),
       (stage(var('Stage')),
        \+ local_center(var('Stage'), var('Neighbourhood'), anonymous(1)),
        \+ reachable_center(var('Stage'), var('Neighbourhood'), anonymous(2)),
        v(mobile_unit_available, var('MobileP')),
        known(var('Stage'), var('Neighbourhood'), var('MobileP'), iri('https://example.org/city/value/yes')))).
clause(125, short(iri('https://example.org/city/proposal/p1'), p1), true).
clause(126, short(iri('https://example.org/city/proposal/p2'), p2), true).
clause(127, short(iri('https://example.org/city/proposal/p3'), p3), true).
clause(128, short(iri('https://example.org/city/proposal/p4'), p4), true).
clause(129, short(iri('https://example.org/city/agent/language-agent'), language_agent), true).
clause(130,
       short(iri('https://example.org/city/evidence/transit-api-20260827'), transit_api_20260827),
       true).
clause(131,
       short(iri('https://example.org/city/evidence/facilities-bulletin-20260827'), facilities_bulletin_20260827),
       true).
clause(132,
       short(iri('https://example.org/city/evidence/community-post-4812'), community_post_4812),
       true).
clause(133,
       short(iri('https://example.org/city/evidence/volunteer-message-112'), volunteer_message_112),
       true).
clause(134,
       short(iri('https://example.org/city/actor/emergency-coordinator'), emergency_coordinator),
       true).
clause(135,
       short(iri('https://example.org/city/actor/operations-officer'), operations_officer),
       true).
clause(136, short(iri('https://example.org/city/facility/central-hall'), central_hall), true).
clause(138,
       short(iri('https://example.org/city/facility/riverside-school'), riverside_school),
       true).
clause(139, short(iri('https://example.org/city/neighbourhood/riverside'), riverside), true).
clause(140, short(iri('https://example.org/city/route/7'), route_7), true).
clause(141, short(iri('https://example.org/vocab/status'), status), true).
clause(142,
       short(iri('https://example.org/vocab/emergencyDesignation'), emergency_designation),
       true).
clause(143, short(iri('https://example.org/city/state/running'), running), true).
clause(144, short(iri('https://example.org/city/state/open'), open), true).
clause(145, short(iri('https://example.org/city/class/cooling-center'), cooling_center), true).
clause(146,
       proposal_state(var('Id'), var('State')),
       (proposal_state_iri(var('IdIri'), var('State')), short(var('IdIri'), var('Id')))).
clause(147,
       conflict(var('Id'), var('Subject'), var('Predicate'), var('Existing')),
       (conflict_iri(var('IdIri'), var('SubjectIri'), var('PredicateIri'), var('ExistingIri')),
        short(var('IdIri'), var('Id')),
        short(var('SubjectIri'), var('Subject')),
        short(var('PredicateIri'), var('Predicate')),
        short(var('ExistingIri'), var('Existing')))).
clause(148,
       knowledge_gain(var('Subject'), var('Predicate'), var('Object')),
       (knowledge_gain_iri(var('SubjectIri'), var('PredicateIri'), var('ObjectIri')),
        short(var('SubjectIri'), var('Subject')),
        short(var('PredicateIri'), var('Predicate')),
        short(var('ObjectIri'), var('Object')))).
clause(149, friendly_action(deploy_mobile_unit, deploy_mobile_unit), true).
clause(150,
       friendly_action(open_local_center(var('CenterIri')), open_local_center(var('Center'))),
       short(var('CenterIri'), var('Center'))).
clause(152,
       recommended_action(var('Stage'), var('Neighbourhood'), var('Action')),
       (recommended_action_iri(var('Stage'), var('NeighbourhoodIri'), var('ActionIri')),
        short(var('NeighbourhoodIri'), var('Neighbourhood')),
        friendly_action(var('ActionIri'), var('Action')))).
clause(153,
       decision_reason(before_review, riverside, "Route 7 is suspended, Central Hall has unstable power, and Riverside School is not yet an approved cooling centre; deploy the mobile unit."),
       recommended_action(before_review, riverside, deploy_mobile_unit)).
clause(154,
       decision_reason(after_review, riverside, "Human review confirms Riverside School as an emergency cooling centre; its verified capacity and accessibility satisfy Riverside demand locally."),
       recommended_action(after_review, riverside, open_local_center(riverside_school))).
clause(155,
       review_summary(var('Id'), human(var('Reviewer'), var('Decision'))),
       (human_review(var('Id'), var('ReviewerIri'), var('Decision'), anonymous(1)),
        short(var('ReviewerIri'), var('Reviewer')))).
clause(156, review_summary(var('Id'), automatic), proposal_state_iri(var('Id'), auto_accepted)).
clause(157, review_summary(var('Id'), pending), proposal_state_iri(var('Id'), needs_review)).
clause(158,
       audit(var('Id'), var('Agent'), var('Evidence'), var('State'), var('Review')),
       (proposal(var('IdIri'), var('AgentIri'), var('EvidenceIri'), anonymous(1), anonymous(2), anonymous(3), anonymous(4)),
        proposal_state_iri(var('IdIri'), var('State')),
        review_summary(var('IdIri'), var('Review')),
        short(var('IdIri'), var('Id')),
        short(var('AgentIri'), var('Agent')),
        short(var('EvidenceIri'), var('Evidence')))).
clause(159,
       feedback_signal(language_agent, var('Id'), accepted_by_human),
       (proposal_state_iri(var('IdIri'), human_accepted), short(var('IdIri'), var('Id')))).
clause(160,
       feedback_signal(language_agent, var('Id'), rejected_by_human),
       (proposal_state_iri(var('IdIri'), human_rejected), short(var('IdIri'), var('Id')))).
clause(161,
       feedback_signal(language_agent, var('Id'), unresolved),
       (proposal_state_iri(var('IdIri'), needs_review), short(var('IdIri'), var('Id')))).
clause(162,
       symbiosis_gain(graph, accepted_machine_knowledge),
       proposal_state(p2, human_accepted)).
clause(163,
       symbiosis_gain(agent, better_operational_answer),
       recommended_action(after_review, riverside, open_local_center(riverside_school))).
clause(164,
       symbiosis_gain(human, inspectable_reason),
       decision_reason(after_review, riverside, anonymous(1))).
clause(165,
       symbiosis_gain(governance, rejected_claim_remains_outside_operational_graph),
       proposal_state(p3, human_rejected)).
clause(166,
       symbiosis_gain(rdf, accepted_and_derived_knowledge_can_be_published_back),
       result_rdf(anonymous(1), anonymous(2), anonymous(3), anonymous(4))).
clause(167, knowledge_exchange(var('X'), var('Y')), knowledge_exchange_fact(var('X'), var('Y'))).
clause(168,
       knowledge_exchange_fact(machine_to_graph, candidate(p2, riverside_school, emergency_designation, cooling_center)),
       true).
clause(169,
       knowledge_exchange_fact(graph_to_machine, constraint(central_hall, power, unstable)),
       true).
clause(170, knowledge_exchange_fact(human_to_machine, review(p2, accept)), true).
clause(171, knowledge_exchange_fact(human_to_machine, review(p3, reject)), true).
clause(172,
       knowledge_exchange_fact(machine_to_human, recommendation(after_review, riverside, open_local_center(riverside_school))),
       true).
clause(173, knowledge_exchange_fact(rdf_to_prolog, ordinary_rdf4_facts), true).
clause(174, knowledge_exchange_fact(prolog_to_rdf, materialized_ground_rdf4), true).
clause(175,
       pipeline_step(var('N'), var('Description')),
       pipeline_step_fact(var('N'), var('Description'))).
clause(176,
       pipeline_step_fact(1, 'RDF 1.2 N-Quads: named graphs keep source and governance boundaries explicit'),
       true).
clause(177,
       pipeline_step_fact(2, 'rdf-prolog-interchange: RDF becomes ordinary rdf/4 Prolog facts without a solver'),
       true).
clause(178,
       pipeline_step_fact(3, 'EyeProlog: ISO Prolog rules validate candidates, apply review policy, and derive actions'),
       true).
clause(179,
       pipeline_step_fact(4, 'EyeProlog: result_rdf/4 materializes accepted knowledge and decisions as ground RDF-shaped facts'),
       true).
clause(180,
       pipeline_step_fact(5, 'rdf-prolog-interchange: ground rdf/4 facts become RDF again for publication or federation'),
       true).
clause(181,
       cognitive_parallel(var('Prolog'), var('Human')),
       cognitive_parallel_fact(var('Prolog'), var('Human'))).
clause(182, cognitive_parallel_fact(fact, remembered_assertion), true).
clause(183, cognitive_parallel_fact(rule, reusable_generalization), true).
clause(184, cognitive_parallel_fact(query, explicit_question), true).
clause(185, cognitive_parallel_fact(variable_binding, filling_in_an_answer), true).
clause(186, cognitive_parallel_fact(backtracking, considering_alternatives), true).
clause(187, cognitive_parallel_fact(proof, giving_reasons), true).
clause(188, cognitive_parallel_fact(review, correcting_shared_knowledge), true).
clause(189,
       result_rdf(iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/emergencyDesignation'), iri('https://example.org/city/class/cooling-center'), iri('https://example.org/graph/accepted-knowledge')),
       proposal_state(p2, human_accepted)).

step(proposal_state(p1, auto_accepted),
     rule(146),
     ['Id' = p1, 'State' = auto_accepted, 'IdIri' = iri('https://example.org/city/proposal/p1')],
     [proposal_state_iri(iri('https://example.org/city/proposal/p1'), auto_accepted),
      short(iri('https://example.org/city/proposal/p1'), p1)]).
step(proposal_state_iri(iri('https://example.org/city/proposal/p1'), auto_accepted),
     rule(102),
     ['Id' = iri('https://example.org/city/proposal/p1'),
      'Evidence' = iri('https://example.org/city/evidence/transit-api-20260827'),
      'Subject' = iri('https://example.org/city/route/7'),
      'Predicate' = iri('https://example.org/vocab/status'),
      'Confidence' = 99,
      'Kind' = iri('https://example.org/city/evidence-kind/official-feed')],
     [proposal(iri('https://example.org/city/proposal/p1'), iri('https://example.org/city/agent/language-agent'), iri('https://example.org/city/evidence/transit-api-20260827'), iri('https://example.org/city/route/7'), iri('https://example.org/vocab/status'), iri('https://example.org/city/state/suspended'), 99),
      evidence_kind(iri('https://example.org/city/evidence/transit-api-20260827'), iri('https://example.org/city/evidence-kind/official-feed')),
      auto_eligible(iri('https://example.org/city/evidence-kind/official-feed')),
      99 >= 95,
      (\+ conflict_iri(iri('https://example.org/city/proposal/p1'), iri('https://example.org/city/route/7'), iri('https://example.org/vocab/status'), _Existing) ; authoritative_override(iri('https://example.org/city/evidence/transit-api-20260827'), iri('https://example.org/vocab/status')))]).
step(proposal(iri('https://example.org/city/proposal/p1'), iri('https://example.org/city/agent/language-agent'), iri('https://example.org/city/evidence/transit-api-20260827'), iri('https://example.org/city/route/7'), iri('https://example.org/vocab/status'), iri('https://example.org/city/state/suspended'), 99),
     rule(89),
     ['Id' = iri('https://example.org/city/proposal/p1'),
      'Agent' = iri('https://example.org/city/agent/language-agent'),
      'Evidence' = iri('https://example.org/city/evidence/transit-api-20260827'),
      'S' = iri('https://example.org/city/route/7'),
      'P' = iri('https://example.org/vocab/status'),
      'O' = iri('https://example.org/city/state/suspended'),
      'Confidence' = 99,
      'G' = iri('https://example.org/graph/ai-proposals'),
      'StatementP' = iri('https://example.org/vocab/statement'),
      'AgentP' = iri('https://example.org/vocab/agent'),
      'EvidenceP' = iri('https://example.org/vocab/evidence'),
      'ConfidenceP' = iri('https://example.org/vocab/confidencePercent'),
      'ConfidenceLiteral' = literal('99', datatype('http://www.w3.org/2001/XMLSchema#integer'))],
     [graph(ai_proposals, iri('https://example.org/graph/ai-proposals')),
      v(statement, iri('https://example.org/vocab/statement')),
      v(agent, iri('https://example.org/vocab/agent')),
      v(evidence, iri('https://example.org/vocab/evidence')),
      v(confidence_percent, iri('https://example.org/vocab/confidencePercent')),
      rdf(iri('https://example.org/city/proposal/p1'), iri('https://example.org/vocab/statement'), triple(iri('https://example.org/city/route/7'), iri('https://example.org/vocab/status'), iri('https://example.org/city/state/suspended')), iri('https://example.org/graph/ai-proposals')),
      rdf(iri('https://example.org/city/proposal/p1'), iri('https://example.org/vocab/agent'), iri('https://example.org/city/agent/language-agent'), iri('https://example.org/graph/ai-proposals')),
      rdf(iri('https://example.org/city/proposal/p1'), iri('https://example.org/vocab/evidence'), iri('https://example.org/city/evidence/transit-api-20260827'), iri('https://example.org/graph/ai-proposals')),
      rdf(iri('https://example.org/city/proposal/p1'), iri('https://example.org/vocab/confidencePercent'), literal('99', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/graph/ai-proposals')),
      integer_literal(literal('99', datatype('http://www.w3.org/2001/XMLSchema#integer')), 99)]).
step(graph(ai_proposals, iri('https://example.org/graph/ai-proposals')), fact(78), [], []).
step(v(statement, iri('https://example.org/vocab/statement')), fact(58), [], []).
step(v(agent, iri('https://example.org/vocab/agent')), fact(59), [], []).
step(v(evidence, iri('https://example.org/vocab/evidence')), fact(60), [], []).
step(v(confidence_percent, iri('https://example.org/vocab/confidencePercent')),
     fact(61),
     [],
     []).
step(rdf(iri('https://example.org/city/proposal/p1'), iri('https://example.org/vocab/statement'), triple(iri('https://example.org/city/route/7'), iri('https://example.org/vocab/status'), iri('https://example.org/city/state/suspended')), iri('https://example.org/graph/ai-proposals')),
     fact(34),
     [],
     []).
step(rdf(iri('https://example.org/city/proposal/p1'), iri('https://example.org/vocab/agent'), iri('https://example.org/city/agent/language-agent'), iri('https://example.org/graph/ai-proposals')),
     fact(35),
     [],
     []).
step(rdf(iri('https://example.org/city/proposal/p1'), iri('https://example.org/vocab/evidence'), iri('https://example.org/city/evidence/transit-api-20260827'), iri('https://example.org/graph/ai-proposals')),
     fact(36),
     [],
     []).
step(rdf(iri('https://example.org/city/proposal/p1'), iri('https://example.org/vocab/confidencePercent'), literal('99', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/graph/ai-proposals')),
     fact(37),
     [],
     []).
step(integer_literal(literal('99', datatype('http://www.w3.org/2001/XMLSchema#integer')), 99),
     rule(88),
     ['Text' = '99', 'Number' = 99, 'Chars' = "99"],
     [atom_chars('99', "99"), number_chars(99, "99")]).
step(atom_chars('99', "99"), builtin, [], []).
step(number_chars(99, "99"), builtin, [], []).
step(evidence_kind(iri('https://example.org/city/evidence/transit-api-20260827'), iri('https://example.org/city/evidence-kind/official-feed')),
     rule(90),
     ['Evidence' = iri('https://example.org/city/evidence/transit-api-20260827'),
      'Kind' = iri('https://example.org/city/evidence-kind/official-feed'),
      'G' = iri('https://example.org/graph/evidence-registry'),
      'Predicate' = iri('https://example.org/vocab/evidenceKind')],
     [graph(evidence_registry, iri('https://example.org/graph/evidence-registry')),
      v(evidence_kind, iri('https://example.org/vocab/evidenceKind')),
      rdf(iri('https://example.org/city/evidence/transit-api-20260827'), iri('https://example.org/vocab/evidenceKind'), iri('https://example.org/city/evidence-kind/official-feed'), iri('https://example.org/graph/evidence-registry'))]).
step(graph(evidence_registry, iri('https://example.org/graph/evidence-registry')),
     fact(80),
     [],
     []).
step(v(evidence_kind, iri('https://example.org/vocab/evidenceKind')), fact(62), [], []).
step(rdf(iri('https://example.org/city/evidence/transit-api-20260827'), iri('https://example.org/vocab/evidenceKind'), iri('https://example.org/city/evidence-kind/official-feed'), iri('https://example.org/graph/evidence-registry')),
     fact(26),
     [],
     []).
step(auto_eligible(iri('https://example.org/city/evidence-kind/official-feed')),
     fact(94),
     [],
     []).
step(99 >= 95, builtin, [], []).
step((\+ conflict_iri(iri('https://example.org/city/proposal/p1'), iri('https://example.org/city/route/7'), iri('https://example.org/vocab/status'), _Existing) ; authoritative_override(iri('https://example.org/city/evidence/transit-api-20260827'), iri('https://example.org/vocab/status'))),
     builtin,
     [],
     []).
step(short(iri('https://example.org/city/proposal/p1'), p1), fact(125), [], []).
step(proposal_state(p2, human_accepted),
     rule(146),
     ['Id' = p2,
      'State' = human_accepted,
      'IdIri' = iri('https://example.org/city/proposal/p2')],
     [proposal_state_iri(iri('https://example.org/city/proposal/p2'), human_accepted),
      short(iri('https://example.org/city/proposal/p2'), p2)]).
step(proposal_state_iri(iri('https://example.org/city/proposal/p2'), human_accepted),
     rule(103),
     ['Id' = iri('https://example.org/city/proposal/p2')],
     [proposal(iri('https://example.org/city/proposal/p2'), iri('https://example.org/city/agent/language-agent'), iri('https://example.org/city/evidence/facilities-bulletin-20260827'), iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/emergencyDesignation'), iri('https://example.org/city/class/cooling-center'), 93),
      human_review(iri('https://example.org/city/proposal/p2'), iri('https://example.org/city/actor/emergency-coordinator'), accept, 'facility bulletin verified by phone')]).
step(proposal(iri('https://example.org/city/proposal/p2'), iri('https://example.org/city/agent/language-agent'), iri('https://example.org/city/evidence/facilities-bulletin-20260827'), iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/emergencyDesignation'), iri('https://example.org/city/class/cooling-center'), 93),
     rule(89),
     ['Id' = iri('https://example.org/city/proposal/p2'),
      'Agent' = iri('https://example.org/city/agent/language-agent'),
      'Evidence' = iri('https://example.org/city/evidence/facilities-bulletin-20260827'),
      'S' = iri('https://example.org/city/facility/riverside-school'),
      'P' = iri('https://example.org/vocab/emergencyDesignation'),
      'O' = iri('https://example.org/city/class/cooling-center'),
      'Confidence' = 93,
      'G' = iri('https://example.org/graph/ai-proposals'),
      'StatementP' = iri('https://example.org/vocab/statement'),
      'AgentP' = iri('https://example.org/vocab/agent'),
      'EvidenceP' = iri('https://example.org/vocab/evidence'),
      'ConfidenceP' = iri('https://example.org/vocab/confidencePercent'),
      'ConfidenceLiteral' = literal('93', datatype('http://www.w3.org/2001/XMLSchema#integer'))],
     [graph(ai_proposals, iri('https://example.org/graph/ai-proposals')),
      v(statement, iri('https://example.org/vocab/statement')),
      v(agent, iri('https://example.org/vocab/agent')),
      v(evidence, iri('https://example.org/vocab/evidence')),
      v(confidence_percent, iri('https://example.org/vocab/confidencePercent')),
      rdf(iri('https://example.org/city/proposal/p2'), iri('https://example.org/vocab/statement'), triple(iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/emergencyDesignation'), iri('https://example.org/city/class/cooling-center')), iri('https://example.org/graph/ai-proposals')),
      rdf(iri('https://example.org/city/proposal/p2'), iri('https://example.org/vocab/agent'), iri('https://example.org/city/agent/language-agent'), iri('https://example.org/graph/ai-proposals')),
      rdf(iri('https://example.org/city/proposal/p2'), iri('https://example.org/vocab/evidence'), iri('https://example.org/city/evidence/facilities-bulletin-20260827'), iri('https://example.org/graph/ai-proposals')),
      rdf(iri('https://example.org/city/proposal/p2'), iri('https://example.org/vocab/confidencePercent'), literal('93', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/graph/ai-proposals')),
      integer_literal(literal('93', datatype('http://www.w3.org/2001/XMLSchema#integer')), 93)]).
step(rdf(iri('https://example.org/city/proposal/p2'), iri('https://example.org/vocab/statement'), triple(iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/emergencyDesignation'), iri('https://example.org/city/class/cooling-center')), iri('https://example.org/graph/ai-proposals')),
     fact(38),
     [],
     []).
step(rdf(iri('https://example.org/city/proposal/p2'), iri('https://example.org/vocab/agent'), iri('https://example.org/city/agent/language-agent'), iri('https://example.org/graph/ai-proposals')),
     fact(39),
     [],
     []).
step(rdf(iri('https://example.org/city/proposal/p2'), iri('https://example.org/vocab/evidence'), iri('https://example.org/city/evidence/facilities-bulletin-20260827'), iri('https://example.org/graph/ai-proposals')),
     fact(40),
     [],
     []).
step(rdf(iri('https://example.org/city/proposal/p2'), iri('https://example.org/vocab/confidencePercent'), literal('93', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/graph/ai-proposals')),
     fact(41),
     [],
     []).
step(integer_literal(literal('93', datatype('http://www.w3.org/2001/XMLSchema#integer')), 93),
     rule(88),
     ['Text' = '93', 'Number' = 93, 'Chars' = "93"],
     [atom_chars('93', "93"), number_chars(93, "93")]).
step(atom_chars('93', "93"), builtin, [], []).
step(number_chars(93, "93"), builtin, [], []).
step(human_review(iri('https://example.org/city/proposal/p2'), iri('https://example.org/city/actor/emergency-coordinator'), accept, 'facility bulletin verified by phone'),
     rule(91),
     ['Id' = iri('https://example.org/city/proposal/p2'),
      'Reviewer' = iri('https://example.org/city/actor/emergency-coordinator'),
      'Decision' = accept,
      'Note' = 'facility bulletin verified by phone',
      'G' = iri('https://example.org/graph/human-review'),
      'AboutP' = iri('https://example.org/vocab/aboutProposal'),
      'ReviewerP' = iri('https://example.org/vocab/reviewer'),
      'DecisionP' = iri('https://example.org/vocab/decision'),
      'NoteP' = iri('https://example.org/vocab/note'),
      'Review' = iri('https://example.org/city/review/r2'),
      'DecisionIri' = iri('https://example.org/city/decision/accept')],
     [graph(human_review, iri('https://example.org/graph/human-review')),
      v(about_proposal, iri('https://example.org/vocab/aboutProposal')),
      v(reviewer, iri('https://example.org/vocab/reviewer')),
      v(decision, iri('https://example.org/vocab/decision')),
      v(note, iri('https://example.org/vocab/note')),
      rdf(iri('https://example.org/city/review/r2'), iri('https://example.org/vocab/aboutProposal'), iri('https://example.org/city/proposal/p2'), iri('https://example.org/graph/human-review')),
      rdf(iri('https://example.org/city/review/r2'), iri('https://example.org/vocab/reviewer'), iri('https://example.org/city/actor/emergency-coordinator'), iri('https://example.org/graph/human-review')),
      rdf(iri('https://example.org/city/review/r2'), iri('https://example.org/vocab/decision'), iri('https://example.org/city/decision/accept'), iri('https://example.org/graph/human-review')),
      rdf(iri('https://example.org/city/review/r2'), iri('https://example.org/vocab/note'), literal('facility bulletin verified by phone', datatype('http://www.w3.org/2001/XMLSchema#string')), iri('https://example.org/graph/human-review')),
      decision_atom(iri('https://example.org/city/decision/accept'), accept)]).
step(graph(human_review, iri('https://example.org/graph/human-review')), fact(79), [], []).
step(v(about_proposal, iri('https://example.org/vocab/aboutProposal')), fact(63), [], []).
step(v(reviewer, iri('https://example.org/vocab/reviewer')), fact(64), [], []).
step(v(decision, iri('https://example.org/vocab/decision')), fact(65), [], []).
step(v(note, iri('https://example.org/vocab/note')), fact(66), [], []).
step(rdf(iri('https://example.org/city/review/r2'), iri('https://example.org/vocab/aboutProposal'), iri('https://example.org/city/proposal/p2'), iri('https://example.org/graph/human-review')),
     fact(50),
     [],
     []).
step(rdf(iri('https://example.org/city/review/r2'), iri('https://example.org/vocab/reviewer'), iri('https://example.org/city/actor/emergency-coordinator'), iri('https://example.org/graph/human-review')),
     fact(51),
     [],
     []).
step(rdf(iri('https://example.org/city/review/r2'), iri('https://example.org/vocab/decision'), iri('https://example.org/city/decision/accept'), iri('https://example.org/graph/human-review')),
     fact(52),
     [],
     []).
step(rdf(iri('https://example.org/city/review/r2'), iri('https://example.org/vocab/note'), literal('facility bulletin verified by phone', datatype('http://www.w3.org/2001/XMLSchema#string')), iri('https://example.org/graph/human-review')),
     fact(53),
     [],
     []).
step(decision_atom(iri('https://example.org/city/decision/accept'), accept), fact(92), [], []).
step(short(iri('https://example.org/city/proposal/p2'), p2), fact(126), [], []).
step(proposal_state(p3, human_rejected),
     rule(146),
     ['Id' = p3,
      'State' = human_rejected,
      'IdIri' = iri('https://example.org/city/proposal/p3')],
     [proposal_state_iri(iri('https://example.org/city/proposal/p3'), human_rejected),
      short(iri('https://example.org/city/proposal/p3'), p3)]).
step(proposal_state_iri(iri('https://example.org/city/proposal/p3'), human_rejected),
     rule(104),
     ['Id' = iri('https://example.org/city/proposal/p3')],
     [proposal(iri('https://example.org/city/proposal/p3'), iri('https://example.org/city/agent/language-agent'), iri('https://example.org/city/evidence/community-post-4812'), iri('https://example.org/city/facility/central-hall'), iri('https://example.org/vocab/status'), iri('https://example.org/city/state/closed'), 78),
      human_review(iri('https://example.org/city/proposal/p3'), iri('https://example.org/city/actor/operations-officer'), reject, 'official operations desk confirms Central Hall is open')]).
step(proposal(iri('https://example.org/city/proposal/p3'), iri('https://example.org/city/agent/language-agent'), iri('https://example.org/city/evidence/community-post-4812'), iri('https://example.org/city/facility/central-hall'), iri('https://example.org/vocab/status'), iri('https://example.org/city/state/closed'), 78),
     rule(89),
     ['Id' = iri('https://example.org/city/proposal/p3'),
      'Agent' = iri('https://example.org/city/agent/language-agent'),
      'Evidence' = iri('https://example.org/city/evidence/community-post-4812'),
      'S' = iri('https://example.org/city/facility/central-hall'),
      'P' = iri('https://example.org/vocab/status'),
      'O' = iri('https://example.org/city/state/closed'),
      'Confidence' = 78,
      'G' = iri('https://example.org/graph/ai-proposals'),
      'StatementP' = iri('https://example.org/vocab/statement'),
      'AgentP' = iri('https://example.org/vocab/agent'),
      'EvidenceP' = iri('https://example.org/vocab/evidence'),
      'ConfidenceP' = iri('https://example.org/vocab/confidencePercent'),
      'ConfidenceLiteral' = literal('78', datatype('http://www.w3.org/2001/XMLSchema#integer'))],
     [graph(ai_proposals, iri('https://example.org/graph/ai-proposals')),
      v(statement, iri('https://example.org/vocab/statement')),
      v(agent, iri('https://example.org/vocab/agent')),
      v(evidence, iri('https://example.org/vocab/evidence')),
      v(confidence_percent, iri('https://example.org/vocab/confidencePercent')),
      rdf(iri('https://example.org/city/proposal/p3'), iri('https://example.org/vocab/statement'), triple(iri('https://example.org/city/facility/central-hall'), iri('https://example.org/vocab/status'), iri('https://example.org/city/state/closed')), iri('https://example.org/graph/ai-proposals')),
      rdf(iri('https://example.org/city/proposal/p3'), iri('https://example.org/vocab/agent'), iri('https://example.org/city/agent/language-agent'), iri('https://example.org/graph/ai-proposals')),
      rdf(iri('https://example.org/city/proposal/p3'), iri('https://example.org/vocab/evidence'), iri('https://example.org/city/evidence/community-post-4812'), iri('https://example.org/graph/ai-proposals')),
      rdf(iri('https://example.org/city/proposal/p3'), iri('https://example.org/vocab/confidencePercent'), literal('78', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/graph/ai-proposals')),
      integer_literal(literal('78', datatype('http://www.w3.org/2001/XMLSchema#integer')), 78)]).
step(rdf(iri('https://example.org/city/proposal/p3'), iri('https://example.org/vocab/statement'), triple(iri('https://example.org/city/facility/central-hall'), iri('https://example.org/vocab/status'), iri('https://example.org/city/state/closed')), iri('https://example.org/graph/ai-proposals')),
     fact(42),
     [],
     []).
step(rdf(iri('https://example.org/city/proposal/p3'), iri('https://example.org/vocab/agent'), iri('https://example.org/city/agent/language-agent'), iri('https://example.org/graph/ai-proposals')),
     fact(43),
     [],
     []).
step(rdf(iri('https://example.org/city/proposal/p3'), iri('https://example.org/vocab/evidence'), iri('https://example.org/city/evidence/community-post-4812'), iri('https://example.org/graph/ai-proposals')),
     fact(44),
     [],
     []).
step(rdf(iri('https://example.org/city/proposal/p3'), iri('https://example.org/vocab/confidencePercent'), literal('78', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/graph/ai-proposals')),
     fact(45),
     [],
     []).
step(integer_literal(literal('78', datatype('http://www.w3.org/2001/XMLSchema#integer')), 78),
     rule(88),
     ['Text' = '78', 'Number' = 78, 'Chars' = "78"],
     [atom_chars('78', "78"), number_chars(78, "78")]).
step(atom_chars('78', "78"), builtin, [], []).
step(number_chars(78, "78"), builtin, [], []).
step(human_review(iri('https://example.org/city/proposal/p3'), iri('https://example.org/city/actor/operations-officer'), reject, 'official operations desk confirms Central Hall is open'),
     rule(91),
     ['Id' = iri('https://example.org/city/proposal/p3'),
      'Reviewer' = iri('https://example.org/city/actor/operations-officer'),
      'Decision' = reject,
      'Note' = 'official operations desk confirms Central Hall is open',
      'G' = iri('https://example.org/graph/human-review'),
      'AboutP' = iri('https://example.org/vocab/aboutProposal'),
      'ReviewerP' = iri('https://example.org/vocab/reviewer'),
      'DecisionP' = iri('https://example.org/vocab/decision'),
      'NoteP' = iri('https://example.org/vocab/note'),
      'Review' = iri('https://example.org/city/review/r3'),
      'DecisionIri' = iri('https://example.org/city/decision/reject')],
     [graph(human_review, iri('https://example.org/graph/human-review')),
      v(about_proposal, iri('https://example.org/vocab/aboutProposal')),
      v(reviewer, iri('https://example.org/vocab/reviewer')),
      v(decision, iri('https://example.org/vocab/decision')),
      v(note, iri('https://example.org/vocab/note')),
      rdf(iri('https://example.org/city/review/r3'), iri('https://example.org/vocab/aboutProposal'), iri('https://example.org/city/proposal/p3'), iri('https://example.org/graph/human-review')),
      rdf(iri('https://example.org/city/review/r3'), iri('https://example.org/vocab/reviewer'), iri('https://example.org/city/actor/operations-officer'), iri('https://example.org/graph/human-review')),
      rdf(iri('https://example.org/city/review/r3'), iri('https://example.org/vocab/decision'), iri('https://example.org/city/decision/reject'), iri('https://example.org/graph/human-review')),
      rdf(iri('https://example.org/city/review/r3'), iri('https://example.org/vocab/note'), literal('official operations desk confirms Central Hall is open', datatype('http://www.w3.org/2001/XMLSchema#string')), iri('https://example.org/graph/human-review')),
      decision_atom(iri('https://example.org/city/decision/reject'), reject)]).
step(rdf(iri('https://example.org/city/review/r3'), iri('https://example.org/vocab/aboutProposal'), iri('https://example.org/city/proposal/p3'), iri('https://example.org/graph/human-review')),
     fact(54),
     [],
     []).
step(rdf(iri('https://example.org/city/review/r3'), iri('https://example.org/vocab/reviewer'), iri('https://example.org/city/actor/operations-officer'), iri('https://example.org/graph/human-review')),
     fact(55),
     [],
     []).
step(rdf(iri('https://example.org/city/review/r3'), iri('https://example.org/vocab/decision'), iri('https://example.org/city/decision/reject'), iri('https://example.org/graph/human-review')),
     fact(56),
     [],
     []).
step(rdf(iri('https://example.org/city/review/r3'), iri('https://example.org/vocab/note'), literal('official operations desk confirms Central Hall is open', datatype('http://www.w3.org/2001/XMLSchema#string')), iri('https://example.org/graph/human-review')),
     fact(57),
     [],
     []).
step(decision_atom(iri('https://example.org/city/decision/reject'), reject), fact(93), [], []).
step(short(iri('https://example.org/city/proposal/p3'), p3), fact(127), [], []).
step(proposal_state(p4, needs_review),
     rule(146),
     ['Id' = p4, 'State' = needs_review, 'IdIri' = iri('https://example.org/city/proposal/p4')],
     [proposal_state_iri(iri('https://example.org/city/proposal/p4'), needs_review),
      short(iri('https://example.org/city/proposal/p4'), p4)]).
step(proposal_state_iri(iri('https://example.org/city/proposal/p4'), needs_review),
     rule(105),
     ['Id' = iri('https://example.org/city/proposal/p4')],
     [proposal(iri('https://example.org/city/proposal/p4'), iri('https://example.org/city/agent/language-agent'), iri('https://example.org/city/evidence/volunteer-message-112'), iri('https://example.org/city/facility/north-library'), iri('https://example.org/vocab/capacity'), literal('40', datatype('http://www.w3.org/2001/XMLSchema#integer')), 66),
      \+ proposal_state_iri(iri('https://example.org/city/proposal/p4'), auto_accepted),
      \+ human_review(iri('https://example.org/city/proposal/p4'), _Reviewer, _Decision, _Note)]).
step(proposal(iri('https://example.org/city/proposal/p4'), iri('https://example.org/city/agent/language-agent'), iri('https://example.org/city/evidence/volunteer-message-112'), iri('https://example.org/city/facility/north-library'), iri('https://example.org/vocab/capacity'), literal('40', datatype('http://www.w3.org/2001/XMLSchema#integer')), 66),
     rule(89),
     ['Id' = iri('https://example.org/city/proposal/p4'),
      'Agent' = iri('https://example.org/city/agent/language-agent'),
      'Evidence' = iri('https://example.org/city/evidence/volunteer-message-112'),
      'S' = iri('https://example.org/city/facility/north-library'),
      'P' = iri('https://example.org/vocab/capacity'),
      'O' = literal('40', datatype('http://www.w3.org/2001/XMLSchema#integer')),
      'Confidence' = 66,
      'G' = iri('https://example.org/graph/ai-proposals'),
      'StatementP' = iri('https://example.org/vocab/statement'),
      'AgentP' = iri('https://example.org/vocab/agent'),
      'EvidenceP' = iri('https://example.org/vocab/evidence'),
      'ConfidenceP' = iri('https://example.org/vocab/confidencePercent'),
      'ConfidenceLiteral' = literal('66', datatype('http://www.w3.org/2001/XMLSchema#integer'))],
     [graph(ai_proposals, iri('https://example.org/graph/ai-proposals')),
      v(statement, iri('https://example.org/vocab/statement')),
      v(agent, iri('https://example.org/vocab/agent')),
      v(evidence, iri('https://example.org/vocab/evidence')),
      v(confidence_percent, iri('https://example.org/vocab/confidencePercent')),
      rdf(iri('https://example.org/city/proposal/p4'), iri('https://example.org/vocab/statement'), triple(iri('https://example.org/city/facility/north-library'), iri('https://example.org/vocab/capacity'), literal('40', datatype('http://www.w3.org/2001/XMLSchema#integer'))), iri('https://example.org/graph/ai-proposals')),
      rdf(iri('https://example.org/city/proposal/p4'), iri('https://example.org/vocab/agent'), iri('https://example.org/city/agent/language-agent'), iri('https://example.org/graph/ai-proposals')),
      rdf(iri('https://example.org/city/proposal/p4'), iri('https://example.org/vocab/evidence'), iri('https://example.org/city/evidence/volunteer-message-112'), iri('https://example.org/graph/ai-proposals')),
      rdf(iri('https://example.org/city/proposal/p4'), iri('https://example.org/vocab/confidencePercent'), literal('66', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/graph/ai-proposals')),
      integer_literal(literal('66', datatype('http://www.w3.org/2001/XMLSchema#integer')), 66)]).
step(rdf(iri('https://example.org/city/proposal/p4'), iri('https://example.org/vocab/statement'), triple(iri('https://example.org/city/facility/north-library'), iri('https://example.org/vocab/capacity'), literal('40', datatype('http://www.w3.org/2001/XMLSchema#integer'))), iri('https://example.org/graph/ai-proposals')),
     fact(46),
     [],
     []).
step(rdf(iri('https://example.org/city/proposal/p4'), iri('https://example.org/vocab/agent'), iri('https://example.org/city/agent/language-agent'), iri('https://example.org/graph/ai-proposals')),
     fact(47),
     [],
     []).
step(rdf(iri('https://example.org/city/proposal/p4'), iri('https://example.org/vocab/evidence'), iri('https://example.org/city/evidence/volunteer-message-112'), iri('https://example.org/graph/ai-proposals')),
     fact(48),
     [],
     []).
step(rdf(iri('https://example.org/city/proposal/p4'), iri('https://example.org/vocab/confidencePercent'), literal('66', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/graph/ai-proposals')),
     fact(49),
     [],
     []).
step(integer_literal(literal('66', datatype('http://www.w3.org/2001/XMLSchema#integer')), 66),
     rule(88),
     ['Text' = '66', 'Number' = 66, 'Chars' = "66"],
     [atom_chars('66', "66"), number_chars(66, "66")]).
step(atom_chars('66', "66"), builtin, [], []).
step(number_chars(66, "66"), builtin, [], []).
step(\+ proposal_state_iri(iri('https://example.org/city/proposal/p4'), auto_accepted),
     absent,
     [],
     []).
step(\+ human_review(iri('https://example.org/city/proposal/p4'), _Reviewer, _Decision, _Note),
     absent,
     [],
     []).
step(short(iri('https://example.org/city/proposal/p4'), p4), fact(128), [], []).
step(conflict(p1, route_7, status, running),
     rule(147),
     ['Id' = p1,
      'Subject' = route_7,
      'Predicate' = status,
      'Existing' = running,
      'IdIri' = iri('https://example.org/city/proposal/p1'),
      'SubjectIri' = iri('https://example.org/city/route/7'),
      'PredicateIri' = iri('https://example.org/vocab/status'),
      'ExistingIri' = iri('https://example.org/city/state/running')],
     [conflict_iri(iri('https://example.org/city/proposal/p1'), iri('https://example.org/city/route/7'), iri('https://example.org/vocab/status'), iri('https://example.org/city/state/running')),
      short(iri('https://example.org/city/proposal/p1'), p1),
      short(iri('https://example.org/city/route/7'), route_7),
      short(iri('https://example.org/vocab/status'), status),
      short(iri('https://example.org/city/state/running'), running)]).
step(conflict_iri(iri('https://example.org/city/proposal/p1'), iri('https://example.org/city/route/7'), iri('https://example.org/vocab/status'), iri('https://example.org/city/state/running')),
     rule(101),
     ['Id' = iri('https://example.org/city/proposal/p1'),
      'Subject' = iri('https://example.org/city/route/7'),
      'Predicate' = iri('https://example.org/vocab/status'),
      'Existing' = iri('https://example.org/city/state/running'),
      'Proposed' = iri('https://example.org/city/state/suspended')],
     [proposal(iri('https://example.org/city/proposal/p1'), iri('https://example.org/city/agent/language-agent'), iri('https://example.org/city/evidence/transit-api-20260827'), iri('https://example.org/city/route/7'), iri('https://example.org/vocab/status'), iri('https://example.org/city/state/suspended'), 99),
      curated(iri('https://example.org/city/route/7'), iri('https://example.org/vocab/status'), iri('https://example.org/city/state/running')),
      opposite(iri('https://example.org/city/state/suspended'), iri('https://example.org/city/state/running'))]).
step(curated(iri('https://example.org/city/route/7'), iri('https://example.org/vocab/status'), iri('https://example.org/city/state/running')),
     rule(87),
     ['S' = iri('https://example.org/city/route/7'),
      'P' = iri('https://example.org/vocab/status'),
      'O' = iri('https://example.org/city/state/running'),
      'G' = iri('https://example.org/graph/transit-plan')],
     [rdf(iri('https://example.org/city/route/7'), iri('https://example.org/vocab/status'), iri('https://example.org/city/state/running'), iri('https://example.org/graph/transit-plan')),
      curated_graph(iri('https://example.org/graph/transit-plan'))]).
step(rdf(iri('https://example.org/city/route/7'), iri('https://example.org/vocab/status'), iri('https://example.org/city/state/running'), iri('https://example.org/graph/transit-plan')),
     fact(23),
     [],
     []).
step(curated_graph(iri('https://example.org/graph/transit-plan')), fact(85), [], []).
step(opposite(iri('https://example.org/city/state/suspended'), iri('https://example.org/city/state/running')),
     fact(100),
     [],
     []).
step(short(iri('https://example.org/city/route/7'), route_7), fact(140), [], []).
step(short(iri('https://example.org/vocab/status'), status), fact(141), [], []).
step(short(iri('https://example.org/city/state/running'), running), fact(143), [], []).
step(conflict(p3, central_hall, status, open),
     rule(147),
     ['Id' = p3,
      'Subject' = central_hall,
      'Predicate' = status,
      'Existing' = open,
      'IdIri' = iri('https://example.org/city/proposal/p3'),
      'SubjectIri' = iri('https://example.org/city/facility/central-hall'),
      'PredicateIri' = iri('https://example.org/vocab/status'),
      'ExistingIri' = iri('https://example.org/city/state/open')],
     [conflict_iri(iri('https://example.org/city/proposal/p3'), iri('https://example.org/city/facility/central-hall'), iri('https://example.org/vocab/status'), iri('https://example.org/city/state/open')),
      short(iri('https://example.org/city/proposal/p3'), p3),
      short(iri('https://example.org/city/facility/central-hall'), central_hall),
      short(iri('https://example.org/vocab/status'), status),
      short(iri('https://example.org/city/state/open'), open)]).
step(conflict_iri(iri('https://example.org/city/proposal/p3'), iri('https://example.org/city/facility/central-hall'), iri('https://example.org/vocab/status'), iri('https://example.org/city/state/open')),
     rule(101),
     ['Id' = iri('https://example.org/city/proposal/p3'),
      'Subject' = iri('https://example.org/city/facility/central-hall'),
      'Predicate' = iri('https://example.org/vocab/status'),
      'Existing' = iri('https://example.org/city/state/open'),
      'Proposed' = iri('https://example.org/city/state/closed')],
     [proposal(iri('https://example.org/city/proposal/p3'), iri('https://example.org/city/agent/language-agent'), iri('https://example.org/city/evidence/community-post-4812'), iri('https://example.org/city/facility/central-hall'), iri('https://example.org/vocab/status'), iri('https://example.org/city/state/closed'), 78),
      curated(iri('https://example.org/city/facility/central-hall'), iri('https://example.org/vocab/status'), iri('https://example.org/city/state/open')),
      opposite(iri('https://example.org/city/state/closed'), iri('https://example.org/city/state/open'))]).
step(curated(iri('https://example.org/city/facility/central-hall'), iri('https://example.org/vocab/status'), iri('https://example.org/city/state/open')),
     rule(87),
     ['S' = iri('https://example.org/city/facility/central-hall'),
      'P' = iri('https://example.org/vocab/status'),
      'O' = iri('https://example.org/city/state/open'),
      'G' = iri('https://example.org/graph/city-facilities')],
     [rdf(iri('https://example.org/city/facility/central-hall'), iri('https://example.org/vocab/status'), iri('https://example.org/city/state/open'), iri('https://example.org/graph/city-facilities')),
      curated_graph(iri('https://example.org/graph/city-facilities'))]).
step(rdf(iri('https://example.org/city/facility/central-hall'), iri('https://example.org/vocab/status'), iri('https://example.org/city/state/open'), iri('https://example.org/graph/city-facilities')),
     fact(3),
     [],
     []).
step(curated_graph(iri('https://example.org/graph/city-facilities')), fact(83), [], []).
step(opposite(iri('https://example.org/city/state/closed'), iri('https://example.org/city/state/open')),
     fact(98),
     [],
     []).
step(short(iri('https://example.org/city/facility/central-hall'), central_hall),
     fact(136),
     [],
     []).
step(short(iri('https://example.org/city/state/open'), open), fact(144), [], []).
step(knowledge_gain(riverside_school, emergency_designation, cooling_center),
     rule(148),
     ['Subject' = riverside_school,
      'Predicate' = emergency_designation,
      'Object' = cooling_center,
      'SubjectIri' = iri('https://example.org/city/facility/riverside-school'),
      'PredicateIri' = iri('https://example.org/vocab/emergencyDesignation'),
      'ObjectIri' = iri('https://example.org/city/class/cooling-center')],
     [knowledge_gain_iri(iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/emergencyDesignation'), iri('https://example.org/city/class/cooling-center')),
      short(iri('https://example.org/city/facility/riverside-school'), riverside_school),
      short(iri('https://example.org/vocab/emergencyDesignation'), emergency_designation),
      short(iri('https://example.org/city/class/cooling-center'), cooling_center)]).
step(knowledge_gain_iri(iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/emergencyDesignation'), iri('https://example.org/city/class/cooling-center')),
     rule(114),
     ['S' = iri('https://example.org/city/facility/riverside-school'),
      'P' = iri('https://example.org/vocab/emergencyDesignation'),
      'O' = iri('https://example.org/city/class/cooling-center')],
     [known(after_review, iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/emergencyDesignation'), iri('https://example.org/city/class/cooling-center')),
      \+ known(before_review, iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/emergencyDesignation'), iri('https://example.org/city/class/cooling-center'))]).
step(known(after_review, iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/emergencyDesignation'), iri('https://example.org/city/class/cooling-center')),
     rule(113),
     ['Stage' = after_review,
      'S' = iri('https://example.org/city/facility/riverside-school'),
      'P' = iri('https://example.org/vocab/emergencyDesignation'),
      'O' = iri('https://example.org/city/class/cooling-center'),
      'Id' = iri('https://example.org/city/proposal/p2')],
     [proposal(iri('https://example.org/city/proposal/p2'), iri('https://example.org/city/agent/language-agent'), iri('https://example.org/city/evidence/facilities-bulletin-20260827'), iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/emergencyDesignation'), iri('https://example.org/city/class/cooling-center'), 93),
      accepted(after_review, iri('https://example.org/city/proposal/p2'))]).
step(accepted(after_review, iri('https://example.org/city/proposal/p2')),
     rule(110),
     ['Id' = iri('https://example.org/city/proposal/p2')],
     [proposal_state_iri(iri('https://example.org/city/proposal/p2'), human_accepted)]).
step(\+ known(before_review, iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/emergencyDesignation'), iri('https://example.org/city/class/cooling-center')),
     absent,
     [],
     []).
step(short(iri('https://example.org/city/facility/riverside-school'), riverside_school),
     fact(138),
     [],
     []).
step(short(iri('https://example.org/vocab/emergencyDesignation'), emergency_designation),
     fact(142),
     [],
     []).
step(short(iri('https://example.org/city/class/cooling-center'), cooling_center),
     fact(145),
     [],
     []).
step(recommended_action(after_review, riverside, open_local_center(riverside_school)),
     rule(152),
     ['Stage' = after_review,
      'Neighbourhood' = riverside,
      'Action' = open_local_center(riverside_school),
      'NeighbourhoodIri' = iri('https://example.org/city/neighbourhood/riverside'),
      'ActionIri' = open_local_center(iri('https://example.org/city/facility/riverside-school'))],
     [recommended_action_iri(after_review, iri('https://example.org/city/neighbourhood/riverside'), open_local_center(iri('https://example.org/city/facility/riverside-school'))),
      short(iri('https://example.org/city/neighbourhood/riverside'), riverside),
      friendly_action(open_local_center(iri('https://example.org/city/facility/riverside-school')), open_local_center(riverside_school))]).
step(recommended_action_iri(after_review, iri('https://example.org/city/neighbourhood/riverside'), open_local_center(iri('https://example.org/city/facility/riverside-school'))),
     rule(122),
     ['Stage' = after_review,
      'Neighbourhood' = iri('https://example.org/city/neighbourhood/riverside'),
      'Center' = iri('https://example.org/city/facility/riverside-school')],
     [stage(after_review),
      local_center(after_review, iri('https://example.org/city/neighbourhood/riverside'), iri('https://example.org/city/facility/riverside-school'))]).
step(stage(after_review), fact(107), [], []).
step(local_center(after_review, iri('https://example.org/city/neighbourhood/riverside'), iri('https://example.org/city/facility/riverside-school')),
     rule(120),
     ['Stage' = after_review,
      'Neighbourhood' = iri('https://example.org/city/neighbourhood/riverside'),
      'Center' = iri('https://example.org/city/facility/riverside-school'),
      'NeighbourhoodP' = iri('https://example.org/vocab/neighbourhood')],
     [operational_center(after_review, iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/city/neighbourhood/riverside')),
      v(neighbourhood, iri('https://example.org/vocab/neighbourhood')),
      known(after_review, iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/neighbourhood'), iri('https://example.org/city/neighbourhood/riverside'))]).
step(operational_center(after_review, iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/city/neighbourhood/riverside')),
     rule(119),
     ['Stage' = after_review,
      'Center' = iri('https://example.org/city/facility/riverside-school'),
      'Neighbourhood' = iri('https://example.org/city/neighbourhood/riverside'),
      'StatusP' = iri('https://example.org/vocab/status'),
      'CoolingP' = iri('https://example.org/vocab/cooling'),
      'AccessP' = iri('https://example.org/vocab/wheelchairAccess'),
      'PowerP' = iri('https://example.org/vocab/power')],
     [cooling_center(after_review, iri('https://example.org/city/facility/riverside-school')),
      v(status, iri('https://example.org/vocab/status')),
      v(cooling, iri('https://example.org/vocab/cooling')),
      v(wheelchair_access, iri('https://example.org/vocab/wheelchairAccess')),
      v(power, iri('https://example.org/vocab/power')),
      known(after_review, iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/status'), iri('https://example.org/city/state/open')),
      known(after_review, iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/cooling'), iri('https://example.org/city/state/available')),
      known(after_review, iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/wheelchairAccess'), iri('https://example.org/city/value/yes')),
      sufficient_capacity(after_review, iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/city/neighbourhood/riverside')),
      \+ known(after_review, iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/power'), iri('https://example.org/city/state/unstable'))]).
step(cooling_center(after_review, iri('https://example.org/city/facility/riverside-school')),
     rule(116),
     ['Stage' = after_review,
      'Center' = iri('https://example.org/city/facility/riverside-school'),
      'P' = iri('https://example.org/vocab/emergencyDesignation')],
     [v(emergency_designation, iri('https://example.org/vocab/emergencyDesignation')),
      known(after_review, iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/emergencyDesignation'), iri('https://example.org/city/class/cooling-center'))]).
step(v(emergency_designation, iri('https://example.org/vocab/emergencyDesignation')),
     fact(77),
     [],
     []).
step(v(status, iri('https://example.org/vocab/status')), fact(69), [], []).
step(v(cooling, iri('https://example.org/vocab/cooling')), fact(70), [], []).
step(v(wheelchair_access, iri('https://example.org/vocab/wheelchairAccess')), fact(72), [], []).
step(v(power, iri('https://example.org/vocab/power')), fact(76), [], []).
step(known(after_review, iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/status'), iri('https://example.org/city/state/open')),
     rule(112),
     ['Stage' = after_review,
      'S' = iri('https://example.org/city/facility/riverside-school'),
      'P' = iri('https://example.org/vocab/status'),
      'O' = iri('https://example.org/city/state/open')],
     [curated(iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/status'), iri('https://example.org/city/state/open')),
      \+ has_accepted_override(after_review, iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/status'))]).
step(curated(iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/status'), iri('https://example.org/city/state/open')),
     rule(87),
     ['S' = iri('https://example.org/city/facility/riverside-school'),
      'P' = iri('https://example.org/vocab/status'),
      'O' = iri('https://example.org/city/state/open'),
      'G' = iri('https://example.org/graph/city-facilities')],
     [rdf(iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/status'), iri('https://example.org/city/state/open'), iri('https://example.org/graph/city-facilities')),
      curated_graph(iri('https://example.org/graph/city-facilities'))]).
step(rdf(iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/status'), iri('https://example.org/city/state/open'), iri('https://example.org/graph/city-facilities')),
     fact(15),
     [],
     []).
step(\+ has_accepted_override(after_review, iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/status')),
     absent,
     [],
     []).
step(known(after_review, iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/cooling'), iri('https://example.org/city/state/available')),
     rule(112),
     ['Stage' = after_review,
      'S' = iri('https://example.org/city/facility/riverside-school'),
      'P' = iri('https://example.org/vocab/cooling'),
      'O' = iri('https://example.org/city/state/available')],
     [curated(iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/cooling'), iri('https://example.org/city/state/available')),
      \+ has_accepted_override(after_review, iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/cooling'))]).
step(curated(iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/cooling'), iri('https://example.org/city/state/available')),
     rule(87),
     ['S' = iri('https://example.org/city/facility/riverside-school'),
      'P' = iri('https://example.org/vocab/cooling'),
      'O' = iri('https://example.org/city/state/available'),
      'G' = iri('https://example.org/graph/city-facilities')],
     [rdf(iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/cooling'), iri('https://example.org/city/state/available'), iri('https://example.org/graph/city-facilities')),
      curated_graph(iri('https://example.org/graph/city-facilities'))]).
step(rdf(iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/cooling'), iri('https://example.org/city/state/available'), iri('https://example.org/graph/city-facilities')),
     fact(16),
     [],
     []).
step(\+ has_accepted_override(after_review, iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/cooling')),
     absent,
     [],
     []).
step(known(after_review, iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/wheelchairAccess'), iri('https://example.org/city/value/yes')),
     rule(112),
     ['Stage' = after_review,
      'S' = iri('https://example.org/city/facility/riverside-school'),
      'P' = iri('https://example.org/vocab/wheelchairAccess'),
      'O' = iri('https://example.org/city/value/yes')],
     [curated(iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/wheelchairAccess'), iri('https://example.org/city/value/yes')),
      \+ has_accepted_override(after_review, iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/wheelchairAccess'))]).
step(curated(iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/wheelchairAccess'), iri('https://example.org/city/value/yes')),
     rule(87),
     ['S' = iri('https://example.org/city/facility/riverside-school'),
      'P' = iri('https://example.org/vocab/wheelchairAccess'),
      'O' = iri('https://example.org/city/value/yes'),
      'G' = iri('https://example.org/graph/city-facilities')],
     [rdf(iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/wheelchairAccess'), iri('https://example.org/city/value/yes'), iri('https://example.org/graph/city-facilities')),
      curated_graph(iri('https://example.org/graph/city-facilities'))]).
step(rdf(iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/wheelchairAccess'), iri('https://example.org/city/value/yes'), iri('https://example.org/graph/city-facilities')),
     fact(18),
     [],
     []).
step(\+ has_accepted_override(after_review, iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/wheelchairAccess')),
     absent,
     [],
     []).
step(sufficient_capacity(after_review, iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/city/neighbourhood/riverside')),
     rule(118),
     ['Stage' = after_review,
      'Center' = iri('https://example.org/city/facility/riverside-school'),
      'Neighbourhood' = iri('https://example.org/city/neighbourhood/riverside'),
      'CapacityP' = iri('https://example.org/vocab/capacity'),
      'DemandP' = iri('https://example.org/vocab/expectedDemand'),
      'Capacity' = 90,
      'Demand' = 70],
     [v(capacity, iri('https://example.org/vocab/capacity')),
      v(expected_demand, iri('https://example.org/vocab/expectedDemand')),
      numeric_value(after_review, iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/capacity'), 90),
      numeric_value(after_review, iri('https://example.org/city/neighbourhood/riverside'), iri('https://example.org/vocab/expectedDemand'), 70),
      90 >= 70]).
step(v(capacity, iri('https://example.org/vocab/capacity')), fact(71), [], []).
step(v(expected_demand, iri('https://example.org/vocab/expectedDemand')), fact(73), [], []).
step(numeric_value(after_review, iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/capacity'), 90),
     rule(117),
     ['Stage' = after_review,
      'S' = iri('https://example.org/city/facility/riverside-school'),
      'Predicate' = iri('https://example.org/vocab/capacity'),
      'Number' = 90,
      'Literal' = literal('90', datatype('http://www.w3.org/2001/XMLSchema#integer'))],
     [known(after_review, iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/capacity'), literal('90', datatype('http://www.w3.org/2001/XMLSchema#integer'))),
      integer_literal(literal('90', datatype('http://www.w3.org/2001/XMLSchema#integer')), 90)]).
step(known(after_review, iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/capacity'), literal('90', datatype('http://www.w3.org/2001/XMLSchema#integer'))),
     rule(112),
     ['Stage' = after_review,
      'S' = iri('https://example.org/city/facility/riverside-school'),
      'P' = iri('https://example.org/vocab/capacity'),
      'O' = literal('90', datatype('http://www.w3.org/2001/XMLSchema#integer'))],
     [curated(iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/capacity'), literal('90', datatype('http://www.w3.org/2001/XMLSchema#integer'))),
      \+ has_accepted_override(after_review, iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/capacity'))]).
step(curated(iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/capacity'), literal('90', datatype('http://www.w3.org/2001/XMLSchema#integer'))),
     rule(87),
     ['S' = iri('https://example.org/city/facility/riverside-school'),
      'P' = iri('https://example.org/vocab/capacity'),
      'O' = literal('90', datatype('http://www.w3.org/2001/XMLSchema#integer')),
      'G' = iri('https://example.org/graph/city-facilities')],
     [rdf(iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/capacity'), literal('90', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/graph/city-facilities')),
      curated_graph(iri('https://example.org/graph/city-facilities'))]).
step(rdf(iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/capacity'), literal('90', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/graph/city-facilities')),
     fact(17),
     [],
     []).
step(\+ has_accepted_override(after_review, iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/capacity')),
     absent,
     [],
     []).
step(integer_literal(literal('90', datatype('http://www.w3.org/2001/XMLSchema#integer')), 90),
     rule(88),
     ['Text' = '90', 'Number' = 90, 'Chars' = "90"],
     [atom_chars('90', "90"), number_chars(90, "90")]).
step(atom_chars('90', "90"), builtin, [], []).
step(number_chars(90, "90"), builtin, [], []).
step(numeric_value(after_review, iri('https://example.org/city/neighbourhood/riverside'), iri('https://example.org/vocab/expectedDemand'), 70),
     rule(117),
     ['Stage' = after_review,
      'S' = iri('https://example.org/city/neighbourhood/riverside'),
      'Predicate' = iri('https://example.org/vocab/expectedDemand'),
      'Number' = 70,
      'Literal' = literal('70', datatype('http://www.w3.org/2001/XMLSchema#integer'))],
     [known(after_review, iri('https://example.org/city/neighbourhood/riverside'), iri('https://example.org/vocab/expectedDemand'), literal('70', datatype('http://www.w3.org/2001/XMLSchema#integer'))),
      integer_literal(literal('70', datatype('http://www.w3.org/2001/XMLSchema#integer')), 70)]).
step(known(after_review, iri('https://example.org/city/neighbourhood/riverside'), iri('https://example.org/vocab/expectedDemand'), literal('70', datatype('http://www.w3.org/2001/XMLSchema#integer'))),
     rule(112),
     ['Stage' = after_review,
      'S' = iri('https://example.org/city/neighbourhood/riverside'),
      'P' = iri('https://example.org/vocab/expectedDemand'),
      'O' = literal('70', datatype('http://www.w3.org/2001/XMLSchema#integer'))],
     [curated(iri('https://example.org/city/neighbourhood/riverside'), iri('https://example.org/vocab/expectedDemand'), literal('70', datatype('http://www.w3.org/2001/XMLSchema#integer'))),
      \+ has_accepted_override(after_review, iri('https://example.org/city/neighbourhood/riverside'), iri('https://example.org/vocab/expectedDemand'))]).
step(curated(iri('https://example.org/city/neighbourhood/riverside'), iri('https://example.org/vocab/expectedDemand'), literal('70', datatype('http://www.w3.org/2001/XMLSchema#integer'))),
     rule(87),
     ['S' = iri('https://example.org/city/neighbourhood/riverside'),
      'P' = iri('https://example.org/vocab/expectedDemand'),
      'O' = literal('70', datatype('http://www.w3.org/2001/XMLSchema#integer')),
      'G' = iri('https://example.org/graph/emergency-plan')],
     [rdf(iri('https://example.org/city/neighbourhood/riverside'), iri('https://example.org/vocab/expectedDemand'), literal('70', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/graph/emergency-plan')),
      curated_graph(iri('https://example.org/graph/emergency-plan'))]).
step(rdf(iri('https://example.org/city/neighbourhood/riverside'), iri('https://example.org/vocab/expectedDemand'), literal('70', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/graph/emergency-plan')),
     fact(19),
     [],
     []).
step(curated_graph(iri('https://example.org/graph/emergency-plan')), fact(84), [], []).
step(\+ has_accepted_override(after_review, iri('https://example.org/city/neighbourhood/riverside'), iri('https://example.org/vocab/expectedDemand')),
     absent,
     [],
     []).
step(integer_literal(literal('70', datatype('http://www.w3.org/2001/XMLSchema#integer')), 70),
     rule(88),
     ['Text' = '70', 'Number' = 70, 'Chars' = "70"],
     [atom_chars('70', "70"), number_chars(70, "70")]).
step(atom_chars('70', "70"), builtin, [], []).
step(number_chars(70, "70"), builtin, [], []).
step(90 >= 70, builtin, [], []).
step(\+ known(after_review, iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/power'), iri('https://example.org/city/state/unstable')),
     absent,
     [],
     []).
step(v(neighbourhood, iri('https://example.org/vocab/neighbourhood')), fact(68), [], []).
step(known(after_review, iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/neighbourhood'), iri('https://example.org/city/neighbourhood/riverside')),
     rule(112),
     ['Stage' = after_review,
      'S' = iri('https://example.org/city/facility/riverside-school'),
      'P' = iri('https://example.org/vocab/neighbourhood'),
      'O' = iri('https://example.org/city/neighbourhood/riverside')],
     [curated(iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/neighbourhood'), iri('https://example.org/city/neighbourhood/riverside')),
      \+ has_accepted_override(after_review, iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/neighbourhood'))]).
step(curated(iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/neighbourhood'), iri('https://example.org/city/neighbourhood/riverside')),
     rule(87),
     ['S' = iri('https://example.org/city/facility/riverside-school'),
      'P' = iri('https://example.org/vocab/neighbourhood'),
      'O' = iri('https://example.org/city/neighbourhood/riverside'),
      'G' = iri('https://example.org/graph/city-facilities')],
     [rdf(iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/neighbourhood'), iri('https://example.org/city/neighbourhood/riverside'), iri('https://example.org/graph/city-facilities')),
      curated_graph(iri('https://example.org/graph/city-facilities'))]).
step(rdf(iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/neighbourhood'), iri('https://example.org/city/neighbourhood/riverside'), iri('https://example.org/graph/city-facilities')),
     fact(14),
     [],
     []).
step(\+ has_accepted_override(after_review, iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/neighbourhood')),
     absent,
     [],
     []).
step(short(iri('https://example.org/city/neighbourhood/riverside'), riverside),
     fact(139),
     [],
     []).
step(friendly_action(open_local_center(iri('https://example.org/city/facility/riverside-school')), open_local_center(riverside_school)),
     rule(150),
     ['CenterIri' = iri('https://example.org/city/facility/riverside-school'),
      'Center' = riverside_school],
     [short(iri('https://example.org/city/facility/riverside-school'), riverside_school)]).
step(recommended_action(before_review, riverside, deploy_mobile_unit),
     rule(152),
     ['Stage' = before_review,
      'Neighbourhood' = riverside,
      'Action' = deploy_mobile_unit,
      'NeighbourhoodIri' = iri('https://example.org/city/neighbourhood/riverside'),
      'ActionIri' = deploy_mobile_unit],
     [recommended_action_iri(before_review, iri('https://example.org/city/neighbourhood/riverside'), deploy_mobile_unit),
      short(iri('https://example.org/city/neighbourhood/riverside'), riverside),
      friendly_action(deploy_mobile_unit, deploy_mobile_unit)]).
step(recommended_action_iri(before_review, iri('https://example.org/city/neighbourhood/riverside'), deploy_mobile_unit),
     rule(124),
     ['Stage' = before_review,
      'Neighbourhood' = iri('https://example.org/city/neighbourhood/riverside'),
      'MobileP' = iri('https://example.org/vocab/mobileUnitAvailable')],
     [stage(before_review),
      \+ local_center(before_review, iri('https://example.org/city/neighbourhood/riverside'), _Local),
      \+ reachable_center(before_review, iri('https://example.org/city/neighbourhood/riverside'), _Remote),
      v(mobile_unit_available, iri('https://example.org/vocab/mobileUnitAvailable')),
      known(before_review, iri('https://example.org/city/neighbourhood/riverside'), iri('https://example.org/vocab/mobileUnitAvailable'), iri('https://example.org/city/value/yes'))]).
step(stage(before_review), fact(106), [], []).
step(\+ local_center(before_review, iri('https://example.org/city/neighbourhood/riverside'), _Local),
     absent,
     [],
     []).
step(\+ reachable_center(before_review, iri('https://example.org/city/neighbourhood/riverside'), _Remote),
     absent,
     [],
     []).
step(v(mobile_unit_available, iri('https://example.org/vocab/mobileUnitAvailable')),
     fact(74),
     [],
     []).
step(known(before_review, iri('https://example.org/city/neighbourhood/riverside'), iri('https://example.org/vocab/mobileUnitAvailable'), iri('https://example.org/city/value/yes')),
     rule(112),
     ['Stage' = before_review,
      'S' = iri('https://example.org/city/neighbourhood/riverside'),
      'P' = iri('https://example.org/vocab/mobileUnitAvailable'),
      'O' = iri('https://example.org/city/value/yes')],
     [curated(iri('https://example.org/city/neighbourhood/riverside'), iri('https://example.org/vocab/mobileUnitAvailable'), iri('https://example.org/city/value/yes')),
      \+ has_accepted_override(before_review, iri('https://example.org/city/neighbourhood/riverside'), iri('https://example.org/vocab/mobileUnitAvailable'))]).
step(curated(iri('https://example.org/city/neighbourhood/riverside'), iri('https://example.org/vocab/mobileUnitAvailable'), iri('https://example.org/city/value/yes')),
     rule(87),
     ['S' = iri('https://example.org/city/neighbourhood/riverside'),
      'P' = iri('https://example.org/vocab/mobileUnitAvailable'),
      'O' = iri('https://example.org/city/value/yes'),
      'G' = iri('https://example.org/graph/emergency-plan')],
     [rdf(iri('https://example.org/city/neighbourhood/riverside'), iri('https://example.org/vocab/mobileUnitAvailable'), iri('https://example.org/city/value/yes'), iri('https://example.org/graph/emergency-plan')),
      curated_graph(iri('https://example.org/graph/emergency-plan'))]).
step(rdf(iri('https://example.org/city/neighbourhood/riverside'), iri('https://example.org/vocab/mobileUnitAvailable'), iri('https://example.org/city/value/yes'), iri('https://example.org/graph/emergency-plan')),
     fact(20),
     [],
     []).
step(\+ has_accepted_override(before_review, iri('https://example.org/city/neighbourhood/riverside'), iri('https://example.org/vocab/mobileUnitAvailable')),
     absent,
     [],
     []).
step(friendly_action(deploy_mobile_unit, deploy_mobile_unit), fact(149), [], []).
step(decision_reason(before_review, riverside, "Route 7 is suspended, Central Hall has unstable power, and Riverside School is not yet an approved cooling centre; deploy the mobile unit."),
     rule(153),
     [],
     [recommended_action(before_review, riverside, deploy_mobile_unit)]).
step(decision_reason(after_review, riverside, "Human review confirms Riverside School as an emergency cooling centre; its verified capacity and accessibility satisfy Riverside demand locally."),
     rule(154),
     [],
     [recommended_action(after_review, riverside, open_local_center(riverside_school))]).
step(audit(p1, language_agent, transit_api_20260827, auto_accepted, automatic),
     rule(158),
     ['Id' = p1,
      'Agent' = language_agent,
      'Evidence' = transit_api_20260827,
      'State' = auto_accepted,
      'Review' = automatic,
      'IdIri' = iri('https://example.org/city/proposal/p1'),
      'AgentIri' = iri('https://example.org/city/agent/language-agent'),
      'EvidenceIri' = iri('https://example.org/city/evidence/transit-api-20260827')],
     [proposal(iri('https://example.org/city/proposal/p1'), iri('https://example.org/city/agent/language-agent'), iri('https://example.org/city/evidence/transit-api-20260827'), iri('https://example.org/city/route/7'), iri('https://example.org/vocab/status'), iri('https://example.org/city/state/suspended'), 99),
      proposal_state_iri(iri('https://example.org/city/proposal/p1'), auto_accepted),
      review_summary(iri('https://example.org/city/proposal/p1'), automatic),
      short(iri('https://example.org/city/proposal/p1'), p1),
      short(iri('https://example.org/city/agent/language-agent'), language_agent),
      short(iri('https://example.org/city/evidence/transit-api-20260827'), transit_api_20260827)]).
step(review_summary(iri('https://example.org/city/proposal/p1'), automatic),
     rule(156),
     ['Id' = iri('https://example.org/city/proposal/p1')],
     [proposal_state_iri(iri('https://example.org/city/proposal/p1'), auto_accepted)]).
step(short(iri('https://example.org/city/agent/language-agent'), language_agent),
     fact(129),
     [],
     []).
step(short(iri('https://example.org/city/evidence/transit-api-20260827'), transit_api_20260827),
     fact(130),
     [],
     []).
step(audit(p2, language_agent, facilities_bulletin_20260827, human_accepted, human(emergency_coordinator, accept)),
     rule(158),
     ['Id' = p2,
      'Agent' = language_agent,
      'Evidence' = facilities_bulletin_20260827,
      'State' = human_accepted,
      'Review' = human(emergency_coordinator, accept),
      'IdIri' = iri('https://example.org/city/proposal/p2'),
      'AgentIri' = iri('https://example.org/city/agent/language-agent'),
      'EvidenceIri' = iri('https://example.org/city/evidence/facilities-bulletin-20260827')],
     [proposal(iri('https://example.org/city/proposal/p2'), iri('https://example.org/city/agent/language-agent'), iri('https://example.org/city/evidence/facilities-bulletin-20260827'), iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/emergencyDesignation'), iri('https://example.org/city/class/cooling-center'), 93),
      proposal_state_iri(iri('https://example.org/city/proposal/p2'), human_accepted),
      review_summary(iri('https://example.org/city/proposal/p2'), human(emergency_coordinator, accept)),
      short(iri('https://example.org/city/proposal/p2'), p2),
      short(iri('https://example.org/city/agent/language-agent'), language_agent),
      short(iri('https://example.org/city/evidence/facilities-bulletin-20260827'), facilities_bulletin_20260827)]).
step(review_summary(iri('https://example.org/city/proposal/p2'), human(emergency_coordinator, accept)),
     rule(155),
     ['Id' = iri('https://example.org/city/proposal/p2'),
      'Reviewer' = emergency_coordinator,
      'Decision' = accept,
      'ReviewerIri' = iri('https://example.org/city/actor/emergency-coordinator')],
     [human_review(iri('https://example.org/city/proposal/p2'), iri('https://example.org/city/actor/emergency-coordinator'), accept, 'facility bulletin verified by phone'),
      short(iri('https://example.org/city/actor/emergency-coordinator'), emergency_coordinator)]).
step(short(iri('https://example.org/city/actor/emergency-coordinator'), emergency_coordinator),
     fact(134),
     [],
     []).
step(short(iri('https://example.org/city/evidence/facilities-bulletin-20260827'), facilities_bulletin_20260827),
     fact(131),
     [],
     []).
step(audit(p3, language_agent, community_post_4812, human_rejected, human(operations_officer, reject)),
     rule(158),
     ['Id' = p3,
      'Agent' = language_agent,
      'Evidence' = community_post_4812,
      'State' = human_rejected,
      'Review' = human(operations_officer, reject),
      'IdIri' = iri('https://example.org/city/proposal/p3'),
      'AgentIri' = iri('https://example.org/city/agent/language-agent'),
      'EvidenceIri' = iri('https://example.org/city/evidence/community-post-4812')],
     [proposal(iri('https://example.org/city/proposal/p3'), iri('https://example.org/city/agent/language-agent'), iri('https://example.org/city/evidence/community-post-4812'), iri('https://example.org/city/facility/central-hall'), iri('https://example.org/vocab/status'), iri('https://example.org/city/state/closed'), 78),
      proposal_state_iri(iri('https://example.org/city/proposal/p3'), human_rejected),
      review_summary(iri('https://example.org/city/proposal/p3'), human(operations_officer, reject)),
      short(iri('https://example.org/city/proposal/p3'), p3),
      short(iri('https://example.org/city/agent/language-agent'), language_agent),
      short(iri('https://example.org/city/evidence/community-post-4812'), community_post_4812)]).
step(review_summary(iri('https://example.org/city/proposal/p3'), human(operations_officer, reject)),
     rule(155),
     ['Id' = iri('https://example.org/city/proposal/p3'),
      'Reviewer' = operations_officer,
      'Decision' = reject,
      'ReviewerIri' = iri('https://example.org/city/actor/operations-officer')],
     [human_review(iri('https://example.org/city/proposal/p3'), iri('https://example.org/city/actor/operations-officer'), reject, 'official operations desk confirms Central Hall is open'),
      short(iri('https://example.org/city/actor/operations-officer'), operations_officer)]).
step(short(iri('https://example.org/city/actor/operations-officer'), operations_officer),
     fact(135),
     [],
     []).
step(short(iri('https://example.org/city/evidence/community-post-4812'), community_post_4812),
     fact(132),
     [],
     []).
step(audit(p4, language_agent, volunteer_message_112, needs_review, pending),
     rule(158),
     ['Id' = p4,
      'Agent' = language_agent,
      'Evidence' = volunteer_message_112,
      'State' = needs_review,
      'Review' = pending,
      'IdIri' = iri('https://example.org/city/proposal/p4'),
      'AgentIri' = iri('https://example.org/city/agent/language-agent'),
      'EvidenceIri' = iri('https://example.org/city/evidence/volunteer-message-112')],
     [proposal(iri('https://example.org/city/proposal/p4'), iri('https://example.org/city/agent/language-agent'), iri('https://example.org/city/evidence/volunteer-message-112'), iri('https://example.org/city/facility/north-library'), iri('https://example.org/vocab/capacity'), literal('40', datatype('http://www.w3.org/2001/XMLSchema#integer')), 66),
      proposal_state_iri(iri('https://example.org/city/proposal/p4'), needs_review),
      review_summary(iri('https://example.org/city/proposal/p4'), pending),
      short(iri('https://example.org/city/proposal/p4'), p4),
      short(iri('https://example.org/city/agent/language-agent'), language_agent),
      short(iri('https://example.org/city/evidence/volunteer-message-112'), volunteer_message_112)]).
step(review_summary(iri('https://example.org/city/proposal/p4'), pending),
     rule(157),
     ['Id' = iri('https://example.org/city/proposal/p4')],
     [proposal_state_iri(iri('https://example.org/city/proposal/p4'), needs_review)]).
step(short(iri('https://example.org/city/evidence/volunteer-message-112'), volunteer_message_112),
     fact(133),
     [],
     []).
step(feedback_signal(language_agent, p2, accepted_by_human),
     rule(159),
     ['Id' = p2, 'IdIri' = iri('https://example.org/city/proposal/p2')],
     [proposal_state_iri(iri('https://example.org/city/proposal/p2'), human_accepted),
      short(iri('https://example.org/city/proposal/p2'), p2)]).
step(feedback_signal(language_agent, p3, rejected_by_human),
     rule(160),
     ['Id' = p3, 'IdIri' = iri('https://example.org/city/proposal/p3')],
     [proposal_state_iri(iri('https://example.org/city/proposal/p3'), human_rejected),
      short(iri('https://example.org/city/proposal/p3'), p3)]).
step(feedback_signal(language_agent, p4, unresolved),
     rule(161),
     ['Id' = p4, 'IdIri' = iri('https://example.org/city/proposal/p4')],
     [proposal_state_iri(iri('https://example.org/city/proposal/p4'), needs_review),
      short(iri('https://example.org/city/proposal/p4'), p4)]).
step(symbiosis_gain(graph, accepted_machine_knowledge),
     rule(162),
     [],
     [proposal_state(p2, human_accepted)]).
step(symbiosis_gain(agent, better_operational_answer),
     rule(163),
     [],
     [recommended_action(after_review, riverside, open_local_center(riverside_school))]).
step(symbiosis_gain(human, inspectable_reason),
     rule(164),
     [],
     [decision_reason(after_review, riverside, "Human review confirms Riverside School as an emergency cooling centre; its verified capacity and accessibility satisfy Riverside demand locally.")]).
step(symbiosis_gain(governance, rejected_claim_remains_outside_operational_graph),
     rule(165),
     [],
     [proposal_state(p3, human_rejected)]).
step(symbiosis_gain(rdf, accepted_and_derived_knowledge_can_be_published_back),
     rule(166),
     [],
     [result_rdf(iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/emergencyDesignation'), iri('https://example.org/city/class/cooling-center'), iri('https://example.org/graph/accepted-knowledge'))]).
step(result_rdf(iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/emergencyDesignation'), iri('https://example.org/city/class/cooling-center'), iri('https://example.org/graph/accepted-knowledge')),
     rule(189),
     [],
     [proposal_state(p2, human_accepted)]).
step(knowledge_exchange(machine_to_graph, candidate(p2, riverside_school, emergency_designation, cooling_center)),
     rule(167),
     ['X' = machine_to_graph,
      'Y' = candidate(p2, riverside_school, emergency_designation, cooling_center)],
     [knowledge_exchange_fact(machine_to_graph, candidate(p2, riverside_school, emergency_designation, cooling_center))]).
step(knowledge_exchange_fact(machine_to_graph, candidate(p2, riverside_school, emergency_designation, cooling_center)),
     fact(168),
     [],
     []).
step(knowledge_exchange(graph_to_machine, constraint(central_hall, power, unstable)),
     rule(167),
     ['X' = graph_to_machine, 'Y' = constraint(central_hall, power, unstable)],
     [knowledge_exchange_fact(graph_to_machine, constraint(central_hall, power, unstable))]).
step(knowledge_exchange_fact(graph_to_machine, constraint(central_hall, power, unstable)),
     fact(169),
     [],
     []).
step(knowledge_exchange(human_to_machine, review(p2, accept)),
     rule(167),
     ['X' = human_to_machine, 'Y' = review(p2, accept)],
     [knowledge_exchange_fact(human_to_machine, review(p2, accept))]).
step(knowledge_exchange_fact(human_to_machine, review(p2, accept)), fact(170), [], []).
step(knowledge_exchange(human_to_machine, review(p3, reject)),
     rule(167),
     ['X' = human_to_machine, 'Y' = review(p3, reject)],
     [knowledge_exchange_fact(human_to_machine, review(p3, reject))]).
step(knowledge_exchange_fact(human_to_machine, review(p3, reject)), fact(171), [], []).
step(knowledge_exchange(machine_to_human, recommendation(after_review, riverside, open_local_center(riverside_school))),
     rule(167),
     ['X' = machine_to_human,
      'Y' = recommendation(after_review, riverside, open_local_center(riverside_school))],
     [knowledge_exchange_fact(machine_to_human, recommendation(after_review, riverside, open_local_center(riverside_school)))]).
step(knowledge_exchange_fact(machine_to_human, recommendation(after_review, riverside, open_local_center(riverside_school))),
     fact(172),
     [],
     []).
step(knowledge_exchange(rdf_to_prolog, ordinary_rdf4_facts),
     rule(167),
     ['X' = rdf_to_prolog, 'Y' = ordinary_rdf4_facts],
     [knowledge_exchange_fact(rdf_to_prolog, ordinary_rdf4_facts)]).
step(knowledge_exchange_fact(rdf_to_prolog, ordinary_rdf4_facts), fact(173), [], []).
step(knowledge_exchange(prolog_to_rdf, materialized_ground_rdf4),
     rule(167),
     ['X' = prolog_to_rdf, 'Y' = materialized_ground_rdf4],
     [knowledge_exchange_fact(prolog_to_rdf, materialized_ground_rdf4)]).
step(knowledge_exchange_fact(prolog_to_rdf, materialized_ground_rdf4), fact(174), [], []).
step(pipeline_step(1, 'RDF 1.2 N-Quads: named graphs keep source and governance boundaries explicit'),
     rule(175),
     ['N' = 1,
      'Description' = 'RDF 1.2 N-Quads: named graphs keep source and governance boundaries explicit'],
     [pipeline_step_fact(1, 'RDF 1.2 N-Quads: named graphs keep source and governance boundaries explicit')]).
step(pipeline_step_fact(1, 'RDF 1.2 N-Quads: named graphs keep source and governance boundaries explicit'),
     fact(176),
     [],
     []).
step(pipeline_step(2, 'rdf-prolog-interchange: RDF becomes ordinary rdf/4 Prolog facts without a solver'),
     rule(175),
     ['N' = 2,
      'Description' = 'rdf-prolog-interchange: RDF becomes ordinary rdf/4 Prolog facts without a solver'],
     [pipeline_step_fact(2, 'rdf-prolog-interchange: RDF becomes ordinary rdf/4 Prolog facts without a solver')]).
step(pipeline_step_fact(2, 'rdf-prolog-interchange: RDF becomes ordinary rdf/4 Prolog facts without a solver'),
     fact(177),
     [],
     []).
step(pipeline_step(3, 'EyeProlog: ISO Prolog rules validate candidates, apply review policy, and derive actions'),
     rule(175),
     ['N' = 3,
      'Description' = 'EyeProlog: ISO Prolog rules validate candidates, apply review policy, and derive actions'],
     [pipeline_step_fact(3, 'EyeProlog: ISO Prolog rules validate candidates, apply review policy, and derive actions')]).
step(pipeline_step_fact(3, 'EyeProlog: ISO Prolog rules validate candidates, apply review policy, and derive actions'),
     fact(178),
     [],
     []).
step(pipeline_step(4, 'EyeProlog: result_rdf/4 materializes accepted knowledge and decisions as ground RDF-shaped facts'),
     rule(175),
     ['N' = 4,
      'Description' = 'EyeProlog: result_rdf/4 materializes accepted knowledge and decisions as ground RDF-shaped facts'],
     [pipeline_step_fact(4, 'EyeProlog: result_rdf/4 materializes accepted knowledge and decisions as ground RDF-shaped facts')]).
step(pipeline_step_fact(4, 'EyeProlog: result_rdf/4 materializes accepted knowledge and decisions as ground RDF-shaped facts'),
     fact(179),
     [],
     []).
step(pipeline_step(5, 'rdf-prolog-interchange: ground rdf/4 facts become RDF again for publication or federation'),
     rule(175),
     ['N' = 5,
      'Description' = 'rdf-prolog-interchange: ground rdf/4 facts become RDF again for publication or federation'],
     [pipeline_step_fact(5, 'rdf-prolog-interchange: ground rdf/4 facts become RDF again for publication or federation')]).
step(pipeline_step_fact(5, 'rdf-prolog-interchange: ground rdf/4 facts become RDF again for publication or federation'),
     fact(180),
     [],
     []).
step(cognitive_parallel(fact, remembered_assertion),
     rule(181),
     ['Prolog' = fact, 'Human' = remembered_assertion],
     [cognitive_parallel_fact(fact, remembered_assertion)]).
step(cognitive_parallel_fact(fact, remembered_assertion), fact(182), [], []).
step(cognitive_parallel(rule, reusable_generalization),
     rule(181),
     ['Prolog' = rule, 'Human' = reusable_generalization],
     [cognitive_parallel_fact(rule, reusable_generalization)]).
step(cognitive_parallel_fact(rule, reusable_generalization), fact(183), [], []).
step(cognitive_parallel(query, explicit_question),
     rule(181),
     ['Prolog' = query, 'Human' = explicit_question],
     [cognitive_parallel_fact(query, explicit_question)]).
step(cognitive_parallel_fact(query, explicit_question), fact(184), [], []).
step(cognitive_parallel(variable_binding, filling_in_an_answer),
     rule(181),
     ['Prolog' = variable_binding, 'Human' = filling_in_an_answer],
     [cognitive_parallel_fact(variable_binding, filling_in_an_answer)]).
step(cognitive_parallel_fact(variable_binding, filling_in_an_answer), fact(185), [], []).
step(cognitive_parallel(backtracking, considering_alternatives),
     rule(181),
     ['Prolog' = backtracking, 'Human' = considering_alternatives],
     [cognitive_parallel_fact(backtracking, considering_alternatives)]).
step(cognitive_parallel_fact(backtracking, considering_alternatives), fact(186), [], []).
step(cognitive_parallel(proof, giving_reasons),
     rule(181),
     ['Prolog' = proof, 'Human' = giving_reasons],
     [cognitive_parallel_fact(proof, giving_reasons)]).
step(cognitive_parallel_fact(proof, giving_reasons), fact(187), [], []).
step(cognitive_parallel(review, correcting_shared_knowledge),
     rule(181),
     ['Prolog' = review, 'Human' = correcting_shared_knowledge],
     [cognitive_parallel_fact(review, correcting_shared_knowledge)]).
step(cognitive_parallel_fact(review, correcting_shared_knowledge), fact(188), [], []).
