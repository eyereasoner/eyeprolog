critical_path_answer(project_finish, 23).
critical_path_answer(critical_task, launch).
critical_path_answer(critical_task, security_review).
critical_path_answer(critical_task, integration).
critical_path_answer(critical_task, backend).
critical_path_answer(critical_task, database).
critical_path_answer(critical_task, architecture).
critical_path_answer(critical_task, requirements).
critical_path_answer(schedule, task(requirements, 0, 2)).
critical_path_answer(schedule, task(architecture, 2, 5)).
critical_path_answer(schedule, task(api_design, 2, 4)).
critical_path_answer(schedule, task(database, 5, 9)).
critical_path_answer(schedule, task(backend, 9, 15)).
critical_path_answer(schedule, task(frontend, 4, 9)).
critical_path_answer(schedule, task(auth, 5, 8)).
critical_path_answer(schedule, task(integration, 15, 19)).
critical_path_answer(schedule, task(security_review, 19, 22)).
critical_path_answer(schedule, task(load_test, 19, 21)).
critical_path_answer(schedule, task(launch, 22, 23)).

clause(3, task(requirements, 2), true).
clause(4, task(architecture, 3), true).
clause(5, task(api_design, 2), true).
clause(6, task(database, 4), true).
clause(7, task(backend, 6), true).
clause(8, task(frontend, 5), true).
clause(9, task(auth, 3), true).
clause(10, task(integration, 4), true).
clause(11, task(security_review, 3), true).
clause(12, task(load_test, 2), true).
clause(13, task(launch, 1), true).
clause(14, depends(architecture, requirements), true).
clause(15, depends(api_design, requirements), true).
clause(16, depends(database, architecture), true).
clause(17, depends(backend, api_design), true).
clause(19, depends(frontend, api_design), true).
clause(20, depends(auth, architecture), true).
clause(21, depends(integration, backend), true).
clause(24, depends(security_review, integration), true).
clause(25, depends(load_test, integration), true).
clause(26, depends(launch, security_review), true).
clause(28,
       earliest_start(var('Task'), 0),
       (task(var('Task'), anonymous(1)), \+ depends(var('Task'), anonymous(2)))).
clause(29,
       earliest_start(var('Task'), var('Start')),
       (depends(var('Task'), anonymous(1)),
        aggregate_max(var('Finish'), var('Pred'), (depends(var('Task'), var('Pred')), finish_time(var('Pred'), var('Finish'))), var('Start'), anonymous(2)))).
clause(30,
       finish_time(var('Task'), var('Finish')),
       (task(var('Task'), var('Duration')),
        earliest_start(var('Task'), var('Start')),
        var('Finish') is var('Start') + var('Duration'))).
clause(31,
       critical_predecessor(var('Task'), var('Pred')),
       (depends(var('Task'), anonymous(1)),
        aggregate_max(var('Finish'), var('P'), (depends(var('Task'), var('P')), finish_time(var('P'), var('Finish'))), anonymous(2), var('Pred')))).
clause(32,
       project_finish(var('Finish')),
       aggregate_max(var('Finishtime'), var('Task'), finish_time(var('Task'), var('Finishtime')), var('Finish'), anonymous(1))).
clause(33,
       final_task(var('Task')),
       (project_finish(var('Finish')), finish_time(var('Task'), var('Finish')))).
clause(34, critical_chain(var('Task'), var('Task')), true).
clause(35,
       critical_chain(var('Task'), var('Pred')),
       (critical_predecessor(var('Task'), var('Parent')),
        critical_chain(var('Parent'), var('Pred')))).
clause(36,
       critical_task(var('Task')),
       (final_task(var('Final')), critical_chain(var('Final'), var('Task')))).
clause(37, critical_path_answer(project_finish, var('Finish')), project_finish(var('Finish'))).
clause(38, critical_path_answer(critical_task, var('Task')), critical_task(var('Task'))).
clause(39,
       critical_path_answer(schedule, task(var('Task'), var('Start'), var('Finish'))),
       (task(var('Task'), anonymous(1)),
        earliest_start(var('Task'), var('Start')),
        finish_time(var('Task'), var('Finish')))).

