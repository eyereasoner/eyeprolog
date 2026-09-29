root_cause(inc900, primary_db, disk_full).
impacted_service(inc900, primary_db).
impacted_service(inc900, payment_api).
impacted_service(inc900, storefront).
impacted_service(inc900, mobile_app).
impacted_service(inc900, checkout_api).
recommended_action(inc900, failover(primary_db, replica_db)).
evidence_chain(inc900, [payment_api_db_timeout, primary_db_unhealthy, primary_db_disk_100_percent, auth_service_healthy, replica_db_healthy]).

clause(1,
       rdf(iri('https://example.org/operations/service/storefront'), iri('https://example.org/vocab/dependsOn'), iri('https://example.org/operations/service/checkout-api'), iri('https://example.org/operations/graph/topology')),
       true).
clause(2,
       rdf(iri('https://example.org/operations/service/mobile-app'), iri('https://example.org/vocab/dependsOn'), iri('https://example.org/operations/service/checkout-api'), iri('https://example.org/operations/graph/topology')),
       true).
clause(3,
       rdf(iri('https://example.org/operations/service/checkout-api'), iri('https://example.org/vocab/dependsOn'), iri('https://example.org/operations/service/payment-api'), iri('https://example.org/operations/graph/topology')),
       true).
clause(4,
       rdf(iri('https://example.org/operations/service/payment-api'), iri('https://example.org/vocab/dependsOn'), iri('https://example.org/operations/db/primary'), iri('https://example.org/operations/graph/topology')),
       true).
clause(7,
       rdf(iri('https://example.org/operations/incident/inc-900'), iri('https://example.org/vocab/symptom'), iri('https://example.org/operations/symptom/db-timeout'), iri('https://example.org/operations/graph/incident')),
       true).
clause(9,
       rdf(iri('https://example.org/operations/db/primary'), iri('https://example.org/vocab/status'), iri('https://example.org/operations/state/unhealthy'), iri('https://example.org/operations/graph/telemetry')),
       true).
