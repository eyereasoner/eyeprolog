# Security incident correlation

## Which alerts add up to a confirmed compromise?

A security team sees many alerts: a strange login here, a malware hash there,
traffic to an unknown address. Each on its own is noise. This example
correlates four independent signals and escalates an incident only when all
four line up, with a proof that names each one.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=security-incident-correlation) ·
[Source](../security-incident-correlation.pl)

---

# The question

Two incidents are open, `inc42` and `inc43`. Which one is a confirmed
compromise that should go to incident response, and on what evidence?

---

# The signals

```prolog
asset(endpoint23, criticality, high).
privileged_user(user_alice).

alert(inc42, endpoint, endpoint23).
alert(inc42, suspicious_login, user_alice).
alert(inc42, malware_hash, hash_redline).
alert(inc42, outbound_ip, ip_203_0_113_17).

vulnerability(endpoint23, cve_critical_rce).
threat_intel(ip_203_0_113_17, command_and_control).
```

Alerts come from different tools (endpoint, identity, network). Asset data,
vulnerability scans, and threat intelligence (C2 = command-and-control server)
add context.

---

# The rules

```prolog
credential_abuse(Incident) :-
  alert(Incident, suspicious_login, User),
  privileged_user(User).

c2_contact(Incident) :-
  alert(Incident, outbound_ip, Ip),
  threat_intel(Ip, command_and_control).

confirmed_compromise(Incident) :-
  credential_abuse(Incident),
  malware_on_critical_asset(Incident),
  c2_contact(Incident),
  exploitable_endpoint(Incident).
```

Each signal is a named concept with its own rule. The decision is their
conjunction: all four, for the same incident.

---

# The answer

```sh
eyeprolog examples/security-incident-correlation.pl
```

```text
type(inc42, confirmed_compromise).
status(inc42, escalate_to_incident_response).
reason(inc42, "privileged credential abuse, malware on a critical endpoint, C2 contact, and exploitable RCE are correlated").
```

Only `inc42` escalates. `inc43` has a suspicious login and outbound traffic,
but no privileged user, no malware, no known C2 address, and no vulnerable
endpoint.

---

# The reason

```text
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
```

The escalation rests on four named findings, and each finding rests on
specific alerts and context facts. An analyst can follow any branch down to
the raw alert that supports it.

---

# The check

```text
condition('C1', resolution, ok, 17).
condition('C4', coverage, ok, 20).
verdict(checked).
```

All 17 steps replay against the rules and facts they cite, and nothing is
taken on trust: the decision depends only on positive evidence.

---

# Try it

- Remove `vulnerability(endpoint23, cve_critical_rce).` and predict which
  answers disappear.
- Make `user_bob` privileged and add C2 intelligence for `ip_198_51_100_42`.
  Is `inc43` confirmed now? Which signal is still missing?
- Add a weaker `status(Incident, investigate)` rule that needs only two of the
  four signals.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 14.
