% Isolated ISO mode-table success case.
%% ?- answer.

answer :- atom_codes(Atom, [65, 90]), Atom = 'AZ'.
