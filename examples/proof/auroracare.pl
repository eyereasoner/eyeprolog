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

clause(28, policyUid(policyPrimary, "urn:policy:primary-care-001"), true).
clause(32, allowAnyCategory(policyPrimary, patientSummary), true).
clause(33, allowAnyCategory(policyPrimary, labResults), true).
clause(34, policyUid(policyQi, "urn:policy:qi-2025-aurora"), true).
clause(41, policyUid(policyResearch, "urn:policy:research-aurora-diabetes"), true).
clause(52, prohibitPurpose(policyDenyInsurance, insuranceManagement), true).
clause(53, linkedTo(clinicianAlba, ruben), true).
clause(54, linkedTo(gpRuben, ruben), true).
clause(55, consentAllow(ruben, healthcareScientificResearch), true).
clause(56, consentDeny(ruben, trainTestAndEvaluateAiSystemsAlgorithms), true).
clause(62, scenario_label(scenarioA, "A – Primary care visit"), true).
clause(63,
       scenario_description(scenarioA, "Clinician in the patient's care team accessing the patient summary for primary care management."),
       true).
clause(64, requester(scenarioA, clinicianAlba), true).
clause(65, requesterRole(scenarioA, "clinician"), true).
clause(66, subject(scenarioA, ruben), true).
clause(67, purpose(scenarioA, primaryCareManagement), true).
clause(69, category(scenarioA, patientSummary), true).
clause(72, scenario_label(scenarioB, "B – Quality improvement (in scope)"), true).
clause(73,
       scenario_description(scenarioB, "QI analyst using lab results + summary in a secure environment."),
       true).
clause(77, purpose(scenarioB, ensureQualitySafetyHealthcare), true).
clause(78, environment(scenarioB, "secure_env"), true).
clause(79, category(scenarioB, labResults), true).
clause(80, category(scenarioB, patientSummary), true).
clause(83, scenario_label(scenarioC, "C – Quality improvement (out of scope)"), true).
clause(84,
       scenario_description(scenarioC, "QI analyst with only lab results; policy expects labs + summary."),
       true).
clause(88, purpose(scenarioC, ensureQualitySafetyHealthcare), true).
clause(93, scenario_label(scenarioD, "D – Insurance management"), true).
clause(94,
       scenario_description(scenarioD, "Insurance bot attempting to use health data for insurance management (prohibited purpose)."),
       true).
clause(98, purpose(scenarioD, insuranceManagement), true).
clause(103, scenario_label(scenarioE, "E – GP checks labs"), true).
clause(104,
       scenario_description(scenarioE, "GP for the same patient checking lab results via the API gateway."),
       true).
clause(105, requester(scenarioE, gpRuben), true).
clause(106, requesterRole(scenarioE, "clinician"), true).
clause(107, subject(scenarioE, ruben), true).
clause(108, purpose(scenarioE, primaryCareManagement), true).
clause(110, category(scenarioE, labResults), true).
clause(113, scenario_label(scenarioF, "F – Research on anonymised dataset"), true).
clause(114,
       scenario_description(scenarioF, "Researcher using anonymised labs + summary in a secure environment, with opt-in."),
       true).
clause(117, subject(scenarioF, ruben), true).
clause(118, purpose(scenarioF, healthcareScientificResearch), true).
clause(119, environment(scenarioF, "secure_env"), true).
clause(120, tom(scenarioF, anonymisation), true).
clause(122, category(scenarioF, labResults), true).
clause(125, scenario_label(scenarioG, "G – AI training (opt-out)"), true).
clause(126,
       scenario_description(scenarioG, "Data user wants to train AI, but the subject opted out of AI training."),
       true).
clause(129, subject(scenarioG, ruben), true).
clause(130, purpose(scenarioG, trainTestAndEvaluateAiSystemsAlgorithms), true).
clause(134, label(var('S'), var('Label')), scenario_label(var('S'), var('Label'))).
clause(135,
       description(var('S'), var('Description')),
       scenario_description(var('S'), var('Description'))).
clause(136,
       care_team_linked(var('S')),
       (requester(var('S'), var('Requester')),
        subject(var('S'), var('Subject')),
        linkedTo(var('Requester'), var('Subject')))).
clause(137,
       subject_opt_in(var('S')),
       (subject(var('S'), var('Subject')),
        purpose(var('S'), var('Purpose')),
        consentAllow(var('Subject'), var('Purpose')))).
clause(138,
       subject_opt_out(var('S')),
       (subject(var('S'), var('Subject')),
        purpose(var('S'), var('Purpose')),
        consentDeny(var('Subject'), var('Purpose')))).
clause(139,
       primary_policy_match(var('S')),
       (purpose(var('S'), primaryCareManagement),
        requesterRole(var('S'), "clinician"),
        care_team_linked(var('S')),
        category(var('S'), var('Category')),
        allowAnyCategory(policyPrimary, var('Category')))).
clause(140,
       qi_policy_match(var('S')),
       (purpose(var('S'), ensureQualitySafetyHealthcare),
        environment(var('S'), "secure_env"),
        category(var('S'), labResults),
        category(var('S'), patientSummary))).
clause(141,
       research_policy_match(var('S')),
       (purpose(var('S'), healthcareScientificResearch),
        environment(var('S'), "secure_env"),
        tom(var('S'), anonymisation),
        subject_opt_in(var('S')),
        category(var('S'), labResults))).
clause(142,
       insurance_prohibition_match(var('S')),
       (purpose(var('S'), insuranceManagement),
        prohibitPurpose(policyDenyInsurance, insuranceManagement))).
clause(143,
       ai_training_opt_out_match(var('S')),
       (purpose(var('S'), trainTestAndEvaluateAiSystemsAlgorithms), subject_opt_out(var('S')))).
