% Prolog result format 4
query(1, report(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 4).
answer(1, ['X0' = next_task, 'X1' = check_power]).
answer(1,
       ['X0' = all_tasks,
        'X1' = [task(check_power, urgent), task(check_network, normal), task(archive_logs, low)]]).
answer(1, ['X0' = old_task_removed, 'X1' = yes]).
answer(1, ['X0' = dynamic_predicate, 'X1' = yes]).
