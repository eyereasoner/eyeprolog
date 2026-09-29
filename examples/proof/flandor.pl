caseName(case, "flandor").
regionName(flanders, "Flanders").
metric(macroInsight, "regional_retooling_priority").
alg(signature, "HMAC-SHA256").
payloadHashSHA256(signature, "718f5b17d07ab6a95503bc04a1000ddb132409f600659c03d21def81914b780b").
signatureHMAC(signature, "955968ca99a191783bc00cba068128ccb9ff40a5e6114fda13a52c74ee27329e").
auditEntries(case, 1).
filesWritten(case, 6).
exportWeakness(case, true).
skillsStrain(case, true).
gridStress(case, true).
needsRetoolingPulse(case, true).
derivedFromNeed(case, "regional_retooling_and_flexibility").
activeNeedCount(answer, 3).
activeNeedThreshold(answer, 3).
recommendedPackageName(answer, "Flandor Retooling Pulse").
budgetCapMEUR(answer, 140).
packageCostMEUR(answer, 120).
envelopeExpiresAt(answer, "2026-04-08T19:00:00+00:00").
workerCoverage(why, 1200).
gridReliefMW(why, 85).
outcome(decision, "Allowed").
target(decision, macroInsight).
allChecksPass(result, true).
signatureVerifies(check, true).
payloadHashMatches(check, true).
hmacMatches(check, true).
minimizationStripsSensitiveTerms(check, true).
scopeComplete(check, true).
authorizationAllowed(check, true).
thresholdReached(check, true).
packageWithinBudget(check, true).
packageCoversAllNeeds(check, true).
dutyTimingConsistent(check, true).
surveillanceReuseProhibited(check, true).
filesWrittenExpected(check, true).
lowestCostEligiblePackageChosen(check, true).
reason(whyExportWeakness, "Export weakness is active because at least one cluster has exportOrdersIndex < 90 (Antwerp chemicals=84, Ghent manufacturing=87).").
reason(whySkillsStrain, "Skills strain is active because technical vacancy rate is 4.6% (threshold > 3.9%).").
reason(whyGridStress, "Grid stress is active because congestion hours = 19 (threshold > 11).").
reason(whyRecommendationPolicy, "The recommendation policy is \"lowest_cost_package_covering_all_active_needs\", so the cheapest package that covers all active needs within budget is selected.").
reason(whySelectedPackage, "Selected package \"Flandor Retooling Pulse\" covers export=true, skills=true, grid=true, cost=€120M.").
reason(whyUsage, "Usage is permitted only for purpose \"regional_stabilization\" and the envelope expires at 2026-04-08T19:00:00+00:00.").

clause(14, case_name(case, "flandor"), true).
clause(21, boardAuthAt(case, "2026-04-08T09:15:00+00:00"), true).
clause(22, boardDutyAt(case, "2026-04-08T18:30:00+00:00"), true).
clause(23, files_written(case, 6), true).
clause(24, audit_entries(case, 1), true).
clause(25, region_name(flanders, "Flanders"), true).
clause(30, industrialCluster(clusterAntwerp), true).
clause(32, exportOrdersIndex(clusterAntwerp, 84), true).
clause(38, techVacancyRateTenths(labourMarket, 46), true).
clause(40, congestionHours(grid, 19), true).
clause(42, maxMEUR(budget, 140), true).
clause(58, policyPackage(pkgFlandor), true).
clause(60, packageName(pkgFlandor, "Flandor Retooling Pulse"), true).
clause(61, costMEUR(pkgFlandor, 120), true).
clause(62, worker_coverage(pkgFlandor, 1200), true).
clause(63, grid_relief_mw(pkgFlandor, 85), true).
clause(64, coversExportWeakness(pkgFlandor, true), true).
clause(65, coversSkillsStrain(pkgFlandor, true), true).
clause(66, coversGridStress(pkgFlandor, true), true).
clause(78, insight_metric(macroInsight, "regional_retooling_priority"), true).
clause(79, thresholdScore(macroInsight, 3), true).
clause(82, scopeDevice(macroInsight, "economic-resilience-board"), true).
clause(83, scopeEvent(macroInsight, "budget-prep-window"), true).
clause(86, expiresAt(macroInsight, "2026-04-08T19:00:00+00:00"), true).
clause(87,
       serializedLowercase(macroInsight, 'createdat expiresat insight metric regional_retooling_priority region flanders scopedevice economic-resilience-board scopeevent budget-prep-window suggestionpolicy lowest_cost_package_covering_all_active_needs threshold 3'),
       true).