clause(144, careTeamLinked(var('S'), true), care_team_linked(var('S'))).
clause(145, subjectOptIn(var('S'), true), subject_opt_in(var('S'))).
clause(146, subjectOptOut(var('S'), true), subject_opt_out(var('S'))).
clause(147, decision(var('S'), "PERMIT"), primary_policy_match(var('S'))).
clause(148, decision(var('S'), "PERMIT"), qi_policy_match(var('S'))).
clause(149, decision(var('S'), "PERMIT"), research_policy_match(var('S'))).
clause(150, decision(var('S'), "DENY"), insurance_prohibition_match(var('S'))).
clause(151, decision(var('S'), "DENY"), ai_training_opt_out_match(var('S'))).
clause(152, decision(scenarioC, "DENY"), purpose(scenarioC, ensureQualitySafetyHealthcare)).
clause(153,
       matchedPolicyUid(var('S'), var('Uid')),
       (primary_policy_match(var('S')), policyUid(policyPrimary, var('Uid')))).
clause(154,
       matchedPolicyUid(var('S'), var('Uid')),
       (qi_policy_match(var('S')), policyUid(policyQi, var('Uid')))).
clause(155,
       matchedPolicyUid(var('S'), var('Uid')),
       (research_policy_match(var('S')), policyUid(policyResearch, var('Uid')))).
clause(156,
       matchedProhibition(var('S'), policyDenyInsurance),
       insurance_prohibition_match(var('S'))).
clause(157,
       reason(var('S'), "Permitted: clinician in the patient's care team, and the primary-care policy matched."),
       primary_policy_match(var('S'))).
clause(158,
       reason(var('S'), "Permitted: ODRL/DPV policy matched for secondary use."),
       qi_policy_match(var('S'))).
clause(159,
       reason(var('S'), "Permitted: subject opted in and an ODRL/DPV policy matched (anonymised dataset in secure environment)."),
       research_policy_match(var('S'))).
clause(160,
       reason(var('S'), "Denied: the requested purpose (insurance management) is prohibited by policy."),
       insurance_prohibition_match(var('S'))).
clause(161,
       reason(var('S'), "Denied: you opted out of your data being used to train AI systems."),
       ai_training_opt_out_match(var('S'))).
clause(162,
       reason(scenarioC, "Denied: no policy matched (purpose, environment, TOMs, or categories out of scope)."),
       purpose(scenarioC, ensureQualitySafetyHealthcare)).
clause(163, trace(var('S'), "permit:primary_care_allowed"), primary_policy_match(var('S'))).
clause(164,
       trace(var('S'), "urn:policy:primary-care-001:permit:odrl:permission_matched"),
       primary_policy_match(var('S'))).
clause(165,
       trace(var('S'), "urn:policy:qi-2025-aurora:permit:odrl:permission_matched"),
       qi_policy_match(var('S'))).
clause(166,
       trace(var('S'), "urn:policy:research-aurora-diabetes:permit:odrl:permission_matched"),
       research_policy_match(var('S'))).
clause(167, trace(var('S'), "deny:prohibited_purpose"), insurance_prohibition_match(var('S'))).
clause(168,
       trace(var('S'), "urn:policy:deny-insurance:deny:odrl:prohibition_matched"),
       insurance_prohibition_match(var('S'))).
clause(169,
       trace(var('S'), "deny:subject_opted_out_ai_training"),
       ai_training_opt_out_match(var('S'))).
clause(170,
       trace(scenarioC, "urn:policy:qi-2025-aurora:deny:odrl:no_permission_matched"),
       purpose(scenarioC, ensureQualitySafetyHealthcare)).
clause(171,
       checkC1(scenarioA, "SKIPPED - not a prohibited purpose"),
       decision(scenarioA, "PERMIT")).
clause(172, checkC2(scenarioA, "OK - clinician"), decision(scenarioA, "PERMIT")).
clause(173, checkC3(scenarioA, "OK - care-team linked"), decision(scenarioA, "PERMIT")).
clause(174, checkC4(scenarioA, "SKIPPED"), decision(scenarioA, "PERMIT")).
clause(175,
       checkC5(scenarioA, "OK - operator=isAnyOf, allowed=[\"https://example.org/health#PATIENT_SUMMARY\", \"https://example.org/health#LAB_RESULTS\"], requested=[\"https://example.org/health#PATIENT_SUMMARY\"]"),
       decision(scenarioA, "PERMIT")).
clause(176,
       checkC6(scenarioA, "SKIPPED - no prohibition matched"),
       decision(scenarioA, "PERMIT")).
clause(177,
       checkC7(scenarioA, "OK - trace shows matching permission"),
       decision(scenarioA, "PERMIT")).
clause(178,
       checkC8(scenarioA, "SKIPPED - no matched policy or no duties"),
       decision(scenarioA, "PERMIT")).
clause(179,
       checkC9(scenarioA, "SKIPPED - policy has no environment constraint"),
       decision(scenarioA, "PERMIT")).
clause(180,
       checkC10Text(scenarioA, "INFO - matched policy: urn:policy:primary-care-001"),
       decision(scenarioA, "PERMIT")).
clause(181,
       checkC1(scenarioB, "SKIPPED - not a prohibited purpose"),
       decision(scenarioB, "PERMIT")).
clause(182, checkC2(scenarioB, "SKIPPED"), decision(scenarioB, "PERMIT")).
clause(183, checkC3(scenarioB, "SKIPPED"), decision(scenarioB, "PERMIT")).
clause(184,
       checkC4(scenarioB, "OK - opt-in present and policy matched"),
       decision(scenarioB, "PERMIT")).
clause(185,
       checkC5(scenarioB, "OK - operator=isAllOf, allowed=[\"https://example.org/health#LAB_RESULTS\", \"https://example.org/health#PATIENT_SUMMARY\"], requested=[\"https://example.org/health#LAB_RESULTS\", \"https://example.org/health#PATIENT_SUMMARY\"]"),
       decision(scenarioB, "PERMIT")).
clause(186,
       checkC6(scenarioB, "SKIPPED - no prohibition matched"),
       decision(scenarioB, "PERMIT")).
clause(187,
       checkC7(scenarioB, "OK - trace shows matching permission"),
       decision(scenarioB, "PERMIT")).
clause(188,
       checkC8(scenarioB, "INFO - duties attached: duty:https://w3id.org/dpv/legal/eu/ehds#requireConsent, duty:https://w3id.org/dpv/legal/eu/ehds#noExfiltration"),
       decision(scenarioB, "PERMIT")).