step(critical_path_answer(project_finish, 23), rule(37), ['Finish' = 23], [project_finish(23)]).
step(project_finish(23),
     rule(32),
     ['Finish' = 23],
     [aggregate_max(Key, Value, finish_time(Value, Key), 23, launch)]).
step(aggregate_max(Key, Value, finish_time(Value, Key), 23, launch), builtin, [], []).
step(critical_path_answer(critical_task, launch),
     rule(38),
     ['Task' = launch],
     [critical_task(launch)]).
step(critical_task(launch),
     rule(36),
     ['Task' = launch, 'Final' = launch],
     [final_task(launch), critical_chain(launch, launch)]).
step(final_task(launch),
     rule(33),
     ['Task' = launch, 'Finish' = 23],
     [project_finish(23), finish_time(launch, 23)]).
step(finish_time(launch, 23),
     rule(30),
     ['Task' = launch, 'Finish' = 23, 'Duration' = 1, 'Start' = 22],
     [task(launch, 1), earliest_start(launch, 22), 23 is 22 + 1]).
step(task(launch, 1), fact(13), [], []).
step(earliest_start(launch, 22),
     rule(29),
     ['Task' = launch, 'Start' = 22],
     [depends(launch, security_review),
      aggregate_max(Key, Value, (depends(launch, Value), finish_time(Value, Key)), 22, security_review)]).
step(depends(launch, security_review), fact(26), [], []).
step(aggregate_max(Key, Value, (depends(launch, Value), finish_time(Value, Key)), 22, security_review),
     builtin,
     [],
     []).
step(23 is 22 + 1, builtin, [], []).
step(critical_chain(launch, launch), fact(34), ['Task' = launch], []).
step(critical_path_answer(critical_task, security_review),
     rule(38),
     ['Task' = security_review],
     [critical_task(security_review)]).
step(critical_task(security_review),
     rule(36),
     ['Task' = security_review, 'Final' = launch],
     [final_task(launch), critical_chain(launch, security_review)]).
step(critical_chain(launch, security_review),
     rule(35),
     ['Task' = launch, 'Pred' = security_review, 'Parent' = security_review],
     [critical_predecessor(launch, security_review),
      critical_chain(security_review, security_review)]).
step(critical_predecessor(launch, security_review),
     rule(31),
     ['Task' = launch, 'Pred' = security_review],
     [depends(launch, security_review),
      aggregate_max(Key, Value, (depends(launch, Value), finish_time(Value, Key)), 22, security_review)]).
step(critical_chain(security_review, security_review), fact(34), ['Task' = security_review], []).
step(critical_path_answer(critical_task, integration),
     rule(38),
     ['Task' = integration],
     [critical_task(integration)]).
step(critical_task(integration),
     rule(36),
     ['Task' = integration, 'Final' = launch],
     [final_task(launch), critical_chain(launch, integration)]).
step(critical_chain(launch, integration),
     rule(35),
     ['Task' = launch, 'Pred' = integration, 'Parent' = security_review],
     [critical_predecessor(launch, security_review),
      critical_chain(security_review, integration)]).
step(critical_chain(security_review, integration),
     rule(35),
     ['Task' = security_review, 'Pred' = integration, 'Parent' = integration],
     [critical_predecessor(security_review, integration),
      critical_chain(integration, integration)]).
step(critical_predecessor(security_review, integration),
     rule(31),
     ['Task' = security_review, 'Pred' = integration],
     [depends(security_review, integration),
      aggregate_max(Key, Value, (depends(security_review, Value), finish_time(Value, Key)), 19, integration)]).
step(depends(security_review, integration), fact(24), [], []).
step(aggregate_max(Key, Value, (depends(security_review, Value), finish_time(Value, Key)), 19, integration),
     builtin,
     [],
     []).
step(critical_chain(integration, integration), fact(34), ['Task' = integration], []).
step(critical_path_answer(critical_task, backend),
     rule(38),
     ['Task' = backend],
     [critical_task(backend)]).
step(critical_task(backend),
     rule(36),
     ['Task' = backend, 'Final' = launch],
     [final_task(launch), critical_chain(launch, backend)]).