clause(90,
       envelopeHash(envelope, "10a85e861075bef2a96c01c7f3238735f82b8f368deb62eafcedd1c4b7f7c707"),
       true).
clause(91, permission(policy, odrlUse, macroInsight, "regional_stabilization"), true).
clause(92, prohibition(policy, odrlDistribute, macroInsight, "firm_surveillance"), true).
clause(94, signature_alg(signature, "HMAC-SHA256"), true).
clause(97,
       payload_hash_sha256(signature, "10a85e861075bef2a96c01c7f3238735f82b8f368deb62eafcedd1c4b7f7c707"),
       true).
clause(98,
       display_payload_hash_sha256(signature, "718f5b17d07ab6a95503bc04a1000ddb132409f600659c03d21def81914b780b"),
       true).
clause(99,
       signature_hmac(signature, "955968ca99a191783bc00cba068128ccb9ff40a5e6114fda13a52c74ee27329e"),
       true).
clause(100, hmacVerificationMode(signature, trustedPrecomputedInput), true).
clause(102, caseName(var('Case'), var('Name')), case_name(var('Case'), var('Name'))).
clause(103, regionName(var('Region'), var('Name')), region_name(var('Region'), var('Name'))).
clause(104,
       metric(var('Insight'), var('Metric')),
       insight_metric(var('Insight'), var('Metric'))).
clause(105, alg(var('Signature'), var('Alg')), signature_alg(var('Signature'), var('Alg'))).
clause(106,
       payloadHashSHA256(var('Signature'), var('Hash')),
       display_payload_hash_sha256(var('Signature'), var('Hash'))).
clause(107,
       signatureHMAC(var('Signature'), var('Hmac')),
       signature_hmac(var('Signature'), var('Hmac'))).
clause(108, auditEntries(var('Case'), var('Count')), audit_entries(var('Case'), var('Count'))).
clause(109, filesWritten(var('Case'), var('Count')), files_written(var('Case'), var('Count'))).
clause(110,
       export_weakness(case),
       (industrialCluster(var('Cluster')),
        exportOrdersIndex(var('Cluster'), var('Index')),
        var('Index') < 90)).
clause(111,
       skills_strain(case),
       (techVacancyRateTenths(labourMarket, var('Rate')), var('Rate') > 39)).
clause(112, grid_stress(case), (congestionHours(grid, var('Hours')), var('Hours') > 11)).
clause(113,
       needs_retooling_pulse(case),
       (export_weakness(case), skills_strain(case), grid_stress(case))).
clause(114,
       payload_hash_matches(check),
       (envelopeHash(envelope, var('Digest')), payload_hash_sha256(signature, var('Digest')))).
clause(115, signature_verifies(check), hmacVerificationMode(signature, trustedPrecomputedInput)).
clause(116,
       hmac_matches(check),
       (hmacVerificationMode(signature, trustedPrecomputedInput),
        signature_hmac(signature, "955968ca99a191783bc00cba068128ccb9ff40a5e6114fda13a52c74ee27329e"))).
clause(117,
       minimization_strips_sensitive_terms(check),
       (serializedLowercase(macroInsight, var('Text')),
        \+ matches(var('Text'), 'salary|payroll|invoice|medical|firmname'))).
clause(118,
       scope_complete(check),
       (scopeDevice(macroInsight, anonymous(1)),
        scopeEvent(macroInsight, anonymous(2)),
        expiresAt(macroInsight, anonymous(3)))).
