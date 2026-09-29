rh(scope, finite_catalog_only).
rh(caveat, "finite catalogue evidence only; this is not a proof of RH").
rh(status, no_counterexample_in_catalog).
zero_check(z1, real_part, 0.5).
zero_check(z2, real_part, 0.5).
zero_check(z3, real_part, 0.5).
zero_check(z1, imaginary_part, 14.134725).
zero_check(z2, imaginary_part, 21.02204).
zero_check(z3, imaginary_part, 25.010858).
zero_check(z1, classification, on_critical_line).
zero_check(z2, classification, on_critical_line).
zero_check(z3, classification, on_critical_line).

clause(5, zeta_zero(z1), true).
clause(6, real_part(z1, 0.5), true).
clause(7, imaginary_part(z1, 14.134725), true).
clause(9, zeta_zero(z2), true).
clause(10, real_part(z2, 0.5), true).
clause(11, imaginary_part(z2, 21.02204), true).
clause(13, zeta_zero(z3), true).
clause(14, real_part(z3, 0.5), true).
clause(15, imaginary_part(z3, 25.010858), true).
clause(22,
       in_critical_strip(var('Zero')),
       (real_part(var('Zero'), var('Real')), var('Real') > 0, var('Real') < 1)).
clause(23,
       non_trivial_zero(var('Zero')),
       (zeta_zero(var('Zero')), in_critical_strip(var('Zero')), \+ trivial_zero(var('Zero')))).
clause(24,
       on_critical_line(var('Zero')),
       (non_trivial_zero(var('Zero')), real_part(var('Zero'), 0.5))).
clause(26, catalog_has(non_trivial_zero), non_trivial_zero(anonymous(1))).
clause(28,
       finite_catalog_supports_rh(yes),
       (catalog_has(non_trivial_zero), \+ counterexample_found(yes))).
clause(29, summary_row(scope, finite_catalog_only), true).
clause(30,
       summary_row(caveat, "finite catalogue evidence only; this is not a proof of RH"),
       true).
clause(31, rh(var('Key'), var('Value')), summary_row(var('Key'), var('Value'))).
clause(32, rh(status, no_counterexample_in_catalog), finite_catalog_supports_rh(yes)).
clause(34,
       zero_check(var('Zero'), real_part, var('Real')),
       (non_trivial_zero(var('Zero')), real_part(var('Zero'), var('Real')))).
clause(35,
       zero_check(var('Zero'), imaginary_part, var('Imaginary')),
       (non_trivial_zero(var('Zero')), imaginary_part(var('Zero'), var('Imaginary')))).
clause(36,
       zero_check(var('Zero'), classification, on_critical_line),
       on_critical_line(var('Zero'))).

step(rh(scope, finite_catalog_only),
     rule(31),
     ['Key' = scope, 'Value' = finite_catalog_only],
     [summary_row(scope, finite_catalog_only)]).
step(summary_row(scope, finite_catalog_only), fact(29), [], []).
step(rh(caveat, "finite catalogue evidence only; this is not a proof of RH"),
     rule(31),
     ['Key' = caveat, 'Value' = "finite catalogue evidence only; this is not a proof of RH"],
     [summary_row(caveat, "finite catalogue evidence only; this is not a proof of RH")]).
step(summary_row(caveat, "finite catalogue evidence only; this is not a proof of RH"),
     fact(30),
     [],
     []).
step(rh(status, no_counterexample_in_catalog), rule(32), [], [finite_catalog_supports_rh(yes)]).
step(finite_catalog_supports_rh(yes),
     rule(28),
     [],
     [catalog_has(non_trivial_zero), \+ counterexample_found(yes)]).
step(catalog_has(non_trivial_zero), rule(26), [], [non_trivial_zero(z1)]).
step(non_trivial_zero(z1),
     rule(23),
     ['Zero' = z1],
     [zeta_zero(z1), in_critical_strip(z1), \+ trivial_zero(z1)]).
