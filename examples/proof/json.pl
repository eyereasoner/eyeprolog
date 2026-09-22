% Prolog result format 4
query(1, json_example(_0, _1), ['Mode' = _0, 'Value' = _1]).
result(1, complete, 2).
answer(1,
       ['Mode' = parsed,
        'Value' = pairs([string("name") - string("Ada"), string("active") - boolean(true), string("scores") - list([number(3), number(5), number(8)]), string("emoji") - string("😀")])]).
why(1,
    ['Mode' = parsed,
     'Value' = pairs([string("name") - string("Ada"), string("active") - boolean(true), string("scores") - list([number(3), number(5), number(8)]), string("emoji") - string("😀")])],
    [json_example(parsed, pairs([string("name") - string("Ada"), string("active") - boolean(true), string("scores") - list([number(3), number(5), number(8)]), string("emoji") - string("😀")]))]).
answer(1, ['Mode' = generated, 'Value' = "{\"project\":\"EyeProlog\",\"ok\":true}"]).
why(1,
    ['Mode' = generated, 'Value' = "{\"project\":\"EyeProlog\",\"ok\":true}"],
    [json_example(generated, "{\"project\":\"EyeProlog\",\"ok\":true}")]).

clause(1,
       json_example(parsed, var('JSON')),
       phrase(json_chars(var('JSON')), "{\"name\":\"Ada\",\"active\":true,\"scores\":[3,5,8],\"emoji\":\"\\uD83D\\uDE00\"}")).
clause(2,
       json_example(generated, var('Chars')),
       once(phrase(json_chars(pairs([string("project") - string("EyeProlog"), string("ok") - boolean(true)])), var('Chars')))).

step(json_example(parsed, pairs([string("name") - string("Ada"), string("active") - boolean(true), string("scores") - list([number(3), number(5), number(8)]), string("emoji") - string("😀")])),
     rule(1),
     ['JSON' = pairs([string("name") - string("Ada"), string("active") - boolean(true), string("scores") - list([number(3), number(5), number(8)]), string("emoji") - string("😀")])],
     [phrase(json_chars(pairs([string("name") - string("Ada"), string("active") - boolean(true), string("scores") - list([number(3), number(5), number(8)]), string("emoji") - string("😀")])), "{\"name\":\"Ada\",\"active\":true,\"scores\":[3,5,8],\"emoji\":\"\\uD83D\\uDE00\"}")]).
step(phrase(json_chars(pairs([string("name") - string("Ada"), string("active") - boolean(true), string("scores") - list([number(3), number(5), number(8)]), string("emoji") - string("😀")])), "{\"name\":\"Ada\",\"active\":true,\"scores\":[3,5,8],\"emoji\":\"\\uD83D\\uDE00\"}"),
     builtin,
     [],
     []).
step(json_example(generated, "{\"project\":\"EyeProlog\",\"ok\":true}"),
     rule(2),
     ['Chars' = "{\"project\":\"EyeProlog\",\"ok\":true}"],
     [once(phrase(json_chars(pairs([string("project") - string("EyeProlog"), string("ok") - boolean(true)])), "{\"project\":\"EyeProlog\",\"ok\":true}"))]).
step(once(phrase(json_chars(pairs([string("project") - string("EyeProlog"), string("ok") - boolean(true)])), "{\"project\":\"EyeProlog\",\"ok\":true}")),
     builtin,
     [],
     [phrase(json_chars(pairs([string("project") - string("EyeProlog"), string("ok") - boolean(true)])), "{\"project\":\"EyeProlog\",\"ok\":true}")]).
step(phrase(json_chars(pairs([string("project") - string("EyeProlog"), string("ok") - boolean(true)])), "{\"project\":\"EyeProlog\",\"ok\":true}"),
     builtin,
     [],
     []).
