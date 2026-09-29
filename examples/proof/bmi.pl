weightKg(case, 72.0).
heightM(case, 1.78).
units(reason, "Inputs were already metric, so kilograms stay kilograms and centimeters are divided by 100 to obtain meters.").
heightSquared(case, 3.1684).
bmi(case, 22.724403484408533).
bmi(answer, 22.72).
bmiRoundedInt(case, 2272).
healthyMinKg(case, 58.6154).
healthyMinKg(answer, 58.6).
healthyMaxKg(case, 78.89316).
healthyMaxKg(answer, 78.9).
healthyMinKgRoundedInt(case, 586).
healthyMaxKgRoundedInt(case, 789).
category(decision, "Normal").
category(answer, "Normal").
heightCm(answer, 178).
heightCm(report, 178).
formula(reason, "BMI is defined as weight in kilograms divided by height in meters squared.").
calculation(reason, "The normalized weight and height were used to compute BMI, then the result was mapped to the WHO adult category table.").
categoryRule(reason, "Normal").
unitsExplanation(reason, "Inputs were already metric, so kilograms stay kilograms and centimeters are divided by 100 to obtain meters.").
c1(check, "OK - the input was normalized into positive SI values.").
c2(check, "OK - height squared was reconstructed from the normalized height.").
c3(check, "OK - the BMI value matches the BMI = kg / m² formula.").
c4(check, "OK - a BMI of 18.49 stays below the normal-weight threshold.").
c5(check, "OK - the lower boundary is half-open: BMI 18.5 is classified as Normal.").
c6(check, "OK - BMI 25.0 starts the Overweight category.").
c7(check, "OK - BMI 30.0 starts the Obesity I category.").
c8(check, "OK - classification behavior is monotonic across representative BMI values.").
c9(check, "OK - the healthy-weight band was reconstructed from BMI 18.5 to 24.9 at the same height.").
result(report, bmi(22.72, "Normal")).
healthyWeightRangeKg(report, range(58.6, 78.9)).
checkPassed(report, c1).
checkPassed(report, c2).
checkPassed(report, c3).
checkPassed(report, c4).
checkPassed(report, c5).
checkPassed(report, c6).
checkPassed(report, c7).
checkPassed(report, c8).
checkPassed(report, c9).

clause(9, unitSystem(input, metric), true).
clause(10, weight(input, 72.0), true).
clause(11, height(input, 178.0), true).
clause(12, weightKg(case, var('W')), (unitSystem(input, metric), weight(input, var('W')))).
clause(13,
       heightM(case, var('M')),
       (unitSystem(input, metric), height(input, var('H')), var('M') is var('H') / 100.0)).
clause(14,
       units(reason, "Inputs were already metric, so kilograms stay kilograms and centimeters are divided by 100 to obtain meters."),
       unitSystem(input, metric)).
clause(18,
       heightSquared(case, var('M2')),
       (heightM(case, var('M')), var('M2') is var('M') * var('M'))).
clause(19,
       bmi(case, var('Bmi')),
       (weightKg(case, var('Kg')),
        heightSquared(case, var('M2')),
        var('Bmi') is var('Kg') / var('M2'))).
clause(20,
       bmiRoundedInt(case, var('Bmiroundedint')),
       (bmi(case, var('Bmi')),
        var('Bmix100') is var('Bmi') * 100.0,
        var('Bmiroundedint') is round(var('Bmix100')))).
clause(21,
       healthyMinKg(case, var('Healthymin')),
       (heightSquared(case, var('M2')), var('Healthymin') is 18.5 * var('M2'))).
clause(22,
       healthyMaxKg(case, var('Healthymax')),
       (heightSquared(case, var('M2')), var('Healthymax') is 24.9 * var('M2'))).
clause(23,
       healthyMinKgRoundedInt(case, var('Minroundedint')),
       (healthyMinKg(case, var('Healthymin')),
        var('Minx10') is var('Healthymin') * 10.0,
        var('Minroundedint') is round(var('Minx10')))).
clause(24,
       healthyMaxKgRoundedInt(case, var('Maxroundedint')),
       (healthyMaxKg(case, var('Healthymax')),
        var('Maxx10') is var('Healthymax') * 10.0,
        var('Maxroundedint') is round(var('Maxx10')))).
clause(26,
       category(decision, "Normal"),
       (bmi(case, var('Bmi')), var('Bmi') >= 18.5, var('Bmi') < 25.0)).
