report(next_task, check_power).
why(
  report(next_task, check_power),
  step(
    report(next_task, check_power),
    rule("iso-dynamic-database.pl", clause(5)),
    ['Task' = check_power, '__anon0' = urgent],
    [
      step(
        once(task(check_power, urgent)),
        builtin(once, 1),
        [],
        [
          step(task(check_power, urgent), fact("<input>", clause(8)), [], [])
        ]
      )
    ]
  )
).

report(all_tasks, [task(check_power, urgent), task(check_network, normal), task(archive_logs, low)]).
why(
  report(all_tasks, [task(check_power, urgent), task(check_network, normal), task(archive_logs, low)]),
  step(
    report(all_tasks, [task(check_power, urgent), task(check_network, normal), task(archive_logs, low)]),
    rule("iso-dynamic-database.pl", clause(6)),
    ['Tasks' = [task(check_power, urgent), task(check_network, normal), task(archive_logs, low)]],
    [
      step(findall(task(Task, Priority), task(Task, Priority), [task(check_power, urgent), task(check_network, normal), task(archive_logs, low)]), builtin(findall, 3), [], [])
    ]
  )
).

report(old_task_removed, yes).
why(
  report(old_task_removed, yes),
  step(
    report(old_task_removed, yes),
    rule("iso-dynamic-database.pl", clause(7)),
    [],
    [
      step('\\+'(task(old_probe, obsolete)), builtin('\\+', 1), [], [])
    ]
  )
).

report(dynamic_predicate, yes).
why(
  report(dynamic_predicate, yes),
  step(
    report(dynamic_predicate, yes),
    rule("iso-dynamic-database.pl", clause(8)),
    [],
    [
      step(current_predicate(/(task, 2)), builtin(current_predicate, 1), [], [])
    ]
  )
).

