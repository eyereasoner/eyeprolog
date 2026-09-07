% From The Art of EyeProlog, Chapter 24 — Optimization is search plus an order.
:- use_module(library(aggregate)).
:- use_module(library(lists)).

best_plan(Request, Plan, Cost) :-
  aggregate_min(
    [CandidateCost, CandidatePlan],
    CandidatePlan,
    candidate_plan(Request, CandidatePlan, CandidateCost),
    [Cost, Plan],
    Plan
  ).
