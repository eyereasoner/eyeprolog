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
