% Prolog result format 4
query(1, type(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = inc42, 'X1' = confirmed_compromise]).
why(1, ['X0' = inc42, 'X1' = confirmed_compromise], [type(inc42, confirmed_compromise)]).
query(2, status(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = inc42, 'X1' = escalate_to_incident_response]).
why(2,
    ['X0' = inc42, 'X1' = escalate_to_incident_response],
    [status(inc42, escalate_to_incident_response)]).
query(3, reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3,
       ['X0' = inc42,
        'X1' = "privileged credential abuse, malware on a critical endpoint, C2 contact, and exploitable RCE are correlated"]).
why(3,
    ['X0' = inc42,
     'X1' = "privileged credential abuse, malware on a critical endpoint, C2 contact, and exploitable RCE are correlated"],
    [reason(inc42, "privileged credential abuse, malware on a critical endpoint, C2 contact, and exploitable RCE are correlated")]).

clause(3, asset(endpoint23, criticality, high), true).
clause(7, privileged_user(user_alice), true).
clause(8, alert(inc42, endpoint, endpoint23), true).
clause(9, alert(inc42, suspicious_login, user_alice), true).
clause(10, alert(inc42, malware_hash, hash_redline), true).
clause(11, alert(inc42, outbound_ip, ip_203_0_113_17), true).
clause(15, vulnerability(endpoint23, cve_critical_rce), true).
clause(16, threat_intel(ip_203_0_113_17, command_and_control), true).
clause(17, critical_asset(var('Endpoint')), asset(var('Endpoint'), criticality, high)).
clause(18,
       credential_abuse(var('Incident')),
       (alert(var('Incident'), suspicious_login, var('User')), privileged_user(var('User')))).
clause(19,
       malware_on_critical_asset(var('Incident')),
       (alert(var('Incident'), endpoint, var('Endpoint')),
        alert(var('Incident'), malware_hash, anonymous(1)),
        critical_asset(var('Endpoint')))).
clause(20,
       c2_contact(var('Incident')),
       (alert(var('Incident'), outbound_ip, var('Ip')),
        threat_intel(var('Ip'), command_and_control))).
clause(21,
       exploitable_endpoint(var('Incident')),
       (alert(var('Incident'), endpoint, var('Endpoint')),
        vulnerability(var('Endpoint'), cve_critical_rce))).
clause(22,
       confirmed_compromise(var('Incident')),
       (credential_abuse(var('Incident')),
        malware_on_critical_asset(var('Incident')),
        c2_contact(var('Incident')),
        exploitable_endpoint(var('Incident')))).
clause(23, type(var('Incident'), confirmed_compromise), confirmed_compromise(var('Incident'))).
clause(24,
       status(var('Incident'), escalate_to_incident_response),
       confirmed_compromise(var('Incident'))).
clause(25,
       reason(var('Incident'), "privileged credential abuse, malware on a critical endpoint, C2 contact, and exploitable RCE are correlated"),
       confirmed_compromise(var('Incident'))).

step(type(inc42, confirmed_compromise),
     rule(23),
     ['Incident' = inc42],
     [confirmed_compromise(inc42)]).
step(confirmed_compromise(inc42),
     rule(22),
     ['Incident' = inc42],
     [credential_abuse(inc42),
      malware_on_critical_asset(inc42),
      c2_contact(inc42),
      exploitable_endpoint(inc42)]).
step(credential_abuse(inc42),
     rule(18),
     ['Incident' = inc42, 'User' = user_alice],
     [alert(inc42, suspicious_login, user_alice), privileged_user(user_alice)]).
step(alert(inc42, suspicious_login, user_alice), fact(9), [], []).
step(privileged_user(user_alice), fact(7), [], []).
step(malware_on_critical_asset(inc42),
     rule(19),
     ['Incident' = inc42, 'Endpoint' = endpoint23],
     [alert(inc42, endpoint, endpoint23),
      alert(inc42, malware_hash, hash_redline),
      critical_asset(endpoint23)]).
step(alert(inc42, endpoint, endpoint23), fact(8), [], []).
step(alert(inc42, malware_hash, hash_redline), fact(10), [], []).
step(critical_asset(endpoint23),
     rule(17),
     ['Endpoint' = endpoint23],
     [asset(endpoint23, criticality, high)]).
step(asset(endpoint23, criticality, high), fact(3), [], []).
step(c2_contact(inc42),
     rule(20),
     ['Incident' = inc42, 'Ip' = ip_203_0_113_17],
     [alert(inc42, outbound_ip, ip_203_0_113_17),
      threat_intel(ip_203_0_113_17, command_and_control)]).
step(alert(inc42, outbound_ip, ip_203_0_113_17), fact(11), [], []).
step(threat_intel(ip_203_0_113_17, command_and_control), fact(16), [], []).
step(exploitable_endpoint(inc42),
     rule(21),
     ['Incident' = inc42, 'Endpoint' = endpoint23],
     [alert(inc42, endpoint, endpoint23), vulnerability(endpoint23, cve_critical_rce)]).
step(vulnerability(endpoint23, cve_critical_rce), fact(15), [], []).
step(status(inc42, escalate_to_incident_response),
     rule(24),
     ['Incident' = inc42],
     [confirmed_compromise(inc42)]).
step(reason(inc42, "privileged credential abuse, malware on a critical endpoint, C2 contact, and exploitable RCE are correlated"),
     rule(25),
     ['Incident' = inc42],
     [confirmed_compromise(inc42)]).
