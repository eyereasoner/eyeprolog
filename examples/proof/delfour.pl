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

clause(1,
       case_graph(delfourCaseGraph, (caseName(case, "delfour"), requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001))),
       true).
clause(2,
       product_catalog(delfourCatalog, [product(prod_BIS_001, "prod_BIS_001", "Classic Tea Biscuits", 120, 12.0), product(prod_BIS_101, "prod_BIS_101", "Low-Sugar Tea Biscuits", 30, 3.0), product(prod_CHOC_050, "prod_CHOC_050", "Milk Chocolate Bar", 150, 15.0), product(prod_CHOC_150, "prod_CHOC_150", "85% Dark Chocolate", 60, 6.0)]),
       true).
clause(3,
       insight_graph(delfourInsightGraph, (metric(insight, "sugar_g_per_serving"), thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner'))),
       true).
clause(4,
       policy_graph(delfourPolicyGraph, (odrl_permission(policy, permission(odrl_use, insight, "shopping_assist")), odrl_prohibition(policy, prohibition(odrl_distribute, insight, "marketing")), odrl_duty(policy, duty(odrl_delete, "2025-10-05T22:33:48.907185+00:00")))),
       true).
clause(5,
       envelope_graph(delfourEnvelopeGraph, (insight(envelope, delfourInsightGraph), policy(envelope, delfourPolicyGraph), hash(envelope, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"))),
       true).
clause(6,
       signature_graph(delfourSignatureGraph, (alg(signature, "HMAC-SHA256"), keyid(signature, "demo-shared-secret"), created(signature, "2025-10-05T20:33:48.907163+00:00"), payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"), hmac(signature, "b21d0072d90112a9f820aced0286889f4b6ef92b145e6fdef1011f3bfa4608c2"), hmacVerificationMode(signature, trustedPrecomputedInput))),
       true).
clause(7,
       reason_text(reasonText, "Household requires low-sugar guidance (diabetes in POD). A neutral Insight is scoped to device 'self-scanner', event 'pick_up_scanner', retailer 'Delfour', and expires soon; the policy confines use to shopping assistance."),
       true).
clause(8,
       context_member((var('Left'), anonymous(1)), var('Member')),
       context_member(var('Left'), var('Member'))).
clause(9,
       context_member((anonymous(1), var('Right')), var('Member')),
       context_member(var('Right'), var('Member'))).
clause(10,
       context_member(var('Member'), var('Member')),
       var('Member') \= (anonymous(1), anonymous(2))).
clause(11,
       case_statement(var('S'), var('P'), var('O')),
       (case_graph(delfourCaseGraph, var('Context')),
        context_member(var('Context'), var('Statement')),
        var('Statement') =.. [var('P'), var('S'), var('O')])).
clause(12,
       insight_statement(var('S'), var('P'), var('O')),
       (insight_graph(delfourInsightGraph, var('Context')),
        context_member(var('Context'), var('Statement')),
        var('Statement') =.. [var('P'), var('S'), var('O')])).
clause(13,
       policy_statement(var('S'), var('P'), var('O')),
       (policy_graph(delfourPolicyGraph, var('Context')),
        context_member(var('Context'), var('Statement')),
        var('Statement') =.. [var('P'), var('S'), var('O')])).
clause(14,
       envelope_statement(var('S'), var('P'), var('O')),
       (envelope_graph(delfourEnvelopeGraph, var('Context')),
        context_member(var('Context'), var('Statement')),
        var('Statement') =.. [var('P'), var('S'), var('O')])).
clause(15,
       signature_statement(var('S'), var('P'), var('O')),
       (signature_graph(delfourSignatureGraph, var('Context')),
        context_member(var('Context'), var('Statement')),
        var('Statement') =.. [var('P'), var('S'), var('O')])).
clause(16, case_name(case, var('Name')), case_statement(case, caseName, var('Name'))).
clause(17,
       request_purpose(case, var('Purpose')),
       case_statement(case, requestPurpose, var('Purpose'))).
clause(21, scanner_auth_at(case, var('Time')), case_statement(case, scannerAuthAt, var('Time'))).
clause(22, scanner_duty_at(case, var('Time')), case_statement(case, scannerDutyAt, var('Time'))).
clause(23, files_written(case, var('Count')), case_statement(case, filesWritten, var('Count'))).
clause(24, audit_entries(case, var('Count')), case_statement(case, auditEntries, var('Count'))).
clause(25,
       condition(householdProfile, var('Condition')),
       case_statement(householdProfile, condition, var('Condition'))).
clause(26,
       scanned_product(scan, var('Product')),
       case_statement(scan, scannedProduct, var('Product'))).
clause(27,
       product(var('Product')),
       (product_catalog(delfourCatalog, var('Products')),
        member(product(var('Product'), anonymous(1), anonymous(2), anonymous(3), anonymous(4)), var('Products')))).
clause(29,
       product_name(var('Product'), var('Name')),
       (product_catalog(delfourCatalog, var('Products')),
        member(product(var('Product'), anonymous(1), var('Name'), anonymous(2), anonymous(3)), var('Products')))).
clause(30,
       sugar_tenths(var('Product'), var('Sugar')),
       (product_catalog(delfourCatalog, var('Products')),
        member(product(var('Product'), anonymous(1), anonymous(2), var('Sugar'), anonymous(3)), var('Products')))).
clause(31,
       sugar_per_serving(var('Product'), var('Sugar')),
       (product_catalog(delfourCatalog, var('Products')),
        member(product(var('Product'), anonymous(1), anonymous(2), anonymous(3), var('Sugar')), var('Products')))).
clause(33, metric(insight, var('Metric')), insight_statement(insight, metric, var('Metric'))).
clause(35,
       threshold_display(insight, var('Threshold')),
       insight_statement(insight, thresholdDisplay, var('Threshold'))).
clause(36,
       threshold_g(insight, var('Threshold')),
       insight_statement(insight, thresholdG, var('Threshold'))).
clause(38,
       scope_device(insight, var('Device')),
       insight_statement(insight, scopeDevice, var('Device'))).
clause(39,
       scope_event(insight, var('Event')),
       insight_statement(insight, scopeEvent, var('Event'))).
clause(40,
       retailer(insight, var('Retailer')),
       insight_statement(insight, retailer, var('Retailer'))).
clause(42, expires_at(insight, var('Time')), insight_statement(insight, expiresAt, var('Time'))).
clause(43,
       serialized_lowercase(insight, var('Text')),
       insight_statement(insight, serializedLowercase, var('Text'))).
clause(45,
       permission(policy, var('Action'), var('Target'), var('Purpose')),
       policy_statement(policy, odrl_permission, permission(var('Action'), var('Target'), var('Purpose')))).
clause(46,
       prohibition(policy, var('Action'), var('Target'), var('Purpose')),
       policy_statement(policy, odrl_prohibition, prohibition(var('Action'), var('Target'), var('Purpose')))).
clause(50,
       envelope_hash(envelope, var('Hash')),
       envelope_statement(envelope, hash, var('Hash'))).
clause(51,
       signature_alg(signature, var('Alg')),
       signature_statement(signature, alg, var('Alg'))).
clause(54,
       payload_hash_sha256(signature, var('Hash')),
       signature_statement(signature, payloadHashSha256, var('Hash'))).
clause(56,
       hmac_verification_mode(signature, var('Mode')),
       signature_statement(signature, hmacVerificationMode, var('Mode'))).
clause(57, needs_low_sugar(case), condition(householdProfile, "Diabetes")).
clause(58, derived_from_need(insight, "low_sugar"), needs_low_sugar(case)).
clause(59,
       payload_hash_matches(check),
       (envelope_hash(envelope, var('Digest')), payload_hash_sha256(signature, var('Digest')))).
clause(60,
       signature_verifies(check),
       hmac_verification_mode(signature, trustedPrecomputedInput)).
clause(61,
       minimization_strips_sensitive_terms(check),
       (serialized_lowercase(insight, var('Text')), \+ matches(var('Text'), 'diabetes|medical'))).
clause(62,
       scope_complete(check),
       (scope_device(insight, anonymous(1)),
        scope_event(insight, anonymous(2)),
        expires_at(insight, anonymous(3)))).
clause(63,
       authorization_allowed(check),
       (permission(policy, odrl_use, insight, "shopping_assist"),
        request_purpose(case, "shopping_assist"),
        scanner_auth_at(case, var('Authat')),
        expires_at(insight, var('Expiresat')),
        var('Authat') @=< var('Expiresat'))).
clause(64, decision(decision, "Allowed", insight), authorization_allowed(check)).
clause(65,
       banner_flags_high_sugar(check),
       (decision(decision, "Allowed", insight),
        scanned_product(scan, var('Product')),
        sugar_per_serving(var('Product'), var('Sugar')),
        threshold_g(insight, var('Threshold')),
        var('Sugar') >= var('Threshold'))).
clause(66,
       banner_headline(banner, "Track sugar per serving while you scan"),
       banner_flags_high_sugar(check)).
clause(67, banner_note(banner, "High sugar"), banner_flags_high_sugar(check)).
clause(69,
       suggested_alternative(case, var('Candidate')),
       (scanned_product(scan, var('Scanned')),
        sugar_tenths(var('Scanned'), var('Scannedsugar')),
        product(var('Candidate')),
        sugar_tenths(var('Candidate'), var('Candidatesugar')),
        var('Scannedsugar') > var('Candidatesugar'),
        \+ better_lower_sugar(var('Scannedsugar'), var('Candidatesugar')))).
clause(70,
       banner_suggested_alternative(banner, var('Name')),
       (banner_note(banner, "High sugar"),
        suggested_alternative(case, var('Alternative')),
        product_name(var('Alternative'), var('Name')))).
clause(71,
       alternative_is_lower_sugar(check),
       (scanned_product(scan, var('Scanned')),
        sugar_tenths(var('Scanned'), var('Scannedsugar')),
        suggested_alternative(case, var('Alternative')),
        sugar_tenths(var('Alternative'), var('Alternativesugar')),
        var('Scannedsugar') > var('Alternativesugar'))).
clause(72,
       duty_timing_consistent(check),
       (scanner_duty_at(case, var('Dutyat')),
        expires_at(insight, var('Expiresat')),
        var('Dutyat') @=< var('Expiresat'))).
clause(73,
       marketing_prohibited(check),
       prohibition(policy, odrl_distribute, insight, "marketing")).
clause(74, files_written_expected(check), files_written(case, 6)).
clause(75,
       all_checks_pass(result),
       (signature_verifies(check),
        payload_hash_matches(check),
        minimization_strips_sensitive_terms(check),
        scope_complete(check),
        authorization_allowed(check),
        banner_flags_high_sugar(check),
        alternative_is_lower_sugar(check),
        duty_timing_consistent(check),
        marketing_prohibited(check),
        files_written_expected(check))).
clause(76, caseName(case, var('Name')), case_name(case, var('Name'))).
clause(77, needsLowSugar(case, true), needs_low_sugar(case)).
clause(78, derivedFromNeed(insight, var('Need')), derived_from_need(insight, var('Need'))).
clause(79, outcome(decision, var('Outcome')), decision(decision, var('Outcome'), anonymous(1))).
clause(80, target(decision, var('Target')), decision(decision, anonymous(1), var('Target'))).
clause(81,
       scannedProduct(scan, var('Productname')),
       (scanned_product(scan, var('Product')), product_name(var('Product'), var('Productname')))).
clause(82,
       suggestedAlternative(case, var('Name')),
       (suggested_alternative(case, var('Alternative')),
        product_name(var('Alternative'), var('Name')))).
clause(83, threshold(insight, var('Threshold')), threshold_display(insight, var('Threshold'))).
clause(84,
       scope(insight, "self-scanner @ pick_up_scanner"),
       (scope_device(insight, "self-scanner"), scope_event(insight, "pick_up_scanner"))).
clause(85, expiresAt(insight, var('Time')), expires_at(insight, var('Time'))).
clause(86,
       reason(why, "The phone desensitizes a diabetes-related household condition into a scoped low-sugar need, wraps it in an expiring Insight + Policy envelope, signs it, and the scanner consumes that envelope for shopping assistance."),
       authorization_allowed(check)).
clause(87, headline(banner, var('Headline')), banner_headline(banner, var('Headline'))).
clause(88, note(banner, var('Note')), banner_note(banner, var('Note'))).
clause(89,
       suggestedAlternative(banner, var('Name')),
       banner_suggested_alternative(banner, var('Name'))).
clause(90, value(reasonText, var('Text')), reason_text(reasonText, var('Text'))).
clause(91, alg(signature, var('Alg')), signature_alg(signature, var('Alg'))).
clause(92, auditEntries(case, var('Count')), audit_entries(case, var('Count'))).
clause(93, filesWritten(case, var('Count')), files_written(case, var('Count'))).
clause(94, allChecksPass(result, true), all_checks_pass(result)).
clause(95, signatureVerifies(check, true), signature_verifies(check)).
clause(96, payloadHashMatches(check, true), payload_hash_matches(check)).
clause(97,
       minimizationStripsSensitiveTerms(check, true),
       minimization_strips_sensitive_terms(check)).
clause(98, scopeComplete(check, true), scope_complete(check)).
clause(99, authorizationAllowed(check, true), authorization_allowed(check)).
clause(100, bannerFlagsHighSugar(check, true), banner_flags_high_sugar(check)).
clause(101, alternativeIsLowerSugar(check, true), alternative_is_lower_sugar(check)).
clause(102, dutyTimingConsistent(check, true), duty_timing_consistent(check)).
clause(103, marketingProhibited(check, true), marketing_prohibited(check)).
clause(104, filesWrittenExpected(check, true), files_written_expected(check)).

step(metric(insight, "sugar_g_per_serving"),
     rule(33),
     ['Metric' = "sugar_g_per_serving"],
     [insight_statement(insight, metric, "sugar_g_per_serving")]).
step(insight_statement(insight, metric, "sugar_g_per_serving"),
     rule(12),
     ['S' = insight,
      'P' = metric,
      'O' = "sugar_g_per_serving",
      'Context' = (metric(insight, "sugar_g_per_serving"), thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Statement' = metric(insight, "sugar_g_per_serving")],
     [insight_graph(delfourInsightGraph, (metric(insight, "sugar_g_per_serving"), thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner'))),
      context_member((metric(insight, "sugar_g_per_serving"), thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), metric(insight, "sugar_g_per_serving")),
      metric(insight, "sugar_g_per_serving") =.. [metric, insight, "sugar_g_per_serving"]]).
step(insight_graph(delfourInsightGraph, (metric(insight, "sugar_g_per_serving"), thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner'))),
     fact(3),
     [],
     []).
step(context_member((metric(insight, "sugar_g_per_serving"), thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), metric(insight, "sugar_g_per_serving")),
     rule(8),
     ['Left' = metric(insight, "sugar_g_per_serving"),
      'Member' = metric(insight, "sugar_g_per_serving")],
     [context_member(metric(insight, "sugar_g_per_serving"), metric(insight, "sugar_g_per_serving"))]).
step(context_member(metric(insight, "sugar_g_per_serving"), metric(insight, "sugar_g_per_serving")),
     rule(10),
     ['Member' = metric(insight, "sugar_g_per_serving")],
     [metric(insight, "sugar_g_per_serving") \= (_left, _right)]).
step(metric(insight, "sugar_g_per_serving") \= (_left, _right), builtin, [], []).
step(metric(insight, "sugar_g_per_serving") =.. [metric, insight, "sugar_g_per_serving"],
     builtin,
     [],
     []).
step(retailer(insight, "Delfour"),
     rule(40),
     ['Retailer' = "Delfour"],
     [insight_statement(insight, retailer, "Delfour")]).
step(insight_statement(insight, retailer, "Delfour"),
     rule(12),
     ['S' = insight,
      'P' = retailer,
      'O' = "Delfour",
      'Context' = (metric(insight, "sugar_g_per_serving"), thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Statement' = retailer(insight, "Delfour")],
     [insight_graph(delfourInsightGraph, (metric(insight, "sugar_g_per_serving"), thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner'))),
      context_member((metric(insight, "sugar_g_per_serving"), thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), retailer(insight, "Delfour")),
      retailer(insight, "Delfour") =.. [retailer, insight, "Delfour"]]).
step(context_member((metric(insight, "sugar_g_per_serving"), thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), retailer(insight, "Delfour")),
     rule(9),
     ['Right' = (thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Member' = retailer(insight, "Delfour")],
     [context_member((thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), retailer(insight, "Delfour"))]).
step(context_member((thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), retailer(insight, "Delfour")),
     rule(9),
     ['Right' = (thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Member' = retailer(insight, "Delfour")],
     [context_member((thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), retailer(insight, "Delfour"))]).
step(context_member((thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), retailer(insight, "Delfour")),
     rule(9),
     ['Right' = (thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Member' = retailer(insight, "Delfour")],
     [context_member((thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), retailer(insight, "Delfour"))]).
step(context_member((thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), retailer(insight, "Delfour")),
     rule(9),
     ['Right' = (suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Member' = retailer(insight, "Delfour")],
     [context_member((suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), retailer(insight, "Delfour"))]).
step(context_member((suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), retailer(insight, "Delfour")),
     rule(9),
     ['Right' = (scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Member' = retailer(insight, "Delfour")],
     [context_member((scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), retailer(insight, "Delfour"))]).
step(context_member((scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), retailer(insight, "Delfour")),
     rule(9),
     ['Right' = (scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Member' = retailer(insight, "Delfour")],
     [context_member((scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), retailer(insight, "Delfour"))]).
step(context_member((scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), retailer(insight, "Delfour")),
     rule(9),
     ['Right' = (retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Member' = retailer(insight, "Delfour")],
     [context_member((retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), retailer(insight, "Delfour"))]).
step(context_member((retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), retailer(insight, "Delfour")),
     rule(8),
     ['Left' = retailer(insight, "Delfour"), 'Member' = retailer(insight, "Delfour")],
     [context_member(retailer(insight, "Delfour"), retailer(insight, "Delfour"))]).
step(context_member(retailer(insight, "Delfour"), retailer(insight, "Delfour")),
     rule(10),
     ['Member' = retailer(insight, "Delfour")],
     [retailer(insight, "Delfour") \= (_left, _right)]).
step(retailer(insight, "Delfour") \= (_left, _right), builtin, [], []).
step(retailer(insight, "Delfour") =.. [retailer, insight, "Delfour"], builtin, [], []).
step(caseName(case, "delfour"), rule(76), ['Name' = "delfour"], [case_name(case, "delfour")]).
step(case_name(case, "delfour"),
     rule(16),
     ['Name' = "delfour"],
     [case_statement(case, caseName, "delfour")]).
step(case_statement(case, caseName, "delfour"),
     rule(11),
     ['S' = case,
      'P' = caseName,
      'O' = "delfour",
      'Context' = (caseName(case, "delfour"), requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Statement' = caseName(case, "delfour")],
     [case_graph(delfourCaseGraph, (caseName(case, "delfour"), requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001))),
      context_member((caseName(case, "delfour"), requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), caseName(case, "delfour")),
      caseName(case, "delfour") =.. [caseName, case, "delfour"]]).
step(case_graph(delfourCaseGraph, (caseName(case, "delfour"), requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001))),
     fact(1),
     [],
     []).
step(context_member((caseName(case, "delfour"), requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), caseName(case, "delfour")),
     rule(8),
     ['Left' = caseName(case, "delfour"), 'Member' = caseName(case, "delfour")],
     [context_member(caseName(case, "delfour"), caseName(case, "delfour"))]).
step(context_member(caseName(case, "delfour"), caseName(case, "delfour")),
     rule(10),
     ['Member' = caseName(case, "delfour")],
     [caseName(case, "delfour") \= (_left, _right)]).
step(caseName(case, "delfour") \= (_left, _right), builtin, [], []).
step(caseName(case, "delfour") =.. [caseName, case, "delfour"], builtin, [], []).
step(needsLowSugar(case, true), rule(77), [], [needs_low_sugar(case)]).
step(needs_low_sugar(case), rule(57), [], [condition(householdProfile, "Diabetes")]).
step(condition(householdProfile, "Diabetes"),
     rule(25),
     ['Condition' = "Diabetes"],
     [case_statement(householdProfile, condition, "Diabetes")]).
step(case_statement(householdProfile, condition, "Diabetes"),
     rule(11),
     ['S' = householdProfile,
      'P' = condition,
      'O' = "Diabetes",
      'Context' = (caseName(case, "delfour"), requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Statement' = condition(householdProfile, "Diabetes")],
     [case_graph(delfourCaseGraph, (caseName(case, "delfour"), requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001))),
      context_member((caseName(case, "delfour"), requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), condition(householdProfile, "Diabetes")),
      condition(householdProfile, "Diabetes") =.. [condition, householdProfile, "Diabetes"]]).
step(context_member((caseName(case, "delfour"), requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), condition(householdProfile, "Diabetes")),
     rule(9),
     ['Right' = (requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = condition(householdProfile, "Diabetes")],
     [context_member((requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), condition(householdProfile, "Diabetes"))]).
step(context_member((requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), condition(householdProfile, "Diabetes")),
     rule(9),
     ['Right' = (requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = condition(householdProfile, "Diabetes")],
     [context_member((requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), condition(householdProfile, "Diabetes"))]).
step(context_member((requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), condition(householdProfile, "Diabetes")),
     rule(9),
     ['Right' = (phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = condition(householdProfile, "Diabetes")],
     [context_member((phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), condition(householdProfile, "Diabetes"))]).
step(context_member((phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), condition(householdProfile, "Diabetes")),
     rule(9),
     ['Right' = (phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = condition(householdProfile, "Diabetes")],
     [context_member((phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), condition(householdProfile, "Diabetes"))]).
step(context_member((phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), condition(householdProfile, "Diabetes")),
     rule(9),
     ['Right' = (scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = condition(householdProfile, "Diabetes")],
     [context_member((scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), condition(householdProfile, "Diabetes"))]).
step(context_member((scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), condition(householdProfile, "Diabetes")),
     rule(9),
     ['Right' = (scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = condition(householdProfile, "Diabetes")],
     [context_member((scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), condition(householdProfile, "Diabetes"))]).
step(context_member((scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), condition(householdProfile, "Diabetes")),
     rule(9),
     ['Right' = (filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = condition(householdProfile, "Diabetes")],
     [context_member((filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), condition(householdProfile, "Diabetes"))]).
step(context_member((filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), condition(householdProfile, "Diabetes")),
     rule(9),
     ['Right' = (auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = condition(householdProfile, "Diabetes")],
     [context_member((auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), condition(householdProfile, "Diabetes"))]).
step(context_member((auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), condition(householdProfile, "Diabetes")),
     rule(9),
     ['Right' = (condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = condition(householdProfile, "Diabetes")],
     [context_member((condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), condition(householdProfile, "Diabetes"))]).
step(context_member((condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), condition(householdProfile, "Diabetes")),
     rule(8),
     ['Left' = condition(householdProfile, "Diabetes"),
      'Member' = condition(householdProfile, "Diabetes")],
     [context_member(condition(householdProfile, "Diabetes"), condition(householdProfile, "Diabetes"))]).
step(context_member(condition(householdProfile, "Diabetes"), condition(householdProfile, "Diabetes")),
     rule(10),
     ['Member' = condition(householdProfile, "Diabetes")],
     [condition(householdProfile, "Diabetes") \= (_left, _right)]).
step(condition(householdProfile, "Diabetes") \= (_left, _right), builtin, [], []).
step(condition(householdProfile, "Diabetes") =.. [condition, householdProfile, "Diabetes"],
     builtin,
     [],
     []).
step(derivedFromNeed(insight, "low_sugar"),
     rule(78),
     ['Need' = "low_sugar"],
     [derived_from_need(insight, "low_sugar")]).
step(derived_from_need(insight, "low_sugar"), rule(58), [], [needs_low_sugar(case)]).
step(outcome(decision, "Allowed"),
     rule(79),
     ['Outcome' = "Allowed"],
     [decision(decision, "Allowed", insight)]).
step(decision(decision, "Allowed", insight), rule(64), [], [authorization_allowed(check)]).
step(authorization_allowed(check),
     rule(63),
     ['Authat' = "2025-10-05T20:35:48.907163+00:00",
      'Expiresat' = "2025-10-05T22:33:48.907185+00:00"],
     [permission(policy, odrl_use, insight, "shopping_assist"),
      request_purpose(case, "shopping_assist"),
      scanner_auth_at(case, "2025-10-05T20:35:48.907163+00:00"),
      expires_at(insight, "2025-10-05T22:33:48.907185+00:00"),
      "2025-10-05T20:35:48.907163+00:00" @=< "2025-10-05T22:33:48.907185+00:00"]).
step(permission(policy, odrl_use, insight, "shopping_assist"),
     rule(45),
     ['Action' = odrl_use, 'Target' = insight, 'Purpose' = "shopping_assist"],
     [policy_statement(policy, odrl_permission, permission(odrl_use, insight, "shopping_assist"))]).
step(policy_statement(policy, odrl_permission, permission(odrl_use, insight, "shopping_assist")),
     rule(13),
     ['S' = policy,
      'P' = odrl_permission,
      'O' = permission(odrl_use, insight, "shopping_assist"),
      'Context' = (odrl_permission(policy, permission(odrl_use, insight, "shopping_assist")), odrl_prohibition(policy, prohibition(odrl_distribute, insight, "marketing")), odrl_duty(policy, duty(odrl_delete, "2025-10-05T22:33:48.907185+00:00"))),
      'Statement' = odrl_permission(policy, permission(odrl_use, insight, "shopping_assist"))],
     [policy_graph(delfourPolicyGraph, (odrl_permission(policy, permission(odrl_use, insight, "shopping_assist")), odrl_prohibition(policy, prohibition(odrl_distribute, insight, "marketing")), odrl_duty(policy, duty(odrl_delete, "2025-10-05T22:33:48.907185+00:00")))),
      context_member((odrl_permission(policy, permission(odrl_use, insight, "shopping_assist")), odrl_prohibition(policy, prohibition(odrl_distribute, insight, "marketing")), odrl_duty(policy, duty(odrl_delete, "2025-10-05T22:33:48.907185+00:00"))), odrl_permission(policy, permission(odrl_use, insight, "shopping_assist"))),
      odrl_permission(policy, permission(odrl_use, insight, "shopping_assist")) =.. [odrl_permission, policy, permission(odrl_use, insight, "shopping_assist")]]).
step(policy_graph(delfourPolicyGraph, (odrl_permission(policy, permission(odrl_use, insight, "shopping_assist")), odrl_prohibition(policy, prohibition(odrl_distribute, insight, "marketing")), odrl_duty(policy, duty(odrl_delete, "2025-10-05T22:33:48.907185+00:00")))),
     fact(4),
     [],
     []).
step(context_member((odrl_permission(policy, permission(odrl_use, insight, "shopping_assist")), odrl_prohibition(policy, prohibition(odrl_distribute, insight, "marketing")), odrl_duty(policy, duty(odrl_delete, "2025-10-05T22:33:48.907185+00:00"))), odrl_permission(policy, permission(odrl_use, insight, "shopping_assist"))),
     rule(8),
     ['Left' = odrl_permission(policy, permission(odrl_use, insight, "shopping_assist")),
      'Member' = odrl_permission(policy, permission(odrl_use, insight, "shopping_assist"))],
     [context_member(odrl_permission(policy, permission(odrl_use, insight, "shopping_assist")), odrl_permission(policy, permission(odrl_use, insight, "shopping_assist")))]).
step(context_member(odrl_permission(policy, permission(odrl_use, insight, "shopping_assist")), odrl_permission(policy, permission(odrl_use, insight, "shopping_assist"))),
     rule(10),
     ['Member' = odrl_permission(policy, permission(odrl_use, insight, "shopping_assist"))],
     [odrl_permission(policy, permission(odrl_use, insight, "shopping_assist")) \= (_left, _right)]).
step(odrl_permission(policy, permission(odrl_use, insight, "shopping_assist")) \= (_left, _right),
     builtin,
     [],
     []).
step(odrl_permission(policy, permission(odrl_use, insight, "shopping_assist")) =.. [odrl_permission, policy, permission(odrl_use, insight, "shopping_assist")],
     builtin,
     [],
     []).
step(request_purpose(case, "shopping_assist"),
     rule(17),
     ['Purpose' = "shopping_assist"],
     [case_statement(case, requestPurpose, "shopping_assist")]).
step(case_statement(case, requestPurpose, "shopping_assist"),
     rule(11),
     ['S' = case,
      'P' = requestPurpose,
      'O' = "shopping_assist",
      'Context' = (caseName(case, "delfour"), requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Statement' = requestPurpose(case, "shopping_assist")],
     [case_graph(delfourCaseGraph, (caseName(case, "delfour"), requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001))),
      context_member((caseName(case, "delfour"), requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), requestPurpose(case, "shopping_assist")),
      requestPurpose(case, "shopping_assist") =.. [requestPurpose, case, "shopping_assist"]]).
step(context_member((caseName(case, "delfour"), requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), requestPurpose(case, "shopping_assist")),
     rule(9),
     ['Right' = (requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = requestPurpose(case, "shopping_assist")],
     [context_member((requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), requestPurpose(case, "shopping_assist"))]).
step(context_member((requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), requestPurpose(case, "shopping_assist")),
     rule(8),
     ['Left' = requestPurpose(case, "shopping_assist"),
      'Member' = requestPurpose(case, "shopping_assist")],
     [context_member(requestPurpose(case, "shopping_assist"), requestPurpose(case, "shopping_assist"))]).
step(context_member(requestPurpose(case, "shopping_assist"), requestPurpose(case, "shopping_assist")),
     rule(10),
     ['Member' = requestPurpose(case, "shopping_assist")],
     [requestPurpose(case, "shopping_assist") \= (_left, _right)]).
step(requestPurpose(case, "shopping_assist") \= (_left, _right), builtin, [], []).
step(requestPurpose(case, "shopping_assist") =.. [requestPurpose, case, "shopping_assist"],
     builtin,
     [],
     []).
step(scanner_auth_at(case, "2025-10-05T20:35:48.907163+00:00"),
     rule(21),
     ['Time' = "2025-10-05T20:35:48.907163+00:00"],
     [case_statement(case, scannerAuthAt, "2025-10-05T20:35:48.907163+00:00")]).
step(case_statement(case, scannerAuthAt, "2025-10-05T20:35:48.907163+00:00"),
     rule(11),
     ['S' = case,
      'P' = scannerAuthAt,
      'O' = "2025-10-05T20:35:48.907163+00:00",
      'Context' = (caseName(case, "delfour"), requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Statement' = scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00")],
     [case_graph(delfourCaseGraph, (caseName(case, "delfour"), requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001))),
      context_member((caseName(case, "delfour"), requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00")),
      scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00") =.. [scannerAuthAt, case, "2025-10-05T20:35:48.907163+00:00"]]).
step(context_member((caseName(case, "delfour"), requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00")),
     rule(9),
     ['Right' = (requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00")],
     [context_member((requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"))]).
step(context_member((requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00")),
     rule(9),
     ['Right' = (requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00")],
     [context_member((requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"))]).
step(context_member((requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00")),
     rule(9),
     ['Right' = (phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00")],
     [context_member((phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"))]).
step(context_member((phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00")),
     rule(9),
     ['Right' = (phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00")],
     [context_member((phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"))]).
step(context_member((phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00")),
     rule(9),
     ['Right' = (scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00")],
     [context_member((scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"))]).
step(context_member((scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00")),
     rule(8),
     ['Left' = scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"),
      'Member' = scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00")],
     [context_member(scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"))]).
step(context_member(scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00")),
     rule(10),
     ['Member' = scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00")],
     [scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00") \= (_left, _right)]).
step(scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00") \= (_left, _right),
     builtin,
     [],
     []).
step(scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00") =.. [scannerAuthAt, case, "2025-10-05T20:35:48.907163+00:00"],
     builtin,
     [],
     []).
step(expires_at(insight, "2025-10-05T22:33:48.907185+00:00"),
     rule(42),
     ['Time' = "2025-10-05T22:33:48.907185+00:00"],
     [insight_statement(insight, expiresAt, "2025-10-05T22:33:48.907185+00:00")]).
step(insight_statement(insight, expiresAt, "2025-10-05T22:33:48.907185+00:00"),
     rule(12),
     ['S' = insight,
      'P' = expiresAt,
      'O' = "2025-10-05T22:33:48.907185+00:00",
      'Context' = (metric(insight, "sugar_g_per_serving"), thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Statement' = expiresAt(insight, "2025-10-05T22:33:48.907185+00:00")],
     [insight_graph(delfourInsightGraph, (metric(insight, "sugar_g_per_serving"), thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner'))),
      context_member((metric(insight, "sugar_g_per_serving"), thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00")),
      expiresAt(insight, "2025-10-05T22:33:48.907185+00:00") =.. [expiresAt, insight, "2025-10-05T22:33:48.907185+00:00"]]).
step(context_member((metric(insight, "sugar_g_per_serving"), thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00")),
     rule(9),
     ['Right' = (thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Member' = expiresAt(insight, "2025-10-05T22:33:48.907185+00:00")],
     [context_member((thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"))]).
step(context_member((thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00")),
     rule(9),
     ['Right' = (thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Member' = expiresAt(insight, "2025-10-05T22:33:48.907185+00:00")],
     [context_member((thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"))]).
step(context_member((thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00")),
     rule(9),
     ['Right' = (thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Member' = expiresAt(insight, "2025-10-05T22:33:48.907185+00:00")],
     [context_member((thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"))]).
step(context_member((thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00")),
     rule(9),
     ['Right' = (suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Member' = expiresAt(insight, "2025-10-05T22:33:48.907185+00:00")],
     [context_member((suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"))]).
step(context_member((suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00")),
     rule(9),
     ['Right' = (scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Member' = expiresAt(insight, "2025-10-05T22:33:48.907185+00:00")],
     [context_member((scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"))]).
step(context_member((scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00")),
     rule(9),
     ['Right' = (scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Member' = expiresAt(insight, "2025-10-05T22:33:48.907185+00:00")],
     [context_member((scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"))]).
step(context_member((scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00")),
     rule(9),
     ['Right' = (retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Member' = expiresAt(insight, "2025-10-05T22:33:48.907185+00:00")],
     [context_member((retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"))]).
step(context_member((retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00")),
     rule(9),
     ['Right' = (createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Member' = expiresAt(insight, "2025-10-05T22:33:48.907185+00:00")],
     [context_member((createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"))]).
step(context_member((createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00")),
     rule(9),
     ['Right' = (expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Member' = expiresAt(insight, "2025-10-05T22:33:48.907185+00:00")],
     [context_member((expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"))]).
step(context_member((expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00")),
     rule(8),
     ['Left' = expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"),
      'Member' = expiresAt(insight, "2025-10-05T22:33:48.907185+00:00")],
     [context_member(expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"))]).
step(context_member(expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00")),
     rule(10),
     ['Member' = expiresAt(insight, "2025-10-05T22:33:48.907185+00:00")],
     [expiresAt(insight, "2025-10-05T22:33:48.907185+00:00") \= (_left, _right)]).
step(expiresAt(insight, "2025-10-05T22:33:48.907185+00:00") \= (_left, _right), builtin, [], []).
step(expiresAt(insight, "2025-10-05T22:33:48.907185+00:00") =.. [expiresAt, insight, "2025-10-05T22:33:48.907185+00:00"],
     builtin,
     [],
     []).
step("2025-10-05T20:35:48.907163+00:00" @=< "2025-10-05T22:33:48.907185+00:00", builtin, [], []).
step(target(decision, insight),
     rule(80),
     ['Target' = insight],
     [decision(decision, "Allowed", insight)]).
step(scannedProduct(scan, "Classic Tea Biscuits"),
     rule(81),
     ['Productname' = "Classic Tea Biscuits", 'Product' = prod_BIS_001],
     [scanned_product(scan, prod_BIS_001), product_name(prod_BIS_001, "Classic Tea Biscuits")]).
step(scanned_product(scan, prod_BIS_001),
     rule(26),
     ['Product' = prod_BIS_001],
     [case_statement(scan, scannedProduct, prod_BIS_001)]).
step(case_statement(scan, scannedProduct, prod_BIS_001),
     rule(11),
     ['S' = scan,
      'P' = scannedProduct,
      'O' = prod_BIS_001,
      'Context' = (caseName(case, "delfour"), requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Statement' = scannedProduct(scan, prod_BIS_001)],
     [case_graph(delfourCaseGraph, (caseName(case, "delfour"), requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001))),
      context_member((caseName(case, "delfour"), requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannedProduct(scan, prod_BIS_001)),
      scannedProduct(scan, prod_BIS_001) =.. [scannedProduct, scan, prod_BIS_001]]).
step(context_member((caseName(case, "delfour"), requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannedProduct(scan, prod_BIS_001)),
     rule(9),
     ['Right' = (requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = scannedProduct(scan, prod_BIS_001)],
     [context_member((requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannedProduct(scan, prod_BIS_001))]).
step(context_member((requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannedProduct(scan, prod_BIS_001)),
     rule(9),
     ['Right' = (requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = scannedProduct(scan, prod_BIS_001)],
     [context_member((requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannedProduct(scan, prod_BIS_001))]).
step(context_member((requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannedProduct(scan, prod_BIS_001)),
     rule(9),
     ['Right' = (phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = scannedProduct(scan, prod_BIS_001)],
     [context_member((phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannedProduct(scan, prod_BIS_001))]).
step(context_member((phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannedProduct(scan, prod_BIS_001)),
     rule(9),
     ['Right' = (phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = scannedProduct(scan, prod_BIS_001)],
     [context_member((phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannedProduct(scan, prod_BIS_001))]).
step(context_member((phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannedProduct(scan, prod_BIS_001)),
     rule(9),
     ['Right' = (scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = scannedProduct(scan, prod_BIS_001)],
     [context_member((scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannedProduct(scan, prod_BIS_001))]).
step(context_member((scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannedProduct(scan, prod_BIS_001)),
     rule(9),
     ['Right' = (scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = scannedProduct(scan, prod_BIS_001)],
     [context_member((scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannedProduct(scan, prod_BIS_001))]).
step(context_member((scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannedProduct(scan, prod_BIS_001)),
     rule(9),
     ['Right' = (filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = scannedProduct(scan, prod_BIS_001)],
     [context_member((filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannedProduct(scan, prod_BIS_001))]).
step(context_member((filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannedProduct(scan, prod_BIS_001)),
     rule(9),
     ['Right' = (auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = scannedProduct(scan, prod_BIS_001)],
     [context_member((auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannedProduct(scan, prod_BIS_001))]).
step(context_member((auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannedProduct(scan, prod_BIS_001)),
     rule(9),
     ['Right' = (condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = scannedProduct(scan, prod_BIS_001)],
     [context_member((condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannedProduct(scan, prod_BIS_001))]).
step(context_member((condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannedProduct(scan, prod_BIS_001)),
     rule(9),
     ['Right' = scannedProduct(scan, prod_BIS_001),
      'Member' = scannedProduct(scan, prod_BIS_001)],
     [context_member(scannedProduct(scan, prod_BIS_001), scannedProduct(scan, prod_BIS_001))]).
step(context_member(scannedProduct(scan, prod_BIS_001), scannedProduct(scan, prod_BIS_001)),
     rule(10),
     ['Member' = scannedProduct(scan, prod_BIS_001)],
     [scannedProduct(scan, prod_BIS_001) \= (_left, _right)]).
step(scannedProduct(scan, prod_BIS_001) \= (_left, _right), builtin, [], []).
step(scannedProduct(scan, prod_BIS_001) =.. [scannedProduct, scan, prod_BIS_001],
     builtin,
     [],
     []).
step(product_name(prod_BIS_001, "Classic Tea Biscuits"),
     rule(29),
     ['Product' = prod_BIS_001,
      'Name' = "Classic Tea Biscuits",
      'Products' = [product(prod_BIS_001, "prod_BIS_001", "Classic Tea Biscuits", 120, 12.0), product(prod_BIS_101, "prod_BIS_101", "Low-Sugar Tea Biscuits", 30, 3.0), product(prod_CHOC_050, "prod_CHOC_050", "Milk Chocolate Bar", 150, 15.0), product(prod_CHOC_150, "prod_CHOC_150", "85% Dark Chocolate", 60, 6.0)]],
     [product_catalog(delfourCatalog, [product(prod_BIS_001, "prod_BIS_001", "Classic Tea Biscuits", 120, 12.0), product(prod_BIS_101, "prod_BIS_101", "Low-Sugar Tea Biscuits", 30, 3.0), product(prod_CHOC_050, "prod_CHOC_050", "Milk Chocolate Bar", 150, 15.0), product(prod_CHOC_150, "prod_CHOC_150", "85% Dark Chocolate", 60, 6.0)]),
      member(product(prod_BIS_001, "prod_BIS_001", "Classic Tea Biscuits", 120, 12.0), [product(prod_BIS_001, "prod_BIS_001", "Classic Tea Biscuits", 120, 12.0), product(prod_BIS_101, "prod_BIS_101", "Low-Sugar Tea Biscuits", 30, 3.0), product(prod_CHOC_050, "prod_CHOC_050", "Milk Chocolate Bar", 150, 15.0), product(prod_CHOC_150, "prod_CHOC_150", "85% Dark Chocolate", 60, 6.0)])]).
step(product_catalog(delfourCatalog, [product(prod_BIS_001, "prod_BIS_001", "Classic Tea Biscuits", 120, 12.0), product(prod_BIS_101, "prod_BIS_101", "Low-Sugar Tea Biscuits", 30, 3.0), product(prod_CHOC_050, "prod_CHOC_050", "Milk Chocolate Bar", 150, 15.0), product(prod_CHOC_150, "prod_CHOC_150", "85% Dark Chocolate", 60, 6.0)]),
     fact(2),
     [],
     []).
step(member(product(prod_BIS_001, "prod_BIS_001", "Classic Tea Biscuits", 120, 12.0), [product(prod_BIS_001, "prod_BIS_001", "Classic Tea Biscuits", 120, 12.0), product(prod_BIS_101, "prod_BIS_101", "Low-Sugar Tea Biscuits", 30, 3.0), product(prod_CHOC_050, "prod_CHOC_050", "Milk Chocolate Bar", 150, 15.0), product(prod_CHOC_150, "prod_CHOC_150", "85% Dark Chocolate", 60, 6.0)]),
     builtin,
     [],
     []).
step(suggestedAlternative(case, "Low-Sugar Tea Biscuits"),
     rule(82),
     ['Name' = "Low-Sugar Tea Biscuits", 'Alternative' = prod_BIS_101],
     [suggested_alternative(case, prod_BIS_101),
      product_name(prod_BIS_101, "Low-Sugar Tea Biscuits")]).
step(suggested_alternative(case, prod_BIS_101),
     rule(69),
     ['Candidate' = prod_BIS_101,
      'Scanned' = prod_BIS_001,
      'Scannedsugar' = 120,
      'Candidatesugar' = 30],
     [scanned_product(scan, prod_BIS_001),
      sugar_tenths(prod_BIS_001, 120),
      product(prod_BIS_101),
      sugar_tenths(prod_BIS_101, 30),
      120 > 30,
      \+ better_lower_sugar(120, 30)]).
step(sugar_tenths(prod_BIS_001, 120),
     rule(30),
     ['Product' = prod_BIS_001,
      'Sugar' = 120,
      'Products' = [product(prod_BIS_001, "prod_BIS_001", "Classic Tea Biscuits", 120, 12.0), product(prod_BIS_101, "prod_BIS_101", "Low-Sugar Tea Biscuits", 30, 3.0), product(prod_CHOC_050, "prod_CHOC_050", "Milk Chocolate Bar", 150, 15.0), product(prod_CHOC_150, "prod_CHOC_150", "85% Dark Chocolate", 60, 6.0)]],
     [product_catalog(delfourCatalog, [product(prod_BIS_001, "prod_BIS_001", "Classic Tea Biscuits", 120, 12.0), product(prod_BIS_101, "prod_BIS_101", "Low-Sugar Tea Biscuits", 30, 3.0), product(prod_CHOC_050, "prod_CHOC_050", "Milk Chocolate Bar", 150, 15.0), product(prod_CHOC_150, "prod_CHOC_150", "85% Dark Chocolate", 60, 6.0)]),
      member(product(prod_BIS_001, "prod_BIS_001", "Classic Tea Biscuits", 120, 12.0), [product(prod_BIS_001, "prod_BIS_001", "Classic Tea Biscuits", 120, 12.0), product(prod_BIS_101, "prod_BIS_101", "Low-Sugar Tea Biscuits", 30, 3.0), product(prod_CHOC_050, "prod_CHOC_050", "Milk Chocolate Bar", 150, 15.0), product(prod_CHOC_150, "prod_CHOC_150", "85% Dark Chocolate", 60, 6.0)])]).
step(product(prod_BIS_101),
     rule(27),
     ['Product' = prod_BIS_101,
      'Products' = [product(prod_BIS_001, "prod_BIS_001", "Classic Tea Biscuits", 120, 12.0), product(prod_BIS_101, "prod_BIS_101", "Low-Sugar Tea Biscuits", 30, 3.0), product(prod_CHOC_050, "prod_CHOC_050", "Milk Chocolate Bar", 150, 15.0), product(prod_CHOC_150, "prod_CHOC_150", "85% Dark Chocolate", 60, 6.0)]],
     [product_catalog(delfourCatalog, [product(prod_BIS_001, "prod_BIS_001", "Classic Tea Biscuits", 120, 12.0), product(prod_BIS_101, "prod_BIS_101", "Low-Sugar Tea Biscuits", 30, 3.0), product(prod_CHOC_050, "prod_CHOC_050", "Milk Chocolate Bar", 150, 15.0), product(prod_CHOC_150, "prod_CHOC_150", "85% Dark Chocolate", 60, 6.0)]),
      member(product(prod_BIS_101, "prod_BIS_101", "Low-Sugar Tea Biscuits", 30, 3.0), [product(prod_BIS_001, "prod_BIS_001", "Classic Tea Biscuits", 120, 12.0), product(prod_BIS_101, "prod_BIS_101", "Low-Sugar Tea Biscuits", 30, 3.0), product(prod_CHOC_050, "prod_CHOC_050", "Milk Chocolate Bar", 150, 15.0), product(prod_CHOC_150, "prod_CHOC_150", "85% Dark Chocolate", 60, 6.0)])]).
step(member(product(prod_BIS_101, "prod_BIS_101", "Low-Sugar Tea Biscuits", 30, 3.0), [product(prod_BIS_001, "prod_BIS_001", "Classic Tea Biscuits", 120, 12.0), product(prod_BIS_101, "prod_BIS_101", "Low-Sugar Tea Biscuits", 30, 3.0), product(prod_CHOC_050, "prod_CHOC_050", "Milk Chocolate Bar", 150, 15.0), product(prod_CHOC_150, "prod_CHOC_150", "85% Dark Chocolate", 60, 6.0)]),
     builtin,
     [],
     []).
step(sugar_tenths(prod_BIS_101, 30),
     rule(30),
     ['Product' = prod_BIS_101,
      'Sugar' = 30,
      'Products' = [product(prod_BIS_001, "prod_BIS_001", "Classic Tea Biscuits", 120, 12.0), product(prod_BIS_101, "prod_BIS_101", "Low-Sugar Tea Biscuits", 30, 3.0), product(prod_CHOC_050, "prod_CHOC_050", "Milk Chocolate Bar", 150, 15.0), product(prod_CHOC_150, "prod_CHOC_150", "85% Dark Chocolate", 60, 6.0)]],
     [product_catalog(delfourCatalog, [product(prod_BIS_001, "prod_BIS_001", "Classic Tea Biscuits", 120, 12.0), product(prod_BIS_101, "prod_BIS_101", "Low-Sugar Tea Biscuits", 30, 3.0), product(prod_CHOC_050, "prod_CHOC_050", "Milk Chocolate Bar", 150, 15.0), product(prod_CHOC_150, "prod_CHOC_150", "85% Dark Chocolate", 60, 6.0)]),
      member(product(prod_BIS_101, "prod_BIS_101", "Low-Sugar Tea Biscuits", 30, 3.0), [product(prod_BIS_001, "prod_BIS_001", "Classic Tea Biscuits", 120, 12.0), product(prod_BIS_101, "prod_BIS_101", "Low-Sugar Tea Biscuits", 30, 3.0), product(prod_CHOC_050, "prod_CHOC_050", "Milk Chocolate Bar", 150, 15.0), product(prod_CHOC_150, "prod_CHOC_150", "85% Dark Chocolate", 60, 6.0)])]).
step(120 > 30, builtin, [], []).
step(\+ better_lower_sugar(120, 30), absent, [], []).
step(product_name(prod_BIS_101, "Low-Sugar Tea Biscuits"),
     rule(29),
     ['Product' = prod_BIS_101,
      'Name' = "Low-Sugar Tea Biscuits",
      'Products' = [product(prod_BIS_001, "prod_BIS_001", "Classic Tea Biscuits", 120, 12.0), product(prod_BIS_101, "prod_BIS_101", "Low-Sugar Tea Biscuits", 30, 3.0), product(prod_CHOC_050, "prod_CHOC_050", "Milk Chocolate Bar", 150, 15.0), product(prod_CHOC_150, "prod_CHOC_150", "85% Dark Chocolate", 60, 6.0)]],
     [product_catalog(delfourCatalog, [product(prod_BIS_001, "prod_BIS_001", "Classic Tea Biscuits", 120, 12.0), product(prod_BIS_101, "prod_BIS_101", "Low-Sugar Tea Biscuits", 30, 3.0), product(prod_CHOC_050, "prod_CHOC_050", "Milk Chocolate Bar", 150, 15.0), product(prod_CHOC_150, "prod_CHOC_150", "85% Dark Chocolate", 60, 6.0)]),
      member(product(prod_BIS_101, "prod_BIS_101", "Low-Sugar Tea Biscuits", 30, 3.0), [product(prod_BIS_001, "prod_BIS_001", "Classic Tea Biscuits", 120, 12.0), product(prod_BIS_101, "prod_BIS_101", "Low-Sugar Tea Biscuits", 30, 3.0), product(prod_CHOC_050, "prod_CHOC_050", "Milk Chocolate Bar", 150, 15.0), product(prod_CHOC_150, "prod_CHOC_150", "85% Dark Chocolate", 60, 6.0)])]).
step(suggestedAlternative(banner, "Low-Sugar Tea Biscuits"),
     rule(89),
     ['Name' = "Low-Sugar Tea Biscuits"],
     [banner_suggested_alternative(banner, "Low-Sugar Tea Biscuits")]).
step(banner_suggested_alternative(banner, "Low-Sugar Tea Biscuits"),
     rule(70),
     ['Name' = "Low-Sugar Tea Biscuits", 'Alternative' = prod_BIS_101],
     [banner_note(banner, "High sugar"),
      suggested_alternative(case, prod_BIS_101),
      product_name(prod_BIS_101, "Low-Sugar Tea Biscuits")]).
step(banner_note(banner, "High sugar"), rule(67), [], [banner_flags_high_sugar(check)]).
step(banner_flags_high_sugar(check),
     rule(65),
     ['Product' = prod_BIS_001, 'Sugar' = 12.0, 'Threshold' = 10.0],
     [decision(decision, "Allowed", insight),
      scanned_product(scan, prod_BIS_001),
      sugar_per_serving(prod_BIS_001, 12.0),
      threshold_g(insight, 10.0),
      12.0 >= 10.0]).
step(sugar_per_serving(prod_BIS_001, 12.0),
     rule(31),
     ['Product' = prod_BIS_001,
      'Sugar' = 12.0,
      'Products' = [product(prod_BIS_001, "prod_BIS_001", "Classic Tea Biscuits", 120, 12.0), product(prod_BIS_101, "prod_BIS_101", "Low-Sugar Tea Biscuits", 30, 3.0), product(prod_CHOC_050, "prod_CHOC_050", "Milk Chocolate Bar", 150, 15.0), product(prod_CHOC_150, "prod_CHOC_150", "85% Dark Chocolate", 60, 6.0)]],
     [product_catalog(delfourCatalog, [product(prod_BIS_001, "prod_BIS_001", "Classic Tea Biscuits", 120, 12.0), product(prod_BIS_101, "prod_BIS_101", "Low-Sugar Tea Biscuits", 30, 3.0), product(prod_CHOC_050, "prod_CHOC_050", "Milk Chocolate Bar", 150, 15.0), product(prod_CHOC_150, "prod_CHOC_150", "85% Dark Chocolate", 60, 6.0)]),
      member(product(prod_BIS_001, "prod_BIS_001", "Classic Tea Biscuits", 120, 12.0), [product(prod_BIS_001, "prod_BIS_001", "Classic Tea Biscuits", 120, 12.0), product(prod_BIS_101, "prod_BIS_101", "Low-Sugar Tea Biscuits", 30, 3.0), product(prod_CHOC_050, "prod_CHOC_050", "Milk Chocolate Bar", 150, 15.0), product(prod_CHOC_150, "prod_CHOC_150", "85% Dark Chocolate", 60, 6.0)])]).
step(threshold_g(insight, 10.0),
     rule(36),
     ['Threshold' = 10.0],
     [insight_statement(insight, thresholdG, 10.0)]).
step(insight_statement(insight, thresholdG, 10.0),
     rule(12),
     ['S' = insight,
      'P' = thresholdG,
      'O' = 10.0,
      'Context' = (metric(insight, "sugar_g_per_serving"), thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Statement' = thresholdG(insight, 10.0)],
     [insight_graph(delfourInsightGraph, (metric(insight, "sugar_g_per_serving"), thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner'))),
      context_member((metric(insight, "sugar_g_per_serving"), thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), thresholdG(insight, 10.0)),
      thresholdG(insight, 10.0) =.. [thresholdG, insight, 10.0]]).
step(context_member((metric(insight, "sugar_g_per_serving"), thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), thresholdG(insight, 10.0)),
     rule(9),
     ['Right' = (thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Member' = thresholdG(insight, 10.0)],
     [context_member((thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), thresholdG(insight, 10.0))]).
step(context_member((thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), thresholdG(insight, 10.0)),
     rule(9),
     ['Right' = (thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Member' = thresholdG(insight, 10.0)],
     [context_member((thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), thresholdG(insight, 10.0))]).
step(context_member((thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), thresholdG(insight, 10.0)),
     rule(9),
     ['Right' = (thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Member' = thresholdG(insight, 10.0)],
     [context_member((thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), thresholdG(insight, 10.0))]).
step(context_member((thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), thresholdG(insight, 10.0)),
     rule(8),
     ['Left' = thresholdG(insight, 10.0), 'Member' = thresholdG(insight, 10.0)],
     [context_member(thresholdG(insight, 10.0), thresholdG(insight, 10.0))]).
step(context_member(thresholdG(insight, 10.0), thresholdG(insight, 10.0)),
     rule(10),
     ['Member' = thresholdG(insight, 10.0)],
     [thresholdG(insight, 10.0) \= (_left, _right)]).
step(thresholdG(insight, 10.0) \= (_left, _right), builtin, [], []).
step(thresholdG(insight, 10.0) =.. [thresholdG, insight, 10.0], builtin, [], []).
step(12.0 >= 10.0, builtin, [], []).
step(threshold(insight, "10.0"),
     rule(83),
     ['Threshold' = "10.0"],
     [threshold_display(insight, "10.0")]).
step(threshold_display(insight, "10.0"),
     rule(35),
     ['Threshold' = "10.0"],
     [insight_statement(insight, thresholdDisplay, "10.0")]).
step(insight_statement(insight, thresholdDisplay, "10.0"),
     rule(12),
     ['S' = insight,
      'P' = thresholdDisplay,
      'O' = "10.0",
      'Context' = (metric(insight, "sugar_g_per_serving"), thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Statement' = thresholdDisplay(insight, "10.0")],
     [insight_graph(delfourInsightGraph, (metric(insight, "sugar_g_per_serving"), thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner'))),
      context_member((metric(insight, "sugar_g_per_serving"), thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), thresholdDisplay(insight, "10.0")),
      thresholdDisplay(insight, "10.0") =.. [thresholdDisplay, insight, "10.0"]]).
step(context_member((metric(insight, "sugar_g_per_serving"), thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), thresholdDisplay(insight, "10.0")),
     rule(9),
     ['Right' = (thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Member' = thresholdDisplay(insight, "10.0")],
     [context_member((thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), thresholdDisplay(insight, "10.0"))]).
step(context_member((thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), thresholdDisplay(insight, "10.0")),
     rule(9),
     ['Right' = (thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Member' = thresholdDisplay(insight, "10.0")],
     [context_member((thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), thresholdDisplay(insight, "10.0"))]).
step(context_member((thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), thresholdDisplay(insight, "10.0")),
     rule(8),
     ['Left' = thresholdDisplay(insight, "10.0"), 'Member' = thresholdDisplay(insight, "10.0")],
     [context_member(thresholdDisplay(insight, "10.0"), thresholdDisplay(insight, "10.0"))]).
step(context_member(thresholdDisplay(insight, "10.0"), thresholdDisplay(insight, "10.0")),
     rule(10),
     ['Member' = thresholdDisplay(insight, "10.0")],
     [thresholdDisplay(insight, "10.0") \= (_left, _right)]).
step(thresholdDisplay(insight, "10.0") \= (_left, _right), builtin, [], []).
step(thresholdDisplay(insight, "10.0") =.. [thresholdDisplay, insight, "10.0"], builtin, [], []).
step(scope(insight, "self-scanner @ pick_up_scanner"),
     rule(84),
     [],
     [scope_device(insight, "self-scanner"), scope_event(insight, "pick_up_scanner")]).
step(scope_device(insight, "self-scanner"),
     rule(38),
     ['Device' = "self-scanner"],
     [insight_statement(insight, scopeDevice, "self-scanner")]).
step(insight_statement(insight, scopeDevice, "self-scanner"),
     rule(12),
     ['S' = insight,
      'P' = scopeDevice,
      'O' = "self-scanner",
      'Context' = (metric(insight, "sugar_g_per_serving"), thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Statement' = scopeDevice(insight, "self-scanner")],
     [insight_graph(delfourInsightGraph, (metric(insight, "sugar_g_per_serving"), thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner'))),
      context_member((metric(insight, "sugar_g_per_serving"), thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), scopeDevice(insight, "self-scanner")),
      scopeDevice(insight, "self-scanner") =.. [scopeDevice, insight, "self-scanner"]]).
step(context_member((metric(insight, "sugar_g_per_serving"), thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), scopeDevice(insight, "self-scanner")),
     rule(9),
     ['Right' = (thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Member' = scopeDevice(insight, "self-scanner")],
     [context_member((thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), scopeDevice(insight, "self-scanner"))]).
step(context_member((thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), scopeDevice(insight, "self-scanner")),
     rule(9),
     ['Right' = (thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Member' = scopeDevice(insight, "self-scanner")],
     [context_member((thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), scopeDevice(insight, "self-scanner"))]).
step(context_member((thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), scopeDevice(insight, "self-scanner")),
     rule(9),
     ['Right' = (thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Member' = scopeDevice(insight, "self-scanner")],
     [context_member((thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), scopeDevice(insight, "self-scanner"))]).
step(context_member((thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), scopeDevice(insight, "self-scanner")),
     rule(9),
     ['Right' = (suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Member' = scopeDevice(insight, "self-scanner")],
     [context_member((suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), scopeDevice(insight, "self-scanner"))]).
step(context_member((suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), scopeDevice(insight, "self-scanner")),
     rule(9),
     ['Right' = (scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Member' = scopeDevice(insight, "self-scanner")],
     [context_member((scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), scopeDevice(insight, "self-scanner"))]).
step(context_member((scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), scopeDevice(insight, "self-scanner")),
     rule(8),
     ['Left' = scopeDevice(insight, "self-scanner"),
      'Member' = scopeDevice(insight, "self-scanner")],
     [context_member(scopeDevice(insight, "self-scanner"), scopeDevice(insight, "self-scanner"))]).
step(context_member(scopeDevice(insight, "self-scanner"), scopeDevice(insight, "self-scanner")),
     rule(10),
     ['Member' = scopeDevice(insight, "self-scanner")],
     [scopeDevice(insight, "self-scanner") \= (_left, _right)]).
step(scopeDevice(insight, "self-scanner") \= (_left, _right), builtin, [], []).
step(scopeDevice(insight, "self-scanner") =.. [scopeDevice, insight, "self-scanner"],
     builtin,
     [],
     []).
step(scope_event(insight, "pick_up_scanner"),
     rule(39),
     ['Event' = "pick_up_scanner"],
     [insight_statement(insight, scopeEvent, "pick_up_scanner")]).
step(insight_statement(insight, scopeEvent, "pick_up_scanner"),
     rule(12),
     ['S' = insight,
      'P' = scopeEvent,
      'O' = "pick_up_scanner",
      'Context' = (metric(insight, "sugar_g_per_serving"), thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Statement' = scopeEvent(insight, "pick_up_scanner")],
     [insight_graph(delfourInsightGraph, (metric(insight, "sugar_g_per_serving"), thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner'))),
      context_member((metric(insight, "sugar_g_per_serving"), thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), scopeEvent(insight, "pick_up_scanner")),
      scopeEvent(insight, "pick_up_scanner") =.. [scopeEvent, insight, "pick_up_scanner"]]).
step(context_member((metric(insight, "sugar_g_per_serving"), thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), scopeEvent(insight, "pick_up_scanner")),
     rule(9),
     ['Right' = (thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Member' = scopeEvent(insight, "pick_up_scanner")],
     [context_member((thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), scopeEvent(insight, "pick_up_scanner"))]).
step(context_member((thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), scopeEvent(insight, "pick_up_scanner")),
     rule(9),
     ['Right' = (thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Member' = scopeEvent(insight, "pick_up_scanner")],
     [context_member((thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), scopeEvent(insight, "pick_up_scanner"))]).
step(context_member((thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), scopeEvent(insight, "pick_up_scanner")),
     rule(9),
     ['Right' = (thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Member' = scopeEvent(insight, "pick_up_scanner")],
     [context_member((thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), scopeEvent(insight, "pick_up_scanner"))]).
step(context_member((thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), scopeEvent(insight, "pick_up_scanner")),
     rule(9),
     ['Right' = (suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Member' = scopeEvent(insight, "pick_up_scanner")],
     [context_member((suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), scopeEvent(insight, "pick_up_scanner"))]).
step(context_member((suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), scopeEvent(insight, "pick_up_scanner")),
     rule(9),
     ['Right' = (scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Member' = scopeEvent(insight, "pick_up_scanner")],
     [context_member((scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), scopeEvent(insight, "pick_up_scanner"))]).
step(context_member((scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), scopeEvent(insight, "pick_up_scanner")),
     rule(9),
     ['Right' = (scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Member' = scopeEvent(insight, "pick_up_scanner")],
     [context_member((scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), scopeEvent(insight, "pick_up_scanner"))]).
step(context_member((scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), scopeEvent(insight, "pick_up_scanner")),
     rule(8),
     ['Left' = scopeEvent(insight, "pick_up_scanner"),
      'Member' = scopeEvent(insight, "pick_up_scanner")],
     [context_member(scopeEvent(insight, "pick_up_scanner"), scopeEvent(insight, "pick_up_scanner"))]).
step(context_member(scopeEvent(insight, "pick_up_scanner"), scopeEvent(insight, "pick_up_scanner")),
     rule(10),
     ['Member' = scopeEvent(insight, "pick_up_scanner")],
     [scopeEvent(insight, "pick_up_scanner") \= (_left, _right)]).
step(scopeEvent(insight, "pick_up_scanner") \= (_left, _right), builtin, [], []).
step(scopeEvent(insight, "pick_up_scanner") =.. [scopeEvent, insight, "pick_up_scanner"],
     builtin,
     [],
     []).
step(expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"),
     rule(85),
     ['Time' = "2025-10-05T22:33:48.907185+00:00"],
     [expires_at(insight, "2025-10-05T22:33:48.907185+00:00")]).
step(reason(why, "The phone desensitizes a diabetes-related household condition into a scoped low-sugar need, wraps it in an expiring Insight + Policy envelope, signs it, and the scanner consumes that envelope for shopping assistance."),
     rule(86),
     [],
     [authorization_allowed(check)]).
step(headline(banner, "Track sugar per serving while you scan"),
     rule(87),
     ['Headline' = "Track sugar per serving while you scan"],
     [banner_headline(banner, "Track sugar per serving while you scan")]).
step(banner_headline(banner, "Track sugar per serving while you scan"),
     rule(66),
     [],
     [banner_flags_high_sugar(check)]).
step(note(banner, "High sugar"),
     rule(88),
     ['Note' = "High sugar"],
     [banner_note(banner, "High sugar")]).
step(value(reasonText, "Household requires low-sugar guidance (diabetes in POD). A neutral Insight is scoped to device 'self-scanner', event 'pick_up_scanner', retailer 'Delfour', and expires soon; the policy confines use to shopping assistance."),
     rule(90),
     ['Text' = "Household requires low-sugar guidance (diabetes in POD). A neutral Insight is scoped to device 'self-scanner', event 'pick_up_scanner', retailer 'Delfour', and expires soon; the policy confines use to shopping assistance."],
     [reason_text(reasonText, "Household requires low-sugar guidance (diabetes in POD). A neutral Insight is scoped to device 'self-scanner', event 'pick_up_scanner', retailer 'Delfour', and expires soon; the policy confines use to shopping assistance.")]).
step(reason_text(reasonText, "Household requires low-sugar guidance (diabetes in POD). A neutral Insight is scoped to device 'self-scanner', event 'pick_up_scanner', retailer 'Delfour', and expires soon; the policy confines use to shopping assistance."),
     fact(7),
     [],
     []).
step(alg(signature, "HMAC-SHA256"),
     rule(91),
     ['Alg' = "HMAC-SHA256"],
     [signature_alg(signature, "HMAC-SHA256")]).
step(signature_alg(signature, "HMAC-SHA256"),
     rule(51),
     ['Alg' = "HMAC-SHA256"],
     [signature_statement(signature, alg, "HMAC-SHA256")]).
step(signature_statement(signature, alg, "HMAC-SHA256"),
     rule(15),
     ['S' = signature,
      'P' = alg,
      'O' = "HMAC-SHA256",
      'Context' = (alg(signature, "HMAC-SHA256"), keyid(signature, "demo-shared-secret"), created(signature, "2025-10-05T20:33:48.907163+00:00"), payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"), hmac(signature, "b21d0072d90112a9f820aced0286889f4b6ef92b145e6fdef1011f3bfa4608c2"), hmacVerificationMode(signature, trustedPrecomputedInput)),
      'Statement' = alg(signature, "HMAC-SHA256")],
     [signature_graph(delfourSignatureGraph, (alg(signature, "HMAC-SHA256"), keyid(signature, "demo-shared-secret"), created(signature, "2025-10-05T20:33:48.907163+00:00"), payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"), hmac(signature, "b21d0072d90112a9f820aced0286889f4b6ef92b145e6fdef1011f3bfa4608c2"), hmacVerificationMode(signature, trustedPrecomputedInput))),
      context_member((alg(signature, "HMAC-SHA256"), keyid(signature, "demo-shared-secret"), created(signature, "2025-10-05T20:33:48.907163+00:00"), payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"), hmac(signature, "b21d0072d90112a9f820aced0286889f4b6ef92b145e6fdef1011f3bfa4608c2"), hmacVerificationMode(signature, trustedPrecomputedInput)), alg(signature, "HMAC-SHA256")),
      alg(signature, "HMAC-SHA256") =.. [alg, signature, "HMAC-SHA256"]]).
step(signature_graph(delfourSignatureGraph, (alg(signature, "HMAC-SHA256"), keyid(signature, "demo-shared-secret"), created(signature, "2025-10-05T20:33:48.907163+00:00"), payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"), hmac(signature, "b21d0072d90112a9f820aced0286889f4b6ef92b145e6fdef1011f3bfa4608c2"), hmacVerificationMode(signature, trustedPrecomputedInput))),
     fact(6),
     [],
     []).
step(context_member((alg(signature, "HMAC-SHA256"), keyid(signature, "demo-shared-secret"), created(signature, "2025-10-05T20:33:48.907163+00:00"), payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"), hmac(signature, "b21d0072d90112a9f820aced0286889f4b6ef92b145e6fdef1011f3bfa4608c2"), hmacVerificationMode(signature, trustedPrecomputedInput)), alg(signature, "HMAC-SHA256")),
     rule(8),
     ['Left' = alg(signature, "HMAC-SHA256"), 'Member' = alg(signature, "HMAC-SHA256")],
     [context_member(alg(signature, "HMAC-SHA256"), alg(signature, "HMAC-SHA256"))]).
step(context_member(alg(signature, "HMAC-SHA256"), alg(signature, "HMAC-SHA256")),
     rule(10),
     ['Member' = alg(signature, "HMAC-SHA256")],
     [alg(signature, "HMAC-SHA256") \= (_left, _right)]).
step(alg(signature, "HMAC-SHA256") \= (_left, _right), builtin, [], []).
step(alg(signature, "HMAC-SHA256") =.. [alg, signature, "HMAC-SHA256"], builtin, [], []).
step(auditEntries(case, 1), rule(92), ['Count' = 1], [audit_entries(case, 1)]).
step(audit_entries(case, 1), rule(24), ['Count' = 1], [case_statement(case, auditEntries, 1)]).
step(case_statement(case, auditEntries, 1),
     rule(11),
     ['S' = case,
      'P' = auditEntries,
      'O' = 1,
      'Context' = (caseName(case, "delfour"), requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Statement' = auditEntries(case, 1)],
     [case_graph(delfourCaseGraph, (caseName(case, "delfour"), requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001))),
      context_member((caseName(case, "delfour"), requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), auditEntries(case, 1)),
      auditEntries(case, 1) =.. [auditEntries, case, 1]]).
step(context_member((caseName(case, "delfour"), requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), auditEntries(case, 1)),
     rule(9),
     ['Right' = (requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = auditEntries(case, 1)],
     [context_member((requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), auditEntries(case, 1))]).
step(context_member((requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), auditEntries(case, 1)),
     rule(9),
     ['Right' = (requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = auditEntries(case, 1)],
     [context_member((requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), auditEntries(case, 1))]).
step(context_member((requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), auditEntries(case, 1)),
     rule(9),
     ['Right' = (phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = auditEntries(case, 1)],
     [context_member((phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), auditEntries(case, 1))]).
step(context_member((phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), auditEntries(case, 1)),
     rule(9),
     ['Right' = (phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = auditEntries(case, 1)],
     [context_member((phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), auditEntries(case, 1))]).
step(context_member((phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), auditEntries(case, 1)),
     rule(9),
     ['Right' = (scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = auditEntries(case, 1)],
     [context_member((scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), auditEntries(case, 1))]).
step(context_member((scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), auditEntries(case, 1)),
     rule(9),
     ['Right' = (scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = auditEntries(case, 1)],
     [context_member((scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), auditEntries(case, 1))]).
step(context_member((scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), auditEntries(case, 1)),
     rule(9),
     ['Right' = (filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = auditEntries(case, 1)],
     [context_member((filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), auditEntries(case, 1))]).
step(context_member((filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), auditEntries(case, 1)),
     rule(9),
     ['Right' = (auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = auditEntries(case, 1)],
     [context_member((auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), auditEntries(case, 1))]).
step(context_member((auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), auditEntries(case, 1)),
     rule(8),
     ['Left' = auditEntries(case, 1), 'Member' = auditEntries(case, 1)],
     [context_member(auditEntries(case, 1), auditEntries(case, 1))]).
step(context_member(auditEntries(case, 1), auditEntries(case, 1)),
     rule(10),
     ['Member' = auditEntries(case, 1)],
     [auditEntries(case, 1) \= (_left, _right)]).
step(auditEntries(case, 1) \= (_left, _right), builtin, [], []).
step(auditEntries(case, 1) =.. [auditEntries, case, 1], builtin, [], []).
step(filesWritten(case, 6), rule(93), ['Count' = 6], [files_written(case, 6)]).
step(files_written(case, 6), rule(23), ['Count' = 6], [case_statement(case, filesWritten, 6)]).
step(case_statement(case, filesWritten, 6),
     rule(11),
     ['S' = case,
      'P' = filesWritten,
      'O' = 6,
      'Context' = (caseName(case, "delfour"), requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Statement' = filesWritten(case, 6)],
     [case_graph(delfourCaseGraph, (caseName(case, "delfour"), requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001))),
      context_member((caseName(case, "delfour"), requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), filesWritten(case, 6)),
      filesWritten(case, 6) =.. [filesWritten, case, 6]]).
step(context_member((caseName(case, "delfour"), requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), filesWritten(case, 6)),
     rule(9),
     ['Right' = (requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = filesWritten(case, 6)],
     [context_member((requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), filesWritten(case, 6))]).
step(context_member((requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), filesWritten(case, 6)),
     rule(9),
     ['Right' = (requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = filesWritten(case, 6)],
     [context_member((requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), filesWritten(case, 6))]).
step(context_member((requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), filesWritten(case, 6)),
     rule(9),
     ['Right' = (phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = filesWritten(case, 6)],
     [context_member((phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), filesWritten(case, 6))]).
step(context_member((phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), filesWritten(case, 6)),
     rule(9),
     ['Right' = (phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = filesWritten(case, 6)],
     [context_member((phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), filesWritten(case, 6))]).
step(context_member((phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), filesWritten(case, 6)),
     rule(9),
     ['Right' = (scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = filesWritten(case, 6)],
     [context_member((scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), filesWritten(case, 6))]).
step(context_member((scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), filesWritten(case, 6)),
     rule(9),
     ['Right' = (scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = filesWritten(case, 6)],
     [context_member((scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), filesWritten(case, 6))]).
step(context_member((scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), filesWritten(case, 6)),
     rule(9),
     ['Right' = (filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = filesWritten(case, 6)],
     [context_member((filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), filesWritten(case, 6))]).
step(context_member((filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), filesWritten(case, 6)),
     rule(8),
     ['Left' = filesWritten(case, 6), 'Member' = filesWritten(case, 6)],
     [context_member(filesWritten(case, 6), filesWritten(case, 6))]).
step(context_member(filesWritten(case, 6), filesWritten(case, 6)),
     rule(10),
     ['Member' = filesWritten(case, 6)],
     [filesWritten(case, 6) \= (_left, _right)]).
step(filesWritten(case, 6) \= (_left, _right), builtin, [], []).
step(filesWritten(case, 6) =.. [filesWritten, case, 6], builtin, [], []).
step(allChecksPass(result, true), rule(94), [], [all_checks_pass(result)]).
step(all_checks_pass(result),
     rule(75),
     [],
     [signature_verifies(check),
      payload_hash_matches(check),
      minimization_strips_sensitive_terms(check),
      scope_complete(check),
      authorization_allowed(check),
      banner_flags_high_sugar(check),
      alternative_is_lower_sugar(check),
      duty_timing_consistent(check),
      marketing_prohibited(check),
      files_written_expected(check)]).
step(signature_verifies(check),
     rule(60),
     [],
     [hmac_verification_mode(signature, trustedPrecomputedInput)]).
step(hmac_verification_mode(signature, trustedPrecomputedInput),
     rule(56),
     ['Mode' = trustedPrecomputedInput],
     [signature_statement(signature, hmacVerificationMode, trustedPrecomputedInput)]).
step(signature_statement(signature, hmacVerificationMode, trustedPrecomputedInput),
     rule(15),
     ['S' = signature,
      'P' = hmacVerificationMode,
      'O' = trustedPrecomputedInput,
      'Context' = (alg(signature, "HMAC-SHA256"), keyid(signature, "demo-shared-secret"), created(signature, "2025-10-05T20:33:48.907163+00:00"), payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"), hmac(signature, "b21d0072d90112a9f820aced0286889f4b6ef92b145e6fdef1011f3bfa4608c2"), hmacVerificationMode(signature, trustedPrecomputedInput)),
      'Statement' = hmacVerificationMode(signature, trustedPrecomputedInput)],
     [signature_graph(delfourSignatureGraph, (alg(signature, "HMAC-SHA256"), keyid(signature, "demo-shared-secret"), created(signature, "2025-10-05T20:33:48.907163+00:00"), payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"), hmac(signature, "b21d0072d90112a9f820aced0286889f4b6ef92b145e6fdef1011f3bfa4608c2"), hmacVerificationMode(signature, trustedPrecomputedInput))),
      context_member((alg(signature, "HMAC-SHA256"), keyid(signature, "demo-shared-secret"), created(signature, "2025-10-05T20:33:48.907163+00:00"), payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"), hmac(signature, "b21d0072d90112a9f820aced0286889f4b6ef92b145e6fdef1011f3bfa4608c2"), hmacVerificationMode(signature, trustedPrecomputedInput)), hmacVerificationMode(signature, trustedPrecomputedInput)),
      hmacVerificationMode(signature, trustedPrecomputedInput) =.. [hmacVerificationMode, signature, trustedPrecomputedInput]]).
step(context_member((alg(signature, "HMAC-SHA256"), keyid(signature, "demo-shared-secret"), created(signature, "2025-10-05T20:33:48.907163+00:00"), payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"), hmac(signature, "b21d0072d90112a9f820aced0286889f4b6ef92b145e6fdef1011f3bfa4608c2"), hmacVerificationMode(signature, trustedPrecomputedInput)), hmacVerificationMode(signature, trustedPrecomputedInput)),
     rule(9),
     ['Right' = (keyid(signature, "demo-shared-secret"), created(signature, "2025-10-05T20:33:48.907163+00:00"), payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"), hmac(signature, "b21d0072d90112a9f820aced0286889f4b6ef92b145e6fdef1011f3bfa4608c2"), hmacVerificationMode(signature, trustedPrecomputedInput)),
      'Member' = hmacVerificationMode(signature, trustedPrecomputedInput)],
     [context_member((keyid(signature, "demo-shared-secret"), created(signature, "2025-10-05T20:33:48.907163+00:00"), payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"), hmac(signature, "b21d0072d90112a9f820aced0286889f4b6ef92b145e6fdef1011f3bfa4608c2"), hmacVerificationMode(signature, trustedPrecomputedInput)), hmacVerificationMode(signature, trustedPrecomputedInput))]).
step(context_member((keyid(signature, "demo-shared-secret"), created(signature, "2025-10-05T20:33:48.907163+00:00"), payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"), hmac(signature, "b21d0072d90112a9f820aced0286889f4b6ef92b145e6fdef1011f3bfa4608c2"), hmacVerificationMode(signature, trustedPrecomputedInput)), hmacVerificationMode(signature, trustedPrecomputedInput)),
     rule(9),
     ['Right' = (created(signature, "2025-10-05T20:33:48.907163+00:00"), payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"), hmac(signature, "b21d0072d90112a9f820aced0286889f4b6ef92b145e6fdef1011f3bfa4608c2"), hmacVerificationMode(signature, trustedPrecomputedInput)),
      'Member' = hmacVerificationMode(signature, trustedPrecomputedInput)],
     [context_member((created(signature, "2025-10-05T20:33:48.907163+00:00"), payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"), hmac(signature, "b21d0072d90112a9f820aced0286889f4b6ef92b145e6fdef1011f3bfa4608c2"), hmacVerificationMode(signature, trustedPrecomputedInput)), hmacVerificationMode(signature, trustedPrecomputedInput))]).
step(context_member((created(signature, "2025-10-05T20:33:48.907163+00:00"), payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"), hmac(signature, "b21d0072d90112a9f820aced0286889f4b6ef92b145e6fdef1011f3bfa4608c2"), hmacVerificationMode(signature, trustedPrecomputedInput)), hmacVerificationMode(signature, trustedPrecomputedInput)),
     rule(9),
     ['Right' = (payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"), hmac(signature, "b21d0072d90112a9f820aced0286889f4b6ef92b145e6fdef1011f3bfa4608c2"), hmacVerificationMode(signature, trustedPrecomputedInput)),
      'Member' = hmacVerificationMode(signature, trustedPrecomputedInput)],
     [context_member((payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"), hmac(signature, "b21d0072d90112a9f820aced0286889f4b6ef92b145e6fdef1011f3bfa4608c2"), hmacVerificationMode(signature, trustedPrecomputedInput)), hmacVerificationMode(signature, trustedPrecomputedInput))]).
step(context_member((payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"), hmac(signature, "b21d0072d90112a9f820aced0286889f4b6ef92b145e6fdef1011f3bfa4608c2"), hmacVerificationMode(signature, trustedPrecomputedInput)), hmacVerificationMode(signature, trustedPrecomputedInput)),
     rule(9),
     ['Right' = (hmac(signature, "b21d0072d90112a9f820aced0286889f4b6ef92b145e6fdef1011f3bfa4608c2"), hmacVerificationMode(signature, trustedPrecomputedInput)),
      'Member' = hmacVerificationMode(signature, trustedPrecomputedInput)],
     [context_member((hmac(signature, "b21d0072d90112a9f820aced0286889f4b6ef92b145e6fdef1011f3bfa4608c2"), hmacVerificationMode(signature, trustedPrecomputedInput)), hmacVerificationMode(signature, trustedPrecomputedInput))]).
step(context_member((hmac(signature, "b21d0072d90112a9f820aced0286889f4b6ef92b145e6fdef1011f3bfa4608c2"), hmacVerificationMode(signature, trustedPrecomputedInput)), hmacVerificationMode(signature, trustedPrecomputedInput)),
     rule(9),
     ['Right' = hmacVerificationMode(signature, trustedPrecomputedInput),
      'Member' = hmacVerificationMode(signature, trustedPrecomputedInput)],
     [context_member(hmacVerificationMode(signature, trustedPrecomputedInput), hmacVerificationMode(signature, trustedPrecomputedInput))]).
step(context_member(hmacVerificationMode(signature, trustedPrecomputedInput), hmacVerificationMode(signature, trustedPrecomputedInput)),
     rule(10),
     ['Member' = hmacVerificationMode(signature, trustedPrecomputedInput)],
     [hmacVerificationMode(signature, trustedPrecomputedInput) \= (_left, _right)]).
step(hmacVerificationMode(signature, trustedPrecomputedInput) \= (_left, _right),
     builtin,
     [],
     []).
step(hmacVerificationMode(signature, trustedPrecomputedInput) =.. [hmacVerificationMode, signature, trustedPrecomputedInput],
     builtin,
     [],
     []).
step(payload_hash_matches(check),
     rule(59),
     ['Digest' = "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"],
     [envelope_hash(envelope, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"),
      payload_hash_sha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098")]).
step(envelope_hash(envelope, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"),
     rule(50),
     ['Hash' = "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"],
     [envelope_statement(envelope, hash, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098")]).
step(envelope_statement(envelope, hash, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"),
     rule(14),
     ['S' = envelope,
      'P' = hash,
      'O' = "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098",
      'Context' = (insight(envelope, delfourInsightGraph), policy(envelope, delfourPolicyGraph), hash(envelope, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098")),
      'Statement' = hash(envelope, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098")],
     [envelope_graph(delfourEnvelopeGraph, (insight(envelope, delfourInsightGraph), policy(envelope, delfourPolicyGraph), hash(envelope, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"))),
      context_member((insight(envelope, delfourInsightGraph), policy(envelope, delfourPolicyGraph), hash(envelope, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098")), hash(envelope, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098")),
      hash(envelope, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098") =.. [hash, envelope, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"]]).
step(envelope_graph(delfourEnvelopeGraph, (insight(envelope, delfourInsightGraph), policy(envelope, delfourPolicyGraph), hash(envelope, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"))),
     fact(5),
     [],
     []).
step(context_member((insight(envelope, delfourInsightGraph), policy(envelope, delfourPolicyGraph), hash(envelope, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098")), hash(envelope, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098")),
     rule(9),
     ['Right' = (policy(envelope, delfourPolicyGraph), hash(envelope, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098")),
      'Member' = hash(envelope, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098")],
     [context_member((policy(envelope, delfourPolicyGraph), hash(envelope, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098")), hash(envelope, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"))]).
step(context_member((policy(envelope, delfourPolicyGraph), hash(envelope, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098")), hash(envelope, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098")),
     rule(9),
     ['Right' = hash(envelope, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"),
      'Member' = hash(envelope, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098")],
     [context_member(hash(envelope, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"), hash(envelope, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"))]).
step(context_member(hash(envelope, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"), hash(envelope, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098")),
     rule(10),
     ['Member' = hash(envelope, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098")],
     [hash(envelope, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098") \= (_left, _right)]).
step(hash(envelope, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098") \= (_left, _right),
     builtin,
     [],
     []).
step(hash(envelope, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098") =.. [hash, envelope, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"],
     builtin,
     [],
     []).
step(payload_hash_sha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"),
     rule(54),
     ['Hash' = "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"],
     [signature_statement(signature, payloadHashSha256, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098")]).
step(signature_statement(signature, payloadHashSha256, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"),
     rule(15),
     ['S' = signature,
      'P' = payloadHashSha256,
      'O' = "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098",
      'Context' = (alg(signature, "HMAC-SHA256"), keyid(signature, "demo-shared-secret"), created(signature, "2025-10-05T20:33:48.907163+00:00"), payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"), hmac(signature, "b21d0072d90112a9f820aced0286889f4b6ef92b145e6fdef1011f3bfa4608c2"), hmacVerificationMode(signature, trustedPrecomputedInput)),
      'Statement' = payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098")],
     [signature_graph(delfourSignatureGraph, (alg(signature, "HMAC-SHA256"), keyid(signature, "demo-shared-secret"), created(signature, "2025-10-05T20:33:48.907163+00:00"), payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"), hmac(signature, "b21d0072d90112a9f820aced0286889f4b6ef92b145e6fdef1011f3bfa4608c2"), hmacVerificationMode(signature, trustedPrecomputedInput))),
      context_member((alg(signature, "HMAC-SHA256"), keyid(signature, "demo-shared-secret"), created(signature, "2025-10-05T20:33:48.907163+00:00"), payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"), hmac(signature, "b21d0072d90112a9f820aced0286889f4b6ef92b145e6fdef1011f3bfa4608c2"), hmacVerificationMode(signature, trustedPrecomputedInput)), payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098")),
      payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098") =.. [payloadHashSha256, signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"]]).
step(context_member((alg(signature, "HMAC-SHA256"), keyid(signature, "demo-shared-secret"), created(signature, "2025-10-05T20:33:48.907163+00:00"), payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"), hmac(signature, "b21d0072d90112a9f820aced0286889f4b6ef92b145e6fdef1011f3bfa4608c2"), hmacVerificationMode(signature, trustedPrecomputedInput)), payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098")),
     rule(9),
     ['Right' = (keyid(signature, "demo-shared-secret"), created(signature, "2025-10-05T20:33:48.907163+00:00"), payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"), hmac(signature, "b21d0072d90112a9f820aced0286889f4b6ef92b145e6fdef1011f3bfa4608c2"), hmacVerificationMode(signature, trustedPrecomputedInput)),
      'Member' = payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098")],
     [context_member((keyid(signature, "demo-shared-secret"), created(signature, "2025-10-05T20:33:48.907163+00:00"), payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"), hmac(signature, "b21d0072d90112a9f820aced0286889f4b6ef92b145e6fdef1011f3bfa4608c2"), hmacVerificationMode(signature, trustedPrecomputedInput)), payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"))]).
step(context_member((keyid(signature, "demo-shared-secret"), created(signature, "2025-10-05T20:33:48.907163+00:00"), payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"), hmac(signature, "b21d0072d90112a9f820aced0286889f4b6ef92b145e6fdef1011f3bfa4608c2"), hmacVerificationMode(signature, trustedPrecomputedInput)), payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098")),
     rule(9),
     ['Right' = (created(signature, "2025-10-05T20:33:48.907163+00:00"), payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"), hmac(signature, "b21d0072d90112a9f820aced0286889f4b6ef92b145e6fdef1011f3bfa4608c2"), hmacVerificationMode(signature, trustedPrecomputedInput)),
      'Member' = payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098")],
     [context_member((created(signature, "2025-10-05T20:33:48.907163+00:00"), payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"), hmac(signature, "b21d0072d90112a9f820aced0286889f4b6ef92b145e6fdef1011f3bfa4608c2"), hmacVerificationMode(signature, trustedPrecomputedInput)), payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"))]).
step(context_member((created(signature, "2025-10-05T20:33:48.907163+00:00"), payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"), hmac(signature, "b21d0072d90112a9f820aced0286889f4b6ef92b145e6fdef1011f3bfa4608c2"), hmacVerificationMode(signature, trustedPrecomputedInput)), payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098")),
     rule(9),
     ['Right' = (payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"), hmac(signature, "b21d0072d90112a9f820aced0286889f4b6ef92b145e6fdef1011f3bfa4608c2"), hmacVerificationMode(signature, trustedPrecomputedInput)),
      'Member' = payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098")],
     [context_member((payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"), hmac(signature, "b21d0072d90112a9f820aced0286889f4b6ef92b145e6fdef1011f3bfa4608c2"), hmacVerificationMode(signature, trustedPrecomputedInput)), payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"))]).
step(context_member((payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"), hmac(signature, "b21d0072d90112a9f820aced0286889f4b6ef92b145e6fdef1011f3bfa4608c2"), hmacVerificationMode(signature, trustedPrecomputedInput)), payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098")),
     rule(8),
     ['Left' = payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"),
      'Member' = payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098")],
     [context_member(payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"), payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"))]).
step(context_member(payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"), payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098")),
     rule(10),
     ['Member' = payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098")],
     [payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098") \= (_left, _right)]).
step(payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098") \= (_left, _right),
     builtin,
     [],
     []).
step(payloadHashSha256(signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098") =.. [payloadHashSha256, signature, "34ad35638dfd7c67d031eeca8abb235ec24280740f863f3f31cd9d7b6517f098"],
     builtin,
     [],
     []).
step(minimization_strips_sensitive_terms(check),
     rule(61),
     ['Text' = 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner'],
     [serialized_lowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner'),
      \+ matches('createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner', 'diabetes|medical')]).
step(serialized_lowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner'),
     rule(43),
     ['Text' = 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner'],
     [insight_statement(insight, serializedLowercase, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')]).
step(insight_statement(insight, serializedLowercase, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner'),
     rule(12),
     ['S' = insight,
      'P' = serializedLowercase,
      'O' = 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner',
      'Context' = (metric(insight, "sugar_g_per_serving"), thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Statement' = serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')],
     [insight_graph(delfourInsightGraph, (metric(insight, "sugar_g_per_serving"), thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner'))),
      context_member((metric(insight, "sugar_g_per_serving"), thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner') =.. [serializedLowercase, insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner']]).
step(context_member((metric(insight, "sugar_g_per_serving"), thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
     rule(9),
     ['Right' = (thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Member' = serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')],
     [context_member((thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner'))]).
step(context_member((thresholdTenths(insight, 100), thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
     rule(9),
     ['Right' = (thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Member' = serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')],
     [context_member((thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner'))]).
step(context_member((thresholdDisplay(insight, "10.0"), thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
     rule(9),
     ['Right' = (thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Member' = serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')],
     [context_member((thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner'))]).
step(context_member((thresholdG(insight, 10.0), suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
     rule(9),
     ['Right' = (suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Member' = serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')],
     [context_member((suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner'))]).
step(context_member((suggestionPolicy(insight, "lower_metric_first_higher_price_ok"), scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
     rule(9),
     ['Right' = (scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Member' = serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')],
     [context_member((scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner'))]).
step(context_member((scopeDevice(insight, "self-scanner"), scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
     rule(9),
     ['Right' = (scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Member' = serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')],
     [context_member((scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner'))]).
step(context_member((scopeEvent(insight, "pick_up_scanner"), retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
     rule(9),
     ['Right' = (retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Member' = serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')],
     [context_member((retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner'))]).
step(context_member((retailer(insight, "Delfour"), createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
     rule(9),
     ['Right' = (createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Member' = serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')],
     [context_member((createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner'))]).
step(context_member((createdAt(insight, "2025-10-05T20:33:48.907163+00:00"), expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
     rule(9),
     ['Right' = (expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
      'Member' = serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')],
     [context_member((expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner'))]).
step(context_member((expiresAt(insight, "2025-10-05T22:33:48.907185+00:00"), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
     rule(9),
     ['Right' = serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner'),
      'Member' = serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')],
     [context_member(serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner'), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner'))]).
step(context_member(serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner'), serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')),
     rule(10),
     ['Member' = serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner')],
     [serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner') \= (_left, _right)]).
step(serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner') \= (_left, _right),
     builtin,
     [],
     []).
step(serializedLowercase(insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner') =.. [serializedLowercase, insight, 'createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner'],
     builtin,
     [],
     []).
step(\+ matches('createdat expiresat insight metric sugar_g_per_serving retailer delfour scopedevice self-scanner scopeevent pick_up_scanner', 'diabetes|medical'),
     absent,
     [],
     []).
step(scope_complete(check),
     rule(62),
     [],
     [scope_device(insight, "self-scanner"),
      scope_event(insight, "pick_up_scanner"),
      expires_at(insight, "2025-10-05T22:33:48.907185+00:00")]).
step(alternative_is_lower_sugar(check),
     rule(71),
     ['Scanned' = prod_BIS_001,
      'Scannedsugar' = 120,
      'Alternative' = prod_BIS_101,
      'Alternativesugar' = 30],
     [scanned_product(scan, prod_BIS_001),
      sugar_tenths(prod_BIS_001, 120),
      suggested_alternative(case, prod_BIS_101),
      sugar_tenths(prod_BIS_101, 30),
      120 > 30]).
step(duty_timing_consistent(check),
     rule(72),
     ['Dutyat' = "2025-10-05T20:37:48.907163+00:00",
      'Expiresat' = "2025-10-05T22:33:48.907185+00:00"],
     [scanner_duty_at(case, "2025-10-05T20:37:48.907163+00:00"),
      expires_at(insight, "2025-10-05T22:33:48.907185+00:00"),
      "2025-10-05T20:37:48.907163+00:00" @=< "2025-10-05T22:33:48.907185+00:00"]).
step(scanner_duty_at(case, "2025-10-05T20:37:48.907163+00:00"),
     rule(22),
     ['Time' = "2025-10-05T20:37:48.907163+00:00"],
     [case_statement(case, scannerDutyAt, "2025-10-05T20:37:48.907163+00:00")]).
step(case_statement(case, scannerDutyAt, "2025-10-05T20:37:48.907163+00:00"),
     rule(11),
     ['S' = case,
      'P' = scannerDutyAt,
      'O' = "2025-10-05T20:37:48.907163+00:00",
      'Context' = (caseName(case, "delfour"), requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Statement' = scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00")],
     [case_graph(delfourCaseGraph, (caseName(case, "delfour"), requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001))),
      context_member((caseName(case, "delfour"), requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00")),
      scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00") =.. [scannerDutyAt, case, "2025-10-05T20:37:48.907163+00:00"]]).
step(context_member((caseName(case, "delfour"), requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00")),
     rule(9),
     ['Right' = (requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00")],
     [context_member((requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"))]).
step(context_member((requestPurpose(case, "shopping_assist"), requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00")),
     rule(9),
     ['Right' = (requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00")],
     [context_member((requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"))]).
step(context_member((requestAction(case, odrl_use), phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00")),
     rule(9),
     ['Right' = (phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00")],
     [context_member((phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"))]).
step(context_member((phoneCreatedAt(case, "2025-10-05T20:33:48.907163+00:00"), phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00")),
     rule(9),
     ['Right' = (phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00")],
     [context_member((phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"))]).
step(context_member((phoneExpiresAt(case, "2025-10-05T22:33:48.907185+00:00"), scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00")),
     rule(9),
     ['Right' = (scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00")],
     [context_member((scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"))]).
step(context_member((scannerAuthAt(case, "2025-10-05T20:35:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00")),
     rule(9),
     ['Right' = (scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)),
      'Member' = scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00")],
     [context_member((scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"))]).
step(context_member((scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), filesWritten(case, 6), auditEntries(case, 1), condition(householdProfile, "Diabetes"), scannedProduct(scan, prod_BIS_001)), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00")),
     rule(8),
     ['Left' = scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"),
      'Member' = scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00")],
     [context_member(scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"))]).
step(context_member(scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00"), scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00")),
     rule(10),
     ['Member' = scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00")],
     [scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00") \= (_left, _right)]).
step(scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00") \= (_left, _right),
     builtin,
     [],
     []).
step(scannerDutyAt(case, "2025-10-05T20:37:48.907163+00:00") =.. [scannerDutyAt, case, "2025-10-05T20:37:48.907163+00:00"],
     builtin,
     [],
     []).
step("2025-10-05T20:37:48.907163+00:00" @=< "2025-10-05T22:33:48.907185+00:00", builtin, [], []).
step(marketing_prohibited(check),
     rule(73),
     [],
     [prohibition(policy, odrl_distribute, insight, "marketing")]).
step(prohibition(policy, odrl_distribute, insight, "marketing"),
     rule(46),
     ['Action' = odrl_distribute, 'Target' = insight, 'Purpose' = "marketing"],
     [policy_statement(policy, odrl_prohibition, prohibition(odrl_distribute, insight, "marketing"))]).
step(policy_statement(policy, odrl_prohibition, prohibition(odrl_distribute, insight, "marketing")),
     rule(13),
     ['S' = policy,
      'P' = odrl_prohibition,
      'O' = prohibition(odrl_distribute, insight, "marketing"),
      'Context' = (odrl_permission(policy, permission(odrl_use, insight, "shopping_assist")), odrl_prohibition(policy, prohibition(odrl_distribute, insight, "marketing")), odrl_duty(policy, duty(odrl_delete, "2025-10-05T22:33:48.907185+00:00"))),
      'Statement' = odrl_prohibition(policy, prohibition(odrl_distribute, insight, "marketing"))],
     [policy_graph(delfourPolicyGraph, (odrl_permission(policy, permission(odrl_use, insight, "shopping_assist")), odrl_prohibition(policy, prohibition(odrl_distribute, insight, "marketing")), odrl_duty(policy, duty(odrl_delete, "2025-10-05T22:33:48.907185+00:00")))),
      context_member((odrl_permission(policy, permission(odrl_use, insight, "shopping_assist")), odrl_prohibition(policy, prohibition(odrl_distribute, insight, "marketing")), odrl_duty(policy, duty(odrl_delete, "2025-10-05T22:33:48.907185+00:00"))), odrl_prohibition(policy, prohibition(odrl_distribute, insight, "marketing"))),
      odrl_prohibition(policy, prohibition(odrl_distribute, insight, "marketing")) =.. [odrl_prohibition, policy, prohibition(odrl_distribute, insight, "marketing")]]).
step(context_member((odrl_permission(policy, permission(odrl_use, insight, "shopping_assist")), odrl_prohibition(policy, prohibition(odrl_distribute, insight, "marketing")), odrl_duty(policy, duty(odrl_delete, "2025-10-05T22:33:48.907185+00:00"))), odrl_prohibition(policy, prohibition(odrl_distribute, insight, "marketing"))),
     rule(9),
     ['Right' = (odrl_prohibition(policy, prohibition(odrl_distribute, insight, "marketing")), odrl_duty(policy, duty(odrl_delete, "2025-10-05T22:33:48.907185+00:00"))),
      'Member' = odrl_prohibition(policy, prohibition(odrl_distribute, insight, "marketing"))],
     [context_member((odrl_prohibition(policy, prohibition(odrl_distribute, insight, "marketing")), odrl_duty(policy, duty(odrl_delete, "2025-10-05T22:33:48.907185+00:00"))), odrl_prohibition(policy, prohibition(odrl_distribute, insight, "marketing")))]).
step(context_member((odrl_prohibition(policy, prohibition(odrl_distribute, insight, "marketing")), odrl_duty(policy, duty(odrl_delete, "2025-10-05T22:33:48.907185+00:00"))), odrl_prohibition(policy, prohibition(odrl_distribute, insight, "marketing"))),
     rule(8),
     ['Left' = odrl_prohibition(policy, prohibition(odrl_distribute, insight, "marketing")),
      'Member' = odrl_prohibition(policy, prohibition(odrl_distribute, insight, "marketing"))],
     [context_member(odrl_prohibition(policy, prohibition(odrl_distribute, insight, "marketing")), odrl_prohibition(policy, prohibition(odrl_distribute, insight, "marketing")))]).
step(context_member(odrl_prohibition(policy, prohibition(odrl_distribute, insight, "marketing")), odrl_prohibition(policy, prohibition(odrl_distribute, insight, "marketing"))),
     rule(10),
     ['Member' = odrl_prohibition(policy, prohibition(odrl_distribute, insight, "marketing"))],
     [odrl_prohibition(policy, prohibition(odrl_distribute, insight, "marketing")) \= (_left, _right)]).
step(odrl_prohibition(policy, prohibition(odrl_distribute, insight, "marketing")) \= (_left, _right),
     builtin,
     [],
     []).
step(odrl_prohibition(policy, prohibition(odrl_distribute, insight, "marketing")) =.. [odrl_prohibition, policy, prohibition(odrl_distribute, insight, "marketing")],
     builtin,
     [],
     []).
step(files_written_expected(check), rule(74), [], [files_written(case, 6)]).
step(signatureVerifies(check, true), rule(95), [], [signature_verifies(check)]).
step(payloadHashMatches(check, true), rule(96), [], [payload_hash_matches(check)]).
step(minimizationStripsSensitiveTerms(check, true),
     rule(97),
     [],
     [minimization_strips_sensitive_terms(check)]).
step(scopeComplete(check, true), rule(98), [], [scope_complete(check)]).
step(authorizationAllowed(check, true), rule(99), [], [authorization_allowed(check)]).
step(bannerFlagsHighSugar(check, true), rule(100), [], [banner_flags_high_sugar(check)]).
step(alternativeIsLowerSugar(check, true), rule(101), [], [alternative_is_lower_sugar(check)]).
step(dutyTimingConsistent(check, true), rule(102), [], [duty_timing_consistent(check)]).
step(marketingProhibited(check, true), rule(103), [], [marketing_prohibited(check)]).
step(filesWrittenExpected(check, true), rule(104), [], [files_written_expected(check)]).
