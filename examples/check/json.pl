condition('C1', resolution, ok, 2).
condition('C2', well_founded, ok, 5).
condition('C3', justification, ok, 5).
condition('C4', coverage, ok, 5).
condition('C5', re_decision, ok, 1).
obligation(builtin, theory_scoped, phrase(json_chars(pairs([string("name") - string("Ada"), string("active") - boolean(true), string("scores") - list([number(3), number(5), number(8)]), string("emoji") - string("😀")])), "{\"name\":\"Ada\",\"active\":true,\"scores\":[3,5,8],\"emoji\":\"\\uD83D\\uDE00\"}")).
obligation(builtin, theory_scoped, phrase(json_chars(pairs([string("project") - string("EyeProlog"), string("ok") - boolean(true)])), "{\"project\":\"EyeProlog\",\"ok\":true}")).
steps(5).
verified(2).
recomputed(0).
composed(1).
trusted(2).
claims(2).
verdict(checked_with_obligations).
