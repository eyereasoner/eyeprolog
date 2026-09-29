answer('PROBLEM INSTANCE\nMinterms: {1, 3, 7, 11, 15}\nDon''t Cares: {0, 2, 5}\n\nPRIME IMPLICANTS (Ordered):\n00xx, 0xx1, xx11\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD').
reason('1. Generated Prime Implicants by iteratively combining adjacent minterms/groups.\n2. Built Prime Implicant Chart for minterms only (excluding don''t cares).\n3. Extracted Essential Prime Implicants.\n4. Performed exhaustive search on remaining primes to find the smallest cover, breaking ties with the lexicographical key (0 < 1 < -).').
check(1, 'Functional Correctness (All minterms covered)', true).
check(2, 'Safety Check (No false positives outside DCs)', true).
check(3, 'Minimality (Cardinality) Proof', true).
check(4, 'Canonical Tie-Breaking (Lexicographical First)', true).
check(5, 'Consistency (Solution is subset of Primes)', true).

clause(10, width(4), true).
clause(12,
       answer(var('String')),
       (get_results(var('Primes'), var('Cover')),
        pats_to_string(var('Primes'), var('PStr')),
        pats_to_string(var('Cover'), var('CStr')),
        cover_to_sop(var('Cover'), var('SopStr')),
        atom_concat_list(['PROBLEM INSTANCE\n', 'Minterms: {1, 3, 7, 11, 15}\n', 'Don''t Cares: {0, 2, 5}\n\n', 'PRIME IMPLICANTS (Ordered):\n', var('PStr'), '\n', 'MINIMAL COVER (Lexicographically First):\n', var('CStr'), '\n', 'EQUATION:\n', ' f = ', var('SopStr')], var('String')))).
clause(13,
       reason(var('String')),
       var('String') = '1. Generated Prime Implicants by iteratively combining adjacent minterms/groups.\n2. Built Prime Implicant Chart for minterms only (excluding don''t cares).\n3. Extracted Essential Prime Implicants.\n4. Performed exhaustive search on remaining primes to find the smallest cover, breaking ties with the lexicographical key (0 < 1 < -).').
clause(14,
       check(1, 'Functional Correctness (All minterms covered)', var('Status')),
       (get_results(anonymous(1), var('Cover')),
        findall(var('M'), minterm(var('M')), var('Minterms')),
        coverage_status(var('Cover'), var('Minterms'), var('Status')))).
clause(15,
       check(2, 'Safety Check (No false positives outside DCs)', var('Status')),
       (get_results(anonymous(1), var('Cover')),
        findall(var('Z'), is_true_zero(var('Z')), var('Zeros')),
        safety_status(var('Cover'), var('Zeros'), var('Status')))).
clause(16,
       check(3, 'Minimality (Cardinality) Proof', var('Status')),
       (get_results(var('Primes'), var('Cover')),
        length_list(var('Cover'), var('Size')),
        var('Limit') is var('Size') - 1,
        findall(var('M'), minterm(var('M')), var('Minterms')),
        minimality_status(var('Primes'), var('Minterms'), var('Limit'), var('Status')))).
clause(17,
       check(4, 'Canonical Tie-Breaking (Lexicographical First)', var('Status')),
       (get_results(var('Primes'), var('Cover')),
        length_list(var('Cover'), var('Size')),
        findall(var('M'), minterm(var('M')), var('Minterms')),
        findall(var('C'), (find_combination(var('Size'), var('Primes'), var('C')), covers_all(var('C'), var('Minterms'))), var('Alternatives')),
        sort(var('Alternatives'), [var('Best') | anonymous(1)]),
        equality_status(var('Cover'), var('Best'), var('Status')))).
clause(18,
       check(5, 'Consistency (Solution is subset of Primes)', var('Status')),
       (get_results(var('Primes'), var('Cover')),
        subset_status(var('Cover'), var('Primes'), var('Status')))).
clause(19,
       coverage_status(var('Cover'), var('Minterms'), true),
       (covers_all(var('Cover'), var('Minterms')), !)).
clause(21,
       safety_status(var('Cover'), var('Zeros'), true),
       (zeros_safe(var('Cover'), var('Zeros')), !)).
clause(24, minimality_status(anonymous(1), anonymous(2), anonymous(3), true), true).
clause(25, equality_status(var('X'), var('X'), true), !).
clause(27,
       subset_status(var('Subset'), var('Set'), true),
       (is_subset(var('Subset'), var('Set')), !)).
clause(29,
       get_results(var('Primes'), var('Cover')),
       (solution_cache(var('Primes'), var('Cover')), !)).
clause(31, atom_concat_list([], ''), true).
clause(32,
       atom_concat_list([var('H') | var('T')], var('S')),
       (atom_concat_list(var('T'), var('Rest')), atom_concat(var('H'), var('Rest'), var('S')))).
clause(33, length_list([], 0), true).
clause(34,
       length_list([anonymous(1) | var('T')], var('N')),
       (length_list(var('T'), var('N1')), var('N') is var('N1') + 1)).
clause(37, is_subset([], anonymous(1)), true).
clause(38,
       is_subset([var('H') | var('T')], var('List')),
       (member(var('H'), var('List')), is_subset(var('T'), var('List')))).
clause(39,
       int_to_bits(var('N'), var('Bits')),
       (width(var('W')), format_bits(var('N'), var('W'), var('Bits')))).
clause(40, format_bits(anonymous(1), 0, []), !).
clause(41,
       format_bits(var('N'), var('W'), [var('B') | var('Rest')]),
       (var('W') > 0,
        var('W1') is var('W') - 1,
        var('Val') is var('N') >> var('W1') /\ 1,
        (var('Val') = 1 -> var('B') = '1' ; var('B') = '0'),
        var('NRem') is var('N') - var('Val') << var('W1'),
        format_bits(var('NRem'), var('W1'), var('Rest')))).
clause(42, covers([], []), true).
clause(43, covers("x"||var('Ps'), [anonymous(1) | var('Bs')]), covers(var('Ps'), var('Bs'))).
clause(44,
       covers([var('B') | var('Ps')], [var('B') | var('Bs')]),
       (var('B') \= x, covers(var('Ps'), var('Bs')))).
clause(45,
       covers_int(var('Pat'), var('Int')),
       (int_to_bits(var('Int'), var('Bits')), covers(var('Pat'), var('Bits')))).
clause(58,
       prime_covers_any(var('Primes'), var('Minterm')),
       (member(var('P'), var('Primes')), covers_int(var('P'), var('Minterm')))).
clause(66, covers_all(anonymous(1), []), true).
clause(67,
       covers_all(var('Primes'), [var('T') | var('Targets')]),
       (prime_covers_any(var('Primes'), var('T')), covers_all(var('Primes'), var('Targets')))).
clause(69, zeros_safe(anonymous(1), []), true).
clause(70,
       zeros_safe(var('Cover'), [var('Z') | var('Zeros')]),
       (no_prime_covers(var('Cover'), var('Z')), zeros_safe(var('Cover'), var('Zeros')))).
clause(71, no_prime_covers([], anonymous(1)), true).
clause(72,
       no_prime_covers([var('P') | var('Ps')], var('Value')),
       (\+ covers_int(var('P'), var('Value')), no_prime_covers(var('Ps'), var('Value')))).
clause(74, pats_to_string([var('H')], var('S')), pat_to_str(var('H'), var('S'))).
clause(75,
       pats_to_string([var('H'), var('N') | var('T')], var('S')),
       (pat_to_str(var('H'), var('Hs')),
        pats_to_string([var('N') | var('T')], var('Ts')),
        atom_concat_list([var('Hs'), ', ', var('Ts')], var('S')))).
clause(76, pat_to_str(var('P'), var('S')), atom_concat_list(var('P'), var('S'))).
clause(77,
       cover_to_sop(var('Cover'), var('S')),
       (findall(var('Part'), (member(var('Pat'), var('Cover')), term_sop(var('Pat'), var('Part'))), var('Terms')),
        intersperse_sop(var('Terms'), var('Parts')),
        atom_concat_list(var('Parts'), var('S')))).
clause(78, intersperse_sop([var('H')], [var('H')]), true).
clause(79,
       intersperse_sop([var('H'), var('N') | var('T')], [var('H'), ' + ' | var('Rest')]),
       intersperse_sop([var('N') | var('T')], var('Rest'))).

