satModel([bind(d, true), bind(c, true), bind(b, true), bind(a, false)]).
satValue(d, true).
satValue(c, true).
satValue(b, true).
satValue(a, false).
satClauseStatus(c1, satisfied).
satClauseStatus(c2, satisfied).
satClauseStatus(c3, satisfied).
satClauseStatus(c4, satisfied).
satClauseStatus(c5, satisfied).
satConclusion(case, "DPLL finds a satisfying assignment after pruning clauses that become impossible").

clause(2, cnf_clause(c1, [pos(a), pos(b)]), true).
clause(3, cnf_clause(c2, [neg(a), pos(c)]), true).
clause(4, cnf_clause(c3, [neg(b), pos(c)]), true).
clause(5, cnf_clause(c4, [neg(c), pos(d)]), true).
clause(6, cnf_clause(c5, [pos(c), neg(d)]), true).
clause(11,
       lookup_bool(var('Name'), [bind(var('Name'), var('Value')) | anonymous(1)], var('Value')),
       true).
clause(12,
       lookup_bool(var('Name'), [bind(anonymous(1), anonymous(2)) | var('Rest')], var('Value')),
       lookup_bool(var('Name'), var('Rest'), var('Value'))).
clause(13,
       literal_true(pos(var('Var')), var('Assignment')),
       lookup_bool(var('Var'), var('Assignment'), true)).
clause(14,
       literal_true(neg(var('Var')), var('Assignment')),
       lookup_bool(var('Var'), var('Assignment'), false)).
clause(17,
       clause_satisfied(var('Assignment'), var('Clause_name')),
       (cnf_clause(var('Clause_name'), var('Literals')),
        member(var('Literal'), var('Literals')),
        literal_true(var('Literal'), var('Assignment')))).
clause(28,
       best_model(var('Model'), var('Rank')),
       aggregate_min(var('Candidate_rank'), var('Candidate_model'), (satisfying_model(var('Candidate_model')), model_rank(var('Candidate_model'), var('Candidate_rank'))), var('Rank'), var('Model'))).
clause(29, satModel(var('Model')), best_model(var('Model'), anonymous(1))).
clause(30,
       satValue(var('Var'), var('Value')),
       (best_model(var('Model'), anonymous(1)),
        lookup_bool(var('Var'), var('Model'), var('Value')))).
clause(31,
       satClauseStatus(var('Clause'), satisfied),
       (best_model(var('Model'), anonymous(1)), clause_satisfied(var('Model'), var('Clause')))).
clause(32,
       satConclusion(case, "DPLL finds a satisfying assignment after pruning clauses that become impossible"),
       best_model(anonymous(1), anonymous(2))).

step(satModel([bind(d, true), bind(c, true), bind(b, true), bind(a, false)]),
     rule(29),
     ['Model' = [bind(d, true), bind(c, true), bind(b, true), bind(a, false)]],
     [best_model([bind(d, true), bind(c, true), bind(b, true), bind(a, false)], 7)]).
step(best_model([bind(d, true), bind(c, true), bind(b, true), bind(a, false)], 7),
     rule(28),
     ['Model' = [bind(d, true), bind(c, true), bind(b, true), bind(a, false)], 'Rank' = 7],
     [aggregate_min(Key, Value, (satisfying_model(Value), model_rank(Value, Key)), 7, [bind(d, true), bind(c, true), bind(b, true), bind(a, false)])]).
step(aggregate_min(Key, Value, (satisfying_model(Value), model_rank(Value, Key)), 7, [bind(d, true), bind(c, true), bind(b, true), bind(a, false)]),
     builtin,
     [],
     []).
step(satValue(d, true),
     rule(30),
     ['Var' = d,
      'Value' = true,
      'Model' = [bind(d, true), bind(c, true), bind(b, true), bind(a, false)]],
     [best_model([bind(d, true), bind(c, true), bind(b, true), bind(a, false)], 7),
      lookup_bool(d, [bind(d, true), bind(c, true), bind(b, true), bind(a, false)], true)]).
step(lookup_bool(d, [bind(d, true), bind(c, true), bind(b, true), bind(a, false)], true),
     fact(11),
     ['Name' = d, 'Value' = true],
     []).
step(satValue(c, true),
     rule(30),
     ['Var' = c,
      'Value' = true,
      'Model' = [bind(d, true), bind(c, true), bind(b, true), bind(a, false)]],
     [best_model([bind(d, true), bind(c, true), bind(b, true), bind(a, false)], 7),
      lookup_bool(c, [bind(d, true), bind(c, true), bind(b, true), bind(a, false)], true)]).
step(lookup_bool(c, [bind(d, true), bind(c, true), bind(b, true), bind(a, false)], true),
     rule(12),
     ['Name' = c, 'Rest' = [bind(c, true), bind(b, true), bind(a, false)], 'Value' = true],
     [lookup_bool(c, [bind(c, true), bind(b, true), bind(a, false)], true)]).
step(lookup_bool(c, [bind(c, true), bind(b, true), bind(a, false)], true),
     fact(11),
     ['Name' = c, 'Value' = true],
     []).