clause(189,
       checkC9(scenarioB, "OK - operator=eq, allowed=\"secure_env\", requested=\"secure_env\""),
       decision(scenarioB, "PERMIT")).
clause(190,
       checkC10Text(scenarioB, "INFO - matched policy: urn:policy:qi-2025-aurora"),
       decision(scenarioB, "PERMIT")).
clause(191,
       checkC1(scenarioC, "SKIPPED - not a prohibited purpose"),
       decision(scenarioC, "DENY")).
clause(192, checkC2(scenarioC, "SKIPPED"), decision(scenarioC, "DENY")).
clause(193, checkC3(scenarioC, "SKIPPED"), decision(scenarioC, "DENY")).
clause(194,
       checkC4(scenarioC, "OK - denied because opt-in missing or no policy match"),
       decision(scenarioC, "DENY")).
clause(195, checkC5(scenarioC, "SKIPPED"), decision(scenarioC, "DENY")).
clause(196, checkC6(scenarioC, "SKIPPED - no prohibition matched"), decision(scenarioC, "DENY")).
clause(197, checkC7(scenarioC, "SKIPPED"), decision(scenarioC, "DENY")).
clause(198,
       checkC8(scenarioC, "SKIPPED - no matched policy or no duties"),
       decision(scenarioC, "DENY")).
clause(199, checkC9(scenarioC, "SKIPPED"), decision(scenarioC, "DENY")).
clause(200, checkC10Text(scenarioC, "SKIPPED - no matched policy"), decision(scenarioC, "DENY")).
clause(201, checkC1(scenarioD, "OK - denied prohibited purpose"), decision(scenarioD, "DENY")).
clause(202, checkC2(scenarioD, "SKIPPED"), decision(scenarioD, "DENY")).
clause(203, checkC3(scenarioD, "SKIPPED"), decision(scenarioD, "DENY")).
clause(204, checkC4(scenarioD, "SKIPPED"), decision(scenarioD, "DENY")).
clause(205, checkC5(scenarioD, "SKIPPED"), decision(scenarioD, "DENY")).
clause(206, checkC6(scenarioD, "OK - denied due to prohibition"), decision(scenarioD, "DENY")).
clause(207, checkC7(scenarioD, "SKIPPED"), decision(scenarioD, "DENY")).
clause(208,
       checkC8(scenarioD, "SKIPPED - no matched policy or no duties"),
       decision(scenarioD, "DENY")).
clause(209, checkC9(scenarioD, "SKIPPED"), decision(scenarioD, "DENY")).
clause(210, checkC10Text(scenarioD, "SKIPPED - no matched policy"), decision(scenarioD, "DENY")).
clause(211,
       checkC1(scenarioE, "SKIPPED - not a prohibited purpose"),
       decision(scenarioE, "PERMIT")).
clause(212, checkC2(scenarioE, "OK - clinician"), decision(scenarioE, "PERMIT")).
clause(213, checkC3(scenarioE, "OK - care-team linked"), decision(scenarioE, "PERMIT")).
clause(214, checkC4(scenarioE, "SKIPPED"), decision(scenarioE, "PERMIT")).
clause(215,
       checkC5(scenarioE, "OK - operator=isAnyOf, allowed=[\"https://example.org/health#PATIENT_SUMMARY\", \"https://example.org/health#LAB_RESULTS\"], requested=[\"https://example.org/health#LAB_RESULTS\"]"),
       decision(scenarioE, "PERMIT")).
clause(216,
       checkC6(scenarioE, "SKIPPED - no prohibition matched"),
       decision(scenarioE, "PERMIT")).
clause(217,
       checkC7(scenarioE, "OK - trace shows matching permission"),
       decision(scenarioE, "PERMIT")).
clause(218,
       checkC8(scenarioE, "SKIPPED - no matched policy or no duties"),
       decision(scenarioE, "PERMIT")).
clause(219,
       checkC9(scenarioE, "SKIPPED - policy has no environment constraint"),
       decision(scenarioE, "PERMIT")).
clause(220,
       checkC10Text(scenarioE, "INFO - matched policy: urn:policy:primary-care-001"),
       decision(scenarioE, "PERMIT")).
clause(221,
       checkC1(scenarioF, "SKIPPED - not a prohibited purpose"),
       decision(scenarioF, "PERMIT")).
clause(222, checkC2(scenarioF, "SKIPPED"), decision(scenarioF, "PERMIT")).
clause(223, checkC3(scenarioF, "SKIPPED"), decision(scenarioF, "PERMIT")).
clause(224,
       checkC4(scenarioF, "OK - opt-in present and policy matched"),
       decision(scenarioF, "PERMIT")).
clause(225,
       checkC5(scenarioF, "OK - operator=isAnyOf, allowed=[\"https://example.org/health#LAB_RESULTS\", \"https://example.org/health#PATIENT_SUMMARY\", \"https://example.org/health#IMAGING_REPORT\"], requested=[\"https://example.org/health#PATIENT_SUMMARY\", \"https://example.org/health#LAB_RESULTS\"]"),
       decision(scenarioF, "PERMIT")).
clause(226,
       checkC6(scenarioF, "SKIPPED - no prohibition matched"),
       decision(scenarioF, "PERMIT")).
clause(227,
       checkC7(scenarioF, "OK - trace shows matching permission"),
       decision(scenarioF, "PERMIT")).
clause(228,
       checkC8(scenarioF, "INFO - duties attached: duty:https://w3id.org/dpv/legal/eu/ehds#annualOutcomeReport, duty:https://w3id.org/dpv/legal/eu/ehds#noReidentification, duty:https://w3id.org/dpv/legal/eu/ehds#noExfiltration"),
       decision(scenarioF, "PERMIT")).
clause(229,
       checkC9(scenarioF, "OK - operator=eq, allowed=\"secure_env\", requested=\"secure_env\""),
       decision(scenarioF, "PERMIT")).
