pipeline_audit(report(stages(5), transitions(4), summaries([stage(0, receive, outgoing(1)), stage(1, parse, outgoing(1)), stage(2, validate, outgoing(1)), stage(3, reason, outgoing(1)), stage(4, publish, outgoing(0))]), trace([step(0, receive, parse), step(1, parse, validate), step(2, validate, reason), step(3, reason, publish), complete]), invariant(true), schema_variant(true))).
why(
  pipeline_audit(report(stages(5), transitions(4), summaries([stage(0, receive, outgoing(1)), stage(1, parse, outgoing(1)), stage(2, validate, outgoing(1)), stage(3, reason, outgoing(1)), stage(4, publish, outgoing(0))]), trace([step(0, receive, parse), step(1, parse, validate), step(2, validate, reason), step(3, reason, publish), complete]), invariant(true), schema_variant(true))),
  step(
    pipeline_audit(report(stages(5), transitions(4), summaries([stage(0, receive, outgoing(1)), stage(1, parse, outgoing(1)), stage(2, validate, outgoing(1)), stage(3, reason, outgoing(1)), stage(4, publish, outgoing(0))]), trace([step(0, receive, parse), step(1, parse, validate), step(2, validate, reason), step(3, reason, publish), complete]), invariant(true), schema_variant(true))),
    rule("iso-extension-pipeline-audit.pl", clause(9)),
    ['StageCount' = 5, 'TransitionCount' = 4, 'StageSummaries' = [stage(0, receive, outgoing(1)), stage(1, parse, outgoing(1)), stage(2, validate, outgoing(1)), stage(3, reason, outgoing(1)), stage(4, publish, outgoing(0))], 'Trace' = [step(0, receive, parse), step(1, parse, validate), step(2, validate, reason), step(3, reason, publish), complete], 'Schema' = pipeline(step(_Input, Shared), step(Shared, _Output))],
    [
      step(countall(stage(__anon0, __anon1), 5), library(countall, 2), [], []),
      step(countall(transition(__anon2, __anon3, __anon4), 4), library(countall, 2), [], []),
      step(findall(stage(Index, Name, outgoing(Outgoing)), (cfor(0, 4, Index), stage(Index, Name), countall(transition(Index, __anon5, __anon6), Outgoing)), [stage(0, receive, outgoing(1)), stage(1, parse, outgoing(1)), stage(2, validate, outgoing(1)), stage(3, reason, outgoing(1)), stage(4, publish, outgoing(0))]), builtin(findall, 3), [], []),
      step(findall(step(Index, From, To), transition(Index, From, To), [step(0, receive, parse), step(1, parse, validate), step(2, validate, reason), step(3, reason, publish), complete], [complete]), library(findall, 4), [], []),
      step(forall(transition(Index, From, To), transition_is_well_formed(Index, From, To)), library(forall, 2), [], []),
      step(linked_pipeline_schema(pipeline(step(_Input, Shared), step(Shared, _Output))), fact("iso-extension-pipeline-audit.pl", clause(8)), [], []),
      step(variant(pipeline(step(_Input, Shared), step(Shared, _Output)), pipeline(step(_Source, Middle), step(Middle, _Result))), library(variant, 2), [], [])
    ]
  )
).

