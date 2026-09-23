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
