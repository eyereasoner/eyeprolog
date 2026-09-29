sharing_decision(marketing, deny).
sharing_decision(research_us, review).
sharing_decision(research_eu, permit).
obligation(research_eu, delete_after_days(120)).
obligation(research_eu, retain_audit_log).
decision_reason(research_eu, "ODRL permission matches; recipient is certified, data is pseudonymized, retention is within 180 days, and the transfer stays in-region.").
decision_reason(marketing, "The requested marketing distribution matches an explicit ODRL prohibition.").
decision_reason(research_us, "The research purpose is permitted, but the out-of-region transfer lacks the required contractual safeguard and must be reviewed.").

clause(1,
       rdf(iri('https://example.org/data-sharing/policy/main'), iri('http://www.w3.org/ns/odrl/2/permission'), iri('https://example.org/data-sharing/policy/research-permission'), iri('https://example.org/data-sharing/graph/policy')),
       true).
clause(2,
       rdf(iri('https://example.org/data-sharing/policy/research-permission'), iri('http://www.w3.org/ns/odrl/2/target'), iri('https://example.org/data-sharing/dataset/cohort-a'), iri('https://example.org/data-sharing/graph/policy')),
       true).
clause(3,
       rdf(iri('https://example.org/data-sharing/policy/research-permission'), iri('http://www.w3.org/ns/odrl/2/action'), iri('http://www.w3.org/ns/odrl/2/use'), iri('https://example.org/data-sharing/graph/policy')),
       true).
clause(4,
       rdf(iri('https://example.org/data-sharing/policy/research-permission'), iri('http://www.w3.org/ns/odrl/2/purpose'), iri('https://w3id.org/dpv#ScientificResearch'), iri('https://example.org/data-sharing/graph/policy')),
       true).
