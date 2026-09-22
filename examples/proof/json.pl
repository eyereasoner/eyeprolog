json_example(parsed, pairs([string("name") - string("Ada"), string("active") - boolean(true), string("scores") - list([number(3), number(5), number(8)]), string("emoji") - string("😀")])).
why(
  json_example(parsed, pairs(['-'(string("name"), string("Ada")), '-'(string("active"), boolean(true)), '-'(string("scores"), list([number(3), number(5), number(8)])), '-'(string("emoji"), string("😀"))])),
  step(
    json_example(parsed, pairs(['-'(string("name"), string("Ada")), '-'(string("active"), boolean(true)), '-'(string("scores"), list([number(3), number(5), number(8)])), '-'(string("emoji"), string("😀"))])),
    rule("json.pl", clause(1)),
    ['JSON' = pairs(['-'(string("name"), string("Ada")), '-'(string("active"), boolean(true)), '-'(string("scores"), list([number(3), number(5), number(8)])), '-'(string("emoji"), string("😀"))])],
    [
      step(phrase(json_chars(pairs(['-'(string("name"), string("Ada")), '-'(string("active"), boolean(true)), '-'(string("scores"), list([number(3), number(5), number(8)])), '-'(string("emoji"), string("😀"))])), "{\"name\":\"Ada\",\"active\":true,\"scores\":[3,5,8],\"emoji\":\"\\uD83D\\uDE00\"}"), builtin(phrase, 2), [], [])
    ]
  )
).

json_example(generated, "{\"project\":\"EyeProlog\",\"ok\":true}").
why(
  json_example(generated, "{\"project\":\"EyeProlog\",\"ok\":true}"),
  step(
    json_example(generated, "{\"project\":\"EyeProlog\",\"ok\":true}"),
    rule("json.pl", clause(2)),
    ['Chars' = "{\"project\":\"EyeProlog\",\"ok\":true}"],
    [
      step(
        once(phrase(json_chars(pairs(['-'(string("project"), string("EyeProlog")), '-'(string("ok"), boolean(true))])), "{\"project\":\"EyeProlog\",\"ok\":true}")),
        builtin(once, 1),
        [],
        [
          step(phrase(json_chars(pairs(['-'(string("project"), string("EyeProlog")), '-'(string("ok"), boolean(true))])), "{\"project\":\"EyeProlog\",\"ok\":true}"), builtin(phrase, 2), [], [])
        ]
      )
    ]
  )
).