clause(119,
       authorization_allowed(check),
       (permission(policy, odrlUse, macroInsight, "regional_stabilization"),
        boardAuthAt(case, var('Authat')),
        expiresAt(macroInsight, var('Expiresat')),
        var('Authat') @=< var('Expiresat'))).
clause(120, decision(decision, "Allowed", macroInsight), authorization_allowed(check)).
clause(121,
       eligible_package(var('Pkg')),
       (needs_retooling_pulse(case),
        maxMEUR(budget, var('Max')),
        policyPackage(var('Pkg')),
        costMEUR(var('Pkg'), var('Cost')),
        coversExportWeakness(var('Pkg'), true),
        coversSkillsStrain(var('Pkg'), true),
        coversGridStress(var('Pkg'), true),
        var('Cost') =< var('Max'))).
clause(123,
       recommended_package(case, var('Pkg')),
       (eligible_package(var('Pkg')),
        costMEUR(var('Pkg'), var('Cost')),
        \+ lower_cost_eligible_package(var('Cost')))).
clause(124,
       package_within_budget(check),
       (recommended_package(case, var('Pkg')),
        costMEUR(var('Pkg'), var('Cost')),
        maxMEUR(budget, var('Max')),
        var('Cost') =< var('Max'))).
clause(125,
       package_covers_all_needs(check),
       (recommended_package(case, var('Pkg')),
        coversExportWeakness(var('Pkg'), true),
        coversSkillsStrain(var('Pkg'), true),
        coversGridStress(var('Pkg'), true))).
clause(126,
       duty_timing_consistent(check),
       (boardDutyAt(case, var('Dutyat')),
        expiresAt(macroInsight, var('Expiresat')),
        var('Dutyat') @=< var('Expiresat'))).
clause(127,
       surveillance_reuse_prohibited(check),
       prohibition(policy, odrlDistribute, macroInsight, "firm_surveillance")).
clause(128, files_written_expected(check), files_written(case, 6)).
clause(129,
       threshold_reached(check),
       (export_weakness(case), skills_strain(case), grid_stress(case))).
clause(130, lowest_cost_eligible_package_chosen(check), recommended_package(case, anonymous(1))).
clause(131,
       all_checks_pass(result),
       (signature_verifies(check),
        payload_hash_matches(check),
        minimization_strips_sensitive_terms(check),
        scope_complete(check),
        authorization_allowed(check),
        package_within_budget(check),
        package_covers_all_needs(check),
        duty_timing_consistent(check),
        surveillance_reuse_prohibited(check),
        files_written_expected(check))).
clause(132, exportWeakness(case, true), export_weakness(case)).
clause(133, skillsStrain(case, true), skills_strain(case)).
clause(134, gridStress(case, true), grid_stress(case)).
clause(135, needsRetoolingPulse(case, true), needs_retooling_pulse(case)).
clause(136,
       derivedFromNeed(case, "regional_retooling_and_flexibility"),
       needs_retooling_pulse(case)).
clause(137, activeNeedCount(answer, 3), threshold_reached(check)).
clause(138, activeNeedThreshold(answer, 3), thresholdScore(macroInsight, 3)).
clause(139,
       recommendedPackageName(answer, var('Name')),
       (recommended_package(case, var('Pkg')), packageName(var('Pkg'), var('Name')))).
clause(140, budgetCapMEUR(answer, var('Max')), maxMEUR(budget, var('Max'))).
clause(141,
       packageCostMEUR(answer, var('Cost')),
       (recommended_package(case, var('Pkg')), costMEUR(var('Pkg'), var('Cost')))).
clause(142, envelopeExpiresAt(answer, var('Time')), expiresAt(macroInsight, var('Time'))).
clause(143,
       workerCoverage(why, var('Workers')),
       (recommended_package(case, var('Pkg')), worker_coverage(var('Pkg'), var('Workers')))).
