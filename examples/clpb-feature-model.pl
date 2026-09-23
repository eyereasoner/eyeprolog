:- use_module(library(clpb)).

% A tiny feature model: exactly one deployment target is chosen; auditing
% requires encryption; an edge deployment additionally requires auditing.
% sat_count/2 counts all valid configurations without enumerating them first.

%% ?- feature_plan(X0).
%% ?- feature_plan_count(X0).

feature_constraints(Cloud, Edge, Audit, Encryption) :-
  sat((Cloud # Edge) *
      (Audit =< Encryption) *
      (Edge =< Audit)).

feature_plan(features(
    cloud(Cloud), edge(Edge), audit(Audit), encryption(Encryption))) :-
  feature_constraints(Cloud, Edge, Audit, Encryption),
  labeling([Cloud, Edge, Audit, Encryption]).

feature_plan_count(Count) :-
  sat_count((_Cloud # Edge) *
            (Audit =< _Encryption) *
            (Edge =< Audit), Count).
