% Prolog result format 4
query(1, unitSystem(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 0).
query(2, weight(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 0).
query(3, height(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 0).
query(4, weightKg(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4, ['X0' = case, 'X1' = 72.0]).
query(5, heightM(_0, _1), ['X0' = _0, 'X1' = _1]).
result(5, complete, 1).
answer(5, ['X0' = case, 'X1' = 1.78]).
query(6, units(_0, _1), ['X0' = _0, 'X1' = _1]).
result(6, complete, 1).
answer(6,
       ['X0' = reason,
        'X1' = "Inputs were already metric, so kilograms stay kilograms and centimeters are divided by 100 to obtain meters."]).
query(7, heightSquared(_0, _1), ['X0' = _0, 'X1' = _1]).
result(7, complete, 1).
answer(7, ['X0' = case, 'X1' = 3.1684]).
query(8, bmi(_0, _1), ['X0' = _0, 'X1' = _1]).
result(8, complete, 2).
answer(8, ['X0' = case, 'X1' = 22.724403484408533]).
answer(8, ['X0' = answer, 'X1' = 22.72]).
query(9, bmiRoundedInt(_0, _1), ['X0' = _0, 'X1' = _1]).
result(9, complete, 1).
answer(9, ['X0' = case, 'X1' = 2272]).
query(10, healthyMinKg(_0, _1), ['X0' = _0, 'X1' = _1]).
result(10, complete, 2).
answer(10, ['X0' = case, 'X1' = 58.6154]).
answer(10, ['X0' = answer, 'X1' = 58.6]).
query(11, healthyMaxKg(_0, _1), ['X0' = _0, 'X1' = _1]).
result(11, complete, 2).
answer(11, ['X0' = case, 'X1' = 78.89316]).
answer(11, ['X0' = answer, 'X1' = 78.9]).
query(12, healthyMinKgRoundedInt(_0, _1), ['X0' = _0, 'X1' = _1]).
result(12, complete, 1).
answer(12, ['X0' = case, 'X1' = 586]).
query(13, healthyMaxKgRoundedInt(_0, _1), ['X0' = _0, 'X1' = _1]).
result(13, complete, 1).
answer(13, ['X0' = case, 'X1' = 789]).
query(14, category(_0, _1), ['X0' = _0, 'X1' = _1]).
result(14, complete, 2).
answer(14, ['X0' = decision, 'X1' = "Normal"]).
answer(14, ['X0' = answer, 'X1' = "Normal"]).
query(15, heightCm(_0, _1), ['X0' = _0, 'X1' = _1]).
result(15, complete, 2).
answer(15, ['X0' = answer, 'X1' = 178]).
answer(15, ['X0' = report, 'X1' = 178]).
query(16, formula(_0, _1), ['X0' = _0, 'X1' = _1]).
result(16, complete, 1).
answer(16,
       ['X0' = reason,
        'X1' = "BMI is defined as weight in kilograms divided by height in meters squared."]).
query(17, calculation(_0, _1), ['X0' = _0, 'X1' = _1]).
result(17, complete, 1).
answer(17,
       ['X0' = reason,
        'X1' = "The normalized weight and height were used to compute BMI, then the result was mapped to the WHO adult category table."]).
query(18, categoryRule(_0, _1), ['X0' = _0, 'X1' = _1]).
result(18, complete, 1).
answer(18, ['X0' = reason, 'X1' = "Normal"]).
query(19, unitsExplanation(_0, _1), ['X0' = _0, 'X1' = _1]).
result(19, complete, 1).
answer(19,
       ['X0' = reason,
        'X1' = "Inputs were already metric, so kilograms stay kilograms and centimeters are divided by 100 to obtain meters."]).
query(20, c1(_0, _1), ['X0' = _0, 'X1' = _1]).
result(20, complete, 1).
answer(20, ['X0' = check, 'X1' = "OK - the input was normalized into positive SI values."]).
query(21, c2(_0, _1), ['X0' = _0, 'X1' = _1]).
result(21, complete, 1).
answer(21,
       ['X0' = check,
        'X1' = "OK - height squared was reconstructed from the normalized height."]).
query(22, c3(_0, _1), ['X0' = _0, 'X1' = _1]).
result(22, complete, 1).
answer(22, ['X0' = check, 'X1' = "OK - the BMI value matches the BMI = kg / m² formula."]).
query(23, c4(_0, _1), ['X0' = _0, 'X1' = _1]).
result(23, complete, 1).
answer(23,
       ['X0' = check, 'X1' = "OK - a BMI of 18.49 stays below the normal-weight threshold."]).
query(24, c5(_0, _1), ['X0' = _0, 'X1' = _1]).
result(24, complete, 1).
answer(24,
       ['X0' = check,
        'X1' = "OK - the lower boundary is half-open: BMI 18.5 is classified as Normal."]).
query(25, c6(_0, _1), ['X0' = _0, 'X1' = _1]).
result(25, complete, 1).
answer(25, ['X0' = check, 'X1' = "OK - BMI 25.0 starts the Overweight category."]).
query(26, c7(_0, _1), ['X0' = _0, 'X1' = _1]).
result(26, complete, 1).
answer(26, ['X0' = check, 'X1' = "OK - BMI 30.0 starts the Obesity I category."]).
query(27, c8(_0, _1), ['X0' = _0, 'X1' = _1]).
result(27, complete, 1).
answer(27,
       ['X0' = check,
        'X1' = "OK - classification behavior is monotonic across representative BMI values."]).
query(28, c9(_0, _1), ['X0' = _0, 'X1' = _1]).
result(28, complete, 1).
answer(28,
       ['X0' = check,
        'X1' = "OK - the healthy-weight band was reconstructed from BMI 18.5 to 24.9 at the same height."]).
query(29, result(_0, _1), ['X0' = _0, 'X1' = _1]).
result(29, complete, 1).
answer(29, ['X0' = report, 'X1' = bmi(22.72, "Normal")]).
query(30, healthyWeightRangeKg(_0, _1), ['X0' = _0, 'X1' = _1]).
result(30, complete, 1).
answer(30, ['X0' = report, 'X1' = range(58.6, 78.9)]).
query(31, checkPassed(_0, _1), ['X0' = _0, 'X1' = _1]).
result(31, complete, 9).
answer(31, ['X0' = report, 'X1' = c1]).
answer(31, ['X0' = report, 'X1' = c2]).
answer(31, ['X0' = report, 'X1' = c3]).
answer(31, ['X0' = report, 'X1' = c4]).
answer(31, ['X0' = report, 'X1' = c5]).
answer(31, ['X0' = report, 'X1' = c6]).
answer(31, ['X0' = report, 'X1' = c7]).
answer(31, ['X0' = report, 'X1' = c8]).
answer(31, ['X0' = report, 'X1' = c9]).
