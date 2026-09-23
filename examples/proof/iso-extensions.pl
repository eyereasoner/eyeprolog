extension_example(all_colors_are_atoms, true).
extension_example(successors, [1 - 2, 2 - 3, 3 - 4]).
extension_example(collection_with_tail, [red, green, blue, done]).
extension_example(repeated_variable_variant, true).
extension_example(different_variable_shape, true).
extension_example(color_count, 3).

clause(4,
       extension_example(all_colors_are_atoms, true),
       forall(color(var('Color')), atom(var('Color')))).
clause(5,
       extension_example(successors, var('Pairs')),
       findall(var('N') - var('S'), (cfor(1, 3, var('N')), succ(var('N'), var('S'))), var('Pairs'))).
clause(6,
       extension_example(collection_with_tail, var('Colors')),
       findall(var('Color'), color(var('Color')), var('Colors'), [done])).
clause(7,
       extension_example(repeated_variable_variant, true),
       variant(tree(var('X'), var('X')), tree(var('Y'), var('Y')))).
clause(8,
       extension_example(different_variable_shape, true),
       \+ variant(tree(var('X'), var('X')), tree(anonymous(1), anonymous(2)))).
clause(9,
       extension_example(color_count, var('Count')),
       countall(color(anonymous(1)), var('Count'))).

step(extension_example(all_colors_are_atoms, true),
     rule(4),
     [],
     [forall(color(Color), atom(Color))]).
step(forall(color(Color), atom(Color)), builtin, [], []).
step(extension_example(successors, [1 - 2, 2 - 3, 3 - 4]),
     rule(5),
     ['Pairs' = [1 - 2, 2 - 3, 3 - 4]],
     [findall(N - S, (cfor(1, 3, N), succ(N, S)), [1 - 2, 2 - 3, 3 - 4])]).
step(findall(N - S, (cfor(1, 3, N), succ(N, S)), [1 - 2, 2 - 3, 3 - 4]), collected, [], []).
step(extension_example(collection_with_tail, [red, green, blue, done]),
     rule(6),
     ['Colors' = [red, green, blue, done]],
     [findall(Template, color(Template), [red, green, blue, done], [done])]).
step(findall(Template, color(Template), [red, green, blue, done], [done]), builtin, [], []).
step(extension_example(repeated_variable_variant, true),
     rule(7),
     [],
     [variant(tree(X, X), tree(Y, Y))]).
step(variant(tree(X, X), tree(Y, Y)), builtin, [], []).
step(extension_example(different_variable_shape, true),
     rule(8),
     [],
     [\+ variant(tree(X, X), tree(__anon0, _Y))]).
step(\+ variant(tree(X, X), tree(__anon0, _Y)), absent, [], []).
step(extension_example(color_count, 3), rule(9), ['Count' = 3], [countall(color(__anon1), 3)]).
step(countall(color(__anon1), 3), builtin, [], []).