step(critical_chain(launch, backend),
     rule(35),
     ['Task' = launch, 'Pred' = backend, 'Parent' = security_review],
     [critical_predecessor(launch, security_review), critical_chain(security_review, backend)]).
step(critical_chain(security_review, backend),
     rule(35),
     ['Task' = security_review, 'Pred' = backend, 'Parent' = integration],
     [critical_predecessor(security_review, integration), critical_chain(integration, backend)]).
step(critical_chain(integration, backend),
     rule(35),
     ['Task' = integration, 'Pred' = backend, 'Parent' = backend],
     [critical_predecessor(integration, backend), critical_chain(backend, backend)]).
step(critical_predecessor(integration, backend),
     rule(31),
     ['Task' = integration, 'Pred' = backend],
     [depends(integration, backend),
      aggregate_max(Key, Value, (depends(integration, Value), finish_time(Value, Key)), 15, backend)]).
step(depends(integration, backend), fact(21), [], []).
step(aggregate_max(Key, Value, (depends(integration, Value), finish_time(Value, Key)), 15, backend),
     builtin,
     [],
     []).
step(critical_chain(backend, backend), fact(34), ['Task' = backend], []).
step(critical_path_answer(critical_task, database),
     rule(38),
     ['Task' = database],
     [critical_task(database)]).
step(critical_task(database),
     rule(36),
     ['Task' = database, 'Final' = launch],
     [final_task(launch), critical_chain(launch, database)]).
step(critical_chain(launch, database),
     rule(35),
     ['Task' = launch, 'Pred' = database, 'Parent' = security_review],
     [critical_predecessor(launch, security_review), critical_chain(security_review, database)]).
step(critical_chain(security_review, database),
     rule(35),
     ['Task' = security_review, 'Pred' = database, 'Parent' = integration],
     [critical_predecessor(security_review, integration), critical_chain(integration, database)]).
step(critical_chain(integration, database),
     rule(35),
     ['Task' = integration, 'Pred' = database, 'Parent' = backend],
     [critical_predecessor(integration, backend), critical_chain(backend, database)]).
step(critical_chain(backend, database),
     rule(35),
     ['Task' = backend, 'Pred' = database, 'Parent' = database],
     [critical_predecessor(backend, database), critical_chain(database, database)]).
step(critical_predecessor(backend, database),
     rule(31),
     ['Task' = backend, 'Pred' = database],
     [depends(backend, api_design),
      aggregate_max(Key, Value, (depends(backend, Value), finish_time(Value, Key)), 9, database)]).
step(depends(backend, api_design), fact(17), [], []).
step(aggregate_max(Key, Value, (depends(backend, Value), finish_time(Value, Key)), 9, database),
     builtin,
     [],
     []).
step(critical_chain(database, database), fact(34), ['Task' = database], []).
step(critical_path_answer(critical_task, architecture),
     rule(38),
     ['Task' = architecture],
     [critical_task(architecture)]).
step(critical_task(architecture),
     rule(36),
     ['Task' = architecture, 'Final' = launch],
     [final_task(launch), critical_chain(launch, architecture)]).
step(critical_chain(launch, architecture),
     rule(35),
     ['Task' = launch, 'Pred' = architecture, 'Parent' = security_review],
     [critical_predecessor(launch, security_review),
      critical_chain(security_review, architecture)]).
step(critical_chain(security_review, architecture),
     rule(35),
     ['Task' = security_review, 'Pred' = architecture, 'Parent' = integration],
     [critical_predecessor(security_review, integration),
      critical_chain(integration, architecture)]).
step(critical_chain(integration, architecture),
     rule(35),
     ['Task' = integration, 'Pred' = architecture, 'Parent' = backend],
     [critical_predecessor(integration, backend), critical_chain(backend, architecture)]).
step(critical_chain(backend, architecture),
     rule(35),
     ['Task' = backend, 'Pred' = architecture, 'Parent' = database],
     [critical_predecessor(backend, database), critical_chain(database, architecture)]).
step(critical_chain(database, architecture),
     rule(35),
     ['Task' = database, 'Pred' = architecture, 'Parent' = architecture],
     [critical_predecessor(database, architecture), critical_chain(architecture, architecture)]).