clause(144,
       gridReliefMW(why, var('Mw')),
       (recommended_package(case, var('Pkg')), grid_relief_mw(var('Pkg'), var('Mw')))).
clause(145, outcome(decision, var('Outcome')), decision(decision, var('Outcome'), anonymous(1))).
clause(146, target(decision, var('Target')), decision(decision, anonymous(1), var('Target'))).
clause(147, allChecksPass(result, true), all_checks_pass(result)).
clause(148, signatureVerifies(check, true), signature_verifies(check)).
clause(149, payloadHashMatches(check, true), payload_hash_matches(check)).
clause(150, hmacMatches(check, true), hmac_matches(check)).
clause(151,
       minimizationStripsSensitiveTerms(check, true),
       minimization_strips_sensitive_terms(check)).
clause(152, scopeComplete(check, true), scope_complete(check)).
clause(153, authorizationAllowed(check, true), authorization_allowed(check)).
clause(154, thresholdReached(check, true), threshold_reached(check)).
clause(155, packageWithinBudget(check, true), package_within_budget(check)).
clause(156, packageCoversAllNeeds(check, true), package_covers_all_needs(check)).
clause(157, dutyTimingConsistent(check, true), duty_timing_consistent(check)).
clause(158, surveillanceReuseProhibited(check, true), surveillance_reuse_prohibited(check)).
clause(159, filesWrittenExpected(check, true), files_written_expected(check)).
clause(160,
       lowestCostEligiblePackageChosen(check, true),
       lowest_cost_eligible_package_chosen(check)).
clause(161,
       reason(whyExportWeakness, "Export weakness is active because at least one cluster has exportOrdersIndex < 90 (Antwerp chemicals=84, Ghent manufacturing=87)."),
       export_weakness(case)).
clause(162,
       reason(whySkillsStrain, "Skills strain is active because technical vacancy rate is 4.6% (threshold > 3.9%)."),
       skills_strain(case)).
clause(163,
       reason(whyGridStress, "Grid stress is active because congestion hours = 19 (threshold > 11)."),
       grid_stress(case)).
clause(164,
       reason(whyRecommendationPolicy, "The recommendation policy is \"lowest_cost_package_covering_all_active_needs\", so the cheapest package that covers all active needs within budget is selected."),
       recommended_package(case, anonymous(1))).
clause(165,
       reason(whySelectedPackage, "Selected package \"Flandor Retooling Pulse\" covers export=true, skills=true, grid=true, cost=€120M."),
       recommended_package(case, pkgFlandor)).
clause(166,
       reason(whyUsage, "Usage is permitted only for purpose \"regional_stabilization\" and the envelope expires at 2026-04-08T19:00:00+00:00."),
       authorization_allowed(check)).

step(caseName(case, "flandor"),
     rule(102),
     ['Case' = case, 'Name' = "flandor"],
     [case_name(case, "flandor")]).
step(case_name(case, "flandor"), fact(14), [], []).
step(regionName(flanders, "Flanders"),
     rule(103),
     ['Region' = flanders, 'Name' = "Flanders"],
     [region_name(flanders, "Flanders")]).
step(region_name(flanders, "Flanders"), fact(25), [], []).
step(metric(macroInsight, "regional_retooling_priority"),
     rule(104),
     ['Insight' = macroInsight, 'Metric' = "regional_retooling_priority"],
     [insight_metric(macroInsight, "regional_retooling_priority")]).
step(insight_metric(macroInsight, "regional_retooling_priority"), fact(78), [], []).
step(alg(signature, "HMAC-SHA256"),
     rule(105),
     ['Signature' = signature, 'Alg' = "HMAC-SHA256"],
     [signature_alg(signature, "HMAC-SHA256")]).
step(signature_alg(signature, "HMAC-SHA256"), fact(94), [], []).
step(payloadHashSHA256(signature, "718f5b17d07ab6a95503bc04a1000ddb132409f600659c03d21def81914b780b"),
     rule(106),
     ['Signature' = signature,
      'Hash' = "718f5b17d07ab6a95503bc04a1000ddb132409f600659c03d21def81914b780b"],
     [display_payload_hash_sha256(signature, "718f5b17d07ab6a95503bc04a1000ddb132409f600659c03d21def81914b780b")]).
