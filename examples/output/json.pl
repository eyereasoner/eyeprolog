% Prolog result format 4
query(1, json_example(_0, _1), ['Mode' = _0, 'Value' = _1]).
result(1, complete, 2).
answer(1,
       ['Mode' = parsed,
        'Value' = pairs([string("name") - string("Ada"), string("active") - boolean(true), string("scores") - list([number(3), number(5), number(8)]), string("emoji") - string("😀")])]).
answer(1, ['Mode' = generated, 'Value' = "{\"project\":\"EyeProlog\",\"ok\":true}"]).
