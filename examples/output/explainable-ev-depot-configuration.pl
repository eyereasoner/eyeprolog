blocker(depot_a, rapid50, insufficient_site_power(60, 80)).
blocker(depot_a, budget11, insufficient_charge_rate(11, 22)).
blocker(depot_a, legacy22, connector_mismatch(type2, ccs2)).
compatible(depot_a, fleet22).
recommendation(depot_a, fleet22).
required_change(depot_a, rapid50, increase_site_power_to(80)).
required_change(depot_a, budget11, choose_charger_at_least_kw(22)).
required_change(depot_a, legacy22, use_connector(ccs2)).
