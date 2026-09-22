% Prolog result format 4
query(1, critical_path_answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 19).
answer(1, ['X0' = project_finish, 'X1' = 23]).
answer(1, ['X0' = critical_task, 'X1' = launch]).
answer(1, ['X0' = critical_task, 'X1' = security_review]).
answer(1, ['X0' = critical_task, 'X1' = integration]).
answer(1, ['X0' = critical_task, 'X1' = backend]).
answer(1, ['X0' = critical_task, 'X1' = database]).
answer(1, ['X0' = critical_task, 'X1' = architecture]).
answer(1, ['X0' = critical_task, 'X1' = requirements]).
answer(1, ['X0' = schedule, 'X1' = task(requirements, 0, 2)]).
answer(1, ['X0' = schedule, 'X1' = task(architecture, 2, 5)]).
answer(1, ['X0' = schedule, 'X1' = task(api_design, 2, 4)]).
answer(1, ['X0' = schedule, 'X1' = task(database, 5, 9)]).
answer(1, ['X0' = schedule, 'X1' = task(backend, 9, 15)]).
answer(1, ['X0' = schedule, 'X1' = task(frontend, 4, 9)]).
answer(1, ['X0' = schedule, 'X1' = task(auth, 5, 8)]).
answer(1, ['X0' = schedule, 'X1' = task(integration, 15, 19)]).
answer(1, ['X0' = schedule, 'X1' = task(security_review, 19, 22)]).
answer(1, ['X0' = schedule, 'X1' = task(load_test, 19, 21)]).
answer(1, ['X0' = schedule, 'X1' = task(launch, 22, 23)]).
