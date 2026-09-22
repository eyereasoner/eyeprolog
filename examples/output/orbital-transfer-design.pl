% Prolog result format 4
query(1, transferSemiMajorAxis_km(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = mars_hohmann, 'X1' = 188768535.35]).
query(2, departureDeltaV_km_s(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = mars_hohmann, 'X1' = 2.9446911328430403]).
query(3, arrivalDeltaV_km_s(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = mars_hohmann, 'X1' = 2.6488967223855973]).
query(4, totalDeltaV_km_s(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4, ['X0' = mars_hohmann, 'X1' = 5.5935878552286376]).
query(5, transferTime_days(_0, _1), ['X0' = _0, 'X1' = _1]).
result(5, complete, 1).
answer(5, ['X0' = mars_hohmann, 'X1' = 258.865826767963]).
query(6, status(_0, _1), ['X0' = _0, 'X1' = _1]).
result(6, complete, 1).
answer(6, ['X0' = mars_hohmann, 'X1' = feasible_reference_transfer]).
query(7, reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(7, complete, 1).
answer(7,
       ['X0' = mars_hohmann,
        'X1' = "total Hohmann transfer delta-v is within the mission budget"]).
