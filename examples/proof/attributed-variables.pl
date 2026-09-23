accepts_required_value(ok).
alias_preserves_attribute(ok).

clause(1,
       attach_required(var('Variable'), var('Value')),
       put_atts(var('Variable'), required(var('Value')))).
clause(4, accepts_required_value(ok), (attach_required(var('X'), 7), var('X') = 7)).
clause(5,
       alias_preserves_attribute(ok),
       (attach_required(var('X'), ready),
        var('X') = var('Y'),
        get_atts(var('Y'), required(ready)),
        var('Y') = ready)).

step(accepts_required_value(ok), rule(4), ['X' = 7], [attach_required(Variable, 7), 7 = 7]).
step(attach_required(Variable, 7), rule(1), ['Value' = 7], [put_atts(Variable, required(7))]).
step(put_atts(Variable, required(7)), builtin, [], []).
step(7 = 7, builtin, [], []).
step(alias_preserves_attribute(ok),
     rule(5),
     ['X' = ready, 'Y' = ready],
     [attach_required(Variable, ready), Y = Y, get_atts(Y, required(ready)), ready = ready]).
step(attach_required(Variable, ready),
     rule(1),
     ['Value' = ready],
     [put_atts(Variable, required(ready))]).
step(put_atts(Variable, required(ready)), builtin, [], []).
step(Y = Y, builtin, [], []).
step(get_atts(Y, required(ready)), builtin, [], []).
step(ready = ready, builtin, [], []).
