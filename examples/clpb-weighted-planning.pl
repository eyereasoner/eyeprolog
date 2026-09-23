:- use_module(library(clpb)).

% Choose at most two release features. Search requires the API, and cache
% requires audit logging. weighted_maximum/3 finds the admissible assignment
% with maximum business value and labels the Boolean variables to that optimum.

%% ?- best_release_plan(X0, X1).

best_release_plan(plan(
    api(Api), cache(Cache), audit(Audit), search(Search)), Score) :-
  sat(card([0,1,2], [Api, Cache, Audit, Search]) *
      (Search =< Api) *
      (Cache =< Audit)),
  weighted_maximum([7, 4, 3, 6], [Api, Cache, Audit, Search], Score).
