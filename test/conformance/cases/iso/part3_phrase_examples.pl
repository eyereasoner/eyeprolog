% ISO/IEC TS 13211-3:2025 phrase/2 and phrase/3 regression examples.
determiner --> [the].
determiner --> [a].

noun --> [boy].
noun --> [girl].

verb --> [likes].
verb --> [scares].

noun_phrase --> determiner, noun.
noun_phrase --> noun.

verb_phrase --> verb.
verb_phrase --> verb, noun_phrase.

sentence --> noun_phrase, verb_phrase.

% ?- phrase([the], [the]).  true.
answer(terminal_only, yes) :- phrase([the], [the]).

% ?- phrase(sentence, [the, girl, likes, the, boy]).  true ; false.
answer(full_sentence, yes) :- phrase(sentence, [the, girl, likes, the, boy]).

% ?- phrase(sentence, [the, girl, likes, the, boy, today]).  false.
answer(trailing_word, no) :- \+ phrase(sentence, [the, girl, likes, the, boy, today]).

% ?- phrase(sentence, [the, girl, likes]).  true ; false.
answer(intransitive, yes) :- phrase(sentence, [the, girl, likes]).

% ?- phrase(noun_phrase, [the, girl, scares, the, boy], Rest).
%    Rest = [scares, the, boy] ; false.
answer(remainder, Rest) :- phrase(noun_phrase, [the, girl, scares, the, boy], Rest).

% ?- phrase(sentence, Sentence).  Sentence = [the, boy, likes] ; ... .
answer(first_generated, Sentence) :-
    findall(S, phrase(sentence, S), All),
    first_four(All, Sentence).

first_four([A,B,C,D|_], [A,B,C,D]).
%% ?- answer(X0, X1).