step(display_payload_hash_sha256(signature, "718f5b17d07ab6a95503bc04a1000ddb132409f600659c03d21def81914b780b"),
     fact(98),
     [],
     []).
step(signatureHMAC(signature, "955968ca99a191783bc00cba068128ccb9ff40a5e6114fda13a52c74ee27329e"),
     rule(107),
     ['Signature' = signature,
      'Hmac' = "955968ca99a191783bc00cba068128ccb9ff40a5e6114fda13a52c74ee27329e"],
     [signature_hmac(signature, "955968ca99a191783bc00cba068128ccb9ff40a5e6114fda13a52c74ee27329e")]).
step(signature_hmac(signature, "955968ca99a191783bc00cba068128ccb9ff40a5e6114fda13a52c74ee27329e"),
     fact(99),
     [],
     []).
step(auditEntries(case, 1), rule(108), ['Case' = case, 'Count' = 1], [audit_entries(case, 1)]).
step(audit_entries(case, 1), fact(24), [], []).
step(filesWritten(case, 6), rule(109), ['Case' = case, 'Count' = 6], [files_written(case, 6)]).
step(files_written(case, 6), fact(23), [], []).
step(exportWeakness(case, true), rule(132), [], [export_weakness(case)]).
step(export_weakness(case),
     rule(110),
     ['Cluster' = clusterAntwerp, 'Index' = 84],
     [industrialCluster(clusterAntwerp), exportOrdersIndex(clusterAntwerp, 84), 84 < 90]).
step(industrialCluster(clusterAntwerp), fact(30), [], []).
step(exportOrdersIndex(clusterAntwerp, 84), fact(32), [], []).
step(84 < 90, builtin, [], []).
step(skillsStrain(case, true), rule(133), [], [skills_strain(case)]).
step(skills_strain(case),
     rule(111),
     ['Rate' = 46],
     [techVacancyRateTenths(labourMarket, 46), 46 > 39]).
step(techVacancyRateTenths(labourMarket, 46), fact(38), [], []).
step(46 > 39, builtin, [], []).
step(gridStress(case, true), rule(134), [], [grid_stress(case)]).
step(grid_stress(case), rule(112), ['Hours' = 19], [congestionHours(grid, 19), 19 > 11]).
step(congestionHours(grid, 19), fact(40), [], []).
step(19 > 11, builtin, [], []).
step(needsRetoolingPulse(case, true), rule(135), [], [needs_retooling_pulse(case)]).
step(needs_retooling_pulse(case),
     rule(113),
     [],
     [export_weakness(case), skills_strain(case), grid_stress(case)]).
step(derivedFromNeed(case, "regional_retooling_and_flexibility"),
     rule(136),
     [],
     [needs_retooling_pulse(case)]).
step(activeNeedCount(answer, 3), rule(137), [], [threshold_reached(check)]).
step(threshold_reached(check),
     rule(129),
     [],
     [export_weakness(case), skills_strain(case), grid_stress(case)]).
step(activeNeedThreshold(answer, 3), rule(138), [], [thresholdScore(macroInsight, 3)]).
step(thresholdScore(macroInsight, 3), fact(79), [], []).
step(recommendedPackageName(answer, "Flandor Retooling Pulse"),
     rule(139),
     ['Name' = "Flandor Retooling Pulse", 'Pkg' = pkgFlandor],
     [recommended_package(case, pkgFlandor), packageName(pkgFlandor, "Flandor Retooling Pulse")]).
step(recommended_package(case, pkgFlandor),
     rule(123),
     ['Pkg' = pkgFlandor, 'Cost' = 120],
     [eligible_package(pkgFlandor),
      costMEUR(pkgFlandor, 120),
      \+ lower_cost_eligible_package(120)]).
