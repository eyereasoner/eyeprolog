% Prolog result format 4
query(1, metric(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = insight, 'X1' = "sugar_g_per_serving"]).
query(2, retailer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = insight, 'X1' = "Delfour"]).
query(3, caseName(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = case, 'X1' = "delfour"]).
query(4, needsLowSugar(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4, ['X0' = case, 'X1' = true]).
query(5, derivedFromNeed(_0, _1), ['X0' = _0, 'X1' = _1]).
result(5, complete, 1).
answer(5, ['X0' = insight, 'X1' = "low_sugar"]).
query(6, outcome(_0, _1), ['X0' = _0, 'X1' = _1]).
result(6, complete, 1).
answer(6, ['X0' = decision, 'X1' = "Allowed"]).
query(7, target(_0, _1), ['X0' = _0, 'X1' = _1]).
result(7, complete, 1).
answer(7, ['X0' = decision, 'X1' = insight]).
query(8, scannedProduct(_0, _1), ['X0' = _0, 'X1' = _1]).
result(8, complete, 1).
answer(8, ['X0' = scan, 'X1' = "Classic Tea Biscuits"]).
query(9, suggestedAlternative(_0, _1), ['X0' = _0, 'X1' = _1]).
result(9, complete, 2).
answer(9, ['X0' = case, 'X1' = "Low-Sugar Tea Biscuits"]).
answer(9, ['X0' = banner, 'X1' = "Low-Sugar Tea Biscuits"]).
query(10, threshold(_0, _1), ['X0' = _0, 'X1' = _1]).
result(10, complete, 1).
answer(10, ['X0' = insight, 'X1' = "10.0"]).
query(11, scope(_0, _1), ['X0' = _0, 'X1' = _1]).
result(11, complete, 1).
answer(11, ['X0' = insight, 'X1' = "self-scanner @ pick_up_scanner"]).
query(12, expiresAt(_0, _1), ['X0' = _0, 'X1' = _1]).
result(12, complete, 1).
answer(12, ['X0' = insight, 'X1' = "2025-10-05T22:33:48.907185+00:00"]).
query(13, reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(13, complete, 1).
answer(13,
       ['X0' = why,
        'X1' = "The phone desensitizes a diabetes-related household condition into a scoped low-sugar need, wraps it in an expiring Insight + Policy envelope, signs it, and the scanner consumes that envelope for shopping assistance."]).
query(14, headline(_0, _1), ['X0' = _0, 'X1' = _1]).
result(14, complete, 1).
answer(14, ['X0' = banner, 'X1' = "Track sugar per serving while you scan"]).
query(15, note(_0, _1), ['X0' = _0, 'X1' = _1]).
result(15, complete, 1).
answer(15, ['X0' = banner, 'X1' = "High sugar"]).
query(16, value(_0, _1), ['X0' = _0, 'X1' = _1]).
result(16, complete, 1).
answer(16,
       ['X0' = reasonText,
        'X1' = "Household requires low-sugar guidance (diabetes in POD). A neutral Insight is scoped to device 'self-scanner', event 'pick_up_scanner', retailer 'Delfour', and expires soon; the policy confines use to shopping assistance."]).
query(17, alg(_0, _1), ['X0' = _0, 'X1' = _1]).
result(17, complete, 1).
answer(17, ['X0' = signature, 'X1' = "HMAC-SHA256"]).
query(18, auditEntries(_0, _1), ['X0' = _0, 'X1' = _1]).
result(18, complete, 1).
answer(18, ['X0' = case, 'X1' = 1]).
query(19, filesWritten(_0, _1), ['X0' = _0, 'X1' = _1]).
result(19, complete, 1).
answer(19, ['X0' = case, 'X1' = 6]).
query(20, allChecksPass(_0, _1), ['X0' = _0, 'X1' = _1]).
result(20, complete, 1).
answer(20, ['X0' = result, 'X1' = true]).
query(21, signatureVerifies(_0, _1), ['X0' = _0, 'X1' = _1]).
result(21, complete, 1).
answer(21, ['X0' = check, 'X1' = true]).
query(22, payloadHashMatches(_0, _1), ['X0' = _0, 'X1' = _1]).
result(22, complete, 1).
answer(22, ['X0' = check, 'X1' = true]).
query(23, minimizationStripsSensitiveTerms(_0, _1), ['X0' = _0, 'X1' = _1]).
result(23, complete, 1).
answer(23, ['X0' = check, 'X1' = true]).
query(24, scopeComplete(_0, _1), ['X0' = _0, 'X1' = _1]).
result(24, complete, 1).
answer(24, ['X0' = check, 'X1' = true]).
query(25, authorizationAllowed(_0, _1), ['X0' = _0, 'X1' = _1]).
result(25, complete, 1).
answer(25, ['X0' = check, 'X1' = true]).
query(26, bannerFlagsHighSugar(_0, _1), ['X0' = _0, 'X1' = _1]).
result(26, complete, 1).
answer(26, ['X0' = check, 'X1' = true]).
query(27, alternativeIsLowerSugar(_0, _1), ['X0' = _0, 'X1' = _1]).
result(27, complete, 1).
answer(27, ['X0' = check, 'X1' = true]).
query(28, dutyTimingConsistent(_0, _1), ['X0' = _0, 'X1' = _1]).
result(28, complete, 1).
answer(28, ['X0' = check, 'X1' = true]).
query(29, marketingProhibited(_0, _1), ['X0' = _0, 'X1' = _1]).
result(29, complete, 1).
answer(29, ['X0' = check, 'X1' = true]).
query(30, filesWrittenExpected(_0, _1), ['X0' = _0, 'X1' = _1]).
result(30, complete, 1).
answer(30, ['X0' = check, 'X1' = true]).