clause(230,
       checkC10Text(scenarioF, "INFO - matched policy: urn:policy:research-aurora-diabetes"),
       decision(scenarioF, "PERMIT")).
clause(231,
       checkC1(scenarioG, "SKIPPED - not a prohibited purpose"),
       decision(scenarioG, "DENY")).
clause(232, checkC2(scenarioG, "SKIPPED"), decision(scenarioG, "DENY")).
clause(233, checkC3(scenarioG, "SKIPPED"), decision(scenarioG, "DENY")).
clause(234,
       checkC4(scenarioG, "OK - denied because opt-in missing or no policy match"),
       decision(scenarioG, "DENY")).
clause(235, checkC5(scenarioG, "SKIPPED"), decision(scenarioG, "DENY")).
clause(236, checkC6(scenarioG, "SKIPPED - no prohibition matched"), decision(scenarioG, "DENY")).
clause(237, checkC7(scenarioG, "SKIPPED"), decision(scenarioG, "DENY")).
clause(238,
       checkC8(scenarioG, "SKIPPED - no matched policy or no duties"),
       decision(scenarioG, "DENY")).
clause(239, checkC9(scenarioG, "SKIPPED"), decision(scenarioG, "DENY")).
clause(240, checkC10Text(scenarioG, "SKIPPED - no matched policy"), decision(scenarioG, "DENY")).

step(label(scenarioA, "A – Primary care visit"),
     rule(134),
     ['S' = scenarioA, 'Label' = "A – Primary care visit"],
     [scenario_label(scenarioA, "A – Primary care visit")]).
step(scenario_label(scenarioA, "A – Primary care visit"), fact(62), [], []).
step(label(scenarioB, "B – Quality improvement (in scope)"),
     rule(134),
     ['S' = scenarioB, 'Label' = "B – Quality improvement (in scope)"],
     [scenario_label(scenarioB, "B – Quality improvement (in scope)")]).
step(scenario_label(scenarioB, "B – Quality improvement (in scope)"), fact(72), [], []).
step(label(scenarioC, "C – Quality improvement (out of scope)"),
     rule(134),
     ['S' = scenarioC, 'Label' = "C – Quality improvement (out of scope)"],
     [scenario_label(scenarioC, "C – Quality improvement (out of scope)")]).
step(scenario_label(scenarioC, "C – Quality improvement (out of scope)"), fact(83), [], []).
step(label(scenarioD, "D – Insurance management"),
     rule(134),
     ['S' = scenarioD, 'Label' = "D – Insurance management"],
     [scenario_label(scenarioD, "D – Insurance management")]).
step(scenario_label(scenarioD, "D – Insurance management"), fact(93), [], []).
step(label(scenarioE, "E – GP checks labs"),
     rule(134),
     ['S' = scenarioE, 'Label' = "E – GP checks labs"],
     [scenario_label(scenarioE, "E – GP checks labs")]).
step(scenario_label(scenarioE, "E – GP checks labs"), fact(103), [], []).
step(label(scenarioF, "F – Research on anonymised dataset"),
     rule(134),
     ['S' = scenarioF, 'Label' = "F – Research on anonymised dataset"],
     [scenario_label(scenarioF, "F – Research on anonymised dataset")]).
step(scenario_label(scenarioF, "F – Research on anonymised dataset"), fact(113), [], []).
step(label(scenarioG, "G – AI training (opt-out)"),
     rule(134),
     ['S' = scenarioG, 'Label' = "G – AI training (opt-out)"],
     [scenario_label(scenarioG, "G – AI training (opt-out)")]).
step(scenario_label(scenarioG, "G – AI training (opt-out)"), fact(125), [], []).
step(description(scenarioA, "Clinician in the patient's care team accessing the patient summary for primary care management."),
     rule(135),
     ['S' = scenarioA,
      'Description' = "Clinician in the patient's care team accessing the patient summary for primary care management."],
     [scenario_description(scenarioA, "Clinician in the patient's care team accessing the patient summary for primary care management.")]).
step(scenario_description(scenarioA, "Clinician in the patient's care team accessing the patient summary for primary care management."),
     fact(63),
     [],
     []).
step(description(scenarioB, "QI analyst using lab results + summary in a secure environment."),
     rule(135),
     ['S' = scenarioB,
      'Description' = "QI analyst using lab results + summary in a secure environment."],
     [scenario_description(scenarioB, "QI analyst using lab results + summary in a secure environment.")]).
step(scenario_description(scenarioB, "QI analyst using lab results + summary in a secure environment."),
     fact(73),
     [],
     []).
step(description(scenarioC, "QI analyst with only lab results; policy expects labs + summary."),
     rule(135),
     ['S' = scenarioC,
      'Description' = "QI analyst with only lab results; policy expects labs + summary."],
     [scenario_description(scenarioC, "QI analyst with only lab results; policy expects labs + summary.")]).
step(scenario_description(scenarioC, "QI analyst with only lab results; policy expects labs + summary."),
     fact(84),
     [],
     []).
step(description(scenarioD, "Insurance bot attempting to use health data for insurance management (prohibited purpose)."),
     rule(135),
     ['S' = scenarioD,
      'Description' = "Insurance bot attempting to use health data for insurance management (prohibited purpose)."],
     [scenario_description(scenarioD, "Insurance bot attempting to use health data for insurance management (prohibited purpose).")]).
step(scenario_description(scenarioD, "Insurance bot attempting to use health data for insurance management (prohibited purpose)."),
     fact(94),
     [],
     []).
step(description(scenarioE, "GP for the same patient checking lab results via the API gateway."),
     rule(135),
     ['S' = scenarioE,
      'Description' = "GP for the same patient checking lab results via the API gateway."],
     [scenario_description(scenarioE, "GP for the same patient checking lab results via the API gateway.")]).
step(scenario_description(scenarioE, "GP for the same patient checking lab results via the API gateway."),
     fact(104),
     [],
     []).
step(description(scenarioF, "Researcher using anonymised labs + summary in a secure environment, with opt-in."),
     rule(135),
     ['S' = scenarioF,
      'Description' = "Researcher using anonymised labs + summary in a secure environment, with opt-in."],
     [scenario_description(scenarioF, "Researcher using anonymised labs + summary in a secure environment, with opt-in.")]).