step(critical_predecessor(database, architecture),
     rule(31),
     ['Task' = database, 'Pred' = architecture],
     [depends(database, architecture),
      aggregate_max(Key, Value, (depends(database, Value), finish_time(Value, Key)), 5, architecture)]).
step(depends(database, architecture), fact(16), [], []).
step(aggregate_max(Key, Value, (depends(database, Value), finish_time(Value, Key)), 5, architecture),
     builtin,
     [],
     []).
step(critical_chain(architecture, architecture), fact(34), ['Task' = architecture], []).
step(critical_path_answer(critical_task, requirements),
     rule(38),
     ['Task' = requirements],
     [critical_task(requirements)]).
step(critical_task(requirements),
     rule(36),
     ['Task' = requirements, 'Final' = launch],
     [final_task(launch), critical_chain(launch, requirements)]).
step(critical_chain(launch, requirements),
     rule(35),
     ['Task' = launch, 'Pred' = requirements, 'Parent' = security_review],
     [critical_predecessor(launch, security_review),
      critical_chain(security_review, requirements)]).
step(critical_chain(security_review, requirements),
     rule(35),
     ['Task' = security_review, 'Pred' = requirements, 'Parent' = integration],
     [critical_predecessor(security_review, integration),
      critical_chain(integration, requirements)]).
step(critical_chain(integration, requirements),
     rule(35),
     ['Task' = integration, 'Pred' = requirements, 'Parent' = backend],
     [critical_predecessor(integration, backend), critical_chain(backend, requirements)]).
step(critical_chain(backend, requirements),
     rule(35),
     ['Task' = backend, 'Pred' = requirements, 'Parent' = database],
     [critical_predecessor(backend, database), critical_chain(database, requirements)]).
step(critical_chain(database, requirements),
     rule(35),
     ['Task' = database, 'Pred' = requirements, 'Parent' = architecture],
     [critical_predecessor(database, architecture), critical_chain(architecture, requirements)]).
step(critical_chain(architecture, requirements),
     rule(35),
     ['Task' = architecture, 'Pred' = requirements, 'Parent' = requirements],
     [critical_predecessor(architecture, requirements),
      critical_chain(requirements, requirements)]).
step(critical_predecessor(architecture, requirements),
     rule(31),
     ['Task' = architecture, 'Pred' = requirements],
     [depends(architecture, requirements),
      aggregate_max(Key, Value, (depends(architecture, Value), finish_time(Value, Key)), 2, requirements)]).
step(depends(architecture, requirements), fact(14), [], []).
step(aggregate_max(Key, Value, (depends(architecture, Value), finish_time(Value, Key)), 2, requirements),
     builtin,
     [],
     []).
step(critical_chain(requirements, requirements), fact(34), ['Task' = requirements], []).
step(critical_path_answer(schedule, task(requirements, 0, 2)),
     rule(39),
     ['Task' = requirements, 'Start' = 0, 'Finish' = 2],
     [task(requirements, 2), earliest_start(requirements, 0), finish_time(requirements, 2)]).
step(task(requirements, 2), fact(3), [], []).
step(earliest_start(requirements, 0),
     rule(28),
     ['Task' = requirements],
     [task(requirements, 2), \+ depends(requirements, _pred)]).
step(\+ depends(requirements, _pred), absent, [], []).
step(finish_time(requirements, 2),
     rule(30),
     ['Task' = requirements, 'Finish' = 2, 'Duration' = 2, 'Start' = 0],
     [task(requirements, 2), earliest_start(requirements, 0), 2 is 0 + 2]).
step(2 is 0 + 2, builtin, [], []).
step(critical_path_answer(schedule, task(architecture, 2, 5)),
     rule(39),
     ['Task' = architecture, 'Start' = 2, 'Finish' = 5],
     [task(architecture, 3), earliest_start(architecture, 2), finish_time(architecture, 5)]).
step(task(architecture, 3), fact(4), [], []).
step(earliest_start(architecture, 2),
     rule(29),
     ['Task' = architecture, 'Start' = 2],
     [depends(architecture, requirements),
      aggregate_max(Key, Value, (depends(architecture, Value), finish_time(Value, Key)), 2, requirements)]).