clause(31, bmi(answer, 22.72), bmiRoundedInt(case, 2272)).
clause(32, category(answer, var('Category')), category(decision, var('Category'))).
clause(33, healthyMinKg(answer, 58.6), healthyMinKgRoundedInt(case, 586)).
clause(34, healthyMaxKg(answer, 78.9), healthyMaxKgRoundedInt(case, 789)).
clause(35,
       heightCm(answer, var('Cmrounded')),
       (heightM(case, var('M')),
        var('Cm') is var('M') * 100.0,
        var('Cmrounded') is round(var('Cm')))).
clause(36,
       formula(reason, "BMI is defined as weight in kilograms divided by height in meters squared."),
       bmi(case, anonymous(1))).
clause(37,
       calculation(reason, "The normalized weight and height were used to compute BMI, then the result was mapped to the WHO adult category table."),
       category(decision, anonymous(1))).
clause(38, categoryRule(reason, var('Category')), category(decision, var('Category'))).
clause(39, unitsExplanation(reason, var('Units')), units(reason, var('Units'))).
clause(40,
       c1(check, "OK - the input was normalized into positive SI values."),
       (weightKg(case, var('Kg')), heightM(case, var('M')), var('Kg') > 0, var('M') > 0)).
clause(41,
       c2(check, "OK - height squared was reconstructed from the normalized height."),
       (heightM(case, var('M')),
        heightSquared(case, var('M2')),
        var('M2') is var('M') * var('M'))).
clause(42,
       c3(check, "OK - the BMI value matches the BMI = kg / m² formula."),
       (weightKg(case, var('Kg')),
        heightSquared(case, var('M2')),
        bmi(case, var('Bmi')),
        var('Bmi') is var('Kg') / var('M2'))).
clause(43,
       c4(check, "OK - a BMI of 18.49 stays below the normal-weight threshold."),
       18.49 < 18.5).
clause(44,
       c5(check, "OK - the lower boundary is half-open: BMI 18.5 is classified as Normal."),
       (18.5 >= 18.5, 18.5 < 25.0)).
clause(45,
       c6(check, "OK - BMI 25.0 starts the Overweight category."),
       (25.0 >= 25.0, 25.0 < 30.0)).
clause(46,
       c7(check, "OK - BMI 30.0 starts the Obesity I category."),
       (30.0 >= 30.0, 30.0 < 35.0)).
clause(47,
       c8(check, "OK - classification behavior is monotonic across representative BMI values."),
       (22.0 >= 18.5, 22.0 < 25.0, 27.0 >= 25.0, 27.0 < 30.0, 41.0 >= 40.0)).
clause(48,
       c9(check, "OK - the healthy-weight band was reconstructed from BMI 18.5 to 24.9 at the same height."),
       (heightSquared(case, var('M2')),
        healthyMinKg(case, var('Min')),
        healthyMaxKg(case, var('Max')),
        var('Min') is 18.5 * var('M2'),
        var('Max') is 24.9 * var('M2'))).
clause(49,
       result(report, bmi(var('Bmi'), var('Category'))),
       (bmi(answer, var('Bmi')), category(answer, var('Category')))).
clause(50,
       healthyWeightRangeKg(report, range(var('Min'), var('Max'))),
       (healthyMinKg(answer, var('Min')), healthyMaxKg(answer, var('Max')))).
clause(51, heightCm(report, var('Height')), heightCm(answer, var('Height'))).
clause(52, checkPassed(report, var('Check')), statement(check, var('Check'), anonymous(1))).
clause(53, statement(check, c1, var('Message')), c1(check, var('Message'))).
clause(54, statement(check, c2, var('Message')), c2(check, var('Message'))).
clause(55, statement(check, c3, var('Message')), c3(check, var('Message'))).
clause(56, statement(check, c4, var('Message')), c4(check, var('Message'))).
clause(57, statement(check, c5, var('Message')), c5(check, var('Message'))).
clause(58, statement(check, c6, var('Message')), c6(check, var('Message'))).
clause(59, statement(check, c7, var('Message')), c7(check, var('Message'))).
clause(60, statement(check, c8, var('Message')), c8(check, var('Message'))).
clause(61, statement(check, c9, var('Message')), c9(check, var('Message'))).

step(weightKg(case, 72.0),
     rule(12),
     ['W' = 72.0],
     [unitSystem(input, metric), weight(input, 72.0)]).
