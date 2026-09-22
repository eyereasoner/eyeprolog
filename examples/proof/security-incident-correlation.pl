type(inc42, confirmed_compromise).
why(
  type(inc42, confirmed_compromise),
  step(
    type(inc42, confirmed_compromise),
    rule("security-incident-correlation.pl", clause(23)),
    ['Incident' = inc42],
    [
      step(
        confirmed_compromise(inc42),
        rule("security-incident-correlation.pl", clause(22)),
        ['Incident' = inc42],
        [
          step(
            credential_abuse(inc42),
            rule("security-incident-correlation.pl", clause(18)),
            ['Incident' = inc42, 'User' = user_alice],
            [
              step(alert(inc42, suspicious_login, user_alice), fact("security-incident-correlation.pl", clause(9)), [], []),
              step(privileged_user(user_alice), fact("security-incident-correlation.pl", clause(7)), [], [])
            ]
          ),
          step(
            malware_on_critical_asset(inc42),
            rule("security-incident-correlation.pl", clause(19)),
            ['Incident' = inc42, 'Endpoint' = endpoint23, '_hash' = hash_redline],
            [
              step(alert(inc42, endpoint, endpoint23), fact("security-incident-correlation.pl", clause(8)), [], []),
              step(alert(inc42, malware_hash, hash_redline), fact("security-incident-correlation.pl", clause(10)), [], []),
              step(
                critical_asset(endpoint23),
                rule("security-incident-correlation.pl", clause(17)),
                ['Endpoint' = endpoint23],
                [
                  step(asset(endpoint23, criticality, high), fact("security-incident-correlation.pl", clause(3)), [], [])
                ]
              )
            ]
          ),
          step(
            c2_contact(inc42),
            rule("security-incident-correlation.pl", clause(20)),
            ['Incident' = inc42, 'Ip' = ip_203_0_113_17],
            [
              step(alert(inc42, outbound_ip, ip_203_0_113_17), fact("security-incident-correlation.pl", clause(11)), [], []),
              step(threat_intel(ip_203_0_113_17, command_and_control), fact("security-incident-correlation.pl", clause(16)), [], [])
            ]
          ),
          step(
            exploitable_endpoint(inc42),
            rule("security-incident-correlation.pl", clause(21)),
            ['Incident' = inc42, 'Endpoint' = endpoint23],
            [
              step(alert(inc42, endpoint, endpoint23), fact("security-incident-correlation.pl", clause(8)), [], []),
              step(vulnerability(endpoint23, cve_critical_rce), fact("security-incident-correlation.pl", clause(15)), [], [])
            ]
          )
        ]
      )
    ]
  )
).

status(inc42, escalate_to_incident_response).
why(
  status(inc42, escalate_to_incident_response),
  step(
    status(inc42, escalate_to_incident_response),
    rule("security-incident-correlation.pl", clause(24)),
    ['Incident' = inc42],
    [
      step(
        confirmed_compromise(inc42),
        rule("security-incident-correlation.pl", clause(22)),
        ['Incident' = inc42],
        [
          step(
            credential_abuse(inc42),
            rule("security-incident-correlation.pl", clause(18)),
            ['Incident' = inc42, 'User' = user_alice],
            [
              step(alert(inc42, suspicious_login, user_alice), fact("security-incident-correlation.pl", clause(9)), [], []),
              step(privileged_user(user_alice), fact("security-incident-correlation.pl", clause(7)), [], [])
            ]
          ),
          step(
            malware_on_critical_asset(inc42),
            rule("security-incident-correlation.pl", clause(19)),
            ['Incident' = inc42, 'Endpoint' = endpoint23, '_hash' = hash_redline],
            [
              step(alert(inc42, endpoint, endpoint23), fact("security-incident-correlation.pl", clause(8)), [], []),
              step(alert(inc42, malware_hash, hash_redline), fact("security-incident-correlation.pl", clause(10)), [], []),
              step(
                critical_asset(endpoint23),
                rule("security-incident-correlation.pl", clause(17)),
                ['Endpoint' = endpoint23],
                [
                  step(asset(endpoint23, criticality, high), fact("security-incident-correlation.pl", clause(3)), [], [])
                ]
              )
            ]
          ),
          step(
            c2_contact(inc42),
            rule("security-incident-correlation.pl", clause(20)),
            ['Incident' = inc42, 'Ip' = ip_203_0_113_17],
            [
              step(alert(inc42, outbound_ip, ip_203_0_113_17), fact("security-incident-correlation.pl", clause(11)), [], []),
              step(threat_intel(ip_203_0_113_17, command_and_control), fact("security-incident-correlation.pl", clause(16)), [], [])
            ]
          ),
          step(
            exploitable_endpoint(inc42),
            rule("security-incident-correlation.pl", clause(21)),
            ['Incident' = inc42, 'Endpoint' = endpoint23],
            [
              step(alert(inc42, endpoint, endpoint23), fact("security-incident-correlation.pl", clause(8)), [], []),
              step(vulnerability(endpoint23, cve_critical_rce), fact("security-incident-correlation.pl", clause(15)), [], [])
            ]
          )
        ]
      )
    ]
  )
).