step(finish_time(architecture, 5),
     rule(30),
     ['Task' = architecture, 'Finish' = 5, 'Duration' = 3, 'Start' = 2],
     [task(architecture, 3), earliest_start(architecture, 2), 5 is 2 + 3]).
step(5 is 2 + 3, builtin, [], []).
step(critical_path_answer(schedule, task(api_design, 2, 4)),
     rule(39),
     ['Task' = api_design, 'Start' = 2, 'Finish' = 4],
     [task(api_design, 2), earliest_start(api_design, 2), finish_time(api_design, 4)]).
step(task(api_design, 2), fact(5), [], []).
step(earliest_start(api_design, 2),
     rule(29),
     ['Task' = api_design, 'Start' = 2],
     [depends(api_design, requirements),
      aggregate_max(Key, Value, (depends(api_design, Value), finish_time(Value, Key)), 2, requirements)]).
step(depends(api_design, requirements), fact(15), [], []).
step(aggregate_max(Key, Value, (depends(api_design, Value), finish_time(Value, Key)), 2, requirements),
     builtin,
     [],
     []).
step(finish_time(api_design, 4),
     rule(30),
     ['Task' = api_design, 'Finish' = 4, 'Duration' = 2, 'Start' = 2],
     [task(api_design, 2), earliest_start(api_design, 2), 4 is 2 + 2]).
step(4 is 2 + 2, builtin, [], []).
step(critical_path_answer(schedule, task(database, 5, 9)),
     rule(39),
     ['Task' = database, 'Start' = 5, 'Finish' = 9],
     [task(database, 4), earliest_start(database, 5), finish_time(database, 9)]).
step(task(database, 4), fact(6), [], []).
step(earliest_start(database, 5),
     rule(29),
     ['Task' = database, 'Start' = 5],
     [depends(database, architecture),
      aggregate_max(Key, Value, (depends(database, Value), finish_time(Value, Key)), 5, architecture)]).
step(finish_time(database, 9),
     rule(30),
     ['Task' = database, 'Finish' = 9, 'Duration' = 4, 'Start' = 5],
     [task(database, 4), earliest_start(database, 5), 9 is 5 + 4]).
step(9 is 5 + 4, builtin, [], []).
step(critical_path_answer(schedule, task(backend, 9, 15)),
     rule(39),
     ['Task' = backend, 'Start' = 9, 'Finish' = 15],
     [task(backend, 6), earliest_start(backend, 9), finish_time(backend, 15)]).
step(task(backend, 6), fact(7), [], []).
step(earliest_start(backend, 9),
     rule(29),
     ['Task' = backend, 'Start' = 9],
     [depends(backend, api_design),
      aggregate_max(Key, Value, (depends(backend, Value), finish_time(Value, Key)), 9, database)]).
step(finish_time(backend, 15),
     rule(30),
     ['Task' = backend, 'Finish' = 15, 'Duration' = 6, 'Start' = 9],
     [task(backend, 6), earliest_start(backend, 9), 15 is 9 + 6]).
step(15 is 9 + 6, builtin, [], []).
step(critical_path_answer(schedule, task(frontend, 4, 9)),
     rule(39),
     ['Task' = frontend, 'Start' = 4, 'Finish' = 9],
     [task(frontend, 5), earliest_start(frontend, 4), finish_time(frontend, 9)]).
step(task(frontend, 5), fact(8), [], []).
step(earliest_start(frontend, 4),
     rule(29),
     ['Task' = frontend, 'Start' = 4],
     [depends(frontend, api_design),
      aggregate_max(Key, Value, (depends(frontend, Value), finish_time(Value, Key)), 4, api_design)]).
step(depends(frontend, api_design), fact(19), [], []).
step(aggregate_max(Key, Value, (depends(frontend, Value), finish_time(Value, Key)), 4, api_design),
     builtin,
     [],
     []).
step(finish_time(frontend, 9),
     rule(30),
     ['Task' = frontend, 'Finish' = 9, 'Duration' = 5, 'Start' = 4],
     [task(frontend, 5), earliest_start(frontend, 4), 9 is 4 + 5]).