step(unitSystem(input, metric), fact(9), [], []).
step(weight(input, 72.0), fact(10), [], []).
step(heightM(case, 1.78),
     rule(13),
     ['M' = 1.78, 'H' = 178.0],
     [unitSystem(input, metric), height(input, 178.0), 1.78 is 178.0 / 100.0]).
step(height(input, 178.0), fact(11), [], []).
step(1.78 is 178.0 / 100.0, builtin, [], []).
step(units(reason, "Inputs were already metric, so kilograms stay kilograms and centimeters are divided by 100 to obtain meters."),
     rule(14),
     [],
     [unitSystem(input, metric)]).
step(heightSquared(case, 3.1684),
     rule(18),
     ['M2' = 3.1684, 'M' = 1.78],
     [heightM(case, 1.78), 3.1684 is 1.78 * 1.78]).
step(3.1684 is 1.78 * 1.78, builtin, [], []).
step(bmi(case, 22.724403484408533),
     rule(19),
     ['Bmi' = 22.724403484408533, 'Kg' = 72.0, 'M2' = 3.1684],
     [weightKg(case, 72.0), heightSquared(case, 3.1684), 22.724403484408533 is 72.0 / 3.1684]).
step(22.724403484408533 is 72.0 / 3.1684, builtin, [], []).
step(bmi(answer, 22.72), rule(31), [], [bmiRoundedInt(case, 2272)]).
step(bmiRoundedInt(case, 2272),
     rule(20),
     ['Bmiroundedint' = 2272, 'Bmi' = 22.724403484408533, 'Bmix100' = 2272.4403484408535],
     [bmi(case, 22.724403484408533),
      2272.4403484408535 is 22.724403484408533 * 100.0,
      2272 is round(2272.4403484408535)]).
step(2272.4403484408535 is 22.724403484408533 * 100.0, builtin, [], []).
step(2272 is round(2272.4403484408535), builtin, [], []).
step(healthyMinKg(case, 58.6154),
     rule(21),
     ['Healthymin' = 58.6154, 'M2' = 3.1684],
     [heightSquared(case, 3.1684), 58.6154 is 18.5 * 3.1684]).
step(58.6154 is 18.5 * 3.1684, builtin, [], []).
step(healthyMinKg(answer, 58.6), rule(33), [], [healthyMinKgRoundedInt(case, 586)]).
step(healthyMinKgRoundedInt(case, 586),
     rule(23),
     ['Minroundedint' = 586, 'Healthymin' = 58.6154, 'Minx10' = 586.154],
     [healthyMinKg(case, 58.6154), 586.154 is 58.6154 * 10.0, 586 is round(586.154)]).
step(586.154 is 58.6154 * 10.0, builtin, [], []).
step(586 is round(586.154), builtin, [], []).
step(healthyMaxKg(case, 78.89316),
     rule(22),
     ['Healthymax' = 78.89316, 'M2' = 3.1684],
     [heightSquared(case, 3.1684), 78.89316 is 24.9 * 3.1684]).
step(78.89316 is 24.9 * 3.1684, builtin, [], []).
step(healthyMaxKg(answer, 78.9), rule(34), [], [healthyMaxKgRoundedInt(case, 789)]).
step(healthyMaxKgRoundedInt(case, 789),
     rule(24),
     ['Maxroundedint' = 789, 'Healthymax' = 78.89316, 'Maxx10' = 788.9315999999999],
     [healthyMaxKg(case, 78.89316),
      788.9315999999999 is 78.89316 * 10.0,
      789 is round(788.9315999999999)]).
step(788.9315999999999 is 78.89316 * 10.0, builtin, [], []).
step(789 is round(788.9315999999999), builtin, [], []).
step(category(decision, "Normal"),
     rule(26),
     ['Bmi' = 22.724403484408533],
     [bmi(case, 22.724403484408533), 22.724403484408533 >= 18.5, 22.724403484408533 < 25.0]).
step(22.724403484408533 >= 18.5, builtin, [], []).
step(22.724403484408533 < 25.0, builtin, [], []).
step(category(answer, "Normal"),
     rule(32),
     ['Category' = "Normal"],
     [category(decision, "Normal")]).
step(heightCm(answer, 178),
     rule(35),
     ['Cmrounded' = 178, 'M' = 1.78, 'Cm' = 178.0],
     [heightM(case, 1.78), 178.0 is 1.78 * 100.0, 178 is round(178.0)]).