step(scenario_description(scenarioF, "Researcher using anonymised labs + summary in a secure environment, with opt-in."),
     fact(114),
     [],
     []).
step(description(scenarioG, "Data user wants to train AI, but the subject opted out of AI training."),
     rule(135),
     ['S' = scenarioG,
      'Description' = "Data user wants to train AI, but the subject opted out of AI training."],
     [scenario_description(scenarioG, "Data user wants to train AI, but the subject opted out of AI training.")]).
step(scenario_description(scenarioG, "Data user wants to train AI, but the subject opted out of AI training."),
     fact(126),
     [],
     []).
step(careTeamLinked(scenarioA, true),
     rule(144),
     ['S' = scenarioA],
     [care_team_linked(scenarioA)]).
step(care_team_linked(scenarioA),
     rule(136),
     ['S' = scenarioA, 'Requester' = clinicianAlba, 'Subject' = ruben],
     [requester(scenarioA, clinicianAlba),
      subject(scenarioA, ruben),
      linkedTo(clinicianAlba, ruben)]).
step(requester(scenarioA, clinicianAlba), fact(64), [], []).
step(subject(scenarioA, ruben), fact(66), [], []).
step(linkedTo(clinicianAlba, ruben), fact(53), [], []).
step(careTeamLinked(scenarioE, true),
     rule(144),
     ['S' = scenarioE],
     [care_team_linked(scenarioE)]).
step(care_team_linked(scenarioE),
     rule(136),
     ['S' = scenarioE, 'Requester' = gpRuben, 'Subject' = ruben],
     [requester(scenarioE, gpRuben), subject(scenarioE, ruben), linkedTo(gpRuben, ruben)]).
step(requester(scenarioE, gpRuben), fact(105), [], []).
step(subject(scenarioE, ruben), fact(107), [], []).
step(linkedTo(gpRuben, ruben), fact(54), [], []).
step(subjectOptIn(scenarioF, true), rule(145), ['S' = scenarioF], [subject_opt_in(scenarioF)]).
step(subject_opt_in(scenarioF),
     rule(137),
     ['S' = scenarioF, 'Subject' = ruben, 'Purpose' = healthcareScientificResearch],
     [subject(scenarioF, ruben),
      purpose(scenarioF, healthcareScientificResearch),
      consentAllow(ruben, healthcareScientificResearch)]).
step(subject(scenarioF, ruben), fact(117), [], []).
step(purpose(scenarioF, healthcareScientificResearch), fact(118), [], []).
step(consentAllow(ruben, healthcareScientificResearch), fact(55), [], []).
step(subjectOptOut(scenarioG, true), rule(146), ['S' = scenarioG], [subject_opt_out(scenarioG)]).
step(subject_opt_out(scenarioG),
     rule(138),
     ['S' = scenarioG, 'Subject' = ruben, 'Purpose' = trainTestAndEvaluateAiSystemsAlgorithms],
     [subject(scenarioG, ruben),
      purpose(scenarioG, trainTestAndEvaluateAiSystemsAlgorithms),
      consentDeny(ruben, trainTestAndEvaluateAiSystemsAlgorithms)]).
step(subject(scenarioG, ruben), fact(129), [], []).
step(purpose(scenarioG, trainTestAndEvaluateAiSystemsAlgorithms), fact(130), [], []).
step(consentDeny(ruben, trainTestAndEvaluateAiSystemsAlgorithms), fact(56), [], []).
step(decision(scenarioA, "PERMIT"),
     rule(147),
     ['S' = scenarioA],
     [primary_policy_match(scenarioA)]).
step(primary_policy_match(scenarioA),
     rule(139),
     ['S' = scenarioA, 'Category' = patientSummary],
     [purpose(scenarioA, primaryCareManagement),
      requesterRole(scenarioA, "clinician"),
      care_team_linked(scenarioA),
      category(scenarioA, patientSummary),
      allowAnyCategory(policyPrimary, patientSummary)]).
step(purpose(scenarioA, primaryCareManagement), fact(67), [], []).
step(requesterRole(scenarioA, "clinician"), fact(65), [], []).
step(category(scenarioA, patientSummary), fact(69), [], []).
step(allowAnyCategory(policyPrimary, patientSummary), fact(32), [], []).
step(decision(scenarioE, "PERMIT"),
     rule(147),
     ['S' = scenarioE],
     [primary_policy_match(scenarioE)]).
step(primary_policy_match(scenarioE),
     rule(139),
     ['S' = scenarioE, 'Category' = labResults],
     [purpose(scenarioE, primaryCareManagement),
      requesterRole(scenarioE, "clinician"),
      care_team_linked(scenarioE),
      category(scenarioE, labResults),
      allowAnyCategory(policyPrimary, labResults)]).
step(purpose(scenarioE, primaryCareManagement), fact(108), [], []).
step(requesterRole(scenarioE, "clinician"), fact(106), [], []).
step(category(scenarioE, labResults), fact(110), [], []).
step(allowAnyCategory(policyPrimary, labResults), fact(33), [], []).
step(decision(scenarioB, "PERMIT"), rule(148), ['S' = scenarioB], [qi_policy_match(scenarioB)]).
step(qi_policy_match(scenarioB),
     rule(140),
     ['S' = scenarioB],
     [purpose(scenarioB, ensureQualitySafetyHealthcare),
      environment(scenarioB, "secure_env"),
      category(scenarioB, labResults),
      category(scenarioB, patientSummary)]).
step(purpose(scenarioB, ensureQualitySafetyHealthcare), fact(77), [], []).
step(environment(scenarioB, "secure_env"), fact(78), [], []).
step(category(scenarioB, labResults), fact(79), [], []).
step(category(scenarioB, patientSummary), fact(80), [], []).
step(decision(scenarioF, "PERMIT"),
     rule(149),
     ['S' = scenarioF],
     [research_policy_match(scenarioF)]).
