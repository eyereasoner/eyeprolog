% Adapted from SWI-Prolog tests/library/test_aggregate.pl.
% See test/conformance/THIRD_PARTY.md.
:- use_module(library(aggregate)).
:- use_module(library(between)).

%% goal: aggregate_sum_template(X0)

aggregate_sum_template(Sum) :-
    aggregate(sum(X), between(1, 2, X), Sum), !.

%% goal: aggregate_count_existential(X0)

aggregate_count_existential(Count) :-
    aggregate(count, X ^ between(1, 2, X), Count), !.
