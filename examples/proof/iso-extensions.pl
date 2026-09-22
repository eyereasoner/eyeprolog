extension_example(all_colors_are_atoms, true).
why(
  extension_example(all_colors_are_atoms, true),
  step(
    extension_example(all_colors_are_atoms, true),
    rule("iso-extensions.pl", clause(4)),
    [],
    [
      step(forall(color(Color), atom(Color)), library(forall, 2), [], [])
    ]
  )
).

extension_example(successors, [1 - 2, 2 - 3, 3 - 4]).
why(
  extension_example(successors, ['-'(1, 2), '-'(2, 3), '-'(3, 4)]),
  step(
    extension_example(successors, ['-'(1, 2), '-'(2, 3), '-'(3, 4)]),
    rule("iso-extensions.pl", clause(5)),
    ['Pairs' = ['-'(1, 2), '-'(2, 3), '-'(3, 4)]],
    [
      step(findall('-'(N, S), (cfor(1, 3, N), succ(N, S)), ['-'(1, 2), '-'(2, 3), '-'(3, 4)]), builtin(findall, 3), [], [])
    ]
  )
).

extension_example(collection_with_tail, [red, green, blue, done]).
why(
  extension_example(collection_with_tail, [red, green, blue, done]),
  step(
    extension_example(collection_with_tail, [red, green, blue, done]),
    rule("iso-extensions.pl", clause(6)),
    ['Colors' = [red, green, blue, done]],
    [
      step(findall(Template, color(Template), [red, green, blue, done], [done]), library(findall, 4), [], [])
    ]
  )
).

extension_example(repeated_variable_variant, true).
why(
  extension_example(repeated_variable_variant, true),
  step(
    extension_example(repeated_variable_variant, true),
    rule("iso-extensions.pl", clause(7)),
    [],
    [
      step(variant(tree(X, X), tree(Y, Y)), library(variant, 2), [], [])
    ]
  )
).

extension_example(different_variable_shape, true).
why(
  extension_example(different_variable_shape, true),
  step(
    extension_example(different_variable_shape, true),
    rule("iso-extensions.pl", clause(8)),
    [],
    [
      step('\\+'(variant(tree(X, X), tree(__anon0, _Y))), builtin('\\+', 1), [], [])
    ]
  )
).

extension_example(color_count, 3).
why(
  extension_example(color_count, 3),
  step(
    extension_example(color_count, 3),
    rule("iso-extensions.pl", clause(9)),
    ['Count' = 3],
    [
      step(countall(color(__anon1), 3), library(countall, 2), [], [])
    ]
  )
).