step(answer('PROBLEM INSTANCE\nMinterms: {1, 3, 7, 11, 15}\nDon''t Cares: {0, 2, 5}\n\nPRIME IMPLICANTS (Ordered):\n00xx, 0xx1, xx11\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD'),
     rule(12),
     ['String' = 'PROBLEM INSTANCE\nMinterms: {1, 3, 7, 11, 15}\nDon''t Cares: {0, 2, 5}\n\nPRIME IMPLICANTS (Ordered):\n00xx, 0xx1, xx11\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD',
      'Primes' = ["00xx", "0xx1", "xx11"],
      'Cover' = ["00xx", "xx11"],
      'PStr' = '00xx, 0xx1, xx11',
      'CStr' = '00xx, xx11',
      'SopStr' = '~A~B + CD'],
     [get_results(["00xx", "0xx1", "xx11"], ["00xx", "xx11"]),
      pats_to_string(["00xx", "0xx1", "xx11"], '00xx, 0xx1, xx11'),
      pats_to_string(["00xx", "xx11"], '00xx, xx11'),
      cover_to_sop(["00xx", "xx11"], '~A~B + CD'),
      atom_concat_list(['PROBLEM INSTANCE\n', 'Minterms: {1, 3, 7, 11, 15}\n', 'Don''t Cares: {0, 2, 5}\n\n', 'PRIME IMPLICANTS (Ordered):\n', '00xx, 0xx1, xx11', '\n', 'MINIMAL COVER (Lexicographically First):\n', '00xx, xx11', '\n', 'EQUATION:\n', ' f = ', '~A~B + CD'], 'PROBLEM INSTANCE\nMinterms: {1, 3, 7, 11, 15}\nDon''t Cares: {0, 2, 5}\n\nPRIME IMPLICANTS (Ordered):\n00xx, 0xx1, xx11\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD')]).
step(get_results(["00xx", "0xx1", "xx11"], ["00xx", "xx11"]),
     rule(29),
     ['Primes' = ["00xx", "0xx1", "xx11"], 'Cover' = ["00xx", "xx11"]],
     [solution_cache(["00xx", "0xx1", "xx11"], ["00xx", "xx11"]), !]).
step(solution_cache(["00xx", "0xx1", "xx11"], ["00xx", "xx11"]), asserted, [], []).
step(!, builtin, [], []).
step(pats_to_string(["00xx", "0xx1", "xx11"], '00xx, 0xx1, xx11'),
     rule(75),
     ['H' = "00xx",
      'N' = "0xx1",
      'T' = ["xx11"],
      'S' = '00xx, 0xx1, xx11',
      'Hs' = '00xx',
      'Ts' = '0xx1, xx11'],
     [pat_to_str("00xx", '00xx'),
      pats_to_string(["0xx1", "xx11"], '0xx1, xx11'),
      atom_concat_list(['00xx', ', ', '0xx1, xx11'], '00xx, 0xx1, xx11')]).
step(pat_to_str("00xx", '00xx'),
     rule(76),
     ['P' = "00xx", 'S' = '00xx'],
     [atom_concat_list("00xx", '00xx')]).
step(atom_concat_list("00xx", '00xx'),
     rule(32),
     ['H' = '0', 'T' = "0xx", 'S' = '00xx', 'Rest' = '0xx'],
     [atom_concat_list("0xx", '0xx'), atom_concat('0', '0xx', '00xx')]).
step(atom_concat_list("0xx", '0xx'),
     rule(32),
     ['H' = '0', 'T' = "xx", 'S' = '0xx', 'Rest' = xx],
     [atom_concat_list("xx", xx), atom_concat('0', xx, '0xx')]).
step(atom_concat_list("xx", xx),
     rule(32),
     ['H' = x, 'T' = "x", 'S' = xx, 'Rest' = x],
     [atom_concat_list("x", x), atom_concat(x, x, xx)]).
step(atom_concat_list("x", x),
     rule(32),
     ['H' = x, 'T' = [], 'S' = x, 'Rest' = ''],
     [atom_concat_list([], ''), atom_concat(x, '', x)]).
step(atom_concat_list([], ''), fact(31), [], []).
step(atom_concat(x, '', x), builtin, [], []).
step(atom_concat(x, x, xx), builtin, [], []).
step(atom_concat('0', xx, '0xx'), builtin, [], []).
step(atom_concat('0', '0xx', '00xx'), builtin, [], []).
step(pats_to_string(["0xx1", "xx11"], '0xx1, xx11'),
     rule(75),
     ['H' = "0xx1", 'N' = "xx11", 'T' = [], 'S' = '0xx1, xx11', 'Hs' = '0xx1', 'Ts' = xx11],
     [pat_to_str("0xx1", '0xx1'),
      pats_to_string(["xx11"], xx11),
      atom_concat_list(['0xx1', ', ', xx11], '0xx1, xx11')]).
step(pat_to_str("0xx1", '0xx1'),
     rule(76),
     ['P' = "0xx1", 'S' = '0xx1'],
     [atom_concat_list("0xx1", '0xx1')]).
step(atom_concat_list("0xx1", '0xx1'),
     rule(32),
     ['H' = '0', 'T' = "xx1", 'S' = '0xx1', 'Rest' = xx1],
     [atom_concat_list("xx1", xx1), atom_concat('0', xx1, '0xx1')]).
step(atom_concat_list("xx1", xx1),
     rule(32),
     ['H' = x, 'T' = "x1", 'S' = xx1, 'Rest' = x1],
     [atom_concat_list("x1", x1), atom_concat(x, x1, xx1)]).
step(atom_concat_list("x1", x1),
     rule(32),
     ['H' = x, 'T' = "1", 'S' = x1, 'Rest' = '1'],
     [atom_concat_list("1", '1'), atom_concat(x, '1', x1)]).
step(atom_concat_list("1", '1'),
     rule(32),
     ['H' = '1', 'T' = [], 'S' = '1', 'Rest' = ''],
     [atom_concat_list([], ''), atom_concat('1', '', '1')]).
step(atom_concat('1', '', '1'), builtin, [], []).
step(atom_concat(x, '1', x1), builtin, [], []).
step(atom_concat(x, x1, xx1), builtin, [], []).
step(atom_concat('0', xx1, '0xx1'), builtin, [], []).
step(pats_to_string(["xx11"], xx11),
     rule(74),
     ['H' = "xx11", 'S' = xx11],
     [pat_to_str("xx11", xx11)]).
step(pat_to_str("xx11", xx11),
     rule(76),
     ['P' = "xx11", 'S' = xx11],
     [atom_concat_list("xx11", xx11)]).
step(atom_concat_list("xx11", xx11),
     rule(32),
     ['H' = x, 'T' = "x11", 'S' = xx11, 'Rest' = x11],
     [atom_concat_list("x11", x11), atom_concat(x, x11, xx11)]).
step(atom_concat_list("x11", x11),
     rule(32),
     ['H' = x, 'T' = "11", 'S' = x11, 'Rest' = '11'],
     [atom_concat_list("11", '11'), atom_concat(x, '11', x11)]).
step(atom_concat_list("11", '11'),
     rule(32),
     ['H' = '1', 'T' = "1", 'S' = '11', 'Rest' = '1'],
     [atom_concat_list("1", '1'), atom_concat('1', '1', '11')]).
step(atom_concat('1', '1', '11'), builtin, [], []).
step(atom_concat(x, '11', x11), builtin, [], []).
step(atom_concat(x, x11, xx11), builtin, [], []).
step(atom_concat_list(['0xx1', ', ', xx11], '0xx1, xx11'),
     rule(32),
     ['H' = '0xx1', 'T' = [', ', xx11], 'S' = '0xx1, xx11', 'Rest' = ', xx11'],
     [atom_concat_list([', ', xx11], ', xx11'), atom_concat('0xx1', ', xx11', '0xx1, xx11')]).
step(atom_concat_list([', ', xx11], ', xx11'),
     rule(32),
     ['H' = ', ', 'T' = [xx11], 'S' = ', xx11', 'Rest' = xx11],
     [atom_concat_list([xx11], xx11), atom_concat(', ', xx11, ', xx11')]).
step(atom_concat_list([xx11], xx11),
     rule(32),
     ['H' = xx11, 'T' = [], 'S' = xx11, 'Rest' = ''],
     [atom_concat_list([], ''), atom_concat(xx11, '', xx11)]).
step(atom_concat(xx11, '', xx11), builtin, [], []).
step(atom_concat(', ', xx11, ', xx11'), builtin, [], []).
step(atom_concat('0xx1', ', xx11', '0xx1, xx11'), builtin, [], []).
step(atom_concat_list(['00xx', ', ', '0xx1, xx11'], '00xx, 0xx1, xx11'),
     rule(32),
     ['H' = '00xx',
      'T' = [', ', '0xx1, xx11'],
      'S' = '00xx, 0xx1, xx11',
      'Rest' = ', 0xx1, xx11'],
     [atom_concat_list([', ', '0xx1, xx11'], ', 0xx1, xx11'),
      atom_concat('00xx', ', 0xx1, xx11', '00xx, 0xx1, xx11')]).
step(atom_concat_list([', ', '0xx1, xx11'], ', 0xx1, xx11'),
     rule(32),
     ['H' = ', ', 'T' = ['0xx1, xx11'], 'S' = ', 0xx1, xx11', 'Rest' = '0xx1, xx11'],
     [atom_concat_list(['0xx1, xx11'], '0xx1, xx11'),
      atom_concat(', ', '0xx1, xx11', ', 0xx1, xx11')]).
