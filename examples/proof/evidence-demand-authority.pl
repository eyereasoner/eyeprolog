demand_validity(evidence_of(continued_conditions), invalid(outside_granted_power)).
termination_ground(missed_deadline(evidence_of(continued_conditions)), unavailable(demand_was_invalid)).
admissible(document(tenancy_record), no(obtained_under_invalid_demand)).
holder_status(status, retained).

clause(4, demanded(authority, holder, evidence_of(continued_conditions), deadline(30)), true).
clause(6, elapsed(deadline(30)), true).
clause(7,
       produced(holder, document(tenancy_record), under(evidence_of(continued_conditions))),
       true).
clause(11,
       demand_validity(var('Subject'), invalid(outside_granted_power)),
       (demanded(authority, anonymous(1), var('Subject'), anonymous(2)),
        \+ may_demand(authority, var('Subject')))).
clause(13,
       termination_ground(missed_deadline(var('Subject')), unavailable(demand_was_invalid)),
       (demanded(authority, holder, var('Subject'), var('Deadline')),
        elapsed(var('Deadline')),
        demand_validity(var('Subject'), invalid(anonymous(1))))).
clause(15,
       admissible(document(var('D')), no(obtained_under_invalid_demand)),
       (produced(holder, document(var('D')), under(var('Subject'))),
        demand_validity(var('Subject'), invalid(anonymous(1))))).
clause(17, holder_status(status, retained), \+ available_ground).

step(demand_validity(evidence_of(continued_conditions), invalid(outside_granted_power)),
     rule(11),
     ['Subject' = evidence_of(continued_conditions)],
     [demanded(authority, holder, evidence_of(continued_conditions), deadline(30)),
      \+ may_demand(authority, evidence_of(continued_conditions))]).
step(demanded(authority, holder, evidence_of(continued_conditions), deadline(30)),
     fact(4),
     [],
     []).
step(\+ may_demand(authority, evidence_of(continued_conditions)), absent, [], []).
step(termination_ground(missed_deadline(evidence_of(continued_conditions)), unavailable(demand_was_invalid)),
     rule(13),
     ['Subject' = evidence_of(continued_conditions), 'Deadline' = deadline(30)],
     [demanded(authority, holder, evidence_of(continued_conditions), deadline(30)),
      elapsed(deadline(30)),
      demand_validity(evidence_of(continued_conditions), invalid(outside_granted_power))]).
step(elapsed(deadline(30)), fact(6), [], []).
step(admissible(document(tenancy_record), no(obtained_under_invalid_demand)),
     rule(15),
     ['D' = tenancy_record, 'Subject' = evidence_of(continued_conditions)],
     [produced(holder, document(tenancy_record), under(evidence_of(continued_conditions))),
      demand_validity(evidence_of(continued_conditions), invalid(outside_granted_power))]).
step(produced(holder, document(tenancy_record), under(evidence_of(continued_conditions))),
     fact(7),
     [],
     []).
step(holder_status(status, retained), rule(17), [], [\+ available_ground]).
step(\+ available_ground, absent, [], []).
