% Prolog result format 4
query(1, caseName(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = case, 'X1' = "flandor"]).
query(2, regionName(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = flanders, 'X1' = "Flanders"]).
query(3, metric(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = macroInsight, 'X1' = "regional_retooling_priority"]).
query(4, alg(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4, ['X0' = signature, 'X1' = "HMAC-SHA256"]).
query(5, payloadHashSHA256(_0, _1), ['X0' = _0, 'X1' = _1]).
result(5, complete, 1).
answer(5,
       ['X0' = signature,
        'X1' = "718f5b17d07ab6a95503bc04a1000ddb132409f600659c03d21def81914b780b"]).
query(6, signatureHMAC(_0, _1), ['X0' = _0, 'X1' = _1]).
result(6, complete, 1).
answer(6,
       ['X0' = signature,
        'X1' = "955968ca99a191783bc00cba068128ccb9ff40a5e6114fda13a52c74ee27329e"]).
query(7, auditEntries(_0, _1), ['X0' = _0, 'X1' = _1]).
result(7, complete, 1).
answer(7, ['X0' = case, 'X1' = 1]).
query(8, filesWritten(_0, _1), ['X0' = _0, 'X1' = _1]).
result(8, complete, 1).
answer(8, ['X0' = case, 'X1' = 6]).
query(9, exportWeakness(_0, _1), ['X0' = _0, 'X1' = _1]).
result(9, complete, 1).
answer(9, ['X0' = case, 'X1' = true]).
query(10, skillsStrain(_0, _1), ['X0' = _0, 'X1' = _1]).
result(10, complete, 1).
answer(10, ['X0' = case, 'X1' = true]).
query(11, gridStress(_0, _1), ['X0' = _0, 'X1' = _1]).
result(11, complete, 1).
answer(11, ['X0' = case, 'X1' = true]).
query(12, needsRetoolingPulse(_0, _1), ['X0' = _0, 'X1' = _1]).
result(12, complete, 1).
answer(12, ['X0' = case, 'X1' = true]).
query(13, derivedFromNeed(_0, _1), ['X0' = _0, 'X1' = _1]).
result(13, complete, 1).
answer(13, ['X0' = case, 'X1' = "regional_retooling_and_flexibility"]).
query(14, activeNeedCount(_0, _1), ['X0' = _0, 'X1' = _1]).
result(14, complete, 1).
answer(14, ['X0' = answer, 'X1' = 3]).
query(15, activeNeedThreshold(_0, _1), ['X0' = _0, 'X1' = _1]).
result(15, complete, 1).
answer(15, ['X0' = answer, 'X1' = 3]).
query(16, recommendedPackageName(_0, _1), ['X0' = _0, 'X1' = _1]).
result(16, complete, 1).
answer(16, ['X0' = answer, 'X1' = "Flandor Retooling Pulse"]).
query(17, budgetCapMEUR(_0, _1), ['X0' = _0, 'X1' = _1]).
result(17, complete, 1).
answer(17, ['X0' = answer, 'X1' = 140]).
query(18, packageCostMEUR(_0, _1), ['X0' = _0, 'X1' = _1]).
result(18, complete, 1).
answer(18, ['X0' = answer, 'X1' = 120]).
query(19, envelopeExpiresAt(_0, _1), ['X0' = _0, 'X1' = _1]).
result(19, complete, 1).
answer(19, ['X0' = answer, 'X1' = "2026-04-08T19:00:00+00:00"]).
query(20, workerCoverage(_0, _1), ['X0' = _0, 'X1' = _1]).
result(20, complete, 1).
answer(20, ['X0' = why, 'X1' = 1200]).
query(21, gridReliefMW(_0, _1), ['X0' = _0, 'X1' = _1]).
result(21, complete, 1).
answer(21, ['X0' = why, 'X1' = 85]).
query(22, outcome(_0, _1), ['X0' = _0, 'X1' = _1]).
result(22, complete, 1).
answer(22, ['X0' = decision, 'X1' = "Allowed"]).
query(23, target(_0, _1), ['X0' = _0, 'X1' = _1]).
result(23, complete, 1).
answer(23, ['X0' = decision, 'X1' = macroInsight]).
query(24, allChecksPass(_0, _1), ['X0' = _0, 'X1' = _1]).
result(24, complete, 1).
answer(24, ['X0' = result, 'X1' = true]).
query(25, signatureVerifies(_0, _1), ['X0' = _0, 'X1' = _1]).
result(25, complete, 1).
answer(25, ['X0' = check, 'X1' = true]).
query(26, payloadHashMatches(_0, _1), ['X0' = _0, 'X1' = _1]).
result(26, complete, 1).
answer(26, ['X0' = check, 'X1' = true]).
query(27, hmacMatches(_0, _1), ['X0' = _0, 'X1' = _1]).
result(27, complete, 1).
answer(27, ['X0' = check, 'X1' = true]).
query(28, minimizationStripsSensitiveTerms(_0, _1), ['X0' = _0, 'X1' = _1]).
result(28, complete, 1).
answer(28, ['X0' = check, 'X1' = true]).
query(29, scopeComplete(_0, _1), ['X0' = _0, 'X1' = _1]).
result(29, complete, 1).
answer(29, ['X0' = check, 'X1' = true]).
query(30, authorizationAllowed(_0, _1), ['X0' = _0, 'X1' = _1]).
result(30, complete, 1).
answer(30, ['X0' = check, 'X1' = true]).
query(31, thresholdReached(_0, _1), ['X0' = _0, 'X1' = _1]).
result(31, complete, 1).
answer(31, ['X0' = check, 'X1' = true]).
query(32, packageWithinBudget(_0, _1), ['X0' = _0, 'X1' = _1]).
result(32, complete, 1).
answer(32, ['X0' = check, 'X1' = true]).
query(33, packageCoversAllNeeds(_0, _1), ['X0' = _0, 'X1' = _1]).
result(33, complete, 1).
answer(33, ['X0' = check, 'X1' = true]).
query(34, dutyTimingConsistent(_0, _1), ['X0' = _0, 'X1' = _1]).
result(34, complete, 1).
answer(34, ['X0' = check, 'X1' = true]).
query(35, surveillanceReuseProhibited(_0, _1), ['X0' = _0, 'X1' = _1]).
result(35, complete, 1).
answer(35, ['X0' = check, 'X1' = true]).
query(36, filesWrittenExpected(_0, _1), ['X0' = _0, 'X1' = _1]).
result(36, complete, 1).
answer(36, ['X0' = check, 'X1' = true]).
query(37, lowestCostEligiblePackageChosen(_0, _1), ['X0' = _0, 'X1' = _1]).
result(37, complete, 1).
answer(37, ['X0' = check, 'X1' = true]).
query(38, reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(38, complete, 6).
answer(38,
       ['X0' = whyExportWeakness,
        'X1' = "Export weakness is active because at least one cluster has exportOrdersIndex < 90 (Antwerp chemicals=84, Ghent manufacturing=87)."]).
answer(38,
       ['X0' = whySkillsStrain,
        'X1' = "Skills strain is active because technical vacancy rate is 4.6% (threshold > 3.9%)."]).
answer(38,
       ['X0' = whyGridStress,
        'X1' = "Grid stress is active because congestion hours = 19 (threshold > 11)."]).
answer(38,
       ['X0' = whyRecommendationPolicy,
        'X1' = "The recommendation policy is \"lowest_cost_package_covering_all_active_needs\", so the cheapest package that covers all active needs within budget is selected."]).
answer(38,
       ['X0' = whySelectedPackage,
        'X1' = "Selected package \"Flandor Retooling Pulse\" covers export=true, skills=true, grid=true, cost=€120M."]).
answer(38,
       ['X0' = whyUsage,
        'X1' = "Usage is permitted only for purpose \"regional_stabilization\" and the envelope expires at 2026-04-08T19:00:00+00:00."]).