step(zeta_zero(z1), fact(5), [], []).
step(in_critical_strip(z1),
     rule(22),
     ['Zero' = z1, 'Real' = 0.5],
     [real_part(z1, 0.5), 0.5 > 0, 0.5 < 1]).
step(real_part(z1, 0.5), fact(6), [], []).
step(0.5 > 0, builtin, [], []).
step(0.5 < 1, builtin, [], []).
step(\+ trivial_zero(z1), absent, [], []).
step(\+ counterexample_found(yes), absent, [], []).
step(zero_check(z1, real_part, 0.5),
     rule(34),
     ['Zero' = z1, 'Real' = 0.5],
     [non_trivial_zero(z1), real_part(z1, 0.5)]).
step(zero_check(z2, real_part, 0.5),
     rule(34),
     ['Zero' = z2, 'Real' = 0.5],
     [non_trivial_zero(z2), real_part(z2, 0.5)]).
step(non_trivial_zero(z2),
     rule(23),
     ['Zero' = z2],
     [zeta_zero(z2), in_critical_strip(z2), \+ trivial_zero(z2)]).
step(zeta_zero(z2), fact(9), [], []).
step(in_critical_strip(z2),
     rule(22),
     ['Zero' = z2, 'Real' = 0.5],
     [real_part(z2, 0.5), 0.5 > 0, 0.5 < 1]).
step(real_part(z2, 0.5), fact(10), [], []).
step(\+ trivial_zero(z2), absent, [], []).
step(zero_check(z3, real_part, 0.5),
     rule(34),
     ['Zero' = z3, 'Real' = 0.5],
     [non_trivial_zero(z3), real_part(z3, 0.5)]).
step(non_trivial_zero(z3),
     rule(23),
     ['Zero' = z3],
     [zeta_zero(z3), in_critical_strip(z3), \+ trivial_zero(z3)]).
step(zeta_zero(z3), fact(13), [], []).
step(in_critical_strip(z3),
     rule(22),
     ['Zero' = z3, 'Real' = 0.5],
     [real_part(z3, 0.5), 0.5 > 0, 0.5 < 1]).
step(real_part(z3, 0.5), fact(14), [], []).
step(\+ trivial_zero(z3), absent, [], []).
step(zero_check(z1, imaginary_part, 14.134725),
     rule(35),
     ['Zero' = z1, 'Imaginary' = 14.134725],
     [non_trivial_zero(z1), imaginary_part(z1, 14.134725)]).
step(imaginary_part(z1, 14.134725), fact(7), [], []).
step(zero_check(z2, imaginary_part, 21.02204),
     rule(35),
     ['Zero' = z2, 'Imaginary' = 21.02204],
     [non_trivial_zero(z2), imaginary_part(z2, 21.02204)]).
step(imaginary_part(z2, 21.02204), fact(11), [], []).
step(zero_check(z3, imaginary_part, 25.010858),
     rule(35),
     ['Zero' = z3, 'Imaginary' = 25.010858],
     [non_trivial_zero(z3), imaginary_part(z3, 25.010858)]).
step(imaginary_part(z3, 25.010858), fact(15), [], []).
step(zero_check(z1, classification, on_critical_line),
     rule(36),
     ['Zero' = z1],
     [on_critical_line(z1)]).
step(on_critical_line(z1), rule(24), ['Zero' = z1], [non_trivial_zero(z1), real_part(z1, 0.5)]).
step(zero_check(z2, classification, on_critical_line),
     rule(36),
     ['Zero' = z2],
     [on_critical_line(z2)]).
step(on_critical_line(z2), rule(24), ['Zero' = z2], [non_trivial_zero(z2), real_part(z2, 0.5)]).
step(zero_check(z3, classification, on_critical_line),
     rule(36),
     ['Zero' = z3],
     [on_critical_line(z3)]).
step(on_critical_line(z3), rule(24), ['Zero' = z3], [non_trivial_zero(z3), real_part(z3, 0.5)]).
