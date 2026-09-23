:- use_module(library(iso_ext)).

% A bounded pipeline audit that composes every relation exported by
% library(iso_ext). The report counts a generated state space, summarizes each
% stage, builds a trace with an explicit difference-list tail, checks every
% transition, and compares variable-sharing schemas modulo variable names.

%% ?- pipeline_audit(X0).

stage(0, receive).
stage(1, parse).
stage(2, validate).
stage(3, reason).
stage(4, publish).

transition(Index, From, To) :-
  cfor(0, 3, Index),
  succ(Index, Next),
  stage(Index, From),
  stage(Next, To).

transition_is_well_formed(Index, From, To) :-
  succ(Index, Next),
  stage(Index, From),
  stage(Next, To),
  Index < Next.

linked_pipeline_schema(
  pipeline(step(_Input, Shared), step(Shared, _Output))).

pipeline_audit(
  report(
    stages(StageCount),
    transitions(TransitionCount),
    summaries(StageSummaries),
    trace(Trace),
    invariant(true),
    schema_variant(true)
  )) :-
  countall(stage(_, _), StageCount),
  countall(transition(_, _, _), TransitionCount),
  findall(
    stage(Index, Name, outgoing(Outgoing)),
    ( cfor(0, 4, Index),
      stage(Index, Name),
      countall(transition(Index, _, _), Outgoing)
    ),
    StageSummaries
  ),
  findall(
    step(Index, From, To),
    transition(Index, From, To),
    Trace,
    [complete]
  ),
  forall(
    transition(Index, From, To),
    transition_is_well_formed(Index, From, To)
  ),
  linked_pipeline_schema(Schema),
  variant(
    Schema,
    pipeline(step(_Source, Middle), step(Middle, _Result))
  ).
