% From The Art of EyeProlog, Chapter 22 — A definite clause grammar.
sentence --> noun_phrase, verb_phrase.

noun_phrase --> [the], noun.
noun_phrase --> [a], noun.

noun --> [robot].
noun --> [scientist].

verb_phrase --> verb, noun_phrase.

verb --> [helps].
verb --> [observes].

complete_sentence(Words) :- phrase(sentence, Words).
