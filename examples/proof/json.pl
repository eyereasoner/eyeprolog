json_example(parsed, pairs([string("name") - string("Ada"), string("active") - boolean(true), string("scores") - list([number(3), number(5), number(8)]), string("emoji") - string("😀")])).
why(
  json_example(parsed, pairs(['-'(string("name"), string("Ada")), '-'(string("active"), boolean(true)), '-'(string("scores"), list([number(3), number(5), number(8)])), '-'(string("emoji"), string("😀"))])),
  proof(
    goal(json_example(parsed, pairs(['-'(string("name"), string("Ada")), '-'(string("active"), boolean(true)), '-'(string("scores"), list([number(3), number(5), number(8)])), '-'(string("emoji"), string("😀"))]))),
    by(rule("json.pl", clause(1))),
    bindings([binding("JSON", pairs(['-'(string("name"), string("Ada")), '-'(string("active"), boolean(true)), '-'(string("scores"), list([number(3), number(5), number(8)])), '-'(string("emoji"), string("😀"))]))]),
    uses([
      proof(
        goal(phrase(json_chars(pairs(['-'(string("name"), string("Ada")), '-'(string("active"), boolean(true)), '-'(string("scores"), list([number(3), number(5), number(8)])), '-'(string("emoji"), string("😀"))])), "{\"name\":\"Ada\",\"active\":true,\"scores\":[3,5,8],\"emoji\":\"\\uD83D\\uDE00\"}")),
        by(builtin(phrase, 2))
      )
    ])
  )
).

json_example(generated, "{\"project\":\"EyeProlog\",\"ok\":true}").
why(
  json_example(generated, "{\"project\":\"EyeProlog\",\"ok\":true}"),
  proof(
    goal(json_example(generated, "{\"project\":\"EyeProlog\",\"ok\":true}")),
    by(rule("json.pl", clause(2))),
    bindings([binding("Chars", "{\"project\":\"EyeProlog\",\"ok\":true}")]),
    uses([
      proof(
        goal(once(phrase(json_chars(pairs(['-'(string("project"), string("EyeProlog")), '-'(string("ok"), boolean(true))])), "{\"project\":\"EyeProlog\",\"ok\":true}"))),
        by(builtin(once, 1)),
        uses([
          proof(
            goal(phrase(json_chars(pairs(['-'(string("project"), string("EyeProlog")), '-'(string("ok"), boolean(true))])), "{\"project\":\"EyeProlog\",\"ok\":true}")),
            by(builtin(phrase, 2))
          )
        ])
      )
    ])
  )
).

