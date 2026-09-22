% Prolog result format 4
query(1, report(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 4).
answer(1, ['X0' = next_task, 'X1' = check_power]).
why(1, ['X0' = next_task, 'X1' = check_power], [report(next_task, check_power)]).
answer(1,
       ['X0' = all_tasks,
        'X1' = [task(check_power, urgent), task(check_network, normal), task(archive_logs, low)]]).
why(1,
    ['X0' = all_tasks,
     'X1' = [task(check_power, urgent), task(check_network, normal), task(archive_logs, low)]],
    [report(all_tasks, [task(check_power, urgent), task(check_network, normal), task(archive_logs, low)])]).
answer(1, ['X0' = old_task_removed, 'X1' = yes]).
why(1, ['X0' = old_task_removed, 'X1' = yes], [report(old_task_removed, yes)]).
answer(1, ['X0' = dynamic_predicate, 'X1' = yes]).
why(1, ['X0' = dynamic_predicate, 'X1' = yes], [report(dynamic_predicate, yes)]).

clause(5, report(next_task, var('Task')), once(task(var('Task'), anonymous(1)))).
clause(6,
       report(all_tasks, var('Tasks')),
       findall(task(var('Task'), var('Priority')), task(var('Task'), var('Priority')), var('Tasks'))).
clause(7, report(old_task_removed, yes), \+ task(old_probe, obsolete)).
clause(8, report(dynamic_predicate, yes), current_predicate(task / 2)).

step(report(next_task, check_power),
     rule(5),
     ['Task' = check_power],
     [once(task(check_power, urgent))]).
step(once(task(check_power, urgent)), builtin, [], [task(check_power, urgent)]).
step(task(check_power, urgent), asserted, [], []).
step(report(all_tasks, [task(check_power, urgent), task(check_network, normal), task(archive_logs, low)]),
     rule(6),
     ['Tasks' = [task(check_power, urgent), task(check_network, normal), task(archive_logs, low)]],
     [findall(task(Task, Priority), task(Task, Priority), [task(check_power, urgent), task(check_network, normal), task(archive_logs, low)])]).
step(findall(task(Task, Priority), task(Task, Priority), [task(check_power, urgent), task(check_network, normal), task(archive_logs, low)]),
     collected,
     [],
     []).
step(report(old_task_removed, yes), rule(7), [], [\+ task(old_probe, obsolete)]).
step(\+ task(old_probe, obsolete), absent, [], []).
step(report(dynamic_predicate, yes), rule(8), [], [current_predicate(task / 2)]).
step(current_predicate(task / 2), builtin, [], []).
