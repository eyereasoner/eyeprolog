% Prolog result format 4
query(1, dutyCycle(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = regulator1, 'X1' = 0.20833333333333334]).
query(2, inductorRipple_A(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = regulator1, 'X1' = 0.35984848484848486]).
query(3, rippleRatio(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = regulator1, 'X1' = 0.17992424242424243]).
query(4, capacitorRipple_V(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4, ['X0' = regulator1, 'X1' = 0.0019140876853642812]).
query(5, status(_0, _1), ['X0' = _0, 'X1' = _1]).
result(5, complete, 1).
answer(5, ['X0' = regulator1, 'X1' = stable_ripple_design]).
query(6, reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(6, complete, 1).
answer(6,
       ['X0' = regulator1,
        'X1' = "inductor-current and output-voltage ripple are below design limits"]).