clause(10,
       rdf(iri('https://example.org/operations/db/primary'), iri('https://example.org/vocab/diskUsagePercent'), literal('100', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/operations/graph/telemetry')),
       true).
clause(11,
       rdf(iri('https://example.org/operations/db/replica'), iri('https://example.org/vocab/status'), iri('https://example.org/operations/state/healthy'), iri('https://example.org/operations/graph/telemetry')),
       true).
clause(12,
       rdf(iri('https://example.org/operations/service/auth-service'), iri('https://example.org/vocab/status'), iri('https://example.org/operations/state/healthy'), iri('https://example.org/operations/graph/telemetry')),
       true).
clause(13,
       rdf(iri('https://example.org/operations/service/payment-api'), iri('https://example.org/vocab/errorRatePercent'), literal('72', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/operations/graph/telemetry')),
       true).
clause(14,
       rdf(iri('https://example.org/operations/runbook/db-failover'), iri('https://example.org/vocab/whenCause'), iri('https://example.org/operations/cause/disk-full'), iri('https://example.org/operations/graph/runbook')),
       true).
clause(15,
       rdf(iri('https://example.org/operations/runbook/db-failover'), iri('https://example.org/vocab/action'), iri('https://example.org/operations/action/failover-to-replica'), iri('https://example.org/operations/graph/runbook')),
       true).
clause(16, v(depends_on, iri('https://example.org/vocab/dependsOn')), true).
clause(17, v(symptom, iri('https://example.org/vocab/symptom')), true).
clause(19, v(status, iri('https://example.org/vocab/status')), true).
clause(20, v(disk_usage, iri('https://example.org/vocab/diskUsagePercent')), true).
clause(21, v(error_rate, iri('https://example.org/vocab/errorRatePercent')), true).
clause(22, v(when_cause, iri('https://example.org/vocab/whenCause')), true).
clause(23, v(action, iri('https://example.org/vocab/action')), true).
clause(24, g(topology, iri('https://example.org/operations/graph/topology')), true).
clause(25, g(telemetry, iri('https://example.org/operations/graph/telemetry')), true).
clause(26, g(incident, iri('https://example.org/operations/graph/incident')), true).
clause(27, g(runbook, iri('https://example.org/operations/graph/runbook')), true).
clause(28, resource(inc900, iri('https://example.org/operations/incident/inc-900')), true).
clause(29, resource(storefront, iri('https://example.org/operations/service/storefront')), true).
clause(30, resource(mobile_app, iri('https://example.org/operations/service/mobile-app')), true).
clause(31,
       resource(checkout_api, iri('https://example.org/operations/service/checkout-api')),
       true).
clause(32,
       resource(payment_api, iri('https://example.org/operations/service/payment-api')),
       true).
clause(33,
       resource(auth_service, iri('https://example.org/operations/service/auth-service')),
       true).
clause(34, resource(primary_db, iri('https://example.org/operations/db/primary')), true).
clause(35, resource(replica_db, iri('https://example.org/operations/db/replica')), true).
clause(36,
       integer_literal(literal(var('Text'), datatype('http://www.w3.org/2001/XMLSchema#integer')), var('N')),
       (atom_chars(var('Text'), var('Cs')), number_chars(var('N'), var('Cs')))).
clause(37,
       depends(var('A'), var('B')),
       (resource(var('A'), var('RA')),
        resource(var('B'), var('RB')),
        v(depends_on, var('P')),
        g(topology, var('G')),
        rdf(var('RA'), var('P'), var('RB'), var('G')))).
clause(38, transitively_depends(var('A'), var('B')), depends(var('A'), var('B'))).
clause(39,
       transitively_depends(var('A'), var('B')),
       (depends(var('A'), var('C')), transitively_depends(var('C'), var('B')))).
clause(40,
       telemetry(var('Resource'), var('Key'), var('Value')),
       (resource(var('Resource'), var('R')),
        v(var('Key'), var('P')),
        g(telemetry, var('G')),
        rdf(var('R'), var('P'), var('Value'), var('G')))).
clause(41,
       incident_fact(var('Key'), var('Value')),
       (resource(inc900, var('I')),
        v(var('Key'), var('P')),
        g(incident, var('G')),
        rdf(var('I'), var('P'), var('Value'), var('G')))).
clause(42,
       root_cause(inc900, primary_db, disk_full),
       (incident_fact(symptom, iri('https://example.org/operations/symptom/db-timeout')),
        telemetry(primary_db, status, iri('https://example.org/operations/state/unhealthy')),
        telemetry(primary_db, disk_usage, var('L')),
        integer_literal(var('L'), 100),
        telemetry(payment_api, error_rate, var('E')),
        integer_literal(var('E'), var('Rate')),
        var('Rate') >= 50,
        telemetry(auth_service, status, iri('https://example.org/operations/state/healthy')))).
clause(43, impacted_service(inc900, primary_db), root_cause(inc900, primary_db, anonymous(1))).
clause(44,
       impacted_service(inc900, var('Service')),
       (root_cause(inc900, primary_db, anonymous(1)),
        transitively_depends(var('Service'), primary_db))).
clause(45, cause_iri(disk_full, iri('https://example.org/operations/cause/disk-full')), true).
clause(46,
       action_iri(failover_to_replica, iri('https://example.org/operations/action/failover-to-replica')),
       true).
clause(47,
       runbook_action(var('Cause'), var('Action')),
       (g(runbook, var('G')),
        v(when_cause, var('PC')),
        v(action, var('PA')),
        cause_iri(var('Cause'), var('C')),
        action_iri(var('Action'), var('A')),
        rdf(var('Rule'), var('PC'), var('C'), var('G')),
        rdf(var('Rule'), var('PA'), var('A'), var('G')))).
clause(48,
       recommended_action(inc900, failover(primary_db, replica_db)),
       (root_cause(inc900, primary_db, disk_full),
        runbook_action(disk_full, failover_to_replica),
        telemetry(replica_db, status, iri('https://example.org/operations/state/healthy')))).
clause(49,
       evidence_chain(inc900, [payment_api_db_timeout, primary_db_unhealthy, primary_db_disk_100_percent, auth_service_healthy, replica_db_healthy]),
       recommended_action(inc900, anonymous(1))).

step(root_cause(inc900, primary_db, disk_full),
     rule(42),
     ['L' = literal('100', datatype('http://www.w3.org/2001/XMLSchema#integer')),
      'E' = literal('72', datatype('http://www.w3.org/2001/XMLSchema#integer')),
      'Rate' = 72],
     [incident_fact(symptom, iri('https://example.org/operations/symptom/db-timeout')),
      telemetry(primary_db, status, iri('https://example.org/operations/state/unhealthy')),
      telemetry(primary_db, disk_usage, literal('100', datatype('http://www.w3.org/2001/XMLSchema#integer'))),
      integer_literal(literal('100', datatype('http://www.w3.org/2001/XMLSchema#integer')), 100),
      telemetry(payment_api, error_rate, literal('72', datatype('http://www.w3.org/2001/XMLSchema#integer'))),
      integer_literal(literal('72', datatype('http://www.w3.org/2001/XMLSchema#integer')), 72),
      72 >= 50,
      telemetry(auth_service, status, iri('https://example.org/operations/state/healthy'))]).
step(incident_fact(symptom, iri('https://example.org/operations/symptom/db-timeout')),
     rule(41),
     ['Key' = symptom,
      'Value' = iri('https://example.org/operations/symptom/db-timeout'),
      'I' = iri('https://example.org/operations/incident/inc-900'),
      'P' = iri('https://example.org/vocab/symptom'),
      'G' = iri('https://example.org/operations/graph/incident')],
     [resource(inc900, iri('https://example.org/operations/incident/inc-900')),
      v(symptom, iri('https://example.org/vocab/symptom')),
      g(incident, iri('https://example.org/operations/graph/incident')),
      rdf(iri('https://example.org/operations/incident/inc-900'), iri('https://example.org/vocab/symptom'), iri('https://example.org/operations/symptom/db-timeout'), iri('https://example.org/operations/graph/incident'))]).
step(resource(inc900, iri('https://example.org/operations/incident/inc-900')), fact(28), [], []).
step(v(symptom, iri('https://example.org/vocab/symptom')), fact(17), [], []).
step(g(incident, iri('https://example.org/operations/graph/incident')), fact(26), [], []).
step(rdf(iri('https://example.org/operations/incident/inc-900'), iri('https://example.org/vocab/symptom'), iri('https://example.org/operations/symptom/db-timeout'), iri('https://example.org/operations/graph/incident')),
     fact(7),
     [],
     []).
step(telemetry(primary_db, status, iri('https://example.org/operations/state/unhealthy')),
     rule(40),
     ['Resource' = primary_db,
      'Key' = status,
      'Value' = iri('https://example.org/operations/state/unhealthy'),
      'R' = iri('https://example.org/operations/db/primary'),
      'P' = iri('https://example.org/vocab/status'),
      'G' = iri('https://example.org/operations/graph/telemetry')],
     [resource(primary_db, iri('https://example.org/operations/db/primary')),
      v(status, iri('https://example.org/vocab/status')),
      g(telemetry, iri('https://example.org/operations/graph/telemetry')),
      rdf(iri('https://example.org/operations/db/primary'), iri('https://example.org/vocab/status'), iri('https://example.org/operations/state/unhealthy'), iri('https://example.org/operations/graph/telemetry'))]).
step(resource(primary_db, iri('https://example.org/operations/db/primary')), fact(34), [], []).
step(v(status, iri('https://example.org/vocab/status')), fact(19), [], []).
step(g(telemetry, iri('https://example.org/operations/graph/telemetry')), fact(25), [], []).
step(rdf(iri('https://example.org/operations/db/primary'), iri('https://example.org/vocab/status'), iri('https://example.org/operations/state/unhealthy'), iri('https://example.org/operations/graph/telemetry')),
     fact(9),
     [],
     []).
step(telemetry(primary_db, disk_usage, literal('100', datatype('http://www.w3.org/2001/XMLSchema#integer'))),
     rule(40),
     ['Resource' = primary_db,
      'Key' = disk_usage,
      'Value' = literal('100', datatype('http://www.w3.org/2001/XMLSchema#integer')),
      'R' = iri('https://example.org/operations/db/primary'),
      'P' = iri('https://example.org/vocab/diskUsagePercent'),
      'G' = iri('https://example.org/operations/graph/telemetry')],
     [resource(primary_db, iri('https://example.org/operations/db/primary')),
      v(disk_usage, iri('https://example.org/vocab/diskUsagePercent')),
      g(telemetry, iri('https://example.org/operations/graph/telemetry')),
      rdf(iri('https://example.org/operations/db/primary'), iri('https://example.org/vocab/diskUsagePercent'), literal('100', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/operations/graph/telemetry'))]).
step(v(disk_usage, iri('https://example.org/vocab/diskUsagePercent')), fact(20), [], []).
step(rdf(iri('https://example.org/operations/db/primary'), iri('https://example.org/vocab/diskUsagePercent'), literal('100', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/operations/graph/telemetry')),
     fact(10),
     [],
     []).
step(integer_literal(literal('100', datatype('http://www.w3.org/2001/XMLSchema#integer')), 100),
     rule(36),
     ['Text' = '100', 'N' = 100, 'Cs' = "100"],
     [atom_chars('100', "100"), number_chars(100, "100")]).
step(atom_chars('100', "100"), builtin, [], []).
step(number_chars(100, "100"), builtin, [], []).
step(telemetry(payment_api, error_rate, literal('72', datatype('http://www.w3.org/2001/XMLSchema#integer'))),
     rule(40),
     ['Resource' = payment_api,
      'Key' = error_rate,
      'Value' = literal('72', datatype('http://www.w3.org/2001/XMLSchema#integer')),
      'R' = iri('https://example.org/operations/service/payment-api'),
      'P' = iri('https://example.org/vocab/errorRatePercent'),
      'G' = iri('https://example.org/operations/graph/telemetry')],
     [resource(payment_api, iri('https://example.org/operations/service/payment-api')),
      v(error_rate, iri('https://example.org/vocab/errorRatePercent')),
      g(telemetry, iri('https://example.org/operations/graph/telemetry')),
      rdf(iri('https://example.org/operations/service/payment-api'), iri('https://example.org/vocab/errorRatePercent'), literal('72', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/operations/graph/telemetry'))]).
step(resource(payment_api, iri('https://example.org/operations/service/payment-api')),
     fact(32),
     [],
     []).
step(v(error_rate, iri('https://example.org/vocab/errorRatePercent')), fact(21), [], []).
step(rdf(iri('https://example.org/operations/service/payment-api'), iri('https://example.org/vocab/errorRatePercent'), literal('72', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/operations/graph/telemetry')),
     fact(13),
     [],
     []).
step(integer_literal(literal('72', datatype('http://www.w3.org/2001/XMLSchema#integer')), 72),
     rule(36),
     ['Text' = '72', 'N' = 72, 'Cs' = "72"],
     [atom_chars('72', "72"), number_chars(72, "72")]).
step(atom_chars('72', "72"), builtin, [], []).
step(number_chars(72, "72"), builtin, [], []).
step(72 >= 50, builtin, [], []).
step(telemetry(auth_service, status, iri('https://example.org/operations/state/healthy')),
     rule(40),
     ['Resource' = auth_service,
      'Key' = status,
      'Value' = iri('https://example.org/operations/state/healthy'),
      'R' = iri('https://example.org/operations/service/auth-service'),
      'P' = iri('https://example.org/vocab/status'),
      'G' = iri('https://example.org/operations/graph/telemetry')],
     [resource(auth_service, iri('https://example.org/operations/service/auth-service')),
      v(status, iri('https://example.org/vocab/status')),
      g(telemetry, iri('https://example.org/operations/graph/telemetry')),
      rdf(iri('https://example.org/operations/service/auth-service'), iri('https://example.org/vocab/status'), iri('https://example.org/operations/state/healthy'), iri('https://example.org/operations/graph/telemetry'))]).
step(resource(auth_service, iri('https://example.org/operations/service/auth-service')),
     fact(33),
     [],
     []).
step(rdf(iri('https://example.org/operations/service/auth-service'), iri('https://example.org/vocab/status'), iri('https://example.org/operations/state/healthy'), iri('https://example.org/operations/graph/telemetry')),
     fact(12),
     [],
     []).
step(impacted_service(inc900, primary_db),
     rule(43),
     [],
     [root_cause(inc900, primary_db, disk_full)]).
step(impacted_service(inc900, payment_api),
     rule(44),
     ['Service' = payment_api],
     [root_cause(inc900, primary_db, disk_full), transitively_depends(payment_api, primary_db)]).
step(transitively_depends(payment_api, primary_db),
     rule(38),
     ['A' = payment_api, 'B' = primary_db],
     [depends(payment_api, primary_db)]).
step(depends(payment_api, primary_db),
     rule(37),
     ['A' = payment_api,
      'B' = primary_db,
      'RA' = iri('https://example.org/operations/service/payment-api'),
      'RB' = iri('https://example.org/operations/db/primary'),
      'P' = iri('https://example.org/vocab/dependsOn'),
      'G' = iri('https://example.org/operations/graph/topology')],
     [resource(payment_api, iri('https://example.org/operations/service/payment-api')),
      resource(primary_db, iri('https://example.org/operations/db/primary')),
      v(depends_on, iri('https://example.org/vocab/dependsOn')),
      g(topology, iri('https://example.org/operations/graph/topology')),
      rdf(iri('https://example.org/operations/service/payment-api'), iri('https://example.org/vocab/dependsOn'), iri('https://example.org/operations/db/primary'), iri('https://example.org/operations/graph/topology'))]).
step(v(depends_on, iri('https://example.org/vocab/dependsOn')), fact(16), [], []).
step(g(topology, iri('https://example.org/operations/graph/topology')), fact(24), [], []).
step(rdf(iri('https://example.org/operations/service/payment-api'), iri('https://example.org/vocab/dependsOn'), iri('https://example.org/operations/db/primary'), iri('https://example.org/operations/graph/topology')),
     fact(4),
     [],
     []).
step(impacted_service(inc900, storefront),
     rule(44),
     ['Service' = storefront],
     [root_cause(inc900, primary_db, disk_full), transitively_depends(storefront, primary_db)]).
step(transitively_depends(storefront, primary_db),
     rule(39),
     ['A' = storefront, 'B' = primary_db, 'C' = checkout_api],
     [depends(storefront, checkout_api), transitively_depends(checkout_api, primary_db)]).
step(depends(storefront, checkout_api),
     rule(37),
     ['A' = storefront,
      'B' = checkout_api,
      'RA' = iri('https://example.org/operations/service/storefront'),
      'RB' = iri('https://example.org/operations/service/checkout-api'),
      'P' = iri('https://example.org/vocab/dependsOn'),
      'G' = iri('https://example.org/operations/graph/topology')],
     [resource(storefront, iri('https://example.org/operations/service/storefront')),
      resource(checkout_api, iri('https://example.org/operations/service/checkout-api')),
      v(depends_on, iri('https://example.org/vocab/dependsOn')),
      g(topology, iri('https://example.org/operations/graph/topology')),
      rdf(iri('https://example.org/operations/service/storefront'), iri('https://example.org/vocab/dependsOn'), iri('https://example.org/operations/service/checkout-api'), iri('https://example.org/operations/graph/topology'))]).
step(resource(storefront, iri('https://example.org/operations/service/storefront')),
     fact(29),
     [],
     []).
step(resource(checkout_api, iri('https://example.org/operations/service/checkout-api')),
     fact(31),
     [],
     []).
step(rdf(iri('https://example.org/operations/service/storefront'), iri('https://example.org/vocab/dependsOn'), iri('https://example.org/operations/service/checkout-api'), iri('https://example.org/operations/graph/topology')),
     fact(1),
     [],
     []).
step(transitively_depends(checkout_api, primary_db),
     rule(39),
     ['A' = checkout_api, 'B' = primary_db, 'C' = payment_api],
     [depends(checkout_api, payment_api), transitively_depends(payment_api, primary_db)]).
step(depends(checkout_api, payment_api),
     rule(37),
     ['A' = checkout_api,
      'B' = payment_api,
      'RA' = iri('https://example.org/operations/service/checkout-api'),
      'RB' = iri('https://example.org/operations/service/payment-api'),
      'P' = iri('https://example.org/vocab/dependsOn'),
      'G' = iri('https://example.org/operations/graph/topology')],
     [resource(checkout_api, iri('https://example.org/operations/service/checkout-api')),
      resource(payment_api, iri('https://example.org/operations/service/payment-api')),
      v(depends_on, iri('https://example.org/vocab/dependsOn')),
      g(topology, iri('https://example.org/operations/graph/topology')),
      rdf(iri('https://example.org/operations/service/checkout-api'), iri('https://example.org/vocab/dependsOn'), iri('https://example.org/operations/service/payment-api'), iri('https://example.org/operations/graph/topology'))]).
step(rdf(iri('https://example.org/operations/service/checkout-api'), iri('https://example.org/vocab/dependsOn'), iri('https://example.org/operations/service/payment-api'), iri('https://example.org/operations/graph/topology')),
     fact(3),
     [],
     []).
step(impacted_service(inc900, mobile_app),
     rule(44),
     ['Service' = mobile_app],
     [root_cause(inc900, primary_db, disk_full), transitively_depends(mobile_app, primary_db)]).
step(transitively_depends(mobile_app, primary_db),
     rule(39),
     ['A' = mobile_app, 'B' = primary_db, 'C' = checkout_api],
     [depends(mobile_app, checkout_api), transitively_depends(checkout_api, primary_db)]).
step(depends(mobile_app, checkout_api),
     rule(37),
     ['A' = mobile_app,
      'B' = checkout_api,
      'RA' = iri('https://example.org/operations/service/mobile-app'),
      'RB' = iri('https://example.org/operations/service/checkout-api'),
      'P' = iri('https://example.org/vocab/dependsOn'),
      'G' = iri('https://example.org/operations/graph/topology')],
     [resource(mobile_app, iri('https://example.org/operations/service/mobile-app')),
      resource(checkout_api, iri('https://example.org/operations/service/checkout-api')),
      v(depends_on, iri('https://example.org/vocab/dependsOn')),
      g(topology, iri('https://example.org/operations/graph/topology')),
      rdf(iri('https://example.org/operations/service/mobile-app'), iri('https://example.org/vocab/dependsOn'), iri('https://example.org/operations/service/checkout-api'), iri('https://example.org/operations/graph/topology'))]).
step(resource(mobile_app, iri('https://example.org/operations/service/mobile-app')),
     fact(30),
     [],
     []).
step(rdf(iri('https://example.org/operations/service/mobile-app'), iri('https://example.org/vocab/dependsOn'), iri('https://example.org/operations/service/checkout-api'), iri('https://example.org/operations/graph/topology')),
     fact(2),
     [],
     []).
step(impacted_service(inc900, checkout_api),
     rule(44),
     ['Service' = checkout_api],
     [root_cause(inc900, primary_db, disk_full), transitively_depends(checkout_api, primary_db)]).
step(recommended_action(inc900, failover(primary_db, replica_db)),
     rule(48),
     [],
     [root_cause(inc900, primary_db, disk_full),
      runbook_action(disk_full, failover_to_replica),
      telemetry(replica_db, status, iri('https://example.org/operations/state/healthy'))]).
step(runbook_action(disk_full, failover_to_replica),
     rule(47),
     ['Cause' = disk_full,
      'Action' = failover_to_replica,
      'G' = iri('https://example.org/operations/graph/runbook'),
      'PC' = iri('https://example.org/vocab/whenCause'),
      'PA' = iri('https://example.org/vocab/action'),
      'C' = iri('https://example.org/operations/cause/disk-full'),
      'A' = iri('https://example.org/operations/action/failover-to-replica'),
      'Rule' = iri('https://example.org/operations/runbook/db-failover')],
     [g(runbook, iri('https://example.org/operations/graph/runbook')),
      v(when_cause, iri('https://example.org/vocab/whenCause')),
      v(action, iri('https://example.org/vocab/action')),
      cause_iri(disk_full, iri('https://example.org/operations/cause/disk-full')),
      action_iri(failover_to_replica, iri('https://example.org/operations/action/failover-to-replica')),
      rdf(iri('https://example.org/operations/runbook/db-failover'), iri('https://example.org/vocab/whenCause'), iri('https://example.org/operations/cause/disk-full'), iri('https://example.org/operations/graph/runbook')),
      rdf(iri('https://example.org/operations/runbook/db-failover'), iri('https://example.org/vocab/action'), iri('https://example.org/operations/action/failover-to-replica'), iri('https://example.org/operations/graph/runbook'))]).
step(g(runbook, iri('https://example.org/operations/graph/runbook')), fact(27), [], []).
step(v(when_cause, iri('https://example.org/vocab/whenCause')), fact(22), [], []).
step(v(action, iri('https://example.org/vocab/action')), fact(23), [], []).
step(cause_iri(disk_full, iri('https://example.org/operations/cause/disk-full')),
     fact(45),
     [],
     []).
step(action_iri(failover_to_replica, iri('https://example.org/operations/action/failover-to-replica')),
     fact(46),
     [],
     []).
step(rdf(iri('https://example.org/operations/runbook/db-failover'), iri('https://example.org/vocab/whenCause'), iri('https://example.org/operations/cause/disk-full'), iri('https://example.org/operations/graph/runbook')),
     fact(14),
     [],
     []).
step(rdf(iri('https://example.org/operations/runbook/db-failover'), iri('https://example.org/vocab/action'), iri('https://example.org/operations/action/failover-to-replica'), iri('https://example.org/operations/graph/runbook')),
     fact(15),
     [],
     []).
step(telemetry(replica_db, status, iri('https://example.org/operations/state/healthy')),
     rule(40),
     ['Resource' = replica_db,
      'Key' = status,
      'Value' = iri('https://example.org/operations/state/healthy'),
      'R' = iri('https://example.org/operations/db/replica'),
      'P' = iri('https://example.org/vocab/status'),
      'G' = iri('https://example.org/operations/graph/telemetry')],
     [resource(replica_db, iri('https://example.org/operations/db/replica')),
      v(status, iri('https://example.org/vocab/status')),
      g(telemetry, iri('https://example.org/operations/graph/telemetry')),
      rdf(iri('https://example.org/operations/db/replica'), iri('https://example.org/vocab/status'), iri('https://example.org/operations/state/healthy'), iri('https://example.org/operations/graph/telemetry'))]).
step(resource(replica_db, iri('https://example.org/operations/db/replica')), fact(35), [], []).
step(rdf(iri('https://example.org/operations/db/replica'), iri('https://example.org/vocab/status'), iri('https://example.org/operations/state/healthy'), iri('https://example.org/operations/graph/telemetry')),
     fact(11),
     [],
     []).
step(evidence_chain(inc900, [payment_api_db_timeout, primary_db_unhealthy, primary_db_disk_100_percent, auth_service_healthy, replica_db_healthy]),
     rule(49),
     [],
     [recommended_action(inc900, failover(primary_db, replica_db))]).
