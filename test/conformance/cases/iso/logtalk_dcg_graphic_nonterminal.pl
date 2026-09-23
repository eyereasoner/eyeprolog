% Adapted from Logtalk dcgs_graphic_01. The (=)//0 translator-only case
% collides with the ISO =/2 built-in when executed and is intentionally omitted.

'[' --> [open].

%% ?- graphic_nonterminal(X0).
graphic_nonterminal(open) :- phrase('[', [open]).