step(research_policy_match(scenarioF),
     rule(141),
     ['S' = scenarioF],
     [purpose(scenarioF, healthcareScientificResearch),
      environment(scenarioF, "secure_env"),
      tom(scenarioF, anonymisation),
      subject_opt_in(scenarioF),
      category(scenarioF, labResults)]).
step(environment(scenarioF, "secure_env"), fact(119), [], []).
step(tom(scenarioF, anonymisation), fact(120), [], []).
step(category(scenarioF, labResults), fact(122), [], []).
step(decision(scenarioD, "DENY"),
     rule(150),
     ['S' = scenarioD],
     [insurance_prohibition_match(scenarioD)]).
step(insurance_prohibition_match(scenarioD),
     rule(142),
     ['S' = scenarioD],
     [purpose(scenarioD, insuranceManagement),
      prohibitPurpose(policyDenyInsurance, insuranceManagement)]).
step(purpose(scenarioD, insuranceManagement), fact(98), [], []).
step(prohibitPurpose(policyDenyInsurance, insuranceManagement), fact(52), [], []).
step(decision(scenarioG, "DENY"),
     rule(151),
     ['S' = scenarioG],
     [ai_training_opt_out_match(scenarioG)]).
step(ai_training_opt_out_match(scenarioG),
     rule(143),
     ['S' = scenarioG],
     [purpose(scenarioG, trainTestAndEvaluateAiSystemsAlgorithms), subject_opt_out(scenarioG)]).
step(decision(scenarioC, "DENY"),
     rule(152),
     [],
     [purpose(scenarioC, ensureQualitySafetyHealthcare)]).
step(purpose(scenarioC, ensureQualitySafetyHealthcare), fact(88), [], []).
step(matchedPolicyUid(scenarioA, "urn:policy:primary-care-001"),
     rule(153),
     ['S' = scenarioA, 'Uid' = "urn:policy:primary-care-001"],
     [primary_policy_match(scenarioA), policyUid(policyPrimary, "urn:policy:primary-care-001")]).
step(policyUid(policyPrimary, "urn:policy:primary-care-001"), fact(28), [], []).
step(matchedPolicyUid(scenarioE, "urn:policy:primary-care-001"),
     rule(153),
     ['S' = scenarioE, 'Uid' = "urn:policy:primary-care-001"],
     [primary_policy_match(scenarioE), policyUid(policyPrimary, "urn:policy:primary-care-001")]).
step(matchedPolicyUid(scenarioB, "urn:policy:qi-2025-aurora"),
     rule(154),
     ['S' = scenarioB, 'Uid' = "urn:policy:qi-2025-aurora"],
     [qi_policy_match(scenarioB), policyUid(policyQi, "urn:policy:qi-2025-aurora")]).
step(policyUid(policyQi, "urn:policy:qi-2025-aurora"), fact(34), [], []).
step(matchedPolicyUid(scenarioF, "urn:policy:research-aurora-diabetes"),
     rule(155),
     ['S' = scenarioF, 'Uid' = "urn:policy:research-aurora-diabetes"],
     [research_policy_match(scenarioF),
      policyUid(policyResearch, "urn:policy:research-aurora-diabetes")]).
step(policyUid(policyResearch, "urn:policy:research-aurora-diabetes"), fact(41), [], []).
step(matchedProhibition(scenarioD, policyDenyInsurance),
     rule(156),
     ['S' = scenarioD],
     [insurance_prohibition_match(scenarioD)]).
step(reason(scenarioA, "Permitted: clinician in the patient's care team, and the primary-care policy matched."),
     rule(157),
     ['S' = scenarioA],
     [primary_policy_match(scenarioA)]).
step(reason(scenarioE, "Permitted: clinician in the patient's care team, and the primary-care policy matched."),
     rule(157),
     ['S' = scenarioE],
     [primary_policy_match(scenarioE)]).
step(reason(scenarioB, "Permitted: ODRL/DPV policy matched for secondary use."),
     rule(158),
     ['S' = scenarioB],
     [qi_policy_match(scenarioB)]).
step(reason(scenarioF, "Permitted: subject opted in and an ODRL/DPV policy matched (anonymised dataset in secure environment)."),
     rule(159),
     ['S' = scenarioF],
     [research_policy_match(scenarioF)]).
step(reason(scenarioD, "Denied: the requested purpose (insurance management) is prohibited by policy."),
     rule(160),
     ['S' = scenarioD],
     [insurance_prohibition_match(scenarioD)]).
step(reason(scenarioG, "Denied: you opted out of your data being used to train AI systems."),
     rule(161),
     ['S' = scenarioG],
     [ai_training_opt_out_match(scenarioG)]).
step(reason(scenarioC, "Denied: no policy matched (purpose, environment, TOMs, or categories out of scope)."),
     rule(162),
     [],
     [purpose(scenarioC, ensureQualitySafetyHealthcare)]).
step(trace(scenarioA, "permit:primary_care_allowed"),
     rule(163),
     ['S' = scenarioA],
     [primary_policy_match(scenarioA)]).
step(trace(scenarioE, "permit:primary_care_allowed"),
     rule(163),
     ['S' = scenarioE],
     [primary_policy_match(scenarioE)]).
step(trace(scenarioA, "urn:policy:primary-care-001:permit:odrl:permission_matched"),
     rule(164),
     ['S' = scenarioA],
     [primary_policy_match(scenarioA)]).
step(trace(scenarioE, "urn:policy:primary-care-001:permit:odrl:permission_matched"),
     rule(164),
     ['S' = scenarioE],
     [primary_policy_match(scenarioE)]).
step(trace(scenarioB, "urn:policy:qi-2025-aurora:permit:odrl:permission_matched"),
     rule(165),
     ['S' = scenarioB],
     [qi_policy_match(scenarioB)]).
step(trace(scenarioF, "urn:policy:research-aurora-diabetes:permit:odrl:permission_matched"),
     rule(166),
     ['S' = scenarioF],
     [research_policy_match(scenarioF)]).
step(trace(scenarioD, "deny:prohibited_purpose"),
     rule(167),
     ['S' = scenarioD],
     [insurance_prohibition_match(scenarioD)]).
