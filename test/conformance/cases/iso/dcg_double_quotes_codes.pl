% Double-quoted terminal sequences honor the active Part 1 flag.
:- set_prolog_flag(double_quotes, codes).

codes --> "ab".

%% ?- phrase(codes, Tokens).
