metric(insight, "sugar_g_per_serving").
retailer(insight, "Delfour").
caseName(case, "delfour").
needsLowSugar(case, true).
derivedFromNeed(insight, "low_sugar").
outcome(decision, "Allowed").
target(decision, insight).
scannedProduct(scan, "Classic Tea Biscuits").
suggestedAlternative(case, "Low-Sugar Tea Biscuits").
suggestedAlternative(banner, "Low-Sugar Tea Biscuits").
threshold(insight, "10.0").
scope(insight, "self-scanner @ pick_up_scanner").
expiresAt(insight, "2025-10-05T22:33:48.907185+00:00").
reason(why, "The phone desensitizes a diabetes-related household condition into a scoped low-sugar need, wraps it in an expiring Insight + Policy envelope, signs it, and the scanner consumes that envelope for shopping assistance.").
headline(banner, "Track sugar per serving while you scan").
note(banner, "High sugar").
value(reasonText, "Household requires low-sugar guidance (diabetes in POD). A neutral Insight is scoped to device 'self-scanner', event 'pick_up_scanner', retailer 'Delfour', and expires soon; the policy confines use to shopping assistance.").
alg(signature, "HMAC-SHA256").
auditEntries(case, 1).
filesWritten(case, 6).
allChecksPass(result, true).
signatureVerifies(check, true).
payloadHashMatches(check, true).
minimizationStripsSensitiveTerms(check, true).
scopeComplete(check, true).
authorizationAllowed(check, true).
bannerFlagsHighSugar(check, true).
alternativeIsLowerSugar(check, true).
dutyTimingConsistent(check, true).
marketingProhibited(check, true).
filesWrittenExpected(check, true).