step(eligible_package(pkgFlandor),
     rule(121),
     ['Pkg' = pkgFlandor, 'Max' = 140, 'Cost' = 120],
     [needs_retooling_pulse(case),
      maxMEUR(budget, 140),
      policyPackage(pkgFlandor),
      costMEUR(pkgFlandor, 120),
      coversExportWeakness(pkgFlandor, true),
      coversSkillsStrain(pkgFlandor, true),
      coversGridStress(pkgFlandor, true),
      120 =< 140]).
step(maxMEUR(budget, 140), fact(42), [], []).
step(policyPackage(pkgFlandor), fact(58), [], []).
step(costMEUR(pkgFlandor, 120), fact(61), [], []).
step(coversExportWeakness(pkgFlandor, true), fact(64), [], []).
step(coversSkillsStrain(pkgFlandor, true), fact(65), [], []).
step(coversGridStress(pkgFlandor, true), fact(66), [], []).
step(120 =< 140, builtin, [], []).
step(\+ lower_cost_eligible_package(120), absent, [], []).
step(packageName(pkgFlandor, "Flandor Retooling Pulse"), fact(60), [], []).
step(budgetCapMEUR(answer, 140), rule(140), ['Max' = 140], [maxMEUR(budget, 140)]).
step(packageCostMEUR(answer, 120),
     rule(141),
     ['Cost' = 120, 'Pkg' = pkgFlandor],
     [recommended_package(case, pkgFlandor), costMEUR(pkgFlandor, 120)]).
step(envelopeExpiresAt(answer, "2026-04-08T19:00:00+00:00"),
     rule(142),
     ['Time' = "2026-04-08T19:00:00+00:00"],
     [expiresAt(macroInsight, "2026-04-08T19:00:00+00:00")]).
step(expiresAt(macroInsight, "2026-04-08T19:00:00+00:00"), fact(86), [], []).
step(workerCoverage(why, 1200),
     rule(143),
     ['Workers' = 1200, 'Pkg' = pkgFlandor],
     [recommended_package(case, pkgFlandor), worker_coverage(pkgFlandor, 1200)]).
step(worker_coverage(pkgFlandor, 1200), fact(62), [], []).
step(gridReliefMW(why, 85),
     rule(144),
     ['Mw' = 85, 'Pkg' = pkgFlandor],
     [recommended_package(case, pkgFlandor), grid_relief_mw(pkgFlandor, 85)]).
step(grid_relief_mw(pkgFlandor, 85), fact(63), [], []).
step(outcome(decision, "Allowed"),
     rule(145),
     ['Outcome' = "Allowed"],
     [decision(decision, "Allowed", macroInsight)]).
step(decision(decision, "Allowed", macroInsight), rule(120), [], [authorization_allowed(check)]).
step(authorization_allowed(check),
     rule(119),
     ['Authat' = "2026-04-08T09:15:00+00:00", 'Expiresat' = "2026-04-08T19:00:00+00:00"],
     [permission(policy, odrlUse, macroInsight, "regional_stabilization"),
      boardAuthAt(case, "2026-04-08T09:15:00+00:00"),
      expiresAt(macroInsight, "2026-04-08T19:00:00+00:00"),
      "2026-04-08T09:15:00+00:00" @=< "2026-04-08T19:00:00+00:00"]).
step(permission(policy, odrlUse, macroInsight, "regional_stabilization"), fact(91), [], []).
step(boardAuthAt(case, "2026-04-08T09:15:00+00:00"), fact(21), [], []).
step("2026-04-08T09:15:00+00:00" @=< "2026-04-08T19:00:00+00:00", builtin, [], []).
step(target(decision, macroInsight),
     rule(146),
     ['Target' = macroInsight],
     [decision(decision, "Allowed", macroInsight)]).
