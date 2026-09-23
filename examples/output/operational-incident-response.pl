root_cause(inc900, primary_db, disk_full).
impacted_service(inc900, primary_db).
impacted_service(inc900, payment_api).
impacted_service(inc900, storefront).
impacted_service(inc900, mobile_app).
impacted_service(inc900, checkout_api).
recommended_action(inc900, failover(primary_db, replica_db)).
evidence_chain(inc900, [payment_api_db_timeout, primary_db_unhealthy, primary_db_disk_100_percent, auth_service_healthy, replica_db_healthy]).
