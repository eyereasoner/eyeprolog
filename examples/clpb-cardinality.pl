:- use_module(library(clpb)).

% Select exactly two reviewers. Alice can only participate together with Carol,
% and exactly one of Bob and Dan must participate. card/2 states the quorum
% size directly; labeling/1 enumerates the admissible Boolean assignments.

%% ?- review_quorum(X0).
%% ?- review_quorum_count(X0).

review_constraints(Alice, Bob, Carol, Dan) :-
  sat(card([2], [Alice, Bob, Carol, Dan]) *
      (Alice =< Carol) *
      (Bob # Dan)).

review_quorum(selection(
    alice(Alice), bob(Bob), carol(Carol), dan(Dan))) :-
  review_constraints(Alice, Bob, Carol, Dan),
  labeling([Alice, Bob, Carol, Dan]).

review_quorum_count(Count) :-
  sat_count(card([2], [Alice, Bob, Carol, Dan]) *
            (Alice =< Carol) *
            (Bob # Dan), Count).