step(9 is 4 + 5, builtin, [], []).
step(critical_path_answer(schedule, task(auth, 5, 8)),
     rule(39),
     ['Task' = auth, 'Start' = 5, 'Finish' = 8],
     [task(auth, 3), earliest_start(auth, 5), finish_time(auth, 8)]).
step(task(auth, 3), fact(9), [], []).
step(earliest_start(auth, 5),
     rule(29),
     ['Task' = auth, 'Start' = 5],
     [depends(auth, architecture),
      aggregate_max(Key, Value, (depends(auth, Value), finish_time(Value, Key)), 5, architecture)]).
step(depends(auth, architecture), fact(20), [], []).
step(aggregate_max(Key, Value, (depends(auth, Value), finish_time(Value, Key)), 5, architecture),
     builtin,
     [],
     []).
step(finish_time(auth, 8),
     rule(30),
     ['Task' = auth, 'Finish' = 8, 'Duration' = 3, 'Start' = 5],
     [task(auth, 3), earliest_start(auth, 5), 8 is 5 + 3]).
step(8 is 5 + 3, builtin, [], []).
step(critical_path_answer(schedule, task(integration, 15, 19)),
     rule(39),
     ['Task' = integration, 'Start' = 15, 'Finish' = 19],
     [task(integration, 4), earliest_start(integration, 15), finish_time(integration, 19)]).
step(task(integration, 4), fact(10), [], []).
step(earliest_start(integration, 15),
     rule(29),
     ['Task' = integration, 'Start' = 15],
     [depends(integration, backend),
      aggregate_max(Key, Value, (depends(integration, Value), finish_time(Value, Key)), 15, backend)]).
step(finish_time(integration, 19),
     rule(30),
     ['Task' = integration, 'Finish' = 19, 'Duration' = 4, 'Start' = 15],
     [task(integration, 4), earliest_start(integration, 15), 19 is 15 + 4]).
step(19 is 15 + 4, builtin, [], []).
step(critical_path_answer(schedule, task(security_review, 19, 22)),
     rule(39),
     ['Task' = security_review, 'Start' = 19, 'Finish' = 22],
     [task(security_review, 3),
      earliest_start(security_review, 19),
      finish_time(security_review, 22)]).
step(task(security_review, 3), fact(11), [], []).
step(earliest_start(security_review, 19),
     rule(29),
     ['Task' = security_review, 'Start' = 19],
     [depends(security_review, integration),
      aggregate_max(Key, Value, (depends(security_review, Value), finish_time(Value, Key)), 19, integration)]).
step(finish_time(security_review, 22),
     rule(30),
     ['Task' = security_review, 'Finish' = 22, 'Duration' = 3, 'Start' = 19],
     [task(security_review, 3), earliest_start(security_review, 19), 22 is 19 + 3]).
step(22 is 19 + 3, builtin, [], []).
step(critical_path_answer(schedule, task(load_test, 19, 21)),
     rule(39),
     ['Task' = load_test, 'Start' = 19, 'Finish' = 21],
     [task(load_test, 2), earliest_start(load_test, 19), finish_time(load_test, 21)]).
step(task(load_test, 2), fact(12), [], []).
step(earliest_start(load_test, 19),
     rule(29),
     ['Task' = load_test, 'Start' = 19],
     [depends(load_test, integration),
      aggregate_max(Key, Value, (depends(load_test, Value), finish_time(Value, Key)), 19, integration)]).
step(depends(load_test, integration), fact(25), [], []).
step(aggregate_max(Key, Value, (depends(load_test, Value), finish_time(Value, Key)), 19, integration),
     builtin,
     [],
     []).
step(finish_time(load_test, 21),
     rule(30),
     ['Task' = load_test, 'Finish' = 21, 'Duration' = 2, 'Start' = 19],
     [task(load_test, 2), earliest_start(load_test, 19), 21 is 19 + 2]).
step(21 is 19 + 2, builtin, [], []).
step(critical_path_answer(schedule, task(launch, 22, 23)),
     rule(39),
     ['Task' = launch, 'Start' = 22, 'Finish' = 23],
     [task(launch, 1), earliest_start(launch, 22), finish_time(launch, 23)]).