step(atom_concat_list(['0xx1, xx11'], '0xx1, xx11'),
     rule(32),
     ['H' = '0xx1, xx11', 'T' = [], 'S' = '0xx1, xx11', 'Rest' = ''],
     [atom_concat_list([], ''), atom_concat('0xx1, xx11', '', '0xx1, xx11')]).
step(atom_concat('0xx1, xx11', '', '0xx1, xx11'), builtin, [], []).
step(atom_concat(', ', '0xx1, xx11', ', 0xx1, xx11'), builtin, [], []).
step(atom_concat('00xx', ', 0xx1, xx11', '00xx, 0xx1, xx11'), builtin, [], []).
step(pats_to_string(["00xx", "xx11"], '00xx, xx11'),
     rule(75),
     ['H' = "00xx", 'N' = "xx11", 'T' = [], 'S' = '00xx, xx11', 'Hs' = '00xx', 'Ts' = xx11],
     [pat_to_str("00xx", '00xx'),
      pats_to_string(["xx11"], xx11),
      atom_concat_list(['00xx', ', ', xx11], '00xx, xx11')]).
step(atom_concat_list(['00xx', ', ', xx11], '00xx, xx11'),
     rule(32),
     ['H' = '00xx', 'T' = [', ', xx11], 'S' = '00xx, xx11', 'Rest' = ', xx11'],
     [atom_concat_list([', ', xx11], ', xx11'), atom_concat('00xx', ', xx11', '00xx, xx11')]).
step(atom_concat('00xx', ', xx11', '00xx, xx11'), builtin, [], []).
step(cover_to_sop(["00xx", "xx11"], '~A~B + CD'),
     rule(77),
     ['Cover' = ["00xx", "xx11"],
      'S' = '~A~B + CD',
      'Terms' = ['~A~B', 'CD'],
      'Parts' = ['~A~B', ' + ', 'CD']],
     [findall(Part, (member(Pat, ["00xx", "xx11"]), term_sop(Pat, Part)), ['~A~B', 'CD']),
      intersperse_sop(['~A~B', 'CD'], ['~A~B', ' + ', 'CD']),
      atom_concat_list(['~A~B', ' + ', 'CD'], '~A~B + CD')]).
step(findall(Part, (member(Pat, ["00xx", "xx11"]), term_sop(Pat, Part)), ['~A~B', 'CD']),
     collected,
     [],
     []).
step(intersperse_sop(['~A~B', 'CD'], ['~A~B', ' + ', 'CD']),
     rule(79),
     ['H' = '~A~B', 'N' = 'CD', 'T' = [], 'Rest' = ['CD']],
     [intersperse_sop(['CD'], ['CD'])]).
step(intersperse_sop(['CD'], ['CD']), fact(78), ['H' = 'CD'], []).
step(atom_concat_list(['~A~B', ' + ', 'CD'], '~A~B + CD'),
     rule(32),
     ['H' = '~A~B', 'T' = [' + ', 'CD'], 'S' = '~A~B + CD', 'Rest' = ' + CD'],
     [atom_concat_list([' + ', 'CD'], ' + CD'), atom_concat('~A~B', ' + CD', '~A~B + CD')]).
step(atom_concat_list([' + ', 'CD'], ' + CD'),
     rule(32),
     ['H' = ' + ', 'T' = ['CD'], 'S' = ' + CD', 'Rest' = 'CD'],
     [atom_concat_list(['CD'], 'CD'), atom_concat(' + ', 'CD', ' + CD')]).
step(atom_concat_list(['CD'], 'CD'),
     rule(32),
     ['H' = 'CD', 'T' = [], 'S' = 'CD', 'Rest' = ''],
     [atom_concat_list([], ''), atom_concat('CD', '', 'CD')]).
step(atom_concat('CD', '', 'CD'), builtin, [], []).
step(atom_concat(' + ', 'CD', ' + CD'), builtin, [], []).
step(atom_concat('~A~B', ' + CD', '~A~B + CD'), builtin, [], []).
step(atom_concat_list(['PROBLEM INSTANCE\n', 'Minterms: {1, 3, 7, 11, 15}\n', 'Don''t Cares: {0, 2, 5}\n\n', 'PRIME IMPLICANTS (Ordered):\n', '00xx, 0xx1, xx11', '\n', 'MINIMAL COVER (Lexicographically First):\n', '00xx, xx11', '\n', 'EQUATION:\n', ' f = ', '~A~B + CD'], 'PROBLEM INSTANCE\nMinterms: {1, 3, 7, 11, 15}\nDon''t Cares: {0, 2, 5}\n\nPRIME IMPLICANTS (Ordered):\n00xx, 0xx1, xx11\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD'),
     rule(32),
     ['H' = 'PROBLEM INSTANCE\n',
      'T' = ['Minterms: {1, 3, 7, 11, 15}\n', 'Don''t Cares: {0, 2, 5}\n\n', 'PRIME IMPLICANTS (Ordered):\n', '00xx, 0xx1, xx11', '\n', 'MINIMAL COVER (Lexicographically First):\n', '00xx, xx11', '\n', 'EQUATION:\n', ' f = ', '~A~B + CD'],
      'S' = 'PROBLEM INSTANCE\nMinterms: {1, 3, 7, 11, 15}\nDon''t Cares: {0, 2, 5}\n\nPRIME IMPLICANTS (Ordered):\n00xx, 0xx1, xx11\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD',
      'Rest' = 'Minterms: {1, 3, 7, 11, 15}\nDon''t Cares: {0, 2, 5}\n\nPRIME IMPLICANTS (Ordered):\n00xx, 0xx1, xx11\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD'],
     [atom_concat_list(['Minterms: {1, 3, 7, 11, 15}\n', 'Don''t Cares: {0, 2, 5}\n\n', 'PRIME IMPLICANTS (Ordered):\n', '00xx, 0xx1, xx11', '\n', 'MINIMAL COVER (Lexicographically First):\n', '00xx, xx11', '\n', 'EQUATION:\n', ' f = ', '~A~B + CD'], 'Minterms: {1, 3, 7, 11, 15}\nDon''t Cares: {0, 2, 5}\n\nPRIME IMPLICANTS (Ordered):\n00xx, 0xx1, xx11\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD'),
      atom_concat('PROBLEM INSTANCE\n', 'Minterms: {1, 3, 7, 11, 15}\nDon''t Cares: {0, 2, 5}\n\nPRIME IMPLICANTS (Ordered):\n00xx, 0xx1, xx11\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD', 'PROBLEM INSTANCE\nMinterms: {1, 3, 7, 11, 15}\nDon''t Cares: {0, 2, 5}\n\nPRIME IMPLICANTS (Ordered):\n00xx, 0xx1, xx11\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD')]).
step(atom_concat_list(['Minterms: {1, 3, 7, 11, 15}\n', 'Don''t Cares: {0, 2, 5}\n\n', 'PRIME IMPLICANTS (Ordered):\n', '00xx, 0xx1, xx11', '\n', 'MINIMAL COVER (Lexicographically First):\n', '00xx, xx11', '\n', 'EQUATION:\n', ' f = ', '~A~B + CD'], 'Minterms: {1, 3, 7, 11, 15}\nDon''t Cares: {0, 2, 5}\n\nPRIME IMPLICANTS (Ordered):\n00xx, 0xx1, xx11\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD'),
     rule(32),
     ['H' = 'Minterms: {1, 3, 7, 11, 15}\n',
      'T' = ['Don''t Cares: {0, 2, 5}\n\n', 'PRIME IMPLICANTS (Ordered):\n', '00xx, 0xx1, xx11', '\n', 'MINIMAL COVER (Lexicographically First):\n', '00xx, xx11', '\n', 'EQUATION:\n', ' f = ', '~A~B + CD'],
      'S' = 'Minterms: {1, 3, 7, 11, 15}\nDon''t Cares: {0, 2, 5}\n\nPRIME IMPLICANTS (Ordered):\n00xx, 0xx1, xx11\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD',
      'Rest' = 'Don''t Cares: {0, 2, 5}\n\nPRIME IMPLICANTS (Ordered):\n00xx, 0xx1, xx11\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD'],
     [atom_concat_list(['Don''t Cares: {0, 2, 5}\n\n', 'PRIME IMPLICANTS (Ordered):\n', '00xx, 0xx1, xx11', '\n', 'MINIMAL COVER (Lexicographically First):\n', '00xx, xx11', '\n', 'EQUATION:\n', ' f = ', '~A~B + CD'], 'Don''t Cares: {0, 2, 5}\n\nPRIME IMPLICANTS (Ordered):\n00xx, 0xx1, xx11\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD'),
      atom_concat('Minterms: {1, 3, 7, 11, 15}\n', 'Don''t Cares: {0, 2, 5}\n\nPRIME IMPLICANTS (Ordered):\n00xx, 0xx1, xx11\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD', 'Minterms: {1, 3, 7, 11, 15}\nDon''t Cares: {0, 2, 5}\n\nPRIME IMPLICANTS (Ordered):\n00xx, 0xx1, xx11\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD')]).
