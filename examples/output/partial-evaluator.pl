partialEvalAnswer(residual(poly_y), add(mul(const(10), var(y)), const(13))).
partialEvalAnswer(residual(static_branch), const(11)).
partialEvalAnswer(residual(dynamic_branch), if(var(flag), const(11), mul(var(y), const(2)))).
partialEvalAnswer(note, "static inputs are folded while dynamic variables remain as residual code").
