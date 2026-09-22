% Prolog result format 4
query(1, report(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 7).
answer(1, ['X0' = shape, 'X1' = shape(event, 2)]).
answer(1, ['X0' = payload, 'X1' = reading(temperature, 21)]).
answer(1, ['X0' = parts, 'X1' = [event, sensor_7, reading(temperature, 21)]]).
answer(1, ['X0' = rebuilt, 'X1' = alert(sensor_7, high)]).
answer(1, ['X0' = variable_count, 'X1' = 3]).
answer(1, ['X0' = copied_shape, 'X1' = same_but_fresh]).
answer(1, ['X0' = order, 'X1' = (<)]).
