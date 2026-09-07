% From The Art of EyeProlog, Chapter 8.
:- use_module(library(aggregate)).
:- use_module(library(lists)).

best_route(From, To, Route, Cost) :-
  aggregate_min(
    [CandidateCost, CandidateRoute],
    CandidateRoute,
    route(From, To, CandidateRoute, CandidateCost),
    [Cost, Route],
    Route
  ).
