:- use_module(library(lists)).
:- use_module(library(iso_ext)).

:- table span/4.

% A tiny explicitly tabled chart parser for a context-free grammar.
%
% span(Sentence, Category, Start, End) is the dynamic-programming chart item:
% Category covers a half-open token interval.  Memoizing span/4 turns recursive
% grammar recognition into chart parsing, so ambiguous phrases share subparses.
%% ?- chart_parser_answer(X0, X1).



% Two sample sentences share the same tiny grammar. The second is ambiguous: the
% prepositional phrase "with the telescope" can attach to "the box" or to "sees
% the box", so it has two parse trees where the first has one.

sentence(command, 5).
sentence(ambiguous_pp, 8).

word(command, 0, the).
word(command, 1, robot).
word(command, 2, moves).
word(command, 3, the).
word(command, 4, box).

word(ambiguous_pp, 0, the).
word(ambiguous_pp, 1, robot).
word(ambiguous_pp, 2, sees).
word(ambiguous_pp, 3, the).
word(ambiguous_pp, 4, box).
word(ambiguous_pp, 5, with).
word(ambiguous_pp, 6, the).
word(ambiguous_pp, 7, telescope).

terminal(det, the).
terminal(noun, robot).
terminal(noun, box).
terminal(noun, telescope).
terminal(verb, moves).
terminal(verb, sees).
terminal(prep, with).

rule(s, np, vp).
rule(np, det, noun).
rule(np, np, pp).
rule(vp, verb, np).
rule(vp, vp, pp).
rule(pp, prep, np).

% Lexical chart items come directly from words and terminal categories.
span(Sentence, Category, Start, End) :-
  word(Sentence, Start, Token),
  terminal(Category, Token),
  (End is Start + 1).
% Nonterminal chart items split the interval at a Middle point.
span(Sentence, Category, Start, End) :-
  rule(Category, Left, Right),
  span(Sentence, Left, Start, Middle),
  span(Sentence, Right, Middle, End).

% The chart says which items exist; it stores each item once, however many ways
% it can be built. Counting parse trees therefore needs its own relation: an
% item's tree count is the sum, over every way to build it, of the product of
% its parts' counts. Each recursive call covers a strictly shorter interval, so
% the counting terminates without tabling.
parse_trees(Sentence, Category, Start, End, Count) :-
  sumall(N, tree_count(Sentence, Category, Start, End, N), Count).

tree_count(Sentence, Category, Start, End, 1) :-
  word(Sentence, Start, Token),
  terminal(Category, Token),
  (End =:= Start + 1).
tree_count(Sentence, Category, Start, End, N) :-
  rule(Category, Left, Right),
  span(Sentence, Left, Start, Middle),
  span(Sentence, Right, Middle, End),
  parse_trees(Sentence, Left, Start, Middle, LeftCount),
  parse_trees(Sentence, Right, Middle, End, RightCount),
  (N is LeftCount * RightCount).

chart_parser_answer(parsed, Sentence) :-
  sentence(Sentence, Length),
  span(Sentence, s, 0, Length).
chart_parser_answer(parse_count, count(Sentence, Count)) :-
  sentence(Sentence, Length),
  parse_trees(Sentence, s, 0, Length, Count).
chart_parser_answer(noun_phrase_count, count(Sentence, Count)) :-
  sentence(Sentence, Length),
  countall(span(Sentence, np, _start, _end), Count),
  (Length > 0).
