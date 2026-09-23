label(scenarioA, "A – Primary care visit").
label(scenarioB, "B – Quality improvement (in scope)").
label(scenarioC, "C – Quality improvement (out of scope)").
label(scenarioD, "D – Insurance management").
label(scenarioE, "E – GP checks labs").
label(scenarioF, "F – Research on anonymised dataset").
label(scenarioG, "G – AI training (opt-out)").
description(scenarioA, "Clinician in the patient's care team accessing the patient summary for primary care management.").
description(scenarioB, "QI analyst using lab results + summary in a secure environment.").
description(scenarioC, "QI analyst with only lab results; policy expects labs + summary.").
description(scenarioD, "Insurance bot attempting to use health data for insurance management (prohibited purpose).").
description(scenarioE, "GP for the same patient checking lab results via the API gateway.").
description(scenarioF, "Researcher using anonymised labs + summary in a secure environment, with opt-in.").
description(scenarioG, "Data user wants to train AI, but the subject opted out of AI training.").
careTeamLinked(scenarioA, true).
careTeamLinked(scenarioE, true).
subjectOptIn(scenarioF, true).
subjectOptOut(scenarioG, true).
decision(scenarioA, "PERMIT").
decision(scenarioE, "PERMIT").
decision(scenarioB, "PERMIT").
decision(scenarioF, "PERMIT").
decision(scenarioD, "DENY").
decision(scenarioG, "DENY").
decision(scenarioC, "DENY").
matchedPolicyUid(scenarioA, "urn:policy:primary-care-001").
matchedPolicyUid(scenarioE, "urn:policy:primary-care-001").
matchedPolicyUid(scenarioB, "urn:policy:qi-2025-aurora").
matchedPolicyUid(scenarioF, "urn:policy:research-aurora-diabetes").
matchedProhibition(scenarioD, policyDenyInsurance).
reason(scenarioA, "Permitted: clinician in the patient's care team, and the primary-care policy matched.").
reason(scenarioE, "Permitted: clinician in the patient's care team, and the primary-care policy matched.").
reason(scenarioB, "Permitted: ODRL/DPV policy matched for secondary use.").
reason(scenarioF, "Permitted: subject opted in and an ODRL/DPV policy matched (anonymised dataset in secure environment).").
reason(scenarioD, "Denied: the requested purpose (insurance management) is prohibited by policy.").
reason(scenarioG, "Denied: you opted out of your data being used to train AI systems.").
reason(scenarioC, "Denied: no policy matched (purpose, environment, TOMs, or categories out of scope).").
trace(scenarioA, "permit:primary_care_allowed").
trace(scenarioE, "permit:primary_care_allowed").
trace(scenarioA, "urn:policy:primary-care-001:permit:odrl:permission_matched").
trace(scenarioE, "urn:policy:primary-care-001:permit:odrl:permission_matched").
trace(scenarioB, "urn:policy:qi-2025-aurora:permit:odrl:permission_matched").
trace(scenarioF, "urn:policy:research-aurora-diabetes:permit:odrl:permission_matched").
trace(scenarioD, "deny:prohibited_purpose").
trace(scenarioD, "urn:policy:deny-insurance:deny:odrl:prohibition_matched").
trace(scenarioG, "deny:subject_opted_out_ai_training").
trace(scenarioC, "urn:policy:qi-2025-aurora:deny:odrl:no_permission_matched").
checkC1(scenarioA, "SKIPPED - not a prohibited purpose").
checkC1(scenarioB, "SKIPPED - not a prohibited purpose").
checkC1(scenarioC, "SKIPPED - not a prohibited purpose").
checkC1(scenarioD, "OK - denied prohibited purpose").
checkC1(scenarioE, "SKIPPED - not a prohibited purpose").
checkC1(scenarioF, "SKIPPED - not a prohibited purpose").
checkC1(scenarioG, "SKIPPED - not a prohibited purpose").
checkC2(scenarioA, "OK - clinician").
checkC2(scenarioB, "SKIPPED").
checkC2(scenarioC, "SKIPPED").
checkC2(scenarioD, "SKIPPED").
checkC2(scenarioE, "OK - clinician").
checkC2(scenarioF, "SKIPPED").
checkC2(scenarioG, "SKIPPED").
checkC3(scenarioA, "OK - care-team linked").
checkC3(scenarioB, "SKIPPED").
checkC3(scenarioC, "SKIPPED").
checkC3(scenarioD, "SKIPPED").
checkC3(scenarioE, "OK - care-team linked").
checkC3(scenarioF, "SKIPPED").
checkC3(scenarioG, "SKIPPED").
checkC4(scenarioA, "SKIPPED").
checkC4(scenarioB, "OK - opt-in present and policy matched").
checkC4(scenarioC, "OK - denied because opt-in missing or no policy match").
checkC4(scenarioD, "SKIPPED").
checkC4(scenarioE, "SKIPPED").
checkC4(scenarioF, "OK - opt-in present and policy matched").
checkC4(scenarioG, "OK - denied because opt-in missing or no policy match").
checkC5(scenarioA, "OK - operator=isAnyOf, allowed=[\"https://example.org/health#PATIENT_SUMMARY\", \"https://example.org/health#LAB_RESULTS\"], requested=[\"https://example.org/health#PATIENT_SUMMARY\"]").
checkC5(scenarioB, "OK - operator=isAllOf, allowed=[\"https://example.org/health#LAB_RESULTS\", \"https://example.org/health#PATIENT_SUMMARY\"], requested=[\"https://example.org/health#LAB_RESULTS\", \"https://example.org/health#PATIENT_SUMMARY\"]").
checkC5(scenarioC, "SKIPPED").
checkC5(scenarioD, "SKIPPED").
checkC5(scenarioE, "OK - operator=isAnyOf, allowed=[\"https://example.org/health#PATIENT_SUMMARY\", \"https://example.org/health#LAB_RESULTS\"], requested=[\"https://example.org/health#LAB_RESULTS\"]").
checkC5(scenarioF, "OK - operator=isAnyOf, allowed=[\"https://example.org/health#LAB_RESULTS\", \"https://example.org/health#PATIENT_SUMMARY\", \"https://example.org/health#IMAGING_REPORT\"], requested=[\"https://example.org/health#PATIENT_SUMMARY\", \"https://example.org/health#LAB_RESULTS\"]").
checkC5(scenarioG, "SKIPPED").
checkC6(scenarioA, "SKIPPED - no prohibition matched").
checkC6(scenarioB, "SKIPPED - no prohibition matched").
checkC6(scenarioC, "SKIPPED - no prohibition matched").
checkC6(scenarioD, "OK - denied due to prohibition").
checkC6(scenarioE, "SKIPPED - no prohibition matched").
checkC6(scenarioF, "SKIPPED - no prohibition matched").
checkC6(scenarioG, "SKIPPED - no prohibition matched").
checkC7(scenarioA, "OK - trace shows matching permission").
checkC7(scenarioB, "OK - trace shows matching permission").
checkC7(scenarioC, "SKIPPED").
checkC7(scenarioD, "SKIPPED").
checkC7(scenarioE, "OK - trace shows matching permission").
checkC7(scenarioF, "OK - trace shows matching permission").
checkC7(scenarioG, "SKIPPED").
checkC8(scenarioA, "SKIPPED - no matched policy or no duties").
checkC8(scenarioB, "INFO - duties attached: duty:https://w3id.org/dpv/legal/eu/ehds#requireConsent, duty:https://w3id.org/dpv/legal/eu/ehds#noExfiltration").
checkC8(scenarioC, "SKIPPED - no matched policy or no duties").
checkC8(scenarioD, "SKIPPED - no matched policy or no duties").
checkC8(scenarioE, "SKIPPED - no matched policy or no duties").
checkC8(scenarioF, "INFO - duties attached: duty:https://w3id.org/dpv/legal/eu/ehds#annualOutcomeReport, duty:https://w3id.org/dpv/legal/eu/ehds#noReidentification, duty:https://w3id.org/dpv/legal/eu/ehds#noExfiltration").
checkC8(scenarioG, "SKIPPED - no matched policy or no duties").
checkC9(scenarioA, "SKIPPED - policy has no environment constraint").
checkC9(scenarioB, "OK - operator=eq, allowed=\"secure_env\", requested=\"secure_env\"").
checkC9(scenarioC, "SKIPPED").
checkC9(scenarioD, "SKIPPED").
checkC9(scenarioE, "SKIPPED - policy has no environment constraint").
checkC9(scenarioF, "OK - operator=eq, allowed=\"secure_env\", requested=\"secure_env\"").
checkC9(scenarioG, "SKIPPED").
checkC10Text(scenarioA, "INFO - matched policy: urn:policy:primary-care-001").
checkC10Text(scenarioB, "INFO - matched policy: urn:policy:qi-2025-aurora").
checkC10Text(scenarioC, "SKIPPED - no matched policy").
checkC10Text(scenarioD, "SKIPPED - no matched policy").
checkC10Text(scenarioE, "INFO - matched policy: urn:policy:primary-care-001").
checkC10Text(scenarioF, "INFO - matched policy: urn:policy:research-aurora-diabetes").
checkC10Text(scenarioG, "SKIPPED - no matched policy").
