impactedByFailureOf(checkout_api, payment_service).
impactedByFailureOf(risk_rules, payment_service).
impactedByFailureOf(web_store, payment_service).
impactedByFailureOf(mobile_app, payment_service).
impactedByFailureOf(payment_service, payment_service).
impactedByFailureOf(fraud_service, payment_service).
status(payment_service, failed).
businessFunctionAtRisk(place_order, true).
businessFunctionAtRisk(mobile_checkout, true).
businessFunctionAtRisk(collect_payment, true).
businessFunctionAtRisk(screen_fraud, true).

clause(2, depends_on(web_store, checkout_api), true).
clause(3, depends_on(mobile_app, checkout_api), true).
clause(4, depends_on(checkout_api, payment_service), true).
clause(6, depends_on(payment_service, fraud_service), true).
clause(7, depends_on(fraud_service, risk_rules), true).
clause(8, depends_on(risk_rules, payment_service), true).
clause(11, business_function(place_order, web_store), true).
clause(12, business_function(mobile_checkout, mobile_app), true).
clause(13, business_function(collect_payment, payment_service), true).
clause(14, business_function(screen_fraud, fraud_service), true).
clause(16, failed(payment_service), true).
clause(17, impacted(var('Service'), var('Failed')), depends_on(var('Service'), var('Failed'))).
clause(18,
       impacted(var('Service'), var('Failed')),
       (depends_on(var('Service'), var('Dependency')),
        impacted(var('Dependency'), var('Failed')))).
clause(19,
       affected(var('Service')),
       (failed(var('Failed')), impacted(var('Service'), var('Failed')))).
clause(21,
       affected_function(var('Function')),
       (business_function(var('Function'), var('Service')), affected(var('Service')))).
clause(22,
       impactedByFailureOf(var('Service'), var('Failed')),
       (failed(var('Failed')), impacted(var('Service'), var('Failed')))).
clause(23, status(var('Service'), failed), failed(var('Service'))).
clause(24, businessFunctionAtRisk(var('Function'), true), affected_function(var('Function'))).

step(impactedByFailureOf(checkout_api, payment_service),
     rule(22),
     ['Service' = checkout_api, 'Failed' = payment_service],
     [failed(payment_service), impacted(checkout_api, payment_service)]).
step(failed(payment_service), fact(16), [], []).
step(impacted(checkout_api, payment_service),
     rule(17),
     ['Service' = checkout_api, 'Failed' = payment_service],
     [depends_on(checkout_api, payment_service)]).
step(depends_on(checkout_api, payment_service), fact(4), [], []).
step(impactedByFailureOf(risk_rules, payment_service),
     rule(22),
     ['Service' = risk_rules, 'Failed' = payment_service],
     [failed(payment_service), impacted(risk_rules, payment_service)]).
step(impacted(risk_rules, payment_service),
     rule(17),
     ['Service' = risk_rules, 'Failed' = payment_service],
     [depends_on(risk_rules, payment_service)]).
step(depends_on(risk_rules, payment_service), fact(8), [], []).
step(impactedByFailureOf(web_store, payment_service),
     rule(22),
     ['Service' = web_store, 'Failed' = payment_service],
     [failed(payment_service), impacted(web_store, payment_service)]).
step(impacted(web_store, payment_service),
     rule(18),
     ['Service' = web_store, 'Failed' = payment_service, 'Dependency' = checkout_api],
     [depends_on(web_store, checkout_api), impacted(checkout_api, payment_service)]).
step(depends_on(web_store, checkout_api), fact(2), [], []).
step(impactedByFailureOf(mobile_app, payment_service),
     rule(22),
     ['Service' = mobile_app, 'Failed' = payment_service],
     [failed(payment_service), impacted(mobile_app, payment_service)]).
step(impacted(mobile_app, payment_service),
     rule(18),
     ['Service' = mobile_app, 'Failed' = payment_service, 'Dependency' = checkout_api],
     [depends_on(mobile_app, checkout_api), impacted(checkout_api, payment_service)]).
step(depends_on(mobile_app, checkout_api), fact(3), [], []).
step(impactedByFailureOf(payment_service, payment_service),
     rule(22),
     ['Service' = payment_service, 'Failed' = payment_service],
     [failed(payment_service), impacted(payment_service, payment_service)]).
step(impacted(payment_service, payment_service),
     rule(18),
     ['Service' = payment_service, 'Failed' = payment_service, 'Dependency' = fraud_service],
     [depends_on(payment_service, fraud_service), impacted(fraud_service, payment_service)]).
step(depends_on(payment_service, fraud_service), fact(6), [], []).
step(impacted(fraud_service, payment_service),
     rule(18),
     ['Service' = fraud_service, 'Failed' = payment_service, 'Dependency' = risk_rules],
     [depends_on(fraud_service, risk_rules), impacted(risk_rules, payment_service)]).
step(depends_on(fraud_service, risk_rules), fact(7), [], []).
step(impactedByFailureOf(fraud_service, payment_service),
     rule(22),
     ['Service' = fraud_service, 'Failed' = payment_service],
     [failed(payment_service), impacted(fraud_service, payment_service)]).
step(status(payment_service, failed),
     rule(23),
     ['Service' = payment_service],
     [failed(payment_service)]).
step(businessFunctionAtRisk(place_order, true),
     rule(24),
     ['Function' = place_order],
     [affected_function(place_order)]).
step(affected_function(place_order),
     rule(21),
     ['Function' = place_order, 'Service' = web_store],
     [business_function(place_order, web_store), affected(web_store)]).
step(business_function(place_order, web_store), fact(11), [], []).
step(affected(web_store),
     rule(19),
     ['Service' = web_store, 'Failed' = payment_service],
     [failed(payment_service), impacted(web_store, payment_service)]).
step(businessFunctionAtRisk(mobile_checkout, true),
     rule(24),
     ['Function' = mobile_checkout],
     [affected_function(mobile_checkout)]).
step(affected_function(mobile_checkout),
     rule(21),
     ['Function' = mobile_checkout, 'Service' = mobile_app],
     [business_function(mobile_checkout, mobile_app), affected(mobile_app)]).
step(business_function(mobile_checkout, mobile_app), fact(12), [], []).
step(affected(mobile_app),
     rule(19),
     ['Service' = mobile_app, 'Failed' = payment_service],
     [failed(payment_service), impacted(mobile_app, payment_service)]).
step(businessFunctionAtRisk(collect_payment, true),
     rule(24),
     ['Function' = collect_payment],
     [affected_function(collect_payment)]).
step(affected_function(collect_payment),
     rule(21),
     ['Function' = collect_payment, 'Service' = payment_service],
     [business_function(collect_payment, payment_service), affected(payment_service)]).
step(business_function(collect_payment, payment_service), fact(13), [], []).
step(affected(payment_service),
     rule(19),
     ['Service' = payment_service, 'Failed' = payment_service],
     [failed(payment_service), impacted(payment_service, payment_service)]).
step(businessFunctionAtRisk(screen_fraud, true),
     rule(24),
     ['Function' = screen_fraud],
     [affected_function(screen_fraud)]).
step(affected_function(screen_fraud),
     rule(21),
     ['Function' = screen_fraud, 'Service' = fraud_service],
     [business_function(screen_fraud, fraud_service), affected(fraud_service)]).
step(business_function(screen_fraud, fraud_service), fact(14), [], []).
step(affected(fraud_service),
     rule(19),
     ['Service' = fraud_service, 'Failed' = payment_service],
     [failed(payment_service), impacted(fraud_service, payment_service)]).
