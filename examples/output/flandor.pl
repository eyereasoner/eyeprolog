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
