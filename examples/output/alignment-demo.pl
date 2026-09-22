% Prolog result format 4
query(1, broader(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 4).
answer(1, ['X0' = tel_car, 'X1' = ref_car]).
answer(1, ['X0' = tel_heavy_vehicle, 'X1' = ref_car]).
answer(1, ['X0' = anpr_vehicle_with_plate, 'X1' = ref_car]).
answer(1, ['X0' = anpr_passenger_car, 'X1' = anpr_vehicle_with_plate]).
query(2, narrower(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 4).
answer(2, ['X0' = ref_car, 'X1' = tel_car]).
answer(2, ['X0' = ref_car, 'X1' = tel_heavy_vehicle]).
answer(2, ['X0' = ref_car, 'X1' = anpr_vehicle_with_plate]).
answer(2, ['X0' = anpr_vehicle_with_plate, 'X1' = anpr_passenger_car]).
query(3, broaderTransitive(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 5).
answer(3, ['X0' = tel_car, 'X1' = ref_car]).
answer(3, ['X0' = tel_heavy_vehicle, 'X1' = ref_car]).
answer(3, ['X0' = anpr_vehicle_with_plate, 'X1' = ref_car]).
answer(3, ['X0' = anpr_passenger_car, 'X1' = anpr_vehicle_with_plate]).
answer(3, ['X0' = anpr_passenger_car, 'X1' = ref_car]).
query(4, narrowerTransitive(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 5).
answer(4, ['X0' = ref_car, 'X1' = tel_car]).
answer(4, ['X0' = ref_car, 'X1' = tel_heavy_vehicle]).
answer(4, ['X0' = ref_car, 'X1' = anpr_vehicle_with_plate]).
answer(4, ['X0' = anpr_vehicle_with_plate, 'X1' = anpr_passenger_car]).
answer(4, ['X0' = ref_car, 'X1' = anpr_passenger_car]).
query(5, narrowerOrEqualOf(_0, _1), ['X0' = _0, 'X1' = _1]).
result(5, complete, 10).
answer(5, ['X0' = ref_car, 'X1' = ref_car]).
answer(5, ['X0' = tel_car, 'X1' = tel_car]).
answer(5, ['X0' = tel_heavy_vehicle, 'X1' = tel_heavy_vehicle]).
answer(5, ['X0' = anpr_vehicle_with_plate, 'X1' = anpr_vehicle_with_plate]).
answer(5, ['X0' = anpr_passenger_car, 'X1' = anpr_passenger_car]).
answer(5, ['X0' = tel_car, 'X1' = ref_car]).
answer(5, ['X0' = tel_heavy_vehicle, 'X1' = ref_car]).
answer(5, ['X0' = anpr_vehicle_with_plate, 'X1' = ref_car]).
answer(5, ['X0' = anpr_passenger_car, 'X1' = anpr_vehicle_with_plate]).
answer(5, ['X0' = anpr_passenger_car, 'X1' = ref_car]).
query(6, rollsUpTo(_0, _1), ['X0' = _0, 'X1' = _1]).
result(6, complete, 4).
answer(6, ['X0' = tel_car, 'X1' = ref_car]).
answer(6, ['X0' = tel_heavy_vehicle, 'X1' = ref_car]).
answer(6, ['X0' = anpr_vehicle_with_plate, 'X1' = ref_car]).
answer(6, ['X0' = anpr_passenger_car, 'X1' = ref_car]).