reason(inc42, "privileged credential abuse, malware on a critical endpoint, C2 contact, and exploitable RCE are correlated").
why(
  reason(inc42, "privileged credential abuse, malware on a critical endpoint, C2 contact, and exploitable RCE are correlated"),
  step(
    reason(inc42, "privileged credential abuse, malware on a critical endpoint, C2 contact, and exploitable RCE are correlated"),
    rule("security-incident-correlation.pl", clause(25)),
    ['Incident' = inc42],
    [
      step(
        confirmed_compromise(inc42),
        rule("security-incident-correlation.pl", clause(22)),
        ['Incident' = inc42],
        [
          step(
            credential_abuse(inc42),
            rule("security-incident-correlation.pl", clause(18)),
            ['Incident' = inc42, 'User' = user_alice],
            [
              step(alert(inc42, suspicious_login, user_alice), fact("security-incident-correlation.pl", clause(9)), [], []),
              step(privileged_user(user_alice), fact("security-incident-correlation.pl", clause(7)), [], [])
            ]
          ),
          step(
            malware_on_critical_asset(inc42),
            rule("security-incident-correlation.pl", clause(19)),
            ['Incident' = inc42, 'Endpoint' = endpoint23, '_hash' = hash_redline],
            [
              step(alert(inc42, endpoint, endpoint23), fact("security-incident-correlation.pl", clause(8)), [], []),
              step(alert(inc42, malware_hash, hash_redline), fact("security-incident-correlation.pl", clause(10)), [], []),
              step(
                critical_asset(endpoint23),
                rule("security-incident-correlation.pl", clause(17)),
                ['Endpoint' = endpoint23],
                [
                  step(asset(endpoint23, criticality, high), fact("security-incident-correlation.pl", clause(3)), [], [])
                ]
              )
            ]
          ),
          step(
            c2_contact(inc42),
            rule("security-incident-correlation.pl", clause(20)),
            ['Incident' = inc42, 'Ip' = ip_203_0_113_17],
            [
              step(alert(inc42, outbound_ip, ip_203_0_113_17), fact("security-incident-correlation.pl", clause(11)), [], []),
              step(threat_intel(ip_203_0_113_17, command_and_control), fact("security-incident-correlation.pl", clause(16)), [], [])
            ]
          ),
          step(
            exploitable_endpoint(inc42),
            rule("security-incident-correlation.pl", clause(21)),
            ['Incident' = inc42, 'Endpoint' = endpoint23],
            [
              step(alert(inc42, endpoint, endpoint23), fact("security-incident-correlation.pl", clause(8)), [], []),
              step(vulnerability(endpoint23, cve_critical_rce), fact("security-incident-correlation.pl", clause(15)), [], [])
            ]
          )
        ]
      )
    ]
  )
).

