% In atom mode, a double-quoted grammar body names a nonterminal.
:- set_prolog_flag(double_quotes, atom).

ab --> [recognized].
uses_atom_body --> "ab".

%% ?- phrase(uses_atom_body, Tokens).
