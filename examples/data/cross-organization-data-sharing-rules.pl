% Flagship example: cross-organization data-sharing decisions using RDF,
% W3C ODRL vocabulary, DPV terms, and portable ISO Prolog policy rules.

%% ?- sharing_decision(X0, X1).
%% ?- obligation(X0, X1).
%% ?- decision_reason(X0, X1).

v(dataset, iri('https://example.org/vocab/dataset')).
v(recipient, iri('https://example.org/vocab/recipient')).
v(action, iri('https://example.org/vocab/action')).
v(purpose, iri('https://example.org/vocab/purpose')).
v(retention_days, iri('https://example.org/vocab/retentionDays')).
v(pseudonymized, iri('https://example.org/vocab/pseudonymized')).
v(legal_basis, iri('https://example.org/vocab/legalBasis')).
v(scc, iri('https://example.org/vocab/standardContractualClauses')).
v(region, iri('https://example.org/vocab/region')).
v(certified, iri('https://example.org/vocab/certifiedResearchOrg')).
v(max_retention, iri('https://example.org/vocab/maxRetentionDays')).

g(requests, iri('https://example.org/data-sharing/graph/requests')).
g(policy, iri('https://example.org/data-sharing/graph/policy')).
g(orgs, iri('https://example.org/data-sharing/graph/organizations')).

yes(iri('https://example.org/data-sharing/value/yes')).
no(iri('https://example.org/data-sharing/value/no')).
eu(iri('https://example.org/data-sharing/region/eu')).
consent_basis(iri('https://w3id.org/dpv#Consent')).

request(research_eu, iri('https://example.org/data-sharing/request/research-eu')).
request(marketing, iri('https://example.org/data-sharing/request/marketing')).
request(research_us, iri('https://example.org/data-sharing/request/research-us')).

integer_literal(literal(Text, datatype('http://www.w3.org/2001/XMLSchema#integer')), N) :- atom_chars(Text,Cs), number_chars(N,Cs).

request_data(Id,R,D,Recipient,Action,Purpose,Retention,Pseudo,Basis,Scc) :-
 request(Id,R), g(requests,G), v(dataset,PD),v(recipient,PR),v(action,PA),v(purpose,PP),v(retention_days,PT),v(pseudonymized,PPs),v(legal_basis,PL),v(scc,PS),
 rdf(R,PD,D,G),rdf(R,PR,Recipient,G),rdf(R,PA,Action,G),rdf(R,PP,Purpose,G),rdf(R,PT,L,G),integer_literal(L,Retention),rdf(R,PPs,Pseudo,G),rdf(R,PL,Basis,G),rdf(R,PS,Scc,G).

policy_permission(D,Action,Purpose,MaxRetention) :-
 g(policy,G), rdf(_,iri('http://www.w3.org/ns/odrl/2/permission'),Rule,G),
 rdf(Rule,iri('http://www.w3.org/ns/odrl/2/target'),D,G), rdf(Rule,iri('http://www.w3.org/ns/odrl/2/action'),Action,G), rdf(Rule,iri('http://www.w3.org/ns/odrl/2/purpose'),Purpose,G),
 v(max_retention,PM), rdf(Rule,PM,L,G), integer_literal(L,MaxRetention).

policy_prohibition(D,Action,Purpose) :-
 g(policy,G), rdf(_,iri('http://www.w3.org/ns/odrl/2/prohibition'),Rule,G),
 rdf(Rule,iri('http://www.w3.org/ns/odrl/2/target'),D,G), rdf(Rule,iri('http://www.w3.org/ns/odrl/2/action'),Action,G), rdf(Rule,iri('http://www.w3.org/ns/odrl/2/purpose'),Purpose,G).

recipient_region(Recipient,Region) :- g(orgs,G),v(region,P),rdf(Recipient,P,Region,G).
certified(Recipient) :- g(orgs,G),v(certified,P),yes(Y),rdf(Recipient,P,Y,G).

sharing_decision(Id, deny) :- request_data(Id,_R,D,_Recip,Action,Purpose,_Ret,_Ps,_B,_S), policy_prohibition(D,Action,Purpose).
sharing_decision(Id, review) :-
 request_data(Id,_R,D,Recip,Action,Purpose,Retention,Pseudo,Basis,Scc), consent_basis(Basis), policy_permission(D,Action,Purpose,Max), certified(Recip), Retention =< Max, yes(Y), Pseudo=Y,
 recipient_region(Recip,Region), eu(EU), Region \= EU, no(N), Scc=N.
sharing_decision(Id, permit) :-
 request_data(Id,_R,D,Recip,Action,Purpose,Retention,Pseudo,Basis,_Scc), consent_basis(Basis), policy_permission(D,Action,Purpose,Max), certified(Recip), Retention =< Max, yes(Y), Pseudo=Y,
 recipient_region(Recip,Region), eu(EU), Region=EU.
sharing_decision(Id, permit) :-
 request_data(Id,_R,D,Recip,Action,Purpose,Retention,Pseudo,Basis,Scc), consent_basis(Basis), policy_permission(D,Action,Purpose,Max), certified(Recip), Retention =< Max, yes(Y), Pseudo=Y,
 recipient_region(Recip,Region), eu(EU), Region \= EU, Scc=Y.

obligation(research_eu, delete_after_days(120)) :- sharing_decision(research_eu,permit).
obligation(research_eu, retain_audit_log) :- sharing_decision(research_eu,permit).

decision_reason(research_eu, "ODRL permission matches; recipient is certified, data is pseudonymized, retention is within 180 days, and the transfer stays in-region.") :- sharing_decision(research_eu,permit).
decision_reason(marketing, "The requested marketing distribution matches an explicit ODRL prohibition.") :- sharing_decision(marketing,deny).
decision_reason(research_us, "The research purpose is permitted, but the out-of-region transfer lacks the required contractual safeguard and must be reviewed.") :- sharing_decision(research_us,review).

result_rdf(R, iri('https://example.org/vocab/sharingDecision'), D, iri('https://example.org/data-sharing/graph/derived')) :-
 sharing_decision(Id,Decision), request(Id,R), decision_iri(Decision,D).
decision_iri(permit,iri('https://example.org/data-sharing/decision/permit')).
decision_iri(deny,iri('https://example.org/data-sharing/decision/deny')).
decision_iri(review,iri('https://example.org/data-sharing/decision/review')).

write_results :- result_rdf(S,P,O,G), write_term(rdf(S,P,O,G),[quoted(true)]), write('.'), nl, fail.
write_results.
:- set_prolog_flag(unknown, fail).
