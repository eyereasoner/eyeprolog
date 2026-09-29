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

clause(1, environment(clear_only, [sensor_clear]), true).
clause(2, environment(blocked_only, [sensor_blocked]), true).
clause(3, environment(conflicting_sensors, [sensor_clear, sensor_blocked]), true).
clause(4, environment(override_blocked, [sensor_blocked, operator_override]), true).
clause(5,
       assumes(var('Environment'), var('Assumption')),
       (environment(var('Environment'), var('Assumptions')),
        member(var('Assumption'), var('Assumptions')))).
clause(6, justification(j_clear_path, [assumption(sensor_clear)], clear_path), true).
clause(7, justification(j_blocked_path, [assumption(sensor_blocked)], blocked_path), true).
clause(8, justification(j_permit_from_clear, [clear_path], permit_go), true).
clause(9, justification(j_forbid_from_blocked, [blocked_path], forbid_go), true).
clause(10,
       justification(j_override, [assumption(operator_override), blocked_path], permit_go),
       true).
clause(11, all_hold(anonymous(1), []), true).
clause(12,
       all_hold(var('Environment'), [assumption(var('Assumption')) | var('Rest')]),
       (assumes(var('Environment'), var('Assumption')),
        all_hold(var('Environment'), var('Rest')))).
clause(13,
       all_hold(var('Environment'), [var('Belief') | var('Rest')]),
       (supported(var('Environment'), var('Belief')), all_hold(var('Environment'), var('Rest')))).
clause(14,
       supported(var('Environment'), var('Belief')),
       (justification(anonymous(1), var('Preconditions'), var('Belief')),
        all_hold(var('Environment'), var('Preconditions')))).
clause(15, contradicts(permit_go, forbid_go), true).
clause(16, contradicts(forbid_go, permit_go), true).
clause(17,
       inconsistent(var('Environment')),
       (supported(var('Environment'), var('Left')),
        supported(var('Environment'), var('Right')),
        contradicts(var('Left'), var('Right')))).
clause(18,
       fires(var('Environment'), var('Justification'), var('Belief')),
       (justification(var('Justification'), var('Preconditions'), var('Belief')),
        all_hold(var('Environment'), var('Preconditions')))).
clause(19,
       tmsSupport(var('Environment'), var('Belief')),
       supported(var('Environment'), var('Belief'))).
clause(20,
       tmsJustification(var('Environment'), var('Justification'), var('Belief')),
       fires(var('Environment'), var('Justification'), var('Belief'))).
clause(21, tmsInconsistent(var('Environment')), inconsistent(var('Environment'))).
clause(22,
       tmsConclusion(case, "truth maintenance separates support from consistency across assumption environments"),
       inconsistent(conflicting_sensors)).

step(tmsSupport(clear_only, clear_path),
     rule(19),
     ['Environment' = clear_only, 'Belief' = clear_path],
     [supported(clear_only, clear_path)]).
step(supported(clear_only, clear_path),
     rule(14),
     ['Environment' = clear_only,
      'Belief' = clear_path,
      'Preconditions' = [assumption(sensor_clear)]],
     [justification(j_clear_path, [assumption(sensor_clear)], clear_path),
      all_hold(clear_only, [assumption(sensor_clear)])]).
step(justification(j_clear_path, [assumption(sensor_clear)], clear_path), fact(6), [], []).
step(all_hold(clear_only, [assumption(sensor_clear)]),
     rule(12),
     ['Environment' = clear_only, 'Assumption' = sensor_clear, 'Rest' = []],
     [assumes(clear_only, sensor_clear), all_hold(clear_only, [])]).
step(assumes(clear_only, sensor_clear),
     rule(5),
     ['Environment' = clear_only, 'Assumption' = sensor_clear, 'Assumptions' = [sensor_clear]],
     [environment(clear_only, [sensor_clear]), member(sensor_clear, [sensor_clear])]).