step(atom_concat_list(['Don''t Cares: {0, 2, 5}\n\n', 'PRIME IMPLICANTS (Ordered):\n', '00xx, 0xx1, xx11', '\n', 'MINIMAL COVER (Lexicographically First):\n', '00xx, xx11', '\n', 'EQUATION:\n', ' f = ', '~A~B + CD'], 'Don''t Cares: {0, 2, 5}\n\nPRIME IMPLICANTS (Ordered):\n00xx, 0xx1, xx11\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD'),
     rule(32),
     ['H' = 'Don''t Cares: {0, 2, 5}\n\n',
      'T' = ['PRIME IMPLICANTS (Ordered):\n', '00xx, 0xx1, xx11', '\n', 'MINIMAL COVER (Lexicographically First):\n', '00xx, xx11', '\n', 'EQUATION:\n', ' f = ', '~A~B + CD'],
      'S' = 'Don''t Cares: {0, 2, 5}\n\nPRIME IMPLICANTS (Ordered):\n00xx, 0xx1, xx11\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD',
      'Rest' = 'PRIME IMPLICANTS (Ordered):\n00xx, 0xx1, xx11\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD'],
     [atom_concat_list(['PRIME IMPLICANTS (Ordered):\n', '00xx, 0xx1, xx11', '\n', 'MINIMAL COVER (Lexicographically First):\n', '00xx, xx11', '\n', 'EQUATION:\n', ' f = ', '~A~B + CD'], 'PRIME IMPLICANTS (Ordered):\n00xx, 0xx1, xx11\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD'),
      atom_concat('Don''t Cares: {0, 2, 5}\n\n', 'PRIME IMPLICANTS (Ordered):\n00xx, 0xx1, xx11\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD', 'Don''t Cares: {0, 2, 5}\n\nPRIME IMPLICANTS (Ordered):\n00xx, 0xx1, xx11\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD')]).
step(atom_concat_list(['PRIME IMPLICANTS (Ordered):\n', '00xx, 0xx1, xx11', '\n', 'MINIMAL COVER (Lexicographically First):\n', '00xx, xx11', '\n', 'EQUATION:\n', ' f = ', '~A~B + CD'], 'PRIME IMPLICANTS (Ordered):\n00xx, 0xx1, xx11\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD'),
     rule(32),
     ['H' = 'PRIME IMPLICANTS (Ordered):\n',
      'T' = ['00xx, 0xx1, xx11', '\n', 'MINIMAL COVER (Lexicographically First):\n', '00xx, xx11', '\n', 'EQUATION:\n', ' f = ', '~A~B + CD'],
      'S' = 'PRIME IMPLICANTS (Ordered):\n00xx, 0xx1, xx11\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD',
      'Rest' = '00xx, 0xx1, xx11\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD'],
     [atom_concat_list(['00xx, 0xx1, xx11', '\n', 'MINIMAL COVER (Lexicographically First):\n', '00xx, xx11', '\n', 'EQUATION:\n', ' f = ', '~A~B + CD'], '00xx, 0xx1, xx11\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD'),
      atom_concat('PRIME IMPLICANTS (Ordered):\n', '00xx, 0xx1, xx11\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD', 'PRIME IMPLICANTS (Ordered):\n00xx, 0xx1, xx11\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD')]).
step(atom_concat_list(['00xx, 0xx1, xx11', '\n', 'MINIMAL COVER (Lexicographically First):\n', '00xx, xx11', '\n', 'EQUATION:\n', ' f = ', '~A~B + CD'], '00xx, 0xx1, xx11\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD'),
     rule(32),
     ['H' = '00xx, 0xx1, xx11',
      'T' = ['\n', 'MINIMAL COVER (Lexicographically First):\n', '00xx, xx11', '\n', 'EQUATION:\n', ' f = ', '~A~B + CD'],
      'S' = '00xx, 0xx1, xx11\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD',
      'Rest' = '\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD'],
     [atom_concat_list(['\n', 'MINIMAL COVER (Lexicographically First):\n', '00xx, xx11', '\n', 'EQUATION:\n', ' f = ', '~A~B + CD'], '\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD'),
      atom_concat('00xx, 0xx1, xx11', '\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD', '00xx, 0xx1, xx11\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD')]).
step(atom_concat_list(['\n', 'MINIMAL COVER (Lexicographically First):\n', '00xx, xx11', '\n', 'EQUATION:\n', ' f = ', '~A~B + CD'], '\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD'),
     rule(32),
     ['H' = '\n',
      'T' = ['MINIMAL COVER (Lexicographically First):\n', '00xx, xx11', '\n', 'EQUATION:\n', ' f = ', '~A~B + CD'],
      'S' = '\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD',
      'Rest' = 'MINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD'],
     [atom_concat_list(['MINIMAL COVER (Lexicographically First):\n', '00xx, xx11', '\n', 'EQUATION:\n', ' f = ', '~A~B + CD'], 'MINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD'),
      atom_concat('\n', 'MINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD', '\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD')]).
step(atom_concat_list(['MINIMAL COVER (Lexicographically First):\n', '00xx, xx11', '\n', 'EQUATION:\n', ' f = ', '~A~B + CD'], 'MINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD'),
     rule(32),
     ['H' = 'MINIMAL COVER (Lexicographically First):\n',
      'T' = ['00xx, xx11', '\n', 'EQUATION:\n', ' f = ', '~A~B + CD'],
      'S' = 'MINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD',
      'Rest' = '00xx, xx11\nEQUATION:\n f = ~A~B + CD'],
     [atom_concat_list(['00xx, xx11', '\n', 'EQUATION:\n', ' f = ', '~A~B + CD'], '00xx, xx11\nEQUATION:\n f = ~A~B + CD'),
      atom_concat('MINIMAL COVER (Lexicographically First):\n', '00xx, xx11\nEQUATION:\n f = ~A~B + CD', 'MINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD')]).
step(atom_concat_list(['00xx, xx11', '\n', 'EQUATION:\n', ' f = ', '~A~B + CD'], '00xx, xx11\nEQUATION:\n f = ~A~B + CD'),
     rule(32),
     ['H' = '00xx, xx11',
      'T' = ['\n', 'EQUATION:\n', ' f = ', '~A~B + CD'],
      'S' = '00xx, xx11\nEQUATION:\n f = ~A~B + CD',
      'Rest' = '\nEQUATION:\n f = ~A~B + CD'],
     [atom_concat_list(['\n', 'EQUATION:\n', ' f = ', '~A~B + CD'], '\nEQUATION:\n f = ~A~B + CD'),
      atom_concat('00xx, xx11', '\nEQUATION:\n f = ~A~B + CD', '00xx, xx11\nEQUATION:\n f = ~A~B + CD')]).
step(atom_concat_list(['\n', 'EQUATION:\n', ' f = ', '~A~B + CD'], '\nEQUATION:\n f = ~A~B + CD'),
     rule(32),
     ['H' = '\n',
      'T' = ['EQUATION:\n', ' f = ', '~A~B + CD'],
      'S' = '\nEQUATION:\n f = ~A~B + CD',
      'Rest' = 'EQUATION:\n f = ~A~B + CD'],
     [atom_concat_list(['EQUATION:\n', ' f = ', '~A~B + CD'], 'EQUATION:\n f = ~A~B + CD'),
      atom_concat('\n', 'EQUATION:\n f = ~A~B + CD', '\nEQUATION:\n f = ~A~B + CD')]).
step(atom_concat_list(['EQUATION:\n', ' f = ', '~A~B + CD'], 'EQUATION:\n f = ~A~B + CD'),
     rule(32),
     ['H' = 'EQUATION:\n',
      'T' = [' f = ', '~A~B + CD'],
      'S' = 'EQUATION:\n f = ~A~B + CD',
      'Rest' = ' f = ~A~B + CD'],
     [atom_concat_list([' f = ', '~A~B + CD'], ' f = ~A~B + CD'),
      atom_concat('EQUATION:\n', ' f = ~A~B + CD', 'EQUATION:\n f = ~A~B + CD')]).
step(atom_concat_list([' f = ', '~A~B + CD'], ' f = ~A~B + CD'),
     rule(32),
     ['H' = ' f = ', 'T' = ['~A~B + CD'], 'S' = ' f = ~A~B + CD', 'Rest' = '~A~B + CD'],
     [atom_concat_list(['~A~B + CD'], '~A~B + CD'),
      atom_concat(' f = ', '~A~B + CD', ' f = ~A~B + CD')]).
