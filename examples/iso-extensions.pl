:- use_module(library(iso_ext)).

% Common extensions found across mature Prolog systems: universal checking,
% bounded integer generation, successor arithmetic, difference-list
% collection, variant testing, and solution counting.

%% ?- extension_example(X0, X1).

color(red).
color(green).
color(blue).

extension_example(all_colors_are_atoms, true) :-
  forall(color(Color), atom(Color)).

extension_example(successors, Pairs) :-
  findall(N-S, (cfor(1, 3, N), succ(N, S)), Pairs).

extension_example(collection_with_tail, Colors) :-
  findall(Color, color(Color), Colors, [done]).

extension_example(repeated_variable_variant, true) :-
  variant(tree(X, X), tree(Y, Y)).

extension_example(different_variable_shape, true) :-
  \+ variant(tree(X, X), tree(_, _Y)).

extension_example(color_count, Count) :-
  countall(color(_), Count).
