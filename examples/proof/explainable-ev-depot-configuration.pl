blocker(depot_a, rapid50, insufficient_site_power(60, 80)).
blocker(depot_a, budget11, insufficient_charge_rate(11, 22)).
blocker(depot_a, legacy22, connector_mismatch(type2, ccs2)).
compatible(depot_a, fleet22).
recommendation(depot_a, fleet22).
required_change(depot_a, rapid50, increase_site_power_to(80)).
required_change(depot_a, budget11, choose_charger_at_least_kw(22)).
required_change(depot_a, legacy22, use_connector(ccs2)).

clause(1,
       rdf(iri('https://example.org/ev-depot/site/depot-a'), iri('https://example.org/vocab/availablePowerKw'), literal('60', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/ev-depot/graph/site')),
       true).
clause(2,
       rdf(iri('https://example.org/ev-depot/site/depot-a'), iri('https://example.org/vocab/requiredChargeKw'), literal('22', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/ev-depot/graph/site')),
       true).
clause(3,
       rdf(iri('https://example.org/ev-depot/site/depot-a'), iri('https://example.org/vocab/requiredConnector'), iri('https://example.org/ev-depot/connector/ccs2'), iri('https://example.org/ev-depot/graph/site')),
       true).
clause(10,
       rdf(iri('https://example.org/ev-depot/charger/rapid50'), iri('https://example.org/vocab/sitePowerRequirementKw'), literal('80', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/ev-depot/graph/catalog')),
       true).
clause(13,
       rdf(iri('https://example.org/ev-depot/charger/budget11'), iri('https://example.org/vocab/chargeKw'), literal('11', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/ev-depot/graph/catalog')),
       true).
clause(19,
       rdf(iri('https://example.org/ev-depot/charger/legacy22'), iri('https://example.org/vocab/connector'), iri('https://example.org/ev-depot/connector/type2'), iri('https://example.org/ev-depot/graph/catalog')),
       true).
clause(21, v(available_power, iri('https://example.org/vocab/availablePowerKw')), true).
clause(22, v(required_charge, iri('https://example.org/vocab/requiredChargeKw')), true).
clause(23, v(required_connector, iri('https://example.org/vocab/requiredConnector')), true).
clause(25, v(charge_kw, iri('https://example.org/vocab/chargeKw')), true).
clause(26,
       v(site_power_requirement, iri('https://example.org/vocab/sitePowerRequirementKw')),
       true).
clause(27, v(connector, iri('https://example.org/vocab/connector')), true).
clause(28, g(site, iri('https://example.org/ev-depot/graph/site')), true).
clause(29, g(catalog, iri('https://example.org/ev-depot/graph/catalog')), true).
clause(30, resource(depot_a, iri('https://example.org/ev-depot/site/depot-a')), true).
clause(32, resource(rapid50, iri('https://example.org/ev-depot/charger/rapid50')), true).
clause(33, resource(budget11, iri('https://example.org/ev-depot/charger/budget11')), true).
clause(34, resource(legacy22, iri('https://example.org/ev-depot/charger/legacy22')), true).
clause(35, product(fleet22), true).
clause(36, product(rapid50), true).
clause(37, product(budget11), true).
clause(38, product(legacy22), true).
clause(39,
       integer_literal(literal(var('Text'), datatype('http://www.w3.org/2001/XMLSchema#integer')), var('N')),
       (atom_chars(var('Text'), var('Cs')), number_chars(var('N'), var('Cs')))).
clause(40,
       site_number(var('Key'), var('N')),
       (resource(depot_a, var('S')),
        v(var('Key'), var('P')),
        g(site, var('G')),
        rdf(var('S'), var('P'), var('L'), var('G')),
        integer_literal(var('L'), var('N')))).
clause(41,
       site_term(var('Key'), var('V')),
       (resource(depot_a, var('S')),
        v(var('Key'), var('P')),
        g(site, var('G')),
        rdf(var('S'), var('P'), var('V'), var('G')))).
clause(42,
       product_number(var('Product'), var('Key'), var('N')),
       (resource(var('Product'), var('R')),
        v(var('Key'), var('P')),
        g(catalog, var('G')),
        rdf(var('R'), var('P'), var('L'), var('G')),
        integer_literal(var('L'), var('N')))).
clause(43,
       product_term(var('Product'), var('Key'), var('V')),
       (resource(var('Product'), var('R')),
        v(var('Key'), var('P')),
        g(catalog, var('G')),
        rdf(var('R'), var('P'), var('V'), var('G')))).
clause(44,
       blocker(depot_a, var('Product'), insufficient_site_power(var('Available'), var('Needed'))),
       (product(var('Product')),
        site_number(available_power, var('Available')),
        product_number(var('Product'), site_power_requirement, var('Needed')),
        var('Available') < var('Needed'))).
clause(45,
       blocker(depot_a, var('Product'), insufficient_charge_rate(var('Offered'), var('Required'))),
       (product(var('Product')),
        product_number(var('Product'), charge_kw, var('Offered')),
        site_number(required_charge, var('Required')),
        var('Offered') < var('Required'))).
clause(46,
       blocker(depot_a, var('Product'), connector_mismatch(var('Offered'), var('Required'))),
       (product(var('Product')),
        product_term(var('Product'), connector, var('OfferedIri')),
        site_term(required_connector, var('RequiredIri')),
        var('OfferedIri') \= var('RequiredIri'),
        connector_name(var('OfferedIri'), var('Offered')),
        connector_name(var('RequiredIri'), var('Required')))).
clause(48, connector_name(iri('https://example.org/ev-depot/connector/ccs2'), ccs2), true).
clause(49, connector_name(iri('https://example.org/ev-depot/connector/type2'), type2), true).
clause(50,
       compatible(depot_a, var('Product')),
       (product(var('Product')), \+ blocker(depot_a, var('Product'), anonymous(1)))).
clause(51, recommendation(depot_a, fleet22), compatible(depot_a, fleet22)).
clause(52,
       required_change(depot_a, var('Product'), increase_site_power_to(var('Needed'))),
       blocker(depot_a, var('Product'), insufficient_site_power(anonymous(1), var('Needed')))).
clause(53,
       required_change(depot_a, var('Product'), choose_charger_at_least_kw(var('Required'))),
       blocker(depot_a, var('Product'), insufficient_charge_rate(anonymous(1), var('Required')))).
clause(54,
       required_change(depot_a, var('Product'), use_connector(var('Required'))),
       blocker(depot_a, var('Product'), connector_mismatch(anonymous(1), var('Required')))).

step(blocker(depot_a, rapid50, insufficient_site_power(60, 80)),
     rule(44),
     ['Product' = rapid50, 'Available' = 60, 'Needed' = 80],
     [product(rapid50),
      site_number(available_power, 60),
      product_number(rapid50, site_power_requirement, 80),
      60 < 80]).
step(product(rapid50), fact(36), [], []).
step(site_number(available_power, 60),
     rule(40),
     ['Key' = available_power,
      'N' = 60,
      'S' = iri('https://example.org/ev-depot/site/depot-a'),
      'P' = iri('https://example.org/vocab/availablePowerKw'),
      'G' = iri('https://example.org/ev-depot/graph/site'),
      'L' = literal('60', datatype('http://www.w3.org/2001/XMLSchema#integer'))],
     [resource(depot_a, iri('https://example.org/ev-depot/site/depot-a')),
      v(available_power, iri('https://example.org/vocab/availablePowerKw')),
      g(site, iri('https://example.org/ev-depot/graph/site')),
      rdf(iri('https://example.org/ev-depot/site/depot-a'), iri('https://example.org/vocab/availablePowerKw'), literal('60', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/ev-depot/graph/site')),
      integer_literal(literal('60', datatype('http://www.w3.org/2001/XMLSchema#integer')), 60)]).
step(resource(depot_a, iri('https://example.org/ev-depot/site/depot-a')), fact(30), [], []).
step(v(available_power, iri('https://example.org/vocab/availablePowerKw')), fact(21), [], []).
step(g(site, iri('https://example.org/ev-depot/graph/site')), fact(28), [], []).
step(rdf(iri('https://example.org/ev-depot/site/depot-a'), iri('https://example.org/vocab/availablePowerKw'), literal('60', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/ev-depot/graph/site')),
     fact(1),
     [],
     []).
step(integer_literal(literal('60', datatype('http://www.w3.org/2001/XMLSchema#integer')), 60),
     rule(39),
     ['Text' = '60', 'N' = 60, 'Cs' = "60"],
     [atom_chars('60', "60"), number_chars(60, "60")]).
step(atom_chars('60', "60"), builtin, [], []).
step(number_chars(60, "60"), builtin, [], []).
step(product_number(rapid50, site_power_requirement, 80),
     rule(42),
     ['Product' = rapid50,
      'Key' = site_power_requirement,
      'N' = 80,
      'R' = iri('https://example.org/ev-depot/charger/rapid50'),
      'P' = iri('https://example.org/vocab/sitePowerRequirementKw'),
      'G' = iri('https://example.org/ev-depot/graph/catalog'),
      'L' = literal('80', datatype('http://www.w3.org/2001/XMLSchema#integer'))],
     [resource(rapid50, iri('https://example.org/ev-depot/charger/rapid50')),
      v(site_power_requirement, iri('https://example.org/vocab/sitePowerRequirementKw')),
      g(catalog, iri('https://example.org/ev-depot/graph/catalog')),
      rdf(iri('https://example.org/ev-depot/charger/rapid50'), iri('https://example.org/vocab/sitePowerRequirementKw'), literal('80', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/ev-depot/graph/catalog')),
      integer_literal(literal('80', datatype('http://www.w3.org/2001/XMLSchema#integer')), 80)]).
step(resource(rapid50, iri('https://example.org/ev-depot/charger/rapid50')), fact(32), [], []).
step(v(site_power_requirement, iri('https://example.org/vocab/sitePowerRequirementKw')),
     fact(26),
     [],
     []).
step(g(catalog, iri('https://example.org/ev-depot/graph/catalog')), fact(29), [], []).
step(rdf(iri('https://example.org/ev-depot/charger/rapid50'), iri('https://example.org/vocab/sitePowerRequirementKw'), literal('80', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/ev-depot/graph/catalog')),
     fact(10),
     [],
     []).
step(integer_literal(literal('80', datatype('http://www.w3.org/2001/XMLSchema#integer')), 80),
     rule(39),
     ['Text' = '80', 'N' = 80, 'Cs' = "80"],
     [atom_chars('80', "80"), number_chars(80, "80")]).
step(atom_chars('80', "80"), builtin, [], []).
step(number_chars(80, "80"), builtin, [], []).
step(60 < 80, builtin, [], []).
step(blocker(depot_a, budget11, insufficient_charge_rate(11, 22)),
     rule(45),
     ['Product' = budget11, 'Offered' = 11, 'Required' = 22],
     [product(budget11),
      product_number(budget11, charge_kw, 11),
      site_number(required_charge, 22),
      11 < 22]).
step(product(budget11), fact(37), [], []).
step(product_number(budget11, charge_kw, 11),
     rule(42),
     ['Product' = budget11,
      'Key' = charge_kw,
      'N' = 11,
      'R' = iri('https://example.org/ev-depot/charger/budget11'),
      'P' = iri('https://example.org/vocab/chargeKw'),
      'G' = iri('https://example.org/ev-depot/graph/catalog'),
      'L' = literal('11', datatype('http://www.w3.org/2001/XMLSchema#integer'))],
     [resource(budget11, iri('https://example.org/ev-depot/charger/budget11')),
      v(charge_kw, iri('https://example.org/vocab/chargeKw')),
      g(catalog, iri('https://example.org/ev-depot/graph/catalog')),
      rdf(iri('https://example.org/ev-depot/charger/budget11'), iri('https://example.org/vocab/chargeKw'), literal('11', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/ev-depot/graph/catalog')),
      integer_literal(literal('11', datatype('http://www.w3.org/2001/XMLSchema#integer')), 11)]).
step(resource(budget11, iri('https://example.org/ev-depot/charger/budget11')), fact(33), [], []).
step(v(charge_kw, iri('https://example.org/vocab/chargeKw')), fact(25), [], []).
step(rdf(iri('https://example.org/ev-depot/charger/budget11'), iri('https://example.org/vocab/chargeKw'), literal('11', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/ev-depot/graph/catalog')),
     fact(13),
     [],
     []).
step(integer_literal(literal('11', datatype('http://www.w3.org/2001/XMLSchema#integer')), 11),
     rule(39),
     ['Text' = '11', 'N' = 11, 'Cs' = "11"],
     [atom_chars('11', "11"), number_chars(11, "11")]).
step(atom_chars('11', "11"), builtin, [], []).
step(number_chars(11, "11"), builtin, [], []).
step(site_number(required_charge, 22),
     rule(40),
     ['Key' = required_charge,
      'N' = 22,
      'S' = iri('https://example.org/ev-depot/site/depot-a'),
      'P' = iri('https://example.org/vocab/requiredChargeKw'),
      'G' = iri('https://example.org/ev-depot/graph/site'),
      'L' = literal('22', datatype('http://www.w3.org/2001/XMLSchema#integer'))],
     [resource(depot_a, iri('https://example.org/ev-depot/site/depot-a')),
      v(required_charge, iri('https://example.org/vocab/requiredChargeKw')),
      g(site, iri('https://example.org/ev-depot/graph/site')),
      rdf(iri('https://example.org/ev-depot/site/depot-a'), iri('https://example.org/vocab/requiredChargeKw'), literal('22', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/ev-depot/graph/site')),
      integer_literal(literal('22', datatype('http://www.w3.org/2001/XMLSchema#integer')), 22)]).
step(v(required_charge, iri('https://example.org/vocab/requiredChargeKw')), fact(22), [], []).
step(rdf(iri('https://example.org/ev-depot/site/depot-a'), iri('https://example.org/vocab/requiredChargeKw'), literal('22', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/ev-depot/graph/site')),
     fact(2),
     [],
     []).
step(integer_literal(literal('22', datatype('http://www.w3.org/2001/XMLSchema#integer')), 22),
     rule(39),
     ['Text' = '22', 'N' = 22, 'Cs' = "22"],
     [atom_chars('22', "22"), number_chars(22, "22")]).
step(atom_chars('22', "22"), builtin, [], []).
step(number_chars(22, "22"), builtin, [], []).
step(11 < 22, builtin, [], []).
step(blocker(depot_a, legacy22, connector_mismatch(type2, ccs2)),
     rule(46),
     ['Product' = legacy22,
      'Offered' = type2,
      'Required' = ccs2,
      'OfferedIri' = iri('https://example.org/ev-depot/connector/type2'),
      'RequiredIri' = iri('https://example.org/ev-depot/connector/ccs2')],
     [product(legacy22),
      product_term(legacy22, connector, iri('https://example.org/ev-depot/connector/type2')),
      site_term(required_connector, iri('https://example.org/ev-depot/connector/ccs2')),
      iri('https://example.org/ev-depot/connector/type2') \= iri('https://example.org/ev-depot/connector/ccs2'),
      connector_name(iri('https://example.org/ev-depot/connector/type2'), type2),
      connector_name(iri('https://example.org/ev-depot/connector/ccs2'), ccs2)]).
step(product(legacy22), fact(38), [], []).
step(product_term(legacy22, connector, iri('https://example.org/ev-depot/connector/type2')),
     rule(43),
     ['Product' = legacy22,
      'Key' = connector,
      'V' = iri('https://example.org/ev-depot/connector/type2'),
      'R' = iri('https://example.org/ev-depot/charger/legacy22'),
      'P' = iri('https://example.org/vocab/connector'),
      'G' = iri('https://example.org/ev-depot/graph/catalog')],
     [resource(legacy22, iri('https://example.org/ev-depot/charger/legacy22')),
      v(connector, iri('https://example.org/vocab/connector')),
      g(catalog, iri('https://example.org/ev-depot/graph/catalog')),
      rdf(iri('https://example.org/ev-depot/charger/legacy22'), iri('https://example.org/vocab/connector'), iri('https://example.org/ev-depot/connector/type2'), iri('https://example.org/ev-depot/graph/catalog'))]).
step(resource(legacy22, iri('https://example.org/ev-depot/charger/legacy22')), fact(34), [], []).
step(v(connector, iri('https://example.org/vocab/connector')), fact(27), [], []).
step(rdf(iri('https://example.org/ev-depot/charger/legacy22'), iri('https://example.org/vocab/connector'), iri('https://example.org/ev-depot/connector/type2'), iri('https://example.org/ev-depot/graph/catalog')),
     fact(19),
     [],
     []).
step(site_term(required_connector, iri('https://example.org/ev-depot/connector/ccs2')),
     rule(41),
     ['Key' = required_connector,
      'V' = iri('https://example.org/ev-depot/connector/ccs2'),
      'S' = iri('https://example.org/ev-depot/site/depot-a'),
      'P' = iri('https://example.org/vocab/requiredConnector'),
      'G' = iri('https://example.org/ev-depot/graph/site')],
     [resource(depot_a, iri('https://example.org/ev-depot/site/depot-a')),
      v(required_connector, iri('https://example.org/vocab/requiredConnector')),
      g(site, iri('https://example.org/ev-depot/graph/site')),
      rdf(iri('https://example.org/ev-depot/site/depot-a'), iri('https://example.org/vocab/requiredConnector'), iri('https://example.org/ev-depot/connector/ccs2'), iri('https://example.org/ev-depot/graph/site'))]).
step(v(required_connector, iri('https://example.org/vocab/requiredConnector')),
     fact(23),
     [],
     []).
step(rdf(iri('https://example.org/ev-depot/site/depot-a'), iri('https://example.org/vocab/requiredConnector'), iri('https://example.org/ev-depot/connector/ccs2'), iri('https://example.org/ev-depot/graph/site')),
     fact(3),
     [],
     []).
step(iri('https://example.org/ev-depot/connector/type2') \= iri('https://example.org/ev-depot/connector/ccs2'),
     builtin,
     [],
     []).
step(connector_name(iri('https://example.org/ev-depot/connector/type2'), type2),
     fact(49),
     [],
     []).
step(connector_name(iri('https://example.org/ev-depot/connector/ccs2'), ccs2), fact(48), [], []).
step(compatible(depot_a, fleet22),
     rule(50),
     ['Product' = fleet22],
     [product(fleet22), \+ blocker(depot_a, fleet22, __anon0)]).
step(product(fleet22), fact(35), [], []).
step(\+ blocker(depot_a, fleet22, __anon0), absent, [], []).
step(recommendation(depot_a, fleet22), rule(51), [], [compatible(depot_a, fleet22)]).
step(required_change(depot_a, rapid50, increase_site_power_to(80)),
     rule(52),
     ['Product' = rapid50, 'Needed' = 80],
     [blocker(depot_a, rapid50, insufficient_site_power(60, 80))]).
step(required_change(depot_a, budget11, choose_charger_at_least_kw(22)),
     rule(53),
     ['Product' = budget11, 'Required' = 22],
     [blocker(depot_a, budget11, insufficient_charge_rate(11, 22))]).
step(required_change(depot_a, legacy22, use_connector(ccs2)),
     rule(54),
     ['Product' = legacy22, 'Required' = ccs2],
     [blocker(depot_a, legacy22, connector_mismatch(type2, ccs2))]).