step(environment(clear_only, [sensor_clear]), fact(1), [], []).
step(member(sensor_clear, [sensor_clear]), builtin, [], []).
step(all_hold(clear_only, []), fact(11), [], []).
step(tmsSupport(conflicting_sensors, clear_path),
     rule(19),
     ['Environment' = conflicting_sensors, 'Belief' = clear_path],
     [supported(conflicting_sensors, clear_path)]).
step(supported(conflicting_sensors, clear_path),
     rule(14),
     ['Environment' = conflicting_sensors,
      'Belief' = clear_path,
      'Preconditions' = [assumption(sensor_clear)]],
     [justification(j_clear_path, [assumption(sensor_clear)], clear_path),
      all_hold(conflicting_sensors, [assumption(sensor_clear)])]).
step(all_hold(conflicting_sensors, [assumption(sensor_clear)]),
     rule(12),
     ['Environment' = conflicting_sensors, 'Assumption' = sensor_clear, 'Rest' = []],
     [assumes(conflicting_sensors, sensor_clear), all_hold(conflicting_sensors, [])]).
step(assumes(conflicting_sensors, sensor_clear),
     rule(5),
     ['Environment' = conflicting_sensors,
      'Assumption' = sensor_clear,
      'Assumptions' = [sensor_clear, sensor_blocked]],
     [environment(conflicting_sensors, [sensor_clear, sensor_blocked]),
      member(sensor_clear, [sensor_clear, sensor_blocked])]).
step(environment(conflicting_sensors, [sensor_clear, sensor_blocked]), fact(3), [], []).
step(member(sensor_clear, [sensor_clear, sensor_blocked]), builtin, [], []).
step(all_hold(conflicting_sensors, []), fact(11), [], []).
step(tmsSupport(blocked_only, blocked_path),
     rule(19),
     ['Environment' = blocked_only, 'Belief' = blocked_path],
     [supported(blocked_only, blocked_path)]).
step(supported(blocked_only, blocked_path),
     rule(14),
     ['Environment' = blocked_only,
      'Belief' = blocked_path,
      'Preconditions' = [assumption(sensor_blocked)]],
     [justification(j_blocked_path, [assumption(sensor_blocked)], blocked_path),
      all_hold(blocked_only, [assumption(sensor_blocked)])]).
step(justification(j_blocked_path, [assumption(sensor_blocked)], blocked_path), fact(7), [], []).
step(all_hold(blocked_only, [assumption(sensor_blocked)]),
     rule(12),
     ['Environment' = blocked_only, 'Assumption' = sensor_blocked, 'Rest' = []],
     [assumes(blocked_only, sensor_blocked), all_hold(blocked_only, [])]).
step(assumes(blocked_only, sensor_blocked),
     rule(5),
     ['Environment' = blocked_only,
      'Assumption' = sensor_blocked,
      'Assumptions' = [sensor_blocked]],
     [environment(blocked_only, [sensor_blocked]), member(sensor_blocked, [sensor_blocked])]).
step(environment(blocked_only, [sensor_blocked]), fact(2), [], []).
step(member(sensor_blocked, [sensor_blocked]), builtin, [], []).
step(all_hold(blocked_only, []), fact(11), [], []).
step(tmsSupport(conflicting_sensors, blocked_path),
     rule(19),
     ['Environment' = conflicting_sensors, 'Belief' = blocked_path],
     [supported(conflicting_sensors, blocked_path)]).
step(supported(conflicting_sensors, blocked_path),
     rule(14),
     ['Environment' = conflicting_sensors,
      'Belief' = blocked_path,
      'Preconditions' = [assumption(sensor_blocked)]],
     [justification(j_blocked_path, [assumption(sensor_blocked)], blocked_path),
      all_hold(conflicting_sensors, [assumption(sensor_blocked)])]).
step(all_hold(conflicting_sensors, [assumption(sensor_blocked)]),
     rule(12),
     ['Environment' = conflicting_sensors, 'Assumption' = sensor_blocked, 'Rest' = []],
     [assumes(conflicting_sensors, sensor_blocked), all_hold(conflicting_sensors, [])]).
