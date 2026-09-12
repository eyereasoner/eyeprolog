% Adapted from Scryer Prolog tests-pl/issue2914.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: current_prolog_flag_shared_var(X0)

current_prolog_flag_shared_var(R) :-
    ( current_prolog_flag(X, X) -> R = true ; R = false ).