step(allChecksPass(result, true), rule(147), [], [all_checks_pass(result)]).
step(all_checks_pass(result),
     rule(131),
     [],
     [signature_verifies(check),
      payload_hash_matches(check),
      minimization_strips_sensitive_terms(check),
      scope_complete(check),
      authorization_allowed(check),
      package_within_budget(check),
      package_covers_all_needs(check),
      duty_timing_consistent(check),
      surveillance_reuse_prohibited(check),
      files_written_expected(check)]).
step(signature_verifies(check),
     rule(115),
     [],
     [hmacVerificationMode(signature, trustedPrecomputedInput)]).
step(hmacVerificationMode(signature, trustedPrecomputedInput), fact(100), [], []).
step(payload_hash_matches(check),
     rule(114),
     ['Digest' = "10a85e861075bef2a96c01c7f3238735f82b8f368deb62eafcedd1c4b7f7c707"],
     [envelopeHash(envelope, "10a85e861075bef2a96c01c7f3238735f82b8f368deb62eafcedd1c4b7f7c707"),
      payload_hash_sha256(signature, "10a85e861075bef2a96c01c7f3238735f82b8f368deb62eafcedd1c4b7f7c707")]).
step(envelopeHash(envelope, "10a85e861075bef2a96c01c7f3238735f82b8f368deb62eafcedd1c4b7f7c707"),
     fact(90),
     [],
     []).
step(payload_hash_sha256(signature, "10a85e861075bef2a96c01c7f3238735f82b8f368deb62eafcedd1c4b7f7c707"),
     fact(97),
     [],
     []).
step(minimization_strips_sensitive_terms(check),
     rule(117),
     ['Text' = 'createdat expiresat insight metric regional_retooling_priority region flanders scopedevice economic-resilience-board scopeevent budget-prep-window suggestionpolicy lowest_cost_package_covering_all_active_needs threshold 3'],
     [serializedLowercase(macroInsight, 'createdat expiresat insight metric regional_retooling_priority region flanders scopedevice economic-resilience-board scopeevent budget-prep-window suggestionpolicy lowest_cost_package_covering_all_active_needs threshold 3'),
      \+ matches('createdat expiresat insight metric regional_retooling_priority region flanders scopedevice economic-resilience-board scopeevent budget-prep-window suggestionpolicy lowest_cost_package_covering_all_active_needs threshold 3', 'salary|payroll|invoice|medical|firmname')]).
step(serializedLowercase(macroInsight, 'createdat expiresat insight metric regional_retooling_priority region flanders scopedevice economic-resilience-board scopeevent budget-prep-window suggestionpolicy lowest_cost_package_covering_all_active_needs threshold 3'),
     fact(87),
     [],
     []).
step(\+ matches('createdat expiresat insight metric regional_retooling_priority region flanders scopedevice economic-resilience-board scopeevent budget-prep-window suggestionpolicy lowest_cost_package_covering_all_active_needs threshold 3', 'salary|payroll|invoice|medical|firmname'),
     absent,
     [],
     []).
step(scope_complete(check),
     rule(118),
     [],
     [scopeDevice(macroInsight, "economic-resilience-board"),
      scopeEvent(macroInsight, "budget-prep-window"),
      expiresAt(macroInsight, "2026-04-08T19:00:00+00:00")]).
step(scopeDevice(macroInsight, "economic-resilience-board"), fact(82), [], []).
step(scopeEvent(macroInsight, "budget-prep-window"), fact(83), [], []).
step(package_within_budget(check),
     rule(124),
     ['Pkg' = pkgFlandor, 'Cost' = 120, 'Max' = 140],
     [recommended_package(case, pkgFlandor),
      costMEUR(pkgFlandor, 120),
      maxMEUR(budget, 140),
      120 =< 140]).
step(package_covers_all_needs(check),
     rule(125),
     ['Pkg' = pkgFlandor],
     [recommended_package(case, pkgFlandor),
      coversExportWeakness(pkgFlandor, true),
      coversSkillsStrain(pkgFlandor, true),
      coversGridStress(pkgFlandor, true)]).