step(atom_concat_list(['~A~B + CD'], '~A~B + CD'),
     rule(32),
     ['H' = '~A~B + CD', 'T' = [], 'S' = '~A~B + CD', 'Rest' = ''],
     [atom_concat_list([], ''), atom_concat('~A~B + CD', '', '~A~B + CD')]).
step(atom_concat('~A~B + CD', '', '~A~B + CD'), builtin, [], []).
step(atom_concat(' f = ', '~A~B + CD', ' f = ~A~B + CD'), builtin, [], []).
step(atom_concat('EQUATION:\n', ' f = ~A~B + CD', 'EQUATION:\n f = ~A~B + CD'), builtin, [], []).
step(atom_concat('\n', 'EQUATION:\n f = ~A~B + CD', '\nEQUATION:\n f = ~A~B + CD'),
     builtin,
     [],
     []).
step(atom_concat('00xx, xx11', '\nEQUATION:\n f = ~A~B + CD', '00xx, xx11\nEQUATION:\n f = ~A~B + CD'),
     builtin,
     [],
     []).
step(atom_concat('MINIMAL COVER (Lexicographically First):\n', '00xx, xx11\nEQUATION:\n f = ~A~B + CD', 'MINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD'),
     builtin,
     [],
     []).
step(atom_concat('\n', 'MINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD', '\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD'),
     builtin,
     [],
     []).
step(atom_concat('00xx, 0xx1, xx11', '\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD', '00xx, 0xx1, xx11\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD'),
     builtin,
     [],
     []).
step(atom_concat('PRIME IMPLICANTS (Ordered):\n', '00xx, 0xx1, xx11\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD', 'PRIME IMPLICANTS (Ordered):\n00xx, 0xx1, xx11\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD'),
     builtin,
     [],
     []).
step(atom_concat('Don''t Cares: {0, 2, 5}\n\n', 'PRIME IMPLICANTS (Ordered):\n00xx, 0xx1, xx11\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD', 'Don''t Cares: {0, 2, 5}\n\nPRIME IMPLICANTS (Ordered):\n00xx, 0xx1, xx11\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD'),
     builtin,
     [],
     []).
step(atom_concat('Minterms: {1, 3, 7, 11, 15}\n', 'Don''t Cares: {0, 2, 5}\n\nPRIME IMPLICANTS (Ordered):\n00xx, 0xx1, xx11\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD', 'Minterms: {1, 3, 7, 11, 15}\nDon''t Cares: {0, 2, 5}\n\nPRIME IMPLICANTS (Ordered):\n00xx, 0xx1, xx11\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD'),
     builtin,
     [],
     []).
step(atom_concat('PROBLEM INSTANCE\n', 'Minterms: {1, 3, 7, 11, 15}\nDon''t Cares: {0, 2, 5}\n\nPRIME IMPLICANTS (Ordered):\n00xx, 0xx1, xx11\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD', 'PROBLEM INSTANCE\nMinterms: {1, 3, 7, 11, 15}\nDon''t Cares: {0, 2, 5}\n\nPRIME IMPLICANTS (Ordered):\n00xx, 0xx1, xx11\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD'),
     builtin,
     [],
     []).
step(reason('1. Generated Prime Implicants by iteratively combining adjacent minterms/groups.\n2. Built Prime Implicant Chart for minterms only (excluding don''t cares).\n3. Extracted Essential Prime Implicants.\n4. Performed exhaustive search on remaining primes to find the smallest cover, breaking ties with the lexicographical key (0 < 1 < -).'),
     rule(13),
     ['String' = '1. Generated Prime Implicants by iteratively combining adjacent minterms/groups.\n2. Built Prime Implicant Chart for minterms only (excluding don''t cares).\n3. Extracted Essential Prime Implicants.\n4. Performed exhaustive search on remaining primes to find the smallest cover, breaking ties with the lexicographical key (0 < 1 < -).'],
     ['1. Generated Prime Implicants by iteratively combining adjacent minterms/groups.\n2. Built Prime Implicant Chart for minterms only (excluding don''t cares).\n3. Extracted Essential Prime Implicants.\n4. Performed exhaustive search on remaining primes to find the smallest cover, breaking ties with the lexicographical key (0 < 1 < -).' = '1. Generated Prime Implicants by iteratively combining adjacent minterms/groups.\n2. Built Prime Implicant Chart for minterms only (excluding don''t cares).\n3. Extracted Essential Prime Implicants.\n4. Performed exhaustive search on remaining primes to find the smallest cover, breaking ties with the lexicographical key (0 < 1 < -).']).
step('1. Generated Prime Implicants by iteratively combining adjacent minterms/groups.\n2. Built Prime Implicant Chart for minterms only (excluding don''t cares).\n3. Extracted Essential Prime Implicants.\n4. Performed exhaustive search on remaining primes to find the smallest cover, breaking ties with the lexicographical key (0 < 1 < -).' = '1. Generated Prime Implicants by iteratively combining adjacent minterms/groups.\n2. Built Prime Implicant Chart for minterms only (excluding don''t cares).\n3. Extracted Essential Prime Implicants.\n4. Performed exhaustive search on remaining primes to find the smallest cover, breaking ties with the lexicographical key (0 < 1 < -).',
     builtin,
     [],
     []).
step(check(1, 'Functional Correctness (All minterms covered)', true),
     rule(14),
     ['Status' = true, 'Cover' = ["00xx", "xx11"], 'Minterms' = [1, 3, 7, 11, 15]],
     [get_results(["00xx", "0xx1", "xx11"], ["00xx", "xx11"]),
      findall(M, minterm(M), [1, 3, 7, 11, 15]),
      coverage_status(["00xx", "xx11"], [1, 3, 7, 11, 15], true)]).
step(findall(M, minterm(M), [1, 3, 7, 11, 15]), collected, [], []).
step(coverage_status(["00xx", "xx11"], [1, 3, 7, 11, 15], true),
     rule(19),
     ['Cover' = ["00xx", "xx11"], 'Minterms' = [1, 3, 7, 11, 15]],
     [covers_all(["00xx", "xx11"], [1, 3, 7, 11, 15]), !]).
step(covers_all(["00xx", "xx11"], [1, 3, 7, 11, 15]),
     rule(67),
     ['Primes' = ["00xx", "xx11"], 'T' = 1, 'Targets' = [3, 7, 11, 15]],
     [prime_covers_any(["00xx", "xx11"], 1), covers_all(["00xx", "xx11"], [3, 7, 11, 15])]).
step(prime_covers_any(["00xx", "xx11"], 1),
     rule(58),
     ['Primes' = ["00xx", "xx11"], 'Minterm' = 1, 'P' = "00xx"],
     [member("00xx", ["00xx", "xx11"]), covers_int("00xx", 1)]).
step(member("00xx", ["00xx", "xx11"]), builtin, [], []).
step(covers_int("00xx", 1),
     rule(45),
     ['Pat' = "00xx", 'Int' = 1, 'Bits' = "0001"],
     [int_to_bits(1, "0001"), covers("00xx", "0001")]).
step(int_to_bits(1, "0001"),
     rule(39),
     ['N' = 1, 'Bits' = "0001", 'W' = 4],
     [width(4), format_bits(1, 4, "0001")]).
step(width(4), fact(10), [], []).
step(format_bits(1, 4, "0001"),
     rule(41),
     ['N' = 1, 'W' = 4, 'B' = '0', 'Rest' = "001", 'W1' = 3, 'Val' = 0, 'NRem' = 1],
     [4 > 0,
      3 is 4 - 1,
      0 is 1 >> 3 /\ 1,
      (0 = 1 -> '0' = '1' ; '0' = '0'),
      1 is 1 - 0 << 3,
      format_bits(1, 3, "001")]).
step(4 > 0, builtin, [], []).
step(3 is 4 - 1, builtin, [], []).
step(0 is 1 >> 3 /\ 1, builtin, [], []).
step((0 = 1 -> '0' = '1' ; '0' = '0'), builtin, [], []).
step(1 is 1 - 0 << 3, builtin, [], []).
step(format_bits(1, 3, "001"),
     rule(41),
     ['N' = 1, 'W' = 3, 'B' = '0', 'Rest' = "01", 'W1' = 2, 'Val' = 0, 'NRem' = 1],
     [3 > 0,
      2 is 3 - 1,
      0 is 1 >> 2 /\ 1,
      (0 = 1 -> '0' = '1' ; '0' = '0'),
      1 is 1 - 0 << 2,
      format_bits(1, 2, "01")]).
step(3 > 0, builtin, [], []).
step(2 is 3 - 1, builtin, [], []).
step(0 is 1 >> 2 /\ 1, builtin, [], []).
step(1 is 1 - 0 << 2, builtin, [], []).
step(format_bits(1, 2, "01"),
     rule(41),
     ['N' = 1, 'W' = 2, 'B' = '0', 'Rest' = "1", 'W1' = 1, 'Val' = 0, 'NRem' = 1],
     [2 > 0,
      1 is 2 - 1,
      0 is 1 >> 1 /\ 1,
      (0 = 1 -> '0' = '1' ; '0' = '0'),
      1 is 1 - 0 << 1,
      format_bits(1, 1, "1")]).