step(178.0 is 1.78 * 100.0, builtin, [], []).
step(178 is round(178.0), builtin, [], []).
step(heightCm(report, 178), rule(51), ['Height' = 178], [heightCm(answer, 178)]).
step(formula(reason, "BMI is defined as weight in kilograms divided by height in meters squared."),
     rule(36),
     [],
     [bmi(case, 22.724403484408533)]).
step(calculation(reason, "The normalized weight and height were used to compute BMI, then the result was mapped to the WHO adult category table."),
     rule(37),
     [],
     [category(decision, "Normal")]).
step(categoryRule(reason, "Normal"),
     rule(38),
     ['Category' = "Normal"],
     [category(decision, "Normal")]).
step(unitsExplanation(reason, "Inputs were already metric, so kilograms stay kilograms and centimeters are divided by 100 to obtain meters."),
     rule(39),
     ['Units' = "Inputs were already metric, so kilograms stay kilograms and centimeters are divided by 100 to obtain meters."],
     [units(reason, "Inputs were already metric, so kilograms stay kilograms and centimeters are divided by 100 to obtain meters.")]).
step(c1(check, "OK - the input was normalized into positive SI values."),
     rule(40),
     ['Kg' = 72.0, 'M' = 1.78],
     [weightKg(case, 72.0), heightM(case, 1.78), 72.0 > 0, 1.78 > 0]).
step(72.0 > 0, builtin, [], []).
step(1.78 > 0, builtin, [], []).
step(c2(check, "OK - height squared was reconstructed from the normalized height."),
     rule(41),
     ['M' = 1.78, 'M2' = 3.1684],
     [heightM(case, 1.78), heightSquared(case, 3.1684), 3.1684 is 1.78 * 1.78]).
step(c3(check, "OK - the BMI value matches the BMI = kg / m² formula."),
     rule(42),
     ['Kg' = 72.0, 'M2' = 3.1684, 'Bmi' = 22.724403484408533],
     [weightKg(case, 72.0),
      heightSquared(case, 3.1684),
      bmi(case, 22.724403484408533),
      22.724403484408533 is 72.0 / 3.1684]).
step(c4(check, "OK - a BMI of 18.49 stays below the normal-weight threshold."),
     rule(43),
     [],
     [18.49 < 18.5]).
step(18.49 < 18.5, builtin, [], []).
step(c5(check, "OK - the lower boundary is half-open: BMI 18.5 is classified as Normal."),
     rule(44),
     [],
     [18.5 >= 18.5, 18.5 < 25.0]).
step(18.5 >= 18.5, builtin, [], []).
step(18.5 < 25.0, builtin, [], []).
step(c6(check, "OK - BMI 25.0 starts the Overweight category."),
     rule(45),
     [],
     [25.0 >= 25.0, 25.0 < 30.0]).
step(25.0 >= 25.0, builtin, [], []).
step(25.0 < 30.0, builtin, [], []).
step(c7(check, "OK - BMI 30.0 starts the Obesity I category."),
     rule(46),
     [],
     [30.0 >= 30.0, 30.0 < 35.0]).
step(30.0 >= 30.0, builtin, [], []).
step(30.0 < 35.0, builtin, [], []).
step(c8(check, "OK - classification behavior is monotonic across representative BMI values."),
     rule(47),
     [],
     [22.0 >= 18.5, 22.0 < 25.0, 27.0 >= 25.0, 27.0 < 30.0, 41.0 >= 40.0]).
step(22.0 >= 18.5, builtin, [], []).
step(22.0 < 25.0, builtin, [], []).
step(27.0 >= 25.0, builtin, [], []).
step(27.0 < 30.0, builtin, [], []).
step(41.0 >= 40.0, builtin, [], []).
step(c9(check, "OK - the healthy-weight band was reconstructed from BMI 18.5 to 24.9 at the same height."),
     rule(48),
     ['M2' = 3.1684, 'Min' = 58.6154, 'Max' = 78.89316],
     [heightSquared(case, 3.1684),
      healthyMinKg(case, 58.6154),
      healthyMaxKg(case, 78.89316),
      58.6154 is 18.5 * 3.1684,
      78.89316 is 24.9 * 3.1684]).
step(result(report, bmi(22.72, "Normal")),
     rule(49),
     ['Bmi' = 22.72, 'Category' = "Normal"],
     [bmi(answer, 22.72), category(answer, "Normal")]).
