% Prolog result format 4
query(1, label(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 7).
answer(1, ['X0' = scenarioA, 'X1' = "A – Primary care visit"]).
answer(1, ['X0' = scenarioB, 'X1' = "B – Quality improvement (in scope)"]).
answer(1, ['X0' = scenarioC, 'X1' = "C – Quality improvement (out of scope)"]).
answer(1, ['X0' = scenarioD, 'X1' = "D – Insurance management"]).
answer(1, ['X0' = scenarioE, 'X1' = "E – GP checks labs"]).
answer(1, ['X0' = scenarioF, 'X1' = "F – Research on anonymised dataset"]).
answer(1, ['X0' = scenarioG, 'X1' = "G – AI training (opt-out)"]).
query(2, description(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 7).
answer(2,
       ['X0' = scenarioA,
        'X1' = "Clinician in the patient's care team accessing the patient summary for primary care management."]).
answer(2,
       ['X0' = scenarioB,
        'X1' = "QI analyst using lab results + summary in a secure environment."]).
answer(2,
       ['X0' = scenarioC,
        'X1' = "QI analyst with only lab results; policy expects labs + summary."]).
answer(2,
       ['X0' = scenarioD,
        'X1' = "Insurance bot attempting to use health data for insurance management (prohibited purpose)."]).
answer(2,
       ['X0' = scenarioE,
        'X1' = "GP for the same patient checking lab results via the API gateway."]).
answer(2,
       ['X0' = scenarioF,
        'X1' = "Researcher using anonymised labs + summary in a secure environment, with opt-in."]).
answer(2,
       ['X0' = scenarioG,
        'X1' = "Data user wants to train AI, but the subject opted out of AI training."]).
query(3, careTeamLinked(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 2).
answer(3, ['X0' = scenarioA, 'X1' = true]).
answer(3, ['X0' = scenarioE, 'X1' = true]).
query(4, subjectOptIn(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4, ['X0' = scenarioF, 'X1' = true]).
query(5, subjectOptOut(_0, _1), ['X0' = _0, 'X1' = _1]).
result(5, complete, 1).
answer(5, ['X0' = scenarioG, 'X1' = true]).
query(6, decision(_0, _1), ['X0' = _0, 'X1' = _1]).
result(6, complete, 7).
answer(6, ['X0' = scenarioA, 'X1' = "PERMIT"]).
answer(6, ['X0' = scenarioE, 'X1' = "PERMIT"]).
answer(6, ['X0' = scenarioB, 'X1' = "PERMIT"]).
answer(6, ['X0' = scenarioF, 'X1' = "PERMIT"]).
answer(6, ['X0' = scenarioD, 'X1' = "DENY"]).
answer(6, ['X0' = scenarioG, 'X1' = "DENY"]).
answer(6, ['X0' = scenarioC, 'X1' = "DENY"]).
query(7, matchedPolicyUid(_0, _1), ['X0' = _0, 'X1' = _1]).
result(7, complete, 4).
answer(7, ['X0' = scenarioA, 'X1' = "urn:policy:primary-care-001"]).
answer(7, ['X0' = scenarioE, 'X1' = "urn:policy:primary-care-001"]).
answer(7, ['X0' = scenarioB, 'X1' = "urn:policy:qi-2025-aurora"]).
answer(7, ['X0' = scenarioF, 'X1' = "urn:policy:research-aurora-diabetes"]).
query(8, matchedProhibition(_0, _1), ['X0' = _0, 'X1' = _1]).
result(8, complete, 1).
answer(8, ['X0' = scenarioD, 'X1' = policyDenyInsurance]).
query(9, reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(9, complete, 7).
answer(9,
       ['X0' = scenarioA,
        'X1' = "Permitted: clinician in the patient's care team, and the primary-care policy matched."]).
answer(9,
       ['X0' = scenarioE,
        'X1' = "Permitted: clinician in the patient's care team, and the primary-care policy matched."]).
answer(9, ['X0' = scenarioB, 'X1' = "Permitted: ODRL/DPV policy matched for secondary use."]).
answer(9,
       ['X0' = scenarioF,
        'X1' = "Permitted: subject opted in and an ODRL/DPV policy matched (anonymised dataset in secure environment)."]).
answer(9,
       ['X0' = scenarioD,
        'X1' = "Denied: the requested purpose (insurance management) is prohibited by policy."]).
answer(9,
       ['X0' = scenarioG,
        'X1' = "Denied: you opted out of your data being used to train AI systems."]).
answer(9,
       ['X0' = scenarioC,
        'X1' = "Denied: no policy matched (purpose, environment, TOMs, or categories out of scope)."]).
query(10, trace(_0, _1), ['X0' = _0, 'X1' = _1]).
result(10, complete, 10).
answer(10, ['X0' = scenarioA, 'X1' = "permit:primary_care_allowed"]).
answer(10, ['X0' = scenarioE, 'X1' = "permit:primary_care_allowed"]).
answer(10,
       ['X0' = scenarioA, 'X1' = "urn:policy:primary-care-001:permit:odrl:permission_matched"]).
answer(10,
       ['X0' = scenarioE, 'X1' = "urn:policy:primary-care-001:permit:odrl:permission_matched"]).
answer(10,
       ['X0' = scenarioB, 'X1' = "urn:policy:qi-2025-aurora:permit:odrl:permission_matched"]).
answer(10,
       ['X0' = scenarioF,
        'X1' = "urn:policy:research-aurora-diabetes:permit:odrl:permission_matched"]).
answer(10, ['X0' = scenarioD, 'X1' = "deny:prohibited_purpose"]).
answer(10, ['X0' = scenarioD, 'X1' = "urn:policy:deny-insurance:deny:odrl:prohibition_matched"]).
answer(10, ['X0' = scenarioG, 'X1' = "deny:subject_opted_out_ai_training"]).
answer(10,
       ['X0' = scenarioC, 'X1' = "urn:policy:qi-2025-aurora:deny:odrl:no_permission_matched"]).
query(11, checkC1(_0, _1), ['X0' = _0, 'X1' = _1]).
result(11, complete, 7).
answer(11, ['X0' = scenarioA, 'X1' = "SKIPPED - not a prohibited purpose"]).
answer(11, ['X0' = scenarioB, 'X1' = "SKIPPED - not a prohibited purpose"]).
answer(11, ['X0' = scenarioC, 'X1' = "SKIPPED - not a prohibited purpose"]).
answer(11, ['X0' = scenarioD, 'X1' = "OK - denied prohibited purpose"]).
answer(11, ['X0' = scenarioE, 'X1' = "SKIPPED - not a prohibited purpose"]).
answer(11, ['X0' = scenarioF, 'X1' = "SKIPPED - not a prohibited purpose"]).
answer(11, ['X0' = scenarioG, 'X1' = "SKIPPED - not a prohibited purpose"]).
query(12, checkC2(_0, _1), ['X0' = _0, 'X1' = _1]).
result(12, complete, 7).
answer(12, ['X0' = scenarioA, 'X1' = "OK - clinician"]).
answer(12, ['X0' = scenarioB, 'X1' = "SKIPPED"]).
answer(12, ['X0' = scenarioC, 'X1' = "SKIPPED"]).
answer(12, ['X0' = scenarioD, 'X1' = "SKIPPED"]).
answer(12, ['X0' = scenarioE, 'X1' = "OK - clinician"]).
answer(12, ['X0' = scenarioF, 'X1' = "SKIPPED"]).
answer(12, ['X0' = scenarioG, 'X1' = "SKIPPED"]).
query(13, checkC3(_0, _1), ['X0' = _0, 'X1' = _1]).
result(13, complete, 7).
answer(13, ['X0' = scenarioA, 'X1' = "OK - care-team linked"]).
answer(13, ['X0' = scenarioB, 'X1' = "SKIPPED"]).
answer(13, ['X0' = scenarioC, 'X1' = "SKIPPED"]).
answer(13, ['X0' = scenarioD, 'X1' = "SKIPPED"]).
answer(13, ['X0' = scenarioE, 'X1' = "OK - care-team linked"]).
answer(13, ['X0' = scenarioF, 'X1' = "SKIPPED"]).
answer(13, ['X0' = scenarioG, 'X1' = "SKIPPED"]).
query(14, checkC4(_0, _1), ['X0' = _0, 'X1' = _1]).
result(14, complete, 7).
answer(14, ['X0' = scenarioA, 'X1' = "SKIPPED"]).
answer(14, ['X0' = scenarioB, 'X1' = "OK - opt-in present and policy matched"]).
answer(14, ['X0' = scenarioC, 'X1' = "OK - denied because opt-in missing or no policy match"]).
answer(14, ['X0' = scenarioD, 'X1' = "SKIPPED"]).
answer(14, ['X0' = scenarioE, 'X1' = "SKIPPED"]).
answer(14, ['X0' = scenarioF, 'X1' = "OK - opt-in present and policy matched"]).
answer(14, ['X0' = scenarioG, 'X1' = "OK - denied because opt-in missing or no policy match"]).
query(15, checkC5(_0, _1), ['X0' = _0, 'X1' = _1]).
result(15, complete, 7).
answer(15,
       ['X0' = scenarioA,
        'X1' = "OK - operator=isAnyOf, allowed=[\"https://example.org/health#PATIENT_SUMMARY\", \"https://example.org/health#LAB_RESULTS\"], requested=[\"https://example.org/health#PATIENT_SUMMARY\"]"]).
answer(15,
       ['X0' = scenarioB,
        'X1' = "OK - operator=isAllOf, allowed=[\"https://example.org/health#LAB_RESULTS\", \"https://example.org/health#PATIENT_SUMMARY\"], requested=[\"https://example.org/health#LAB_RESULTS\", \"https://example.org/health#PATIENT_SUMMARY\"]"]).
answer(15, ['X0' = scenarioC, 'X1' = "SKIPPED"]).
answer(15, ['X0' = scenarioD, 'X1' = "SKIPPED"]).
answer(15,
       ['X0' = scenarioE,
        'X1' = "OK - operator=isAnyOf, allowed=[\"https://example.org/health#PATIENT_SUMMARY\", \"https://example.org/health#LAB_RESULTS\"], requested=[\"https://example.org/health#LAB_RESULTS\"]"]).
answer(15,
       ['X0' = scenarioF,
        'X1' = "OK - operator=isAnyOf, allowed=[\"https://example.org/health#LAB_RESULTS\", \"https://example.org/health#PATIENT_SUMMARY\", \"https://example.org/health#IMAGING_REPORT\"], requested=[\"https://example.org/health#PATIENT_SUMMARY\", \"https://example.org/health#LAB_RESULTS\"]"]).
answer(15, ['X0' = scenarioG, 'X1' = "SKIPPED"]).
query(16, checkC6(_0, _1), ['X0' = _0, 'X1' = _1]).
result(16, complete, 7).
answer(16, ['X0' = scenarioA, 'X1' = "SKIPPED - no prohibition matched"]).
answer(16, ['X0' = scenarioB, 'X1' = "SKIPPED - no prohibition matched"]).
answer(16, ['X0' = scenarioC, 'X1' = "SKIPPED - no prohibition matched"]).
answer(16, ['X0' = scenarioD, 'X1' = "OK - denied due to prohibition"]).
answer(16, ['X0' = scenarioE, 'X1' = "SKIPPED - no prohibition matched"]).
answer(16, ['X0' = scenarioF, 'X1' = "SKIPPED - no prohibition matched"]).
answer(16, ['X0' = scenarioG, 'X1' = "SKIPPED - no prohibition matched"]).
query(17, checkC7(_0, _1), ['X0' = _0, 'X1' = _1]).
result(17, complete, 7).
answer(17, ['X0' = scenarioA, 'X1' = "OK - trace shows matching permission"]).
answer(17, ['X0' = scenarioB, 'X1' = "OK - trace shows matching permission"]).
answer(17, ['X0' = scenarioC, 'X1' = "SKIPPED"]).
answer(17, ['X0' = scenarioD, 'X1' = "SKIPPED"]).
answer(17, ['X0' = scenarioE, 'X1' = "OK - trace shows matching permission"]).
answer(17, ['X0' = scenarioF, 'X1' = "OK - trace shows matching permission"]).
answer(17, ['X0' = scenarioG, 'X1' = "SKIPPED"]).
query(18, checkC8(_0, _1), ['X0' = _0, 'X1' = _1]).
result(18, complete, 7).
answer(18, ['X0' = scenarioA, 'X1' = "SKIPPED - no matched policy or no duties"]).
answer(18,
       ['X0' = scenarioB,
        'X1' = "INFO - duties attached: duty:https://w3id.org/dpv/legal/eu/ehds#requireConsent, duty:https://w3id.org/dpv/legal/eu/ehds#noExfiltration"]).
answer(18, ['X0' = scenarioC, 'X1' = "SKIPPED - no matched policy or no duties"]).
answer(18, ['X0' = scenarioD, 'X1' = "SKIPPED - no matched policy or no duties"]).
answer(18, ['X0' = scenarioE, 'X1' = "SKIPPED - no matched policy or no duties"]).
answer(18,
       ['X0' = scenarioF,
        'X1' = "INFO - duties attached: duty:https://w3id.org/dpv/legal/eu/ehds#annualOutcomeReport, duty:https://w3id.org/dpv/legal/eu/ehds#noReidentification, duty:https://w3id.org/dpv/legal/eu/ehds#noExfiltration"]).
answer(18, ['X0' = scenarioG, 'X1' = "SKIPPED - no matched policy or no duties"]).
query(19, checkC9(_0, _1), ['X0' = _0, 'X1' = _1]).
result(19, complete, 7).
answer(19, ['X0' = scenarioA, 'X1' = "SKIPPED - policy has no environment constraint"]).
answer(19,
       ['X0' = scenarioB,
        'X1' = "OK - operator=eq, allowed=\"secure_env\", requested=\"secure_env\""]).
answer(19, ['X0' = scenarioC, 'X1' = "SKIPPED"]).
answer(19, ['X0' = scenarioD, 'X1' = "SKIPPED"]).
answer(19, ['X0' = scenarioE, 'X1' = "SKIPPED - policy has no environment constraint"]).
answer(19,
       ['X0' = scenarioF,
        'X1' = "OK - operator=eq, allowed=\"secure_env\", requested=\"secure_env\""]).
answer(19, ['X0' = scenarioG, 'X1' = "SKIPPED"]).
query(20, checkC10Text(_0, _1), ['X0' = _0, 'X1' = _1]).
result(20, complete, 7).
answer(20, ['X0' = scenarioA, 'X1' = "INFO - matched policy: urn:policy:primary-care-001"]).
answer(20, ['X0' = scenarioB, 'X1' = "INFO - matched policy: urn:policy:qi-2025-aurora"]).
answer(20, ['X0' = scenarioC, 'X1' = "SKIPPED - no matched policy"]).
answer(20, ['X0' = scenarioD, 'X1' = "SKIPPED - no matched policy"]).
answer(20, ['X0' = scenarioE, 'X1' = "INFO - matched policy: urn:policy:primary-care-001"]).
answer(20,
       ['X0' = scenarioF, 'X1' = "INFO - matched policy: urn:policy:research-aurora-diabetes"]).
answer(20, ['X0' = scenarioG, 'X1' = "SKIPPED - no matched policy"]).