step(2 > 0, builtin, [], []).
step(1 is 2 - 1, builtin, [], []).
step(0 is 1 >> 1 /\ 1, builtin, [], []).
step(1 is 1 - 0 << 1, builtin, [], []).
step(format_bits(1, 1, "1"),
     rule(41),
     ['N' = 1, 'W' = 1, 'B' = '1', 'Rest' = [], 'W1' = 0, 'Val' = 1, 'NRem' = 0],
     [1 > 0,
      0 is 1 - 1,
      1 is 1 >> 0 /\ 1,
      (1 = 1 -> '1' = '1' ; '1' = '0'),
      0 is 1 - 1 << 0,
      format_bits(0, 0, [])]).
step(1 > 0, builtin, [], []).
step(0 is 1 - 1, builtin, [], []).
step(1 is 1 >> 0 /\ 1, builtin, [], []).
step((1 = 1 -> '1' = '1' ; '1' = '0'), builtin, [], []).
step(0 is 1 - 1 << 0, builtin, [], []).
step(format_bits(0, 0, []), rule(40), [], "!").
step(covers("00xx", "0001"),
     rule(44),
     ['B' = '0', 'Ps' = "0xx", 'Bs' = "001"],
     ['0' \= x, covers("0xx", "001")]).
step('0' \= x, builtin, [], []).
step(covers("0xx", "001"),
     rule(44),
     ['B' = '0', 'Ps' = "xx", 'Bs' = "01"],
     ['0' \= x, covers("xx", "01")]).
step(covers("xx", "01"), rule(43), ['Ps' = "x", 'Bs' = "1"], [covers("x", "1")]).
step(covers("x", "1"), rule(43), ['Ps' = [], 'Bs' = []], [covers([], [])]).
step(covers([], []), fact(42), [], []).
step(covers_all(["00xx", "xx11"], [3, 7, 11, 15]),
     rule(67),
     ['Primes' = ["00xx", "xx11"], 'T' = 3, 'Targets' = [7, 11, 15]],
     [prime_covers_any(["00xx", "xx11"], 3), covers_all(["00xx", "xx11"], [7, 11, 15])]).
step(prime_covers_any(["00xx", "xx11"], 3),
     rule(58),
     ['Primes' = ["00xx", "xx11"], 'Minterm' = 3, 'P' = "00xx"],
     [member("00xx", ["00xx", "xx11"]), covers_int("00xx", 3)]).
step(covers_int("00xx", 3),
     rule(45),
     ['Pat' = "00xx", 'Int' = 3, 'Bits' = "0011"],
     [int_to_bits(3, "0011"), covers("00xx", "0011")]).
step(int_to_bits(3, "0011"),
     rule(39),
     ['N' = 3, 'Bits' = "0011", 'W' = 4],
     [width(4), format_bits(3, 4, "0011")]).
step(format_bits(3, 4, "0011"),
     rule(41),
     ['N' = 3, 'W' = 4, 'B' = '0', 'Rest' = "011", 'W1' = 3, 'Val' = 0, 'NRem' = 3],
     [4 > 0,
      3 is 4 - 1,
      0 is 3 >> 3 /\ 1,
      (0 = 1 -> '0' = '1' ; '0' = '0'),
      3 is 3 - 0 << 3,
      format_bits(3, 3, "011")]).
step(0 is 3 >> 3 /\ 1, builtin, [], []).
step(3 is 3 - 0 << 3, builtin, [], []).
step(format_bits(3, 3, "011"),
     rule(41),
     ['N' = 3, 'W' = 3, 'B' = '0', 'Rest' = "11", 'W1' = 2, 'Val' = 0, 'NRem' = 3],
     [3 > 0,
      2 is 3 - 1,
      0 is 3 >> 2 /\ 1,
      (0 = 1 -> '0' = '1' ; '0' = '0'),
      3 is 3 - 0 << 2,
      format_bits(3, 2, "11")]).
step(0 is 3 >> 2 /\ 1, builtin, [], []).
step(3 is 3 - 0 << 2, builtin, [], []).
step(format_bits(3, 2, "11"),
     rule(41),
     ['N' = 3, 'W' = 2, 'B' = '1', 'Rest' = "1", 'W1' = 1, 'Val' = 1, 'NRem' = 1],
     [2 > 0,
      1 is 2 - 1,
      1 is 3 >> 1 /\ 1,
      (1 = 1 -> '1' = '1' ; '1' = '0'),
      1 is 3 - 1 << 1,
      format_bits(1, 1, "1")]).
step(1 is 3 >> 1 /\ 1, builtin, [], []).
step(1 is 3 - 1 << 1, builtin, [], []).
step(covers("00xx", "0011"),
     rule(44),
     ['B' = '0', 'Ps' = "0xx", 'Bs' = "011"],
     ['0' \= x, covers("0xx", "011")]).
step(covers("0xx", "011"),
     rule(44),
     ['B' = '0', 'Ps' = "xx", 'Bs' = "11"],
     ['0' \= x, covers("xx", "11")]).
step(covers("xx", "11"), rule(43), ['Ps' = "x", 'Bs' = "1"], [covers("x", "1")]).
step(covers_all(["00xx", "xx11"], [7, 11, 15]),
     rule(67),
     ['Primes' = ["00xx", "xx11"], 'T' = 7, 'Targets' = [11, 15]],
     [prime_covers_any(["00xx", "xx11"], 7), covers_all(["00xx", "xx11"], [11, 15])]).
step(prime_covers_any(["00xx", "xx11"], 7),
     rule(58),
     ['Primes' = ["00xx", "xx11"], 'Minterm' = 7, 'P' = "xx11"],
     [member("xx11", ["00xx", "xx11"]), covers_int("xx11", 7)]).
step(member("xx11", ["00xx", "xx11"]), builtin, [], []).
step(covers_int("xx11", 7),
     rule(45),
     ['Pat' = "xx11", 'Int' = 7, 'Bits' = "0111"],
     [int_to_bits(7, "0111"), covers("xx11", "0111")]).
step(int_to_bits(7, "0111"),
     rule(39),
     ['N' = 7, 'Bits' = "0111", 'W' = 4],
     [width(4), format_bits(7, 4, "0111")]).
step(format_bits(7, 4, "0111"),
     rule(41),
     ['N' = 7, 'W' = 4, 'B' = '0', 'Rest' = "111", 'W1' = 3, 'Val' = 0, 'NRem' = 7],
     [4 > 0,
      3 is 4 - 1,
      0 is 7 >> 3 /\ 1,
      (0 = 1 -> '0' = '1' ; '0' = '0'),
      7 is 7 - 0 << 3,
      format_bits(7, 3, "111")]).
step(0 is 7 >> 3 /\ 1, builtin, [], []).
step(7 is 7 - 0 << 3, builtin, [], []).
step(format_bits(7, 3, "111"),
     rule(41),
     ['N' = 7, 'W' = 3, 'B' = '1', 'Rest' = "11", 'W1' = 2, 'Val' = 1, 'NRem' = 3],
     [3 > 0,
      2 is 3 - 1,
      1 is 7 >> 2 /\ 1,
      (1 = 1 -> '1' = '1' ; '1' = '0'),
      3 is 7 - 1 << 2,
      format_bits(3, 2, "11")]).
step(1 is 7 >> 2 /\ 1, builtin, [], []).
step(3 is 7 - 1 << 2, builtin, [], []).
step(covers("xx11", "0111"), rule(43), ['Ps' = "x11", 'Bs' = "111"], [covers("x11", "111")]).
step(covers("x11", "111"), rule(43), ['Ps' = "11", 'Bs' = "11"], [covers("11", "11")]).
step(covers("11", "11"),
     rule(44),
     ['B' = '1', 'Ps' = "1", 'Bs' = "1"],
     ['1' \= x, covers("1", "1")]).
step('1' \= x, builtin, [], []).
step(covers("1", "1"), rule(44), ['B' = '1', 'Ps' = [], 'Bs' = []], ['1' \= x, covers([], [])]).
step(covers_all(["00xx", "xx11"], [11, 15]),
     rule(67),
     ['Primes' = ["00xx", "xx11"], 'T' = 11, 'Targets' = [15]],
     [prime_covers_any(["00xx", "xx11"], 11), covers_all(["00xx", "xx11"], [15])]).
step(prime_covers_any(["00xx", "xx11"], 11),
     rule(58),
     ['Primes' = ["00xx", "xx11"], 'Minterm' = 11, 'P' = "xx11"],
     [member("xx11", ["00xx", "xx11"]), covers_int("xx11", 11)]).