step(healthyWeightRangeKg(report, range(58.6, 78.9)),
     rule(50),
     ['Min' = 58.6, 'Max' = 78.9],
     [healthyMinKg(answer, 58.6), healthyMaxKg(answer, 78.9)]).
step(checkPassed(report, c1),
     rule(52),
     ['Check' = c1],
     [statement(check, c1, "OK - the input was normalized into positive SI values.")]).
step(statement(check, c1, "OK - the input was normalized into positive SI values."),
     rule(53),
     ['Message' = "OK - the input was normalized into positive SI values."],
     [c1(check, "OK - the input was normalized into positive SI values.")]).
step(checkPassed(report, c2),
     rule(52),
     ['Check' = c2],
     [statement(check, c2, "OK - height squared was reconstructed from the normalized height.")]).
step(statement(check, c2, "OK - height squared was reconstructed from the normalized height."),
     rule(54),
     ['Message' = "OK - height squared was reconstructed from the normalized height."],
     [c2(check, "OK - height squared was reconstructed from the normalized height.")]).
step(checkPassed(report, c3),
     rule(52),
     ['Check' = c3],
     [statement(check, c3, "OK - the BMI value matches the BMI = kg / m² formula.")]).
step(statement(check, c3, "OK - the BMI value matches the BMI = kg / m² formula."),
     rule(55),
     ['Message' = "OK - the BMI value matches the BMI = kg / m² formula."],
     [c3(check, "OK - the BMI value matches the BMI = kg / m² formula.")]).
step(checkPassed(report, c4),
     rule(52),
     ['Check' = c4],
     [statement(check, c4, "OK - a BMI of 18.49 stays below the normal-weight threshold.")]).
step(statement(check, c4, "OK - a BMI of 18.49 stays below the normal-weight threshold."),
     rule(56),
     ['Message' = "OK - a BMI of 18.49 stays below the normal-weight threshold."],
     [c4(check, "OK - a BMI of 18.49 stays below the normal-weight threshold.")]).
step(checkPassed(report, c5),
     rule(52),
     ['Check' = c5],
     [statement(check, c5, "OK - the lower boundary is half-open: BMI 18.5 is classified as Normal.")]).
step(statement(check, c5, "OK - the lower boundary is half-open: BMI 18.5 is classified as Normal."),
     rule(57),
     ['Message' = "OK - the lower boundary is half-open: BMI 18.5 is classified as Normal."],
     [c5(check, "OK - the lower boundary is half-open: BMI 18.5 is classified as Normal.")]).
step(checkPassed(report, c6),
     rule(52),
     ['Check' = c6],
     [statement(check, c6, "OK - BMI 25.0 starts the Overweight category.")]).
step(statement(check, c6, "OK - BMI 25.0 starts the Overweight category."),
     rule(58),
     ['Message' = "OK - BMI 25.0 starts the Overweight category."],
     [c6(check, "OK - BMI 25.0 starts the Overweight category.")]).
step(checkPassed(report, c7),
     rule(52),
     ['Check' = c7],
     [statement(check, c7, "OK - BMI 30.0 starts the Obesity I category.")]).
step(statement(check, c7, "OK - BMI 30.0 starts the Obesity I category."),
     rule(59),
     ['Message' = "OK - BMI 30.0 starts the Obesity I category."],
     [c7(check, "OK - BMI 30.0 starts the Obesity I category.")]).
step(checkPassed(report, c8),
     rule(52),
     ['Check' = c8],
     [statement(check, c8, "OK - classification behavior is monotonic across representative BMI values.")]).
step(statement(check, c8, "OK - classification behavior is monotonic across representative BMI values."),
     rule(60),
     ['Message' = "OK - classification behavior is monotonic across representative BMI values."],
     [c8(check, "OK - classification behavior is monotonic across representative BMI values.")]).
step(checkPassed(report, c9),
     rule(52),
     ['Check' = c9],
     [statement(check, c9, "OK - the healthy-weight band was reconstructed from BMI 18.5 to 24.9 at the same height.")]).
step(statement(check, c9, "OK - the healthy-weight band was reconstructed from BMI 18.5 to 24.9 at the same height."),
     rule(61),
     ['Message' = "OK - the healthy-weight band was reconstructed from BMI 18.5 to 24.9 at the same height."],
     [c9(check, "OK - the healthy-weight band was reconstructed from BMI 18.5 to 24.9 at the same height.")]).
