extension_example(all_colors_are_atoms, true).
why(
  extension_example(all_colors_are_atoms, true),
  proof(
    goal(extension_example(all_colors_are_atoms, true)),
    by(rule("iso-extensions.pl", clause(4))),
    uses([
      proof(
        goal(forall(color(Color), atom(Color))),
        by(library(forall, 2))
      )
    ])
  )
).

extension_example(successors, [1 - 2, 2 - 3, 3 - 4]).
why(
  extension_example(successors, ['-'(1, 2), '-'(2, 3), '-'(3, 4)]),
  proof(
    goal(extension_example(successors, ['-'(1, 2), '-'(2, 3), '-'(3, 4)])),
    by(rule("iso-extensions.pl", clause(5))),
    bindings([binding("Pairs", ['-'(1, 2), '-'(2, 3), '-'(3, 4)])]),
    uses([
      proof(
        goal(findall('-'(N, S), (cfor(1, 3, N), succ(N, S)), ['-'(1, 2), '-'(2, 3), '-'(3, 4)])),
        by(builtin(findall, 3))
      )
    ])
  )
).

extension_example(collection_with_tail, [red, green, blue, done]).
why(
  extension_example(collection_with_tail, [red, green, blue, done]),
  proof(
    goal(extension_example(collection_with_tail, [red, green, blue, done])),
    by(rule("iso-extensions.pl", clause(6))),
    bindings([binding("Colors", [red, green, blue, done])]),
    uses([
      proof(
        goal(findall(Template, color(Template), [red, green, blue, done], [done])),
        by(library(findall, 4))
      )
    ])
  )
).

extension_example(repeated_variable_variant, true).
why(
  extension_example(repeated_variable_variant, true),
  proof(
    goal(extension_example(repeated_variable_variant, true)),
    by(rule("iso-extensions.pl", clause(7))),
    uses([
      proof(
        goal(variant(tree(X, X), tree(Y, Y))),
        by(library(variant, 2))
      )
    ])
  )
).

extension_example(different_variable_shape, true).
why(
  extension_example(different_variable_shape, true),
  proof(
    goal(extension_example(different_variable_shape, true)),
    by(rule("iso-extensions.pl", clause(8))),
    uses([
      proof(
        goal('\\+'(variant(tree(X, X), tree(__anon0, _Y)))),
        by(builtin('\\+', 1))
      )
    ])
  )
).

extension_example(color_count, 3).
why(
  extension_example(color_count, 3),
  proof(
    goal(extension_example(color_count, 3)),
    by(rule("iso-extensions.pl", clause(9))),
    bindings([binding("Count", 3)]),
    uses([
      proof(
        goal(countall(color(__anon1), 3)),
        by(library(countall, 2))
      )
    ])
  )
).

