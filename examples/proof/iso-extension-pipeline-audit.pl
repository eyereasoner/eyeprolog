% Prolog result format 4
query(1, pipeline_audit(_0), ['X0' = _0]).
result(1, complete, 1).
answer(1,
       ['X0' = report(stages(5), transitions(4), summaries([stage(0, receive, outgoing(1)), stage(1, parse, outgoing(1)), stage(2, validate, outgoing(1)), stage(3, reason, outgoing(1)), stage(4, publish, outgoing(0))]), trace([step(0, receive, parse), step(1, parse, validate), step(2, validate, reason), step(3, reason, publish), complete]), invariant(true), schema_variant(true))]).
why(1,
    ['X0' = report(stages(5), transitions(4), summaries([stage(0, receive, outgoing(1)), stage(1, parse, outgoing(1)), stage(2, validate, outgoing(1)), stage(3, reason, outgoing(1)), stage(4, publish, outgoing(0))]), trace([step(0, receive, parse), step(1, parse, validate), step(2, validate, reason), step(3, reason, publish), complete]), invariant(true), schema_variant(true))],
    [pipeline_audit(report(stages(5), transitions(4), summaries([stage(0, receive, outgoing(1)), stage(1, parse, outgoing(1)), stage(2, validate, outgoing(1)), stage(3, reason, outgoing(1)), stage(4, publish, outgoing(0))]), trace([step(0, receive, parse), step(1, parse, validate), step(2, validate, reason), step(3, reason, publish), complete]), invariant(true), schema_variant(true)))]).

clause(8,
       linked_pipeline_schema(pipeline(step(anonymous(1), var('Shared')), step(var('Shared'), anonymous(2)))),
       true).
clause(9,
       pipeline_audit(report(stages(var('StageCount')), transitions(var('TransitionCount')), summaries(var('StageSummaries')), trace(var('Trace')), invariant(true), schema_variant(true))),
       (countall(stage(anonymous(1), anonymous(2)), var('StageCount')),
        countall(transition(anonymous(3), anonymous(4), anonymous(5)), var('TransitionCount')),
        findall(stage(var('Index'), var('Name'), outgoing(var('Outgoing'))), (cfor(0, 4, var('Index')), stage(var('Index'), var('Name')), countall(transition(var('Index'), anonymous(6), anonymous(7)), var('Outgoing'))), var('StageSummaries')),
        findall(step(var('Index'), var('From'), var('To')), transition(var('Index'), var('From'), var('To')), var('Trace'), [complete]),
        forall(transition(var('Index'), var('From'), var('To')), transition_is_well_formed(var('Index'), var('From'), var('To'))),
        linked_pipeline_schema(var('Schema')),
        variant(var('Schema'), pipeline(step(anonymous(8), var('Middle')), step(var('Middle'), anonymous(9)))))).

step(pipeline_audit(report(stages(5), transitions(4), summaries([stage(0, receive, outgoing(1)), stage(1, parse, outgoing(1)), stage(2, validate, outgoing(1)), stage(3, reason, outgoing(1)), stage(4, publish, outgoing(0))]), trace([step(0, receive, parse), step(1, parse, validate), step(2, validate, reason), step(3, reason, publish), complete]), invariant(true), schema_variant(true))),
     rule(9),
     ['StageCount' = 5,
      'TransitionCount' = 4,
      'StageSummaries' = [stage(0, receive, outgoing(1)), stage(1, parse, outgoing(1)), stage(2, validate, outgoing(1)), stage(3, reason, outgoing(1)), stage(4, publish, outgoing(0))],
      'Trace' = [step(0, receive, parse), step(1, parse, validate), step(2, validate, reason), step(3, reason, publish), complete],
      'Schema' = pipeline(step(_Input, Shared), step(Shared, _Output))],
     [countall(stage(__anon0, __anon1), 5),
      countall(transition(__anon2, __anon3, __anon4), 4),
      findall(stage(Index, Name, outgoing(Outgoing)), (cfor(0, 4, Index), stage(Index, Name), countall(transition(Index, __anon5, __anon6), Outgoing)), [stage(0, receive, outgoing(1)), stage(1, parse, outgoing(1)), stage(2, validate, outgoing(1)), stage(3, reason, outgoing(1)), stage(4, publish, outgoing(0))]),
      findall(step(Index, From, To), transition(Index, From, To), [step(0, receive, parse), step(1, parse, validate), step(2, validate, reason), step(3, reason, publish), complete], [complete]),
      forall(transition(Index, From, To), transition_is_well_formed(Index, From, To)),
      linked_pipeline_schema(pipeline(step(_Input, Shared), step(Shared, _Output))),
      variant(pipeline(step(_Input, Shared), step(Shared, _Output)), pipeline(step(_Source, Middle), step(Middle, _Result)))]).
step(countall(stage(__anon0, __anon1), 5), builtin, [], []).
step(countall(transition(__anon2, __anon3, __anon4), 4), builtin, [], []).
step(findall(stage(Index, Name, outgoing(Outgoing)), (cfor(0, 4, Index), stage(Index, Name), countall(transition(Index, __anon5, __anon6), Outgoing)), [stage(0, receive, outgoing(1)), stage(1, parse, outgoing(1)), stage(2, validate, outgoing(1)), stage(3, reason, outgoing(1)), stage(4, publish, outgoing(0))]),
     collected,
     [],
     []).
step(findall(step(Index, From, To), transition(Index, From, To), [step(0, receive, parse), step(1, parse, validate), step(2, validate, reason), step(3, reason, publish), complete], [complete]),
     builtin,
     [],
     []).
step(forall(transition(Index, From, To), transition_is_well_formed(Index, From, To)),
     builtin,
     [],
     []).
step(linked_pipeline_schema(pipeline(step(_Input, Shared), step(Shared, _Output))),
     fact(8),
     [],
     []).
step(variant(pipeline(step(_Input, Shared), step(Shared, _Output)), pipeline(step(_Source, Middle), step(Middle, _Result))),
     builtin,
     [],
     []).