step(satValue(b, true),
     rule(30),
     ['Var' = b,
      'Value' = true,
      'Model' = [bind(d, true), bind(c, true), bind(b, true), bind(a, false)]],
     [best_model([bind(d, true), bind(c, true), bind(b, true), bind(a, false)], 7),
      lookup_bool(b, [bind(d, true), bind(c, true), bind(b, true), bind(a, false)], true)]).
step(lookup_bool(b, [bind(d, true), bind(c, true), bind(b, true), bind(a, false)], true),
     rule(12),
     ['Name' = b, 'Rest' = [bind(c, true), bind(b, true), bind(a, false)], 'Value' = true],
     [lookup_bool(b, [bind(c, true), bind(b, true), bind(a, false)], true)]).
step(lookup_bool(b, [bind(c, true), bind(b, true), bind(a, false)], true),
     rule(12),
     ['Name' = b, 'Rest' = [bind(b, true), bind(a, false)], 'Value' = true],
     [lookup_bool(b, [bind(b, true), bind(a, false)], true)]).
step(lookup_bool(b, [bind(b, true), bind(a, false)], true),
     fact(11),
     ['Name' = b, 'Value' = true],
     []).
step(satValue(a, false),
     rule(30),
     ['Var' = a,
      'Value' = false,
      'Model' = [bind(d, true), bind(c, true), bind(b, true), bind(a, false)]],
     [best_model([bind(d, true), bind(c, true), bind(b, true), bind(a, false)], 7),
      lookup_bool(a, [bind(d, true), bind(c, true), bind(b, true), bind(a, false)], false)]).
step(lookup_bool(a, [bind(d, true), bind(c, true), bind(b, true), bind(a, false)], false),
     rule(12),
     ['Name' = a, 'Rest' = [bind(c, true), bind(b, true), bind(a, false)], 'Value' = false],
     [lookup_bool(a, [bind(c, true), bind(b, true), bind(a, false)], false)]).
step(lookup_bool(a, [bind(c, true), bind(b, true), bind(a, false)], false),
     rule(12),
     ['Name' = a, 'Rest' = [bind(b, true), bind(a, false)], 'Value' = false],
     [lookup_bool(a, [bind(b, true), bind(a, false)], false)]).
step(lookup_bool(a, [bind(b, true), bind(a, false)], false),
     rule(12),
     ['Name' = a, 'Rest' = [bind(a, false)], 'Value' = false],
     [lookup_bool(a, [bind(a, false)], false)]).
step(lookup_bool(a, [bind(a, false)], false), fact(11), ['Name' = a, 'Value' = false], []).
step(satClauseStatus(c1, satisfied),
     rule(31),
     ['Clause' = c1, 'Model' = [bind(d, true), bind(c, true), bind(b, true), bind(a, false)]],
     [best_model([bind(d, true), bind(c, true), bind(b, true), bind(a, false)], 7),
      clause_satisfied([bind(d, true), bind(c, true), bind(b, true), bind(a, false)], c1)]).
step(clause_satisfied([bind(d, true), bind(c, true), bind(b, true), bind(a, false)], c1),
     rule(17),
     ['Assignment' = [bind(d, true), bind(c, true), bind(b, true), bind(a, false)],
      'Clause_name' = c1,
      'Literals' = [pos(a), pos(b)],
      'Literal' = pos(b)],
     [cnf_clause(c1, [pos(a), pos(b)]),
      member(pos(b), [pos(a), pos(b)]),
      literal_true(pos(b), [bind(d, true), bind(c, true), bind(b, true), bind(a, false)])]).
step(cnf_clause(c1, [pos(a), pos(b)]), fact(2), [], []).
step(member(pos(b), [pos(a), pos(b)]), builtin, [], []).
step(literal_true(pos(b), [bind(d, true), bind(c, true), bind(b, true), bind(a, false)]),
     rule(13),
     ['Var' = b, 'Assignment' = [bind(d, true), bind(c, true), bind(b, true), bind(a, false)]],
     [lookup_bool(b, [bind(d, true), bind(c, true), bind(b, true), bind(a, false)], true)]).
step(satClauseStatus(c2, satisfied),
     rule(31),
     ['Clause' = c2, 'Model' = [bind(d, true), bind(c, true), bind(b, true), bind(a, false)]],
     [best_model([bind(d, true), bind(c, true), bind(b, true), bind(a, false)], 7),
      clause_satisfied([bind(d, true), bind(c, true), bind(b, true), bind(a, false)], c2)]).
step(clause_satisfied([bind(d, true), bind(c, true), bind(b, true), bind(a, false)], c2),
     rule(17),
     ['Assignment' = [bind(d, true), bind(c, true), bind(b, true), bind(a, false)],
      'Clause_name' = c2,
      'Literals' = [neg(a), pos(c)],
      'Literal' = neg(a)],
     [cnf_clause(c2, [neg(a), pos(c)]),
      member(neg(a), [neg(a), pos(c)]),
      literal_true(neg(a), [bind(d, true), bind(c, true), bind(b, true), bind(a, false)])]).