step(covers_int("xx11", 11),
     rule(45),
     ['Pat' = "xx11", 'Int' = 11, 'Bits' = "1011"],
     [int_to_bits(11, "1011"), covers("xx11", "1011")]).
step(int_to_bits(11, "1011"),
     rule(39),
     ['N' = 11, 'Bits' = "1011", 'W' = 4],
     [width(4), format_bits(11, 4, "1011")]).
step(format_bits(11, 4, "1011"),
     rule(41),
     ['N' = 11, 'W' = 4, 'B' = '1', 'Rest' = "011", 'W1' = 3, 'Val' = 1, 'NRem' = 3],
     [4 > 0,
      3 is 4 - 1,
      1 is 11 >> 3 /\ 1,
      (1 = 1 -> '1' = '1' ; '1' = '0'),
      3 is 11 - 1 << 3,
      format_bits(3, 3, "011")]).
step(1 is 11 >> 3 /\ 1, builtin, [], []).
step(3 is 11 - 1 << 3, builtin, [], []).
step(covers("xx11", "1011"), rule(43), ['Ps' = "x11", 'Bs' = "011"], [covers("x11", "011")]).
step(covers("x11", "011"), rule(43), ['Ps' = "11", 'Bs' = "11"], [covers("11", "11")]).
step(covers_all(["00xx", "xx11"], [15]),
     rule(67),
     ['Primes' = ["00xx", "xx11"], 'T' = 15, 'Targets' = []],
     [prime_covers_any(["00xx", "xx11"], 15), covers_all(["00xx", "xx11"], [])]).
step(prime_covers_any(["00xx", "xx11"], 15),
     rule(58),
     ['Primes' = ["00xx", "xx11"], 'Minterm' = 15, 'P' = "xx11"],
     [member("xx11", ["00xx", "xx11"]), covers_int("xx11", 15)]).
step(covers_int("xx11", 15),
     rule(45),
     ['Pat' = "xx11", 'Int' = 15, 'Bits' = "1111"],
     [int_to_bits(15, "1111"), covers("xx11", "1111")]).
step(int_to_bits(15, "1111"),
     rule(39),
     ['N' = 15, 'Bits' = "1111", 'W' = 4],
     [width(4), format_bits(15, 4, "1111")]).
step(format_bits(15, 4, "1111"),
     rule(41),
     ['N' = 15, 'W' = 4, 'B' = '1', 'Rest' = "111", 'W1' = 3, 'Val' = 1, 'NRem' = 7],
     [4 > 0,
      3 is 4 - 1,
      1 is 15 >> 3 /\ 1,
      (1 = 1 -> '1' = '1' ; '1' = '0'),
      7 is 15 - 1 << 3,
      format_bits(7, 3, "111")]).
step(1 is 15 >> 3 /\ 1, builtin, [], []).
step(7 is 15 - 1 << 3, builtin, [], []).
step(covers("xx11", "1111"), rule(43), ['Ps' = "x11", 'Bs' = "111"], [covers("x11", "111")]).
step(covers_all(["00xx", "xx11"], []), fact(66), [], []).
step(check(2, 'Safety Check (No false positives outside DCs)', true),
     rule(15),
     ['Status' = true, 'Cover' = ["00xx", "xx11"], 'Zeros' = [4, 6, 8, 9, 10, 12, 13, 14]],
     [get_results(["00xx", "0xx1", "xx11"], ["00xx", "xx11"]),
      findall(Z, is_true_zero(Z), [4, 6, 8, 9, 10, 12, 13, 14]),
      safety_status(["00xx", "xx11"], [4, 6, 8, 9, 10, 12, 13, 14], true)]).
step(findall(Z, is_true_zero(Z), [4, 6, 8, 9, 10, 12, 13, 14]), collected, [], []).
step(safety_status(["00xx", "xx11"], [4, 6, 8, 9, 10, 12, 13, 14], true),
     rule(21),
     ['Cover' = ["00xx", "xx11"], 'Zeros' = [4, 6, 8, 9, 10, 12, 13, 14]],
     [zeros_safe(["00xx", "xx11"], [4, 6, 8, 9, 10, 12, 13, 14]), !]).
step(zeros_safe(["00xx", "xx11"], [4, 6, 8, 9, 10, 12, 13, 14]),
     rule(70),
     ['Cover' = ["00xx", "xx11"], 'Z' = 4, 'Zeros' = [6, 8, 9, 10, 12, 13, 14]],
     [no_prime_covers(["00xx", "xx11"], 4),
      zeros_safe(["00xx", "xx11"], [6, 8, 9, 10, 12, 13, 14])]).
step(no_prime_covers(["00xx", "xx11"], 4),
     rule(72),
     ['P' = "00xx", 'Ps' = ["xx11"], 'Value' = 4],
     [\+ covers_int("00xx", 4), no_prime_covers(["xx11"], 4)]).
step(\+ covers_int("00xx", 4), absent, [], []).
step(no_prime_covers(["xx11"], 4),
     rule(72),
     ['P' = "xx11", 'Ps' = [], 'Value' = 4],
     [\+ covers_int("xx11", 4), no_prime_covers([], 4)]).
step(\+ covers_int("xx11", 4), absent, [], []).
step(no_prime_covers([], 4), fact(71), [], []).
step(zeros_safe(["00xx", "xx11"], [6, 8, 9, 10, 12, 13, 14]),
     rule(70),
     ['Cover' = ["00xx", "xx11"], 'Z' = 6, 'Zeros' = [8, 9, 10, 12, 13, 14]],
     [no_prime_covers(["00xx", "xx11"], 6),
      zeros_safe(["00xx", "xx11"], [8, 9, 10, 12, 13, 14])]).
step(no_prime_covers(["00xx", "xx11"], 6),
     rule(72),
     ['P' = "00xx", 'Ps' = ["xx11"], 'Value' = 6],
     [\+ covers_int("00xx", 6), no_prime_covers(["xx11"], 6)]).
step(\+ covers_int("00xx", 6), absent, [], []).
step(no_prime_covers(["xx11"], 6),
     rule(72),
     ['P' = "xx11", 'Ps' = [], 'Value' = 6],
     [\+ covers_int("xx11", 6), no_prime_covers([], 6)]).
step(\+ covers_int("xx11", 6), absent, [], []).
step(no_prime_covers([], 6), fact(71), [], []).
step(zeros_safe(["00xx", "xx11"], [8, 9, 10, 12, 13, 14]),
     rule(70),
     ['Cover' = ["00xx", "xx11"], 'Z' = 8, 'Zeros' = [9, 10, 12, 13, 14]],
     [no_prime_covers(["00xx", "xx11"], 8), zeros_safe(["00xx", "xx11"], [9, 10, 12, 13, 14])]).
step(no_prime_covers(["00xx", "xx11"], 8),
     rule(72),
     ['P' = "00xx", 'Ps' = ["xx11"], 'Value' = 8],
     [\+ covers_int("00xx", 8), no_prime_covers(["xx11"], 8)]).
step(\+ covers_int("00xx", 8), absent, [], []).
step(no_prime_covers(["xx11"], 8),
     rule(72),
     ['P' = "xx11", 'Ps' = [], 'Value' = 8],
     [\+ covers_int("xx11", 8), no_prime_covers([], 8)]).
step(\+ covers_int("xx11", 8), absent, [], []).
step(no_prime_covers([], 8), fact(71), [], []).
step(zeros_safe(["00xx", "xx11"], [9, 10, 12, 13, 14]),
     rule(70),
     ['Cover' = ["00xx", "xx11"], 'Z' = 9, 'Zeros' = [10, 12, 13, 14]],
     [no_prime_covers(["00xx", "xx11"], 9), zeros_safe(["00xx", "xx11"], [10, 12, 13, 14])]).
step(no_prime_covers(["00xx", "xx11"], 9),
     rule(72),
     ['P' = "00xx", 'Ps' = ["xx11"], 'Value' = 9],
     [\+ covers_int("00xx", 9), no_prime_covers(["xx11"], 9)]).
step(\+ covers_int("00xx", 9), absent, [], []).
step(no_prime_covers(["xx11"], 9),
     rule(72),
     ['P' = "xx11", 'Ps' = [], 'Value' = 9],
     [\+ covers_int("xx11", 9), no_prime_covers([], 9)]).
step(\+ covers_int("xx11", 9), absent, [], []).
step(no_prime_covers([], 9), fact(71), [], []).
step(zeros_safe(["00xx", "xx11"], [10, 12, 13, 14]),
     rule(70),
     ['Cover' = ["00xx", "xx11"], 'Z' = 10, 'Zeros' = [12, 13, 14]],
     [no_prime_covers(["00xx", "xx11"], 10), zeros_safe(["00xx", "xx11"], [12, 13, 14])]).
step(no_prime_covers(["00xx", "xx11"], 10),
     rule(72),
     ['P' = "00xx", 'Ps' = ["xx11"], 'Value' = 10],
     [\+ covers_int("00xx", 10), no_prime_covers(["xx11"], 10)]).