step(trace(scenarioD, "urn:policy:deny-insurance:deny:odrl:prohibition_matched"),
     rule(168),
     ['S' = scenarioD],
     [insurance_prohibition_match(scenarioD)]).
step(trace(scenarioG, "deny:subject_opted_out_ai_training"),
     rule(169),
     ['S' = scenarioG],
     [ai_training_opt_out_match(scenarioG)]).
step(trace(scenarioC, "urn:policy:qi-2025-aurora:deny:odrl:no_permission_matched"),
     rule(170),
     [],
     [purpose(scenarioC, ensureQualitySafetyHealthcare)]).
step(checkC1(scenarioA, "SKIPPED - not a prohibited purpose"),
     rule(171),
     [],
     [decision(scenarioA, "PERMIT")]).
step(checkC1(scenarioB, "SKIPPED - not a prohibited purpose"),
     rule(181),
     [],
     [decision(scenarioB, "PERMIT")]).
step(checkC1(scenarioC, "SKIPPED - not a prohibited purpose"),
     rule(191),
     [],
     [decision(scenarioC, "DENY")]).
step(checkC1(scenarioD, "OK - denied prohibited purpose"),
     rule(201),
     [],
     [decision(scenarioD, "DENY")]).
step(checkC1(scenarioE, "SKIPPED - not a prohibited purpose"),
     rule(211),
     [],
     [decision(scenarioE, "PERMIT")]).
step(checkC1(scenarioF, "SKIPPED - not a prohibited purpose"),
     rule(221),
     [],
     [decision(scenarioF, "PERMIT")]).
step(checkC1(scenarioG, "SKIPPED - not a prohibited purpose"),
     rule(231),
     [],
     [decision(scenarioG, "DENY")]).
step(checkC2(scenarioA, "OK - clinician"), rule(172), [], [decision(scenarioA, "PERMIT")]).
step(checkC2(scenarioB, "SKIPPED"), rule(182), [], [decision(scenarioB, "PERMIT")]).
step(checkC2(scenarioC, "SKIPPED"), rule(192), [], [decision(scenarioC, "DENY")]).
step(checkC2(scenarioD, "SKIPPED"), rule(202), [], [decision(scenarioD, "DENY")]).
step(checkC2(scenarioE, "OK - clinician"), rule(212), [], [decision(scenarioE, "PERMIT")]).
step(checkC2(scenarioF, "SKIPPED"), rule(222), [], [decision(scenarioF, "PERMIT")]).
step(checkC2(scenarioG, "SKIPPED"), rule(232), [], [decision(scenarioG, "DENY")]).
step(checkC3(scenarioA, "OK - care-team linked"),
     rule(173),
     [],
     [decision(scenarioA, "PERMIT")]).
step(checkC3(scenarioB, "SKIPPED"), rule(183), [], [decision(scenarioB, "PERMIT")]).
step(checkC3(scenarioC, "SKIPPED"), rule(193), [], [decision(scenarioC, "DENY")]).
step(checkC3(scenarioD, "SKIPPED"), rule(203), [], [decision(scenarioD, "DENY")]).
step(checkC3(scenarioE, "OK - care-team linked"),
     rule(213),
     [],
     [decision(scenarioE, "PERMIT")]).
step(checkC3(scenarioF, "SKIPPED"), rule(223), [], [decision(scenarioF, "PERMIT")]).
step(checkC3(scenarioG, "SKIPPED"), rule(233), [], [decision(scenarioG, "DENY")]).
step(checkC4(scenarioA, "SKIPPED"), rule(174), [], [decision(scenarioA, "PERMIT")]).
step(checkC4(scenarioB, "OK - opt-in present and policy matched"),
     rule(184),
     [],
     [decision(scenarioB, "PERMIT")]).
step(checkC4(scenarioC, "OK - denied because opt-in missing or no policy match"),
     rule(194),
     [],
     [decision(scenarioC, "DENY")]).
step(checkC4(scenarioD, "SKIPPED"), rule(204), [], [decision(scenarioD, "DENY")]).
step(checkC4(scenarioE, "SKIPPED"), rule(214), [], [decision(scenarioE, "PERMIT")]).
step(checkC4(scenarioF, "OK - opt-in present and policy matched"),
     rule(224),
     [],
     [decision(scenarioF, "PERMIT")]).
step(checkC4(scenarioG, "OK - denied because opt-in missing or no policy match"),
     rule(234),
     [],
     [decision(scenarioG, "DENY")]).
step(checkC5(scenarioA, "OK - operator=isAnyOf, allowed=[\"https://example.org/health#PATIENT_SUMMARY\", \"https://example.org/health#LAB_RESULTS\"], requested=[\"https://example.org/health#PATIENT_SUMMARY\"]"),
     rule(175),
     [],
     [decision(scenarioA, "PERMIT")]).
step(checkC5(scenarioB, "OK - operator=isAllOf, allowed=[\"https://example.org/health#LAB_RESULTS\", \"https://example.org/health#PATIENT_SUMMARY\"], requested=[\"https://example.org/health#LAB_RESULTS\", \"https://example.org/health#PATIENT_SUMMARY\"]"),
     rule(185),
     [],
     [decision(scenarioB, "PERMIT")]).
step(checkC5(scenarioC, "SKIPPED"), rule(195), [], [decision(scenarioC, "DENY")]).
step(checkC5(scenarioD, "SKIPPED"), rule(205), [], [decision(scenarioD, "DENY")]).
step(checkC5(scenarioE, "OK - operator=isAnyOf, allowed=[\"https://example.org/health#PATIENT_SUMMARY\", \"https://example.org/health#LAB_RESULTS\"], requested=[\"https://example.org/health#LAB_RESULTS\"]"),
     rule(215),
     [],
     [decision(scenarioE, "PERMIT")]).
step(checkC5(scenarioF, "OK - operator=isAnyOf, allowed=[\"https://example.org/health#LAB_RESULTS\", \"https://example.org/health#PATIENT_SUMMARY\", \"https://example.org/health#IMAGING_REPORT\"], requested=[\"https://example.org/health#PATIENT_SUMMARY\", \"https://example.org/health#LAB_RESULTS\"]"),
     rule(225),
     [],
     [decision(scenarioF, "PERMIT")]).
