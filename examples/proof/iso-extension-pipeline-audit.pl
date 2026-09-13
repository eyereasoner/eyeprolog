pipeline_audit(report(stages(5), transitions(4), summaries([stage(0, receive, outgoing(1)), stage(1, parse, outgoing(1)), stage(2, validate, outgoing(1)), stage(3, reason, outgoing(1)), stage(4, publish, outgoing(0))]), trace([step(0, receive, parse), step(1, parse, validate), step(2, validate, reason), step(3, reason, publish), complete]), invariant(true), schema_variant(true))).
why(
  pipeline_audit(report(stages(5), transitions(4), summaries([stage(0, receive, outgoing(1)), stage(1, parse, outgoing(1)), stage(2, validate, outgoing(1)), stage(3, reason, outgoing(1)), stage(4, publish, outgoing(0))]), trace([step(0, receive, parse), step(1, parse, validate), step(2, validate, reason), step(3, reason, publish), complete]), invariant(true), schema_variant(true))),
  proof(
    goal(pipeline_audit(report(stages(5), transitions(4), summaries([stage(0, receive, outgoing(1)), stage(1, parse, outgoing(1)), stage(2, validate, outgoing(1)), stage(3, reason, outgoing(1)), stage(4, publish, outgoing(0))]), trace([step(0, receive, parse), step(1, parse, validate), step(2, validate, reason), step(3, reason, publish), complete]), invariant(true), schema_variant(true)))),
    by(rule("iso-extension-pipeline-audit.pl", clause(9))),
    bindings([binding("StageCount", 5), binding("TransitionCount", 4), binding("StageSummaries", [stage(0, receive, outgoing(1)), stage(1, parse, outgoing(1)), stage(2, validate, outgoing(1)), stage(3, reason, outgoing(1)), stage(4, publish, outgoing(0))]), binding("Trace", [step(0, receive, parse), step(1, parse, validate), step(2, validate, reason), step(3, reason, publish), complete]), binding("Schema", pipeline(step(_Input, Shared), step(Shared, _Output)))]),
    uses([
      proof(
        goal(countall(stage(__anon0, __anon1), 5)),
        by(library(countall, 2))
      ),
      proof(
        goal(countall(transition(__anon2, __anon3, __anon4), 4)),
        by(library(countall, 2))
      ),
      proof(
        goal(findall(stage(Index, Name, outgoing(Outgoing)), (cfor(0, 4, Index), stage(Index, Name), countall(transition(Index, __anon5, __anon6), Outgoing)), [stage(0, receive, outgoing(1)), stage(1, parse, outgoing(1)), stage(2, validate, outgoing(1)), stage(3, reason, outgoing(1)), stage(4, publish, outgoing(0))])),
        by(builtin(findall, 3))
      ),
      proof(
        goal(findall(step(Index, From, To), transition(Index, From, To), [step(0, receive, parse), step(1, parse, validate), step(2, validate, reason), step(3, reason, publish), complete], [complete])),
        by(library(findall, 4))
      ),
      proof(
        goal(forall(transition(Index, From, To), transition_is_well_formed(Index, From, To))),
        by(library(forall, 2))
      ),
      proof(
        goal(linked_pipeline_schema(pipeline(step(_Input, Shared), step(Shared, _Output)))),
        by(fact("iso-extension-pipeline-audit.pl", clause(8)))
      ),
      proof(
        goal(variant(pipeline(step(_Input, Shared), step(Shared, _Output)), pipeline(step(_Source, Middle), step(Middle, _Result)))),
        by(library(variant, 2))
      )
    ])
  )
).