step(assumes(conflicting_sensors, sensor_blocked),
     rule(5),
     ['Environment' = conflicting_sensors,
      'Assumption' = sensor_blocked,
      'Assumptions' = [sensor_clear, sensor_blocked]],
     [environment(conflicting_sensors, [sensor_clear, sensor_blocked]),
      member(sensor_blocked, [sensor_clear, sensor_blocked])]).
step(member(sensor_blocked, [sensor_clear, sensor_blocked]), builtin, [], []).
step(tmsSupport(override_blocked, blocked_path),
     rule(19),
     ['Environment' = override_blocked, 'Belief' = blocked_path],
     [supported(override_blocked, blocked_path)]).
step(supported(override_blocked, blocked_path),
     rule(14),
     ['Environment' = override_blocked,
      'Belief' = blocked_path,
      'Preconditions' = [assumption(sensor_blocked)]],
     [justification(j_blocked_path, [assumption(sensor_blocked)], blocked_path),
      all_hold(override_blocked, [assumption(sensor_blocked)])]).
step(all_hold(override_blocked, [assumption(sensor_blocked)]),
     rule(12),
     ['Environment' = override_blocked, 'Assumption' = sensor_blocked, 'Rest' = []],
     [assumes(override_blocked, sensor_blocked), all_hold(override_blocked, [])]).
step(assumes(override_blocked, sensor_blocked),
     rule(5),
     ['Environment' = override_blocked,
      'Assumption' = sensor_blocked,
      'Assumptions' = [sensor_blocked, operator_override]],
     [environment(override_blocked, [sensor_blocked, operator_override]),
      member(sensor_blocked, [sensor_blocked, operator_override])]).
step(environment(override_blocked, [sensor_blocked, operator_override]), fact(4), [], []).
step(member(sensor_blocked, [sensor_blocked, operator_override]), builtin, [], []).
step(all_hold(override_blocked, []), fact(11), [], []).
step(tmsSupport(clear_only, permit_go),
     rule(19),
     ['Environment' = clear_only, 'Belief' = permit_go],
     [supported(clear_only, permit_go)]).
step(supported(clear_only, permit_go),
     rule(14),
     ['Environment' = clear_only, 'Belief' = permit_go, 'Preconditions' = [clear_path]],
     [justification(j_permit_from_clear, [clear_path], permit_go),
      all_hold(clear_only, [clear_path])]).
step(justification(j_permit_from_clear, [clear_path], permit_go), fact(8), [], []).
step(all_hold(clear_only, [clear_path]),
     rule(13),
     ['Environment' = clear_only, 'Belief' = clear_path, 'Rest' = []],
     [supported(clear_only, clear_path), all_hold(clear_only, [])]).
step(tmsSupport(conflicting_sensors, permit_go),
     rule(19),
     ['Environment' = conflicting_sensors, 'Belief' = permit_go],
     [supported(conflicting_sensors, permit_go)]).
step(supported(conflicting_sensors, permit_go),
     rule(14),
     ['Environment' = conflicting_sensors, 'Belief' = permit_go, 'Preconditions' = [clear_path]],
     [justification(j_permit_from_clear, [clear_path], permit_go),
      all_hold(conflicting_sensors, [clear_path])]).
step(all_hold(conflicting_sensors, [clear_path]),
     rule(13),
     ['Environment' = conflicting_sensors, 'Belief' = clear_path, 'Rest' = []],
     [supported(conflicting_sensors, clear_path), all_hold(conflicting_sensors, [])]).
step(tmsSupport(blocked_only, forbid_go),
     rule(19),
     ['Environment' = blocked_only, 'Belief' = forbid_go],
     [supported(blocked_only, forbid_go)]).
step(supported(blocked_only, forbid_go),
     rule(14),
     ['Environment' = blocked_only, 'Belief' = forbid_go, 'Preconditions' = [blocked_path]],
     [justification(j_forbid_from_blocked, [blocked_path], forbid_go),
      all_hold(blocked_only, [blocked_path])]).
