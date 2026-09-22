% Prolog result format 4
query(1, tmsSupport(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 11).
answer(1, ['X0' = clear_only, 'X1' = clear_path]).
answer(1, ['X0' = conflicting_sensors, 'X1' = clear_path]).
answer(1, ['X0' = blocked_only, 'X1' = blocked_path]).
answer(1, ['X0' = conflicting_sensors, 'X1' = blocked_path]).
answer(1, ['X0' = override_blocked, 'X1' = blocked_path]).
answer(1, ['X0' = clear_only, 'X1' = permit_go]).
answer(1, ['X0' = conflicting_sensors, 'X1' = permit_go]).
answer(1, ['X0' = blocked_only, 'X1' = forbid_go]).
answer(1, ['X0' = conflicting_sensors, 'X1' = forbid_go]).
answer(1, ['X0' = override_blocked, 'X1' = forbid_go]).
answer(1, ['X0' = override_blocked, 'X1' = permit_go]).
query(2, tmsJustification(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(2, complete, 11).
answer(2, ['X0' = clear_only, 'X1' = j_clear_path, 'X2' = clear_path]).
answer(2, ['X0' = conflicting_sensors, 'X1' = j_clear_path, 'X2' = clear_path]).
answer(2, ['X0' = blocked_only, 'X1' = j_blocked_path, 'X2' = blocked_path]).
answer(2, ['X0' = conflicting_sensors, 'X1' = j_blocked_path, 'X2' = blocked_path]).
answer(2, ['X0' = override_blocked, 'X1' = j_blocked_path, 'X2' = blocked_path]).
answer(2, ['X0' = clear_only, 'X1' = j_permit_from_clear, 'X2' = permit_go]).
answer(2, ['X0' = conflicting_sensors, 'X1' = j_permit_from_clear, 'X2' = permit_go]).
answer(2, ['X0' = blocked_only, 'X1' = j_forbid_from_blocked, 'X2' = forbid_go]).
answer(2, ['X0' = conflicting_sensors, 'X1' = j_forbid_from_blocked, 'X2' = forbid_go]).
answer(2, ['X0' = override_blocked, 'X1' = j_forbid_from_blocked, 'X2' = forbid_go]).
answer(2, ['X0' = override_blocked, 'X1' = j_override, 'X2' = permit_go]).
query(3, tmsInconsistent(_0), ['X0' = _0]).
result(3, complete, 2).
answer(3, ['X0' = conflicting_sensors]).
answer(3, ['X0' = override_blocked]).
query(4, tmsConclusion(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4,
       ['X0' = case,
        'X1' = "truth maintenance separates support from consistency across assumption environments"]).