step(cnf_clause(c2, [neg(a), pos(c)]), fact(3), [], []).
step(member(neg(a), [neg(a), pos(c)]), builtin, [], []).
step(literal_true(neg(a), [bind(d, true), bind(c, true), bind(b, true), bind(a, false)]),
     rule(14),
     ['Var' = a, 'Assignment' = [bind(d, true), bind(c, true), bind(b, true), bind(a, false)]],
     [lookup_bool(a, [bind(d, true), bind(c, true), bind(b, true), bind(a, false)], false)]).
step(satClauseStatus(c3, satisfied),
     rule(31),
     ['Clause' = c3, 'Model' = [bind(d, true), bind(c, true), bind(b, true), bind(a, false)]],
     [best_model([bind(d, true), bind(c, true), bind(b, true), bind(a, false)], 7),
      clause_satisfied([bind(d, true), bind(c, true), bind(b, true), bind(a, false)], c3)]).
step(clause_satisfied([bind(d, true), bind(c, true), bind(b, true), bind(a, false)], c3),
     rule(17),
     ['Assignment' = [bind(d, true), bind(c, true), bind(b, true), bind(a, false)],
      'Clause_name' = c3,
      'Literals' = [neg(b), pos(c)],
      'Literal' = pos(c)],
     [cnf_clause(c3, [neg(b), pos(c)]),
      member(pos(c), [neg(b), pos(c)]),
      literal_true(pos(c), [bind(d, true), bind(c, true), bind(b, true), bind(a, false)])]).
step(cnf_clause(c3, [neg(b), pos(c)]), fact(4), [], []).
step(member(pos(c), [neg(b), pos(c)]), builtin, [], []).
step(literal_true(pos(c), [bind(d, true), bind(c, true), bind(b, true), bind(a, false)]),
     rule(13),
     ['Var' = c, 'Assignment' = [bind(d, true), bind(c, true), bind(b, true), bind(a, false)]],
     [lookup_bool(c, [bind(d, true), bind(c, true), bind(b, true), bind(a, false)], true)]).
step(satClauseStatus(c4, satisfied),
     rule(31),
     ['Clause' = c4, 'Model' = [bind(d, true), bind(c, true), bind(b, true), bind(a, false)]],
     [best_model([bind(d, true), bind(c, true), bind(b, true), bind(a, false)], 7),
      clause_satisfied([bind(d, true), bind(c, true), bind(b, true), bind(a, false)], c4)]).
step(clause_satisfied([bind(d, true), bind(c, true), bind(b, true), bind(a, false)], c4),
     rule(17),
     ['Assignment' = [bind(d, true), bind(c, true), bind(b, true), bind(a, false)],
      'Clause_name' = c4,
      'Literals' = [neg(c), pos(d)],
      'Literal' = pos(d)],
     [cnf_clause(c4, [neg(c), pos(d)]),
      member(pos(d), [neg(c), pos(d)]),
      literal_true(pos(d), [bind(d, true), bind(c, true), bind(b, true), bind(a, false)])]).
step(cnf_clause(c4, [neg(c), pos(d)]), fact(5), [], []).
step(member(pos(d), [neg(c), pos(d)]), builtin, [], []).
step(literal_true(pos(d), [bind(d, true), bind(c, true), bind(b, true), bind(a, false)]),
     rule(13),
     ['Var' = d, 'Assignment' = [bind(d, true), bind(c, true), bind(b, true), bind(a, false)]],
     [lookup_bool(d, [bind(d, true), bind(c, true), bind(b, true), bind(a, false)], true)]).
step(satClauseStatus(c5, satisfied),
     rule(31),
     ['Clause' = c5, 'Model' = [bind(d, true), bind(c, true), bind(b, true), bind(a, false)]],
     [best_model([bind(d, true), bind(c, true), bind(b, true), bind(a, false)], 7),
      clause_satisfied([bind(d, true), bind(c, true), bind(b, true), bind(a, false)], c5)]).
step(clause_satisfied([bind(d, true), bind(c, true), bind(b, true), bind(a, false)], c5),
     rule(17),
     ['Assignment' = [bind(d, true), bind(c, true), bind(b, true), bind(a, false)],
      'Clause_name' = c5,
      'Literals' = [pos(c), neg(d)],
      'Literal' = pos(c)],
     [cnf_clause(c5, [pos(c), neg(d)]),
      member(pos(c), [pos(c), neg(d)]),
      literal_true(pos(c), [bind(d, true), bind(c, true), bind(b, true), bind(a, false)])]).
step(cnf_clause(c5, [pos(c), neg(d)]), fact(6), [], []).
step(member(pos(c), [pos(c), neg(d)]), builtin, [], []).
step(satConclusion(case, "DPLL finds a satisfying assignment after pruning clauses that become impossible"),
     rule(32),
     [],
     [best_model([bind(d, true), bind(c, true), bind(b, true), bind(a, false)], 7)]).