step(justification(j_forbid_from_blocked, [blocked_path], forbid_go), fact(9), [], []).
step(all_hold(blocked_only, [blocked_path]),
     rule(13),
     ['Environment' = blocked_only, 'Belief' = blocked_path, 'Rest' = []],
     [supported(blocked_only, blocked_path), all_hold(blocked_only, [])]).
step(tmsSupport(conflicting_sensors, forbid_go),
     rule(19),
     ['Environment' = conflicting_sensors, 'Belief' = forbid_go],
     [supported(conflicting_sensors, forbid_go)]).
step(supported(conflicting_sensors, forbid_go),
     rule(14),
     ['Environment' = conflicting_sensors,
      'Belief' = forbid_go,
      'Preconditions' = [blocked_path]],
     [justification(j_forbid_from_blocked, [blocked_path], forbid_go),
      all_hold(conflicting_sensors, [blocked_path])]).
step(all_hold(conflicting_sensors, [blocked_path]),
     rule(13),
     ['Environment' = conflicting_sensors, 'Belief' = blocked_path, 'Rest' = []],
     [supported(conflicting_sensors, blocked_path), all_hold(conflicting_sensors, [])]).
step(tmsSupport(override_blocked, forbid_go),
     rule(19),
     ['Environment' = override_blocked, 'Belief' = forbid_go],
     [supported(override_blocked, forbid_go)]).
step(supported(override_blocked, forbid_go),
     rule(14),
     ['Environment' = override_blocked, 'Belief' = forbid_go, 'Preconditions' = [blocked_path]],
     [justification(j_forbid_from_blocked, [blocked_path], forbid_go),
      all_hold(override_blocked, [blocked_path])]).
step(all_hold(override_blocked, [blocked_path]),
     rule(13),
     ['Environment' = override_blocked, 'Belief' = blocked_path, 'Rest' = []],
     [supported(override_blocked, blocked_path), all_hold(override_blocked, [])]).
step(tmsSupport(override_blocked, permit_go),
     rule(19),
     ['Environment' = override_blocked, 'Belief' = permit_go],
     [supported(override_blocked, permit_go)]).
step(supported(override_blocked, permit_go),
     rule(14),
     ['Environment' = override_blocked,
      'Belief' = permit_go,
      'Preconditions' = [assumption(operator_override), blocked_path]],
     [justification(j_override, [assumption(operator_override), blocked_path], permit_go),
      all_hold(override_blocked, [assumption(operator_override), blocked_path])]).
step(justification(j_override, [assumption(operator_override), blocked_path], permit_go),
     fact(10),
     [],
     []).
step(all_hold(override_blocked, [assumption(operator_override), blocked_path]),
     rule(12),
     ['Environment' = override_blocked,
      'Assumption' = operator_override,
      'Rest' = [blocked_path]],
     [assumes(override_blocked, operator_override), all_hold(override_blocked, [blocked_path])]).
step(assumes(override_blocked, operator_override),
     rule(5),
     ['Environment' = override_blocked,
      'Assumption' = operator_override,
      'Assumptions' = [sensor_blocked, operator_override]],
     [environment(override_blocked, [sensor_blocked, operator_override]),
      member(operator_override, [sensor_blocked, operator_override])]).
step(member(operator_override, [sensor_blocked, operator_override]), builtin, [], []).
step(tmsJustification(clear_only, j_clear_path, clear_path),
     rule(20),
     ['Environment' = clear_only, 'Justification' = j_clear_path, 'Belief' = clear_path],
     [fires(clear_only, j_clear_path, clear_path)]).
step(fires(clear_only, j_clear_path, clear_path),
     rule(18),
     ['Environment' = clear_only,
      'Justification' = j_clear_path,
      'Belief' = clear_path,
      'Preconditions' = [assumption(sensor_clear)]],
     [justification(j_clear_path, [assumption(sensor_clear)], clear_path),
      all_hold(clear_only, [assumption(sensor_clear)])]).