clause(5,
       rdf(iri('https://example.org/data-sharing/policy/research-permission'), iri('https://example.org/vocab/maxRetentionDays'), literal('180', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/data-sharing/graph/policy')),
       true).
clause(6,
       rdf(iri('https://example.org/data-sharing/policy/main'), iri('http://www.w3.org/ns/odrl/2/prohibition'), iri('https://example.org/data-sharing/policy/marketing-prohibition'), iri('https://example.org/data-sharing/graph/policy')),
       true).
clause(7,
       rdf(iri('https://example.org/data-sharing/policy/marketing-prohibition'), iri('http://www.w3.org/ns/odrl/2/target'), iri('https://example.org/data-sharing/dataset/cohort-a'), iri('https://example.org/data-sharing/graph/policy')),
       true).
clause(8,
       rdf(iri('https://example.org/data-sharing/policy/marketing-prohibition'), iri('http://www.w3.org/ns/odrl/2/action'), iri('http://www.w3.org/ns/odrl/2/distribute'), iri('https://example.org/data-sharing/graph/policy')),
       true).
clause(9,
       rdf(iri('https://example.org/data-sharing/policy/marketing-prohibition'), iri('http://www.w3.org/ns/odrl/2/purpose'), iri('https://w3id.org/dpv#Marketing'), iri('https://example.org/data-sharing/graph/policy')),
       true).
clause(10,
       rdf(iri('https://example.org/data-sharing/org/university-eu'), iri('https://example.org/vocab/region'), iri('https://example.org/data-sharing/region/eu'), iri('https://example.org/data-sharing/graph/organizations')),
       true).
clause(11,
       rdf(iri('https://example.org/data-sharing/org/university-eu'), iri('https://example.org/vocab/certifiedResearchOrg'), iri('https://example.org/data-sharing/value/yes'), iri('https://example.org/data-sharing/graph/organizations')),
       true).
clause(12,
       rdf(iri('https://example.org/data-sharing/org/university-us'), iri('https://example.org/vocab/region'), iri('https://example.org/data-sharing/region/us'), iri('https://example.org/data-sharing/graph/organizations')),
       true).
clause(13,
       rdf(iri('https://example.org/data-sharing/org/university-us'), iri('https://example.org/vocab/certifiedResearchOrg'), iri('https://example.org/data-sharing/value/yes'), iri('https://example.org/data-sharing/graph/organizations')),
       true).
clause(15,
       rdf(iri('https://example.org/data-sharing/request/research-eu'), iri('https://example.org/vocab/dataset'), iri('https://example.org/data-sharing/dataset/cohort-a'), iri('https://example.org/data-sharing/graph/requests')),
       true).
clause(16,
       rdf(iri('https://example.org/data-sharing/request/research-eu'), iri('https://example.org/vocab/recipient'), iri('https://example.org/data-sharing/org/university-eu'), iri('https://example.org/data-sharing/graph/requests')),
       true).
clause(17,
       rdf(iri('https://example.org/data-sharing/request/research-eu'), iri('https://example.org/vocab/action'), iri('http://www.w3.org/ns/odrl/2/use'), iri('https://example.org/data-sharing/graph/requests')),
       true).
clause(18,
       rdf(iri('https://example.org/data-sharing/request/research-eu'), iri('https://example.org/vocab/purpose'), iri('https://w3id.org/dpv#ScientificResearch'), iri('https://example.org/data-sharing/graph/requests')),
       true).
clause(19,
       rdf(iri('https://example.org/data-sharing/request/research-eu'), iri('https://example.org/vocab/retentionDays'), literal('120', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/data-sharing/graph/requests')),
       true).
clause(20,
       rdf(iri('https://example.org/data-sharing/request/research-eu'), iri('https://example.org/vocab/pseudonymized'), iri('https://example.org/data-sharing/value/yes'), iri('https://example.org/data-sharing/graph/requests')),
       true).
clause(21,
       rdf(iri('https://example.org/data-sharing/request/research-eu'), iri('https://example.org/vocab/legalBasis'), iri('https://w3id.org/dpv#Consent'), iri('https://example.org/data-sharing/graph/requests')),
       true).
clause(22,
       rdf(iri('https://example.org/data-sharing/request/research-eu'), iri('https://example.org/vocab/standardContractualClauses'), iri('https://example.org/data-sharing/value/yes'), iri('https://example.org/data-sharing/graph/requests')),
       true).
clause(23,
       rdf(iri('https://example.org/data-sharing/request/marketing'), iri('https://example.org/vocab/dataset'), iri('https://example.org/data-sharing/dataset/cohort-a'), iri('https://example.org/data-sharing/graph/requests')),
       true).
clause(24,
       rdf(iri('https://example.org/data-sharing/request/marketing'), iri('https://example.org/vocab/recipient'), iri('https://example.org/data-sharing/org/ad-network'), iri('https://example.org/data-sharing/graph/requests')),
       true).
clause(25,
       rdf(iri('https://example.org/data-sharing/request/marketing'), iri('https://example.org/vocab/action'), iri('http://www.w3.org/ns/odrl/2/distribute'), iri('https://example.org/data-sharing/graph/requests')),
       true).
clause(26,
       rdf(iri('https://example.org/data-sharing/request/marketing'), iri('https://example.org/vocab/purpose'), iri('https://w3id.org/dpv#Marketing'), iri('https://example.org/data-sharing/graph/requests')),
       true).
clause(27,
       rdf(iri('https://example.org/data-sharing/request/marketing'), iri('https://example.org/vocab/retentionDays'), literal('30', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/data-sharing/graph/requests')),
       true).
clause(28,
       rdf(iri('https://example.org/data-sharing/request/marketing'), iri('https://example.org/vocab/pseudonymized'), iri('https://example.org/data-sharing/value/no'), iri('https://example.org/data-sharing/graph/requests')),
       true).
clause(29,
       rdf(iri('https://example.org/data-sharing/request/marketing'), iri('https://example.org/vocab/legalBasis'), iri('https://w3id.org/dpv#Consent'), iri('https://example.org/data-sharing/graph/requests')),
       true).
clause(30,
       rdf(iri('https://example.org/data-sharing/request/marketing'), iri('https://example.org/vocab/standardContractualClauses'), iri('https://example.org/data-sharing/value/yes'), iri('https://example.org/data-sharing/graph/requests')),
       true).
clause(31,
       rdf(iri('https://example.org/data-sharing/request/research-us'), iri('https://example.org/vocab/dataset'), iri('https://example.org/data-sharing/dataset/cohort-a'), iri('https://example.org/data-sharing/graph/requests')),
       true).
clause(32,
       rdf(iri('https://example.org/data-sharing/request/research-us'), iri('https://example.org/vocab/recipient'), iri('https://example.org/data-sharing/org/university-us'), iri('https://example.org/data-sharing/graph/requests')),
       true).
clause(33,
       rdf(iri('https://example.org/data-sharing/request/research-us'), iri('https://example.org/vocab/action'), iri('http://www.w3.org/ns/odrl/2/use'), iri('https://example.org/data-sharing/graph/requests')),
       true).
clause(34,
       rdf(iri('https://example.org/data-sharing/request/research-us'), iri('https://example.org/vocab/purpose'), iri('https://w3id.org/dpv#ScientificResearch'), iri('https://example.org/data-sharing/graph/requests')),
       true).
clause(35,
       rdf(iri('https://example.org/data-sharing/request/research-us'), iri('https://example.org/vocab/retentionDays'), literal('90', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/data-sharing/graph/requests')),
       true).
clause(36,
       rdf(iri('https://example.org/data-sharing/request/research-us'), iri('https://example.org/vocab/pseudonymized'), iri('https://example.org/data-sharing/value/yes'), iri('https://example.org/data-sharing/graph/requests')),
       true).
clause(37,
       rdf(iri('https://example.org/data-sharing/request/research-us'), iri('https://example.org/vocab/legalBasis'), iri('https://w3id.org/dpv#Consent'), iri('https://example.org/data-sharing/graph/requests')),
       true).
clause(38,
       rdf(iri('https://example.org/data-sharing/request/research-us'), iri('https://example.org/vocab/standardContractualClauses'), iri('https://example.org/data-sharing/value/no'), iri('https://example.org/data-sharing/graph/requests')),
       true).
clause(39, v(dataset, iri('https://example.org/vocab/dataset')), true).
clause(40, v(recipient, iri('https://example.org/vocab/recipient')), true).
clause(41, v(action, iri('https://example.org/vocab/action')), true).
clause(42, v(purpose, iri('https://example.org/vocab/purpose')), true).
clause(43, v(retention_days, iri('https://example.org/vocab/retentionDays')), true).
clause(44, v(pseudonymized, iri('https://example.org/vocab/pseudonymized')), true).
clause(45, v(legal_basis, iri('https://example.org/vocab/legalBasis')), true).
clause(46, v(scc, iri('https://example.org/vocab/standardContractualClauses')), true).
clause(47, v(region, iri('https://example.org/vocab/region')), true).
clause(48, v(certified, iri('https://example.org/vocab/certifiedResearchOrg')), true).
clause(49, v(max_retention, iri('https://example.org/vocab/maxRetentionDays')), true).
clause(50, g(requests, iri('https://example.org/data-sharing/graph/requests')), true).
clause(51, g(policy, iri('https://example.org/data-sharing/graph/policy')), true).
clause(52, g(orgs, iri('https://example.org/data-sharing/graph/organizations')), true).
clause(53, yes(iri('https://example.org/data-sharing/value/yes')), true).
clause(54, no(iri('https://example.org/data-sharing/value/no')), true).
clause(55, eu(iri('https://example.org/data-sharing/region/eu')), true).
clause(56, consent_basis(iri('https://w3id.org/dpv#Consent')), true).
clause(57,
       request(research_eu, iri('https://example.org/data-sharing/request/research-eu')),
       true).
clause(58, request(marketing, iri('https://example.org/data-sharing/request/marketing')), true).
clause(59,
       request(research_us, iri('https://example.org/data-sharing/request/research-us')),
       true).
clause(60,
       integer_literal(literal(var('Text'), datatype('http://www.w3.org/2001/XMLSchema#integer')), var('N')),
       (atom_chars(var('Text'), var('Cs')), number_chars(var('N'), var('Cs')))).
clause(61,
       request_data(var('Id'), var('R'), var('D'), var('Recipient'), var('Action'), var('Purpose'), var('Retention'), var('Pseudo'), var('Basis'), var('Scc')),
       (request(var('Id'), var('R')),
        g(requests, var('G')),
        v(dataset, var('PD')),
        v(recipient, var('PR')),
        v(action, var('PA')),
        v(purpose, var('PP')),
        v(retention_days, var('PT')),
        v(pseudonymized, var('PPs')),
        v(legal_basis, var('PL')),
        v(scc, var('PS')),
        rdf(var('R'), var('PD'), var('D'), var('G')),
        rdf(var('R'), var('PR'), var('Recipient'), var('G')),
        rdf(var('R'), var('PA'), var('Action'), var('G')),
        rdf(var('R'), var('PP'), var('Purpose'), var('G')),
        rdf(var('R'), var('PT'), var('L'), var('G')),
        integer_literal(var('L'), var('Retention')),
        rdf(var('R'), var('PPs'), var('Pseudo'), var('G')),
        rdf(var('R'), var('PL'), var('Basis'), var('G')),
        rdf(var('R'), var('PS'), var('Scc'), var('G')))).
clause(62,
       policy_permission(var('D'), var('Action'), var('Purpose'), var('MaxRetention')),
       (g(policy, var('G')),
        rdf(anonymous(1), iri('http://www.w3.org/ns/odrl/2/permission'), var('Rule'), var('G')),
        rdf(var('Rule'), iri('http://www.w3.org/ns/odrl/2/target'), var('D'), var('G')),
        rdf(var('Rule'), iri('http://www.w3.org/ns/odrl/2/action'), var('Action'), var('G')),
        rdf(var('Rule'), iri('http://www.w3.org/ns/odrl/2/purpose'), var('Purpose'), var('G')),
        v(max_retention, var('PM')),
        rdf(var('Rule'), var('PM'), var('L'), var('G')),
        integer_literal(var('L'), var('MaxRetention')))).
clause(63,
       policy_prohibition(var('D'), var('Action'), var('Purpose')),
       (g(policy, var('G')),
        rdf(anonymous(1), iri('http://www.w3.org/ns/odrl/2/prohibition'), var('Rule'), var('G')),
        rdf(var('Rule'), iri('http://www.w3.org/ns/odrl/2/target'), var('D'), var('G')),
        rdf(var('Rule'), iri('http://www.w3.org/ns/odrl/2/action'), var('Action'), var('G')),
        rdf(var('Rule'), iri('http://www.w3.org/ns/odrl/2/purpose'), var('Purpose'), var('G')))).
clause(64,
       recipient_region(var('Recipient'), var('Region')),
       (g(orgs, var('G')),
        v(region, var('P')),
        rdf(var('Recipient'), var('P'), var('Region'), var('G')))).
clause(65,
       certified(var('Recipient')),
       (g(orgs, var('G')),
        v(certified, var('P')),
        yes(var('Y')),
        rdf(var('Recipient'), var('P'), var('Y'), var('G')))).
clause(66,
       sharing_decision(var('Id'), deny),
       (request_data(var('Id'), anonymous(1), var('D'), anonymous(2), var('Action'), var('Purpose'), anonymous(3), anonymous(4), anonymous(5), anonymous(6)),
        policy_prohibition(var('D'), var('Action'), var('Purpose')))).
clause(67,
       sharing_decision(var('Id'), review),
       (request_data(var('Id'), anonymous(1), var('D'), var('Recip'), var('Action'), var('Purpose'), var('Retention'), var('Pseudo'), var('Basis'), var('Scc')),
        consent_basis(var('Basis')),
        policy_permission(var('D'), var('Action'), var('Purpose'), var('Max')),
        certified(var('Recip')),
        var('Retention') =< var('Max'),
        yes(var('Y')),
        var('Pseudo') = var('Y'),
        recipient_region(var('Recip'), var('Region')),
        eu(var('EU')),
        var('Region') \= var('EU'),
        no(var('N')),
        var('Scc') = var('N'))).
clause(68,
       sharing_decision(var('Id'), permit),
       (request_data(var('Id'), anonymous(1), var('D'), var('Recip'), var('Action'), var('Purpose'), var('Retention'), var('Pseudo'), var('Basis'), anonymous(2)),
        consent_basis(var('Basis')),
        policy_permission(var('D'), var('Action'), var('Purpose'), var('Max')),
        certified(var('Recip')),
        var('Retention') =< var('Max'),
        yes(var('Y')),
        var('Pseudo') = var('Y'),
        recipient_region(var('Recip'), var('Region')),
        eu(var('EU')),
        var('Region') = var('EU'))).
clause(70,
       obligation(research_eu, delete_after_days(120)),
       sharing_decision(research_eu, permit)).
clause(71, obligation(research_eu, retain_audit_log), sharing_decision(research_eu, permit)).
clause(72,
       decision_reason(research_eu, "ODRL permission matches; recipient is certified, data is pseudonymized, retention is within 180 days, and the transfer stays in-region."),
       sharing_decision(research_eu, permit)).
clause(73,
       decision_reason(marketing, "The requested marketing distribution matches an explicit ODRL prohibition."),
       sharing_decision(marketing, deny)).
clause(74,
       decision_reason(research_us, "The research purpose is permitted, but the out-of-region transfer lacks the required contractual safeguard and must be reviewed."),
       sharing_decision(research_us, review)).

step(sharing_decision(marketing, deny),
     rule(66),
     ['Id' = marketing,
      'D' = iri('https://example.org/data-sharing/dataset/cohort-a'),
      'Action' = iri('http://www.w3.org/ns/odrl/2/distribute'),
      'Purpose' = iri('https://w3id.org/dpv#Marketing')],
     [request_data(marketing, iri('https://example.org/data-sharing/request/marketing'), iri('https://example.org/data-sharing/dataset/cohort-a'), iri('https://example.org/data-sharing/org/ad-network'), iri('http://www.w3.org/ns/odrl/2/distribute'), iri('https://w3id.org/dpv#Marketing'), 30, iri('https://example.org/data-sharing/value/no'), iri('https://w3id.org/dpv#Consent'), iri('https://example.org/data-sharing/value/yes')),
      policy_prohibition(iri('https://example.org/data-sharing/dataset/cohort-a'), iri('http://www.w3.org/ns/odrl/2/distribute'), iri('https://w3id.org/dpv#Marketing'))]).
step(request_data(marketing, iri('https://example.org/data-sharing/request/marketing'), iri('https://example.org/data-sharing/dataset/cohort-a'), iri('https://example.org/data-sharing/org/ad-network'), iri('http://www.w3.org/ns/odrl/2/distribute'), iri('https://w3id.org/dpv#Marketing'), 30, iri('https://example.org/data-sharing/value/no'), iri('https://w3id.org/dpv#Consent'), iri('https://example.org/data-sharing/value/yes')),
     rule(61),
     ['Id' = marketing,
      'R' = iri('https://example.org/data-sharing/request/marketing'),
      'D' = iri('https://example.org/data-sharing/dataset/cohort-a'),
      'Recipient' = iri('https://example.org/data-sharing/org/ad-network'),
      'Action' = iri('http://www.w3.org/ns/odrl/2/distribute'),
      'Purpose' = iri('https://w3id.org/dpv#Marketing'),
      'Retention' = 30,
      'Pseudo' = iri('https://example.org/data-sharing/value/no'),
      'Basis' = iri('https://w3id.org/dpv#Consent'),
      'Scc' = iri('https://example.org/data-sharing/value/yes'),
      'G' = iri('https://example.org/data-sharing/graph/requests'),
      'PD' = iri('https://example.org/vocab/dataset'),
      'PR' = iri('https://example.org/vocab/recipient'),
      'PA' = iri('https://example.org/vocab/action'),
      'PP' = iri('https://example.org/vocab/purpose'),
      'PT' = iri('https://example.org/vocab/retentionDays'),
      'PPs' = iri('https://example.org/vocab/pseudonymized'),
      'PL' = iri('https://example.org/vocab/legalBasis'),
      'PS' = iri('https://example.org/vocab/standardContractualClauses'),
      'L' = literal('30', datatype('http://www.w3.org/2001/XMLSchema#integer'))],
     [request(marketing, iri('https://example.org/data-sharing/request/marketing')),
      g(requests, iri('https://example.org/data-sharing/graph/requests')),
      v(dataset, iri('https://example.org/vocab/dataset')),
      v(recipient, iri('https://example.org/vocab/recipient')),
      v(action, iri('https://example.org/vocab/action')),
      v(purpose, iri('https://example.org/vocab/purpose')),
      v(retention_days, iri('https://example.org/vocab/retentionDays')),
      v(pseudonymized, iri('https://example.org/vocab/pseudonymized')),
      v(legal_basis, iri('https://example.org/vocab/legalBasis')),
      v(scc, iri('https://example.org/vocab/standardContractualClauses')),
      rdf(iri('https://example.org/data-sharing/request/marketing'), iri('https://example.org/vocab/dataset'), iri('https://example.org/data-sharing/dataset/cohort-a'), iri('https://example.org/data-sharing/graph/requests')),
      rdf(iri('https://example.org/data-sharing/request/marketing'), iri('https://example.org/vocab/recipient'), iri('https://example.org/data-sharing/org/ad-network'), iri('https://example.org/data-sharing/graph/requests')),
      rdf(iri('https://example.org/data-sharing/request/marketing'), iri('https://example.org/vocab/action'), iri('http://www.w3.org/ns/odrl/2/distribute'), iri('https://example.org/data-sharing/graph/requests')),
      rdf(iri('https://example.org/data-sharing/request/marketing'), iri('https://example.org/vocab/purpose'), iri('https://w3id.org/dpv#Marketing'), iri('https://example.org/data-sharing/graph/requests')),
      rdf(iri('https://example.org/data-sharing/request/marketing'), iri('https://example.org/vocab/retentionDays'), literal('30', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/data-sharing/graph/requests')),
      integer_literal(literal('30', datatype('http://www.w3.org/2001/XMLSchema#integer')), 30),
      rdf(iri('https://example.org/data-sharing/request/marketing'), iri('https://example.org/vocab/pseudonymized'), iri('https://example.org/data-sharing/value/no'), iri('https://example.org/data-sharing/graph/requests')),
      rdf(iri('https://example.org/data-sharing/request/marketing'), iri('https://example.org/vocab/legalBasis'), iri('https://w3id.org/dpv#Consent'), iri('https://example.org/data-sharing/graph/requests')),
      rdf(iri('https://example.org/data-sharing/request/marketing'), iri('https://example.org/vocab/standardContractualClauses'), iri('https://example.org/data-sharing/value/yes'), iri('https://example.org/data-sharing/graph/requests'))]).
step(request(marketing, iri('https://example.org/data-sharing/request/marketing')),
     fact(58),
     [],
     []).
step(g(requests, iri('https://example.org/data-sharing/graph/requests')), fact(50), [], []).
step(v(dataset, iri('https://example.org/vocab/dataset')), fact(39), [], []).
step(v(recipient, iri('https://example.org/vocab/recipient')), fact(40), [], []).
step(v(action, iri('https://example.org/vocab/action')), fact(41), [], []).
step(v(purpose, iri('https://example.org/vocab/purpose')), fact(42), [], []).
step(v(retention_days, iri('https://example.org/vocab/retentionDays')), fact(43), [], []).
step(v(pseudonymized, iri('https://example.org/vocab/pseudonymized')), fact(44), [], []).
step(v(legal_basis, iri('https://example.org/vocab/legalBasis')), fact(45), [], []).
step(v(scc, iri('https://example.org/vocab/standardContractualClauses')), fact(46), [], []).
step(rdf(iri('https://example.org/data-sharing/request/marketing'), iri('https://example.org/vocab/dataset'), iri('https://example.org/data-sharing/dataset/cohort-a'), iri('https://example.org/data-sharing/graph/requests')),
     fact(23),
     [],
     []).
step(rdf(iri('https://example.org/data-sharing/request/marketing'), iri('https://example.org/vocab/recipient'), iri('https://example.org/data-sharing/org/ad-network'), iri('https://example.org/data-sharing/graph/requests')),
     fact(24),
     [],
     []).
step(rdf(iri('https://example.org/data-sharing/request/marketing'), iri('https://example.org/vocab/action'), iri('http://www.w3.org/ns/odrl/2/distribute'), iri('https://example.org/data-sharing/graph/requests')),
     fact(25),
     [],
     []).
step(rdf(iri('https://example.org/data-sharing/request/marketing'), iri('https://example.org/vocab/purpose'), iri('https://w3id.org/dpv#Marketing'), iri('https://example.org/data-sharing/graph/requests')),
     fact(26),
     [],
     []).
step(rdf(iri('https://example.org/data-sharing/request/marketing'), iri('https://example.org/vocab/retentionDays'), literal('30', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/data-sharing/graph/requests')),
     fact(27),
     [],
     []).
step(integer_literal(literal('30', datatype('http://www.w3.org/2001/XMLSchema#integer')), 30),
     rule(60),
     ['Text' = '30', 'N' = 30, 'Cs' = "30"],
     [atom_chars('30', "30"), number_chars(30, "30")]).
step(atom_chars('30', "30"), builtin, [], []).
step(number_chars(30, "30"), builtin, [], []).
step(rdf(iri('https://example.org/data-sharing/request/marketing'), iri('https://example.org/vocab/pseudonymized'), iri('https://example.org/data-sharing/value/no'), iri('https://example.org/data-sharing/graph/requests')),
     fact(28),
     [],
     []).
step(rdf(iri('https://example.org/data-sharing/request/marketing'), iri('https://example.org/vocab/legalBasis'), iri('https://w3id.org/dpv#Consent'), iri('https://example.org/data-sharing/graph/requests')),
     fact(29),
     [],
     []).
step(rdf(iri('https://example.org/data-sharing/request/marketing'), iri('https://example.org/vocab/standardContractualClauses'), iri('https://example.org/data-sharing/value/yes'), iri('https://example.org/data-sharing/graph/requests')),
     fact(30),
     [],
     []).
step(policy_prohibition(iri('https://example.org/data-sharing/dataset/cohort-a'), iri('http://www.w3.org/ns/odrl/2/distribute'), iri('https://w3id.org/dpv#Marketing')),
     rule(63),
     ['D' = iri('https://example.org/data-sharing/dataset/cohort-a'),
      'Action' = iri('http://www.w3.org/ns/odrl/2/distribute'),
      'Purpose' = iri('https://w3id.org/dpv#Marketing'),
      'G' = iri('https://example.org/data-sharing/graph/policy'),
      'Rule' = iri('https://example.org/data-sharing/policy/marketing-prohibition')],
     [g(policy, iri('https://example.org/data-sharing/graph/policy')),
      rdf(iri('https://example.org/data-sharing/policy/main'), iri('http://www.w3.org/ns/odrl/2/prohibition'), iri('https://example.org/data-sharing/policy/marketing-prohibition'), iri('https://example.org/data-sharing/graph/policy')),
      rdf(iri('https://example.org/data-sharing/policy/marketing-prohibition'), iri('http://www.w3.org/ns/odrl/2/target'), iri('https://example.org/data-sharing/dataset/cohort-a'), iri('https://example.org/data-sharing/graph/policy')),
      rdf(iri('https://example.org/data-sharing/policy/marketing-prohibition'), iri('http://www.w3.org/ns/odrl/2/action'), iri('http://www.w3.org/ns/odrl/2/distribute'), iri('https://example.org/data-sharing/graph/policy')),
      rdf(iri('https://example.org/data-sharing/policy/marketing-prohibition'), iri('http://www.w3.org/ns/odrl/2/purpose'), iri('https://w3id.org/dpv#Marketing'), iri('https://example.org/data-sharing/graph/policy'))]).
step(g(policy, iri('https://example.org/data-sharing/graph/policy')), fact(51), [], []).
step(rdf(iri('https://example.org/data-sharing/policy/main'), iri('http://www.w3.org/ns/odrl/2/prohibition'), iri('https://example.org/data-sharing/policy/marketing-prohibition'), iri('https://example.org/data-sharing/graph/policy')),
     fact(6),
     [],
     []).
step(rdf(iri('https://example.org/data-sharing/policy/marketing-prohibition'), iri('http://www.w3.org/ns/odrl/2/target'), iri('https://example.org/data-sharing/dataset/cohort-a'), iri('https://example.org/data-sharing/graph/policy')),
     fact(7),
     [],
     []).
step(rdf(iri('https://example.org/data-sharing/policy/marketing-prohibition'), iri('http://www.w3.org/ns/odrl/2/action'), iri('http://www.w3.org/ns/odrl/2/distribute'), iri('https://example.org/data-sharing/graph/policy')),
     fact(8),
     [],
     []).
step(rdf(iri('https://example.org/data-sharing/policy/marketing-prohibition'), iri('http://www.w3.org/ns/odrl/2/purpose'), iri('https://w3id.org/dpv#Marketing'), iri('https://example.org/data-sharing/graph/policy')),
     fact(9),
     [],
     []).
step(sharing_decision(research_us, review),
     rule(67),
     ['Id' = research_us,
      'D' = iri('https://example.org/data-sharing/dataset/cohort-a'),
      'Recip' = iri('https://example.org/data-sharing/org/university-us'),
      'Action' = iri('http://www.w3.org/ns/odrl/2/use'),
      'Purpose' = iri('https://w3id.org/dpv#ScientificResearch'),
      'Retention' = 90,
      'Pseudo' = iri('https://example.org/data-sharing/value/yes'),
      'Basis' = iri('https://w3id.org/dpv#Consent'),
      'Scc' = iri('https://example.org/data-sharing/value/no'),
      'Max' = 180,
      'Y' = iri('https://example.org/data-sharing/value/yes'),
      'Region' = iri('https://example.org/data-sharing/region/us'),
      'EU' = iri('https://example.org/data-sharing/region/eu'),
      'N' = iri('https://example.org/data-sharing/value/no')],
     [request_data(research_us, iri('https://example.org/data-sharing/request/research-us'), iri('https://example.org/data-sharing/dataset/cohort-a'), iri('https://example.org/data-sharing/org/university-us'), iri('http://www.w3.org/ns/odrl/2/use'), iri('https://w3id.org/dpv#ScientificResearch'), 90, iri('https://example.org/data-sharing/value/yes'), iri('https://w3id.org/dpv#Consent'), iri('https://example.org/data-sharing/value/no')),
      consent_basis(iri('https://w3id.org/dpv#Consent')),
      policy_permission(iri('https://example.org/data-sharing/dataset/cohort-a'), iri('http://www.w3.org/ns/odrl/2/use'), iri('https://w3id.org/dpv#ScientificResearch'), 180),
      certified(iri('https://example.org/data-sharing/org/university-us')),
      90 =< 180,
      yes(iri('https://example.org/data-sharing/value/yes')),
      iri('https://example.org/data-sharing/value/yes') = iri('https://example.org/data-sharing/value/yes'),
      recipient_region(iri('https://example.org/data-sharing/org/university-us'), iri('https://example.org/data-sharing/region/us')),
      eu(iri('https://example.org/data-sharing/region/eu')),
      iri('https://example.org/data-sharing/region/us') \= iri('https://example.org/data-sharing/region/eu'),
      no(iri('https://example.org/data-sharing/value/no')),
      iri('https://example.org/data-sharing/value/no') = iri('https://example.org/data-sharing/value/no')]).
step(request_data(research_us, iri('https://example.org/data-sharing/request/research-us'), iri('https://example.org/data-sharing/dataset/cohort-a'), iri('https://example.org/data-sharing/org/university-us'), iri('http://www.w3.org/ns/odrl/2/use'), iri('https://w3id.org/dpv#ScientificResearch'), 90, iri('https://example.org/data-sharing/value/yes'), iri('https://w3id.org/dpv#Consent'), iri('https://example.org/data-sharing/value/no')),
     rule(61),
     ['Id' = research_us,
      'R' = iri('https://example.org/data-sharing/request/research-us'),
      'D' = iri('https://example.org/data-sharing/dataset/cohort-a'),
      'Recipient' = iri('https://example.org/data-sharing/org/university-us'),
      'Action' = iri('http://www.w3.org/ns/odrl/2/use'),
      'Purpose' = iri('https://w3id.org/dpv#ScientificResearch'),
      'Retention' = 90,
      'Pseudo' = iri('https://example.org/data-sharing/value/yes'),
      'Basis' = iri('https://w3id.org/dpv#Consent'),
      'Scc' = iri('https://example.org/data-sharing/value/no'),
      'G' = iri('https://example.org/data-sharing/graph/requests'),
      'PD' = iri('https://example.org/vocab/dataset'),
      'PR' = iri('https://example.org/vocab/recipient'),
      'PA' = iri('https://example.org/vocab/action'),
      'PP' = iri('https://example.org/vocab/purpose'),
      'PT' = iri('https://example.org/vocab/retentionDays'),
      'PPs' = iri('https://example.org/vocab/pseudonymized'),
      'PL' = iri('https://example.org/vocab/legalBasis'),
      'PS' = iri('https://example.org/vocab/standardContractualClauses'),
      'L' = literal('90', datatype('http://www.w3.org/2001/XMLSchema#integer'))],
     [request(research_us, iri('https://example.org/data-sharing/request/research-us')),
      g(requests, iri('https://example.org/data-sharing/graph/requests')),
      v(dataset, iri('https://example.org/vocab/dataset')),
      v(recipient, iri('https://example.org/vocab/recipient')),
      v(action, iri('https://example.org/vocab/action')),
      v(purpose, iri('https://example.org/vocab/purpose')),
      v(retention_days, iri('https://example.org/vocab/retentionDays')),
      v(pseudonymized, iri('https://example.org/vocab/pseudonymized')),
      v(legal_basis, iri('https://example.org/vocab/legalBasis')),
      v(scc, iri('https://example.org/vocab/standardContractualClauses')),
      rdf(iri('https://example.org/data-sharing/request/research-us'), iri('https://example.org/vocab/dataset'), iri('https://example.org/data-sharing/dataset/cohort-a'), iri('https://example.org/data-sharing/graph/requests')),
      rdf(iri('https://example.org/data-sharing/request/research-us'), iri('https://example.org/vocab/recipient'), iri('https://example.org/data-sharing/org/university-us'), iri('https://example.org/data-sharing/graph/requests')),
      rdf(iri('https://example.org/data-sharing/request/research-us'), iri('https://example.org/vocab/action'), iri('http://www.w3.org/ns/odrl/2/use'), iri('https://example.org/data-sharing/graph/requests')),
      rdf(iri('https://example.org/data-sharing/request/research-us'), iri('https://example.org/vocab/purpose'), iri('https://w3id.org/dpv#ScientificResearch'), iri('https://example.org/data-sharing/graph/requests')),
      rdf(iri('https://example.org/data-sharing/request/research-us'), iri('https://example.org/vocab/retentionDays'), literal('90', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/data-sharing/graph/requests')),
      integer_literal(literal('90', datatype('http://www.w3.org/2001/XMLSchema#integer')), 90),
      rdf(iri('https://example.org/data-sharing/request/research-us'), iri('https://example.org/vocab/pseudonymized'), iri('https://example.org/data-sharing/value/yes'), iri('https://example.org/data-sharing/graph/requests')),
      rdf(iri('https://example.org/data-sharing/request/research-us'), iri('https://example.org/vocab/legalBasis'), iri('https://w3id.org/dpv#Consent'), iri('https://example.org/data-sharing/graph/requests')),
      rdf(iri('https://example.org/data-sharing/request/research-us'), iri('https://example.org/vocab/standardContractualClauses'), iri('https://example.org/data-sharing/value/no'), iri('https://example.org/data-sharing/graph/requests'))]).
step(request(research_us, iri('https://example.org/data-sharing/request/research-us')),
     fact(59),
     [],
     []).
step(rdf(iri('https://example.org/data-sharing/request/research-us'), iri('https://example.org/vocab/dataset'), iri('https://example.org/data-sharing/dataset/cohort-a'), iri('https://example.org/data-sharing/graph/requests')),
     fact(31),
     [],
     []).
step(rdf(iri('https://example.org/data-sharing/request/research-us'), iri('https://example.org/vocab/recipient'), iri('https://example.org/data-sharing/org/university-us'), iri('https://example.org/data-sharing/graph/requests')),
     fact(32),
     [],
     []).
step(rdf(iri('https://example.org/data-sharing/request/research-us'), iri('https://example.org/vocab/action'), iri('http://www.w3.org/ns/odrl/2/use'), iri('https://example.org/data-sharing/graph/requests')),
     fact(33),
     [],
     []).
step(rdf(iri('https://example.org/data-sharing/request/research-us'), iri('https://example.org/vocab/purpose'), iri('https://w3id.org/dpv#ScientificResearch'), iri('https://example.org/data-sharing/graph/requests')),
     fact(34),
     [],
     []).
step(rdf(iri('https://example.org/data-sharing/request/research-us'), iri('https://example.org/vocab/retentionDays'), literal('90', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/data-sharing/graph/requests')),
     fact(35),
     [],
     []).
step(integer_literal(literal('90', datatype('http://www.w3.org/2001/XMLSchema#integer')), 90),
     rule(60),
     ['Text' = '90', 'N' = 90, 'Cs' = "90"],
     [atom_chars('90', "90"), number_chars(90, "90")]).
step(atom_chars('90', "90"), builtin, [], []).
step(number_chars(90, "90"), builtin, [], []).
step(rdf(iri('https://example.org/data-sharing/request/research-us'), iri('https://example.org/vocab/pseudonymized'), iri('https://example.org/data-sharing/value/yes'), iri('https://example.org/data-sharing/graph/requests')),
     fact(36),
     [],
     []).
step(rdf(iri('https://example.org/data-sharing/request/research-us'), iri('https://example.org/vocab/legalBasis'), iri('https://w3id.org/dpv#Consent'), iri('https://example.org/data-sharing/graph/requests')),
     fact(37),
     [],
     []).
step(rdf(iri('https://example.org/data-sharing/request/research-us'), iri('https://example.org/vocab/standardContractualClauses'), iri('https://example.org/data-sharing/value/no'), iri('https://example.org/data-sharing/graph/requests')),
     fact(38),
     [],
     []).
step(consent_basis(iri('https://w3id.org/dpv#Consent')), fact(56), [], []).
step(policy_permission(iri('https://example.org/data-sharing/dataset/cohort-a'), iri('http://www.w3.org/ns/odrl/2/use'), iri('https://w3id.org/dpv#ScientificResearch'), 180),
     rule(62),
     ['D' = iri('https://example.org/data-sharing/dataset/cohort-a'),
      'Action' = iri('http://www.w3.org/ns/odrl/2/use'),
      'Purpose' = iri('https://w3id.org/dpv#ScientificResearch'),
      'MaxRetention' = 180,
      'G' = iri('https://example.org/data-sharing/graph/policy'),
      'Rule' = iri('https://example.org/data-sharing/policy/research-permission'),
      'PM' = iri('https://example.org/vocab/maxRetentionDays'),
      'L' = literal('180', datatype('http://www.w3.org/2001/XMLSchema#integer'))],
     [g(policy, iri('https://example.org/data-sharing/graph/policy')),
      rdf(iri('https://example.org/data-sharing/policy/main'), iri('http://www.w3.org/ns/odrl/2/permission'), iri('https://example.org/data-sharing/policy/research-permission'), iri('https://example.org/data-sharing/graph/policy')),
      rdf(iri('https://example.org/data-sharing/policy/research-permission'), iri('http://www.w3.org/ns/odrl/2/target'), iri('https://example.org/data-sharing/dataset/cohort-a'), iri('https://example.org/data-sharing/graph/policy')),
      rdf(iri('https://example.org/data-sharing/policy/research-permission'), iri('http://www.w3.org/ns/odrl/2/action'), iri('http://www.w3.org/ns/odrl/2/use'), iri('https://example.org/data-sharing/graph/policy')),
      rdf(iri('https://example.org/data-sharing/policy/research-permission'), iri('http://www.w3.org/ns/odrl/2/purpose'), iri('https://w3id.org/dpv#ScientificResearch'), iri('https://example.org/data-sharing/graph/policy')),
      v(max_retention, iri('https://example.org/vocab/maxRetentionDays')),
      rdf(iri('https://example.org/data-sharing/policy/research-permission'), iri('https://example.org/vocab/maxRetentionDays'), literal('180', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/data-sharing/graph/policy')),
      integer_literal(literal('180', datatype('http://www.w3.org/2001/XMLSchema#integer')), 180)]).
step(rdf(iri('https://example.org/data-sharing/policy/main'), iri('http://www.w3.org/ns/odrl/2/permission'), iri('https://example.org/data-sharing/policy/research-permission'), iri('https://example.org/data-sharing/graph/policy')),
     fact(1),
     [],
     []).
step(rdf(iri('https://example.org/data-sharing/policy/research-permission'), iri('http://www.w3.org/ns/odrl/2/target'), iri('https://example.org/data-sharing/dataset/cohort-a'), iri('https://example.org/data-sharing/graph/policy')),
     fact(2),
     [],
     []).
step(rdf(iri('https://example.org/data-sharing/policy/research-permission'), iri('http://www.w3.org/ns/odrl/2/action'), iri('http://www.w3.org/ns/odrl/2/use'), iri('https://example.org/data-sharing/graph/policy')),
     fact(3),
     [],
     []).
step(rdf(iri('https://example.org/data-sharing/policy/research-permission'), iri('http://www.w3.org/ns/odrl/2/purpose'), iri('https://w3id.org/dpv#ScientificResearch'), iri('https://example.org/data-sharing/graph/policy')),
     fact(4),
     [],
     []).
step(v(max_retention, iri('https://example.org/vocab/maxRetentionDays')), fact(49), [], []).
step(rdf(iri('https://example.org/data-sharing/policy/research-permission'), iri('https://example.org/vocab/maxRetentionDays'), literal('180', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/data-sharing/graph/policy')),
     fact(5),
     [],
     []).
step(integer_literal(literal('180', datatype('http://www.w3.org/2001/XMLSchema#integer')), 180),
     rule(60),
     ['Text' = '180', 'N' = 180, 'Cs' = "180"],
     [atom_chars('180', "180"), number_chars(180, "180")]).
step(atom_chars('180', "180"), builtin, [], []).
step(number_chars(180, "180"), builtin, [], []).
step(certified(iri('https://example.org/data-sharing/org/university-us')),
     rule(65),
     ['Recipient' = iri('https://example.org/data-sharing/org/university-us'),
      'G' = iri('https://example.org/data-sharing/graph/organizations'),
      'P' = iri('https://example.org/vocab/certifiedResearchOrg'),
      'Y' = iri('https://example.org/data-sharing/value/yes')],
     [g(orgs, iri('https://example.org/data-sharing/graph/organizations')),
      v(certified, iri('https://example.org/vocab/certifiedResearchOrg')),
      yes(iri('https://example.org/data-sharing/value/yes')),
      rdf(iri('https://example.org/data-sharing/org/university-us'), iri('https://example.org/vocab/certifiedResearchOrg'), iri('https://example.org/data-sharing/value/yes'), iri('https://example.org/data-sharing/graph/organizations'))]).
step(g(orgs, iri('https://example.org/data-sharing/graph/organizations')), fact(52), [], []).
step(v(certified, iri('https://example.org/vocab/certifiedResearchOrg')), fact(48), [], []).
step(yes(iri('https://example.org/data-sharing/value/yes')), fact(53), [], []).
step(rdf(iri('https://example.org/data-sharing/org/university-us'), iri('https://example.org/vocab/certifiedResearchOrg'), iri('https://example.org/data-sharing/value/yes'), iri('https://example.org/data-sharing/graph/organizations')),
     fact(13),
     [],
     []).
step(90 =< 180, builtin, [], []).
step(iri('https://example.org/data-sharing/value/yes') = iri('https://example.org/data-sharing/value/yes'),
     builtin,
     [],
     []).
step(recipient_region(iri('https://example.org/data-sharing/org/university-us'), iri('https://example.org/data-sharing/region/us')),
     rule(64),
     ['Recipient' = iri('https://example.org/data-sharing/org/university-us'),
      'Region' = iri('https://example.org/data-sharing/region/us'),
      'G' = iri('https://example.org/data-sharing/graph/organizations'),
      'P' = iri('https://example.org/vocab/region')],
     [g(orgs, iri('https://example.org/data-sharing/graph/organizations')),
      v(region, iri('https://example.org/vocab/region')),
      rdf(iri('https://example.org/data-sharing/org/university-us'), iri('https://example.org/vocab/region'), iri('https://example.org/data-sharing/region/us'), iri('https://example.org/data-sharing/graph/organizations'))]).
step(v(region, iri('https://example.org/vocab/region')), fact(47), [], []).
step(rdf(iri('https://example.org/data-sharing/org/university-us'), iri('https://example.org/vocab/region'), iri('https://example.org/data-sharing/region/us'), iri('https://example.org/data-sharing/graph/organizations')),
     fact(12),
     [],
     []).
step(eu(iri('https://example.org/data-sharing/region/eu')), fact(55), [], []).
step(iri('https://example.org/data-sharing/region/us') \= iri('https://example.org/data-sharing/region/eu'),
     builtin,
     [],
     []).
step(no(iri('https://example.org/data-sharing/value/no')), fact(54), [], []).
step(iri('https://example.org/data-sharing/value/no') = iri('https://example.org/data-sharing/value/no'),
     builtin,
     [],
     []).
step(sharing_decision(research_eu, permit),
     rule(68),
     ['Id' = research_eu,
      'D' = iri('https://example.org/data-sharing/dataset/cohort-a'),
      'Recip' = iri('https://example.org/data-sharing/org/university-eu'),
      'Action' = iri('http://www.w3.org/ns/odrl/2/use'),
      'Purpose' = iri('https://w3id.org/dpv#ScientificResearch'),
      'Retention' = 120,
      'Pseudo' = iri('https://example.org/data-sharing/value/yes'),
      'Basis' = iri('https://w3id.org/dpv#Consent'),
      'Max' = 180,
      'Y' = iri('https://example.org/data-sharing/value/yes'),
      'Region' = iri('https://example.org/data-sharing/region/eu'),
      'EU' = iri('https://example.org/data-sharing/region/eu')],
     [request_data(research_eu, iri('https://example.org/data-sharing/request/research-eu'), iri('https://example.org/data-sharing/dataset/cohort-a'), iri('https://example.org/data-sharing/org/university-eu'), iri('http://www.w3.org/ns/odrl/2/use'), iri('https://w3id.org/dpv#ScientificResearch'), 120, iri('https://example.org/data-sharing/value/yes'), iri('https://w3id.org/dpv#Consent'), iri('https://example.org/data-sharing/value/yes')),
      consent_basis(iri('https://w3id.org/dpv#Consent')),
      policy_permission(iri('https://example.org/data-sharing/dataset/cohort-a'), iri('http://www.w3.org/ns/odrl/2/use'), iri('https://w3id.org/dpv#ScientificResearch'), 180),
      certified(iri('https://example.org/data-sharing/org/university-eu')),
      120 =< 180,
      yes(iri('https://example.org/data-sharing/value/yes')),
      iri('https://example.org/data-sharing/value/yes') = iri('https://example.org/data-sharing/value/yes'),
      recipient_region(iri('https://example.org/data-sharing/org/university-eu'), iri('https://example.org/data-sharing/region/eu')),
      eu(iri('https://example.org/data-sharing/region/eu')),
      iri('https://example.org/data-sharing/region/eu') = iri('https://example.org/data-sharing/region/eu')]).
step(request_data(research_eu, iri('https://example.org/data-sharing/request/research-eu'), iri('https://example.org/data-sharing/dataset/cohort-a'), iri('https://example.org/data-sharing/org/university-eu'), iri('http://www.w3.org/ns/odrl/2/use'), iri('https://w3id.org/dpv#ScientificResearch'), 120, iri('https://example.org/data-sharing/value/yes'), iri('https://w3id.org/dpv#Consent'), iri('https://example.org/data-sharing/value/yes')),
     rule(61),
     ['Id' = research_eu,
      'R' = iri('https://example.org/data-sharing/request/research-eu'),
      'D' = iri('https://example.org/data-sharing/dataset/cohort-a'),
      'Recipient' = iri('https://example.org/data-sharing/org/university-eu'),
      'Action' = iri('http://www.w3.org/ns/odrl/2/use'),
      'Purpose' = iri('https://w3id.org/dpv#ScientificResearch'),
      'Retention' = 120,
      'Pseudo' = iri('https://example.org/data-sharing/value/yes'),
      'Basis' = iri('https://w3id.org/dpv#Consent'),
      'Scc' = iri('https://example.org/data-sharing/value/yes'),
      'G' = iri('https://example.org/data-sharing/graph/requests'),
      'PD' = iri('https://example.org/vocab/dataset'),
      'PR' = iri('https://example.org/vocab/recipient'),
      'PA' = iri('https://example.org/vocab/action'),
      'PP' = iri('https://example.org/vocab/purpose'),
      'PT' = iri('https://example.org/vocab/retentionDays'),
      'PPs' = iri('https://example.org/vocab/pseudonymized'),
      'PL' = iri('https://example.org/vocab/legalBasis'),
      'PS' = iri('https://example.org/vocab/standardContractualClauses'),
      'L' = literal('120', datatype('http://www.w3.org/2001/XMLSchema#integer'))],
     [request(research_eu, iri('https://example.org/data-sharing/request/research-eu')),
      g(requests, iri('https://example.org/data-sharing/graph/requests')),
      v(dataset, iri('https://example.org/vocab/dataset')),
      v(recipient, iri('https://example.org/vocab/recipient')),
      v(action, iri('https://example.org/vocab/action')),
      v(purpose, iri('https://example.org/vocab/purpose')),
      v(retention_days, iri('https://example.org/vocab/retentionDays')),
      v(pseudonymized, iri('https://example.org/vocab/pseudonymized')),
      v(legal_basis, iri('https://example.org/vocab/legalBasis')),
      v(scc, iri('https://example.org/vocab/standardContractualClauses')),
      rdf(iri('https://example.org/data-sharing/request/research-eu'), iri('https://example.org/vocab/dataset'), iri('https://example.org/data-sharing/dataset/cohort-a'), iri('https://example.org/data-sharing/graph/requests')),
      rdf(iri('https://example.org/data-sharing/request/research-eu'), iri('https://example.org/vocab/recipient'), iri('https://example.org/data-sharing/org/university-eu'), iri('https://example.org/data-sharing/graph/requests')),
      rdf(iri('https://example.org/data-sharing/request/research-eu'), iri('https://example.org/vocab/action'), iri('http://www.w3.org/ns/odrl/2/use'), iri('https://example.org/data-sharing/graph/requests')),
      rdf(iri('https://example.org/data-sharing/request/research-eu'), iri('https://example.org/vocab/purpose'), iri('https://w3id.org/dpv#ScientificResearch'), iri('https://example.org/data-sharing/graph/requests')),
      rdf(iri('https://example.org/data-sharing/request/research-eu'), iri('https://example.org/vocab/retentionDays'), literal('120', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/data-sharing/graph/requests')),
      integer_literal(literal('120', datatype('http://www.w3.org/2001/XMLSchema#integer')), 120),
      rdf(iri('https://example.org/data-sharing/request/research-eu'), iri('https://example.org/vocab/pseudonymized'), iri('https://example.org/data-sharing/value/yes'), iri('https://example.org/data-sharing/graph/requests')),
      rdf(iri('https://example.org/data-sharing/request/research-eu'), iri('https://example.org/vocab/legalBasis'), iri('https://w3id.org/dpv#Consent'), iri('https://example.org/data-sharing/graph/requests')),
      rdf(iri('https://example.org/data-sharing/request/research-eu'), iri('https://example.org/vocab/standardContractualClauses'), iri('https://example.org/data-sharing/value/yes'), iri('https://example.org/data-sharing/graph/requests'))]).
step(request(research_eu, iri('https://example.org/data-sharing/request/research-eu')),
     fact(57),
     [],
     []).
step(rdf(iri('https://example.org/data-sharing/request/research-eu'), iri('https://example.org/vocab/dataset'), iri('https://example.org/data-sharing/dataset/cohort-a'), iri('https://example.org/data-sharing/graph/requests')),
     fact(15),
     [],
     []).
step(rdf(iri('https://example.org/data-sharing/request/research-eu'), iri('https://example.org/vocab/recipient'), iri('https://example.org/data-sharing/org/university-eu'), iri('https://example.org/data-sharing/graph/requests')),
     fact(16),
     [],
     []).
step(rdf(iri('https://example.org/data-sharing/request/research-eu'), iri('https://example.org/vocab/action'), iri('http://www.w3.org/ns/odrl/2/use'), iri('https://example.org/data-sharing/graph/requests')),
     fact(17),
     [],
     []).
step(rdf(iri('https://example.org/data-sharing/request/research-eu'), iri('https://example.org/vocab/purpose'), iri('https://w3id.org/dpv#ScientificResearch'), iri('https://example.org/data-sharing/graph/requests')),
     fact(18),
     [],
     []).
step(rdf(iri('https://example.org/data-sharing/request/research-eu'), iri('https://example.org/vocab/retentionDays'), literal('120', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/data-sharing/graph/requests')),
     fact(19),
     [],
     []).
step(integer_literal(literal('120', datatype('http://www.w3.org/2001/XMLSchema#integer')), 120),
     rule(60),
     ['Text' = '120', 'N' = 120, 'Cs' = "120"],
     [atom_chars('120', "120"), number_chars(120, "120")]).
step(atom_chars('120', "120"), builtin, [], []).
step(number_chars(120, "120"), builtin, [], []).
step(rdf(iri('https://example.org/data-sharing/request/research-eu'), iri('https://example.org/vocab/pseudonymized'), iri('https://example.org/data-sharing/value/yes'), iri('https://example.org/data-sharing/graph/requests')),
     fact(20),
     [],
     []).
step(rdf(iri('https://example.org/data-sharing/request/research-eu'), iri('https://example.org/vocab/legalBasis'), iri('https://w3id.org/dpv#Consent'), iri('https://example.org/data-sharing/graph/requests')),
     fact(21),
     [],
     []).
step(rdf(iri('https://example.org/data-sharing/request/research-eu'), iri('https://example.org/vocab/standardContractualClauses'), iri('https://example.org/data-sharing/value/yes'), iri('https://example.org/data-sharing/graph/requests')),
     fact(22),
     [],
     []).
step(certified(iri('https://example.org/data-sharing/org/university-eu')),
     rule(65),
     ['Recipient' = iri('https://example.org/data-sharing/org/university-eu'),
      'G' = iri('https://example.org/data-sharing/graph/organizations'),
      'P' = iri('https://example.org/vocab/certifiedResearchOrg'),
      'Y' = iri('https://example.org/data-sharing/value/yes')],
     [g(orgs, iri('https://example.org/data-sharing/graph/organizations')),
      v(certified, iri('https://example.org/vocab/certifiedResearchOrg')),
      yes(iri('https://example.org/data-sharing/value/yes')),
      rdf(iri('https://example.org/data-sharing/org/university-eu'), iri('https://example.org/vocab/certifiedResearchOrg'), iri('https://example.org/data-sharing/value/yes'), iri('https://example.org/data-sharing/graph/organizations'))]).
step(rdf(iri('https://example.org/data-sharing/org/university-eu'), iri('https://example.org/vocab/certifiedResearchOrg'), iri('https://example.org/data-sharing/value/yes'), iri('https://example.org/data-sharing/graph/organizations')),
     fact(11),
     [],
     []).
step(120 =< 180, builtin, [], []).
step(recipient_region(iri('https://example.org/data-sharing/org/university-eu'), iri('https://example.org/data-sharing/region/eu')),
     rule(64),
     ['Recipient' = iri('https://example.org/data-sharing/org/university-eu'),
      'Region' = iri('https://example.org/data-sharing/region/eu'),
      'G' = iri('https://example.org/data-sharing/graph/organizations'),
      'P' = iri('https://example.org/vocab/region')],
     [g(orgs, iri('https://example.org/data-sharing/graph/organizations')),
      v(region, iri('https://example.org/vocab/region')),
      rdf(iri('https://example.org/data-sharing/org/university-eu'), iri('https://example.org/vocab/region'), iri('https://example.org/data-sharing/region/eu'), iri('https://example.org/data-sharing/graph/organizations'))]).
step(rdf(iri('https://example.org/data-sharing/org/university-eu'), iri('https://example.org/vocab/region'), iri('https://example.org/data-sharing/region/eu'), iri('https://example.org/data-sharing/graph/organizations')),
     fact(10),
     [],
     []).
step(iri('https://example.org/data-sharing/region/eu') = iri('https://example.org/data-sharing/region/eu'),
     builtin,
     [],
     []).
step(obligation(research_eu, delete_after_days(120)),
     rule(70),
     [],
     [sharing_decision(research_eu, permit)]).
step(obligation(research_eu, retain_audit_log),
     rule(71),
     [],
     [sharing_decision(research_eu, permit)]).
step(decision_reason(research_eu, "ODRL permission matches; recipient is certified, data is pseudonymized, retention is within 180 days, and the transfer stays in-region."),
     rule(72),
     [],
     [sharing_decision(research_eu, permit)]).
step(decision_reason(marketing, "The requested marketing distribution matches an explicit ODRL prohibition."),
     rule(73),
     [],
     [sharing_decision(marketing, deny)]).
step(decision_reason(research_us, "The research purpose is permitted, but the out-of-region transfer lacks the required contractual safeguard and must be reviewed."),
     rule(74),
     [],
     [sharing_decision(research_us, review)]).