step(\+ covers_int("00xx", 10), absent, [], []).
step(no_prime_covers(["xx11"], 10),
     rule(72),
     ['P' = "xx11", 'Ps' = [], 'Value' = 10],
     [\+ covers_int("xx11", 10), no_prime_covers([], 10)]).
step(\+ covers_int("xx11", 10), absent, [], []).
step(no_prime_covers([], 10), fact(71), [], []).
step(zeros_safe(["00xx", "xx11"], [12, 13, 14]),
     rule(70),
     ['Cover' = ["00xx", "xx11"], 'Z' = 12, 'Zeros' = [13, 14]],
     [no_prime_covers(["00xx", "xx11"], 12), zeros_safe(["00xx", "xx11"], [13, 14])]).
step(no_prime_covers(["00xx", "xx11"], 12),
     rule(72),
     ['P' = "00xx", 'Ps' = ["xx11"], 'Value' = 12],
     [\+ covers_int("00xx", 12), no_prime_covers(["xx11"], 12)]).
step(\+ covers_int("00xx", 12), absent, [], []).
step(no_prime_covers(["xx11"], 12),
     rule(72),
     ['P' = "xx11", 'Ps' = [], 'Value' = 12],
     [\+ covers_int("xx11", 12), no_prime_covers([], 12)]).
step(\+ covers_int("xx11", 12), absent, [], []).
step(no_prime_covers([], 12), fact(71), [], []).
step(zeros_safe(["00xx", "xx11"], [13, 14]),
     rule(70),
     ['Cover' = ["00xx", "xx11"], 'Z' = 13, 'Zeros' = [14]],
     [no_prime_covers(["00xx", "xx11"], 13), zeros_safe(["00xx", "xx11"], [14])]).
step(no_prime_covers(["00xx", "xx11"], 13),
     rule(72),
     ['P' = "00xx", 'Ps' = ["xx11"], 'Value' = 13],
     [\+ covers_int("00xx", 13), no_prime_covers(["xx11"], 13)]).
step(\+ covers_int("00xx", 13), absent, [], []).
step(no_prime_covers(["xx11"], 13),
     rule(72),
     ['P' = "xx11", 'Ps' = [], 'Value' = 13],
     [\+ covers_int("xx11", 13), no_prime_covers([], 13)]).
step(\+ covers_int("xx11", 13), absent, [], []).
step(no_prime_covers([], 13), fact(71), [], []).
step(zeros_safe(["00xx", "xx11"], [14]),
     rule(70),
     ['Cover' = ["00xx", "xx11"], 'Z' = 14, 'Zeros' = []],
     [no_prime_covers(["00xx", "xx11"], 14), zeros_safe(["00xx", "xx11"], [])]).
step(no_prime_covers(["00xx", "xx11"], 14),
     rule(72),
     ['P' = "00xx", 'Ps' = ["xx11"], 'Value' = 14],
     [\+ covers_int("00xx", 14), no_prime_covers(["xx11"], 14)]).
step(\+ covers_int("00xx", 14), absent, [], []).
step(no_prime_covers(["xx11"], 14),
     rule(72),
     ['P' = "xx11", 'Ps' = [], 'Value' = 14],
     [\+ covers_int("xx11", 14), no_prime_covers([], 14)]).
step(\+ covers_int("xx11", 14), absent, [], []).
step(no_prime_covers([], 14), fact(71), [], []).
step(zeros_safe(["00xx", "xx11"], []), fact(69), [], []).
step(check(3, 'Minimality (Cardinality) Proof', true),
     rule(16),
     ['Status' = true,
      'Primes' = ["00xx", "0xx1", "xx11"],
      'Cover' = ["00xx", "xx11"],
      'Size' = 2,
      'Limit' = 1,
      'Minterms' = [1, 3, 7, 11, 15]],
     [get_results(["00xx", "0xx1", "xx11"], ["00xx", "xx11"]),
      length_list(["00xx", "xx11"], 2),
      1 is 2 - 1,
      findall(M, minterm(M), [1, 3, 7, 11, 15]),
      minimality_status(["00xx", "0xx1", "xx11"], [1, 3, 7, 11, 15], 1, true)]).
step(length_list(["00xx", "xx11"], 2),
     rule(34),
     ['T' = ["xx11"], 'N' = 2, 'N1' = 1],
     [length_list(["xx11"], 1), 2 is 1 + 1]).
step(length_list(["xx11"], 1),
     rule(34),
     ['T' = [], 'N' = 1, 'N1' = 0],
     [length_list([], 0), 1 is 0 + 1]).
step(length_list([], 0), fact(33), [], []).
step(1 is 0 + 1, builtin, [], []).
step(2 is 1 + 1, builtin, [], []).
step(minimality_status(["00xx", "0xx1", "xx11"], [1, 3, 7, 11, 15], 1, true), fact(24), [], []).
step(check(4, 'Canonical Tie-Breaking (Lexicographical First)', true),
     rule(17),
     ['Status' = true,
      'Primes' = ["00xx", "0xx1", "xx11"],
      'Cover' = ["00xx", "xx11"],
      'Size' = 2,
      'Minterms' = [1, 3, 7, 11, 15],
      'Alternatives' = [["00xx", "xx11"], ["00xx", "xx11"], ["0xx1", "xx11"], ["0xx1", "xx11"], ["0xx1", "xx11"], ["0xx1", "xx11"]],
      'Best' = ["00xx", "xx11"]],
     [get_results(["00xx", "0xx1", "xx11"], ["00xx", "xx11"]),
      length_list(["00xx", "xx11"], 2),
      findall(M, minterm(M), [1, 3, 7, 11, 15]),
      findall(C, (find_combination(2, ["00xx", "0xx1", "xx11"], C), covers_all(C, [1, 3, 7, 11, 15])), [["00xx", "xx11"], ["00xx", "xx11"], ["0xx1", "xx11"], ["0xx1", "xx11"], ["0xx1", "xx11"], ["0xx1", "xx11"]]),
      sort([["00xx", "xx11"], ["00xx", "xx11"], ["0xx1", "xx11"], ["0xx1", "xx11"], ["0xx1", "xx11"], ["0xx1", "xx11"]], [["00xx", "xx11"], ["0xx1", "xx11"]]),
      equality_status(["00xx", "xx11"], ["00xx", "xx11"], true)]).
step(findall(C, (find_combination(2, ["00xx", "0xx1", "xx11"], C), covers_all(C, [1, 3, 7, 11, 15])), [["00xx", "xx11"], ["00xx", "xx11"], ["0xx1", "xx11"], ["0xx1", "xx11"], ["0xx1", "xx11"], ["0xx1", "xx11"]]),
     collected,
     [],
     []).
step(sort([["00xx", "xx11"], ["00xx", "xx11"], ["0xx1", "xx11"], ["0xx1", "xx11"], ["0xx1", "xx11"], ["0xx1", "xx11"]], [["00xx", "xx11"], ["0xx1", "xx11"]]),
     builtin,
     [],
     []).
step(equality_status(["00xx", "xx11"], ["00xx", "xx11"], true),
     rule(25),
     ['X' = ["00xx", "xx11"]],
     "!").
step(check(5, 'Consistency (Solution is subset of Primes)', true),
     rule(18),
     ['Status' = true, 'Primes' = ["00xx", "0xx1", "xx11"], 'Cover' = ["00xx", "xx11"]],
     [get_results(["00xx", "0xx1", "xx11"], ["00xx", "xx11"]),
      subset_status(["00xx", "xx11"], ["00xx", "0xx1", "xx11"], true)]).
step(subset_status(["00xx", "xx11"], ["00xx", "0xx1", "xx11"], true),
     rule(27),
     ['Subset' = ["00xx", "xx11"], 'Set' = ["00xx", "0xx1", "xx11"]],
     [is_subset(["00xx", "xx11"], ["00xx", "0xx1", "xx11"]), !]).
step(is_subset(["00xx", "xx11"], ["00xx", "0xx1", "xx11"]),
     rule(38),
     ['H' = "00xx", 'T' = ["xx11"], 'List' = ["00xx", "0xx1", "xx11"]],
     [member("00xx", ["00xx", "0xx1", "xx11"]), is_subset(["xx11"], ["00xx", "0xx1", "xx11"])]).
step(member("00xx", ["00xx", "0xx1", "xx11"]), builtin, [], []).
step(is_subset(["xx11"], ["00xx", "0xx1", "xx11"]),
     rule(38),
     ['H' = "xx11", 'T' = [], 'List' = ["00xx", "0xx1", "xx11"]],
     [member("xx11", ["00xx", "0xx1", "xx11"]), is_subset([], ["00xx", "0xx1", "xx11"])]).
step(member("xx11", ["00xx", "0xx1", "xx11"]), builtin, [], []).
step(is_subset([], ["00xx", "0xx1", "xx11"]), fact(37), [], []).