step(tmsJustification(conflicting_sensors, j_clear_path, clear_path),
     rule(20),
     ['Environment' = conflicting_sensors,
      'Justification' = j_clear_path,
      'Belief' = clear_path],
     [fires(conflicting_sensors, j_clear_path, clear_path)]).
step(fires(conflicting_sensors, j_clear_path, clear_path),
     rule(18),
     ['Environment' = conflicting_sensors,
      'Justification' = j_clear_path,
      'Belief' = clear_path,
      'Preconditions' = [assumption(sensor_clear)]],
     [justification(j_clear_path, [assumption(sensor_clear)], clear_path),
      all_hold(conflicting_sensors, [assumption(sensor_clear)])]).
step(tmsJustification(blocked_only, j_blocked_path, blocked_path),
     rule(20),
     ['Environment' = blocked_only, 'Justification' = j_blocked_path, 'Belief' = blocked_path],
     [fires(blocked_only, j_blocked_path, blocked_path)]).
step(fires(blocked_only, j_blocked_path, blocked_path),
     rule(18),
     ['Environment' = blocked_only,
      'Justification' = j_blocked_path,
      'Belief' = blocked_path,
      'Preconditions' = [assumption(sensor_blocked)]],
     [justification(j_blocked_path, [assumption(sensor_blocked)], blocked_path),
      all_hold(blocked_only, [assumption(sensor_blocked)])]).
step(tmsJustification(conflicting_sensors, j_blocked_path, blocked_path),
     rule(20),
     ['Environment' = conflicting_sensors,
      'Justification' = j_blocked_path,
      'Belief' = blocked_path],
     [fires(conflicting_sensors, j_blocked_path, blocked_path)]).
step(fires(conflicting_sensors, j_blocked_path, blocked_path),
     rule(18),
     ['Environment' = conflicting_sensors,
      'Justification' = j_blocked_path,
      'Belief' = blocked_path,
      'Preconditions' = [assumption(sensor_blocked)]],
     [justification(j_blocked_path, [assumption(sensor_blocked)], blocked_path),
      all_hold(conflicting_sensors, [assumption(sensor_blocked)])]).
step(tmsJustification(override_blocked, j_blocked_path, blocked_path),
     rule(20),
     ['Environment' = override_blocked,
      'Justification' = j_blocked_path,
      'Belief' = blocked_path],
     [fires(override_blocked, j_blocked_path, blocked_path)]).
step(fires(override_blocked, j_blocked_path, blocked_path),
     rule(18),
     ['Environment' = override_blocked,
      'Justification' = j_blocked_path,
      'Belief' = blocked_path,
      'Preconditions' = [assumption(sensor_blocked)]],
     [justification(j_blocked_path, [assumption(sensor_blocked)], blocked_path),
      all_hold(override_blocked, [assumption(sensor_blocked)])]).
step(tmsJustification(clear_only, j_permit_from_clear, permit_go),
     rule(20),
     ['Environment' = clear_only, 'Justification' = j_permit_from_clear, 'Belief' = permit_go],
     [fires(clear_only, j_permit_from_clear, permit_go)]).
step(fires(clear_only, j_permit_from_clear, permit_go),
     rule(18),
     ['Environment' = clear_only,
      'Justification' = j_permit_from_clear,
      'Belief' = permit_go,
      'Preconditions' = [clear_path]],
     [justification(j_permit_from_clear, [clear_path], permit_go),
      all_hold(clear_only, [clear_path])]).
step(tmsJustification(conflicting_sensors, j_permit_from_clear, permit_go),
     rule(20),
     ['Environment' = conflicting_sensors,
      'Justification' = j_permit_from_clear,
      'Belief' = permit_go],
     [fires(conflicting_sensors, j_permit_from_clear, permit_go)]).
step(fires(conflicting_sensors, j_permit_from_clear, permit_go),
     rule(18),
     ['Environment' = conflicting_sensors,
      'Justification' = j_permit_from_clear,
      'Belief' = permit_go,
      'Preconditions' = [clear_path]],
     [justification(j_permit_from_clear, [clear_path], permit_go),
      all_hold(conflicting_sensors, [clear_path])]).
