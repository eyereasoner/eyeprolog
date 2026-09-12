% Adapted from SWI-Prolog tests/library/test_ugraphs.pl.
% See test/conformance/THIRD_PARTY.md.
:- use_module(library(ugraphs)).

%% goal: ugraphs_top_sort_linear(X0)

ugraphs_top_sort_linear(L) :-
    top_sort([1-[2], 2-[3], 3-[]], L), !.
