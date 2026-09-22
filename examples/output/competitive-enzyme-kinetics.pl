% Prolog result format 4
query(1, effectiveKm_uM(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = assay1, 'X1' = 90.0]).
query(2, uninhibitedRate_uM_s(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = assay1, 'X1' = 75.0]).
query(3, inhibitedRate_uM_s(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = assay1, 'X1' = 42.857142857142854]).
query(4, inhibitionFraction(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4, ['X0' = assay1, 'X1' = 0.4285714285714286]).
query(5, status(_0, _1), ['X0' = _0, 'X1' = _1]).
result(5, complete, 1).
answer(5, ['X0' = assay1, 'X1' = significant_inhibition]).
query(6, reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(6, complete, 1).
answer(6,
       ['X0' = assay1,
        'X1' = "competitive inhibitor raises effective Km and lowers reaction rate"]).
