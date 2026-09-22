% Prolog result format 4
query(1, status(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 4).
answer(1, ['X0' = early_lactation, 'X1' = negative_energy_balance]).
answer(1, ['X0' = grazing, 'X1' = negative_energy_balance]).
answer(1, ['X0' = mid_lactation, 'X1' = near_neutral_energy_balance]).
answer(1, ['X0' = late_lactation, 'X1' = positive_energy_balance]).
query(2, energyBalance_Mcal(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 4).
answer(2, ['X0' = early_lactation, 'X1' = -101.19999999999999]).
answer(2, ['X0' = mid_lactation, 'X1' = 0.19999999999998863]).
answer(2, ['X0' = late_lactation, 'X1' = 41.099999999999994]).
answer(2, ['X0' = grazing, 'X1' = -11.399999999999991]).
query(3, rationSupportedMilk_kg(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 4).
answer(3, ['X0' = early_lactation, 'X1' = 17.76]).
answer(3, ['X0' = mid_lactation, 'X1' = 24.04]).
answer(3, ['X0' = late_lactation, 'X1' = 24.22]).
answer(3, ['X0' = grazing, 'X1' = 15.719999999999999]).
query(4, reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 0).
query(5, strongestDeficit(_0, _1), ['X0' = _0, 'X1' = _1]).
result(5, complete, 1).
answer(5, ['X0' = dairy_energy_balance, 'X1' = early_lactation]).