step(duty_timing_consistent(check),
     rule(126),
     ['Dutyat' = "2026-04-08T18:30:00+00:00", 'Expiresat' = "2026-04-08T19:00:00+00:00"],
     [boardDutyAt(case, "2026-04-08T18:30:00+00:00"),
      expiresAt(macroInsight, "2026-04-08T19:00:00+00:00"),
      "2026-04-08T18:30:00+00:00" @=< "2026-04-08T19:00:00+00:00"]).
step(boardDutyAt(case, "2026-04-08T18:30:00+00:00"), fact(22), [], []).
step("2026-04-08T18:30:00+00:00" @=< "2026-04-08T19:00:00+00:00", builtin, [], []).
step(surveillance_reuse_prohibited(check),
     rule(127),
     [],
     [prohibition(policy, odrlDistribute, macroInsight, "firm_surveillance")]).
step(prohibition(policy, odrlDistribute, macroInsight, "firm_surveillance"), fact(92), [], []).
step(files_written_expected(check), rule(128), [], [files_written(case, 6)]).
step(signatureVerifies(check, true), rule(148), [], [signature_verifies(check)]).
step(payloadHashMatches(check, true), rule(149), [], [payload_hash_matches(check)]).
step(hmacMatches(check, true), rule(150), [], [hmac_matches(check)]).
step(hmac_matches(check),
     rule(116),
     [],
     [hmacVerificationMode(signature, trustedPrecomputedInput),
      signature_hmac(signature, "955968ca99a191783bc00cba068128ccb9ff40a5e6114fda13a52c74ee27329e")]).
step(minimizationStripsSensitiveTerms(check, true),
     rule(151),
     [],
     [minimization_strips_sensitive_terms(check)]).
step(scopeComplete(check, true), rule(152), [], [scope_complete(check)]).
step(authorizationAllowed(check, true), rule(153), [], [authorization_allowed(check)]).
step(thresholdReached(check, true), rule(154), [], [threshold_reached(check)]).
step(packageWithinBudget(check, true), rule(155), [], [package_within_budget(check)]).
step(packageCoversAllNeeds(check, true), rule(156), [], [package_covers_all_needs(check)]).
step(dutyTimingConsistent(check, true), rule(157), [], [duty_timing_consistent(check)]).
step(surveillanceReuseProhibited(check, true),
     rule(158),
     [],
     [surveillance_reuse_prohibited(check)]).
step(filesWrittenExpected(check, true), rule(159), [], [files_written_expected(check)]).
step(lowestCostEligiblePackageChosen(check, true),
     rule(160),
     [],
     [lowest_cost_eligible_package_chosen(check)]).
step(lowest_cost_eligible_package_chosen(check),
     rule(130),
     [],
     [recommended_package(case, pkgFlandor)]).
step(reason(whyExportWeakness, "Export weakness is active because at least one cluster has exportOrdersIndex < 90 (Antwerp chemicals=84, Ghent manufacturing=87)."),
     rule(161),
     [],
     [export_weakness(case)]).
step(reason(whySkillsStrain, "Skills strain is active because technical vacancy rate is 4.6% (threshold > 3.9%)."),
     rule(162),
     [],
     [skills_strain(case)]).
step(reason(whyGridStress, "Grid stress is active because congestion hours = 19 (threshold > 11)."),
     rule(163),
     [],
     [grid_stress(case)]).
step(reason(whyRecommendationPolicy, "The recommendation policy is \"lowest_cost_package_covering_all_active_needs\", so the cheapest package that covers all active needs within budget is selected."),
     rule(164),
     [],
     [recommended_package(case, pkgFlandor)]).
step(reason(whySelectedPackage, "Selected package \"Flandor Retooling Pulse\" covers export=true, skills=true, grid=true, cost=€120M."),
     rule(165),
     [],
     [recommended_package(case, pkgFlandor)]).
step(reason(whyUsage, "Usage is permitted only for purpose \"regional_stabilization\" and the envelope expires at 2026-04-08T19:00:00+00:00."),
     rule(166),
     [],
     [authorization_allowed(check)]).