step(checkC5(scenarioG, "SKIPPED"), rule(235), [], [decision(scenarioG, "DENY")]).
step(checkC6(scenarioA, "SKIPPED - no prohibition matched"),
     rule(176),
     [],
     [decision(scenarioA, "PERMIT")]).
step(checkC6(scenarioB, "SKIPPED - no prohibition matched"),
     rule(186),
     [],
     [decision(scenarioB, "PERMIT")]).
step(checkC6(scenarioC, "SKIPPED - no prohibition matched"),
     rule(196),
     [],
     [decision(scenarioC, "DENY")]).
step(checkC6(scenarioD, "OK - denied due to prohibition"),
     rule(206),
     [],
     [decision(scenarioD, "DENY")]).
step(checkC6(scenarioE, "SKIPPED - no prohibition matched"),
     rule(216),
     [],
     [decision(scenarioE, "PERMIT")]).
step(checkC6(scenarioF, "SKIPPED - no prohibition matched"),
     rule(226),
     [],
     [decision(scenarioF, "PERMIT")]).
step(checkC6(scenarioG, "SKIPPED - no prohibition matched"),
     rule(236),
     [],
     [decision(scenarioG, "DENY")]).
step(checkC7(scenarioA, "OK - trace shows matching permission"),
     rule(177),
     [],
     [decision(scenarioA, "PERMIT")]).
step(checkC7(scenarioB, "OK - trace shows matching permission"),
     rule(187),
     [],
     [decision(scenarioB, "PERMIT")]).
step(checkC7(scenarioC, "SKIPPED"), rule(197), [], [decision(scenarioC, "DENY")]).
step(checkC7(scenarioD, "SKIPPED"), rule(207), [], [decision(scenarioD, "DENY")]).
step(checkC7(scenarioE, "OK - trace shows matching permission"),
     rule(217),
     [],
     [decision(scenarioE, "PERMIT")]).
step(checkC7(scenarioF, "OK - trace shows matching permission"),
     rule(227),
     [],
     [decision(scenarioF, "PERMIT")]).
step(checkC7(scenarioG, "SKIPPED"), rule(237), [], [decision(scenarioG, "DENY")]).
step(checkC8(scenarioA, "SKIPPED - no matched policy or no duties"),
     rule(178),
     [],
     [decision(scenarioA, "PERMIT")]).
step(checkC8(scenarioB, "INFO - duties attached: duty:https://w3id.org/dpv/legal/eu/ehds#requireConsent, duty:https://w3id.org/dpv/legal/eu/ehds#noExfiltration"),
     rule(188),
     [],
     [decision(scenarioB, "PERMIT")]).
step(checkC8(scenarioC, "SKIPPED - no matched policy or no duties"),
     rule(198),
     [],
     [decision(scenarioC, "DENY")]).
step(checkC8(scenarioD, "SKIPPED - no matched policy or no duties"),
     rule(208),
     [],
     [decision(scenarioD, "DENY")]).
step(checkC8(scenarioE, "SKIPPED - no matched policy or no duties"),
     rule(218),
     [],
     [decision(scenarioE, "PERMIT")]).
step(checkC8(scenarioF, "INFO - duties attached: duty:https://w3id.org/dpv/legal/eu/ehds#annualOutcomeReport, duty:https://w3id.org/dpv/legal/eu/ehds#noReidentification, duty:https://w3id.org/dpv/legal/eu/ehds#noExfiltration"),
     rule(228),
     [],
     [decision(scenarioF, "PERMIT")]).
step(checkC8(scenarioG, "SKIPPED - no matched policy or no duties"),
     rule(238),
     [],
     [decision(scenarioG, "DENY")]).
step(checkC9(scenarioA, "SKIPPED - policy has no environment constraint"),
     rule(179),
     [],
     [decision(scenarioA, "PERMIT")]).
step(checkC9(scenarioB, "OK - operator=eq, allowed=\"secure_env\", requested=\"secure_env\""),
     rule(189),
     [],
     [decision(scenarioB, "PERMIT")]).
step(checkC9(scenarioC, "SKIPPED"), rule(199), [], [decision(scenarioC, "DENY")]).
step(checkC9(scenarioD, "SKIPPED"), rule(209), [], [decision(scenarioD, "DENY")]).
step(checkC9(scenarioE, "SKIPPED - policy has no environment constraint"),
     rule(219),
     [],
     [decision(scenarioE, "PERMIT")]).
step(checkC9(scenarioF, "OK - operator=eq, allowed=\"secure_env\", requested=\"secure_env\""),
     rule(229),
     [],
     [decision(scenarioF, "PERMIT")]).
step(checkC9(scenarioG, "SKIPPED"), rule(239), [], [decision(scenarioG, "DENY")]).
step(checkC10Text(scenarioA, "INFO - matched policy: urn:policy:primary-care-001"),
     rule(180),
     [],
     [decision(scenarioA, "PERMIT")]).
step(checkC10Text(scenarioB, "INFO - matched policy: urn:policy:qi-2025-aurora"),
     rule(190),
     [],
     [decision(scenarioB, "PERMIT")]).
step(checkC10Text(scenarioC, "SKIPPED - no matched policy"),
     rule(200),
     [],
     [decision(scenarioC, "DENY")]).
step(checkC10Text(scenarioD, "SKIPPED - no matched policy"),
     rule(210),
     [],
     [decision(scenarioD, "DENY")]).
step(checkC10Text(scenarioE, "INFO - matched policy: urn:policy:primary-care-001"),
     rule(220),
     [],
     [decision(scenarioE, "PERMIT")]).
step(checkC10Text(scenarioF, "INFO - matched policy: urn:policy:research-aurora-diabetes"),
     rule(230),
     [],
     [decision(scenarioF, "PERMIT")]).
step(checkC10Text(scenarioG, "SKIPPED - no matched policy"),
     rule(240),
     [],
     [decision(scenarioG, "DENY")]).
