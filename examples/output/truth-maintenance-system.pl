tmsSupport(clear_only, clear_path).
tmsSupport(conflicting_sensors, clear_path).
tmsSupport(blocked_only, blocked_path).
tmsSupport(conflicting_sensors, blocked_path).
tmsSupport(override_blocked, blocked_path).
tmsSupport(clear_only, permit_go).
tmsSupport(conflicting_sensors, permit_go).
tmsSupport(blocked_only, forbid_go).
tmsSupport(conflicting_sensors, forbid_go).
tmsSupport(override_blocked, forbid_go).
tmsSupport(override_blocked, permit_go).
tmsJustification(clear_only, j_clear_path, clear_path).
tmsJustification(conflicting_sensors, j_clear_path, clear_path).
tmsJustification(blocked_only, j_blocked_path, blocked_path).
tmsJustification(conflicting_sensors, j_blocked_path, blocked_path).
tmsJustification(override_blocked, j_blocked_path, blocked_path).
tmsJustification(clear_only, j_permit_from_clear, permit_go).
tmsJustification(conflicting_sensors, j_permit_from_clear, permit_go).
tmsJustification(blocked_only, j_forbid_from_blocked, forbid_go).
tmsJustification(conflicting_sensors, j_forbid_from_blocked, forbid_go).
tmsJustification(override_blocked, j_forbid_from_blocked, forbid_go).
tmsJustification(override_blocked, j_override, permit_go).
tmsInconsistent(conflicting_sensors).
tmsInconsistent(override_blocked).
tmsConclusion(case, "truth maintenance separates support from consistency across assumption environments").