step(tmsJustification(blocked_only, j_forbid_from_blocked, forbid_go),
     rule(20),
     ['Environment' = blocked_only,
      'Justification' = j_forbid_from_blocked,
      'Belief' = forbid_go],
     [fires(blocked_only, j_forbid_from_blocked, forbid_go)]).
step(fires(blocked_only, j_forbid_from_blocked, forbid_go),
     rule(18),
     ['Environment' = blocked_only,
      'Justification' = j_forbid_from_blocked,
      'Belief' = forbid_go,
      'Preconditions' = [blocked_path]],
     [justification(j_forbid_from_blocked, [blocked_path], forbid_go),
      all_hold(blocked_only, [blocked_path])]).
step(tmsJustification(conflicting_sensors, j_forbid_from_blocked, forbid_go),
     rule(20),
     ['Environment' = conflicting_sensors,
      'Justification' = j_forbid_from_blocked,
      'Belief' = forbid_go],
     [fires(conflicting_sensors, j_forbid_from_blocked, forbid_go)]).
step(fires(conflicting_sensors, j_forbid_from_blocked, forbid_go),
     rule(18),
     ['Environment' = conflicting_sensors,
      'Justification' = j_forbid_from_blocked,
      'Belief' = forbid_go,
      'Preconditions' = [blocked_path]],
     [justification(j_forbid_from_blocked, [blocked_path], forbid_go),
      all_hold(conflicting_sensors, [blocked_path])]).
step(tmsJustification(override_blocked, j_forbid_from_blocked, forbid_go),
     rule(20),
     ['Environment' = override_blocked,
      'Justification' = j_forbid_from_blocked,
      'Belief' = forbid_go],
     [fires(override_blocked, j_forbid_from_blocked, forbid_go)]).
step(fires(override_blocked, j_forbid_from_blocked, forbid_go),
     rule(18),
     ['Environment' = override_blocked,
      'Justification' = j_forbid_from_blocked,
      'Belief' = forbid_go,
      'Preconditions' = [blocked_path]],
     [justification(j_forbid_from_blocked, [blocked_path], forbid_go),
      all_hold(override_blocked, [blocked_path])]).
step(tmsJustification(override_blocked, j_override, permit_go),
     rule(20),
     ['Environment' = override_blocked, 'Justification' = j_override, 'Belief' = permit_go],
     [fires(override_blocked, j_override, permit_go)]).
step(fires(override_blocked, j_override, permit_go),
     rule(18),
     ['Environment' = override_blocked,
      'Justification' = j_override,
      'Belief' = permit_go,
      'Preconditions' = [assumption(operator_override), blocked_path]],
     [justification(j_override, [assumption(operator_override), blocked_path], permit_go),
      all_hold(override_blocked, [assumption(operator_override), blocked_path])]).
step(tmsInconsistent(conflicting_sensors),
     rule(21),
     ['Environment' = conflicting_sensors],
     [inconsistent(conflicting_sensors)]).
step(inconsistent(conflicting_sensors),
     rule(17),
     ['Environment' = conflicting_sensors, 'Left' = permit_go, 'Right' = forbid_go],
     [supported(conflicting_sensors, permit_go),
      supported(conflicting_sensors, forbid_go),
      contradicts(permit_go, forbid_go)]).
step(contradicts(permit_go, forbid_go), fact(15), [], []).
step(tmsInconsistent(override_blocked),
     rule(21),
     ['Environment' = override_blocked],
     [inconsistent(override_blocked)]).
step(inconsistent(override_blocked),
     rule(17),
     ['Environment' = override_blocked, 'Left' = forbid_go, 'Right' = permit_go],
     [supported(override_blocked, forbid_go),
      supported(override_blocked, permit_go),
      contradicts(forbid_go, permit_go)]).
step(contradicts(forbid_go, permit_go), fact(16), [], []).
step(tmsConclusion(case, "truth maintenance separates support from consistency across assumption environments"),
     rule(22),
     [],
     [inconsistent(conflicting_sensors)]).
