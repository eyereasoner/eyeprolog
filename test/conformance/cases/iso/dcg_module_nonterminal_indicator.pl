% Module compatibility exports combined with a Part 3 nonterminal indicator.
:- module(dcg_vocab, [word//1, answer/1]).

word(X) --> [X].
answer(X) :- phrase(word(X), [hello]).

%% ?- dcg_vocab:answer(X).
%% ?- phrase(dcg_vocab:word(hello), [hello]).
